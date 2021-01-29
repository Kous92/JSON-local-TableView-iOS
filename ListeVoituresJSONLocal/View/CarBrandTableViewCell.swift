//
//  CarBrandTableViewCell.swift
//  Liste voitures JSON
//
//  Created by Koussaïla Ben Mamar on 21/01/2021.
//

import UIKit

class CarBrandTableViewCell: UITableViewCell {

    @IBOutlet weak var logoMarque: UIImageView!
    @IBOutlet weak var texteMarqueVoiture: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configuration(with car: Cars)
    {
        self.logoMarque.image = UIImage(named: car.imageName ?? "not_ok")
        self.texteMarqueVoiture.text = car.brandName ?? "Inconnu"
    }
}
