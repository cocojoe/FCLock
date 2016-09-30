//
//  FCLockController.swift
//  FCLock
//
//  Created by Martin Walsh on 30/09/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import UIKit

public struct FCLockSkin {
    var backgroundColor = Constants.Theme.Tone3
}

public class FCLockController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginView: UIView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        applySkin(skin: FCLockSkin())
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func applySkin(skin: FCLockSkin) {
        view.backgroundColor = skin.backgroundColor
    }
    
    @IBAction func authenticateUser(_ sender: AnyObject) {
        
        if let username = self.usernameField.text, let password = self.passwordField.text {
            FCLockManager.sharedInstance.authenticate(username: username, password: password) {
                print("Authentication failed")
            }
        }

    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
