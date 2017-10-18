//
//  DestinationTableViewCell.swift
//  LearningMapKit
//
//  Created by Rommel Rico on 10/18/17.
//  Copyright © 2017 Rommel Rico. All rights reserved.
//

import UIKit
import MapKit

class DestinationTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var destination: Destination? {
        didSet {
            nameLabel.text = destination!.name
        }
    }
    
    var userCoordinate: CLLocationCoordinate2D? {
        didSet {
            etaLabel.text = ""
            departureTimeLabel.text = "Departure Time:"
            arrivalTimeLabel.text = "Arrival Time:"
            distanceLabel.text = "Distance:"
            
            guard let coordinate = userCoordinate else { return }
            
            let request = MKDirectionsRequest()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
            request.destination = destination!.mapItem
            request.transportType = .transit
            
            let directions = MKDirections(request: request)
            directions.calculateETA { (response: MKETAResponse?, error: Error?) in
                if let error = error {
                    self.etaLabel.text = error.localizedDescription
                    return
                }
                
                let nf = NumberFormatter()
                nf.numberStyle = .decimal
                nf.maximumFractionDigits = 0
                
                self.etaLabel.text = "\(nf.string(from: NSNumber(floatLiteral: response!.expectedTravelTime/60))!) minutes travel time"
                self.departureTimeLabel.text = "Departure Time: \(response!.expectedDepartureDate)"
                self.arrivalTimeLabel.text = "Arrival Time: \(response!.expectedArrivalDate)"
                self.distanceLabel.text = "Distance: \(response!.distance) meters"
            }
        }
    }

    @IBAction func viewRouteTapped(_ sender: UIButton) {
        guard let mapDestination = destination else { return }
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeTransit]
        mapDestination.mapItem.openInMaps(launchOptions: launchOptions)
    }
}
