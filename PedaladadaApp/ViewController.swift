//
//  ViewController.swift
//  PedaladadaApp
//
//  Created by Bruno on 23/07/16.
//  Copyright © 2016 Bruno. All rights reserved.
//

import UIKit
import ArcGIS


class ViewController: UIViewController, AGSMapViewLayerDelegate ,AGSLayerDelegate,  UITextFieldDelegate,CLLocationManagerDelegate{
    @IBOutlet weak var textField: UILabel!
    let kDefaultMap = "http://services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer"
  
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var mapView: AGSMapView!
    var startGraphic: AGSGraphic!
    var myGraphic:AGSGraphic!
    var locationssaved : [AGSPoint]!
    var startLocation: CLLocation!
    
    var graphicsLayer1 :AGSGraphicsLayer!
   // var startGraphic: AGSGraphic!
   
    var locationManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
     
        self.mapView.layerDelegate = self
    
        
        let mapUrl = NSURL(string: kDefaultMap)
        let tiledLyr = AGSTiledMapServiceLayer(URL: mapUrl)
        self.mapView.enableWrapAround()
        self.mapView.allowRotationByPinching = true
        self.mapView.addMapLayer(tiledLyr, withName:"Tiled Layer")
      
        // Do any additional setup after loading the view, typically from a nib.
        //Zooming to an initial envelope with the specified spatial reference of the
        graphicsLayer1 =  AGSGraphicsLayer()
    
    
        //initialize labels
        
        dispatch_async(dispatch_get_main_queue(), {
           
            self.textField.text = "Longitude: 0º Latitude: 0º"
             self.textField.sizeToFit()
           
            self.speed.text = "Speed: 0 m/s"
             self.speed.sizeToFit()
        })
        
        
        // Add location manager
        startLocation = nil
        self.mapView.addMapLayer(graphicsLayer1, withName:"Graphi Layer")
        locationManager = CLLocationManager()
        locationManager.delegate = self
     
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.allowsBackgroundLocationUpdates = true
        
        self.locationssaved = [AGSPoint]()
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        
        
        
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapViewDidLoad(mapView: AGSMapView!) {
        //do something now that the map is loaded
        //for example, show the current location on the map
        mapView.locationDisplay.startDataSource()
    
        self.mapView.locationDisplay.autoPanMode = .Default
        self.mapView.locationDisplay.wanderExtentFactor = 0.75
        

        
    }
   
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

         self.graphicsLayer1.refresh()
        //define the buoy locations
        let wgs84 = AGSSpatialReference.wgs84SpatialReference()
        let geometryEngine = AGSGeometryEngine()
        if manager.location?.speed > 1.0 {
        let newGeometry = geometryEngine.projectGeometry(AGSPoint(x:manager.location!.coordinate.longitude, y: manager.location!.coordinate.latitude, spatialReference: wgs84), toSpatialReference: self.mapView.spatialReference) as! AGSPoint
    
            
    
        //create marker symbol
        let color = UIColor(red: CGFloat(0.0), green: CGFloat(2.0), blue: CGFloat(0.0), alpha: CGFloat(1))
        let myMarkerSymbol = AGSSimpleMarkerSymbol ()
        myMarkerSymbol.color = color
        myMarkerSymbol.style = .Diamond
        myMarkerSymbol.outline.width = 5
        //create graphics
        startGraphic = AGSGraphic()
        startGraphic.geometry = newGeometry
        startGraphic.symbol = myMarkerSymbol
        
        self.graphicsLayer1.addGraphic(startGraphic)
        
        // add coordinates and speed to  text
        var long = manager.location?.coordinate.longitude
        var lati = manager.location?.coordinate.latitude
        long = Double(round(100*long!)/100)
        lati = Double(round(100*lati!)/100)
        var speeds = manager.location?.speed
        speeds = Double(round(100*speeds!)/100)
            
        dispatch_async(dispatch_get_main_queue(), {
                //perform all UI stuff her
                self.textField.text = "Longitude:\(long!)º Latitude:\(lati!)º"
                self.textField.textColor =  UIColor.greenColor()
                self.textField.sizeToFit()
            
                self.speed.text = "Speed: \(speeds!) m/s"
                self.speed.textColor =  UIColor.greenColor()
                self.speed.sizeToFit()
        })
        
            if UIApplication.sharedApplication().applicationState == .Active {
             print("Active")
            } else {
                     print("Longitude:\(long!)º Latitude:\(lati!)º")
            }
            
            
            
        //Find Distance ridden
            if startLocation == nil {
                startLocation = manager.location! as CLLocation
            }
            var distanceBetween: CLLocationDistance =
                manager.location!.distanceFromLocation(startLocation)
            
            let distance = String(format: "%.2f", distanceBetween)
            print("Distanc\(distance)")
            
        //1- add polyline
        
        let myPolyline = AGSMutablePolyline(spatialReference:self.mapView.spatialReference)
        //2-
        myPolyline.addPathToPolyline()
        
        
        self.locationssaved.append(AGSPoint(x: newGeometry.x, y: newGeometry.y, spatialReference: nil))
        //3-
        
          for result in self.locationssaved{
            myPolyline.addPointToPath(AGSPoint(x: result.x, y: result.y, spatialReference: nil))
        }
        //4-
        let myPolylineSymbol = AGSSimpleLineSymbol()
        //5-
        self.myGraphic = AGSGraphic(geometry: myPolyline, symbol: myPolylineSymbol, attributes:
            nil)
        }
        //6-
       // self.graphicsLayer1.addGraphic(myGraphic)
    
        //self.mapView.addMapLayer(graphicsLayer1, withName:"Graphi Layer")

        
        
    }
    
    
}

