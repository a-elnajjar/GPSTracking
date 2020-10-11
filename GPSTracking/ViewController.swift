//
//  ViewController.swift
//  GPSTracking
//
//  Created by Abdalla.Mohamed on 2016-02-08.
//  Copyright © 2016 Abdalla.Mohamed. All rights reserved.
//


import CoreLocation
import MapKit
import UIKit

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager =  CLLocationManager()
    
    var userLocations:[CLLocation] = []

    @IBOutlet weak var lblCurrentLocation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //setup coreLocation manager 
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
       
        
        //setup map
        mapView.delegate = self;
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        
        lblCurrentLocation.text = "\(locations[0])"
        userLocations.append(locations[0] as CLLocation)
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegin  = MKCoordinateRegion(center: mapView.userLocation.coordinate, span:MKCoordinateSpan(latitudeDelta: spanX, longitudeDelta: spanY))
        mapView.setRegion(newRegin, animated: true)
        
        if (userLocations.count > 1){
            let sourceIndex = userLocations.count - 1
            let destinationIndex = userLocations.count - 2
            
            let c1 = userLocations[sourceIndex].coordinate
            let c2 = userLocations[destinationIndex].coordinate
            
            var a=[c1, c2]
            let polyline = MKPolyline(coordinates: &a, count:a.count)
            mapView.addOverlay(polyline)
            
            
        }
        
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getMyLocation(sender: AnyObject) {
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        self.lblCurrentLocation.text = "locations = \(locValue.latitude) \(locValue.longitude)"

       
    }

    @IBAction func startTracking(sender: AnyObject) {
        locationManager.startUpdatingLocation()

    }
    
    @IBAction func endTracking(sender: AnyObject) {
         locationManager.stopUpdatingLocation()
    }
}

