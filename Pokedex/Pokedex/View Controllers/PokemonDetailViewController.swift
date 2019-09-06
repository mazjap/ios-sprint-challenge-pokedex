//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Jordan Christensen on 9/6/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
    var apiController: APIController?
    var pokemon: Pokemon?
    
    @IBOutlet weak var pokemonSearchBar: UISearchBar!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var idNumberLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var typesListLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    @IBOutlet weak var abilitiesListLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        pokemonSearchBar.delegate = self
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        navigationController?.navigationBar.barTintColor = UIColor(red:0.91, green:0.05, blue:0.07, alpha:1.00)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red:0.25, green:0.30, blue:0.29, alpha:1.00)]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(red:0.25, green:0.30, blue:0.29, alpha:1.00)]
        
        pokemonSearchBar.barTintColor = UIColor(red:0.25, green:0.30, blue:0.29, alpha:1.00)
        
        view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.00)
    }
    
    func updateViews() {
        if let pokemon = pokemon {
            unhide()
            
            nameLabel.text = pokemon.name
            idNumberLabel.text = "\(pokemon.id)"
            typesListLabel.text = getTypesString()
            abilitiesListLabel.text = getAbilitiesString()
            
            
            guard let url = URL(string: pokemon.sprites.frontImage),
                let imageData = try? Data(contentsOf: url) else { fatalError() }
            pokemonImageView.image = UIImage(data: imageData)
            
        } else {
            nameLabel.isHidden = true
            idLabel.isHidden = true
            idNumberLabel.isHidden = true
            typesLabel.isHidden = true
            typesListLabel.isHidden = true
            abilitiesLabel.isHidden = true
            abilitiesListLabel.isHidden = true
        }
    }
    
    func unhide() {
        nameLabel.isHidden = false
        idLabel.isHidden = false
        idNumberLabel.isHidden = false
        typesLabel.isHidden = false
        typesListLabel.isHidden = false
        abilitiesLabel.isHidden = false
        abilitiesListLabel.isHidden = false
    }
    
    func getTypesString() -> String {
        guard let pokemon = pokemon else { return "" }
        var types = ""
        for type in 0...pokemon.types.count - 1 {
            if type == pokemon.abilities.count - 1 {
                types += "\(pokemon.types[type].type.name)"
            } else {
                types += "\(pokemon.types[type].type.name), "
            }
        }
        return types
    }
    
    func getAbilitiesString() -> String {
        guard let pokemon = pokemon else { return "" }
        var abilities = ""
        for ability in 0...pokemon.abilities.count - 1 {
            if ability == pokemon.abilities.count - 1 {
                abilities += "\(pokemon.abilities[ability].ability.name)"
            } else {
                abilities += "\(pokemon.abilities[ability].ability.name), "
            }
        }
        return abilities
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PokemonDetailViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let apiController = apiController,
            let searchTerm = pokemonSearchBar.text?.lowercased() else { return }
        
        apiController.getPokemon(with: searchTerm, completion: { networkError in
            if let error = networkError {
                NSLog("Error fetching pokemon info: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.pokemon = apiController.pokemon[apiController.pokemon.count - 1]
                    self.updateViews()
                }
            }
        })
    }
}
