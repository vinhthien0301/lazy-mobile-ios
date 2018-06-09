//
//  ApiService.swift
//  Lazy Mining
//
//  Created by Admin on 3/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Alamofire

class ApiResponseCode {
    
    static let UPDATE_PUSH_TOKEN_SUCCESS_CODE = "SUCC_UPDATE_PUSH_TOKEN"
    static let DELETE_MINER_SUCCESS_CODE = "SUCC_DELETE_MINER"
    static let RESTART_MINER_SUCCESS_CODE = "SUCC_RESET_MINER"
    static let LOGIN_SUCCESS_CODE = "SUCC_LOGIN"
    static let LOGOUT_SUCCESS_CODE = "SUCC_LOGOUT"
    static let REGISTER_SUCCESS_CODE = "SUCC_SIGNUP"
    static let MINERS_SUCCESS_CODE = "SUCC_MINERS"
    static let SUCC_EXEC = "SUCC_EXEC"
    static let SUCC_SEND_RESET_EMAIL = "SUCC_SEND_RESET_EMAIL"

    static let DELETE_MINERS_SUCCESS_CODE = "SUCC_DELETE_MINERS"
    static let TOKEN_NOT_FOUND_ERROR_CODE = "ERRO_NOT_FOUND"
    static let DELETE_MINER_ERROR_CODE = "ERRO_DELETE_MINER"
    static let ACCOUNT_EXISTING_ERROR_CODE = "ERRO_ACCOUNT_EXISTING"
    static let INVALID_AUTH_ERROR_CODE = "ERRO_INVALID_AUTH"
    
    
}


class ApiService {
    
    // MARK: -
    
    let baseURL: String
    
    
    // Initialization
    
    private init() {
        self.baseURL = Environment().configuration(PlistKey.ConnectionProtocol) + "://" + Environment().configuration(PlistKey.ServerURL)
    }
    
    // MARK: - Properties
    
    private static var sharedApiService: ApiService = {
        let apiService = ApiService()
        
        // Configuration
        // ...
        
        return apiService
    }()
    
    
    // MARK: - Accessors
    
    class func shared() -> ApiService {
        return sharedApiService
    }
    
    func getPublicIP(pushToken: String, token: String, email: String,
                         completion: @escaping (Dictionary<String, Any>)->(),
                         failed: @escaping (Dictionary<String, Any>)->()) {
        let parameters: Parameters = [
            "push_token": pushToken,
            "token": token,
            "email": email
        ]
        
        Alamofire.request(self.baseURL + "/push_token", method: HTTPMethod.post, parameters: parameters).responseJSON { response in
            
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                
                let response = json as! NSDictionary
                let code = response["response_code"] as! String
                if (ApiResponseCode.UPDATE_PUSH_TOKEN_SUCCESS_CODE == code) {
                    let data = response["data"]
                    if ((data) != nil) {
                        completion([:]);
                    } else {
                        completion((data as? Dictionary<String, Any>)!);
                    }
                } else {
                    failed(response as! Dictionary<String, Any>);
                }
                
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        };
    }
    
    func updatePushToken(pushToken: String, token: String, email: String,
                completion: @escaping (Dictionary<String, Any>)->(),
                failed: @escaping (Dictionary<String, Any>)->()) {
        let parameters: Parameters = [
            "push_token": pushToken,
            "token": token,
            "email": email
        ]
        
        Alamofire.request(self.baseURL + "/push_token", method: HTTPMethod.post, parameters: parameters).responseJSON { response in
            
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                
                let response = json as! NSDictionary
                let code = response["response_code"] as! String
                if (ApiResponseCode.UPDATE_PUSH_TOKEN_SUCCESS_CODE == code) {
                    let data = response["data"]
                    if ((data) != nil) {
                        completion([:]);
                    } else {
                        completion((data as? Dictionary<String, Any>)!);
                    }
                } else {
                    failed(response as! Dictionary<String, Any>);
                }
                
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        };
    }
    
    func logout(token: String,
                completion: @escaping (Dictionary<String, Any>)->(),
                failed: @escaping (Dictionary<String, Any>)->()) {
        let parameters: Parameters = [
            "token": token
        ]
        
        Alamofire.request(self.baseURL + "/logout", method: HTTPMethod.post, parameters: parameters).responseJSON { response in
            
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                
                let response = json as! NSDictionary
                let code = response["response_code"] as! String
                if (ApiResponseCode.LOGOUT_SUCCESS_CODE == code) {
                    let data = response["data"]
                    if ((data) != nil) {
                        completion([:]);
                    } else {
                        completion((data as? Dictionary<String, Any>)!);
                    }
                } else {
                    failed(response as! Dictionary<String, Any>);
                }
                
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        };
    }
    
    
    func forgotPassword(email: String,
                completion: @escaping (Dictionary<String, Any>)->(),
                failed: @escaping (Dictionary<String, Any>)->()) {
        let parameters: Parameters = [
            "email": email,
            "action": "grenade_token"
        ]
        
        Alamofire.request(self.baseURL + "/resetPasswordUser/send", method: HTTPMethod.post, parameters: parameters).responseJSON { response in
            
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                
                let response = json as! NSDictionary
                let code = response["response_code"] as! String
                completion(json as! Dictionary<String, Any>);

                
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        };
    }
    
    func deleteMiner(email: String, machineID: String,
                      completion: @escaping (Dictionary<String, Any>?)->(),
                      failed: @escaping (Dictionary<String, Any>?)->()) {
        let parameters: Parameters = [
            "email": email,
            "machine_id": machineID
        ]
        
        Alamofire.request(self.baseURL + "/delete_miner", method: HTTPMethod.post, parameters: parameters).responseJSON { response in
            
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                
                let response = json as! NSDictionary
                let code = response["response_code"] as! String
                if (ApiResponseCode.DELETE_MINER_SUCCESS_CODE == code) {
                    
                        let data = response["data"] as! NSObject
                        completion(data as? Dictionary<String, Any>);
                    
                    
                } else {
                    failed(response as? Dictionary<String, Any>);
                }
                
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        };
        
    }
    
    func restartMiner(email: String, machineID: String,
               completion: @escaping (Dictionary<String, Any>?)->(),
               failed: @escaping (Dictionary<String, Any>?)->()) {
        let parameters: Parameters = [
            "email": email,
            "machine_id": machineID
        ]
        
        Alamofire.request(self.baseURL + "/restart_miner", method: HTTPMethod.post, parameters: parameters).responseJSON { response in
            
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                
                let response = json as! NSDictionary
                let code = response["response_code"] as! String
                if (ApiResponseCode.RESTART_MINER_SUCCESS_CODE == code) {
                    completion("" as? Dictionary<String, Any>);

                   
                } else {
                    failed(response as? Dictionary<String, Any>);
                }
                
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        };
        
    }
    
    func login(email: String, password: String,
               appVersion: String, devicePlatform: String,
               deviceModel: String, deviceVersion: String,
               deviceUUID: String,
               completion: @escaping (Dictionary<String, Any>?)->(),
               failed: @escaping (Dictionary<String, Any>?)->()) {
        let parameters: Parameters = [
            "email": email,
            "password": password,
            "app_version": appVersion,
            "device_platform": devicePlatform,
            "device_model": deviceModel,
            "device_version": deviceVersion,
            "device_uuid": deviceUUID
        ]
        
        Alamofire.request(self.baseURL + "/login", method: HTTPMethod.post, parameters: parameters).responseJSON { response in
        
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                
                let response = json as! NSDictionary
                let code = response["response_code"] as! String
                if (ApiResponseCode.LOGIN_SUCCESS_CODE == code) {
                    let data = response["data"] as! NSDictionary
                    completion(data as? Dictionary<String, Any>);
                } else {
                    failed(response as? Dictionary<String, Any>);
                }
                
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        };
        
    }
    
    func register(email: String, password: String,
                  appVersion: String, devicePlatform: String,
                  deviceModel: String, deviceVersion: String,
                  deviceUUID: String,
                  completion: @escaping (Dictionary<String, Any>)->(),
                  failed: @escaping (Dictionary<String, Any>)->()) {
        
        
        
        let parameters: Parameters = [
            "email": email,
            "password": password,
            "app_version": appVersion,
            "device_platform": devicePlatform,
            "device_model": deviceModel,
            "device_version": deviceVersion,
            "device_uuid": deviceUUID,
        ]
        
        Alamofire.request(self.baseURL + "/signup", method: HTTPMethod.post, parameters: parameters).responseJSON { response in
            
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                
                let response = json as! NSDictionary
                let code = response["response_code"] as! String
                if (ApiResponseCode.REGISTER_SUCCESS_CODE == code) {
                    let data = response["data"] as! NSDictionary
                    completion((data as? Dictionary<String, Any>)!);
                } else {
                    failed(response as! Dictionary<String, Any>);
                }
                
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        };
        
    }
    
    func getMinerInfo(token: String, email: String,
                      completion: @escaping (Dictionary<String, Any>)->(),
                      failed: @escaping (Dictionary<String, Any>)->()) {
        
        let parameters: Parameters = [
            "token": token,
            "email": email
        ]
        
        Alamofire.request(self.baseURL + "/miners", method: HTTPMethod.post, parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                
                let response = json as! NSDictionary
                let code = response["response_code"] as! String
                if (ApiResponseCode.MINERS_SUCCESS_CODE == code) {
                    let data = response["data"] as! NSDictionary
                    completion((data as? Dictionary<String, Any>)!);
                } else {
                    failed(response as! Dictionary<String, Any>);
                }
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        };
        
    }
}

