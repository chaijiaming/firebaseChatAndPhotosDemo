//
//  LoginController.swift
//  firesbaseDemoChats
//
//  Created by Jeremy Chai on 5/15/17.
//  Copyright © 2017 JiamingChai. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:23/255, green: 63/255, blue: 111/255, alpha: 1)
        
        view.addSubview(inputContainerView)
        view.addSubview(loginRefisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginSegementControl)
        
        setInputContainerView()
        setLoginButton()
        setProfileImage()
        setupLoginSetementControl()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    

    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let loginRefisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red:80/255, green: 101/255,blue: 161/255, alpha: 1)
        button.setTitle("注册", for: .normal)
        button.setTitleColor(.white ,for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
        
    }()
    
    
    func handleLoginRegister(){
        if loginSegementControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else{
            handleRegister()
        }
    }
    
    func handleLogin(){
        guard let email = emailTextField.text, let password = PWTextField.text
            else{
                print("Form is invalid")
                return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user, error) in
            if error != nil {
                print(error!)
                return
            }
            
            // logged in our user
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func handleRegister(){
        guard let email = emailTextField.text, let password = PWTextField.text, let name = nameTextField.text
            else{
                print("Form is invalid")
                return
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user: FIRUser?, error ) in
            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.uid else{
                return
            }
            
            
            // Success!
            let ref = FIRDatabase.database().reference(fromURL: "https://testproject1-804df.firebaseio.com/")
            let values = ["Name": name, "Email": email]
            let userReference = ref.child("users").child(uid)
            userReference.updateChildValues(values, withCompletionBlock:{(err, ref)in
            
                if err != nil{
                    print(err!)
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
            
            })
            
            })
    }
    
    
    let nameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "名字"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeperaterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:220/255, green: 220/255,blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "电子邮箱"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeperaterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:220/255, green: 220/255,blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let PWTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "密码"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    
    
    let profileImageView: UIView = {
        let view = UIImageView()
        view.image = UIImage(named: "photo-video-slr-camera-icon-512x512-pixel-12")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let loginSegementControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["登陆", "注册"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginChange), for: .valueChanged)
        return sc
        
    }()
    
    
    
    
    
    func handleLoginChange(){
        
        let title = loginSegementControl.titleForSegment(at: loginSegementControl.selectedSegmentIndex)
        loginRefisterButton.setTitle(title, for: .normal)
        
        nameTextField.isHidden = loginSegementControl.selectedSegmentIndex == 0 ? true : false
        
        inputsContainerViewAnchor?.constant = loginSegementControl.selectedSegmentIndex == 0 ? 100 : 150
        
        nameTextFieldAnchor?.isActive = false
        nameTextFieldAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginSegementControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldAnchor?.isActive = true
        
        emailTextFieldAnchor?.isActive = false
        emailTextFieldAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginSegementControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldAnchor?.isActive = true
        
        PWTextFieldAnchor?.isActive = false
        PWTextFieldAnchor = PWTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginSegementControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        PWTextFieldAnchor?.isActive = true
        
        
        
        
    }
    
    var inputsContainerViewAnchor: NSLayoutConstraint?
    var nameTextFieldAnchor: NSLayoutConstraint?
    var emailTextFieldAnchor: NSLayoutConstraint?
    var PWTextFieldAnchor: NSLayoutConstraint?

    
    func setInputContainerView(){
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewAnchor?.isActive = true
        
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSeperaterView)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeperaterView)
        inputContainerView.addSubview(PWTextField)
        
        
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextFieldAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
            nameTextFieldAnchor?.isActive = true
        
        nameSeperaterView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeperaterView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperaterView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeperaterView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        emailTextFieldAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
            emailTextFieldAnchor?.isActive = true

        
        emailSeperaterView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeperaterView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperaterView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeperaterView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        PWTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        PWTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        PWTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        PWTextFieldAnchor = PWTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        PWTextFieldAnchor?.isActive = true
        
    }
    
    func setLoginButton(){
        loginRefisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRefisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        loginRefisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRefisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setProfileImage() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginSegementControl.topAnchor, constant: -30).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupLoginSetementControl(){
        loginSegementControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginSegementControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginSegementControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginSegementControl.heightAnchor.constraint(equalToConstant: 33).isActive = true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
}
