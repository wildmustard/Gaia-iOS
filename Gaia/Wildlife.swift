//
//  Wildlife.swift
//  Gaia
//
//  Created by John Henning on 3/23/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse

class Wildlife: NSObject {
    
    
    let wildlife: [String] = ["lion","tiger","alligator","squirrel", "tarantula", "fox", "squirrel", "mouse", "anteater", "ape", "armadillo", "baboon", "badger", "beaver", "bee" , "wasp", "hornet", "boar", "pig", "cow", "bull", "camel", "chicken", "cockaroach", "crab", "dragonfly", "eel", "ferret", "fox", "frog", "goat", "goose", "hare", "hedgehog", "hippo", "hippopotamus", "jaguar", "jellyfish", "kangaroo", "lobster", "moose", "opossum", "owl", "ostrich", "oyster", "porcupine", "rabbit", "racoon", "panda", "rhino", "seal", "shark", "skunk", "snake", "turkey", "turtle", "walrus", "whale", "snail","beetle","butterfly","duck","crow","horse","deer","gorilla","monkey","elephant","giraffe","swan","eagle","wolf","beagle","retriever","dog","zebra","rose","dandelion","marijuana","spider","sunflower","mushroom", "apple", "bamboo", "banana", "blackberry", "blueberry", "carrot", "cherry", "cucumber", "daisy", "lemon", "lettuce", "rice", "potato", "tea", "tomato", "walnut"]

    
    
    internal func serverPost() {
        for wild in wildlife {
            let wildlifeParse = PFObject(className: "Wildlife")
            //print("test")
            wildlifeParse["name"] = wild
            wildlifeParse["score"] = pointsTag(wild)
            wildlifeParse["wiki"] = "https://en.m.wikipedia.org/wiki/" + wild
            wildlifeParse.saveInBackground()
        }
    }
    
    
    internal func getWildlife() -> [String] {
        return wildlife
    }
    
    internal func matchWildlife(tags: [String], wildlife: [PFObject]) -> (Bool, PFObject) {
        let emptyObject = PFObject(className: "Wildlife")

        
        for wild in wildlife {
            for tag in tags {
                if (tag == (wild["name"] as? String)!) {
                    return (true,wild)
                }
            }
        }
        return (false,emptyObject)
    }
    
    internal func pointsTag(tag: String) -> (Int){
        
        let points = tag.characters.count * 15
    
        return points
    }
    
}
