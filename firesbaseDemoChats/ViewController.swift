//
//  ViewController.swift
//  firesbaseDemoChats
//
//  Created by Jeremy Chai on 5/15/17.
//  Copyright © 2017 JiamingChai. All rights reserved.
//

import UIKit
import Firebase
import TLPhotoPicker

                    //UICollectionViewController
class ViewController: UITableViewController, TLPhotosPickerViewControllerDelegate {
    
    let cellID = "ID"
    var cView: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    var selectedAssets = [TLPHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "登出账户", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "用户列表", style: .plain, target: self, action: #selector(usersListsTable))
        
        
        
        
        
//        cView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
//        cView.delegate = self
//        cView.backgroundColor = UIColor.white
//        cView.dataSource = self
//        
//        self.view.addSubview(cView)
        
        setupCameraButton()
        
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        checkIfUserIsLoggedIn()
    }
    
//    init(){
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
//        layout.itemSize = CGSize(width: 111, height: 111)
//        super.init(collectionViewLayout: layout)
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        
//        
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 21
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
//        cell.backgroundColor = UIColor.orange
//        return cell
//    }
    
    func setupCameraButton(){
        
        let cameraButton = UIButton(type: .system)
        cameraButton.frame = CGRect(x: self.view.frame.width * 0.5 - 200, y: self.view.frame.size.height - 100, width: 150, height: 50)
        
        cameraButton.setTitle("拍照／选照片", for: .normal)
        cameraButton.setTitleColor(UIColor.white, for: .normal)
        cameraButton.backgroundColor = UIColor(red:80/255, green: 101/255,blue: 161/255, alpha: 1)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        cameraButton.addTarget(self, action: #selector(openMainCamera), for: .touchUpInside)
        self.view.addSubview(cameraButton)
        
        
    }
    
    func openMainCamera(){
        openCamera(animated: true)
    }
    
    func openCamera(animated: Bool){
        let viewController = PublishPhotosController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func checkIfUserIsLoggedIn(){
        if FIRAuth.auth()?.currentUser?.uid == nil{
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
                if let dictionary =  snapshot.value as? [String: AnyObject]{
                    self.navigationItem.title = dictionary["Name"] as? String
                }
            }, withCancel: nil)
        }
    }
    
    func handleLogout(){
        
        do{
            try FIRAuth.auth()?.signOut()
        } catch let logoutEror{
            print(logoutEror)
        }
        navigationController?.pushViewController(LoginController(), animated: true)
    }
    
    func usersListsTable(){
        navigationController?.pushViewController(NewMessageController(), animated: true)
    }
    
    //func setupImageView()
    //    {
    //        let photoController = PublishPhotosController()
    //        let scale = UIScreen.main.scale
    //        myImageView = UIImageView()
    //        myImageView.contentMode = .redraw
    //        myImageView.image = selectedAssets.popLast()?.fullResolutionImage
    //        myImageView.frame = CGRect(x: 10, y: self.view.frame.height * 0.6, width: scale * 30, height: scale * 30)
    //        photoController.view.addSubview(myImageView)
    //        self.addChildViewController(photoController)
    //
    //    }
    
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // use selected order, fullresolution image
        self.selectedAssets = withTLPHAssets
        dismissComplete()
    }
    
    
    func photoPickerDidCancel() {
        selectedAssets.removeAll()
    }
    
    func dismissComplete() {
        
        self.dismiss(animated: false, completion: nil)
        
        let postButton = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(uploadPhotoView))
        
        
        let publish = PublishPhotosController()
        publish.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(dismissPublishView))
        publish.navigationItem.rightBarButtonItem = postButton
        
        navigationController?.pushViewController(publish, animated: true)
        
    }
    
    func dismissPublishView(){
        self.navigationController?.popViewController(animated: true)
        self.openCamera(animated: true)
        
    }
    
    func uploadPhotoView(){
        self.navigationController?.popViewController(animated: true)
        
        // TODO: UPLOAD PHOTOS
    }
    
    
    func showAlert(vc: UIViewController) {
        let alert = UIAlertController(title: nil, message: "最多只可以选 5 张照片", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "我知道了", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
}




