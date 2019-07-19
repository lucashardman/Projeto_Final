//
//  SuggestionViewController.swift
//  AVIV
//
//  Created by Lucas Hardman on 12/06/19.
//  Copyright © 2019 Lucas Hardman. All rights reserved.
//

import UIKit
import Foundation

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
    
    @IBAction func backButton(_ sender: UIButton) {
    }
    
    @IBAction func websiteButton(_ sender: UIButton) {
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
