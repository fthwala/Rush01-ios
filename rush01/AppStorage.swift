//
//  AppStorage.swift
//  D05
//
//  Created by Thamsanca MNUNE on 2018/10/08.
//  Copyright © 2018 Thamsanca MNUNE. All rights reserved.
//

import Foundation
import MapKit

// Data Structs

struct Place {
    let name    : String
    let subtitle : String
    let lat     : Double
    let long    : Double
    let color   : UIColor
    
    static var places : [Place] = [
        Place(name: "WeThinkCode_", subtitle: "Programming School", lat: -26.204881, long: 28.040324, color: UIColor.blue),
        Place(name: "42", subtitle: "Coding School", lat: 48.896679, long: 2.318765, color: UIColor.black),
        Place(name: "Derivco", subtitle: "Software Dev Company", lat: -29.746513, long: 31.068199, color: UIColor.lightGray),
        Place(name: "Rosebank Mall", subtitle: "Shopping Mall", lat: -26.145044, long: 28.042560, color: UIColor.gray),
        Place(name: "NMMU George", subtitle: "University", lat: -33.960366, long: 22.534870, color: UIColor.purple)]
    
    
    
    // Mutables
    static var selectedPlace = Place.places[0]
    static var destinationPlace = Place.places[0]
}

class MapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(title: String, subtitle: String, location: CLLocationCoordinate2D) {
        self.coordinate = location
        self.title = title
        self.subtitle = subtitle
    }
    
}


