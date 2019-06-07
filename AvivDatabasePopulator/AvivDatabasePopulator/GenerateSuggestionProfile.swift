//
//  GenerateSuggestionProfile.swift
//  AVIV
//
//  Created by Lucas Hardman on 16/05/19.
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
    
    func sendUserInfoToFirebase(name: String, city: String, category: String, link: String, image: String, description: String, id: String, posts: [Dictionary<String, Any>]){
        
        print("\nDados recebidos do formulario:\n")
        print("nome: \(name)\ncity: \(city)\ncategory: \(category)\nlink: \(link)\nimage: \(image)\ndescription: \(description)\n")
        
        let dataToSave: [String: String] = ["name": name,"city": city, "category": category, "link": link, "image": image, "description": description]
        
        firebase.collection("suggestions").document(id).setData(dataToSave)
 
        //Requisitando o processamento das postagens pelo Personality Insights
        self.processFacebookPostsWithPersonalityInsights(posts: posts, id: id, city: city, category: category)
    }
    
    private func processFacebookPostsWithPersonalityInsights(posts: [Dictionary<String, Any>], id: String, city: String, category: String){
        
        //Inicializando PersonalityInsights
        let personalityInsights = PersonalityInsights(
            username: WatsonCredentials.personalityInsightsUsername,
            password: WatsonCredentials.personalityInsightsPassword,
            version: WatsonCredentials.version)
        
        //Inicializando o LanguageTranslator
        let languageTranslator = LanguageTranslator(version: WatsonCredentials.version, apiKey: WatsonCredentials.languageTranslatorAPIKey)
        
        //Passando as postagens para um array de string para ser lido pelo Language Translator
        var messageArray = [String]()
        print("\nPostagens na lingua original:")
        posts.forEach{ post in
            if (post["message"] != nil){
                let message = post["message"] as! String
                print(message)
                messageArray.append(message)
            }
        }
        
        //Tradução das postagens pelo Language Translator
        languageTranslator.translate(text: messageArray, modelID: "pt-en"){
            response, error in
            
            //Tratamento de erro
            guard let translation = response?.result else {
                print("Language Translator error: ")
                print(error?.localizedDescription ?? "Erro desconhecido")
                return
            }
            
            //Transferindo postagens para o tipo legivel pelo Personality Insights
            var contentItems: [ContentItem] = []
            translation.translations.forEach{ post in
                let message = post.translationOutput
                contentItems.append(ContentItem.init(content: message))
            }
            
            print("\nPostagens traduzidas:")
            contentItems.forEach{ post in
                print(post.content)
                print("\n")
            }
            
            //Enviando as postagens traduzidas para o Personality Insights
            let profileContent = ProfileContent.content(Content.init(contentItems: contentItems))
            let customHeader: [String: String] = ["Custom-Header": "{Header-Value}"]
            
            personalityInsights.profile(profileContent: profileContent, contentLanguage: "en", acceptLanguage: "en", rawScores: true, consumptionPreferences: true, headers: customHeader){ response, error in
                
                //Tratamento de erro
                guard let profile = response?.result else {
                    print("Personality Insights error: ")
                    print(error?.localizedDescription ?? "Erro desconhecido")
                    return
                }
                
                //LEMBRAR DE ATUALIZAR ESTA CHAMADA QUANDO IMPLEMENTAR O FORMULARIO
                print("Personality Insights: perfil gerado com sucesso")
                self.sendPersonalityInsightsUserProfileToFirebase(profile: profile, city: city, category: category, id: id)
            }
        }
    }
    
    private func sendPersonalityInsightsUserProfileToFirebase(profile: Profile, city: String, category: String, id: String){
        
        print("\nBIG FIVE OF CITY \(city)")
        for big_five in profile.personality{
            firebase.collection("suggestions").document(id).collection("big_five").document(big_five.name).setData(["name": big_five.name, "percentile": big_five.percentile])
            print("\n-> \(big_five.name): \(big_five.percentile)")
            
            for facet in big_five.children!{
                firebase.collection("suggestions").document(id).collection("big_five").document(big_five.name).collection(big_five.name).document(facet.name).setData(["name": facet.name, "percentile": facet.percentile])
                print("\(facet.name): \(facet.percentile)")
            }
        }
        print("\nNEEDS OF CITY\(city)")
        for need in profile.needs{
            firebase.collection("suggestions").document(id).collection("needs").document(need.name).setData(["name": need.name, "percentile": need.percentile])
            print("\(need.name): \(need.percentile)")
        }
        print("\nVALUES OF CITY \(city)")
        for value in profile.values{
            firebase.collection("suggestions").document(id).collection("values").document(value.name).setData(["name": value.name, "percentile": value.percentile])
            print("\(value.name): \(value.percentile)")
        }
        print("\nCONSUMPTION PREFERENCES OF CITY \(city)")
        for preferences in profile.consumptionPreferences!{
            print("\n-> \(preferences.name):")
            for preference in preferences.consumptionPreferences{
                firebase.collection("suggestions").document(id).collection("consumption_preferences").document(preferences.name).collection(preferences.name).document(preference.name).setData(["name": preference.name, "score": preference.score])
                print("\(preference.name): \(preference.score)")
            }
        }
    }
}
