//
//  InitiativeTableViewCell.swift
//  EcoLinkHub
//
//  Created by Zeynab Mounkaila on 30/11/2023.
//

import UIKit

class InitiativeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var numeroImageView: UIImageView!
    @IBOutlet weak var localisationImageView: UIImageView!
    @IBOutlet weak var heureLabel: UILabel!

    func configureCell(with initiative: Initiative) {
        titleLabel.text = initiative.titre
        descriptionLabel.text = initiative.description
        heureLabel.text = "Heure: \(formatDate(initiative.heure))" // Utilisez une fonction pour formater la date selon vos besoins

        // Configurer l'image numéro pour déclencher l'appel téléphonique
        let tapNumeroGesture = UITapGestureRecognizer(target: self, action: #selector(numeroTapped))
        numeroImageView.addGestureRecognizer(tapNumeroGesture)
        numeroImageView.isUserInteractionEnabled = true

        // Configurer l'image localisation pour ouvrir l'application Maps
        let tapLocalisationGesture = UITapGestureRecognizer(target: self, action: #selector(localisationTapped))
        localisationImageView.addGestureRecognizer(tapLocalisationGesture)
        localisationImageView.isUserInteractionEnabled = true
    }

    @objc func numeroTapped() {
        // Déclencher l'appel téléphonique avec le numéro de téléphone de l'initiative
        // Assurez-vous que l'initiative a une propriété avec le numéro de téléphone
        if let numero = titleLabel.text {
            if let url = URL(string: "tel://\(numero)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    @objc func localisationTapped() {
        // Ouvrir l'application Maps avec la localisation de l'initiative
        // Assurez-vous que l'initiative a une propriété avec la localisation
        if let localisation = localisationImageView.image {
            // Utilisez la localisation pour ouvrir l'application Maps
            // Vous devrez ajuster cela en fonction de la manière dont vous stockez la localisation dans votre modèle
            // Vous pouvez utiliser la latitude et la longitude, par exemple
        }
    }

    // Fonction pour formater la date selon vos besoins
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
}
