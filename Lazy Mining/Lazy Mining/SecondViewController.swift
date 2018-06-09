//
//  SecondViewController.swift
//  Lazy Mining
//
//  Created by Admin on 3/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import MessageUI

extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(NSURL(string: url)! as URL) {
                application.openURL(NSURL(string: url)! as URL)
                return
            }
        }
    }
}

class SecondViewController: UIViewController {

    
    
    @IBOutlet weak var contactFacebookLabel: UILabel!
    @IBOutlet weak var contactEmailLabel: UILabel!
    @IBOutlet weak var lazyminingInfoLabel: UILabel!
    @IBOutlet weak var helloEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let displayName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        
        lazyminingInfoLabel.text = displayName + " - phiên bản " + version
        
        let email = LocalStorageService.shared().get(key: "email")
        helloEmailLabel.text = "Chào " + email!
        
        let contactFacebookTap = UITapGestureRecognizer(target: self, action: #selector(SecondViewController.contactFacebookTapped))
        contactFacebookLabel.isUserInteractionEnabled = true
        contactFacebookLabel.addGestureRecognizer(contactFacebookTap)
        
        let contactEmailTap = UITapGestureRecognizer(target: self, action: #selector(SecondViewController.contactEmailTapped))
        contactEmailLabel.isUserInteractionEnabled = true
        contactEmailLabel.addGestureRecognizer(contactEmailTap)
    }

    @objc func contactFacebookTapped(sender:UITapGestureRecognizer) {
        UIApplication.tryURL(urls: [
            "fb://profile/Lazy-Mining-797049757131819", // App
            "https://www.facebook.com/Lazy-Mining-797049757131819" // Website if app fails
            ])
    }
    
    @objc func contactEmailTapped(sender:UITapGestureRecognizer) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients(["vinh.thien0301@gmail.com"])
            mail.setSubject("Lazy Mining | Suggestion")
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogoutClicked(_ sender: Any) {
        let token = LocalStorageService.shared().get(key: "token");
        if (token == nil) {
            let storyboard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            self.dismiss(animated: true, completion: nil)
            self.show(vc, sender: self)
            
            return;
        }
        ApiService.shared().logout(token: token!, completion: { result in
            LocalStorageService.shared().set(key: "token", value: nil)
            LocalStorageService.shared().set(key: "email", value: nil)
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            self.dismiss(animated: true, completion: nil)
            self.show(vc, sender: self)
            
        }, failed: { result in
            // nothing
        })
    }
    
    
}

