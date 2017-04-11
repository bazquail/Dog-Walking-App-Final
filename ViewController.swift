//
//  ViewController.swift
//  Do Walking App
//
//  Created by Elias Topp on 10/11/16.
//  Copyright © 2016 Topp Minds. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTXT.delegate = self
        passwordTXT.delegate = self
        
        /*FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "toWalkerView", sender: self)
            }
        }*/
    }
    
    @IBAction func logInBtn(_ sender: AnyObject) {
        
        //FIRAuth.auth()!.signIn(withEmail: usernameTXT.text!, password: passwordTXT.text!)
        
        if emailTXT.text! == UserDefaults.standard.string(forKey: "username") && passwordTXT.text! == UserDefaults.standard.string(forKey: "password") {
            self.performSegue(withIdentifier: "toWalkerView", sender: self)
        }
    }

    @IBOutlet weak var emailTXT: UITextField!
    @IBOutlet weak var passwordTXT: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func createAccount(_ sender: Any) {
        
        let alert = UIAlertController(title: "Create your account", message: "Passwords must be at least 6 characters long.", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            let usernameField = alert.textFields![2]
            
            UserDefaults.standard.set(usernameField.text, forKey: "username")
            UserDefaults.standard.set(emailField.text, forKey: "email")
            UserDefaults.standard.set(passwordField.text, forKey: "password")
            
            /*FIRAuth.auth()!.createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                if error == nil {
                    FIRAuth.auth()!.signIn(withEmail: self.usernameTXT.text!, password: self.passwordTXT.text!)
                }
            }*/
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addTextField { textUsername in
            textUsername.placeholder = "Enter your username"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

