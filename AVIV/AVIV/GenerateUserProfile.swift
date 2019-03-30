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
import LanguageTranslatorV3
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
        
        let dataToSave: [String: String] = ["name": name, "email": email, "gender": gender]
        firebase.collection("users").document(id).setData(dataToSave)
        
        self.processFacebookPostsWithPersonalityInsights(posts: posts, id: id)
    }
    private func processFacebookPostsWithPersonalityInsights(posts: [Dictionary<String, Any>], id: String){
        
        //Inicializando PersonalityInsights
        let personalityInsights = PersonalityInsights(
            username: WatsonCredentials.personalityInsightsUsername,
            password: WatsonCredentials.personalityInsightsPassword,
            version: WatsonCredentials.version)
        
        let languageTranslator = LanguageTranslator(version: WatsonCredentials.version, apiKey: WatsonCredentials.languageTranslatorAPIKey, iamUrl: WatsonCredentials.languageTranslatorURL)
    
        //Transferindo postagens para o tipo legivel pelo Personality Insights
        var contentItems: [ContentItem] = []
        print("\nPostagens na lingua original:")
        posts.forEach{ post in
            if (post["message"] != nil){
                //print(post["message"])
                let message = post["message"] as! String
                print(message)
                contentItems.append(ContentItem.init(content: message))
            }
        }
        let profileContent = ProfileContent.content(Content.init(contentItems: contentItems))
        //TESTE: contentItems está preenchida corretamente com os posts em ingles?
        print("\nPostagens traduzidas:")
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
            self.sendPersonalityInsightsUserProfileToFirebase(profile: profile, id: id)
        }
    }
    
    private func sendPersonalityInsightsUserProfileToFirebase(profile: Profile, id: String){

        print("\nBIG FIVE OF USER \(id)")
        for big_five in profile.personality{
        firebase.collection("users").document(id).collection("big_five").document(big_five.name).setData(["name": big_five.name, "percentile": big_five.percentile])
            print("\n-> \(big_five.name): \(big_five.percentile)")
            
            for facet in big_five.children!{
            firebase.collection("users").document(id).collection("big_five").document(big_five.name).collection(big_five.name).document(facet.name).setData(["name": facet.name, "percentile": facet.percentile])
                print("\(facet.name): \(facet.percentile)")
            }
        }
        print("\nNEEDS OF USER \(id)")
        for need in profile.needs{
        firebase.collection("users").document(id).collection("needs").document(need.name).setData(["name": need.name, "percentile": need.percentile])
            print("\(need.name): \(need.percentile)")
        }
        print("\nVALUES OF USER \(id)")
        for value in profile.values{
            firebase.collection("users").document(id).collection("values").document(value.name).setData(["name": value.name, "percentile": value.percentile])
            print("\(value.name): \(value.percentile)")
        }
        print("\nCONSUMPTION PREFERENCES OF USER \(id)")
        for preferences in profile.consumptionPreferences!{
            print("\n-> \(preferences.name):")
            for preference in preferences.consumptionPreferences{
            firebase.collection("users").document(id).collection("consumption_preferences").document(preferences.name).collection(preferences.name).document(preference.name).setData(["name": preference.name, "score": preference.score])
                print("\(preference.name): \(preference.score)")
            }
        }
    }
}
