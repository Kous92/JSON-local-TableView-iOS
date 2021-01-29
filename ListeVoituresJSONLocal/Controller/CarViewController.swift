//
//  CarViewController.swift
//  Liste voitures JSON
//
//  Created by Koussaïla Ben Mamar on 21/01/2021.
//

import UIKit

class CarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imageLogoMarque: UIImageView!
    @IBOutlet weak var texteVoituresMarque: UILabel!
    @IBOutlet weak var listeModèles: UITableView!
    
    var imageName: String?
    var car: Cars?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listeModèles.delegate = self
        listeModèles.dataSource = self
        listeModèles.tableHeaderView = UIView()
        listeModèles.tableFooterView = UIView()
        self.imageLogoMarque.image = UIImage(named: imageName ?? "not_ok")
        self.texteVoituresMarque.text = car?.brandName ?? "Inconnu"
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return car?.models?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cellule (TableViewCell) personnalisée
        let cell = tableView.dequeueReusableCell(withIdentifier: "carModelCell", for: indexPath) as! CarModelTableViewCell
        
        guard let model = car?.models?[indexPath.row] else {
            return cell
        }
        cell.configuration(with: model)
        
        return cell
    }
    
    @IBAction func closeView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
