//
//  SearchViewController.swift
//  AVIV
//
//  Created by Lucas Hardman on 18/03/19.
//  Copyright © 2019 Lucas Hardman. All rights reserved.
//

import UIKit
import Foundation

class SearchViewController: UIViewController {
    
    @IBOutlet weak var refineButton: UIButton!
    private var hiddenRefinedSearch: Bool = false
    
    @IBOutlet weak var openAir: UIButton!
    @IBOutlet weak var nightClub: UIButton!
    @IBOutlet weak var theater: UIButton!
    @IBOutlet weak var shopping: UIButton!
    @IBOutlet weak var museum: UIButton!
    @IBOutlet weak var music: UIButton!
    @IBOutlet weak var hotel: UIButton!
    @IBOutlet weak var gastronomy: UIButton!
    
    //Flags de filtro de busca inicializadas como false, pois não há filtros por default
    private var openAirFlag: Bool = false
    private var nightClubFlag: Bool = false
    private var theaterFlag: Bool = false
    private var shoppingFlag: Bool = false
    private var museumFlag: Bool = false
    private var musicFlag: Bool = false
    private var hotelFlag: Bool = false
    private var gastronomyFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refineButton.center = view.center;
        refineButton.setTitle("\u{2193} Refinar pesquisa", for: .normal)
        hiddenRefinedSearch = false
        loadRefineButtons()
    }
    
    private func loadRefineButtons(){
        openAir.isHidden = true
        nightClub.isHidden = true
        theater.isHidden = true
        shopping.isHidden = true
        museum.isHidden = true
        music.isHidden = true
        hotel.isHidden = true
        gastronomy.isHidden = true
        
        openAir.setImage(UIImage(named: "openAir"), for: .normal)
        nightClub.setImage(UIImage(named: "nightClub"), for: .normal)
        theater.setImage(UIImage(named: "theater"), for: .normal)
        shopping.setImage(UIImage(named: "shopping"), for: .normal)
        museum.setImage(UIImage(named: "museum"), for: .normal)
        music.setImage(UIImage(named: "music"), for: .normal)
        hotel.setImage(UIImage(named: "hotel"), for: .normal)
        gastronomy.setImage(UIImage(named: "gastronomy"), for: .normal)
        
        openAir.frame.size = CGSize(width: 40, height: 40)
        nightClub.frame.size = CGSize(width: 40, height: 40)
        theater.frame.size = CGSize(width: 40, height: 40)
        shopping.frame.size = CGSize(width: 40, height: 40)
        museum.frame.size = CGSize(width: 40, height: 40)
        music.frame.size = CGSize(width: 40, height: 40)
        hotel.frame.size = CGSize(width: 40, height: 40)
        gastronomy.frame.size = CGSize(width: 40, height: 40)
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
    
    @IBAction func openAirClicked(_ sender: UIButton) {
        if (openAirFlag == false){
            openAirFlag = true
        }
        else{
            openAirFlag = false
        }
    }
    @IBAction func nighClubsClicked(_ sender: UIButton) {
        if (nightClubFlag == false){
            nightClubFlag = true
        }
        else{
            nightClubFlag = false
        }
    }
    @IBAction func theaterClicked(_ sender: UIButton) {
        if (theaterFlag == false){
            theaterFlag = true
        }
        else{
            theaterFlag = false
        }
    }
    @IBAction func shoppingClicked(_ sender: UIButton) {
        if (shoppingFlag == false){
            shoppingFlag = true
        }
        else{
            shoppingFlag = false
        }
    }
    @IBAction func museumClicked(_ sender: UIButton) {
        if (museumFlag == false){
            museumFlag = true
        }
        else{
            museumFlag = false
        }
    }
    @IBAction func musicClicked(_ sender: UIButton) {
        if (musicFlag == false){
            musicFlag = true
        }
        else{
            musicFlag = false
        }
    }
    @IBAction func hotelClicked(_ sender: UIButton) {
        if (hotelFlag == false){
            hotelFlag = true
        }
        else{
            hotelFlag = false
        }
    }
    @IBAction func gastronomyClicked(_ sender: UIButton) {
        if (gastronomyFlag == false){
            gastronomyFlag = true
        }
        else{
            gastronomyFlag = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
