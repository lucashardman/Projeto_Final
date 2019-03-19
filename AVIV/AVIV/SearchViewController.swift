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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refineButton.center = view.center;
        refineButton.setTitle("\u{2193} Refinar pesquisa", for: .normal)
        hiddenRefinedSearch = false
    }
    
    @IBAction func refineButtonClicked(_ sender: UIButton) {
        
        if (hiddenRefinedSearch == false){
            refineButton.setTitle("\u{2191} Ocultar opções refinadas", for: .normal)
            hiddenRefinedSearch = true
        }else{
            refineButton.setTitle("\u{2193} Refinar pesquisa", for: .normal)
            hiddenRefinedSearch = false
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
