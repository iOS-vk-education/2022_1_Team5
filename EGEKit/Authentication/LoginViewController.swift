//
//  LoginViewController.swift
//  EGEKit
//
//  Created by user on 08.05.2022.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var loginField: UITextField!
    
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
        
    private var email: String { loginField.text! }
    private var password: String { passField.text! }
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NetworkManager.userEmail)
        
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)

    }
    
    @objc
    private func handleLogin() {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            guard error == nil else {
                self?.errorLabel.text = error?.localizedDescription
                self?.errorLabel.isHidden = false
                return
            }
            NetworkManager.userEmail = (self?.email)!
            
            FavouriteManager.shared.getFavourites()
            
            self?.dismiss(animated: true)
        }
    }


}

