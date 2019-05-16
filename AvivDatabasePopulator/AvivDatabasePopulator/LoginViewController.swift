//
//  LoginViewController.swift
//  AVIV
//
//  Created by Lucas on 16/05/19.
//  Copyright © 2018 Lucas. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var imageField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadForm()
       // loadLoginButton()
    }
    
    private func loadForm(){
        descriptionField.layer.borderWidth = 1
        descriptionField.layer.cornerRadius = 5
        descriptionField.layer.borderColor = UIColor.lightGray.cgColor
        
        sendButton.layer.cornerRadius = 5
        sendButton.backgroundColor = UIColor.darkGray
        sendButton.tintColor = UIColor.white
        sendButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
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
    
    private func verifyFields() -> Bool{
        
        if nameField.text == "" {
            print("Nome invalido")
            return false
        }
        if cityField.text == ""{
            print("Cidade invalida")
            return false
        }
        if categoryField.text == ""{
            print("Categoria invalida")
            return false
        }
        if linkField.text == ""{
            print("Link invalido")
            return false
        }
        if imageField.text == ""{
            print("Imagem invalida")
            return false
        }
        if descriptionField.text == ""{
            print("Descrição invalida")
            return false
        }
        return true
    }
    
    @objc func loginButtonClicked() {
        
        //Verifica se os campos foram preenchidos
        if verifyFields() == true{
            
            //Pede permissão ao Facebook
            let loginManager = LoginManager()
            loginManager.logIn(readPermissions: [.publicProfile, .email, .userGender, .userPosts] , viewController: self){loginResult in
                switch loginResult {
                case .failed(let error):
                    print(error)
                case .cancelled:
                    print("User cancelled login.")
                case .success( _, _, _):
                    print("Logged in!")
                    
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
                                name: self.nameField.text!,
                                city: self.cityField.text!,
                                category: self.categoryField.text!,
                                link: self.linkField.text!,
                                image: self.imageField.text!,
                                description: self.descriptionField.text!,
                                id: response.id,
                                posts: response.posts)
                            
                        case .failed(let error):
                            print("Graph request at login have failed: \(error)")
                        }
                    }
                    connection.start()
                    
                    //Change view to Tab Bar Controller
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "sendViewController")
                    self.present(newViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
