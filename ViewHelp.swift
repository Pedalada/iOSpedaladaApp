//
//  ViewHelp.swift
//  PedaladadaApp
//
//  Created by Bruno on 25/07/16.
//  Copyright © 2016 Bruno. All rights reserved.
//

import UIKit
import ArcGIS


class ViewHelp: UIViewController,AGSCalloutDelegate  {
    let kDefaultMap = "http://services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer"
    
    @IBOutlet weak var mapView: AGSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
      self.mapView.callout.delegate = self
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapViewDidLoad(mapView: AGSMapView!) {
        //do something now that the map is loaded
        //for example, show the current location on the map
        mapView.locationDisplay.startDataSource()
        
    }
    
    
    
}



