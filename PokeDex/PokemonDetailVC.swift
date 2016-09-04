//
//  PokemonDetailVC.swift
//  PokeDex
//
//  Created by ZhangRunqing on 16/9/3.
//  Copyright © 2016年 ZhangRunqing. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var mainImage: UIImageView!
    
    var poke: Pokemon!
    
    @IBOutlet weak var descpritionLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenceLable: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var WeightLabel: UILabel!
    @IBOutlet weak var AttackLabel: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    
    @IBOutlet weak var nextEvolabel: UIImageView!
    @IBOutlet weak var evoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = poke.name
        let image = UIImage(named: "\(poke.pokedexId)")
        mainImage.image = image
        currentEvoImg.image = image
        idLabel.text = "\(poke.pokedexId)"
        
        
        
        poke.downloadPokemonDetails {
            print("Yeahh")
            self.updateUI()
        }
           }
    
    func updateUI(){
        descpritionLabel.text = poke.description
        typeLabel.text = poke.type
        defenceLable.text = poke.defence
        heightLabel.text = poke.height
        
        WeightLabel.text = poke.weight
        AttackLabel.text = poke.attack
        if poke.nextEvolutionID == ""{
            evoLabel.text = "No Evolutions"
            nextEvoImage.hidden = true
        }else{
            nextEvoImage.hidden = false
            nextEvoImage.image = UIImage(named: poke.nextEvolutionID)
            var str1 = "Next Evolution: \(poke.nextEvolutionText)"
            if poke.nextEvolutionLVL != ""{
                str1 += " - LVL: \(poke.nextEvolutionLVL)"
            }
        }
        
        
        
    }

    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
