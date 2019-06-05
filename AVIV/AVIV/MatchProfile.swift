//
//  MatchProfile.swift
//  AVIV
//
//  Created by Lucas Hardman on 02/06/19.
//  Copyright © 2019 Lucas Hardman. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit
import PromiseKit

class MatchProfile {
    
    var teste: Double = 0
    
    func calculate() -> [Suggestion]{
        
        var suggestionList = [Suggestion]()
        let firebase = Firestore.firestore()
        let userID = FBSDKAccessToken.current()?.userID
        let userDocRef = firebase.collection("users").document(userID!)
        let suggestionDocRef = firebase.collection("suggestions")
        
        var count: Int = 0
        
        let group = DispatchGroup()
        
        var name = [String]()
        
        //anArray.insert("This String", at: 0)
        
        suggestionDocRef.getDocuments { (snapshot, error) in
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    
                    let data = document.data()
                    var user = userDocRef.collection("big_five").document("Agreeableness")
                    var suggestion = suggestionDocRef.document(document.documentID)
                    
                    group.enter()
                    suggestion.getDocument { (document, error) in
                        
                        if let document = document, document.exists {
                            
                            let suggestionName = document.get("name")
                            name.append(suggestionName as!String)
                            print("Name Suggestion: \(name)")
                            
                            
                            let suggestion = Suggestion.init()
                            suggestion.loadElement(addName: suggestionName as! String, addId: "renata", addCategory: "renata", addMasterCategory: "renata", addMainPhoto: "renata", addText: "renata", addLink: "renata", addPhotoGallery: "renata", addCity: "renata", addProfile: "renata", match: 0)
                            
                            suggestionList.append(suggestion)
                            
                            count = count + 1
                            group.leave()
                        } else {
                            print("Document does not exist")
                        }
                    }
                    user = userDocRef.collection("big_five").document("Agreeableness")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Agreeableness")
                    
                    
                    var i: Int = 0
                    group.enter()
                    user.getDocument { (document, error) in
                        
                        if let document = document, document.exists {
                            
                            let property = document.get("percentile")
                            let match = property as! Double
                            print("Agreeableness User: \(match)")
                            
                            suggestion.getDocument { (document, error) in
                                
                                if let document = document, document.exists {
                                    
                                    let property = document.get("percentile")
                                    let match2 = property as! Double
                                    print("Agreeableness Suggestion: \(match2)")
                                    
                                    self.teste = match2
                                    i = i + 1
                                    group.leave()
                                } else {
                                    print("Document does not exist")
                                }
                            }
                            
                        } else {
                            print("Document does not exist")
                        }
                    }
                    
                    print("O DOCUMENTO \(count) É: \(document.documentID)")
                    print("OS DADOS SÃO: \(data)")
 
                }
 
            }
            group.notify(queue: .main, execute: {
                print("Quantas sugestões? \(count)")
                print("nome: \(suggestionList[0].getName())")
                print("Percentual: \(self.teste)")
            })
        }
        
        
        
        //SÓ PARA RETORNAR ALGUMA COISA POR ENQUANTO
        //let olar = Suggestion.init()
        //olar.loadElement(addName: "renata", addId: "renata", addCategory: "renata", addMasterCategory: "renata", addMainPhoto: "renata", addText: "renata", addLink: "renata", addPhotoGallery: "renata", addCity: "renata", addProfile: "renata", match: 0)
        //suggestionList.append(olar)
        
        return suggestionList
    }

}
