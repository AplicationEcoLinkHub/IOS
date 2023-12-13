//
//  ViewController.swift
//  EcoLinkHub
//
//  Created by Zeynab Mounkaila on 27/11/2023.
//
import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var dechets: UIImageView!
    @IBOutlet weak var marcheBio: UIImageView!
    @IBOutlet weak var covoiturage: UIImageView!
    @IBOutlet weak var eau: UIImageView!
    @IBOutlet weak var energie: UIImageView!
    @IBOutlet weak var consommation: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Ajouter un geste de tap à chaque image
        addTapGesture(to: dechets, segueIdentifier: "ShowDetailDechets")
        addTapGesture(to: marcheBio, segueIdentifier: "ShowDetailMarche")
        addTapGesture(to: covoiturage, segueIdentifier: "ShowDetailCovoiturage")
        addTapGesture(to: eau, segueIdentifier: "ShowDetailEau")
        addTapGesture(to: energie, segueIdentifier: "ShowDetailEnergie")
        addTapGesture(to: consommation, segueIdentifier: "ShowDetailConsommation")
    }

    func addTapGesture(to imageView: UIImageView?, segueIdentifier: String) {
        guard let imageView = imageView else {
            print()
            return
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true

        imageSegueMap[imageView] = segueIdentifier
    }

    // Dictionnaire pour stocker les identifiants de segue associés à chaque image
    var imageSegueMap: [UIImageView: String] = [:]

    @objc func imageTapped(sender: UITapGestureRecognizer) {
        // Vérifier quelle image a été tapée
        if let tappedImageView = sender.view as? UIImageView,
           let segueIdentifier = imageSegueMap[tappedImageView] {
            // Déclencher le segue avec l'identifiant spécifié dans le storyboard
            performSegue(withIdentifier: segueIdentifier, sender: self)
        }
    }
}


