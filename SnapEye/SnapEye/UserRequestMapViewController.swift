//
//  UserRequestMapViewController.swift
//  SnapEye
//
//  Created by whmou on 2017/4/19.
//  Copyright © 2017年 whmou. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class UserRequestMapViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
    CLLocationManagerDelegate,
MKMapViewDelegate {

    var isKeyboardExist = false;
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    

    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
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
        
        let gestureRecognizer = UILongPressGestureRecognizer(
            target: self, action:(#selector(longPress)
            )
        )
        gestureRecognizer.minimumPressDuration = 0.6
        mapView.addGestureRecognizer(gestureRecognizer)
        
        // -------- Maps End------------ //
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func longPress(gestureRecognizer: UILongPressGestureRecognizer) {
        //let coordinate = mapView.centerCoordinate
        let annotation = MKPointAnnotation()
        var touchPoint = gestureRecognizer.location(in: mapView)
        var newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        annotation.coordinate = newCoordinates
        self.mapView.removeAnnotations(self.mapView.annotations)
        mapView.addAnnotation(annotation)
    }
    
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
        }
    }
    
   
    
    var location: CLLocation!
    @IBAction func userLocatButtonAction(_ sender: Any) {
        self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
        //print ( String(self.mapView.userLocation.coordinate.latitude))
        //print ( String(self.mapView.userLocation.coordinate.longitude))

    }
    
   
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        self.view.frame.origin.y = 0
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBOutlet weak var userDesInputField: UITextView!
    
    @IBOutlet weak var textBottom: UITextView!
    
    func keyboardWillShow(notification: NSNotification) {
        if (isKeyboardExist == false) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                    isKeyboardExist = true
                    
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if (isKeyboardExist == true){
            
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0{
                    self.view.frame.origin.y += keyboardSize.height
                    isKeyboardExist = false
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
