//
//  Wildlife.swift
//  Gaia
//
//  Created by John Henning on 3/23/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import Cocoa
import UIKit

class Wildlife: NSObject {
    
    let wildlife: [String] = ["lion","tiger","bear","dog","cat","alligator","squirrel","beetle","snail","ant","butterfly","duck","crow","horse","deer","monkey","gorilla","elephant","giraffe","swan"]
    
    public func getWildlife() -> [String] {
        return wildlife
    }
}
