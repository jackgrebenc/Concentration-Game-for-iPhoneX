//
//  Card.swift
//  assignment1
//
//  Created by Jack Grebenc on 2018-10-22.
//  Copyright © 2018 Jack Grebenc. All rights reserved.
//

import Foundation
//structs in swift are a lot like classes except 1) They have no inheritance 2) Structs are value types (gets copied when assigned to something else) , classes are refecence types
struct Card
{
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    //inTracker and scored gets used by the score function in viewController
    var inTracker = false
    var scored = false

    
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
