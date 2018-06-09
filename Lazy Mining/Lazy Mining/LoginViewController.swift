//
//  LoginViewController.swift
//  Lazy Mining
//
//  Created by Admin on 3/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var forgotPasswordButton: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var goRegisterButton: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.updateLayoutButton(button: loginButton)
        
        let goRegisterTap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.goRegisterTapped))
        goRegisterButton.isUserInteractionEnabled = true
        goRegisterButton.addGestureRecognizer(goRegisterTap)
        
        let goForgotPwTap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.goForgotPwTapped))
        forgotPasswordButton.isUserInteractionEnabled = true
        forgotPasswordButton.addGestureRecognizer(goForgotPwTap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let token = LocalStorageService.shared().get(key: "token")
        if (token != nil) {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
            self.show(vc, sender: self)
        }
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
    
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        let devicePlatform = UIDevice.current.systemName
        let deviceModel = UIDevice.current.model
        let deviceVersion = UIDevice.current.systemVersion
        let deviceUUID = UIDevice.current.identifierForVendor?.uuidString
        
        loginButton.isEnabled = false;
        self.updateLayoutButton(button: loginButton)
        ApiService.shared().login(email: email, password: password,
                                  appVersion: appVersion as! String, devicePlatform: devicePlatform,
                                  deviceModel: deviceModel, deviceVersion: deviceVersion,
                                  deviceUUID: deviceUUID!, completion: { result in
            
            self.loginButton.isEnabled = true;
            self.updateLayoutButton(button: self.loginButton)
            
            let pushToken = InstanceID.instanceID().token()
            let token = result!["token"] as! String
            let email = result!["email"] as! String
            LocalStorageService.shared().set(key: "token", value: token)
            LocalStorageService.shared().set(key: "email", value: email)
            
            if (pushToken != nil) {
                ApiService.shared().updatePushToken(pushToken: pushToken!, token: token, email: email, completion: { (result) in
                    // nothing
                }, failed: { (result) in
                    // nothing
                })
            }
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
            self.show(vc, sender: self)
        }, failed: { result in
            
            self.loginButton.isEnabled = true;
            self.updateLayoutButton(button: self.loginButton)
            
            let errorCode = result!["response_code"] as! String
            if (ApiResponseCode.INVALID_AUTH_ERROR_CODE == errorCode) {
                let alertController = UIAlertController(title: "Lazy Mining", message:
                    "Mật mã không đúng.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Đóng", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLayoutButton(button: UIButton) {
        if (button.isEnabled) {
            button.backgroundColor = UIColor(red: 254/255.0, green: 208/255.0, blue: 102/255.0, alpha: 255/255.0)
        } else {
            button.backgroundColor = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 255/255.0)
        }
    }
    
    @IBAction func onLoginChanged(_ sender: Any) {
        if ((emailTextField.text?.isEmpty)!
            || (passwordTextField.text?.isEmpty)!) {
            loginButton.isEnabled = false;
            self.updateLayoutButton(button: loginButton)
            return;
        }
        loginButton.isEnabled = true;
        self.updateLayoutButton(button: loginButton)
    }
    
    @objc func goRegisterTapped(sender:UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "goRegisterSeque", sender: self)
    }
    
    @objc func goForgotPwTapped(sender:UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "test", sender: self)
    }
    
}


