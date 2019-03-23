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
        refineButton.center = view.center;
        refineButton.setTitle("\u{2193} Refinar pesquisa", for: .normal)
        hiddenRefinedSearch = false
        
        
        loadRefineButtons(buttons: [openAir,
                                    nightClub,
                                    theater,
                                    shopping,
                                    museum,
                                    music,
                                    hotel,
                                    gastronomy])
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
        
        
        buttons.forEach{ button in
            button.isHidden = true
            
            button.setImage(UIImage(named: (button.titleLabel?.text)!)?.addImagePadding(extraWidth: width*8, extraHeight: height*8), for: .normal)
            button.frame.size = size
            button.layer.cornerRadius = radius
            button.layer.borderWidth = borderWidth
            button.layer.borderColor = borderColor
            button.backgroundColor = backgroundColor
            button.tintColor = color
            button.clipsToBounds = true
            button.layer.masksToBounds = true
            button.contentMode = UIView.ContentMode.scaleAspectFill
        }
    }
    
    private func selectRefineButton(button: UIButton){
        /*
        width = 70
        height = 70
        size = CGSize(width: width, height: height)
        radius = CGFloat(Double(height/2))
        button.frame.size = size
        button.layer.cornerRadius = radius
        */
        
        button.layer.borderWidth = CGFloat(Double(0))
        button.backgroundColor = UIColor.init(red: CGFloat(147.0/255.0), green: CGFloat(147.0/255.0), blue: CGFloat(149.0/255.0), alpha: CGFloat(1))
        button.tintColor = UIColor.white
        
    }
    private func diselectRefineButton(button: UIButton){
        /*
        width = 70
        height = 70
        size = CGSize(width: width, height: height)
        radius = CGFloat(Double(height/2))
        button.frame.size = size
        button.layer.cornerRadius = radius
        */
        
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
    
    @IBAction func openAirClicked(_ sender: UIButton) {
        if (openAirFlag == false){
            openAirFlag = true
            selectRefineButton(button: openAir)
        }
        else{
            openAirFlag = false
            diselectRefineButton(button: openAir)
        }
    }
    @IBAction func nighClubsClicked(_ sender: UIButton) {
        if (nightClubFlag == false){
            nightClubFlag = true
            selectRefineButton(button: nightClub)
        }
        else{
            nightClubFlag = false
            diselectRefineButton(button: nightClub)
        }
    }
    @IBAction func theaterClicked(_ sender: UIButton) {
        if (theaterFlag == false){
            theaterFlag = true
            selectRefineButton(button: theater)
        }
        else{
            theaterFlag = false
            diselectRefineButton(button: theater)
        }
    }
    @IBAction func shoppingClicked(_ sender: UIButton) {
        if (shoppingFlag == false){
            shoppingFlag = true
            selectRefineButton(button: shopping)
        }
        else{
            shoppingFlag = false
            diselectRefineButton(button: shopping)
        }
    }
    @IBAction func museumClicked(_ sender: UIButton) {
        if (museumFlag == false){
            museumFlag = true
            selectRefineButton(button: museum)
        }
        else{
            museumFlag = false
            diselectRefineButton(button: museum)
        }
    }
    @IBAction func musicClicked(_ sender: UIButton) {
        if (musicFlag == false){
            musicFlag = true
            selectRefineButton(button: music)
        }
        else{
            musicFlag = false
            diselectRefineButton(button: music)
        }
    }
    @IBAction func hotelClicked(_ sender: UIButton) {
        if (hotelFlag == false){
            hotelFlag = true
            selectRefineButton(button: hotel)
        }
        else{
            hotelFlag = false
            diselectRefineButton(button: hotel)
        }
    }
    @IBAction func gastronomyClicked(_ sender: UIButton) {
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
