//
//  ViewController.swift
//  PedaladadaApp
//
//  Created by Bruno on 23/07/16.
//  Copyright © 2016 Bruno. All rights reserved.
//

import UIKit
import ArcGIS

class ViewController: UIViewController,AGSMapViewLayerDelegate  {
    let kDefaultMap = "http://services.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer"
  
    @IBOutlet weak var mapView: AGSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let mapUrl = NSURL(string: kDefaultMap)
        let tiledLyr = AGSTiledMapServiceLayer(URL: mapUrl)
        self.mapView.addMapLayer(tiledLyr, withName:"Tiled Layer")
        // Do any additional setup after loading the view, typically from a nib.
        //Zooming to an initial envelope with the specified spatial reference of the map.
        //2. Set the map view's layer delegate
        self.mapView.layerDelegate = self
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

