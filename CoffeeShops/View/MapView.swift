//
//  MapView.swift
//  CoffeeShops
//
//  Created by Sujan Kanna on 3/24/20.
//  Copyright © 2020 CoffeeShops. All rights reserved.
//

import SwiftUI
import MapKit
import Combine

struct MapView: UIViewRepresentable {
    // @Binding is used to pass a value controlled and persisted by a parent view, and to invalidate the view when this values changes.
    // List of coffee shops for the current user location. Automatically updated through the updates in the VenuesViewModel dataSource.
    @Binding var venues: [CoffeeShop]
    
    // Whenever this value is updated the changes will be propagated to VenuesViewModel's currentLocation, which triggers a call to fetch new shops.
    @Binding var currentLocation: CLLocationCoordinate2D
    
    private let locationManager = CLLocationManager()
    private let mapView = MKMapView()
    
    /// Called once when a MapView object is created.
    func makeUIView(context: Context) -> MKMapView {
        setupLocationManager(context)
        
        mapView.delegate = context.coordinator
        mapView.userTrackingMode = .none
        mapView.showsUserLocation = true
        return mapView
    }
    
    /// Called automatically whenever new changes are detected in the venues array. Updates the map with new annotations.
    func updateUIView(_ view: MKMapView, context: Context) {
        updateAnnotations(in: view)
    }
    
    /// Required for handling the user interactions on the MapView through MKMapViewDelegate.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func setRegion(_ region: MKCoordinateRegion, animated: Bool) {
        mapView.setRegion(region, animated: animated)
    }
    
    private func setupLocationManager(_ context: Context) {
        locationManager.delegate = context.coordinator
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    private func updateAnnotations(in mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
        
        let newAnnotations = venues.map { VenueAnnotation(venue: $0) }
        mapView.addAnnotations(newAnnotations)
    }
}

final class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locations.isEmpty else { return }
        
        parent.currentLocation = locations[0].coordinate
        // Re-centers the map to the current user location
        recenter(mapView: parent, coordinate: parent.currentLocation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let venueAnnotation = annotation as? VenueAnnotation else { return nil }
        
        let identifier = "VenueAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: venueAnnotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.calloutOffset = CGPoint(x: -5, y: 5)
            
            // Tapping on the detail disclosure takes the user to the Maps app.
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            // clusteringIdentifier is used to cluster markers that are very close to each with a number marker. Zoom in to see the markers under that cluster.
            annotationView?.clusteringIdentifier = identifier
        } else {
            annotationView?.annotation = venueAnnotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let venue = view.annotation as? VenueAnnotation else { return }
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        venue.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    private func recenter(mapView: MapView, coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
