import UIKit
import ContactsUI

class TableViewCellController: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var edit: UIImageView!
    @IBOutlet weak var delete: UIImageView!
    @IBOutlet weak var ittineraire: UIImageView!
    @IBOutlet weak var tel: UIImageView!
    @IBOutlet weak var like: UIImageView!
    @IBOutlet weak var partage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var decr: UILabel!
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var partager: UILabel!
    
    @IBOutlet weak var heure: UILabel!
    @IBOutlet weak var lovalisation: UILabel!
    @IBOutlet weak var numero: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Ajoutez un geste de tap sur l'image "like"
        let likeTapGesture = UITapGestureRecognizer(target: self, action: #selector(likeTapped(_:)))
        like.addGestureRecognizer(likeTapGesture)
        like.isUserInteractionEnabled = true
        
        // Ajoutez un geste de tap sur le label "numero"
        let numeroTapGesture = UITapGestureRecognizer(target: self, action: #selector(numeroTapped))
        numero.addGestureRecognizer(numeroTapGesture)
        numero.isUserInteractionEnabled = true
        
        let localisationTapGesture = UITapGestureRecognizer(target: self, action: #selector(lovalisationTapped))
        lovalisation.addGestureRecognizer(localisationTapGesture)
        lovalisation.isUserInteractionEnabled = true

        let partagerTapGesture = UITapGestureRecognizer(target: self, action: #selector(partagerTapped))
        partager.addGestureRecognizer(partagerTapGesture)
        partager.isUserInteractionEnabled = true

        let deleteTapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteTapped))
            delete.addGestureRecognizer(deleteTapGesture)
            delete.isUserInteractionEnabled = true
    }
    
    @objc func deleteTapped() {
        
        if let viewController = findViewController() as? DetailleMarcheController {
            viewController.deleteInitiative(for: self)
        }
    }

    @objc func likeTapped(_ sender: UITapGestureRecognizer) {
        // Changez l'image de "like" à chaque tap
        let currentImage = like.image
        let newImage = (currentImage == UIImage(named: "emptyHeart")) ? UIImage(named: "redHeart") : UIImage(named: "emptyHeart")
        like.image = newImage
    }
    @objc func numeroTapped() {
        // Récupérez le numéro de l'initiative à partir du label
        guard let numeroText = numero.text else {
            print("Numéro de téléphone non valide.")
            return
        }

        // Supprimez les espaces du numéro de téléphone
        let cleanedNumero = numeroText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        // Vérifiez que l'URL du téléphone est valide
        guard let smsURL = URL(string: "sms:\(cleanedNumero)") else {
            print("Impossible de créer l'URL pour l'application Messages.")
            return
        }

        // Vérifiez que l'application Messages peut être ouverte
        guard UIApplication.shared.canOpenURL(smsURL) else {
            print("Impossible d'ouvrir l'application Messages.")
            return
        }

        // Ouvrez l'application Messages avec le numéro pré-rempli
        UIApplication.shared.open(smsURL, options: [:], completionHandler: { success in
            if success {
                print("L'application Messages a été ouverte avec succès.")
            } else {
                print("Impossible d'ouvrir l'application Messages.")
            }
        })
    }

    @objc func lovalisationTapped() {
        // Récupérez la localisation de l'initiative à partir du label
        guard let locationText = lovalisation.text else {
            print("Localisation non valide.")
            return
        }

        // Encodez la localisation pour l'URL
        guard let encodedLocation = locationText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Impossible d'encoder la localisation pour l'URL.")
            return
        }

        // Vérifiez que l'URL de Plans est valide
        guard let mapsURL = URL(string: "http://maps.apple.com/?address=\(encodedLocation)") else {
            print("Impossible de créer l'URL de Plans.")
            return
        }

        // Vérifiez que l'application Plans peut être ouverte
        guard UIApplication.shared.canOpenURL(mapsURL) else {
            print("Impossible d'ouvrir l'application Plans.")
            return
        }

        // Ouvrez l'application Plans avec la localisation
        UIApplication.shared.open(mapsURL, options: [:], completionHandler: { success in
            if success {
                print("L'URL de Plans a été ouverte avec succès.")
            } else {
                print("Impossible d'ouvrir l'URL de Plans.")
            }
        })
    }
    @objc func partagerTapped() {
        // Récupérez les données de l'initiative que vous souhaitez partager
        guard let titreText = titre.text, let descriptionText = decr.text else {
            print("Données non valides pour le partage.")
            return
        }

        // Créez le texte que vous souhaitez partager
        let partageText = "Découvrez cette initiative : \(titreText)\n\(descriptionText)"

        // Créez l'objet UIActivityViewController
        let activityViewController = UIActivityViewController(activityItems: [partageText], applicationActivities: nil)

        // Présentez le contrôleur d'activité
        if let viewController = findViewController() {
            viewController.present(activityViewController, animated: true, completion: nil)
        }
    }

    // Fonction pour trouver la vue parente (View Controller) à partir de la cellule
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            responder = nextResponder
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

}

