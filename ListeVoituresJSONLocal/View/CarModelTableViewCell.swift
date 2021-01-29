//
//  CarModelTableViewCell.swift
//  Liste voitures JSON
//
//  Created by Koussaïla Ben Mamar on 21/01/2021.
//

import UIKit

class CarModelTableViewCell: UITableViewCell {

    @IBOutlet weak var texteNomModèle: UILabel!
    @IBOutlet weak var textePuissanceVitesse: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configuration(with car: Car)
    {
        if let model = car.modelName, let power = car.power, let speed = car.maxSpeed {
            self.texteNomModèle.text = model
            self.textePuissanceVitesse.text = "\(power) chevaux, \(speed) km/h"
        } else {
            self.texteNomModèle.text = "Modèle inconnu"
            self.textePuissanceVitesse.text = "Puissance et vitesse max inconnue"
        }
        
    }
}
