//
//  MapViewController.swift
//  PlayingTemps
//
//  Created by Nishant Punia on 24/05/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate {
    
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let locationRadius: CLLocationDistance = 1000
    
    let places = ["Unnamed Rd, Sector 14 Hisar, Haryana 125011","Kehri Gaon, Prem Nagar, Dehradun, Uttarakhand"]
    
    override func loadView() {
        
        mapView = MKMapView()
        view = mapView
        
        let standardString = NSLocalizedString("Standard", comment: "Standard Map View")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid Map View")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite Map View")
        
        let segementalControl = UISegmentedControl(items: [standardString,hybridString,satelliteString])
        segementalControl.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        segementalControl.selectedSegmentIndex = 0
        segementalControl.translatesAutoresizingMaskIntoConstraints = false
        segementalControl.addTarget(self, action: #selector(MapViewController.changingTypeOfMaps(_:)), forControlEvents: .ValueChanged)
        
        let margins = view.layoutMarginsGuide
        let topConstraint = segementalControl.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: 8)
        let leadingConstraint = segementalControl.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        let trailingConstraint = segementalControl.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        view.addSubview(segementalControl)
        
        topConstraint.active = true
        leadingConstraint.active = true
        trailingConstraint.active = true
        
        let zoomButtonTitle = NSLocalizedString("UserLocation", comment: "Zoom Button Title")
        let zoomButton = UIButton()
        zoomButton.setTitle( (zoomButtonTitle), forState: .Normal)
        zoomButton.backgroundColor = UIColor.blackColor()
        zoomButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        zoomButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        zoomButton.translatesAutoresizingMaskIntoConstraints = false
        zoomButton.addTarget(self, action: #selector(MapViewController.zoomButtonTapped), forControlEvents: .TouchUpInside)
        
        let trailingConstraint1 = zoomButton.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        let bottomConstraint = zoomButton.bottomAnchor.constraintEqualToAnchor(margins.bottomAnchor,constant: -69.0)
        self.view.addSubview(zoomButton)
       
        trailingConstraint1.active = true
        bottomConstraint.active = true
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        for place in places {
            getPlaceMarkForPlaces(place)
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        permissionForUserLocation()
    }
    
    func changingTypeOfMaps(segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .Standard
        case 1:
            mapView.mapType = .Hybrid
        case 2:
            mapView.mapType = .Satellite
        default:
            break
        }
    }
    
    func permissionForUserLocation() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func zoomInOnUserLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, locationRadius * 2, locationRadius * 2)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    func zoomButtonTapped() {
        self.zoomInOnUserLocation(CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude))
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(PlaceAnnotations) {
            let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
            annoView.pinTintColor = UIColor.blackColor()
            annoView.animatesDrop = true
            annoView.canShowCallout = true
            return annoView
        } else if annotation.isKindOfClass(MKAnnotation) {
            return nil
        }
        return nil
    }
    
    func createAnnotationForPlaces(location: CLLocation) {
        
            let annotations = PlaceAnnotations(coordinate: location.coordinate)
            annotations.title = "Home/P.G."
            annotations.subtitle = "Hometown: Hisar,P.G.: Dehradun"
            mapView.addAnnotation(annotations)
    }
    
    func getPlaceMarkForPlaces(places: String) {
        CLGeocoder().geocodeAddressString(places) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if let marks = placemarks where marks.count > 0 {
                if let loc = marks[0].location {
                    self.createAnnotationForPlaces(loc)
                }
            }
        }
    }
    
    
}
