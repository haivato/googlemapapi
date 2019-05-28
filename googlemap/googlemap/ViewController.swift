//
//  ViewController.swift
//  googlemap
//
//  Created by HaiPhan on 5/28/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit
import GoogleMaps

var google_api_key = "AIzaSyBDLBpnBwc1JqWyThVSp7XOgjILXpyAjCw"

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationmanager = CLLocationManager()
    lazy var mapView = GMSMapView()
    // 1
    let defaultSession = URLSession(configuration: .default)
    // 2
    var dataTask: URLSessionDataTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 10.758496, longitude: 106.687753, zoom: 16.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
//
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 10.823099, longitude: 106.629662)
//        marker.title = "Ho Chi Minh"
//        marker.snippet = "hihi"
//        marker.map = mapView
//
//        // cấu hình  User Location
//        locationmanager.delegate = self
//        locationmanager.requestWhenInUseAuthorization()
//        locationmanager.desiredAccuracy = kCLLocationAccuracyBest
//        locationmanager.startUpdatingLocation()
//
//        //draw 2 point
        draw2point()
//
        
        
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Lấy địa điểm cuối cùng của user
        let userlocation = locations.last
        //chuyển dữ liệu sang  coori2d
        let center = CLLocationCoordinate2D(latitude: (userlocation?.coordinate.latitude)!, longitude: userlocation!.coordinate.longitude)
        //truyền lat long vào biến camera
        let camera = GMSCameraPosition.camera(withLatitude: userlocation!.coordinate.latitude, longitude: userlocation!.coordinate.longitude, zoom: 16.0)
        //đưa dũ liệu từ camera lên map
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        
        //Cấu hình annomation
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 10.767367, longitude: 106.695346)
        marker.title = "Ho Chi Minh"
        marker.snippet = "hihi"
        marker.map = mapView
        marker.icon = GMSMarker.markerImage(with: .blue)
        
        self.view = mapView
        
        locationmanager.stopUpdatingLocation()
        
        //tính khoảng cách giữa 2
//        let coordinate0 = CLLocation(latitude: 10.767328, longitude: 106.695006)
//        let coordinate1 = CLLocation(latitude: 10.762279, longitude: 106.690554)
//        let distanceInMeters = coordinate0.distance(from: coordinate1)
    }
    // Chỉ hiển thị 1 lần
    func draw2point(){
        //Setup 2 điểm đầu & cuối
            let originlocation = "\(10.766097),\(106.694153)"
            let destinationlocation = "\(10.758496),\(106.687753)"
        //khởi tạo url
        //nhớ, check url lên web
        let urltext = "https://maps.googleapis.com/maps/api/directions/json?origin=\(originlocation)&destination=\(destinationlocation)&mode=driving&key=\(google_api_key)"
        //đổi url thành URL
        let url = URL(string: urltext)
        print(url)
        //Lấy dữ liệu về
        //viết URLSession.shared.dataTask xong phải .resume, để nó thưc thi hàm này
        let task = URLSession.shared.dataTask(with: url!) { (data, res, err) in
            if err != nil {
                print(err?.localizedDescription)
            }
            else {
                do {
                    //Chuyển dữ liệu thành danh [String:Any]
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    //láy dữ liệu routes ra thôi
                    //Đổi rout thanh dạng Array
                    let routes = json["routes"] as! NSArray
                    //Cách 1
                    //Dùng hàm nay để chạy let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
//                    OperationQueue.main.addOperation({
//                        for route in routes
//                        {
//                            //láy dữ liệu overview_polyline ra dưới dạng NSDictionary
//                            let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
//                            //Lấy dữ liệu Points
//                            let points = routeOverviewPolyline.object(forKey: "points") as! String
//                            //Đổi point thanh path
//                            let path = GMSPath(fromEncodedPath: points)
//                            //gắn Path vào GMSPolyline
//                            let polyline = GMSPolyline(path: path)
//                            //Cấu hinh độ rộng
//                            polyline.strokeWidth = 3
//                            //Bound path lại
//                            let bound = GMSCoordinateBounds(path: path!)
//                            self.mapView.animate(with: GMSCameraUpdate.fit(bound, withPadding: 30.0))
//                            //Show ra map
//                            polyline.map = self.mapView
//
//                        }
//                    })
                    //Cách 2
                    //Phải có OperationQueue.main.addOperation mới call được API
                    OperationQueue.main.addOperation({
                        for route in routes {
                            let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                            let points = routeOverviewPolyline["points"] as! String
                            let path = GMSPath(fromEncodedPath: points)
                            let polyline = GMSPolyline(path: path)
                            polyline.strokeWidth = 3
                            polyline.map = self.mapView
                            //Lấy giái trị khoảng cách giữa 2 điểm
                            //                        let legs: NSArray = (route as! NSDictionary).value(forKey: "legs") as! NSArray
                            //                        for distance in legs {
                            //                            let distance1:NSDictionary = (distance as! NSDictionary).value(forKey: "distance") as! NSDictionary
                            //                            let value = distance1["value"] as! Int
                            //                        }
                            
                            
                        }

                    })
                }catch let err as NSError {
                    print(err)
                }
            }
        }.resume()



    }

}

