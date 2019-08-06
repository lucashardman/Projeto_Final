//
//  LoginViewController.swift
//  AVIV
//
//  Created by Lucas on 11/03/19.
//  Copyright © 2018 Lucas. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    
    public var profileGenerated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLoginButton()
    }
    
    private func loadLoginButton(){
        
        let loginButton = UIButton(type: .custom)
        loginButton.backgroundColor = UIColor.darkGray
        loginButton.frame = CGRect(x: 0, y: 0, width: 180, height: 40)
        loginButton.center = view.center;
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)

        view.addSubview(loginButton)
    }
    
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email", "user_gender", "user_posts"], from: self, handler: { result, error in

            guard let result = result else {
                print("No result found")
                return
            }
            if result.isCancelled {
                print("Cancelled \(error?.localizedDescription ?? "unkown")")
            } else if let error = error {
                print("Process error \(error.localizedDescription)")
            } else {
                print("Logged in")
                GraphRequest(graphPath: "me", parameters: ["limit":"1000","fields": "name, id, gender, email, posts"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error != nil){
                        print(error ?? "unkown")
                        return
                    }
                    if let result = result as? Dictionary<String, Any>{
            
                        print(result)
                        
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "generateUserProfile") as! GenerateUserProfile
                        
                        if let id = result["id"] as? String{
                            print("My facebook id is \(id)")
                            newViewController.id = id
                        }
                        if let name = result["name"] as? String{
                            print("My name is \(name)")
                            newViewController.name = name
                        }
                        if let gender = result["gender"] as? String{
                            print("My gender is \(gender)")
                            newViewController.gender = gender
                        }
                        if let email = result["email"] as? String{
                            print("My e-mail is \(email)")
                            newViewController.email = email
                        }
                        
                        if let aux = result["posts"] as? Dictionary<String, Any>{
                            let posts = aux["data"] as! [Dictionary<String, Any>]
                            
                            newViewController.posts = posts
                        }
                        self.present(newViewController, animated: true, completion: nil)
                    }
                })
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
