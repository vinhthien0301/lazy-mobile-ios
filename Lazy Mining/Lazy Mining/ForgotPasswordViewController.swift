//
//  ForgotPasswordViewController.swift
//  Lazy Mining
//
//  Created by doan ngoc duc on 3/17/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

class ForgotPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var goBackButton: UILabel!
    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let goBackTap = UITapGestureRecognizer(target: self, action: #selector(ForgotPasswordViewController.goBackTap))
        goBackButton.isUserInteractionEnabled = true
        goBackButton.addGestureRecognizer(goBackTap)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ForgotPasswordViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func goBackTap(sender:UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "goBack", sender: self)
    }
    
    @IBAction func onSendEmailForgot(_ sender: Any) {
        let email = emailTextField.text!
        if(email.isEmpty){
            let alertController = UIAlertController(title: "Lazy Mining", message:
                "không được để trống email.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Đóng", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return;
        }
        
        ApiService.shared().forgotPassword(email: email, completion: { result in
            let response_code = result["response_code"] as! String
            if(response_code == ApiResponseCode.SUCC_SEND_RESET_EMAIL){
                self.showAlert(content: "hãy kiểm tra email để nhận thông tin đăng nhập")
            }else{
                self.showAlert(content: result["description"] as! String)
            }
            
        }, failed: { result in
            
            self.showAlert(content: "Lỗi mạng.")

        })
        
        
        
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func showAlert(content: String) {
        let alertController = UIAlertController(title: "Lazy Mining", message:
            content, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Đóng", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
}
