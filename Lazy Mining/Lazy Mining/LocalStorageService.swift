//
//  LocalStorageService.swift
//  Lazy Mining
//
//  Created by Admin on 3/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class LocalStorageService {
    
    // MARK: -
    
    
    
    // Initialization
    
    private init() {
        // nothing
    }
    
    // MARK: - Properties
    
    private static var sharedLocalStorageService: LocalStorageService = {
        let localStorageService = LocalStorageService()
        
        // Configuration
        // ...
        
        return localStorageService
    }()
    
    
    // MARK: - Accessors
    
    class func shared() -> LocalStorageService {
        return sharedLocalStorageService
    }
    
    func set(key: String, value: String?) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    func get(key: String) -> String? {
        let defaults = UserDefaults.standard
        
        if let value = defaults.string(forKey: key)
        {
            return value
        }
        
        return nil
    }
    
}
