//
//  RegisterViewController.swift
//  Lazy Mining
//
//  Created by Admin on 3/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var retypePasswordTextField: UITextField!
    
    @IBOutlet weak var goLoginButton: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerButton.backgroundColor = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 255/255.0)
        
        let goLoginTap = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.goLoginTapped))
        goLoginButton.isUserInteractionEnabled = true
        goLoginButton.addGestureRecognizer(goLoginTap)
    }
    
    func getIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    if let name: String = String(cString: (interface?.ifa_name)!), name == "en0" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }
    
    @IBAction func onRegisterButton(_ sender: Any) {
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let retypePassword = retypePasswordTextField.text!
        if (password != retypePassword) {
            let alertController = UIAlertController(title: "Lazy Mining", message:
                "Mật mã không trùng khớp.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Đóng", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return;
        }
        
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        let devicePlatform = UIDevice.current.systemName
        let deviceModel = UIDevice.current.model
        let deviceVersion = UIDevice.current.systemVersion
        let deviceUUID = UIDevice.current.identifierForVendor?.uuidString
        
        self.registerButton.isEnabled = false
        self.updateLayoutButton(button: self.registerButton)
        
        ApiService.shared().register(email: email, password: password,
                                  appVersion: appVersion as! String, devicePlatform: devicePlatform,
                                  deviceModel: deviceModel, deviceVersion: deviceVersion,
                                  deviceUUID: deviceUUID!, completion: { result in
            
            self.registerButton.isEnabled = true
            self.updateLayoutButton(button: self.registerButton)
                                    
            let token = result["token"] as! String
            let email = result["email"] as! String
            LocalStorageService.shared().set(key: "token", value: token)
            LocalStorageService.shared().set(key: "email", value: email)
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
            self.show(vc, sender: self)
        }, failed: {result in
            self.registerButton.isEnabled = true
            self.updateLayoutButton(button: self.registerButton)
            
            let responseCode = result["response_code"] as! String
            if (responseCode == ApiResponseCode.ACCOUNT_EXISTING_ERROR_CODE) {
                let alertController = UIAlertController(title: "Lazy Mining", message:
                    "Email đã tồn tại.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Đóng", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Lazy Mining", message:
                    result["description"] as? String, preferredStyle: UIAlertControllerStyle.alert)
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
    
    @IBAction func onRegisterChanged(_ sender: Any) {
        if ((emailTextField.text?.isEmpty)!
            || (passwordTextField.text?.isEmpty)!
            || (retypePasswordTextField.text?.isEmpty)!) {
            
            registerButton.backgroundColor = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 255/255.0)
            registerButton.isEnabled = false;
            return;
        }
        registerButton.backgroundColor = UIColor(red: 254/255.0, green: 208/255.0, blue: 102/255.0, alpha: 255/255.0)
        registerButton.isEnabled = true;
        
    }
    
    @objc func goLoginTapped(sender:UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "goLoginSeque", sender: self)
    }
    
}



