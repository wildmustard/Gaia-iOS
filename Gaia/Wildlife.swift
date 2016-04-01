//
//  Wildlife.swift
//  Gaia
//
//  Created by John Henning on 3/23/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit

class Wildlife: NSObject {
    
    let wildlife: [String] = ["lion","tiger","alligator","squirrel", "tarantula", "snail","beetle","butterfly","duck","crow","horse","deer","gorilla","monkey","elephant","giraffe","swan","eagle","rose","dandelion","marijuana","spider","sunflower","mushroom","wolf","beagle","retriever","dog","zebra"]
    
    internal func getWildlife() -> [String] {
        return wildlife
    }
    
    internal func matchWildlife(tags: [String]) -> (Bool, String) {
        for wild in wildlife {
            for tag in tags {
                if (tag == wild) {
                    return (true,tag)
                }
            }
        }
        return (false,"")
    }
    
}
