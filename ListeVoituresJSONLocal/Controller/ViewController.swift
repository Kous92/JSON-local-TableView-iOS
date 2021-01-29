//
//  ViewController.swift
//  ListeVoituresJSONLocal
//
//  Created by Koussaïla Ben Mamar on 28/01/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var listeMarquesVoitures: UITableView!
    @IBOutlet weak var barreRecherche: UISearchBar!
    
    var carBrands = [Cars]()
    var filteredCarBrands = [Cars]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        listeMarquesVoitures.delegate = self
        listeMarquesVoitures.dataSource = self
        barreRecherche.delegate = self
        
        initialiserListe()
        filteredCarBrands = carBrands
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCarBrands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cellule (TableViewCell) personnalisée
        let cell = tableView.dequeueReusableCell(withIdentifier: "carBrandCell", for: indexPath) as! CarBrandTableViewCell
        cell.configuration(with: filteredCarBrands[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "carModelSegue", sender: self)
    }
    
    // De la cellule, on transite vers le ViewController de la marque de la voiture avec les données de la cellule
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CarViewController
        {
            // On vérifie que le contenu de l'article existe
            guard let index = listeMarquesVoitures.indexPathForSelectedRow?.row else
            {
                return
            }
        
            // On envoie au ViewController les données de la marque
            destination.car = filteredCarBrands[index]
            destination.imageName = filteredCarBrands[index].imageName
        }
    }
    
    private func initialiserListe() {
        // Vérification de l'existence du fichier data.json
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        var listeVoitures: CarBrands?
        
        do {
            // Récupération des données JSON en type Data
            let data = try Data(contentsOf: url)
            
            // Décodage des données JSON en objets exploitables
            listeVoitures = try JSONDecoder().decode(CarBrands.self, from: data)
            
            if let result = listeVoitures {
                //print(result)
                
                if let cars = result.cars {
                    carBrands = cars
                    // print(carBrands)
                }
            } else {
                print("Échec lors du décodage des données")
            }
        } catch {
            print("ERREUR: \(error)")
        }
    }
    
    // Filtrage des marques automobiles
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            // Champ vide: aucun filtre = toutes les marques dans la liste
            filteredCarBrands = carBrands
        } else {
            // Filtre présent, on remplit le tableau des données filtrées
            filteredCarBrands.removeAll()
            for brands in carBrands {
                if let brand = brands.brandName {
                    if brand.lowercased().contains(searchText.lowercased()) {
                        filteredCarBrands.append(brands)
                    }
                }
            }
        }
        
        // À chaque changement, la liste (TableView) doit être actualisée
        self.listeMarquesVoitures.reloadData()
    }
    
    // Dès qu'on a cliqué sur la barre de recherche
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        barreRecherche.resignFirstResponder() // Le clavier disparaît (ce n'est pas automatique de base)
        print(searchBar.text!)
    }
}

