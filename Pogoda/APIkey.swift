//
//  APIkey.swift
//  Pogoda
//
//  Created by Miguel Pelayo Mercado Caram on 3/28/21.
//

import Foundation

func valueForAPIKey(named keyname:String) -> String {
    let filePath = Bundle.main.path(forResource: "APIkeyInfo", ofType: "plist")
    let plist = NSDictionary(contentsOfFile:filePath!)
    let value = plist?.object(forKey: keyname) as! String
    
    return value
}
