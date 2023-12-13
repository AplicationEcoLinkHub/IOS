import UIKit

class initiativeCellController: UITableViewCell {

    @IBOutlet var initiativeImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var heureLabel: UILabel!

    @IBOutlet weak var localisationImageView: UIImageView!
    @IBOutlet weak var numeroImageView: UIImageView!

    func configureCell(with initiative: Initiative) {
        titleLabel.text = initiative.titre
        descriptionLabel.text = initiative.description
        initiativeImageView.image = UIImage(named: initiative.image) // Assurez-vous que votre modèle Initiative a une propriété image de type String
        heureLabel.text = "Heure: \(formatDate(initiative.heure))"

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
        if let numero = titleLabel.text, let url = URL(string: "tel://\(numero)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @objc func localisationTapped() {
        // Ouvrir l'application Maps avec la localisation de l'initiative
        // Vous devrez ajuster cela en fonction de la manière dont vous stockez la localisation dans votre modèle
    }

    // Fonction pour formater la date selon vos besoins
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
}
