//
//  Login.swift
//  roomiesapp
//
//  Created by Gebruiker on 18-06-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase



class Login: UIViewController {
    
    @IBOutlet weak var signInSelector: UISegmentedControl!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var UsernameLabel: UILabel!
    
    var ref: DatabaseReference!
    var isSignin: Bool = false
    var dataBaseHandle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInSelectorChange(signInSelector)
        ref = Database.database().reference()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func signInSelectorChange(_ sender: UISegmentedControl) {
        // flip boolian
        isSignin = !isSignin
        if isSignin {
            signInLabel.text = "Sign in"
            UsernameLabel.isHidden = true
            UsernameTextField.isHidden = true
            submitButton.setTitle("Sign in", for: .normal)
        }
        else {
            UsernameLabel.isHidden = false
            UsernameTextField.isHidden = false
            signInLabel.text = "Register"
            submitButton.setTitle("Register", for: .normal)
        }
        
    }
    @IBAction func SignInButtonTapped(_ sender: UIButton) {
        // Check if register or signin
        if let email = emailTextField.text, let password = passwordTextField.text, let username = UsernameTextField.text {
        
            // sign in user with firebase
            if isSignin {
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    return
                    }
                    
                    let userID = Auth.auth().currentUser!.uid
       
                    UsersInfo.username.append(username)
                    print("username: \(username)");
                    print("userID: \(userID)");
                    UsersInfo.userID.append(userID)
                    self.performSegue(withIdentifier: "goToHomeScreen", sender: self)    
                })
            }
                
            else {
                //register user with firebase
                Auth.auth().createUser(withEmail: email, password: password, completion:  { (user, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    let userID = Auth.auth().currentUser!.uid
                    UsersInfo.username.append(username)
                    UsersInfo.userID.append(userID)
                    let PathUserID = self.ref.child("Users").child(userID).child("UserInfo")
                    PathUserID.setValue(["username": username, "email": email])
                    self.performSegue(withIdentifier: "goToHomeScreen", sender: self)
                })
            }
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    struct UsersInfo  {
        static var username = String()
        static var userID = String()
        static var roommates = [String]()
    }
    
}
