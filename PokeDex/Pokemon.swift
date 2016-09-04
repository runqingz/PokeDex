//
//  Pokemon.swift
//  PokeDex
//
//  Created by ZhangRunqing on 16/9/2.
//  Copyright © 2016年 ZhangRunqing. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{
    
    private var _name:String!
    private var _pokedexID: Int!
    private var _description: String!
    private var _defence: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _pokemonUrl :String!
    private var _type :String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLVL: String!
    
    var name: String {
       
        return _name
    }
    
    var pokedexId: Int{
       
        return _pokedexID
    }
    
    var description: String{
        if _description == nil{
            _description = ""
        }
        return _description
    }
    
    var defence: String{
        if _defence == nil{
            _defence = ""
        }
        return _defence
    }
    
    var height: String{
        if _height == nil{
            _height = ""
        }
        return _height
    }
    
    var weight: String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    
    var attack: String{
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionText: String{
        if _nextEvolutionText == nil{
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    var nextEvolutionID: String{
        if _nextEvolutionID == nil{
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
    
    var nextEvolutionLVL: String{
        if _nextEvolutionLVL == nil{
            _nextEvolutionLVL = ""
        }
        return _nextEvolutionLVL
    }
    
    var type: String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    
    init (name:String, pokedexID:Int){
        self._name = name
        self._pokedexID = pokedexID
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    
    func downloadPokemonDetails(completed: DownloadCompelete){
        
        let url = NSURL(string: _pokemonUrl)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String , AnyObject>{
                
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String{
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int{
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int{
                    self._defence = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String , String>] where types.count > 0{
                    
                    if let name = types[0]["name"]{
                        self._type = name
                    }
                    
                    if types.count > 1 {
                        for x in 1 ..< types.count{
                            if let name = types[x]["name"]{
                            self._type! += "/\(name)"
                            }
                        }
                    }
                }else{
                    self._type = ""
                }
                
                if let descriparr = dict["descriptions"] as? [Dictionary<String, String>] where descriparr.count > 0{
                    if let url = descriparr[0]["resource_uri"]{
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            let result = response.result
                            if let dict = result.value as? Dictionary<String, AnyObject>{
                                if let description = dict["description"] as? String{
                                    self._description = description
                                }
                            }
                            
                            completed()
                        }
                    }
                }else{
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0{
                    
                    if let evol = evolutions[0]["to"] as? String{
                        
                        if evol.rangeOfString("mega") == nil{
                            if let str = evolutions[0]["resource_uri"] as? String{
                              
                                let newString = str.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let idnum = newString.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionID = idnum
                                self._nextEvolutionText = evol
                                if let level = evolutions[0]["level"] as? Int{
                                    self._nextEvolutionLVL = "\(level)"
                                }
                            
                            }
                        }
                    }
                    
                }
            }
        }
    }

}
