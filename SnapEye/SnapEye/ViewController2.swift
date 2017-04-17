//
//  ViewController2.swift
//  SnapEye
//
//  Created by Larry H Chen (RD-TW) on 18/04/2017.
//  Copyright © 2017 whmou. All rights reserved.
//

import UIKit

class ViewController2: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {

    @IBOutlet weak var imageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //imageView.image = UIImage(named:"")
        imageView.image = #imageLiteral(resourceName: "add")
        //imageView = UIImageView(image: UIImage(named: "add.png"))

        // Do any additional setup after loading the view.
    }
    
    //take photo
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
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("didFinishPickingImage")
        
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) //save photo to album
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePickerControllerDidCancel")
        dismiss(animated: true, completion: nil)
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
