//
//  ViewController.swift
//  twitter
//
//  Created by McTavish Wang on 15/9/27.
//  Copyright (c) 2015年 McTavish Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var ref = Firebase(url: "https://testrealtime.firebaseio.com/")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {

        if ref.authData != nil {
            println("there is a user already signed in")
            self.performSegueWithIdentifier("loginAndSignUpComplete", sender: self)
        }
        else{println("you need to login or signup")}
        
    }
    
    @IBAction func login(sender: AnyObject) {
        
        if emailTextField.text == "" || passwordTextField.text == ""{
        
                println("make sure to enter all fields")
            
        }else{
        
            ref.authUser(emailTextField.text, password: passwordTextField.text, withCompletionBlock: {
                (error, authData) -> Void in
                if error != nil {
                    println(error)
                    println("there is an error")
                }else{
                    println("login success")
                    self.performSegueWithIdentifier("loginAndSignUpComplete", sender: self)
                }
            })
            
        }
        
    }

    @IBAction func signup(sender: AnyObject) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
        
            println("make sure to enter in each textfield")
        
        }else{
        
            ref.createUser(emailTextField.text, password: passwordTextField.text, withValueCompletionBlock: {
                (error, result) -> Void in
                if error != nil{
                
                    println(error)
                    
                }else{
                
                    println("success sign up!")
                    
                    self.ref.authUser(self.emailTextField.text, password: self.passwordTextField.text, withCompletionBlock: {
                    (error, authData) -> Void in
                        
                        if(error != nil)
                        {
                            println(error)
                            println("there is an error with your given information")
                        }
                        else{
                            var userId = authData.uid // use id is unique for every user accross all devices
                            
                            let newUser = [
                                "provider": authData.provider,
                                "email": authData.providerData["email"] as? String
                            ]
                            
                            let fakePost=[
                                "\(NSDate())":"this is my first fake Post",
                                "\(NSDate())2":"this is my second fake Post"
                            ]
                            
                            self.ref.childByAppendingPath("users").childByAppendingPath(authData.uid).setValue(newUser)
                            self.ref.childByAppendingPath("users/\(authData.uid)/post").setValue(fakePost)
                        
                            //finish signing up, segue
                            self.performSegueWithIdentifier("loginAndSignUpComplete", sender: self)
                        }
                    
                    })
                    
                    
                }
            
            })
        
        }
        
        
        
    }
}

