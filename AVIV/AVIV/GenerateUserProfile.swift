//
//  ProcessFacebookData.swift
//  AVIV
//
//  Created by Lucas Hardman on 12/03/19.
//  Copyright © 2019 Lucas Hardman. All rights reserved.
//

import Foundation
import FacebookCore
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
    
    func sendUserInfoToFirebase(id: String, name: String, email: String, gender: String){
    
    }
    func processFacebookPostsWithPersonalityInsights(posts: [Dictionary<String, Any>]){
        //print(posts)
        posts.forEach{ post in
            if (post["message"] != nil){
                print(post["message"])
            }
        }
    }
    
    func sendPersonalityInsightsUserProfileToFirebase(){
        
    }
    /******************************************
     * - Get the info from Facebook           *
     * - Process the info with Watson         *
     * - Send the processed info to Firebase  *
     ******************************************/
    /*func process(data: GraphRequestResult<GraphRequest>) {
        //print(data)
        
        
        let request = GraphRequest(graphPath: "/me", parameters: ["fields": "email,name,gender,posts", "limit": 250])
        request.start{(response, result) in
            //print(result)
            
        }
        
    }*/
}
