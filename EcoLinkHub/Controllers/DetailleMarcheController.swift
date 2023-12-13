import UIKit
import Alamofire

class DetailleMarcheController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var add: UIImageView!
    @IBOutlet weak var table: UITableView!

    
    var initiatives: [Initiative] = []
    var filteredInitiatives: [Initiative] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        add.addGestureRecognizer(tapGesture)
        add.isUserInteractionEnabled = true

        
        fetchInitiatives()

        
        table.delegate = self
        table.dataSource = self

        
        search.delegate = self
    }

    @objc func imageTapped() {
        // Trigger the segue with the specified identifier in the storyboard
        performSegue(withIdentifier: "showAjouter", sender: self)
    }

    func fetchInitiatives() {
        AF.request("http://localhost:8000/api/initiatives")
        
           /*http://172.18.11.179:8000/api/initiatives*/
            .responseDecodable(of: [Initiative].self) { response in
            switch response.result {
            case .success(let initiatives):
                self.initiatives = initiatives
                self.filteredInitiatives = initiatives
                print("Initiatives: \(self.initiatives)")
                self.table.reloadData() 
            case .failure(let error):
                print("Erreur de chargement des initiatives: \(error)")
            }
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredInitiatives.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCellController

        let initiative = filteredInitiatives[indexPath.row]

        // recuperation
        cell.titre.text = initiative.titre
        cell.decr.text = initiative.description
        cell.heure.text = "\(initiative.heure)"
        cell.lovalisation.text = initiative.localisation
        cell.numero.text = "\(initiative.numero)"

        if let url = URL(string: initiative.image) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.cellImage.image = UIImage(data: data)
                    }
                }
            }.resume()
        }

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editTapped))
        cell.edit.addGestureRecognizer(tapGesture)
        cell.edit.isUserInteractionEnabled = true
        
        // Ajoutez un geste de tap sur l'image "like"
        let likeTapGesture = UITapGestureRecognizer(target: cell, action: #selector(cell.likeTapped(_:)))
            cell.like.addGestureRecognizer(likeTapGesture)
            cell.like.isUserInteractionEnabled = true

        return cell
        

    }

    // ...

    func deleteInitiative(for cell: TableViewCellController) {
        guard let indexPath = table.indexPath(for: cell) else {
            print("Impossible d'obtenir l'indexPath de la cellule.")
            return
        }

        let initiativeToDelete = filteredInitiatives[indexPath.row]

        // Effectuez une requête DELETE vers votre point d'API directement lorsque l'image de suppression est tapée
        let deleteURL = "http://localhost:8000/api/initiatives/delete"

        AF.request(deleteURL, method: .delete, parameters: ["titre": initiativeToDelete.titre, "description": initiativeToDelete.description])
            .response { response in
                switch response.result {
                case .success:
                    print("Initiative supprimée avec succès sur le serveur.")
                    // Retirez l'initiative du tableau local
                    self.filteredInitiatives.remove(at: indexPath.row)

                    // Mettez à jour la table view
                    self.table.reloadData()
                case .failure(let error):
                    print("Erreur lors de la suppression de l'initiative sur le serveur : \(error)")
                }
            }
    }

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            // Si le texte saisi est vide, afficher toutes les initiatives
            filteredInitiatives = initiatives
        } else {
            // Filtrer les initiatives en fonction du texte saisi
            filteredInitiatives = initiatives.filter { initiative in
                return initiative.titre.lowercased().contains(searchText.lowercased())
            }
        }
        table.reloadData()
    }
    @objc func editTapped() {
        // Get the selected initiative
        if let selectedIndexPath = table.indexPathForSelectedRow {
            let selectedInitiative = filteredInitiatives[selectedIndexPath.row]
            
            // Perform segue to ModifierInitiativeController
            performSegue(withIdentifier: "showModifier", sender: selectedInitiative)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showModifier", let modifierController = segue.destination as? ModifierInitiativeController, let selectedInitiative = sender as? Initiative {
            modifierController.initiative = selectedInitiative
        }
    }
}
