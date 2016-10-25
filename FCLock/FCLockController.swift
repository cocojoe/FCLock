//
//  FCLockController.swift
//  FCLock
//
//  Created by Martin Walsh on 30/09/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import UIKit
import SafariServices

enum authAction {
    case userNamePassword, passwordless, userNamePasscode
}

public class FCButton : UIButton {
    var authAction:authAction = .userNamePassword
}

public class FCLockController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: FCButton!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var facebookButton: UIButton!
    
    var safariViewController: SFSafariViewController?
    var XSRF:String?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Additional manual setup
        usernameField.delegate = self
        usernameField.layer.borderColor = UIColor.red.cgColor
        passwordField.delegate = self
        passwordField.layer.borderColor = UIColor.red.cgColor
        
        loginView.layer.cornerRadius = 4.0
        loginButton.layer.cornerRadius = 4.0
        
        // Apply theme colors
        applySkin(skin: FCLockConstants.ThemeDefault)
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func applySkin(skin: FCLockSkin) {
        view.backgroundColor = skin.backgroundColor
        loginView.backgroundColor = skin.boxColor
        
        usernameField.textColor = skin.inputTextColor
        passwordField.textColor = skin.inputTextColor
        
        loginButton.backgroundColor = skin.buttonColor
        loginButton.setTitleColor(skin.buttonTextColor, for: .normal)
        
    }
    
    @IBAction func authenticateUser(_ sender: AnyObject) {
        
        switch loginButton.authAction {
        case .userNamePassword, .userNamePasscode:
            authenticateUserNamePassword()
        case .passwordless:
            requestPasswordcode()
            
            // Expected next user action, passcode entry
            passwordField.placeholder = "Passcode"
        }
        
    }
    
    private func authenticateUserNamePassword() {
        
        // Reset Error(s)
        usernameField.hideError()
        passwordField.hideError()
        
        // Validate username/email
        // TODO: Soft email check
        if usernameField.text?.characters.count == 0 {
            usernameField.showError()
            return
        }
        
        // Validate password
        // TODO: Soft check minimum limit (if there is one)
        if passwordField.text?.characters.count == 0 {
            passwordField.showError()
            return
        }
        
        if let username = self.usernameField.text, let password = self.passwordField.text {
            FCLockManager.sharedInstance.authenticate(username: username, password: password) {
                self.view.scalePop()
                self.usernameField.showError()
                self.passwordField.showError()
            }
        }
    }
    
    private func requestPasswordcode() {
        
        // Reset Error(s)
        usernameField.hideError()
        passwordField.hideError()
        
        // Validate username/email
        // TODO: Soft email check
        if usernameField.text?.characters.count == 0 {
            usernameField.showError()
            return
        }
        
        if let username = self.usernameField.text {
            FCLockManager.sharedInstance.requestPasscode(username: username) {
                self.view.scalePop()
                self.usernameField.showError()
            }
        }
    }
    
    
    @IBAction func authenticateFacebook(_ sender: AnyObject) {
        
        guard let client = FCLockManager.sharedInstance.client.client_id,
              let URLScheme = FCLockManager.sharedInstance.URLScheme else { return }
        
        let nonce = randomString(length: 6) // Negate replay attacks
        let XSRF = FCLockManager.sharedInstance.generateXSRF()
        let requestURL = URL(string: "https://fcauth.eu.auth0.com/authorize?response_type=token&client_id=\(client)&connection=facebook&state=\(XSRF)&redirect_uri=\(URLScheme)://facebook&nonce=\(nonce)")
        
        print(requestURL)
        
        openSafari(URL: requestURL!)
        
    }
    
    func openSafari(URL: URL) {
        // Safari View Controller
        safariViewController = SFSafariViewController(url: URL)
        safariViewController?.delegate = self
        self.present(safariViewController!, animated: true, completion: nil)
    }
    
    func dismissSafari() {
        safariViewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension FCLockController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let password = passwordField.text
        let length   = password!.characters.count
        
        if textField == passwordField {
            self.view.endEditing(true)
            
            if length == 0 {
                loginButton.setTitle("Request Passcode", for: .normal)
                loginButton.authAction = .passwordless
                loginButton.enableButton()
            }
            
        } else {
            passwordField.becomeFirstResponder()
        }
        
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == passwordField {
            
            let password = passwordField.text
            let length   = password!.characters.count
            
            if length == 0 {
                loginButton.setTitle("Request Passcode", for: .normal)
                loginButton.authAction = .passwordless
            } else {
                loginButton.setTitle("LOGIN", for: .normal)
                loginButton.authAction = .userNamePasscode
            }
            
            loginButton.enableButton()
        }
        
        return true
    }
    
}

extension FCLockController : SFSafariViewControllerDelegate {
    
   public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.delegate = nil
        controller.dismiss(animated: true, completion: nil)
    }
}

