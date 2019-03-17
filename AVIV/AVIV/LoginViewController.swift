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
import FBSDKCoreKit

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
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                
                //let facebook = ProcessFacebookData()
                let connection = GraphRequestConnection()
                connection.add(FacebookProfileRequest()) { response, result in
                    switch result {
                    case .success(let response):
                        
                        //Prints de teste:
                        print("Custom Graph Request Succeeded: \(response)")
                        print("My facebook id is \(response.id)")
                        print("My name is \(response.name)")
                        print("My gender is \(response.gender)")
                        print("My e-mail is \(response.email)")
                        //print(response.posts.debugDescription)
                        let profile = GenerateUserProfile()
                        profile.processFacebookPostsWithPersonalityInsights(posts: response.posts)
                    case .failed(let error):
                        print("Graph request at login have failed: \(error)")
                    }
                }
                connection.start()
 
                
                
                
                
                
                /*
                let request = GraphRequest(graphPath: "/me", parameters: ["fields": "email,name,gender,posts", "limit": 250])
                
                request.start{(response, result) in
                    print(result)
                    let facebook = ProcessFacebookData()
                    facebook.process(data: result)
                    //print("My facebook id is \(response.dictionaryValue?["id"])")
                }
                */
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
    /****************************************************************************************
     *
     * DESCRIÇÃO DA FUNÇÃO
     *
     ****************************************************************************************/
    @IBAction func loginButton(_ sender: UIButton) {
    
        /*
        let fbLoginManager : LoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    print ("Logging in")
                    
                    //Pegar dados do Facebook, interpretar com PI e enviar para o Firebase
                    self.processFacebookData()
                    
                    //Sair da tela de login para a tela do Conversation
                    let myTabBar = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    let appDelegate = UIApplication.shared.delegate as!AppDelegate
                    appDelegate.window?.rootViewController = myTabBar
                }
            }
        }
    */
    }
    /****************************************************************************************
     *
     * DESCRIÇÃO DA FUNÇÃO
     *
     ****************************************************************************************/
   /*
    func processFacebookData(){
        
        GraphRequest(graphPath: "/me", parameters: ["fields": "email,name,gender,posts", "limit": 250]).start {
            (connection, result, err) in
            
            if err != nil{
                print("Failed to start graph request: ", err!);
                return
            }
            print(result.debugDescription)
            
            //Interpretar dados com o Personality Insights e enviar para o Firebase
            let arrayOfMessages = self.convertFacebookResultToStringArray(result.debugDescription) //Transforma o resultado do GraphRequest (dados extraidos do facebook) em um formato legivel pelo Personality Insights
            let (name, first_name) = self.getName(result.debugDescription)
            let email = self.getEmail(result.debugDescription)
            let gender = self.getGender(result.debugDescription)
            let id = self.getId(result.debugDescription)
            let personalityInsights = PersonalityInsightsHandler()
            personalityInsights.submitProfile(text: arrayOfMessages,id: id, name: name, first_name: first_name, email: email, gender: gender) //Gera o perfil e envia para o Firebae
        }
    }
    */
    /****************************************************************************************
     *
     * DESCRIÇÃO DA FUNÇÃO
     *
     ****************************************************************************************/
    /*
    private func getStringOfMessages(result: String, lookFor: String) -> (String, String){
        
        var indexStart = result.startIndex
        var indexEndMessage = result.endIndex
        let indexEndResult = result.endIndex
        var index = 0
        var messageString = ""
        var endMessageString = ""
        var message = ""
        var tempResult = result
        var found = false
        
        if (lookFor == "messages"){
            messageString = "message"
            endMessageString = ";\n"
        }else if (lookFor == "name"){
            messageString = "name"
            endMessageString = ";\n"
        }else if (lookFor == "email"){
            messageString = "email"
            endMessageString = ";\n"
        }else if (lookFor == "gender"){
            messageString = "gender"
            endMessageString = ";\n"
        }
        else if (lookFor == "id"){
            messageString = "id"
            endMessageString = ";\n"
        }
        
        for char in tempResult{
            if messageString.first == char{
                let startOfFoundCharacter = tempResult.index(tempResult.startIndex, offsetBy: index)
                let lengthOfFoundCharacter = tempResult.index(tempResult.startIndex, offsetBy: (messageString.count + index))
                let range = startOfFoundCharacter..<lengthOfFoundCharacter
                
                if tempResult.substring(with: range) == messageString {
                    //print("Found \(messageString):")
                    indexStart = tempResult.substring(with: range).endIndex
                    found = true
                    break
                }
            }
            index += 1
        }
        
        if found == false {
            return ("END", "")
        }
        
        indexStart = tempResult.index(indexStart, offsetBy: index + 3)
        tempResult = String(tempResult[indexStart..<indexEndResult])
        index = 0
        for char in tempResult{
            if endMessageString.first == char{
                let startOfFoundCharacter = tempResult.index(tempResult.startIndex, offsetBy: index)
                let lengthOfFoundCharacter = tempResult.index(tempResult.startIndex, offsetBy: (endMessageString.count + index))
                let range = startOfFoundCharacter..<lengthOfFoundCharacter
                
                if tempResult.substring(with: range) == endMessageString {
                    //print("Found \(endMessageString):")
                    indexEndMessage = tempResult.substring(with: range).endIndex
                    break
                }
            }
            index += 1
        }
        indexEndMessage = tempResult.index(indexEndMessage, offsetBy: index - 2)
        message = String(tempResult[tempResult.startIndex..<indexEndMessage])
        
        // Remove as aspas do nome e do e-mail
        if (lookFor == "name" || lookFor == "email"){
            message = String(message.dropLast())
            message = String(message.dropFirst())
        }
        
        return (tempResult, message)
    }
 */
    /****************************************************************************************
     *
     * DESCRIÇÃO DA FUNÇÃO
     *
     ****************************************************************************************/
   /*
    func getName(_ result: String) -> (String, String){
        
        var name = "name_not_found"
        var first_name = "first_name_not_found"
        
        (_,name) = getStringOfMessages(result: result, lookFor: "name")
        
        var listOfNames = name.components(separatedBy: " ")
        first_name = listOfNames[0]
        
        return (name, first_name)
    }
     */
    /****************************************************************************************
     *
     * DESCRIÇÃO DA FUNÇÃO
     *
     ****************************************************************************************/
    /*
    func getId(_ result: String) -> String{
        var id = "id_not_found"
        
        (_,id) = getStringOfMessages(result: result, lookFor: "id")
        
        return id
    }
 */
    /****************************************************************************************
     *
     * DESCRIÇÃO DA FUNÇÃO
     *
     ****************************************************************************************/
    /*
    func getEmail(_ result: String) -> String{
        var email = "email_not_found"
        
        (_,email) = getStringOfMessages(result: result, lookFor: "email")
        
        return email
    }
     */
    /****************************************************************************************
     *
     * DESCRIÇÃO DA FUNÇÃO
     *
     ****************************************************************************************/
    /*
    func getGender(_ result: String) -> String{
        var gender = "gender_not_found"
        
        (_,gender) = getStringOfMessages(result: result, lookFor: "gender")
        
        return gender
    }
    */
    /****************************************************************************************
     *
     * DESCRIÇÃO DA FUNÇÃO
     *
     ****************************************************************************************/
    /*
    func convertFacebookResultToStringArray(_ result: String) -> [String]{
        
        var tempResult = result
        var tempMessage = ""
        var messages: [String] = []
        print ("Converting Facebook result to JSON...")
        
        // Separating each message of the result string and allocating in an array
        while tempResult != "END" {
            (tempResult, tempMessage) = getStringOfMessages(result: tempResult, lookFor: "messages")
            if tempMessage.hasPrefix("\"") == true{
                messages.append(tempMessage)
            }
        }
        return messages
    }
    */
}
