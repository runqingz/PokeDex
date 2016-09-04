//
//  PokeCell.swift
//  PokeDex
//
//  Created by ZhangRunqing on 16/9/2.
//  Copyright © 2016年 ZhangRunqing. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    
    var pokemon: Pokemon!
    
   
    
    required init?(coder aDecoder: NSCoder) {
   
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5.0
        
    }
    
    
    func configureCell (pokemon: Pokemon){
        self.pokemon = pokemon
        
        nameLable.text = self.pokemon.name.capitalizedString
        pokeImage.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
        
    }
    
    
}
