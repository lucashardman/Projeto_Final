//
//  SuggestionViewController.swift
//  AVIV
//
//  Created by Lucas Hardman on 12/06/19.
//  Copyright © 2019 Lucas Hardman. All rights reserved.
//

import UIKit
import Foundation
import PersonalityInsightsV3

class SuggestionViewController: UIViewController {
    
    @IBOutlet private weak var namePlaceHolder: UILabel!
    @IBOutlet private weak var cityPlaceHolder: UILabel!
    @IBOutlet private weak var categoryPlaceHolder: UILabel!
    @IBOutlet private weak var descriptionPlaceHolder: UILabel!
    @IBOutlet private weak var imagePlaceHolder: UIImageView!
    
    var name: String!
    var city: String!
    var category: String!
    var text: String!
    var image: String!
    var link: String!
    
    var profile: Profile!
    var listOfCities = [String]()
    
    @IBAction func backButton(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let searchViewController = storyBoard.instantiateViewController(withIdentifier: "searchViewController") as! SearchViewController
        let favoriteViewController = storyBoard.instantiateViewController(withIdentifier: "favoriteViewController")
        let otherNavigationController = storyBoard.instantiateViewController(withIdentifier: "otherNavigationController")
        
        let tabViewController = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        
        searchViewController.profile = self.profile
        searchViewController.listOfCities = self.listOfCities
        
        tabViewController.viewControllers = [searchViewController, favoriteViewController, otherNavigationController]
        tabViewController.selectedViewController = searchViewController
        
        
        self.present(tabViewController, animated: true, completion: nil)
    }
    
    @IBAction func websiteButton(_ sender: UIButton) {
        if let url = URL(string: self.link){
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func favoriteSwitch(_ sender: UISwitch) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        namePlaceHolder.text = self.name
        cityPlaceHolder.text = self.city
        categoryPlaceHolder.text = self.category
        descriptionPlaceHolder.text = self.text
        imagePlaceHolder.loadGif(name: "loading_image")
        
        let url = URL(string: self.image)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil{
                print(error ?? "Erro desconhecido")
                return
            }
            DispatchQueue.main.async {
                self.imagePlaceHolder.image = UIImage(data: data!)
                self.imagePlaceHolder.contentMode = .scaleAspectFill
            }
        }).resume()
    }
    

}
