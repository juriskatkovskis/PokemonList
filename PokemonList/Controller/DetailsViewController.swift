//
//  DetailsViewController.swift
//  PokemonList
//
//  Created by juris.katkovskis on 20/08/2022.
//

import UIKit
import SDWebImage


class DetailsViewController: UIViewController {
    
   
    var pokemon: Card?
      var cardImage: UIImage?
      var favoriteCards: [String: Bool] = [:]
      let userDefaults = UserDefaults.standard
   
    
    @IBOutlet weak var pokemonCardImage: UIImageView!
    @IBOutlet weak var markAsFavoriteButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            
            loadUserDefaults()
            
            if let pokemon = pokemon {
                title = pokemon.name
                self.pokemonCardImage.sd_setImage(with: URL(string: pokemon.imageURL), placeholderImage: UIImage(named: "pok.png"))
                
                updateFavoriteButtonTitle(id: pokemon.id)
            } else {
                print("Pokemon image is nil")
            }
        }//end viewWillAppear
        
        //IBActions
    //    @IBAction func shareBarButtonTapped(_ sender: UIBarButtonItem) {
    //        guard let image = cardImage else {
    //            basicAlert(title: "Error!", message: "Unable to share. Apparently there is no image to share.")
    //            return }
    //        ShareManager.share(image: image, text: "Here is a Pokemon card I like.", vc: self)
    //    }
        
        
        @IBAction func markAsFavoriteButtonTapped(_ sender: UIButton) {
            guard let pokemon = pokemon else { return }
            if favoriteCards[pokemon.id] == false {
                favoriteCards[pokemon.id] = true
            } else {
                favoriteCards[pokemon.id] = false
            }
            userDefaults.set(favoriteCards, forKey: "favoriteCards")
            updateFavoriteButtonTitle(id: pokemon.id)
        }
        
        func loadUserDefaults() {
            if let dict = userDefaults.dictionary(forKey: "favoriteCards") as? [String: Bool] {
                favoriteCards = dict
            }
        }
        
        func updateFavoriteButtonTitle(id: String) {
            if favoriteCards[id] == false {
                markAsFavoriteButton.setTitle("Mark as favorite", for: .normal)
            } else {
                markAsFavoriteButton.setTitle("Unmark as favorite", for: .normal)
            }
        }
        
    }//end class
