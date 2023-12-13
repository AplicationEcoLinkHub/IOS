import UIKit
import Foundation
import Alamofire

class ModifierInitiativeController: UIViewController {

    @IBOutlet weak var image: UITextField!
    @IBOutlet weak var titre: UITextField!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var numero: UITextField!
    @IBOutlet weak var localisation: UITextField!
    @IBOutlet weak var heure: UIDatePicker!
    var initiative: Initiative?

    @IBAction func Modifier(_ sender: Any) {
        if let newTitle = titre.text, !newTitle.isEmpty {
            initiative?.titre = newTitle
        }
        if let newNumero = numero.text, !newNumero.isEmpty {
            initiative?.numero = Int(newNumero)!
        }
        if let newDesc = desc.text, !newDesc.isEmpty {
            initiative?.description = newDesc
        }
        if let newLocalisation = localisation.text, !newLocalisation.isEmpty {
            initiative?.localisation = newLocalisation
        }
        if let newImage = image.text, !newImage.isEmpty {
            initiative?.image = newImage
        }

        // Mettez à jour l'initiative sur le serveur
        if let initiative = initiative {
            updateInitiative(initiative)
        }

        navigationController?.popViewController(animated: true)

        showSuccessAlert()

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let initiative = initiative {
            // Préremplissez les champs avec les détails actuels de l'initiative
            titre.text = initiative.titre
            desc.text = initiative.description
            numero.text = "\(initiative.numero)"
            localisation.text = initiative.localisation

            // Convertir la chaîne de date en objet Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: initiative.heure) {
                heure.date = date
            }

            image.text = initiative.image
        }
    }

    func updateInitiative(_ initiative: Initiative) {
            // Assurez-vous que l'initiative a un ID valide
            guard let initiativeID = initiative.id else {
                print("L'initiative n'a pas d'ID valide.")
                return
            }

            // Construire l'URL de mise à jour avec l'ID de l'initiative
            let updateURL = "http://localhost:8000/api/initiatives/\(initiativeID)"

            // Construire les paramètres de mise à jour (sans inclure l'ID)
            let parameters: [String: Any] = [
                "titre": initiative.titre,
                "description": initiative.description,
                "numero": initiative.numero,
                "localisation": initiative.localisation,
                "image": initiative.image,
                "heure": initiative.heure
            ]

            // Effectuer la requête de mise à jour
            AF.request(updateURL, method: .put, parameters: parameters, encoding: JSONEncoding.default)
                .response { response in
                    switch response.result {
                    case .success:
                        print("Initiative mise à jour avec succès sur le serveur.")
                        self.showSuccessAlert() // Appel de la fonction pour afficher l'alerte et effectuer la redirection
                    case .failure(let error):
                        print("Erreur lors de la mise à jour de l'initiative sur le serveur : \(error)")
                    }
                }
        }

        func showSuccessAlert() {
            print("Affichage de l'alerte de succès")
            let alert = UIAlertController(title: "Succès", message: "Initiative modifiée avec succès", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.performSegue(withIdentifier: "showDetailleMarche", sender: self)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
