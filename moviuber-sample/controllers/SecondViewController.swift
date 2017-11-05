//
//  SecondViewController.swift
//  moviuber-sample

import UIKit
import MapKit

class SecondViewController: UIViewController {

    let client = SODAClient(domain: "data.sfgov.org", token: "wzp88jwj9q81WlJpBjlA9rG38")
    var data: [[String: AnyObject]]! = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData () {
        let cngQuery = client.queryDataset("wwmu-gmzc")
        cngQuery.orderAscending("title").get { res in
            switch res {
            case .dataset (let data):
                self.data = data
            case .error (let err):
                print (err.userInfo.debugDescription)
            }
           
            self.updateWithData(data: self.data, animated: true)
        }
    }
    
    func updateWithData(data: [[String: AnyObject]]!, animated: Bool) {
        
        if mapView.annotations.count > 0 {
            let ex = mapView.annotations
            mapView.removeAnnotations(ex)
        }
        
        var anns : [MKAnnotation] = []
        for item in data {
            var location = item["locations"]  as? String
            if (location != nil){
                location  = location! + " San Fransisco, CA"
                let geocoder:CLGeocoder = CLGeocoder()
                geocoder.geocodeAddressString(location!, completionHandler: { (placemarks, error) in
                    if (placemarks != nil)
                    {
                        if placemarks!.count > 0
                        {
                            let topResult:CLPlacemark = placemarks![0];
                            let placemark: MKPlacemark = MKPlacemark(placemark:
                                topResult);
                            
                            let a = MKPointAnnotation()
                            a.coordinate = placemark.coordinate;
                            a.title = item["title"] as! NSString as String
                            a.title = a.title! + " " + (item["locations"] as! NSString as String)
                            anns.append(a);
                            
                            if (error == nil && a.coordinate.latitude != 0 &&
                                a.coordinate.longitude != 0){
                                self.mapView.addAnnotation(a);
                            }
                        }
                    }
                })
                
                let w = 1.0
                let r = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: 37.79666680533*w,longitude: -122.39826411049*w), 25000, 25000)
                self.mapView.setRegion(r, animated: false)
            }
        }
    }
}

