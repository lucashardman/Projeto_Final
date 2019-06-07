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

class MatchProfile: UIViewController {
    
    var sum: Double = 0
    var count: Double = 0
    var countSuggestions: Int = 0
    private var listOfSuggestions: [Suggestion] = []
    private let group = DispatchGroup()
    private let groupOfIndicators = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.group.enter()
        self.calculate()
        group.notify(queue: .main, execute: {
            
            for i in self.listOfSuggestions{
                print("Testando: \(i.getId())\n\(i.getName())\n\(i.getCity())")
                print ("O match é de \(i.getMatch()*100)%")
            }
            
            //Change view to Tab Bar Controller
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let searchViewController = storyBoard.instantiateViewController(withIdentifier: "searchViewController") as! SearchViewController
            let favoriteViewController = storyBoard.instantiateViewController(withIdentifier: "favoriteViewController")
            let otherNavigationController = storyBoard.instantiateViewController(withIdentifier: "otherNavigationController")
            
            let tabViewController = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
            
            searchViewController.listOfSuggestions = self.listOfSuggestions
            
            tabViewController.viewControllers = [searchViewController, favoriteViewController, otherNavigationController]
            tabViewController.selectedViewController = searchViewController
            
            self.present(tabViewController, animated: true, completion: nil)
        })
    }
    
    func calculate(){
        
        let firebase = Firestore.firestore()
        let userID = FBSDKAccessToken.current()?.userID
        let userDocRef = firebase.collection("users").document(userID!)
        let suggestionDocRef = firebase.collection("suggestions")
        
        suggestionDocRef.getDocuments { (snapshot, error) in
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    
                    var user = userDocRef.collection("big_five").document("Agreeableness")
                    var suggestion = suggestionDocRef.document(document.documentID)
                    
                    self.countSuggestions = self.countSuggestions + 1
                    
                    suggestion.getDocument { (document, error) in
                        
                        if let document = document, document.exists {
                            
                            let suggestionName = document.get("name") as! String
                            let suggestionId = String(document.documentID)
                            let suggestionCategory = document.get("category") as! String
                            let suggestionImage = document.get("image") as! String
                            let suggestionDescription = document.get("description") as! String
                            let suggestionLink = document.get("link") as! String
                            let suggestionCity = document.get("city") as! String
                            
                            self.count = 0
                            self.sum = 0
                            
                            let suggestion = Suggestion.init()
                            suggestion.loadElement(addName: suggestionName, addId: suggestionId, addCategory: suggestionCategory, addMainPhoto: suggestionImage, addText: suggestionDescription, addLink: suggestionLink, addPhotoGallery: "FALTANDO", addCity: suggestionCity, addProfile: "FALTANDOS", match: 0)
                            
                            self.listOfSuggestions.append(suggestion)
                            
                            self.group.leave()
                        } else {
                            print("Document does not exist")
                        }
                    }
                    
                    //let groupOfIndicators = DispatchGroup()
                    
                    self.group.enter()
                    
                    //************ GRUPOS BIG FIVE ************\\
                    //GRUPO AGREEABLENESS
                    user = userDocRef.collection("big_five").document("Agreeableness")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Agreeableness")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Altruism
                    user = userDocRef.collection("big_five").document("Agreeableness").collection("Agreeableness").document("Altruism")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Agreeableness").collection("Agreeableness").document("Altruism")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Cooperation
                    user = userDocRef.collection("big_five").document("Agreeableness").collection("Agreeableness").document("Cooperation")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Agreeableness").collection("Agreeableness").document("Cooperation")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Modesty
                    user = userDocRef.collection("big_five").document("Agreeableness").collection("Agreeableness").document("Modesty")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Agreeableness").collection("Agreeableness").document("Modesty")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Sympathy
                    user = userDocRef.collection("big_five").document("Agreeableness").collection("Agreeableness").document("Sympathy")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Agreeableness").collection("Agreeableness").document("Sympathy")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Trust
                    user = userDocRef.collection("big_five").document("Agreeableness").collection("Agreeableness").document("Trust")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Agreeableness").collection("Agreeableness").document("Trust")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Uncompromising
                    user = userDocRef.collection("big_five").document("Agreeableness").collection("Agreeableness").document("Uncompromising")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Agreeableness").collection("Agreeableness").document("Uncompromising")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    
                    //GRUPO CONSCIENTIOUSNESS
                    user = userDocRef.collection("big_five").document("Conscientiousness")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Conscientiousness")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Achievement striving
                    user = userDocRef.collection("big_five").document("Conscientiousness").collection("Conscientiousness").document("Achievement striving")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Conscientiousness").collection("Conscientiousness").document("Achievement striving")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Cautiousness
                    user = userDocRef.collection("big_five").document("Conscientiousness").collection("Conscientiousness").document("Cautiousness")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Conscientiousness").collection("Conscientiousness").document("Cautiousness")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Dutifulness
                    user = userDocRef.collection("big_five").document("Conscientiousness").collection("Conscientiousness").document("Dutifulness")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Conscientiousness").collection("Conscientiousness").document("Dutifulness")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Orderliness
                    user = userDocRef.collection("big_five").document("Conscientiousness").collection("Conscientiousness").document("Orderliness")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Conscientiousness").collection("Conscientiousness").document("Orderliness")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Self-discipline
                    user = userDocRef.collection("big_five").document("Conscientiousness").collection("Conscientiousness").document("Self-discipline")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Conscientiousness").collection("Conscientiousness").document("Self-discipline")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Self-efficacy
                    user = userDocRef.collection("big_five").document("Conscientiousness").collection("Conscientiousness").document("Self-efficacy")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Conscientiousness").collection("Conscientiousness").document("Self-efficacy")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    
                    //GRUPO EMOTIONAL RANGE
                    user = userDocRef.collection("big_five").document("Emotional range")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Emotional range")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Fiery
                    user = userDocRef.collection("big_five").document("Emotional range").collection("Emotional range").document("Fiery")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Emotional range").collection("Emotional range").document("Fiery")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Immoderation
                    user = userDocRef.collection("big_five").document("Emotional range").collection("Emotional range").document("Immoderation")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Emotional range").collection("Emotional range").document("Immoderation")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Melancholy
                    user = userDocRef.collection("big_five").document("Emotional range").collection("Emotional range").document("Melancholy")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Emotional range").collection("Emotional range").document("Melancholy")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Prone to worry
                    user = userDocRef.collection("big_five").document("Emotional range").collection("Emotional range").document("Prone to worry")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Emotional range").collection("Emotional range").document("Prone to worry")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Self-consciousness
                    user = userDocRef.collection("big_five").document("Emotional range").collection("Emotional range").document("Self-consciousness")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Emotional range").collection("Emotional range").document("Self-consciousness")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Susceptible to stress
                    user = userDocRef.collection("big_five").document("Emotional range").collection("Emotional range").document("Susceptible to stress")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Emotional range").collection("Emotional range").document("Susceptible to stress")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    
                    //GRUPO EXTRAVERSION
                    user = userDocRef.collection("big_five").document("Extraversion")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Extraversion")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Activity level
                    user = userDocRef.collection("big_five").document("Extraversion").collection("Extraversion").document("Activity level")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Extraversion").collection("Extraversion").document("Activity level")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    
                    //SUBGRUPO Assertiveness
                    user = userDocRef.collection("big_five").document("Extraversion").collection("Extraversion").document("Assertiveness")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Extraversion").collection("Extraversion").document("Assertiveness")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Cheerfulness
                    user = userDocRef.collection("big_five").document("Extraversion").collection("Extraversion").document("Cheerfulness")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Extraversion").collection("Extraversion").document("Cheerfulness")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Excitement-seeking
                    user = userDocRef.collection("big_five").document("Extraversion").collection("Extraversion").document("Excitement-seeking")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Extraversion").collection("Extraversion").document("Excitement-seeking")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Gregariousness
                    user = userDocRef.collection("big_five").document("Extraversion").collection("Extraversion").document("Gregariousness")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Extraversion").collection("Extraversion").document("Gregariousness")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Outgoing
                    user = userDocRef.collection("big_five").document("Extraversion").collection("Extraversion").document("Outgoing")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Extraversion").collection("Extraversion").document("Outgoing")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    
                    //GRUPO OPENNESS
                    user = userDocRef.collection("big_five").document("Openness")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Openness")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Adventurousness
                    user = userDocRef.collection("big_five").document("Openness").collection("Openness").document("Adventurousness")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Openness").collection("Openness").document("Adventurousness")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Artistic interests
                    user = userDocRef.collection("big_five").document("Openness").collection("Openness").document("Artistic interests")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Openness").collection("Openness").document("Artistic interests")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Authority-challenging
                    user = userDocRef.collection("big_five").document("Openness").collection("Openness").document("Authority-challenging")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Openness").collection("Openness").document("Authority-challenging")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Emotionality
                    user = userDocRef.collection("big_five").document("Openness").collection("Openness").document("Emotionality")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Openness").collection("Openness").document("Emotionality")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Imagination
                    user = userDocRef.collection("big_five").document("Openness").collection("Openness").document("Imagination")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Openness").collection("Openness").document("Imagination")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //SUBGRUPO Intellect
                    user = userDocRef.collection("big_five").document("Openness").collection("Openness").document("Intellect")
                    suggestion = suggestionDocRef.document(document.documentID).collection("big_five").document("Openness").collection("Openness").document("Intellect")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    
                    //************ GRUPOS CONSUMPTION PREFERENCES ************\\
                    //GRUPO Entrepreneurship Preferences
                    user = userDocRef.collection("consumption_preferences").document("Entrepreneurship Preferences").collection("Entrepreneurship Preferences").document("Likely to consider starting a business in next few years")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Entrepreneurship Preferences").collection("Entrepreneurship Preferences").document("Likely to consider starting a business in next few years")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    //GRUPO Environmental Concern Preferences
                    user = userDocRef.collection("consumption_preferences").document("Environmental Concern Preferences").collection("Environmental Concern Preferences").document("Likely to be concerned about the environment")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Environmental Concern Preferences").collection("Environmental Concern Preferences").document("Likely to be concerned about the environment")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    //GRUPO Environmental Health & Activity Preferences
                    user = userDocRef.collection("consumption_preferences").document("Health & Activity Preferences").collection("Health & Activity Preferences").document("Likely to eat out frequently")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Health & Activity Preferences").collection("Health & Activity Preferences").document("Likely to eat out frequently")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Health & Activity Preferences").collection("Health & Activity Preferences").document("Likely to have a gym membership")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Health & Activity Preferences").collection("Health & Activity Preferences").document("Likely to have a gym membership")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Health & Activity Preferences").collection("Health & Activity Preferences").document("Likely to like outdoor activities")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Health & Activity Preferences").collection("Health & Activity Preferences").document("Likely to like outdoor activities")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    //GRUPO Movie Preferences
                    user = userDocRef.collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like action movies")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like action movies")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")

                    user = userDocRef.collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like adventure movies")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like adventure movies")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like documentary movies")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like documentary movies")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like drama movies")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like drama movies")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like historical movies")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like historical movies")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like horror movies")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like horror movies")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like musical movies")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like musical movies")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like romance movies")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like romance movies")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like science-fiction movies")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like science-fiction movies")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like war movies")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Movie Preferences").collection("Movie Preferences").document("Likely to like war movies")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    //GRUPO Music Preferences
                    user = userDocRef.collection("consumption_preferences").document("Music Preferences").collection("Music Preferences").document("Likely to attend live musical events")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Music Preferences").collection("Music Preferences").document("Likely to attend live musical events")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Music Preferences").collection("Music Preferences").document("Likely to have experience playing music")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Music Preferences").collection("Music Preferences").document("Likely to have experience playing music")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Music Preferences").collection("Music Preferences").document("Likely to like Latin music")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Music Preferences").collection("Music Preferences").document("Likely to like Latin music")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Music Preferences").collection("Music Preferences").document("Likely to like R&B music")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Music Preferences").collection("Music Preferences").document("Likely to like R&B music")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Music Preferences").collection("Music Preferences").document("Likely to like classical music")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Music Preferences").collection("Music Preferences").document("Likely to like classical music")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Music Preferences").collection("Music Preferences").document("Likely to like country music")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Music Preferences").collection("Music Preferences").document("Likely to like country music")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Music Preferences").collection("Music Preferences").document("Likely to like hip hop music")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Music Preferences").collection("Music Preferences").document("Likely to like hip hop music")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Music Preferences").collection("Music Preferences").document("Likely to like rap music")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Music Preferences").collection("Music Preferences").document("Likely to like rap music")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Music Preferences").collection("Music Preferences").document("Likely to like rock music")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Music Preferences").collection("Music Preferences").document("Likely to like rock music")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    //GRUPO Purchasing Preferences
                    user = userDocRef.collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to be influenced by brand name when making product purchases")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to be influenced by brand name when making product purchases")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to be influenced by family when making product purchases")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to be influenced by family when making product purchases")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to be influenced by online ads when making product purchases")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to be influenced by online ads when making product purchases")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to be influenced by product utility when making product purchases")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to be influenced by product utility when making product purchases")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to be influenced by social media when making product purchases")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to be influenced by social media when making product purchases")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to be sensitive to ownership cost when buying automobiles")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to be sensitive to ownership cost when buying automobiles")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to indulge in spur of the moment purchases")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to indulge in spur of the moment purchases")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to prefer comfort when buying clothes")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to prefer comfort when buying clothes")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to prefer quality when buying clothes")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to prefer quality when buying clothes")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to prefer safety when buying automobiles")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to prefer safety when buying automobiles")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to prefer style when buying clothes")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to prefer style when buying clothes")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to prefer using credit cards for shopping")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Purchasing Preferences").collection("Purchasing Preferences").document("Likely to prefer using credit cards for shopping")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    //GRUPO Reading Preferences
                    user = userDocRef.collection("consumption_preferences").document("Reading Preferences").collection("Reading Preferences").document("Likely to read autobiographical books")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Reading Preferences").collection("Reading Preferences").document("Likely to read autobiographical books")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Reading Preferences").collection("Reading Preferences").document("Likely to read entertainment magazines")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Reading Preferences").collection("Reading Preferences").document("Likely to read entertainment magazines")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Reading Preferences").collection("Reading Preferences").document("Likely to read financial investment books")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Reading Preferences").collection("Reading Preferences").document("Likely to read financial investment books")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Reading Preferences").collection("Reading Preferences").document("Likely to read non-fiction books")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Reading Preferences").collection("Reading Preferences").document("Likely to read non-fiction books")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    user = userDocRef.collection("consumption_preferences").document("Reading Preferences").collection("Reading Preferences").document("Likely to read often")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Reading Preferences").collection("Reading Preferences").document("Likely to read often")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    //GRUPO Volunteering Preferences
                    user = userDocRef.collection("consumption_preferences").document("Volunteering Preferences").collection("Volunteering Preferences").document("Likely to volunteer for social causes")
                    suggestion = suggestionDocRef.document(document.documentID).collection("consumption_preferences").document("Volunteering Preferences").collection("Volunteering Preferences").document("Likely to volunteer for social causes")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "score")
                    
                    
                    //************ GRUPOS NEEDS ************\\
                    //GRUPO Challenge
                    user = userDocRef.collection("needs").document("Challenge")
                    suggestion = suggestionDocRef.document(document.documentID).collection("needs").document("Challenge")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //GRUPO Closeness
                    user = userDocRef.collection("needs").document("Closeness")
                    suggestion = suggestionDocRef.document(document.documentID).collection("needs").document("Closeness")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //GRUPO Curiosity
                    user = userDocRef.collection("needs").document("Curiosity")
                    suggestion = suggestionDocRef.document(document.documentID).collection("needs").document("Curiosity")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //GRUPO Excitement
                    user = userDocRef.collection("needs").document("Excitement")
                    suggestion = suggestionDocRef.document(document.documentID).collection("needs").document("Excitement")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //GRUPO Harmony
                    user = userDocRef.collection("needs").document("Harmony")
                    suggestion = suggestionDocRef.document(document.documentID).collection("needs").document("Harmony")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //GRUPO Ideal
                    user = userDocRef.collection("needs").document("Ideal")
                    suggestion = suggestionDocRef.document(document.documentID).collection("needs").document("Ideal")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //GRUPO Liberty
                    user = userDocRef.collection("needs").document("Liberty")
                    suggestion = suggestionDocRef.document(document.documentID).collection("needs").document("Liberty")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //GRUPO Love
                    user = userDocRef.collection("needs").document("Love")
                    suggestion = suggestionDocRef.document(document.documentID).collection("needs").document("Love")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //GRUPO Practicality
                    user = userDocRef.collection("needs").document("Practicality")
                    suggestion = suggestionDocRef.document(document.documentID).collection("needs").document("Practicality")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //GRUPO Self-expression
                    user = userDocRef.collection("needs").document("Self-expression")
                    suggestion = suggestionDocRef.document(document.documentID).collection("needs").document("Self-expression")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //GRUPO Stability
                    user = userDocRef.collection("needs").document("Stability")
                    suggestion = suggestionDocRef.document(document.documentID).collection("needs").document("Stability")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //GRUPO Structure
                    user = userDocRef.collection("needs").document("Structure")
                    suggestion = suggestionDocRef.document(document.documentID).collection("needs").document("Structure")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //************ GRUPOS VALUES ************\\
                    //GRUPO EXTRAVERSION
                    user = userDocRef.collection("values").document("Conservation")
                    suggestion = suggestionDocRef.document(document.documentID).collection("values").document("Conservation")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //GRUPO HENDONISM
                    user = userDocRef.collection("values").document("Hedonism")
                    suggestion = suggestionDocRef.document(document.documentID).collection("values").document("Hedonism")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //GRUPO OPENNESS TO CHANGE
                    user = userDocRef.collection("values").document("Openness to change")
                    suggestion = suggestionDocRef.document(document.documentID).collection("values").document("Openness to change")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //GRUPO SELF-ENHANCEMENT
                    user = userDocRef.collection("values").document("Self-enhancement")
                    suggestion = suggestionDocRef.document(document.documentID).collection("values").document("Self-enhancement")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //GRUPO SELF-TRANSCEDENCE
                    user = userDocRef.collection("values").document("Self-transcendence")
                    suggestion = suggestionDocRef.document(document.documentID).collection("values").document("Self-transcendence")
                    self.groupOfIndicators.enter()
                    self.compare(user: user, suggestion: suggestion, indicatorType: "percentile")
                    
                    //************ FIM DOS GRUPOS ************\\
                    self.groupOfIndicators.notify(queue: .main, execute: {
                        print("Este é a sugestão de número \(self.countSuggestions)")
                        
                        self.listOfSuggestions[self.countSuggestions - 1].setMatch(match: self.sum/self.count)
                        
                        self.count = 0
                        self.sum = 0
                        self.group.leave()
                    })
                }
 
            }
        }
    }
    private func compareIndicators(user: Double, suggestion: Double){
        
        if user > suggestion{
            self.sum = self.sum + (1 - (user - suggestion))
        }else{
            self.sum = self.sum + (1 - (suggestion - user))
        }
    }
    
    private func compare (user: DocumentReference, suggestion: DocumentReference, indicatorType: String){
        user.getDocument { (documentUser, error) in
            
            if let documentUser = documentUser, documentUser.exists {
                
                suggestion.getDocument { (documentSuggestion, error) in
                    
                    if let documentSuggestion = documentSuggestion, documentSuggestion.exists {
                        
                        self.compareIndicators(user: (documentUser.get(indicatorType) as! Double), suggestion: (documentSuggestion.get(indicatorType) as! Double))
                        
                        self.count = self.count + 1
                        
                        self.groupOfIndicators.leave()
                        
                    } else {
                        print("Suggestion: Document does not exist")
                    }
                }
                
            } else {
                print("User: Document does not exist")
            }
        }
    }
}
