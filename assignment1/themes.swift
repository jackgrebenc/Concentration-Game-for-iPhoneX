//
//  themes.swift
//  assignment1
//
//  Created by Jack Grebenc on 2018-10-29.
//  Copyright © 2018 Jack Grebenc. All rights reserved.
//
import UIKit
import Foundation
enum Themes {
    case flowers, halloween, cosmos, food, sports, transportation
    
    var style: ThemeStyling {
        switch self {
        case .flowers:
            return ThemeStyling(textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), backOfCard: #colorLiteral(red: 0.8510764241, green: 0.9842011333, blue: 0.01325141266, alpha: 1), newGameButtonColor: #colorLiteral(red: 0.690631032, green: 0.7790341973, blue: 0.07897358388, alpha: 1), backgroundImage: "flowersBackground")
        case .halloween:
            return ThemeStyling(textColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), backOfCard: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), newGameButtonColor: #colorLiteral(red: 0.9620509744, green: 0.4853927493, blue: 0.02735389397, alpha: 1), backgroundImage: "halloweenBackground")
        case .cosmos:
            return ThemeStyling(textColor: #colorLiteral(red: 0.02882496454, green: 0.6501441598, blue: 0.9524310231, alpha: 1), backOfCard: #colorLiteral(red: 0.8757533431, green: 0.804148376, blue: 0.06115407497, alpha: 1), newGameButtonColor: #colorLiteral(red: 0.9989714026, green: 0.9366487265, blue: 0.0003251277376, alpha: 1), backgroundImage: "cosmosBackground")
        case .food:
            return ThemeStyling(textColor: #colorLiteral(red: 0.9141074419, green: 0.9462448955, blue: 0.7742090821, alpha: 1), backOfCard: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), newGameButtonColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), backgroundImage: "foodBackground")
        case.sports:
            return ThemeStyling(textColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1), backOfCard: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), newGameButtonColor: #colorLiteral(red: 1, green: 0.02328635045, blue: 0, alpha: 1) , backgroundImage: "sportsBackground")
        case .transportation:
            return ThemeStyling(textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backOfCard: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), newGameButtonColor: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), backgroundImage: "transportationBackground")
        }

    }
}

struct ThemeStyling {
    let textColor : UIColor
    let backOfCard: UIColor
    let newGameButtonColor: UIColor
    let backgroundImage: String
}
