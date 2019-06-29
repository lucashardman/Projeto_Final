//
//  SearchViewController.swift
//  AVIV
//
//  Created by Lucas Hardman on 18/03/19.
//  Copyright © 2019 Lucas Hardman. All rights reserved.
//

import UIKit
import Foundation
import PersonalityInsightsV3

extension UIImage {
    
    func addImagePadding(extraWidth: Double, extraHeight: Double) -> UIImage? {
        let width: CGFloat = size.width + CGFloat(Double(extraWidth))
        let height: CGFloat = size.height + CGFloat(Double(extraHeight))
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        let origin: CGPoint = CGPoint(x: (width - size.width) / 2, y: (height - size.height) / 2)
        draw(at: origin)
        let imageWithPadding = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageWithPadding
    }
}

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //Variaveis globais recebidas de outras views
    var profile: Profile!
    var listOfCities = [String]()
    var currentListOfCities = [String]()
    @IBOutlet weak var tableViewOfCities: UITableView!
    
    //Variaveis globais que serão passadas para outras views
    private var arrayOfCategoryFilter: [String] = []
    private var sendCity: String = ""
    
    //Variaveis globais do botões de filtro
    @IBOutlet weak var refineButton: UIButton!
    private var hiddenRefinedSearch: Bool = false
    
    private let openAir: UIButton = UIButton(type: .custom)
    private let nightClub: UIButton = UIButton(type: .custom)
    private let theater: UIButton = UIButton(type: .custom)
    private let shopping: UIButton = UIButton(type: .custom)
    private let museum: UIButton = UIButton(type: .custom)
    private let music: UIButton = UIButton(type: .custom)
    private let hotel: UIButton = UIButton(type: .custom)
    private let gastronomy: UIButton = UIButton(type: .custom)
    
    //Flags de filtro de busca inicializadas como false, pois não há filtros por default
    private var openAirFlag: Bool = false
    private var nightClubFlag: Bool = false
    private var theaterFlag: Bool = false
    private var shoppingFlag: Bool = false
    private var museumFlag: Bool = false
    private var musicFlag: Bool = false
    private var hotelFlag: Bool = false
    private var gastronomyFlag: Bool = false
    
    //Variaveis globais do search bar
    @IBOutlet weak var searchCityBar: UISearchBar!
    private var width: Double!
    private var height: Double!
    private var size: CGSize!
    private var radius: CGFloat!
    private var borderWidth: CGFloat!
    private var borderColor: CGColor!
    private var backgroundColor: UIColor!
    private var color: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewOfCities.isHidden = true
        
        print("Todas as cidades: \(self.listOfCities)")
        
        loadViewElements()
        loadRefineButtons(buttons: [openAir,
                                    nightClub,
                                    theater,
                                    shopping,
                                    museum,
                                    music,
                                    hotel,
                                    gastronomy])
    }
    
    private func loadViewElements(){
        
        //Tratamento dos elementos visiveis na tela
        refineButton.center = view.center;
        refineButton.setTitle("\u{2193} Refinar pesquisa", for: .normal)
        hiddenRefinedSearch = false
    }
    
    private func loadRefineButtons(buttons: [UIButton]){
        
        width = 70
        height = 70
        borderWidth = CGFloat(Double(3))
        size = CGSize(width: width, height: height)
        radius = CGFloat(Double(height/2))
        
        borderColor = UIColor.init(red: CGFloat(147.0/255.0), green: CGFloat(147.0/255.0), blue: CGFloat(149.0/255.0), alpha: CGFloat(1)).cgColor
        color = UIColor.init(red: CGFloat(147.0/255.0), green: CGFloat(147.0/255.0), blue: CGFloat(149.0/255.0), alpha: CGFloat(1))
        backgroundColor = UIColor.white
        
        openAir.titleLabel?.text = "openAir"
        nightClub.titleLabel?.text = "nightClub"
        theater.titleLabel?.text = "theater"
        shopping.titleLabel?.text = "shopping"
        museum.titleLabel?.text = "museum"
        music.titleLabel?.text = "music"
        hotel.titleLabel?.text = "hotel"
        gastronomy.titleLabel?.text = "gastronomy"
        
        buttons.forEach{ button in
            
            view.addSubview(button)
            button.isHidden = true
            
            button.setImage(UIImage(named: (button.titleLabel?.text)!)?.addImagePadding(extraWidth: width*8, extraHeight: height*8), for: .normal)
            
            button.layer.cornerRadius = radius
            button.layer.borderWidth = borderWidth
            button.layer.borderColor = borderColor
            button.backgroundColor = backgroundColor
            button.tintColor = color
            
            openAir.frame = CGRect(x: 50, y: 300, width: width, height: height)
            nightClub.frame = CGRect(x: 150, y: 300, width: width, height: height)
            theater.frame = CGRect(x: 250, y: 300, width: width, height: height)
            shopping.frame = CGRect(x: 50, y: 400, width: width, height: height)
            museum.frame = CGRect(x: 150, y: 400, width: width, height: height)
            music.frame = CGRect(x: 250, y: 400, width: width, height: height)
            hotel.frame = CGRect(x: 50, y: 500, width: width, height: height)
            gastronomy.frame = CGRect(x: 150, y: 500, width: width, height: height)
            
            openAir.addTarget(self, action: #selector(self.openAirClicked), for: .touchUpInside )
            nightClub.addTarget(self, action: #selector(self.nighClubClicked), for: .touchUpInside)
            theater.addTarget(self, action: #selector(self.theaterClicked), for: .touchUpInside)
            shopping.addTarget(self, action: #selector(self.shoppingClicked), for: .touchUpInside)
            museum.addTarget(self, action: #selector(self.museumClicked), for: .touchUpInside)
            music.addTarget(self, action: #selector(self.musicClicked), for: .touchUpInside)
            hotel.addTarget(self, action: #selector(self.hotelClicked), for: .touchUpInside)
            gastronomy.addTarget(self, action: #selector(self.gastronomyClicked), for: .touchUpInside)
        }
    }
    
    private func selectRefineButton(button: UIButton){

        button.layer.borderWidth = CGFloat(Double(0))
        button.backgroundColor = UIColor.init(red: CGFloat(147.0/255.0), green: CGFloat(147.0/255.0), blue: CGFloat(149.0/255.0), alpha: CGFloat(1))
        button.tintColor = UIColor.white

    }
    private func diselectRefineButton(button: UIButton){

        button.layer.borderWidth = CGFloat(Double(3))
        button.backgroundColor = UIColor.white
        button.tintColor = UIColor.init(red: CGFloat(147.0/255.0), green: CGFloat(147.0/255.0), blue: CGFloat(149.0/255.0), alpha: CGFloat(1))

    }
    
    @IBAction func refineButtonClicked(_ sender: UIButton) {
        
        print("Quais botões estão clicados? \(self.arrayOfCategoryFilter)")
        
        if (hiddenRefinedSearch == false){
            refineButton.setTitle("\u{2191} Ocultar opções refinadas", for: .normal)
            hiddenRefinedSearch = true
            
            openAir.isHidden = false
            nightClub.isHidden = false
            theater.isHidden = false
            shopping.isHidden = false
            museum.isHidden = false
            music.isHidden = false
            hotel.isHidden = false
            gastronomy.isHidden = false
        }else{
            refineButton.setTitle("\u{2193} Refinar pesquisa", for: .normal)
            hiddenRefinedSearch = false
            
            openAir.isHidden = true
            nightClub.isHidden = true
            theater.isHidden = true
            shopping.isHidden = true
            museum.isHidden = true
            music.isHidden = true
            hotel.isHidden = true
            gastronomy.isHidden = true
        }
    }
    
    @objc func openAirClicked() {
        if (openAirFlag == false){
            openAirFlag = true
            selectRefineButton(button: openAir)
            arrayOfCategoryFilter.append("Familia")
        }
        else{
            openAirFlag = false
            diselectRefineButton(button: openAir)
            arrayOfCategoryFilter = arrayOfCategoryFilter.filter(){$0 != "Familia"}
        }
    }
    @objc func nighClubClicked() {
        if (nightClubFlag == false){
            nightClubFlag = true
            selectRefineButton(button: nightClub)
            arrayOfCategoryFilter.append("Gastronomia")
        }
        else{
            nightClubFlag = false
            diselectRefineButton(button: nightClub)
            arrayOfCategoryFilter = arrayOfCategoryFilter.filter(){$0 != "Gastronomia"}
        }
    }
    @objc func theaterClicked() {
        if (theaterFlag == false){
            theaterFlag = true
            selectRefineButton(button: theater)
            arrayOfCategoryFilter.append("theater")
        }
        else{
            theaterFlag = false
            diselectRefineButton(button: theater)
            arrayOfCategoryFilter = arrayOfCategoryFilter.filter(){$0 != "theater"}
        }
    }
    @objc func shoppingClicked() {
        if (shoppingFlag == false){
            shoppingFlag = true
            selectRefineButton(button: shopping)
            arrayOfCategoryFilter.append("shopping")
        }
        else{
            shoppingFlag = false
            diselectRefineButton(button: shopping)
            arrayOfCategoryFilter = arrayOfCategoryFilter.filter(){$0 != "shopping"}
        }
    }
    @objc func museumClicked() {
        if (museumFlag == false){
            museumFlag = true
            selectRefineButton(button: museum)
            arrayOfCategoryFilter.append("museum")
        }
        else{
            museumFlag = false
            diselectRefineButton(button: museum)
            arrayOfCategoryFilter = arrayOfCategoryFilter.filter(){$0 != "museum"}
        }
    }
    @objc func musicClicked() {
        if (musicFlag == false){
            musicFlag = true
            selectRefineButton(button: music)
            arrayOfCategoryFilter.append("music")
        }
        else{
            musicFlag = false
            diselectRefineButton(button: music)
            arrayOfCategoryFilter = arrayOfCategoryFilter.filter(){$0 != "music"}
        }
    }
    @objc func hotelClicked() {
        if (hotelFlag == false){
            hotelFlag = true
            selectRefineButton(button: hotel)
            arrayOfCategoryFilter.append("hotel")
        }
        else{
            hotelFlag = false
            diselectRefineButton(button: hotel)
            arrayOfCategoryFilter = arrayOfCategoryFilter.filter(){$0 != "hotel"}
        }
    }
    @objc func gastronomyClicked() {
        if (gastronomyFlag == false){
            gastronomyFlag = true
            selectRefineButton(button: gastronomy)
            arrayOfCategoryFilter.append("gastronomy")
        }
        else{
            gastronomyFlag = false
            diselectRefineButton(button: gastronomy)
            arrayOfCategoryFilter = arrayOfCategoryFilter.filter(){$0 != "gastronomy"}
        }
    }
    @IBOutlet weak var testandoParaVerSeMuda: UILabel!
    
    @IBAction func searchButton(_ sender: UIButton) {
        
        if openAirFlag == false && nightClubFlag == false && theaterFlag == false && shoppingFlag == false && museumFlag == false && musicFlag == false && hotelFlag == false && gastronomyFlag == false{
            
            arrayOfCategoryFilter.append("Familia")
            arrayOfCategoryFilter.append("Gastronomia")
            arrayOfCategoryFilter.append("Natureza")
            arrayOfCategoryFilter.append("Esportes")
            arrayOfCategoryFilter.append("Arte")
            arrayOfCategoryFilter.append("Cultura")
            arrayOfCategoryFilter.append("Tecnologia")
            arrayOfCategoryFilter.append("Vida Noturna")
            arrayOfCategoryFilter.append("Landmarks")
            arrayOfCategoryFilter.append("Compras")
            arrayOfCategoryFilter.append("Negocios")
            arrayOfCategoryFilter.append("Teste")
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "matchProfile") as! MatchProfile
        
        newViewController.profile = self.profile
        newViewController.categoryFilters = self.arrayOfCategoryFilter
        
        let delimiter = ","
        let token = searchCityBar.text?.components(separatedBy: delimiter)
        let city = token![0]
        //let province = token![1]
        //let country = token![2]
        
        newViewController.searchForCity = city
        
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentListOfCities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CityTableCell else {
            return UITableViewCell()
        }
        cell.cityLabel.text = currentListOfCities[indexPath.row]
        cell.cityLabel.sizeToFit()
        //cell.backgroundColor = UIColor.darkGray
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CityTableCell else {
            return 0
        }
        return cell.bounds.height
    }
    
    //Ao clicar na cidade da table view, ela some e o texto dela passa para a search bar
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchCityBar.text = currentListOfCities[indexPath.row]
        tableViewOfCities.isHidden = true
    }
    
    //Muda a table view conforme o texto da search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentListOfCities = listOfCities.filter({ city -> Bool in
   
            if searchText.isEmpty {
                return true
            }
            return city.lowercased().contains(searchText.lowercased())
        
        })
        if searchText.isEmpty{
            tableViewOfCities.isHidden = true
            currentListOfCities = []
        }
        else{
            tableViewOfCities.isHidden = false
            //Serve para deixar a tableview no tamanho certo
            tableViewOfCities.frame = CGRect(x: tableViewOfCities.frame.origin.x, y: tableViewOfCities.frame.origin.y, width: tableViewOfCities.frame.size.width, height: tableViewOfCities.contentSize.height)
        }
        tableViewOfCities.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
      
        currentListOfCities = listOfCities
        
        tableViewOfCities.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class CityTableCell: UITableViewCell{
    
    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
