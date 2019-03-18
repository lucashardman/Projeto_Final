//
//  LoginViewController.swift
//  AVIV
//
//  Created by Lucas on 11/03/19.
//  Copyright © 2018 Lucas. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        loginManager.logIn(readPermissions: [.publicProfile, .email, .userGender, .userPosts] , viewController: self){loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            //case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            case .success( _, _, _):
                print("Logged in!")
                
                //let facebook = ProcessFacebookData()
                let connection = GraphRequestConnection()
                connection.add(FacebookProfileRequest()) { response, result in
                    switch result {
                    case .success(let response):
                        
                        //Prints de teste:
                        print("I'm at Login Button Clicked, Facebook graph request")
                        print("Custom Graph Request Succeeded: \(response)")
                        print("My facebook id is \(response.id)")
                        print("My name is \(response.name)")
                        print("My gender is \(response.gender)")
                        print("My e-mail is \(response.email)")
                        
                        let profile = GenerateUserProfile.init()
                        
                        profile.sendUserInfoToFirebase(
                            id: response.id,
                            name: response.name,
                            email: response.email,
                            gender: response.gender,
                            posts: response.posts)
                        
                    case .failed(let error):
                        print("Graph request at login have failed: \(error)")
                    }
                }
                connection.start()
 
                //Change view to Tab Bar Controller
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabBarController")
                self.present(newViewController, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
