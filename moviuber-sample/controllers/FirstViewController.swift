//
//  FirstViewController.swift
//  moviuber-sample

import UIKit
import MapKit
import CoreLocation
import UberRides

class FirstViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let client = SODAClient(domain: "data.sfgov.org", token: "wzp88jwj9q81WlJpBjlA9rG38")
    let cellId = "DetailCell"
    var data: [[String: AnyObject]]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "MovieSpotTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView.rowHeight = 64.0
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        getData()
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
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MovieSpotTableViewCell
        
        let item = data[indexPath.row]
        let name = item["title"]! as! String
        let location = item["locations"]  as? String
        cell.loadItem(name:name, location : location)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        var location = item["locations"]  as? String;
        if (location != nil)
        {
            location  = location! + " San Fransisco, CA"
            let geocoder:CLGeocoder = CLGeocoder()
            geocoder.geocodeAddressString(location!, completionHandler: { (placemarks, error) in
                if placemarks != nil && placemarks!.count > 0
                {
                    let topResult:CLPlacemark = placemarks![0];
                    let placemark: MKPlacemark = MKPlacemark(placemark:topResult);
                    
                    if (error == nil && placemark.coordinate.latitude != 0 && placemark.coordinate.longitude != 0){
                        
                        let behavior = RideRequestViewRequestingBehavior(presentingViewController: self)
                        
                        let dropOffLocationlocation = CLLocation(
                            latitude: placemark.coordinate.latitude,
                            longitude: placemark.coordinate.longitude)
                        
                        let builder = RideParametersBuilder()
                        builder.dropoffLocation = dropOffLocationlocation
                        let parameters = builder.build()
                        
                        let button = RideRequestButton(rideParameters:
                            parameters, requestingBehavior: behavior)
                        
                        self.view.addSubview(button)
                    } // if err
                }   // if place marks
            })    // geo code
        } // location not null
    }
}

