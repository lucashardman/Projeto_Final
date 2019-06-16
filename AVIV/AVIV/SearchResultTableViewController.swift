//
//  SearchResultTableViewController.swift
//  AVIV
//
//  Created by Lucas Hardman on 12/06/19.
//  Copyright © 2019 Lucas Hardman. All rights reserved.
//

import UIKit
import PersonalityInsightsV3

class SearchResultTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var suggestionsList = [Suggestion]()
    var profile: Profile!
    var listOfCities = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suggestionsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell") as? ResultCell else {
            return UITableViewCell()
        }
        
        cell.namePlaceHolder.text = suggestionsList[indexPath.row].getName()
        cell.cityPlaceHolder.text = suggestionsList[indexPath.row].getCity()
        cell.categoryPlaceHolder.text = suggestionsList[indexPath.row].getCategory()
        cell.descriptionPlaceHolder.text = suggestionsList[indexPath.row].getText()
        cell.descriptionPlaceHolder.numberOfLines = 3
        cell.imagePlaceHolder.loadGif(name: "loading_image")
        
        let link = suggestionsList[indexPath.row].getMainPhoto()
        
        let url = URL(string: link)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
        
            if error != nil{
                print(error ?? "Erro desconhecido")
                return
            }
            DispatchQueue.main.async {
                cell.imagePlaceHolder.image = UIImage(data: data!)
            }
        }).resume()
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell") as? ResultCell else {
            return 0
        }
        return cell.bounds.height
    }
    
}
class ResultCell: UITableViewCell{
    
    @IBOutlet weak var imagePlaceHolder: UIImageView!
    @IBOutlet weak var namePlaceHolder: UILabel!
    @IBOutlet weak var cityPlaceHolder: UILabel!
    @IBOutlet weak var categoryPlaceHolder: UILabel!
    @IBOutlet weak var descriptionPlaceHolder: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


