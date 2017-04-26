//
//  EyerRequest.swift
//  SnapEye
//
//  Created by whmou on 2017/4/19.
//  Copyright © 2017年 whmou. All rights reserved.
//

import UIKit
import MapKit

class CustomPointAnnotation: MKPointAnnotation {
    var pinCustomImageName:String!
}

class EyerRequest: UIViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    CLLocationManagerDelegate,
MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var init_x = 0.0
    var init_y = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // -------- Maps ------------ //
        
        
        // 設置委任對象
        mapView.delegate=self;
        locationManager.delegate = self
        
        // 距離篩選器 用來設置移動多遠距離才觸發委任方法更新位置
        locationManager.distanceFilter =
        kCLLocationAccuracyNearestTenMeters
        
        // 取得自身定位位置的精確度
        locationManager.desiredAccuracy =
        kCLLocationAccuracyBest
        
        
        // 首次使用 向使用者詢問定位自身位置權限
        if CLLocationManager.authorizationStatus()
            == .notDetermined {
            // 取得定位服務授權
            locationManager.requestWhenInUseAuthorization()
            
            // 開始定位自身位置
            locationManager.startUpdatingLocation()
        }
            // 使用者已經拒絕定位自身位置權限
        else if CLLocationManager.authorizationStatus()
            == .denied {
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController(
                title: "定位權限已關閉",
                message:
                "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "確認", style: .default, handler:nil)
            alertController.addAction(okAction)
            self.present(
                alertController,
                animated: true, completion: nil)
        }
            // 使用者已經同意定位自身位置權限
        else if CLLocationManager.authorizationStatus()
            == .authorizedWhenInUse {
            // 開始定位自身位置
            locationManager.startUpdatingLocation()
        }
        
        // 地圖預設顯示的範圍大小 (數字越小越精確)
        let latDelta = 0.004
        let longDelta = 0.004
        let currentLocationSpan:MKCoordinateSpan =
            MKCoordinateSpanMake(latDelta, longDelta)
        //
        //        // 設置地圖顯示的範圍與中心點座標
        
        //        let center:CLLocation = CLLocation(
        //            latitude: (locationManager.location?.coordinate.latitude)!
        //            , longitude: (locationManager.location?.coordinate.latitude)!)
        
        let leti = locationManager.location?.coordinate.latitude
        let loni = locationManager.location?.coordinate.longitude
        
        let center = CLLocationCoordinate2D(
            latitude: leti!,
            longitude: loni!)
        
        let currentRegion:MKCoordinateRegion =
            MKCoordinateRegion(
                center: center,
                span: currentLocationSpan)
        
        
        mapView.setRegion(currentRegion, animated: true)
        
        
        var info2 = CustomPointAnnotation()
        info2.coordinate = CLLocationCoordinate2DMake(leti!+0.003, loni!+0.003)
        info2.title = "Info2"
        info2.subtitle = "Subtitle"
        info2.pinCustomImageName = "camera-icon.png"
        
//        let annotation = MKPointAnnotation()
//        var newCoordinates = mapView.convert(CGPoint(x: (init_x), y: (init_y)), toCoordinateFrom: mapView)
        //annotation.coordinate = newCoordinates
        
        mapView.addAnnotation(info2)
        
        
        // -------- Maps End------------ //

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
            init_x = location.coordinate.latitude
            init_y = location.coordinate.longitude
        }
    }

    

    @IBAction func eyerLoacteButtonPush(_ sender: Any) {
        self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.canShowCallout = true
        }
        else {
            anView?.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        anView?.image = UIImage(named:cpa.pinCustomImageName)
        anView?.frame.size = CGSize(width: 30.0, height: 30.0)
        
        return anView
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
