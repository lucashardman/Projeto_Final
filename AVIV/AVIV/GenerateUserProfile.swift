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

class GenerateUserProfile: UIViewController {
    
    private var firebase: Firestore!
    private var readyToChangeViewController: Bool = false
    private let group = DispatchGroup()
    
    var id: String!
    var name: String!
    var email: String!
    var gender: String!
    var posts: [Dictionary<String, Any>]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firebase = Firestore.firestore()
        group.enter()
        sendUserInfoToFirebase()

        group.notify(queue: .main, execute: {
            //Change view to Tab Bar Controller
            self.changeViewController()
        })
        
    }
    
    private func changeViewController(){
        print("Checando se mudou a tela depois de carregar tudo...")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabBarController")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func sendUserInfoToFirebase(){
        
        let dataToSave: [String: String] = ["name": self.name, "email": self.email, "gender": self.gender]
        
        firebase.collection("users").document(self.id).setData(dataToSave)
        
        self.processFacebookPostsWithPersonalityInsights(posts: self.posts, id: self.id)
    }

    private func processFacebookPostsWithPersonalityInsights(posts: [Dictionary<String, Any>], id: String){
        
        //Inicializando PersonalityInsights
        let personalityInsights = PersonalityInsights(
            username: WatsonCredentials.personalityInsightsUsername,
            password: WatsonCredentials.personalityInsightsPassword,
            version: WatsonCredentials.version)
        
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
        print (messageArray)
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
                self.sendPersonalityInsightsUserProfileToFirebase(profile: profile, id: id)
            }
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
        group.leave()
        
    }
}
