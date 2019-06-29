//
//  LoginViewController.swift
//  AVIV
//
//  Created by Lucas on 11/03/19.
//  Copyright © 2018 Lucas. All rights reserved.
//

import UIKit
import FBSDKCoreKit
//import FacebookLogin
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
    
    //THIS FUNCTION WORKS WITH FBSDKLoginKit
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
//    //THIS FUNCION WORKS WITH FacebookLogin, BUT IS BUGGY
//    @objc func loginButtonClicked() {
//
//        let loginManager = LoginManager()
//        loginManager.logIn(readPermissions: [.publicProfile, .email, .userGender, .userPosts] , viewController: self){loginResult in
//
//            switch loginResult {
//            case .failed(let error):
//                print(error)
//            case .cancelled:
//                print("User cancelled login.")
//            case .success( _, _, _):
//                print("Logged in!")
//
//                let connection = GraphRequestConnection()
//                connection.add(FacebookProfileRequest()) { response, result in
//                    switch result {
//                    case .success(let response):
//
//                        //Prints de teste:
//                        print("I'm at Login Button Clicked, Facebook graph request")
//                        print("Custom Graph Request Succeeded: \(response)")
//                        print("My facebook id is \(response.id)")
//                        print("My name is \(response.name)")
//                        print("My gender is \(response.gender)")
//                        print("My e-mail is \(response.email)")
//
//                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "generateUserProfile") as! GenerateUserProfile
//
//                        newViewController.id = response.id
//                        newViewController.name = response.name
//                        newViewController.email = response.email
//                        newViewController.gender = response.gender
//                        newViewController.posts = response.posts
//
//                        self.present(newViewController, animated: true, completion: nil)
//
//                    case .failed(let error):
//                        print("Graph request at login have failed: \(error)")
//                    }
//                }
//                connection.start()
//            }
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
