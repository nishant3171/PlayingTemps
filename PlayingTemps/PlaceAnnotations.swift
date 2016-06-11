//
//  PlaceAnnotations.swift
//  FunWithMaps
//
//  Created by nishant punia on 21/01/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import Foundation
import MapKit

class PlaceAnnotations: NSObject, MKAnnotation {
    
    var coordinate = CLLocationCoordinate2D()
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
    }
}
