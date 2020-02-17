//
//  ViewController.swift
//  new
//
//  Created by Mac on 31/01/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleMaps
import MapKit
import CoreLocation
import CoreMotion
import Network

class CustomPolyline : MKPolyline {
    var color: UIColor?
}

class ViewController: UIViewController,GIDSignInDelegate,CLLocationManagerDelegate, MKMapViewDelegate{
  
    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var map4: MKMapView!
    var s = 49
    var r = 120
var txtflag = String()
    var textField = UITextField()
    var locationManager = CLLocationManager()
    @IBAction func addstop(_ sender: UIButton) {
        drive.isHidden = true
        walk.isHidden = true
   
         textField = UITextField(frame: CGRect(x: s, y: r, width: 289, height: 30))
        self.view.addSubview(textField)
        textField.backgroundColor = UIColor.red
       
        r = r+40
        textField.backgroundColor = UIColor.yellow
        txtflag = "1"
    }
   
    let monitor = NWPathMonitor()
    var lat11 = Double()
    var long1 = Double()
    var lat11end = Int()
    var long1end = Int()
    var arrayLatitude: [Double] = []
    var arrayLongitude: [Double] = []
    var array: [String] = []
    var address1: [String] = []
    var address2: [String] = []
    var flag = String()
     var walkflag = String()
  //  let locationManager = CLLocationManager()
    
    @IBOutlet weak var direction: UIButton!
    
   
    
    
    func networkConnection()
    {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
//                let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
//                    switch action.style{
//                    case .default:
//                        print("default")
//                        self.start()
//
//                    case .cancel:
//                        print("cancel")
//
//                    case .destructive:
//                        print("destructive")
//
//
//                    }}))
//                self.present(alert, animated: true, completion: nil)
                
              
                
                var refreshAlert = UIAlertController(title: "", message: "Please Check Internet Connection.", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action: UIAlertAction!) in
                    print("Handle Ok logic here")
                    
                    self.start()
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Setting", style: .cancel, handler: { (action: UIAlertAction!) in
                    print("Handle Cancel Logic here")
                    if #available(iOS 10.0, *) {
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                        }
                    }
                }))
                
                self.present(refreshAlert, animated: true, completion: nil)
            }
          
            print("Connection ,\(path.isExpensive)")
        }
    }
    @IBAction func swipebtn(_ sender: UIButton){
        start()
        let souce = startlocation.text!
        let destination = endlocation.text!
       startlocation.text = destination
        endlocation.text = souce
        flag = "1"
    }
     @IBOutlet weak var minlabel: UILabel!
      @IBOutlet weak var distance: UILabel!
      @IBOutlet weak var time1: UILabel!
       @IBOutlet weak var timeview: UIView!
    var position2 = CLLocationCoordinate2D()
      var position1 = CLLocationCoordinate2D()
    @IBOutlet weak var walk: UIButton!
  //  var receivedLocation : CLLocation! = nil
    @IBOutlet weak var drive: UIButton!
    @IBAction func carbtn(_ sender: UIButton) {
        map4.isHidden = false
          start()
     
        drive.backgroundColor = UIColor.blue
        walk.backgroundColor = UIColor.clear
        if(flag == "1") {
            self.arrayLatitude.removeAll()
            self.arrayLongitude.removeAll()
            self.array.removeAll()
            self.map4.removeAnnotations(self.map4.annotations)
            self.map4.removeOverlays( self.map4.overlays)
            let address1 = startlocation.text!
            let address2 =  endlocation.text!
            array = [address1,address2]
            var arrayLoc: [String] = []
            
            for i in 0 ..< array.count {
                CLGeocoder().geocodeAddressString(array[i], completionHandler: { placemarks, error in
                    if (error != nil) {
                        let alert = UIAlertController(title: "", message: "No Route Found", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    if let placemark = placemarks?[0]  {
                        
                        let lat = String(format: "%.04f", (placemark.location?.coordinate.latitude ?? 0.0)!)
                        let lon =   String(format: "%.04f", (placemark.location?.coordinate.longitude ?? 0.0)!)
                        
                        let name = placemark.name!
                        let country = placemark.country!
                      //  let region = placemark.administrativeArea!
                        print("location,\(lat),\(lon)\n\(name) \(country)")
                        self.lat11 = Double((placemark.location?.coordinate.latitude ?? 0.0))
                        self.long1 = Double((placemark.location?.coordinate.longitude ?? 0.0))
                        
                        print("lat11 ,long1 : \(self.lat11) , \(self.long1)")
                        
                        self.arrayLongitude.append(self.long1)
                        self.arrayLatitude.append(self.lat11)
                        print("self.arrayLatitude,\(self.arrayLatitude)")
                        print("arrayLongitude,\(self.arrayLongitude)")
                        
                        for i in 0 ..< self.arrayLatitude.count{
                            print("self.arrayLatitude,\(self.arrayLatitude)")
                            
                            print("arrayLongitude,\(self.arrayLongitude)")
                            
                            
                            
                            
                            
                            self.position2 = CLLocationCoordinate2DMake(CLLocationDegrees(self.arrayLatitude[0]), CLLocationDegrees(self.arrayLongitude[0]))
                            print(" position2,\( self.position2)")
                            let marker2 = GMSMarker(position: self.position2)
                            
                            
                            let london = MKPointAnnotation()
                            
                            london.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.arrayLatitude[i]), longitude:  CLLocationDegrees(self.arrayLongitude[i]))
                            print(" london.coordinate,\( london.coordinate)")
                            london.title = self.array[i]
                            self.map4?.addAnnotation(london)
                            print("array[i],\(self.array[i])")
                            
                            print("address1,\(address1)")
                            if(self.array[i] != address1 ){
                                
                                self.position1 = CLLocationCoordinate2DMake(CLLocationDegrees(self.arrayLatitude[1]), CLLocationDegrees(self.arrayLongitude[1]))
                                  print("posirion,\(self.position1)")
                                print(" position1,\( self.position1)")
                                let marker1 = GMSMarker(position: self.position1)
                                
                                
                                
                                
                                let sourceLocation = MKPlacemark(coordinate: self.position2)
                                let destinationLocation = MKPlacemark(coordinate: self.position1)
                                let directionRequest = MKDirections.Request()
                                directionRequest.source = MKMapItem(placemark: sourceLocation)
                                directionRequest.destination = MKMapItem(placemark: destinationLocation)
                                directionRequest.transportType = .automobile
                                let directions = MKDirections(request: directionRequest)
                                directions.calculate{(response, error)in
                                    guard let directionResponse = response else{
                                        if let error = error{
                                            print("error,\(error.localizedDescription)")
                                            let alert = UIAlertController(title: "", message: "Directions Not Available", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                            self.present(alert, animated: true, completion: nil)
                                        }
                                        return
                                    }
                                    let route = directionResponse.routes[0]
                                    print(route.distance)
                                    print(" driving distance , \(route.distance)")
                                    let kilometers = route.distance / 1000.0
                                    print(" driving distance km , \(kilometers)")
                                    print("directionResponse.routes[0],\(directionResponse.routes[0])")
                                    
                                    if (response?.routes.count)! > 0 {
                                        let route = response?.routes[0]
                                        print(route!.expectedTravelTime)
                                        let time = route!.expectedTravelTime
                                        let (hr,  minf) = modf (time / 3600)
                                        let newtime = hr
                                        let (min, secf) = modf (60 * minf)
                                        self.timeview.isHidden = false
                                        let formatter = NumberFormatter()
                                        self.distance.text = ("\(NSString(format: "%.02f", kilometers) as String)km")
                                        self.time1.text = ("\( NSString(format: "%.f", (newtime) ) as String)hr")
                                        self.minlabel.text = ("\(NSString(format: "%.002f", (minf*100) ) as String)min")
                                        
                                    }
                                    
                                    
                                    self.map4.addOverlay(route.polyline, level: .aboveRoads)
                                    let rect = route.polyline.boundingMapRect
                                    self.map4.setRegion(MKCoordinateRegion(rect), animated:true)
                                    
                                }
                                self.map4.delegate = self
                            }
                            //
                            //
                            //
                            //                                        let polyline = GMSPolyline(path: path)
                            //                                        polyline.map = mapView
                            //                                   //  self.map4?.addOverlay((polyline))
                            //                                            polyline.strokeColor = .blue
                            
                            
                        }
                        
                        
                    }
                    
                })
            }
            
        }
            
        else
        {
            self.arrayLatitude.removeAll()
            self.arrayLongitude.removeAll()
            self.array.removeAll()
            self.map4.removeAnnotations(self.map4.annotations)
            self.map4.removeOverlays( self.map4.overlays)
            let address1 = startlocation.text!
            let address2 = endlocation.text!
            array = [address1,address2]
            var arrayLoc: [String] = []
            
            for i in 0 ..< array.count {
               
                CLGeocoder().geocodeAddressString(array[i], completionHandler: { placemarks, error in
                    print("array[i],\(self.array[i])")
                    print("error,\(error)")
                    if (error != nil) {
                        let alert = UIAlertController(title: "", message: "No Route Found", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                      
                        return
                    }
                    
                    if let placemark = placemarks?[0]  {
                        
                        let lat = String(format: "%.04f", (placemark.location?.coordinate.latitude ?? 0.0)!)
                        let lon =   String(format: "%.04f", (placemark.location?.coordinate.longitude ?? 0.0)!)
                    
                        let name = placemark.name!
                        let country = placemark.country!
                   //     let region = placemark.administrativeArea!
                        print("location,\(lat),\(lon)\n\(name) \(country)")
                        self.lat11 = Double((placemark.location?.coordinate.latitude ?? 0.0))
                        self.long1 = Double((placemark.location?.coordinate.longitude ?? 0.0))
                        
                        print("lat11 ,long1 : \(self.lat11) , \(self.long1)")
                        
                        self.arrayLongitude.append(self.long1)
                        self.arrayLatitude.append(self.lat11)
                        print("self.arrayLatitude,\(self.arrayLatitude)")
                        print("arrayLongitude,\(self.arrayLongitude)")
                        
                        for i in 0 ..< self.arrayLatitude.count{
                            print("self.arrayLatitude,\(self.arrayLatitude)")
                            
                            print("arrayLongitude,\(self.arrayLongitude)")
                            
                            
                            
                            
                            
                            let position2 = CLLocationCoordinate2DMake(CLLocationDegrees(self.arrayLatitude[0]), CLLocationDegrees(self.arrayLongitude[0]))
                            print(" position2,\( position2)")
                            let marker2 = GMSMarker(position: position2)
                            
                            
                            let london = MKPointAnnotation()
                            
                            london.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.arrayLatitude[i]), longitude:  CLLocationDegrees(self.arrayLongitude[i]))
                            print(" london.coordinate,\( london.coordinate)")
                            london.title = self.array[i]
                            self.map4?.addAnnotation(london)
                            print("array[i],\(self.array[i])")
                            
                            print("address1,\(address1)")
                            if(self.array[i] != address1 ){
                                
                                let position1 = CLLocationCoordinate2DMake(CLLocationDegrees(self.arrayLatitude[1]), CLLocationDegrees(self.arrayLongitude[1]))
                                print(" position1,\( position1)")
                                let marker1 = GMSMarker(position: position1)
                                
                                
                                
                                
                                let sourceLocation = MKPlacemark(coordinate: position2)
                                let destinationLocation = MKPlacemark(coordinate: position1)
                                let directionRequest = MKDirections.Request()
                                directionRequest.source = MKMapItem(placemark: sourceLocation)
                                directionRequest.destination = MKMapItem(placemark: destinationLocation)
                                
                                
                                directionRequest.transportType = .automobile
                                let directions = MKDirections(request: directionRequest)
                                directions.calculate{(response, error)in
                                    guard let directionResponse = response else{
                                        if let error = error{
                                            print("error,\(error.localizedDescription)")
                                            let alert = UIAlertController(title: "", message: "Directions Not Available", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                            self.present(alert, animated: true, completion: nil)
                                        }
                                        return
                                    }
                                    let route = directionResponse.routes[0]
                                    print(route.distance)
                                    print(" driving distance , \(route.distance)")
                                    let kilometers = route.distance / 1000.0
                                    print(" driving distance km , \(kilometers)")
                                    print("directionResponse.routes[0],\(directionResponse.routes[0])")
                                    
                                    if (response?.routes.count)! > 0 {
                                        let route = response?.routes[0]
                                        print(route!.expectedTravelTime)
                                        let time = route!.expectedTravelTime
                                        let (hr,  minf) = modf (time / 3600)
                                        let newtime = hr
                                        let (min, secf) = modf (60 * minf)
                                        self.timeview.isHidden = false
                                        let formatter = NumberFormatter()
                                        
                                        
                                        self.distance.text = ("\(NSString(format: "%.02f", kilometers) as String)km")
                                        self.time1.text = ("\( NSString(format: "%.f", (newtime) ) as String)hr")
                                        self.minlabel.text = ("\(NSString(format: "%.002f", (minf*100) ) as String)min")
                                        
                                    }
                                    
                                    self.map4.addOverlay(route.polyline, level: .aboveRoads)
                                    let rect = route.polyline.boundingMapRect
                                    self.map4.setRegion(MKCoordinateRegion(rect), animated:true)
                                    
                                }
                                self.map4.delegate = self
                            }
                            //
                            //
                            //
                            //                                        let polyline = GMSPolyline(path: path)
                            //                                        polyline.map = mapView
                            //                                   //  self.map4?.addOverlay((polyline))
                            //                                            polyline.strokeColor = .blue
                            
                            
                        }
                        
                        
                    }
                     print("error,\(error)")
                })
                 print("array,\(array)")
            }
               print("array,\(array)")
        }
    
        
        
    }
    
    @IBAction func walkbtn(_ sender: UIButton) {
         map4.isHidden = false
        start()
        walkflag = "1"
        drive.backgroundColor = UIColor.clear
        walk.backgroundColor =  UIColor.blue
        if(flag == "1") {
            self.arrayLatitude.removeAll()
            self.arrayLongitude.removeAll()
            self.array.removeAll()
            self.map4.removeAnnotations(self.map4.annotations)
            self.map4.removeOverlays( self.map4.overlays)
            let address1 = startlocation.text!
            let address2 =  endlocation.text!
            array = [address1,address2]
            var arrayLoc: [String] = []
            
            for i in 0 ..< array.count {
                CLGeocoder().geocodeAddressString(array[i], completionHandler: { placemarks, error in
                    if (error != nil) {
                        
                        let alert = UIAlertController(title: "", message: "No Route Found", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    if let placemark = placemarks?[0]  {
                        
                        let lat = String(format: "%.04f", (placemark.location?.coordinate.latitude ?? 0.0)!)
                        let lon =   String(format: "%.04f", (placemark.location?.coordinate.longitude ?? 0.0)!)
                        
                        let name = placemark.name!
                        let country = placemark.country!
                      //  let region = placemark.administrativeArea!
                        print("location,\(lat),\(lon)\n\(name) \(country)")
                        self.lat11 = Double((placemark.location?.coordinate.latitude ?? 0.0))
                        self.long1 = Double((placemark.location?.coordinate.longitude ?? 0.0))
                        
                        print("lat11 ,long1 : \(self.lat11) , \(self.long1)")
                        
                        self.arrayLongitude.append(self.long1)
                        self.arrayLatitude.append(self.lat11)
                        print("self.arrayLatitude,\(self.arrayLatitude)")
                        print("arrayLongitude,\(self.arrayLongitude)")
                        
                        for i in 0 ..< self.arrayLatitude.count{
                            print("self.arrayLatitude,\(self.arrayLatitude)")
                            
                            print("arrayLongitude,\(self.arrayLongitude)")
                            
                            
                            
                            
                            let camera = GMSCameraPosition.camera(withLatitude: (self.arrayLatitude[i]), longitude: 73.8567, zoom: 10.0)
                            let position2 = CLLocationCoordinate2DMake(CLLocationDegrees(self.arrayLatitude[i]), CLLocationDegrees(self.arrayLongitude[i]))
                            print(" position2,\( position2)")
                            let marker2 = GMSMarker(position: position2)
                            
                           // let camera = GMSCameraPosition.camera(withLatitude: 18.5204, longitude: 73.8567, zoom: 10.0)
//                            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//                            self.view = mapView
//
//                            // Creates a marker in the center of the map.
//                            let marker = GMSMarker()
//                            marker.position = CLLocationCoordinate2DMake(CLLocationDegrees(self.arrayLatitude[i]), CLLocationDegrees(self.arrayLongitude[i]))
//                            marker.title = "Pune"
//                            marker.snippet = "India"
//                            marker.map = mapView
//
                            
                            let london = MKPointAnnotation()

                            london.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.arrayLatitude[i]), longitude:  CLLocationDegrees(self.arrayLongitude[i]))
                            print(" london.coordinate,\( london.coordinate)")
                            london.title = self.array[i]
                            self.map4?.addAnnotation(london)
                            print("array[i],\(self.array[i])")

                            print("address1,\(address1)")
                            if(self.array[i] != address1 ){

                                let position1 = CLLocationCoordinate2DMake(CLLocationDegrees(self.arrayLatitude[1]), CLLocationDegrees(self.arrayLongitude[1]))
                                print(" position1,\( position1)")
                                let marker1 = GMSMarker(position: position1)




                                let sourceLocation = MKPlacemark(coordinate: position2)
                                let destinationLocation = MKPlacemark(coordinate: position1)
                                let directionRequest = MKDirections.Request()
                                directionRequest.source = MKMapItem(placemark: sourceLocation)
                                directionRequest.destination = MKMapItem(placemark: destinationLocation)
                                directionRequest.transportType = .walking
                                let directions = MKDirections(request: directionRequest)
                                directions.calculate{(response, error)in
                                    guard let directionResponse = response else{
                                        if let error = error{
                                            print("error,\(error.localizedDescription)")
                                            let alert = UIAlertController(title: "", message: "Directions Not Available", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                            self.present(alert, animated: true, completion: nil)
                                        }
                                        return
                                    }
                                    let route = directionResponse.routes[0]
                                    print(route.distance)
                                    print(" driving distance , \(route.distance)")
                                    let kilometers = route.distance / 1000.0
                                    print(" driving distance km , \(kilometers)")
                                    print("directionResponse.routes[0],\(directionResponse.routes[0])")

                                    if (response?.routes.count)! > 0 {
                                        let route = response?.routes[0]
                                        print(route!.expectedTravelTime)
                                        let time = route!.expectedTravelTime
                                        let (hr,  minf) = modf (time / 3600)
                                        let newtime = hr
                                        let (min, secf) = modf (60 * minf)
                                        self.timeview.isHidden = false
                                        let formatter = NumberFormatter()
                                        self.distance.text = ("\(NSString(format: "%.02f", kilometers) as String)km")
                                        self.time1.text = ("\( NSString(format: "%.f", (newtime) ) as String)hr")
                                        self.minlabel.text = ("\(NSString(format: "%.002f", (minf*100) ) as String)min")

                                    }

                                    self.map4.addOverlay(route.polyline, level: .aboveRoads)
                                    let rect = route.polyline.boundingMapRect
                                    self.map4.setRegion(MKCoordinateRegion(rect), animated:true)

                                }
                                self.map4.delegate = self
                            }
                            
                            
                            
//                                                                    let polyline = GMSPolyline(path: path)
//                                                                    polyline.map = mapView
//                                                               //  self.map4?.addOverlay((polyline))
//                                                                        polyline.strokeColor = .blue
                            
                            
                        }
                        
                        
                    }
                    
                })
            }
            
        }
            
        else
        {
            self.arrayLatitude.removeAll()
            self.arrayLongitude.removeAll()
            self.array.removeAll()
            self.map4.removeAnnotations(self.map4.annotations)
            self.map4.removeOverlays( self.map4.overlays)
            let address1 = startlocation.text!
            let address2 = endlocation.text!
            array = [address1,address2]
            var arrayLoc: [String] = []
            
            for i in 0 ..< array.count {
                CLGeocoder().geocodeAddressString(array[i], completionHandler: { placemarks, error in
                    if (error != nil) {
                        print("error,\(error)")
                        let alert = UIAlertController(title: "", message: "No Route Found", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    if let placemark = placemarks?[0]  {
                       
                        let lat = String(format: "%.04f", (placemark.location?.coordinate.latitude ?? 0.0)!)
                        let lon =   String(format: "%.04f", (placemark.location?.coordinate.longitude ?? 0.0)!)
                        
                        let name = placemark.name!
                        let country = placemark.country!
                       // let region = placemark.administrativeArea!
                        print("location,\(lat),\(lon)\n\(name) \(country)")
                        self.lat11 = Double((placemark.location?.coordinate.latitude ?? 0.0))
                        self.long1 = Double((placemark.location?.coordinate.longitude ?? 0.0))
                        
                        print("lat11 ,long1 : \(self.lat11) , \(self.long1)")
                        
                        self.arrayLongitude.append(self.long1)
                        self.arrayLatitude.append(self.lat11)
                        print("self.arrayLatitude,\(self.arrayLatitude)")
                        print("arrayLongitude,\(self.arrayLongitude)")
                        
                        for i in 0 ..< self.arrayLatitude.count{
                            print("self.arrayLatitude,\(self.arrayLatitude)")
                            
                            print("arrayLongitude,\(self.arrayLongitude)")
                            
                            
                            
                            
                            
                            let position2 = CLLocationCoordinate2DMake(CLLocationDegrees(self.arrayLatitude[0]), CLLocationDegrees(self.arrayLongitude[0]))
                            print(" position2,\( position2)")
                            let marker2 = GMSMarker(position: position2)
                            
                            
                            let london = MKPointAnnotation()
                            
                            london.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.arrayLatitude[i]), longitude:  CLLocationDegrees(self.arrayLongitude[i]))
                            print(" london.coordinate,\( london.coordinate)")
                            london.title = self.array[i]
                            self.map4?.addAnnotation(london)
                            print("array[i],\(self.array[i])")
                            
                            print("address1,\(address1)")
                            if(self.array[i] != address1 ){
                                
                                let position1 = CLLocationCoordinate2DMake(CLLocationDegrees(self.arrayLatitude[1]), CLLocationDegrees(self.arrayLongitude[1]))
                                print(" position1,\( position1)")
                                let marker1 = GMSMarker(position: position1)
                                
                                
                                
                                
                                let sourceLocation = MKPlacemark(coordinate: position2)
                                let destinationLocation = MKPlacemark(coordinate: position1)
                                let directionRequest = MKDirections.Request()
                                directionRequest.source = MKMapItem(placemark: sourceLocation)
                                directionRequest.destination = MKMapItem(placemark: destinationLocation)
                                
                                
                                directionRequest.transportType = .walking
                                let directions = MKDirections(request: directionRequest)
                                directions.calculate{(response, error)in
                                    guard let directionResponse = response else{
                                        if let error = error{
                                            print("error,\(error.localizedDescription)")
                                            let alert = UIAlertController(title: "", message: "Directions Not Available", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                            self.present(alert, animated: true, completion: nil)
                                        }
                                        return
                                    }
                                    let route = directionResponse.routes[0]
                                    print(route.distance)
                                    print(" driving distance , \(route.distance)")
                                    let kilometers = route.distance / 1000.0
                                    print(" driving distance km , \(kilometers)")
                                    print("directionResponse.routes[0],\(directionResponse.routes[0])")
                                    
                                    if (response?.routes.count)! > 0 {
                                        let route = response?.routes[0]
                                        print(route!.expectedTravelTime)
                                        let time = route!.expectedTravelTime
                                        let (hr,  minf) = modf (time / 3600)
                                        let newtime = hr
                                        let (min, secf) = modf (60 * minf)
                                        self.timeview.isHidden = false
                                        let formatter = NumberFormatter()
                                        
                                        
                                        self.distance.text = ("\(NSString(format: "%.02f", kilometers) as String)km")
                                        self.time1.text = ("\( NSString(format: "%.f", (newtime) ) as String)hr")
                                        self.minlabel.text = ("\(NSString(format: "%.002f", (minf*100) ) as String)min")
                                        
                                    }
                                    
                                    self.map4.addOverlay(route.polyline, level: .aboveRoads)
                                    let rect = route.polyline.boundingMapRect
                                    self.map4.setRegion(MKCoordinateRegion(rect), animated:true)
                                    
                                }
                                self.map4.delegate = self
                            }
                            //
                            //
                            //
                            //                                        let polyline = GMSPolyline(path: path)
                            //                                        polyline.map = mapView
                            //                                   //  self.map4?.addOverlay((polyline))
                            //                                            polyline.strokeColor = .blue
                            
                            
                        }
                        
                        
                    }
                    
                })
            }
            
        }
   
        
        }
    
      var arrayLoc: [String] = []
    var aray = NSMutableArray()
    @IBAction func direction(_ sender: UIButton) {
     start()
        if(flag == "1") {
            
            
                let address1 = startlocation.text!
                let address2 =  endlocation.text!
            
            
            map4?.isHidden = false
            array = [address1,address2]
            var arrayLoc: [String] = []
            
            print(" textField.text,\( textField.text!)")
               print("   array.append(textField.text!),\(   array.append(textField.text!))")
          let address3 =  array.append(textField.text!)
           
            array = [address1,address2,address3] as! [String]
                for i in 0 ..< array.count {
                    CLGeocoder().geocodeAddressString(array[i], completionHandler: { placemarks, error in
                        if (error != nil) {
                            return
                        }

                        if let placemark = placemarks?[0]  {

                            let lat = String(format: "%.04f", (placemark.location?.coordinate.latitude ?? 0.0)!)
                            let lon =   String(format: "%.04f", (placemark.location?.coordinate.longitude ?? 0.0)!)

                            let name = placemark.name!
                            let country = placemark.country!
                         //   let region = placemark.administrativeArea!
                            print("location,\(lat),\(lon)\n\(name) \(country)")
                            self.lat11 = Double((placemark.location?.coordinate.latitude ?? 0.0))
                            self.long1 = Double((placemark.location?.coordinate.longitude ?? 0.0))

                            print("lat11 ,long1 : \(self.lat11) , \(self.long1)")

                            self.arrayLongitude.append(self.long1)
                            self.arrayLatitude.append(self.lat11)
                            print("self.arrayLatitude,\(self.arrayLatitude)")
                            print("arrayLongitude,\(self.arrayLongitude)")

                            for i in 0 ..< self.arrayLatitude.count{
                                print("self.arrayLatitude,\(self.arrayLatitude)")

                                print("arrayLongitude,\(self.arrayLongitude)")





                                let position2 = CLLocationCoordinate2DMake(CLLocationDegrees(self.arrayLatitude[0]), CLLocationDegrees(self.arrayLongitude[0]))
                                print(" position2,\( position2)")
                                let marker2 = GMSMarker(position: position2)


                                let london = MKPointAnnotation()

                                london.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.arrayLatitude[i]), longitude:  CLLocationDegrees(self.arrayLongitude[i]))
                                print(" london.coordinate,\( london.coordinate)")
                                london.title = self.array[i]
                                self.map4?.addAnnotation(london)
                                print("array[i],\(self.array[i])")

                                print("address1,\(address1)")
                                if(self.array[i] != address1 ){

                                    let position1 = CLLocationCoordinate2DMake(CLLocationDegrees(self.arrayLatitude[1]), CLLocationDegrees(self.arrayLongitude[1]))
                                    print(" position1,\( position1)")
                                    let marker1 = GMSMarker(position: position1)




                                    let sourceLocation = MKPlacemark(coordinate: position2)
                                    let destinationLocation = MKPlacemark(coordinate: position1)
                                    let directionRequest = MKDirections.Request()
                                    directionRequest.source = MKMapItem(placemark: sourceLocation)
                                    directionRequest.destination = MKMapItem(placemark: destinationLocation)
                                    directionRequest.transportType = .automobile
                                    let directions = MKDirections(request: directionRequest)
                                    directions.calculate{(response, error)in
                                        guard let directionResponse = response else{
                                            if let error = error{
                                                print("error,\(error.localizedDescription)")
                                            }
                                            return
                                        }
                                        let route = directionResponse.routes[0]
                                        print(route.distance)
                                        print(" driving distance , \(route.distance)")
                                        let kilometers = route.distance / 1000.0
                                        print(" driving distance km , \(kilometers)")
                                        print("directionResponse.routes[0],\(directionResponse.routes[0])")

                                        if (response?.routes.count)! > 0 {
                                            let route = response?.routes[0]
                                            print(route!.expectedTravelTime)
                                            let time = route!.expectedTravelTime
                                            let (hr,  minf) = modf (time / 3600)
                                            let newtime = hr
                                            let (min, secf) = modf (60 * minf)
                                            self.timeview.isHidden = false
                                            let formatter = NumberFormatter()
                                            self.distance.text = ("\(NSString(format: "%.02f", kilometers) as String)km")
                                            self.time1.text = ("\( NSString(format: "%.f", (newtime) ) as String)hr")
                                            self.minlabel.text = ("\(NSString(format: "%.002f", (minf*100) ) as String)min")

                                        }

                                        self.map4.addOverlay(route.polyline, level: .aboveRoads)
                                        let rect = route.polyline.boundingMapRect
                                        self.map4.setRegion(MKCoordinateRegion(rect), animated:true)

                                    }
                                    self.map4.delegate = self
                                }
                                //
                                //
                                //
                                //                                        let polyline = GMSPolyline(path: path)
                                //                                        polyline.map = mapView
                                //                                   //  self.map4?.addOverlay((polyline))
                                //                                            polyline.strokeColor = .blue


                            }


                        }

                    })
                }

            }

        else
        {
    
           
        let address1 = startlocation.text!
         let address2 = endlocation.text!
          map4?.isHidden = false
     //   array = [address1,address2]
      
           

            print("   array.append(textField.text!),\(   array.append(textField.text!))")
            
           
            array = [address1,address2]
                print("   array.array\(array))")
          
              print("   arrayLoc\(arrayLoc))")
            if(txtflag == "1")
            {
                   let string = textField.text
                 aray.add(string)
            }
         
            
           
           // let zipped = zip(array, aray)
            arrayLoc = array + (aray as! [String])
        for i in 0 ..< arrayLoc.count {
                            CLGeocoder().geocodeAddressString(arrayLoc[i], completionHandler: { placemarks, error in
                                if (error != nil) {
                                    return
                                }

                                if let placemark = placemarks?[0]  {

                                    let lat = String(format: "%.04f", (placemark.location?.coordinate.latitude ?? 0.0)!)
                                    let lon =   String(format: "%.04f", (placemark.location?.coordinate.longitude ?? 0.0)!)

                                    let name = placemark.name!
                                    let country = placemark.country!
                                  //  let region = placemark.administrativeArea!
                                    print("location,\(lat),\(lon)\n\(name) \(country)")
                                    self.lat11 = Double((placemark.location?.coordinate.latitude ?? 0.0))
                                    self.long1 = Double((placemark.location?.coordinate.longitude ?? 0.0))

                                    print("lat11 ,long1 : \(self.lat11) , \(self.long1)")

                                    self.arrayLongitude.append(self.long1)
                                    self.arrayLatitude.append(self.lat11)
                                    print("self.arrayLatitude,\(self.arrayLatitude)")
                                       print("arrayLongitude,\(self.arrayLongitude)")

                                   for i in 0 ..< self.arrayLatitude.count{
                                      print("self.arrayLatitude,\(self.arrayLatitude)")
                                      print("arrayLongitude,\(self.arrayLongitude)")
//                                let position2 = CLLocationCoordinate2DMake(CLLocationDegrees(self.arrayLatitude[0]), CLLocationDegrees(self.arrayLongitude[0]))
//                                      print(" position2,\( position2)")
//                                let marker2 = GMSMarker(position: position2)
//                                 let london = MKPointAnnotation()
//                                london.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.arrayLatitude[i]), longitude:  CLLocationDegrees(self.arrayLongitude[i]))
//                                 print(" london.coordinate,\( london.coordinate)")
                                  
                         //   self.map4?.addAnnotation(london)
                                    
                                    let yourTotalCoordinates = Double(3)
                                    var arraycordinate  = [CLLocationCoordinate2D]()
                                    for index in 1...Int(yourTotalCoordinates) {
                                        let position2 = CLLocationCoordinate2DMake(CLLocationDegrees(self.arrayLatitude[i]), CLLocationDegrees(self.arrayLongitude[i]))
                                        print(" position2,\( position2)")
                                        let marker2 = GMSMarker(position: position2)
                                        let london = MKPointAnnotation()
                                        london.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.arrayLatitude[i]), longitude:  CLLocationDegrees(self.arrayLongitude[i]))
                                        print(" london.coordinate,\( london.coordinate)")
                                        
                                        self.map4?.addAnnotation(london)
                                      
                                        let sourceLocation = MKPlacemark(coordinate: self.position2)
                                        let destinationLocation = MKPlacemark(coordinate: self.position2)
                                        let directionRequest = MKDirections.Request()
                                        directionRequest.source = MKMapItem(placemark: sourceLocation)
                                        directionRequest.destination = MKMapItem(placemark: destinationLocation)
                                        directionRequest.transportType = .automobile
                                        let directions = MKDirections(request: directionRequest)
                                        directions.calculate{(response, error)in
                                            guard let directionResponse = response else{
                                                if let error = error{
                                                    print("error,\(error.localizedDescription)")
                                                }
                                                return
                                            }
                                            let route = directionResponse.routes[0]
                                            print(route.distance)
                                            print(" driving distance , \(route.distance)")
                                            let kilometers = route.distance / 1000.0
                                            print(" driving distance km , \(kilometers)")
                                            print("directionResponse.routes[0],\(directionResponse.routes[0])")
                                            
                                            if (response?.routes.count)! > 0 {
                                                let route = response?.routes[0]
                                                print(route!.expectedTravelTime)
                                                let time = route!.expectedTravelTime
                                                let (hr,  minf) = modf (time / 3600)
                                                let newtime = hr
                                                let (min, secf) = modf (60 * minf)
                                                self.timeview.isHidden = false
                                                let formatter = NumberFormatter()
                                                
                                                
                                                self.distance.text = ("\(NSString(format: "%.02f", kilometers) as String)km")
                                                self.time1.text = ("\( NSString(format: "%.f", (newtime) ) as String)hr")
                                                self.minlabel.text = ("\(NSString(format: "%.002f", (minf*100) ) as String)min")
                                                
                                            }
                                            
                                            self.map4.addOverlay(route.polyline, level: .aboveRoads)
                                            let rect = route.polyline.boundingMapRect
                                            self.map4.setRegion(MKCoordinateRegion(rect), animated:true)
                                            
                                        }
                                        self.map4.delegate = self
                                    
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                    print("arrayLoc[i],\(self.arrayLoc[i])")
                   print("address1,\(address1)")
                                    if(self.arrayLoc[i] != address1 ){
                                    let position1 = CLLocationCoordinate2DMake(CLLocationDegrees(self.arrayLatitude[1]), CLLocationDegrees(self.arrayLongitude[1]))
                                 print(" position1,\( position1)")
                                        
                                        
                                       
                                        
                                        let marker1 = GMSMarker(position: position1)
                                        let sourceLocation = MKPlacemark(coordinate: self.position2)
                                    let destinationLocation = MKPlacemark(coordinate: position1)
                                    let directionRequest = MKDirections.Request()
                                    directionRequest.source = MKMapItem(placemark: sourceLocation)
                                    directionRequest.destination = MKMapItem(placemark: destinationLocation)
                                    directionRequest.transportType = .automobile
                                            let directions = MKDirections(request: directionRequest)
                                            directions.calculate{(response, error)in
                                                guard let directionResponse = response else{
                                                    if let error = error{
                                                        print("error,\(error.localizedDescription)")
                                                }
                                                return
                                            }
                                            let route = directionResponse.routes[0]
                                                print(route.distance)
                                                  print(" driving distance , \(route.distance)")
                                               let kilometers = route.distance / 1000.0
                                                 print(" driving distance km , \(kilometers)")
                                                print("directionResponse.routes[0],\(directionResponse.routes[0])")

                                                if (response?.routes.count)! > 0 {
                                                    let route = response?.routes[0]
                                                    print(route!.expectedTravelTime)
                                                    let time = route!.expectedTravelTime
                                                    let (hr,  minf) = modf (time / 3600)
                                                    let newtime = hr
                                                    let (min, secf) = modf (60 * minf)
                                                    self.timeview.isHidden = false
                                                    let formatter = NumberFormatter()


                                                    self.distance.text = ("\(NSString(format: "%.02f", kilometers) as String)km")
                                                self.time1.text = ("\( NSString(format: "%.f", (newtime) ) as String)hr")
                                                    self.minlabel.text = ("\(NSString(format: "%.002f", (minf*100) ) as String)min")

                                                }

                                                self.map4.addOverlay(route.polyline, level: .aboveRoads)
                                            let rect = route.polyline.boundingMapRect
                                                self.map4.setRegion(MKCoordinateRegion(rect), animated:true)

                                            }
                                            self.map4.delegate = self
                                    }
//
//
//
//                                        let polyline = GMSPolyline(path: path)
//                                        polyline.map = mapView
//                                   //  self.map4?.addOverlay((polyline))
//                                            polyline.strokeColor = .blue


                                    }


                               }

                              })
                }

    }
    }
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading){
        print("Are we in ?")    // ---------- NOPE!!
        print(newHeading.magneticHeading)
           print("\(newHeading.magneticHeading)")
//         if let newHeading = newHeading as CLLocation?{
//
//            let oldCoordinates = oldLocationNew.coordinate
//
//            var area = [oldCoordinates, newHeading]
//
//            let alert = UIAlertController(title: "Alert", message: " error Location updated oldCoordinates,newCoordinates ,\(newHeading)", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
//                switch action.style{
//                case .default:
//                    print("default")
//                    self.start()
//
//                case .cancel:
//                    print("cancel")
//
//                case .destructive:
//                    print("destructive")
//
//
//                }}))
//            self.present(alert, animated: true, completion: nil)
//
//        }
    }
    var firstLoc = String()
    var lastLoc = String()
    var latnew = Double()
      var longnew = Double()
     let london = MKPointAnnotation()
    let london1 = MKPointAnnotation()
   public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
   
        if let location1 = locations.first {
           // lastLocation = location
           // ...
//           firstLoc = String(format: "%.04f", (location1.coordinate.latitude ?? 0.0)!)
//             lastLoc = String(format: "%.04f", (location1.coordinate.longitude ?? 0.0)!)
//            print("location1,\(location1)")
//
//           self.latnew = Double((location1.coordinate.latitude ?? 0.0))
//             self.longnew = Double((location1.coordinate.longitude ?? 0.0))
//            london.coordinate = CLLocationCoordinate2D(latitude:  self.latnew, longitude: longnew)
//           // print(" london.coordinate,\( london.coordinate)")
//            london.title = "Hello"
//            self.map4?.addAnnotation(london)
//            firstLoc = String(format: "%.04f", (position1.coordinate.latitude ?? 0.0)!)
//          lastLoc = String(format: "%.04f", (pos.coordinate.longitude ?? 0.0)!)
//             self.longnew = Double((position1.coordinate.longitude ?? 0.0))
            
            print("posirion,\(self.position2)")
          
           //    firstLoc = CLLocationCoordinate2DMake(self.position1)
        //    let center = CLLocationCoordinate2D(latitude:   self.position1.latitude, longitude:   self.position1.longitude)
         //   let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
         //   self.map4.setRegion(region, animated: true)
            
            london.coordinate = CLLocationCoordinate2D(latitude:   self.position1.latitude, longitude:    self.position1.longitude)
            print(" london.coordinate,\( london.coordinate)")
            //london.title = "Acharya House"
           // self.map4?.addAnnotation(london)
        }
if let location = locations.first{
//    let latitude = locationManager.location!.coordinate.latitude
//    let longitude = locationManager.location!.coordinate.longitude
   
    //location = CLLocationCoordinate2D(latitude: 19.0760, longitude:72.8777)
   
           // let center = CLLocationCoordinate2D(latitude:   self.position2.latitude, longitude:   self.position2.longitude)
           // let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
          //  self.map4.setRegion(region, animated: true)
    
    
    london1.coordinate = CLLocationCoordinate2D(latitude:   self.position2.latitude, longitude:    self.position2.longitude)
     print(" london.coordinate,\( london1.coordinate)")
   // london1.title = "LMD garden"
  //  self.map4?.addAnnotation(london1)

       }
      
            let oldCoordinates =  london.coordinate
            let newCoordinates = london1.coordinate
            var area = [oldCoordinates, newCoordinates]
            var polyline = MKPolyline(coordinates: &area, count: area.count)
            map4.addOverlay(polyline)
        
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError){
        let alert = UIAlertController(title: "Alert", message: " error Location updated", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                self.start()
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
          start()
        print("walkflag,\(walkflag)")
        if(walkflag == "1"){
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 4.0
            // renderer.lineWidth = 4.0
            renderer.lineDashPhase = 2
            renderer.lineDashPattern = [NSNumber(value: 1),NSNumber(value:5)]
            walkflag = "0"
            return renderer
            
        }
        else{
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 4.0
            // renderer.lineWidth = 4.0
          
            return renderer
            
        }
    }
    @objc func handleTap(_ sender: UIButton) {
        print("You tapped a button")
    }
    @IBOutlet weak var endlocation: UITextField!
    @IBOutlet weak var startlocation: UITextField!
    @IBAction func btnmap(_ sender: Any) {
        let camera = GMSCameraPosition.camera(withLatitude: 18.5204, longitude: 73.8567, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
       
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 18.5204, longitude: 73.8567)
        marker.title = "Pune"
        marker.snippet = "India"
        marker.map = mapView
    }
  

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil
        {
            print(error)
        }
      
        
        else
        {  print(user.profile.email)
          // self.performSegue(withIdentifier: "home", sender: self)
        }
    }
    
    

    
@IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var btn: UIButton!
   
    
    @IBAction func signin(_ sender: Any) {
        
        // GIDSignIn.sharedInstance().signIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        direction.layer.cornerRadius = 5; // this value vary as per your desire
      timeview.isHidden = true
        GIDSignIn.sharedInstance()?.delegate=self
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
        GIDSignIn.sharedInstance()?.presentingViewController = self
       // if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
//            UIApplication.shared.openURL(URL(string:
//                "comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic")!)
//        } else {
//            print("Can't use comgooglemaps://");
//        }
       
    //    locationManager.delegate = self
       
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.activityType = .automotiveNavigation
        locationManager.distanceFilter = 10.0  // Movement threshold for new events
//        locationManager.allowsBackgroundLocationUpdates = true
//    map4.isHidden = true
//       locationManager.requestAlwaysAuthorization()
//     locationManager.startUpdatingLocation()
//    // var currentLocation: CLLocation!
//        locationManager.requestWhenInUseAuthorization()
//        //locationManager.requestLocation()
        //_locationManager.location = currentLocation
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        var status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        print((CLLocationManager.headingAvailable())) //works!!!
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        
       
        map4.delegate = self
        map4.showsUserLocation = true
        map4.mapType = MKMapType(rawValue: 0)!
        map4.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
        
       start()
      
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func start(){
        let queue = DispatchQueue(label: "Monitor")
        self.monitor.start(queue: queue)
        let cellMonitor = NWPathMonitor(requiredInterfaceType: .wifi)
        networkConnection()
    }
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }

}

