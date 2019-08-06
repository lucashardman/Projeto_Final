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
    
    //Switch e label dos filtros
    @IBOutlet weak var naturezaSwitch: UISwitch!
    @IBOutlet weak var naturezaLabel: UILabel!
    @IBOutlet weak var arteSwitch: UISwitch!
    @IBOutlet weak var arteLabel: UILabel!
    @IBOutlet weak var culturaSwitch: UISwitch!
    @IBOutlet weak var culturaLabel: UILabel!
    @IBOutlet weak var vidaNoturnaSwitch: UISwitch!
    @IBOutlet weak var vidaNoturnaLabel: UILabel!
    @IBOutlet weak var landmarksSwitch: UISwitch!
    @IBOutlet weak var landmarksLabel: UILabel!
    @IBOutlet weak var gastronomiaSwitch: UISwitch!
    @IBOutlet weak var gastronomiaLabel: UILabel!
    @IBOutlet weak var comprasSwitch: UISwitch!
    @IBOutlet weak var comprasLabel: UILabel!
    @IBOutlet weak var esportesSwitch: UISwitch!
    @IBOutlet weak var esportesLabel: UILabel!
    @IBOutlet weak var familiaSwitch: UISwitch!
    @IBOutlet weak var familiaLabel: UILabel!
    @IBOutlet weak var negociosSwitch: UISwitch!
    @IBOutlet weak var negociosLabel: UILabel!
    @IBOutlet weak var tecnologiaSwitch: UISwitch!
    @IBOutlet weak var tecnologiaLabel: UILabel!
    
    
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
 
    }
    
    private func loadViewElements(){
        
        //Tratamento dos elementos visiveis na tela
        refineButton.center = view.center;
        refineButton.setTitle("\u{2193} Refinar pesquisa", for: .normal)
        hiddenRefinedSearch = false
        
        naturezaSwitch.isHidden = true
        naturezaLabel.isHidden = true
        arteSwitch.isHidden = true
        arteLabel.isHidden = true
        culturaSwitch.isHidden = true
        culturaLabel.isHidden = true
        vidaNoturnaSwitch.isHidden = true
        vidaNoturnaLabel.isHidden = true
        landmarksSwitch.isHidden = true
        landmarksLabel.isHidden = true
        gastronomiaSwitch.isHidden = true
        gastronomiaLabel.isHidden = true
        comprasSwitch.isHidden = true
        comprasLabel.isHidden = true
        esportesSwitch.isHidden = true
        esportesLabel.isHidden = true
        familiaSwitch.isHidden = true
        familiaLabel.isHidden = true
        negociosSwitch.isHidden = true
        negociosLabel.isHidden = true
        tecnologiaSwitch.isHidden = true
        tecnologiaLabel.isHidden = true
        
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
    
    @IBAction func refineButtonClicked(_ sender: UIButton) {
        
        print("Quais botões estão clicados? \(self.arrayOfCategoryFilter)")
        
        if (hiddenRefinedSearch == false){
            refineButton.setTitle("\u{2191} Ocultar opções refinadas", for: .normal)
            hiddenRefinedSearch = true
            
            naturezaSwitch.isHidden = false
            naturezaLabel.isHidden = false
            arteSwitch.isHidden = false
            arteLabel.isHidden = false
            culturaSwitch.isHidden = false
            culturaLabel.isHidden = false
            vidaNoturnaSwitch.isHidden = false
            vidaNoturnaLabel.isHidden = false
            landmarksSwitch.isHidden = false
            landmarksLabel.isHidden = false
            gastronomiaSwitch.isHidden = false
            gastronomiaLabel.isHidden = false
            comprasSwitch.isHidden = false
            comprasLabel.isHidden = false
            esportesSwitch.isHidden = false
            esportesLabel.isHidden = false
            familiaSwitch.isHidden = false
            familiaLabel.isHidden = false
            negociosSwitch.isHidden = false
            negociosLabel.isHidden = false
            tecnologiaSwitch.isHidden = false
            tecnologiaLabel.isHidden = false
        
        }else{
            refineButton.setTitle("\u{2193} Refinar pesquisa", for: .normal)
            hiddenRefinedSearch = false
            
            naturezaSwitch.isHidden = true
            naturezaLabel.isHidden = true
            arteSwitch.isHidden = true
            arteLabel.isHidden = true
            culturaSwitch.isHidden = true
            culturaLabel.isHidden = true
            vidaNoturnaSwitch.isHidden = true
            vidaNoturnaLabel.isHidden = true
            landmarksSwitch.isHidden = true
            landmarksLabel.isHidden = true
            gastronomiaSwitch.isHidden = true
            gastronomiaLabel.isHidden = true
            comprasSwitch.isHidden = true
            comprasLabel.isHidden = true
            esportesSwitch.isHidden = true
            esportesLabel.isHidden = true
            familiaSwitch.isHidden = true
            familiaLabel.isHidden = true
            negociosSwitch.isHidden = true
            negociosLabel.isHidden = true
            tecnologiaSwitch.isHidden = true
            tecnologiaLabel.isHidden = true
   
        }
    }
    
    @IBAction func naturezaButton(_ sender: UISwitch) {
        if naturezaSwitch.isOn{
            arrayOfCategoryFilter.append("Natureza")
        }
        else{
            arrayOfCategoryFilter = arrayOfCategoryFilter.filter(){$0 != "Natureza"}
        }
    }
    @IBAction func arteButton(_ sender: UISwitch) {
        if arteSwitch.isOn{
            arrayOfCategoryFilter.append("Arte")
        }
        else{
            arrayOfCategoryFilter = arrayOfCategoryFilter.filter(){$0 != "Arte"}
        }
    }
    @IBAction func culturaButton(_ sender: UISwitch) {
        if culturaSwitch.isOn{
            arrayOfCategoryFilter.append("Cultura")
        }
        else{
            arrayOfCategoryFilter = arrayOfCategoryFilter.filter(){$0 != "Cultura"}
        }
    }
    @IBAction func vidaNoturnaButton(_ sender: UISwitch) {
        if vidaNoturnaSwitch.isOn{
            arrayOfCategoryFilter.append("Vida Noturna")
        }
        else{
            arrayOfCategoryFilter = arrayOfCategoryFilter.filter(){$0 != "Vida Noturna"}
        }
    }
    @IBAction func landmarksButton(_ sender: UISwitch) {
        if landmarksSwitch.isOn{
            arrayOfCategoryFilter.append("Landmarks")
        }
        else{
            arrayOfCategoryFilter = arrayOfCategoryFilter.filter(){$0 != "Landmarks"}
        }
    }
    @IBAction func gastronomiaButton(_ sender: UISwitch) {
        if gastronomiaSwitch.isOn{
            arrayOfCategoryFilter.append("Gastronomia")
        }
        else{
            arrayOfCategoryFilter = arrayOfCategoryFilter.filter(){$0 != "Gastronomia"}
        }
    }
    @IBAction func comprasButton(_ sender: UISwitch) {
        if comprasSwitch.isOn{
            arrayOfCategoryFilter.append("Compras")
        }
        else{
            arrayOfCategoryFilter = arrayOfCategoryFilter.filter(){$0 != "Compras"}
        }
    }
    @IBAction func esportesButton(_ sender: UISwitch) {
        if esportesSwitch.isOn{
            arrayOfCategoryFilter.append("Esportes")
        }
        else{
            arrayOfCategoryFilter = arrayOfCategoryFilter.filter(){$0 != "Esportes"}
        }
    }
    @IBAction func familiaButton(_ sender: UISwitch) {
        if familiaSwitch.isOn{
            arrayOfCategoryFilter.append("Familia")
        }
        else{
            arrayOfCategoryFilter = arrayOfCategoryFilter.filter(){$0 != "Familia"}
        }
    }
    @IBAction func negociosButton(_ sender: UISwitch) {
        if negociosSwitch.isOn{
            arrayOfCategoryFilter.append("Negocios")
        }
        else{
            arrayOfCategoryFilter = arrayOfCategoryFilter.filter(){$0 != "Negocios"}
        }
    }
    @IBAction func tecnologiaButton(_ sender: UISwitch) {
        if tecnologiaSwitch.isOn{
            arrayOfCategoryFilter.append("Tecnologia")
        }
        else{
            arrayOfCategoryFilter = arrayOfCategoryFilter.filter(){$0 != "Tecnologia"}
        }
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "matchProfile") as! MatchProfile
        
        newViewController.profile = self.profile
        newViewController.categoryFilters = self.arrayOfCategoryFilter
        
        let delimiter = ","
        let token = searchCityBar.text?.components(separatedBy: delimiter)
        let city = token![0]
        
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
