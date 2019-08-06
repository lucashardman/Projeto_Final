//
//  LoginViewController.swift
//  AVIV
//
//  Created by Lucas on 16/05/19.
//  Copyright © 2018 Lucas. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var provinceField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var imageField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadForm()
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
        
        let listOfCategory = ["Natureza", "Arte", "Cultura", "Vida Noturna", "Landmarks", "Gastronomia", "Compras", "Esportes", "família", "Negócios", "Tecnologia"]
        
        let alert = UIAlertController(title: "Ops!", message: "Há campos inválidos ou em branco.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        if nameField.text == "" {
            print("Nome invalido")
            self.present(alert, animated: true)
            return false
        }
        if cityField.text == ""{
            print("Cidade invalida")
            self.present(alert, animated: true)
            return false
        }
        if provinceField.text == ""{
            print("Província invalida")
            self.present(alert, animated: true)
            return false
        }
        if countryField.text == ""{
            print("País invalido")
            self.present(alert, animated: true)
            return false
        }
        if !listOfCategory.contains(categoryField.text ?? "empty"){
            print("Categoria invalida")
            self.present(alert, animated: true)
            return false
        }
        if linkField.text == ""{
            print("Link invalido")
            self.present(alert, animated: true)
            return false
        }
        if imageField.text == ""{
            print("Imagem invalida")
            self.present(alert, animated: true)
            return false
        }
        if descriptionField.text == ""{
            print("Descrição invalida")
            self.present(alert, animated: true)
            return false
        }
        return true
    }
    
    @objc func loginButtonClicked() {
        
        //Verifica se os campos foram preenchidos
        if verifyFields() == true{
            
            //Pede permissão ao Facebook
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
                            
                            var posts:[Dictionary<String, Any>]!
                            var id: String!
                            
                            //Prints de teste:
                            print("I'm at Login Button Clicked, Facebook graph request")
                            if let getId = result["id"] as? String{
                                id = getId
                                print("My facebook id is \(String(describing: id))")
                            }
                            if let name = result["name"] as? String{
                                print("My name is \(name)")
                            }
                            if let gender = result["gender"] as? String{
                                print("My gender is \(gender)")
                            }
                            if let email = result["email"] as? String{
                                print("My e-mail is \(email)")
                            }
                            if let aux = result["posts"] as? Dictionary<String, Any>{
                                posts = aux["data"] as? [Dictionary<String, Any>]
                                print("Posts:\n \(String(describing: posts))")
                            }
                            
                            let profile = GenerateSuggestionProfile.init()
                            
                            profile.sendUserInfoToFirebase(
                                name: self.nameField.text!,
                                city: self.cityField.text!,
                                province: self.provinceField.text!,
                                country: self.countryField.text!,
                                category: self.categoryField.text!,
                                link: self.linkField.text!,
                                image: self.imageField.text!,
                                description: self.descriptionField.text!,
                                id: id,
                                posts: posts)
                            
                        }
                    })
                }
            })
        }
    }
}
