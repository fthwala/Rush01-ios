//
//  RouteViewController.swift
//  rush01
//
//  Created by Thamsanca MNUNE on 2018/10/13.
//  Copyright © 2018 Thamsanca MNUNE. All rights reserved.
//

import UIKit
import MapKit

class RouteViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var sourceField: UITextField!
    
    @IBOutlet weak var destinationField: UITextField!
    
    let directionRequest = MKDirectionsRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        directionRequest.transportType = .automobile
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        destinationField.text = Place.destinationPlace.name
//        sourceField.text = Place.selectedPlace.name
//    }
    
    @IBAction func setTransportMode(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            directionRequest.transportType = .automobile
        case 1:
            directionRequest.transportType = .transit
        case 2:
            directionRequest.transportType = .walking
        default:
            break
        }
        setSourcePlace()
    }
    
    @IBAction func setMapMode(_ sender: UISegmentedControl) {
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
    

    @IBAction func getRoute(_ sender: UIButton) {
        setSourcePlace()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        let colors = [UIColor.blue, UIColor.red, UIColor.yellow, UIColor.brown, UIColor.cyan, UIColor.lightGray, UIColor.black]
        renderer.strokeColor = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
    func setRoute(){
        let sourceLocation = CLLocationCoordinate2D(latitude: Place.selectedPlace.lat, longitude: Place.selectedPlace.long)
        
        let destinationLocation = CLLocationCoordinate2D(latitude: Place.destinationPlace.lat, longitude: Place.destinationPlace.long)
        
        mapView.addAnnotation(MapPin(title: Place.selectedPlace.name, subtitle: Place.selectedPlace.subtitle, location: sourceLocation))
        mapView.addAnnotation(MapPin(title: Place.destinationPlace.name, subtitle: Place.destinationPlace.subtitle, location: destinationLocation))
        
        let sourceMark = MKPlacemark(coordinate: sourceLocation)
        let destMark = MKPlacemark(coordinate: destinationLocation)
        
        directionRequest.source = MKMapItem(placemark: sourceMark)
        directionRequest.destination = MKMapItem(placemark: destMark)
        directionRequest.transportType = .automobile
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (response, error) in
            guard let directionResponse = response else {
                if let error = error {
                    let refreshAlert = UIAlertController(title: "Error", message: "Failed to calculate route. Places may be too far apart for autombile routing!", preferredStyle: UIAlertControllerStyle.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    print(error.localizedDescription)
                    UIApplication.shared.keyWindow?.rootViewController?.present(refreshAlert, animated: true, completion: nil)
                }
                return
            }
            
            let route = directionResponse.routes[0]
            self.mapView.add(route.polyline, level: .aboveRoads)

            let rect = route.polyline.boundingMapRect

            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    func setSourcePlace() {
        // Activity indicator
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        // Create Search request
        let searchRequest = MKLocalSearchRequest()
        
        let address = sourceField.text
        searchRequest.naturalLanguageQuery = address
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start {
            (res, err) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if res == nil {
                let refreshAlert = UIAlertController(title: "Error", message: "Failed to get Source location!", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                }))
                UIApplication.shared.keyWindow?.rootViewController?.present(refreshAlert, animated: true, completion: nil)
            } else {
                // Coordinates
                let lat = res?.boundingRegion.center.latitude
                let lng = res?.boundingRegion.center.longitude
                
                Place.selectedPlace = Place(name: address!, subtitle: "Source", lat: lat!, long: lng!, color: UIColor.green)
                Place.places.append(Place.selectedPlace)
                self.setDestinationPlace()
            }
        }
    }
    
    func setDestinationPlace() {
        // Activity indicator
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        // Create Search request
        let searchRequest = MKLocalSearchRequest()
        
        let address = destinationField.text
        
        searchRequest.naturalLanguageQuery = address
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start {
            (res, err) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if res == nil {
                let refreshAlert = UIAlertController(title: "Error", message: "Failed to get Destination location!", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                }))
                UIApplication.shared.keyWindow?.rootViewController?.present(refreshAlert, animated: true, completion: nil)
            } else {
                // Coordinates
                let lat = res?.boundingRegion.center.latitude
                let lng = res?.boundingRegion.center.longitude
                
                Place.destinationPlace = Place(name: address!, subtitle: "Destination", lat: lat!, long: lng!, color: UIColor.green)
                Place.places.append(Place.destinationPlace)
                
                self.setRoute()
            }
        }
    }
    
}
