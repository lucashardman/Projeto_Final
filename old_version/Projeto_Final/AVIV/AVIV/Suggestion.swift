//
//  Suggestion.swift
//  AVIV
//
//  Created by Lucas Hardman on 24/03/19.
//  Copyright © 2019 Lucas Hardman. All rights reserved.
//

import Foundation

class Suggestion {
    
    private var name: String!
    private var id: String!
    private var category: String!
    private var mainPhoto: String!
    private var text: String!
    private var link: String!
    private var city: String!
    private var match: Double = 0
    
    func loadElement(addName: String, addId: String, addCategory: String, addMainPhoto: String, addText: String, addLink: String, addCity: String){
        
        name = addName
        id = addId
        category = addCategory
        mainPhoto = addMainPhoto
        text = addText
        link = addLink
        city = addCity
    }
    
    func setMatch(match: Double){
        self.match = match
    }
    
    func getName() -> String{
        return name
    }
    func getId() -> String{
        return id
    }
    func getCategory() -> String{
        return category
    }
    func getMainPhoto() -> String{
        return mainPhoto
    }
    func getText() -> String{
        return text
    }
    func getLink() -> String{
        return link
    }
    func getCity() -> String{
        return city
    }
    func getMatch() -> Double{
        return match
    }
}
