//
//  Destination.swift
//  LearningMapKit
//
//  Created by Rommel Rico on 10/18/17.
//  Copyright © 2017 Rommel Rico. All rights reserved.
//

import Foundation
import MapKit

class Destination {
    
    let coordinate: CLLocationCoordinate2D
    private var addressDictionary: [String: AnyObject]
    let name: String
    
    init(withName placeName: String,
         latitude: CLLocationDegrees,
         longitude: CLLocationDegrees,
         address: [String: AnyObject]) {
        name = placeName
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        addressDictionary = address
    }
    
    var mapItem: MKMapItem {
        get {
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
            let item = MKMapItem(placemark: placemark)
            return item
        }
    }

}
