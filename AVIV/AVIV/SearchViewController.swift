//
//  SearchViewController.swift
//  AVIV
//
//  Created by Lucas Hardman on 18/03/19.
//  Copyright © 2019 Lucas Hardman. All rights reserved.
//

import UIKit
import Foundation

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

class SearchViewController: UIViewController {
    
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
    
    private var width: Double!
    private var height: Double!
    private var size: CGSize!
    private var radius: CGFloat!
    private var borderWidth: CGFloat!
    private var borderColor: CGColor!
    private var backgroundColor: UIColor!
    private var color: UIColor!
    
    private var suggestions: [Suggestion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        //Buscando Sugestões
        //let loadSuggestions = Suggestion.init()
        //loadSuggestions.loadFromFirebase()
    }
    
    private func loadSuggestionsFromFirebase(){
        
        let suggestion = Suggestion.init()
        suggestion.loadElement(addName: "Corcovado", addId: "1", addCategory: "Ponto Turistico", addMasterCategory: "openAir", addMainPhoto: "foto", addText: "Um lugar muito lindo", addLink: "http://www.tremdocorcovado.rio", addPhotoGallery: "varias fotos", addCity: "Rio de Janeiro", addProfile: "caracteristicas")
        suggestions.append(suggestion)
        
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
        }
        else{
            openAirFlag = false
            diselectRefineButton(button: openAir)
        }
    }
    @objc func nighClubClicked() {
        if (nightClubFlag == false){
            nightClubFlag = true
            selectRefineButton(button: nightClub)
        }
        else{
            nightClubFlag = false
            diselectRefineButton(button: nightClub)
        }
    }
    @objc func theaterClicked() {
        if (theaterFlag == false){
            theaterFlag = true
            selectRefineButton(button: theater)
        }
        else{
            theaterFlag = false
            diselectRefineButton(button: theater)
        }
    }
    @objc func shoppingClicked() {
        if (shoppingFlag == false){
            shoppingFlag = true
            selectRefineButton(button: shopping)
        }
        else{
            shoppingFlag = false
            diselectRefineButton(button: shopping)
        }
    }
    @objc func museumClicked() {
        if (museumFlag == false){
            museumFlag = true
            selectRefineButton(button: museum)
        }
        else{
            museumFlag = false
            diselectRefineButton(button: museum)
        }
    }
    @objc func musicClicked() {
        if (musicFlag == false){
            musicFlag = true
            selectRefineButton(button: music)
        }
        else{
            musicFlag = false
            diselectRefineButton(button: music)
        }
    }
    @objc func hotelClicked() {
        if (hotelFlag == false){
            hotelFlag = true
            selectRefineButton(button: hotel)
        }
        else{
            hotelFlag = false
            diselectRefineButton(button: hotel)
        }
    }
    @objc func gastronomyClicked() {
        if (gastronomyFlag == false){
            gastronomyFlag = true
            selectRefineButton(button: gastronomy)
        }
        else{
            gastronomyFlag = false
            diselectRefineButton(button: gastronomy)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
