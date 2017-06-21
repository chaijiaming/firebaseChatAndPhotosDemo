//
//  CameraViewController.swift
//  firesbaseDemoChats
//
//  Created by Jeremy Chai on 5/24/17.
//  Copyright © 2017 JiamingChai. All rights reserved.
//

import UIKit
import TLPhotoPicker

class CameraViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    var selectedAssets = [TLPHAsset]()
    var myImageView: UIImageView!
    var showImagePicketButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "使用", style: .plain, target: self, action: #selector(handlePhoto))
        
        navigationItem.title = "照片"
        
        
        
        setupImagePickerButton()
        
        setupImageView()
        
    }
    func handleCancel(){
        navigationController?.popViewController(animated: true)
    }
    
    func handlePhoto(){
        // TODO: upload photos to firebase
        navigationController?.popViewController(animated: true)
    }
    
    func setupImagePickerButton()
    {
        let button = UIButton(type: UIButtonType.system) as UIButton
        let cameButton = UIButton(type: UIButtonType.system) as UIButton
        
        
        button.frame = CGRect(x: 0, y: self.view.frame.size.height - 50, width: self.view.frame.width*0.5, height: 45)
        
        button.backgroundColor = UIColor.lightGray
        button.setTitle("选择照片", for: UIControlState.normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(CameraViewController.displayImagePickerButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        
        cameButton.frame = CGRect(x: self.view.frame.width*0.5, y: self.view.frame.size.height - 50, width: self.view.frame.width*0.5, height: 45)
        cameButton.backgroundColor = UIColor.lightGray
        cameButton.setTitle("现在拍摄", for: UIControlState.normal)
        cameButton.tintColor = UIColor.black
        cameButton.addTarget(self, action: #selector(CameraViewController.cameraView(_:)), for: .touchUpInside)
        self.view.addSubview(cameButton)
        
    }
    
    func cameraView(_ sender: UIButton!) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            let camPickerController = UIImagePickerController()
            camPickerController.delegate = self
            camPickerController.sourceType = UIImagePickerControllerSourceType.camera
        
            self.present(camPickerController, animated: true, completion: nil)
            
          
            //navigationController?.pushViewController(camPickerController, animated: true)
            
            //let nav = UINavigationController(rootViewController: camPickerController)
            //navigationController?.pushViewController(nav, animated: true)
        }
        
    }
    
    func setupImageView()
    {
        
        myImageView = UIImageView()
        
        myImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.size.height - 60)
        myImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        self.view.addSubview(myImageView)
    }
    
    func displayImagePickerButtonTapped(_ sender:UIButton!) {
        
        let myPickerController = TLPhotosPickerViewController()
        myPickerController.delegate = self as? TLPhotosPickerViewControllerDelegate
        self.present(myPickerController, animated: true, completion: nil)
        //navigationController?.pushViewController(myPickerController, animated: true)
        //let nav = UINavigationController(rootViewController: myPickerController)
        //navigationController?.pushViewController(nav, animated: true)
    }
    
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // use selected order, fullresolution image
        self.selectedAssets = withTLPHAssets
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        myImageView.reloadInputViews()
        myImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        myImageView.backgroundColor = UIColor.gray
        myImageView.contentMode = UIViewContentMode.scaleAspectFit
        dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
