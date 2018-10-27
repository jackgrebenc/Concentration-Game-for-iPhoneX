//
//  ViewController.swift
//  assignment1
//
//  Created by Jack Grebenc on 2018-10-21.
//  Copyright © 2018 Jack Grebenc. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1)/2)
    lazy var flipCounter = flipCount()

    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var scoreCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    var scoreCount = 0 {
        didSet {
            scoreCountLabel.text = "Score: \(scoreCount)"
        }
    }
    func updateScore() {
        flipCountLabel.text = "Flips: \(flipCounter.count)"
    }
    var buttonColor = UIColor.white
    
    var pCard = Int()
    @IBAction func touchCard(_ sender: UIButton) {
        flipCounter.increment()
        updateScore()
        firstGame()
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel(bcolor: buttonColor)
            
            //This section of code is used for scoring (Q7)
            //It uses the score method to decide the points awarded/removed
            
            //if two cards are flipped over
            if game.indexOfOneAndOnlyFaceUpCard == nil {
                score(for: cardNumber)
                score(for: pCard)
            }
            //one card flipped which gets stored and used when both cards are flipped over
            else {
                if let prevCard = game.indexOfOneAndOnlyFaceUpCard {
                    pCard = prevCard
                }
            }
        } else {
            print ("card chosen not in cardButtons")
        }
    }
    

    func updateViewFromModel(bcolor buttonC: UIColor) {

        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji (for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : buttonC
            }
          }
        }
    


    //This is a helper function I added that makes it halloween themed when the app opens up for the first game and initializes all the other themes (which get chosen by pickTheme function when the new game button is pressed
    var first = true
    var newTheme = Dictionary<String, [String]>()
    func firstGame() {
        if first == true {
            //let tempDict = pickTheme()!
            emojiChoices = ["🦇", "😱", "🙀","😈", "🎃", "👻","🍭", "🍬", "🍎"]
            buttonColor = UIColor.orange
            first = false
            newTheme.updateValue(["🦇", "😱", "🙀","😈", "🎃", "👻","🍭", "🍬", "🍎"], forKey: "halloween")
            newTheme.updateValue(["🐬", "🐔", "🐥","🐝", "🦆", "🦏", "🦋", "🐠", "🐖"], forKey: "animals")
            newTheme.updateValue(["🌞", "🌛", "🌚", "🌍", "⚡️", "🌥", "🌜", "🌕", "☄️" ], forKey: "cosmos")
            newTheme.updateValue(["🍋","🍌","🍉","🍒","🥦","🍆","🥑","🥝","🍅"], forKey: "food")
            newTheme.updateValue(["⚽️","🏀","🏈","⚾️","🏐","🏓","🎾","🎱"], forKey: "sports")
            newTheme.updateValue(["🚗","🚕","🏎","🚓","✈️","🚆","🚲","🚁","🛶"], forKey: "transportation")
        }

    }
    
    //Question 5 -> pickTheme generates a random theme from the newTheme dictionary initialized in firstGame function
    func pickTheme() -> (key:String, value:[String])? {
        return newTheme.randomElement()
    }
    //Question  7
    /* score implements the method described in Question 7 of the assignment
     -> This function gets called twice in a row by the touchCard method to
     assess both face up cards (scoring occurs only when two cards are face up)
     -> It takes an integer index number as a parameter that relates to the cards
     placement in the game.cards array
     -> I added a new boolean called inTracker which keeps track of which cards have
     already been passed through the function
     */
    func score(for cardNumber: Int) {
        //checks if the card has already been flipped and subtracts from the score if it isn't matched
        if game.cards[cardNumber].inTracker && !game.cards[cardNumber].isMatched {
                scoreCount -= 1
        }
        if game.cards[cardNumber].isMatched && !game.cards[cardNumber].scored {
            scoreCount += 2
            game.cards[cardNumber].scored = true
            game.cards[pCard].scored = true
        }
        //now the card has been flipped so it gets added to inTracker
        game.cards[cardNumber].inTracker = true
    }
    

    
    //Extra Credit Problem 1 -> setting backgrounds to match theme
    func setTheme(newTheme theme: String) -> UIColor {
        let buttons = cardButtons!
        var buttonColor = UIColor()
        for index in cardButtons.indices {
            if theme == "cosmos" {
                buttons[index].backgroundColor = UIColor.blue
                buttonColor = UIColor.blue
                view.backgroundColor = UIColor.gray
                flipCountLabel.textColor = UIColor.white
                scoreCountLabel.textColor = UIColor.white
                newGameButton.setTitleColor(UIColor.black, for: .normal)
            }
            if theme == "transportation" {
                buttons[index].backgroundColor = UIColor.red
                buttonColor = UIColor.red
                view.backgroundColor = UIColor.blue
                flipCountLabel.textColor = UIColor.red
                scoreCountLabel.textColor = UIColor.red
                newGameButton.setTitleColor(UIColor.red, for: .normal)
            }
            if theme == "sports" {
                buttons[index].backgroundColor = UIColor.gray
                buttonColor = UIColor.gray
                view.backgroundColor = UIColor.green
                flipCountLabel.textColor = UIColor.gray
                scoreCountLabel.textColor = UIColor.gray
                newGameButton.setTitleColor(UIColor.gray, for: .normal)
            }
            if theme == "food" {
                buttons[index].backgroundColor = UIColor.green
                buttonColor = UIColor.green
                view.backgroundColor = UIColor.yellow
                flipCountLabel.textColor = UIColor.green
                scoreCountLabel.textColor = UIColor.green
                newGameButton.setTitleColor(UIColor.green, for: .normal)
            }
            if theme == "animals" {
                buttons[index].backgroundColor = UIColor.purple
                buttonColor = UIColor.purple
                view.backgroundColor = UIColor.magenta
                flipCountLabel.textColor = UIColor.black
                scoreCountLabel.textColor = UIColor.black
                newGameButton.setTitleColor(UIColor.black, for: .normal)
            }
            if theme == "halloween" {
                buttons[index].backgroundColor = UIColor.orange
                buttonColor = UIColor.orange
                view.backgroundColor = UIColor.black
                flipCountLabel.textColor = UIColor.orange
                scoreCountLabel.textColor = UIColor.orange
                newGameButton.setTitleColor(UIColor.orange, for: .normal)
            }
        }
        return buttonColor
    }
    
    
    var emoji = [Int:String]() //same as Dictionary<Int,String>()
    var emojiChoices: [String] = []
    
    func emoji(for card: Card) -> String {
        //used to randomize cards only for the first game (newGame function does it for all other games)

        if emojiChoices.count > 0, emoji[card.identifier] == nil {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
       
        }
        return emoji[card.identifier] ?? "?"
        
    }
    /* Question 3 -> newGame function
     If pressed, new game needs to:
     1) Flip all the cards to face down
     2) resets flip count and score
     3) Pick a new theme
     4) call the init method for concentration
     */
    @IBAction func newGame(_ sender: UIButton) {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp || card.isMatched {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
        flipCounter.reset()
        updateScore()
        scoreCount = 0
        let tempDict = pickTheme()!
        emojiChoices = tempDict.value
        buttonColor = setTheme(newTheme: tempDict.key)
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1)/2)
    }
    
}
 

