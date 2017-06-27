//
//  PublishPhotosController.swift
//  firesbaseDemoChats
//
//  Created by Jeremy Chai on 6/9/17.
//  Copyright © 2017 JiamingChai. All rights reserved.
//

import UIKit
import TLPhotoPicker

class PublishPhotosController: UIViewController, UINavigationControllerDelegate, TLPhotosPickerViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    var window: UIWindow?
    private let cellId = "cellId"
    
    var currentVC: ViewController = ViewController(nibName: nil, bundle: nil)
    var selectedAssets = [TLPHAsset]()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.row == selectedAssets.count{
            let viewController = TLPhotosPickerViewController()
            viewController.delegate = self
            viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
                self?.showAlert(vc: picker)
            }
            var configure = TLPhotosPickerConfigure()
            configure.numberOfColumn = 3
            configure.maxSelectedAssets = 5
            //configure.nibSet = (nibName: "CustomCell_Instagram", bundle: Bundle.main)
            viewController.configure = configure
            viewController.selectedAssets = self.selectedAssets
            
            self.present(viewController, animated: true, completion: nil)
        }
        
    }
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        self.selectedAssets = withTLPHAssets
        photoCellView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedAssets.count == 0 {
            return 1
        } else if selectedAssets.count == 1 {
            return 2
        } else if selectedAssets.count == 2{
            return 3
        } else if selectedAssets.count == 3{
            return 4
        } else if selectedAssets.count == 4{
            return 5
        } else {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! PhotoViewCell
        if indexPath.row == selectedAssets.count{
          cell.currentImageView.image = #imageLiteral(resourceName: "Icon-60")
        } else {
            let currentPhoto = selectedAssets[indexPath.row].fullResolutionImage
            cell.currentImageView.image = currentPhoto
            
        }
    
        return cell
    }

    override func viewDidLoad(){
        
        photoCellView.register(PhotoViewCell.self, forCellWithReuseIdentifier: cellId)
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        
        view.backgroundColor = UIColor(colorLiteralRed: 240/255, green: 248/255, blue: 255/255, alpha: 1)
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        view.addSubview(inputContainerView)
        view.addSubview(inputSeperatorView)
        view.addSubview(photoCellView)
        setupFrame()
        setupPhotoCellView()
        
        self.selectedAssets = currentVC.selectedAssets
    }
    
    func dismissPublishView(){
        navigationController?.popViewController(animated: true)
        
    }
    
    func uploadPhotoView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupFrame(){
        
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(view.frame.height * 0.33)).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        inputContainerView.addSubview(titleTextField)
        inputContainerView.addSubview(momentTextField)
        
        titleTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        titleTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        titleTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.5).isActive = true
        
        
        momentTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor).isActive = true
        momentTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        momentTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        momentTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.5).isActive = true
        
        
        inputSeperatorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputSeperatorView.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 20).isActive = true

        inputSeperatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        inputSeperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true

        photoCellView.topAnchor.constraint(equalTo: inputSeperatorView.bottomAnchor).isActive = true
        photoCellView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        photoCellView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        photoCellView.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.64).isActive = true
        

    }
    
    func setupPhotoCellView(){
        photoCellView.delegate = self
        photoCellView.dataSource = self
        photoCellView.isScrollEnabled = false
        
    }
    
    let photoCellView: UICollectionView = {
        
        let photoCellLayout = UICollectionViewFlowLayout()
        photoCellLayout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        photoCellLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 24) * 0.32, height: (UIScreen.main.bounds.width - 24) * 0.32)
        photoCellLayout.scrollDirection = .vertical
        let pcv = UICollectionView(frame: .infinite, collectionViewLayout: photoCellLayout)
        pcv.backgroundColor = UIColor(red:240/255, green: 248/255, blue: 255/255, alpha: 1)
        pcv.translatesAutoresizingMaskIntoConstraints = false
        
        
        return pcv
    }()
    
    let inputSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let inputContainerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(colorLiteralRed: 240/255, green: 248/255, blue: 255/255, alpha: 1)
        return view
    }()
    
    let titleTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .twitter
        tf.keyboardAppearance = .dark
        tf.placeholder = "标题"
        tf.clearButtonMode = .whileEditing
        tf.layer.masksToBounds = true
        tf.becomeFirstResponder()
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let momentTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .twitter
        tf.keyboardAppearance = .dark
        tf.placeholder = "在这里说点什么..."
        tf.clearButtonMode = .whileEditing
        tf.layer.masksToBounds = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    func showAlert(vc: UIViewController) {
        let alert = UIAlertController(title: nil, message: "最多只可以选 5 张照片", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "我知道了", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    

}

class PhotoViewCell: UICollectionViewCell {
    
    var currentImageView: UIImageView = {
        let temp = UIImageView()
        temp.frame = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width - 24) * 0.32, height: (UIScreen.main.bounds.width - 24) * 0.32)
        temp.clipsToBounds = true
        temp.contentMode = .scaleAspectFill
        return temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubview(currentImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView(){
    }
    
}


