//
//  ProcessFacebookData.swift
//  AVIV
//
//  Created by Lucas Hardman on 12/03/19.
//  Copyright © 2019 Lucas Hardman. All rights reserved.
//

import Foundation
import Firebase
import FacebookCore
import PersonalityInsightsV3
/**********************************************
 
 Struct global responsavel por decodificar o json retornado pelo Facebook
 
 
 **********************************************/
struct FacebookProfileRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        var id: String
        var name: String
        var email: String
        var gender: String
        var posts: [Dictionary<String, Any>]
        
        init(rawResponse: Any?) {
            // Decode JSON from rawResponse into other properties here.
            guard let response = rawResponse as? Dictionary<String, Any> else {
                id = ""
                name = ""
                email = ""
                gender = ""
                posts = []
                return
            }
            
            id = response["id"] as! String
            name = response["name"] as! String
            email = response["email"] as! String
            gender = response["gender"] as! String
            let aux = response["posts"] as! Dictionary<String, Any>
            posts = aux["data"] as! [Dictionary<String, Any>]
        }
    }
    
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "id, name, email, gender, posts"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
}

class GenerateUserProfile {
    
    var firebase: Firestore!
    
    init(){
        firebase = Firestore.firestore()
    }
    
    func sendUserInfoToFirebase(id: String, name: String, email: String, gender: String, posts: [Dictionary<String, Any>]){
        
        //var firebase: DatabaseReference!
        //firebase = Database.database().reference()
        let dataToSave: [String: String] = ["id": id, "name": name, "email": email, "gender": gender]
        
        firebase.collection("users").addDocument(data: dataToSave) {
            (error) in
            if let error = error {
                print("Save to Firebase Error: \(error.localizedDescription)")
            }
            else{
                print("Personality data saved to Firebase")
            }
        }
        
        self.processFacebookPostsWithPersonalityInsights(posts: posts)
    }
    private func processFacebookPostsWithPersonalityInsights(posts: [Dictionary<String, Any>]){
        
        //Inicializando PersonalityInsights
        let personalityInsights = PersonalityInsights(
            username: WatsonPersonalityInsightsCredentials.personalityInsightsUsername,
            password: WatsonPersonalityInsightsCredentials.personalityInsightsPassword,
            version: WatsonPersonalityInsightsCredentials.version)
        
        //Transferindo postagens para o tipo legivel pelo Personality Insights
        var contentItems: [ContentItem] = []
        posts.forEach{ post in
            if (post["message"] != nil){
                //print(post["message"])
                let message = post["message"] as! String
                //print(message)
                contentItems.append(ContentItem.init(content: message))
            }
        }
        let profileContent = ProfileContent.content(Content.init(contentItems: contentItems))
        //TESTE: contentItems está preenchida corretamente?
        contentItems.forEach{ item in
            print(item.content)
        }
        
        //Requerindo o Perfil do usuário
        let customHeader: [String: String] = ["Custom-Header": "{Header-Value}"] //não sei pra que serve isso ç_ç
        personalityInsights.profile(profileContent: profileContent, contentLanguage: "en", acceptLanguage: "en", rawScores: true, consumptionPreferences: true, headers: customHeader){ response, error in
            
            guard let profile = response?.result else {
                print("Personality Insights error: ")
                print(error?.localizedDescription ?? "unknown error")
                return
            }
            print("I'm at Personality Insights profile request")
            self.sendPersonalityInsightsUserProfileToFirebase(profile: profile)
        }
    }
    
    private func sendPersonalityInsightsUserProfileToFirebase(profile: Profile){
        print(profile)
        /*
        firebase = Firestore.firestore()
        
        let id: String = profile
        let name: String
        let email: String
        let gender: String
        let dataToSave: [String: String] = ["quote": primeiro, "author": segundo]
        firebase.collection("users")
        firebase.collection("users").addDocument(data: dataToSave) {
            (error) in
            if let error = error {
                print("Save to Firebase Error: \(error.localizedDescription)")
            }
            else{
                print("Personality data saved to Firebase")
            }
        }
        */
       /*
        firebase.setData(dataToSave){
            (error) in
            if let error = error {
                print("Save to Firebase Error: \(error.localizedDescription)")
            }
            else{
                print("Personality data saved to Firebase")
            }
        }
        */
    }

}
