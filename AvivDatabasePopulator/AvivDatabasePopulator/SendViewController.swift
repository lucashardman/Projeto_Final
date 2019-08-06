//
//  LogoutViewController.swift
//  AVIV
//
//  Created by Lucas on 12/03/19.
//  Copyright © 2018 Lucas. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SendViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //O botão de logout é o mesmo de enviar as informações
        loadLogoutButton()
    }
    
    private func loadLogoutButton(){
        
        let logoutButton = UIButton(type: .custom)
        logoutButton.backgroundColor = UIColor.darkGray
        logoutButton.frame = CGRect(x: 0, y: 0, width: 180, height: 40)
        logoutButton.center = view.center;
        logoutButton.setTitle("Concluir", for: .normal)
        logoutButton.addTarget(self, action: #selector(self.logoutButtonAction), for: .touchUpInside)
        
        view.addSubview(logoutButton)
    }
    
    @objc func logoutButtonAction() {
        print ("Logout Pressed")
        let loginManager = LoginManager()
        loginManager.logOut()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "loginViewController")
        self.present(newViewController, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
