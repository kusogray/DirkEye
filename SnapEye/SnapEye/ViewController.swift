//
//  ViewController.swift
//  SnapEye
//
//  Created by whmou on 2017/4/15.
//  Copyright © 2017年 whmou. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //拍照
    @IBAction func TakePhoto(sender: AnyObject)
    {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){

            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil);
                
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

