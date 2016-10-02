//
//  FCLockNetwork.swift
//  FCLock
//
//  Created by Martin Walsh on 30/09/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import Alamofire
import SwiftyJSON

struct Auth0 {
    var client_id = ""
    var domain = ""
}

struct Token {
    var type = ""
    var id = ""
    var access = ""
}

class FCLockNetwork {
    
    var token = Token()
    var client = Auth0()
    
    init() {
        
        let bundle = Bundle.main.path(forResource: "Info", ofType: "plist")
        if let info = NSDictionary(contentsOfFile: bundle!) {
            
            guard let client_id = info["Auth0ClientId"],
                let domain = info["Auth0Domain"] else {
                    fatalError("Check Auth0 credentials (Auth0ClientId, Auth0Domain) set in Info.plist")
            }
            
            client.client_id = client_id as! String
            client.domain = domain as! String
        }
    }
    
    func authenticate(username: String, password: String, completion: @escaping (Bool) -> Void ) {
        
        var connection = "Username-Password-Authentication"
        
        // Quick check for numeric passcode, change connection mode
        if Int(password) != nil {
            connection = "email"
        }
        
        let parameters = ["client_id": client.client_id,
                          "username" : username,
                          "password" : password,
                          "connection" : connection,
                          "grant_type" : "password",
                          "scope" : "openid"]

        Alamofire.request("https://\(client.domain)/oauth/ro", method: .post, parameters: parameters,
                          encoding: JSONEncoding.default).validate().responseJSON { response in
                            
                            print(response.request)  // original URL request
                            print(response.response) // HTTP URL response
                            print(response.data)     // server data
                            print(response.result)   // result of response serialization
                            
                            switch response.result {
                            case .success(let body):
                                let tokenJSON = JSON(body)
                                
                                guard let token_type = tokenJSON["token_type"].string,
                                    let id_token = tokenJSON["id_token"].string,
                                    let access_token = tokenJSON["access_token"].string else {
                                        completion(false)
                                        return
                                }
                                
                                self.token.type = token_type
                                self.token.id = id_token
                                self.token.access = access_token
                                
                                completion(true)
                                
                            case .failure(let error):
                                print(error)
                                completion(false)
                            }
        }
    }
    
    func requestPasscode(username: String, completion: @escaping (Bool) -> Void ) {
        
        let parameters = ["connection" : "email",
                          "client_id": client.client_id,
                          "email" : username,
                          "send" : "code"]

        Alamofire.request("https://\(client.domain)/passwordless/start", method: .post, parameters: parameters,
                          encoding: JSONEncoding.default).validate().responseJSON { response in
                            
                            print(response.request)  // original URL request
                            print(response.response) // HTTP URL response
                            print(response.data)     // server data
                            print(response.result)   // result of response serialization
                            
                            switch response.result {
                                
                            case .success(let body):
                                let tokenJSON = JSON(body)
                                
                                guard let email = tokenJSON["email"].string, let id = tokenJSON["_id"].string else {
                                        completion(false)
                                        return
                                }
                                
                                print("Confirmation: \(id)\nEmail: \(email)")
                                
                                completion(true)
                                
                            case .failure(let error):
                                print(error)
                                completion(false)
                            }
        }
    }
    
}

