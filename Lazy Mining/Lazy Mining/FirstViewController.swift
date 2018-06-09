//
//  FirstViewController.swift
//  Lazy Mining
//
//  Created by Admin on 3/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SocketIO

class ShowMode {
    static let MESSAGE_ONLY = "MESSAGE_ONLY"
    static let MESSAGE_AND_RIG_INFORMATION = "MESSAGE_AND_RIG_INFORMATION"
}
class WorkingStatus {
    static let STOPPED = "STOPPED"
    static let WARNING = "WARNING"
}
class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var minerTableView: UITableView!
    let manager = SocketManager(socketURL: URL(string: "http://lazymining.com")!, config: [.log(true), .compress])

  
    var timer: Timer?
    var heightArray = [CGFloat]()
    var sampleGpuTextView: UITextView = UITextView()
    var sampleMessageLabel: UILabel = UILabel()
    
    var miners: Dictionary<String, Any> = [:]
    var countdown = 10;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let socket = manager.defaultSocket

        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            socket.emit("test", "asdsa")
            
        }
        socket.on("test123") {[weak self] data, ack in
            print("RECEIVE DATA")
        }
        
        
        socket.connect()
        let cell = self.minerTableView.dequeueReusableCell(withIdentifier: "minerCell") as! MinerTableCell
        self.sampleGpuTextView = cell.gpuTextView
        self.sampleMessageLabel = cell.messageLabel
        connectSocket();
    }
    func connectSocket() -> Void {
    
    }
    override func viewDidAppear(_ animated: Bool) {
        self.updateMinerInfo();
        if (timer == nil) {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerUpdateMinerInfo), userInfo: nil, repeats: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
    }

    @objc func timerUpdateMinerInfo() {
        countdown -= 1
        countDownLabel.text = String(countdown) + " giây"
        if (countdown == 0) {
            countdown = 10;
            updateMinerInfo()
        }
    }
    
    func updateMinerInfo() {
        let token = LocalStorageService.shared().get(key: "token")
        let email = LocalStorageService.shared().get(key: "email")
        
        if (token == nil || email == nil) {
            return;
        }
        
        ApiService.shared().getMinerInfo(token: token!, email: email!, completion: { result in
            
            self.miners = result["miners"] as! Dictionary<String, Any>
            self.calculateHeights(miners: self.miners)
            self.minerTableView.reloadData()
            
        }, failed: {result in
            // nothing
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func calculateHeights(miners: Dictionary<String, Any>) {
        let minersArray = Array(miners)
        self.heightArray.removeAll()
        for var index in (0..<miners.count) {
            let miner = (minersArray[index].value) as! Dictionary<String, Any>
            
            
            self.sampleMessageLabel.lineBreakMode = .byTruncatingTail
            self.sampleMessageLabel.numberOfLines = 0
            self.sampleMessageLabel.text = (miner["warning_message"] as! String)
            let messageLabelSize = self.sampleMessageLabel.sizeThatFits(CGSize(width: self.sampleMessageLabel.frame.width, height: CGFloat.greatestFiniteMagnitude))
            
            let showMode = miner["show_mode"] as! String
            if (showMode == ShowMode.MESSAGE_AND_RIG_INFORMATION) {
                let gpuInfoText = self.getTempText(temps: miner["temps"] as! String,                mainCoinHr: miner["main_coin_hr"] as! String, mainSpeedUnit: miner["main_speed_unit"] as! String)
                self.sampleGpuTextView.text = gpuInfoText
                let gpuTextViewSize = self.sampleGpuTextView.sizeThatFits(CGSize(width: self.sampleGpuTextView.frame.width, height: CGFloat.greatestFiniteMagnitude))
                
                self.heightArray.append(215.0 + messageLabelSize.height + gpuTextViewSize.height)
            } else if (showMode == ShowMode.MESSAGE_ONLY) {
                self.heightArray.append(64.5 + messageLabelSize.height)
            }else if(showMode == ""){
                self.heightArray.append(215.0)
            }
            
        }
        
    }
    
    func getTempText(temps: String, mainCoinHr: String, mainSpeedUnit: String) -> String {
        let tempsValues = temps.split(separator: ";")
        let mainCoinHrValues = mainCoinHr.split(separator: ";")
        var gpuInfoText = ""
        for index in (0..<tempsValues.count/2) {
            let tempValue = String(tempsValues[index*2])
            let fanSpeedValue = String(tempsValues[index*2 + 1])
            let gpuSpeed = String(Float(mainCoinHrValues[index])! / 1000)
            if index > 0 {
                gpuInfoText += "\n"
            }
            gpuInfoText += "GPU" + String(index) + " (" + tempValue + "\u{00B0}C - " + fanSpeedValue + "%) - " + gpuSpeed + " " + mainSpeedUnit
        }
        return gpuInfoText
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.tag == 99) { // minerCell
            return self.miners.count
        } else if (tableView.tag == 97) { // gpuCell
            return 1
        }
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView.tag == 99) {
            var row = indexPath.row
            var length = self.heightArray.count
            return self.heightArray[indexPath.row]
        }
        return 215.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "minerCell", for: indexPath) as! MinerTableCell
    
        cell.messageLabel.lineBreakMode = .byTruncatingTail
        cell.messageLabel.numberOfLines = 0
        
        let miner = (Array(miners)[indexPath.row].value) as! Dictionary<String, Any>
        cell.rigNameLabel.text = miner["name"] as? String
        cell.ipLabel.text = (miner["public_ip"] as! String) + " (local: " + (miner["local_ip"] as! String) + ")"
        cell.messageLabel.text = miner["warning_message"] as? String
        
        let workingStatus = miner["working_status"] as? String
        if (WorkingStatus.STOPPED == workingStatus) {
            cell.bgView.backgroundColor = UIColor(red: 255/255.0, green: 96/255.0, blue: 101/255.0, alpha: 0.1)
            UIView.animate(withDuration: 0.8, delay: 0, options: [.repeat, .curveEaseIn], animations: {
                cell.bgView.backgroundColor = UIColor(red: 255/255.0, green: 96/255.0, blue: 101/255.0, alpha: 0.27)
            }, completion: { finished in
                // nothing
            })
        } else if (WorkingStatus.WARNING == workingStatus) {
            cell.bgView.backgroundColor = UIColor(red: 255/255.0, green: 250/255.0, blue: 120/255.0, alpha: 0.1)
            UIView.animate(withDuration: 0.8, delay: 0, options: [.repeat, .curveEaseIn], animations: {
                cell.bgView.backgroundColor = UIColor(red: 255/255.0, green: 250/255.0, blue: 120/255.0, alpha: 0.27)
            }, completion: { finished in
                // nothing
            })
        } else {
            cell.bgView.backgroundColor = UIColor.clear
        }
        
        let showMode = miner["show_mode"] as! String
        if (showMode == ShowMode.MESSAGE_ONLY) {
            return cell
        }
        
        cell.sumSpeedValueLabel.text = (miner["total_main_speed"] as! String) + " " + (miner["main_speed_unit"] as! String)
        
        let mainCoinValues = (miner["main_coin"] as! String).split(separator: ";")
        if (mainCoinValues.count > 2) {
            cell.sharesValueLabel.text = String(mainCoinValues[1])
            cell.rejectValueLabel.text = String(mainCoinValues[2])
        }
        cell.upTimeValueLabel.text = miner["uptime"] as? String
        cell.poolsValueLabel.text = miner["pools"] as? String
        
        cell.gpuTextView.text = ""
        cell.gpuTextView.text = getTempText(temps: miner["temps"] as! String, mainCoinHr: miner["main_coin_hr"] as! String, mainSpeedUnit: miner["main_speed_unit"] as! String)
        
        
    
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (_, indexPath) in
            let email = LocalStorageService.shared().get(key: "email")
            let miner = (Array(self.miners)[indexPath.row].value) as! Dictionary<String, Any>
            let machineID = miner["machine_id"] as! String
            
            ApiService.shared().deleteMiner(email: email!, machineID: machineID, completion: { (result) in
                // nothing
                
                dictLoop: for (key, _) in self.miners {
                    if(machineID == key){
                            self.miners.removeValue(forKey: key)
                            break
                    }
                    
                }
                self.calculateHeights(miners: self.miners)
                self.minerTableView.reloadData()

            }, failed: { (result) in
                // nothing
            })
        }
        
        let restart = UITableViewRowAction(style: .normal, title: "Restart") { (_, indexPath) in
            
            let email = LocalStorageService.shared().get(key: "email")
            let miner = (Array(self.miners)[indexPath.row].value) as! Dictionary<String, Any>
            let machineID = miner["machine_id"] as! String
            
            ApiService.shared().restartMiner(email: email!, machineID: machineID, completion: { (result) in
                // nothing
            }, failed: { (result) in
                // nothing
                
            })
        }
        restart.backgroundColor = UIColor(red: 254/255.0, green: 208/255.0, blue: 102/255.0, alpha: 255/255.0)
        
        return [delete, restart]
        
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
   
    

}

