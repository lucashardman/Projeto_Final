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
    private var masterCategory: String!
    private var mainPhoto: String!
    private var text: String!
    private var link: String!
    private var photoGallery: String!
    private var city: String!
    private var profile: String!
    private var match: Double = 0
    
    func loadElement(addName: String, addId: String, addCategory: String, addMasterCategory: String, addMainPhoto: String, addText: String, addLink: String, addPhotoGallery: String, addCity: String, addProfile: String, match: Double){
        
        name = addName
        id = addId
        category = addCategory
        masterCategory = addMasterCategory
        mainPhoto = addMainPhoto
        text = addText
        link = addLink
        photoGallery = addPhotoGallery
        city = addCity
        profile = addProfile
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
    func getMasterCategory() -> String{
        return masterCategory
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
    func getPhotoGallery() -> String{
        return photoGallery
    }
    func getCity() -> String{
        return city
    }
    func getProfile() -> String{
        return profile
    }
    func getMatch() -> Double{
        return match
    }
}
