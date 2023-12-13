import UIKit

class AjouterInitiativeController: UIViewController {

    @IBOutlet weak var image: UITextField!
    @IBOutlet weak var titre: UITextField!
    @IBOutlet weak var numero: UITextField!
    @IBOutlet weak var localisation: UITextField!
    @IBOutlet weak var desciption: UITextField!
    @IBOutlet weak var heure: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func nouveau(_ sender: Any) {
        // Récupérer les valeurs saisies par l'utilisateur
        guard
            let titre = titre.text,
            let description = desciption.text,
            let numero = numero.text,
            let image = image.text,
            let localisation = localisation.text
        else {
            // Gérer le cas où l'une des valeurs est manquante
            return
        }

        // Récupérer la date sélectionnée dans le datePicker
        let heure = heure.date

        // Créer l'objet d'initiative avec les valeurs des champs
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, h:mm a"
        let nouvelleInitiative = Initiative(
            titre: titre,
            description: description,
            numero: Int(numero)!,
            heure: heure.formatted(),
            image: image,
            localisation: localisation
        )

        // Créer l'URL de votre API backend
        guard let url = URL(string: "http://localhost:8000/api/initiatives") else {
            return
        }

        // Définir la requête
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            // Convertir l'objet Initiative en JSON
            let jsonData = try JSONEncoder().encode(nouvelleInitiative)
            request.httpBody = jsonData
        } catch {
            print("Erreur lors de la conversion de l'objet en JSON: \(error)")
            return
        }

        // Effectuer la requête
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Gérer la réponse
            if let data = data {
                print("Réponse de l'API reçue avec succès")
                do {
                    // Analyser la réponse JSON (si nécessaire)
                    let responseInitiative = try JSONDecoder().decode(Initiative.self, from: data)
                    print("Initiative ajoutée avec succès : \(responseInitiative)")

                    // Afficher une alerte pour informer de l'ajout réussi
                    DispatchQueue.main.async {
                        self.showSuccessAlert()

                        // Rediriger vers la page DetailleMarcheController après l'ajout
                        self.performSegue(withIdentifier: "showDetailleMarche", sender: self)
                    }

                } catch {
                    print("Erreur lors de l'analyse de la réponse JSON : \(error)")
                }
            } else if let error = error {
                print("Erreur lors de la requête : \(error)")
            }

            // Mettez à jour l'interface utilisateur sur le fil principal si nécessaire
            DispatchQueue.main.async {
                // Mettre à jour l'interface utilisateur
                // ...
            }

        }.resume()
    }

    func showSuccessAlert() {
        print("Affichage de l'alerte de succès")
        let alert = UIAlertController(title: "Succès", message: "Initiative ajoutée avec succès", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            
            self.performSegue(withIdentifier: "showDetailleMarche", sender: self)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: {
            print("Alerte affichée avec succès")
        })
    }

}
