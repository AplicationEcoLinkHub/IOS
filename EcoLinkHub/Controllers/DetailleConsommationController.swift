//
//  DetailleConsommationController.swift
//  EcoLinkHub
//
//  Created by Zeynab Mounkaila on 28/11/2023.
//

import UIKit

class DetailleConsommationController: UIViewController {

   
    @IBOutlet weak var add: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        add.addGestureRecognizer(tapGesture)
        add.isUserInteractionEnabled = true
    }

    @objc func imageTapped() {
        // Déclencher le segue avec l'identifiant spécifié dans le storyboard
        performSegue(withIdentifier: "showAjouter", sender: self)
    }
}

