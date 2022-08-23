//
//  ViewController.swift
//  PokemonList
//
//  Created by juris.katkovskis on 20/08/2022.
//

import UIKit

class PokemonViewController: UIViewController {

    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var pokey: [Card] = []
    var favoriteCards: [String: Bool] = [:]
        let userDefaults = UserDefaults.standard

       
    override func viewDidLoad() {
           super.viewDidLoad()
           self.title = "Pokémon List"
           getPokemonData()
           loadUserDefaults()
       }
       
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
           tableViewOutlet.reloadData()
           loadUserDefaults()
       }
       
       func loadUserDefaults() {
           if let dict = userDefaults.dictionary(forKey: "favoriteCards") as? [String: Bool] {
               favoriteCards = dict
           }
       }
       
       func getPokemonData(){
           let jsonUrl = "https://api.pokemontcg.io/v1/cards"
           //https://api.pokemontcg.io/v2/cards
           guard let url = URL(string: jsonUrl) else {return}
           
           var request = URLRequest(url: url)
           request.httpMethod = "GET"
           
           let config = URLSessionConfiguration.default
           config.waitsForConnectivity = true
           
           URLSession(configuration: config).dataTask(with: request) { (myData, myResponse, myError) in
               
               if myError != nil {
                   print((myError?.localizedDescription)!)
               }
               
               guard let data = myData else{
                   print(myError as Any)
                   return
               }
               
               do{
                   let jsonData = try JSONDecoder().decode(Pokemon.self, from: data)
                   print("jsonData: ", jsonData)
                   self.pokey = jsonData.cards
                   //setting dict of favorite cards
                   for pokemon in self.pokey {
                       if self.favoriteCards[pokemon.id] == nil {
                           self.favoriteCards[pokemon.id] = false
                       }
                   }
                   self.userDefaults.set(self.favoriteCards, forKey: "favoriteCards")
                   
                   DispatchQueue.main.async {
                       self.tableViewOutlet.reloadData()
                   }
                   
               }catch{
                   print("Error:::::: ", myError as Any)
               }
           }.resume()
           
       }
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "detailedPokemon" {
               if let detailVC = segue.destination as? DetailsViewController, let row = tableViewOutlet.indexPathForSelectedRow?.row {
                   detailVC.pokemon = pokey[row]
               }
           }
       }
       
       
   }//end class
   extension PokemonViewController: UITableViewDelegate, UITableViewDataSource {
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return pokey.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "PokeyTableViewCell", for: indexPath) as? PokeyTableViewCell else {return UITableViewCell()}
           
           let pok = pokey[indexPath.row]
           cell.setupUI(withDataFrom: pok)
           
           //setting if card is Favorite
           if favoriteCards[pok.id] == true {
               cell.favoriteImage.image = UIImage(systemName: "star.fill")
               cell.favoriteImage.alpha = 1
           } else {
               cell.favoriteImage.image = UIImage(systemName: "star")
               cell.favoriteImage.alpha = 0.5
           }
           
           return cell
           
       }
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 250
       }
       
       
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "detailedPokemon", sender: self)
   }
       
       
   }
