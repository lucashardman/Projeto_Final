//
//  MatchProfile.swift
//  AVIV
//
//  Created by Lucas Hardman on 02/06/19.
//  Copyright © 2019 Lucas Hardman. All rights reserved.
//

import Foundation
import Firebase
import PersonalityInsightsV3

class MatchProfile: UIViewController {

    private var listOfSuggestions: [Suggestion] = []
    private let group = DispatchGroup()
    private var groupOfIndicators = DispatchGroup()
    private var groupOfCities = DispatchGroup()
    private var listOfCities = [String]()
    
    var countSuggestionsTotal: Int = 0
    var countSuggestionsFiltered: Int = 0
    var profile: Profile!
    var categoryFilters: [String] = []
    var searchForCity: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Filtros: \(self.categoryFilters)")
        print("Cidade: \(self.searchForCity)")
        
        self.group.enter()
        self.calculate()
        
        self.group.notify(queue: .main, execute: {
            
            let firebase = Firestore.firestore()
            let suggestionDocRef = firebase.collection("suggestions")
            
            self.groupOfCities.enter()
            
            suggestionDocRef.getDocuments { (snapshot, error) in
                if let snapshot = snapshot {
                    
                    for document in snapshot.documents {
                        if self.listOfCities.contains(document.get("city") as! String) == false{
                            self.listOfCities.append(document.get("city") as! String)
                        }
                    }
                }
                self.groupOfCities.leave()
            }
            
            self.groupOfCities.notify(queue: .main, execute: {
                print("Total de sugestões: \(self.countSuggestionsTotal)")
                print("Total de sugestões filtradas: \(self.countSuggestionsFiltered)")
                
                for i in self.listOfSuggestions{
                    print("Testando: \(i.getId())\n\(i.getName())\n\(i.getCity())")
                    print ("O match é de \(i.getMatch())%")
                }
                
                //Change view to Tab Bar Controller
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let searchViewController = storyBoard.instantiateViewController(withIdentifier: "searchViewController") as! SearchViewController
                let favoriteViewController = storyBoard.instantiateViewController(withIdentifier: "favoriteViewController")
                let otherNavigationController = storyBoard.instantiateViewController(withIdentifier: "otherNavigationController")
                
                let tabViewController = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                
                self.sort()
                searchViewController.profile = self.profile
                searchViewController.listOfCities = self.listOfCities
                
                tabViewController.viewControllers = [searchViewController, favoriteViewController, otherNavigationController]
                tabViewController.selectedViewController = searchViewController
                
                
                self.present(tabViewController, animated: true, completion: nil)
            })
        })
    }
    
    func calculate(){
        
        let firebase = Firestore.firestore()
        let suggestionDocRef = firebase.collection("suggestions")
        
        suggestionDocRef.whereField("city", isEqualTo: self.searchForCity).getDocuments { (snapshot, error) in
            if let snapshot = snapshot {
                
                for document in snapshot.documents {
                    
                    let suggestion = suggestionDocRef.document(document.documentID)
                    
                    self.groupOfIndicators.enter()
                    self.countSuggestionsTotal = self.countSuggestionsTotal + 1
                    
                    suggestion.getDocument { (document, error) in
                        
                        if let document = document, document.exists {
                            
                            if self.categoryFilters.contains(document.get("category") as! String){
                            
                                self.countSuggestionsFiltered = self.countSuggestionsFiltered + 1
                                
                                let suggestionName = document.get("name") as! String
                                let suggestionId = String(document.documentID)
                                let suggestionCategory = document.get("category") as! String
                                let suggestionImage = document.get("image") as! String
                                let suggestionDescription = document.get("description") as! String
                                let suggestionLink = document.get("link") as! String
                                let suggestionCity = document.get("city") as! String
                                
                                var sum: Double = 0
                                var count: Double = 0
                                
                                let suggestion = Suggestion.init()
                                suggestion.loadElement(addName: suggestionName, addId: suggestionId, addCategory: suggestionCategory, addMainPhoto: suggestionImage, addText: suggestionDescription, addLink: suggestionLink, addCity: suggestionCity)
                                
                                print("\nBIG FIVE")
                                for big_five in self.profile.personality{
                                   
                                    print("\n-> \(big_five.name): \(big_five.percentile)")
                                    sum = sum + self.compareIndicators(user: big_five.percentile, suggestion: (document.get(big_five.name) ?? 0.0) as! Double)
                                    count = count + 1
                                    for facet in big_five.children!{
                                        
                                        print("\(facet.name): \(facet.percentile)")
                                        sum = sum + self.compareIndicators(user: facet.percentile, suggestion: (document.get(facet.name) ?? 0.0) as! Double)
                                        count = count + 1
                                    }
                                }
                                print("\nNEEDS")
                                for need in self.profile.needs{
                                   
                                    print("\(need.name): \(need.percentile)")
                                    sum = sum + self.compareIndicators(user: need.percentile, suggestion: (document.get(need.name) ?? 0.0) as! Double)
                                    count = count + 1
                                }
                                print("\nVALUES")
                                for value in self.profile.values{
                                   
                                    print("\(value.name): \(value.percentile)")
                                    sum = sum + self.compareIndicators(user: value.percentile, suggestion: (document.get(value.name) ?? 0.0) as! Double)
                                    count = count + 1
                                }
                                print("\nCONSUMPTION PREFERENCES")
                                for preferences in self.profile.consumptionPreferences!{
                                    print("\n-> \(preferences.name):")
                                    for preference in preferences.consumptionPreferences{
                                       
                                        print("\(preference.name): \(preference.score)")
                                        sum = sum + self.compareIndicators(user: preference.score, suggestion: (document.get(preference.name) ?? 0.0) as! Double)
                                        count = count + 1
                                    }
                                }
                                print("COUNT: \(count)\nSUM: \(sum)")
                                suggestion.setMatch(match: sum/count*100)
                                
                                self.listOfSuggestions.append(suggestion)
                                
                                self.groupOfIndicators.leave()
                            }
                            else{
                                self.groupOfIndicators.leave()
                            }
                        } else {
                            self.groupOfIndicators.leave()
                            print("Document does not exist")
                        
                        }
                    }
                    
                    self.groupOfIndicators.notify(queue: .main, execute: {
                        
                            self.group.leave()
                            self.group.enter()

                    })
                }
            }else{
                print("Document does not exist")
            }
            if self.countSuggestionsTotal == 0 {
                print("Não há nenhuma sugestão para esta cidade")
                self.group.leave()
            }
        }
    }
    
    private func compareIndicators(user: Double, suggestion: Double) -> Double{
        
        var result: Double = 0
        
        if user > suggestion{
            result = result + (1 - (user - suggestion))
        }else{
            result = result + (1 - (suggestion - user))
        }
        return result
    }
    
    private func sort(){
        
    }
}
