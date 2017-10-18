//
//  ViewController.swift
//  LearningMapKit
//
//  Created by Rommel Rico on 10/18/17.
//  Copyright © 2017 Rommel Rico. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class ViewController: UIViewController {
    

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    var destinations: [Destination]
    var userAnnotation: MKPointAnnotation?
    var userCoordinate: CLLocationCoordinate2D?
    
    required init?(coder aDecoder: NSCoder) {
        let stPauls = Destination(
            withName: "St Paul's Cathedral",
            latitude: 51.5138244,
            longitude: -0.0983483,
            address: [
                CNPostalAddressStreetKey: "St. Paul's Churchyard" as AnyObject,
                CNPostalAddressCityKey: "London" as AnyObject,
                CNPostalAddressPostalCodeKey: "EC4M 8AD" as AnyObject,
                CNPostalAddressCountryKey: "England" as AnyObject
            ]
        )
        let towerBridge = Destination(
            withName: "Tower Bridge",
            latitude: 51.5054644,
            longitude: -0.0754688,
            address: [
                CNPostalAddressStreetKey: "Tower Bridge Rd" as AnyObject,
                CNPostalAddressCityKey: "London" as AnyObject,
                CNPostalAddressPostalCodeKey: "SE1 2UP" as AnyObject,
                CNPostalAddressCountryKey: "England" as AnyObject
            ]
        )
        let buckinghamPalace = Destination(
            withName: "Buckingham Palace",
            latitude: 51.5015639,
            longitude: -0.141328,
            address: [
                CNPostalAddressStreetKey: "Buckingham Palace" as AnyObject,
                CNPostalAddressCityKey: "London" as AnyObject,
                CNPostalAddressPostalCodeKey: "SW1A 1AA" as AnyObject,
                CNPostalAddressCountryKey: "England" as AnyObject
            ]
        )
        destinations = [stPauls, towerBridge, buckinghamPalace]
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(gestureRecognizer:)))
        mapView.addGestureRecognizer(tap)
        
        mapView.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: CLLocationDegrees(51.5074157),
                longitude: CLLocationDegrees(-0.1201011)),
            span: MKCoordinateSpan(
                latitudeDelta: CLLocationDegrees(0.025),
                longitudeDelta: CLLocationDegrees(0.025))
            )
        
        for destination in destinations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = destination.coordinate
            mapView.addAnnotation(annotation)
        }
        
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let point = gestureRecognizer.location(in: mapView)
        userCoordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        if let userAnnotation = userAnnotation {
            mapView.removeAnnotation(userAnnotation)
        }
        
        userAnnotation = MKPointAnnotation()
        userAnnotation?.coordinate = userCoordinate!
        mapView.addAnnotation(userAnnotation!)
        
        for cell in self.tableView.visibleCells as! [DestinationTableViewCell] {
            cell.userCoordinate = userCoordinate
        }
        
    }
    
}

// MARK: - UITableView Datasource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "destinationCell") as! DestinationTableViewCell
        cell.destination = destinations[indexPath.row]
        cell.userCoordinate = userCoordinate
        return cell
    }

}

// MARK: - MKMapViewDelegate

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pin.pinTintColor = annotation === userAnnotation ? UIColor.red : UIColor.blue
        return pin
    }
    
}
