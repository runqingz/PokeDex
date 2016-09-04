//
//  ViewController.swift
//  PokeDex
//
//  Created by ZhangRunqing on 16/9/2.
//  Copyright © 2016年 ZhangRunqing. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collection: UICollectionView!
    
    var filteredPokes = [Pokemon]()
    var musicPlay : AVAudioPlayer!
    var pokemons = [Pokemon]()
    var inSearchMode =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        initAudio()
        parsePokemonCsv()
        
        
      
    }
    
    func initAudio(){
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        do {
            musicPlay = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlay.prepareToPlay()
            musicPlay.numberOfLoops = -1
            musicPlay.play()
        }catch let err as NSError{
            print(err.debugDescription)
           
            
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell{
            let pokemon : Pokemon!
            if inSearchMode{
                pokemon = filteredPokes[indexPath.row]
            }else{
                pokemon = pokemons[indexPath.row]
            }
            
            cell.configureCell(pokemon)
            
            return cell
        }else{
            
            return UICollectionViewCell()
        }
        
        
        
    }
    
   
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode{
            return filteredPokes.count
        }else{
            return pokemons.count
        }
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
    
    
    func parsePokemonCsv(){
        let path =  NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows{
                let pokeId = Int(row["id"]!)!
                let pokename = row["identifier"]!
                let  poke = Pokemon(name: pokename, pokedexID: pokeId)
                pokemons.append(poke)
                
            }
            
            
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }

    @IBAction func musicButtonPressed(sender: UIButton) {
        if musicPlay.playing{
            musicPlay.stop()
            sender.alpha = 0.2
        }else{
            musicPlay.play()
            sender.alpha = 1.0
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
   
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text == nil)||(searchBar.text == "") {
            inSearchMode = false
            
            collection.reloadData()
            view.endEditing(true)
        }else{
            inSearchMode = true
            let key = searchBar.text!.lowercaseString
            filteredPokes = pokemons.filter({$0.name.rangeOfString(key) != nil})
            collection.reloadData()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var poke: Pokemon!
        
        if inSearchMode{
            poke = filteredPokes[indexPath.row]
        }else{
            poke = pokemons[indexPath.row]
        }
        
        performSegueWithIdentifier("PokemonDetail", sender: poke)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetail"{
            if let detailVC = segue.destinationViewController as? PokemonDetailVC{
                if let poke = sender as? Pokemon{
                    detailVC.poke = poke
                }
            }
        }
    }

}

