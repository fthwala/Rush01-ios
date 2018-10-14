//
//  FirstViewController.swift
//  D05
//
//  Created by Thamsanca MNUNE on 2018/10/08.
//  Copyright © 2018 Thamsanca MNUNE. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FirstViewController: UIViewController, UISearchBarDelegate ,MKMapViewDelegate, CLLocationManagerDelegate {

    // Search button outlet
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    
    // Map view outlet
    @IBOutlet weak var mapView: MKMapView!
    
    // Location manager
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Map Setup
        let span : MKCoordinateSpan = MKCoordinateSpanMake(0.006, 0.006)
        let location : CLLocationCoordinate2D = CLLocationCoordinate2DMake(Place.selectedPlace.lat, Place.selectedPlace.long )
        let region : MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        // Manager set up
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.stopUpdatingLocation() // Stops manager if manager is updating
        
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(MapPin(title: Place.selectedPlace.name, subtitle: Place.selectedPlace.subtitle, location: location))
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor.green
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
    
    
    // ---------------------------- HANDLERS -----------------------------------
    
    // Map view handler
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.canShowCallout = true
        
        if annotation.title! != "My Location" {
            annotationView.pinTintColor = Place.selectedPlace.color
        } else {
            return nil;
        }

        return annotationView
    }
    
    // User Location handler
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let span = MKCoordinateSpanMake(0.006, 0.006)
            let userLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
            let region = MKCoordinateRegionMake(userLocation, span)
            mapView.removeAnnotations(mapView.annotations)
            mapView.setRegion(region, animated: true)
            
        }
        self.mapView.showsUserLocation = true
    }
    
    // Search handler
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Ignoring user activities
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Activity indicator
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        // Hide Search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        // Create Search request
        let searchRequest = MKLocalSearchRequest()
        
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start {
            (res, err) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if res == nil {
                
            } else {
                let pins = self.mapView.annotations
                
                self.mapView.removeAnnotations(pins)
                
                // Coordinates
                let lat = res?.boundingRegion.center.latitude
                let lng = res?.boundingRegion.center.longitude
                
                Place.destinationPlace = Place(name: searchBar.text!, subtitle: searchBar.text!, lat: lat!, long: lng!, color: UIColor.blue)
                
                self.mapView.addAnnotation(MapPin(title: searchBar.text!, subtitle: searchBar.text!, location: CLLocationCoordinate2D(latitude: lat!, longitude: lng!)))
                
                // Set Map reqion
                let region = MKCoordinateRegionMake(
                    CLLocationCoordinate2DMake(lat!, lng!),
                    MKCoordinateSpanMake(0.006, 0.006)
                )
                
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    // ----------------------- ACTIONS ----------------------------
    
    @IBAction func changeMapMode(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        
        switch index {
        case 0:
            mapView.mapType = MKMapType.standard
        case 1:
            mapView.mapType = MKMapType.satellite
        case 2:
            mapView.mapType = MKMapType.hybrid
        default:
            break
        }
    }
    
    @IBAction func getUserLocation(_ sender: UIButton) {
        manager.startUpdatingLocation()
    }
    
    @IBAction func searchPlace(_ sender: UIBarButtonItem) {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.delegate = self
        
        present(searchController, animated: true, completion: nil)
    }
    

}

