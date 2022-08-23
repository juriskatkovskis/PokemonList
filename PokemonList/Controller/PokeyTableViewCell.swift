//
//  PokeyTableViewCell.swift
//  PokemonList
//
//  Created by juris.katkovskis on 20/08/2022.
//

import UIKit
import SDWebImage
class PokeyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pokeyImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var supertypeLabel: UILabel!
    @IBOutlet weak var evolvesFromLabel: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    
    override func prepareForReuse() {
        pokeyImageView.image = nil
        nameLabel.text = ""
        supertypeLabel.text = ""
        evolvesFromLabel.text = ""
        hpLabel.text = ""
    }
    
    func setupUI(withDataFrom: Card){
        nameLabel.text = "Name: " + withDataFrom.name
        hpLabel.text = "Card value: " + (withDataFrom.hp ?? "")
        evolvesFromLabel.text = "Evolves From: " + (withDataFrom.evolvesFrom ?? "")
        
        self.pokeyImageView.sd_setImage(with: URL(string: withDataFrom.imageURL), placeholderImage: UIImage(named: "pok.png"))
        
        if let supertype = withDataFrom.supertype {
            supertypeLabel.text = "Type: " + supertype
            
            if withDataFrom.supertype == "Trainer"{
                contentView.backgroundColor = .cyan
            }else{
                contentView.backgroundColor = .systemGreen
            }
        }
        
    }

}
