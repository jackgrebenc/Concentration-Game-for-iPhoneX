//
//  ViewController.swift
//  assignment1
//
//  Created by Jack Grebenc on 2018-10-21.
//  Copyright © 2018 Jack Grebenc. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    /*Added a viewDidLoad override to enable the randomiztion of themes
    for the first game when the app loads and to apply some styling to the
     labels and the new game button
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        //randomizes themes when app loads
        initializeThemes()
        flipCountLabel.layer.cornerRadius = 5
        scoreCountLabel.layer.cornerRadius = 5
        timerLabel.layer.cornerRadius = 5
        newGameButton.layer.cornerRadius = 10
        newGameButton.showsTouchWhenHighlighted = true
    }
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    var numberOfPairsOfCards : Int {
            return (cardButtons.count + 1)/2
    }

    private(set) var flipCounter = flipCount()
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    private func updateFlips() {
        flipCountLabel.text = "Flips: \(flipCounter.count)"
    }
    
    @IBOutlet private weak var scoreCountLabel: UILabel!
    
    var scoreCount = 0 {
        didSet {
            scoreCountLabel.text = "Score: \(scoreCount)"
        }
    }
    //Extra credit problem 2 -> make a timer
    //Using the Timer class, a player gets penalized by 1 point if they don't tap a card every 3 seconds
    //
    @IBOutlet weak var timerLabel: UILabel!
    var seconds = 3
    var timer = Timer()
    /*restartTimer is called everytime a card is touched
     (see touchCard method), so that the timer resets and the player isn't penalized
     if they press a card button within the 3 second
    */
    func restartTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil , repeats: true)
        seconds = 3
        timerLabel.text  = "Timer: \(seconds)"
    }
    func stopTimer() {
        timer.invalidate()
        seconds = 3
        timerLabel.text = "Timer: \(seconds)"
    }
    /* updateTimer is the selector method used by timer. The timer gets updated every second, so this method
     gets called every second and it counts down to 0 (penailzing the player if it every hits zero due to player inaction
    */
    @objc func updateTimer() {
        seconds -= 1
        if seconds == 0 {
            scoreCount -= 1
            seconds = 3
        }
        timerLabel.text = "Timer: \(seconds)"
    }

    @IBOutlet private var cardButtons: [UIButton]!
    var buttonColor =  UIColor()
    @IBOutlet private weak var newGameButton: UIButton!
    var pCard = Int()
    @IBAction private func touchCard(_ sender: UIButton) {
        restartTimer()
        flipCounter.increment()
        updateFlips()
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
        for item in game.cards {
            if !item.isMatched {
                return;
            }
        }
        //All cards are matched, therefore game is done so timer can be turned off
        stopTimer()
    }
    

    private func updateViewFromModel(bcolor buttonC: UIColor) {
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
    var newTheme = Dictionary<Themes,String>()
    private func initializeThemes() {
        if first == true {
            first = false
            newTheme.updateValue("🦇😱🙀😈🎃👻🍭🍬🍎", forKey: Themes.halloween)
            newTheme.updateValue("🌸🌼🌻🌷🌹🥀💐🌱🎋", forKey: Themes.flowers)
            newTheme.updateValue("🌞🌛🌚🌍⚡️🌥🌜🌕☄️", forKey: Themes.cosmos)
            newTheme.updateValue("🍋🍌🍉🍒🥦🍆🥑🥝🍓🍑", forKey: Themes.food)
            newTheme.updateValue("⚽️🏀🏈⚾️🏐🏓🎾🎱", forKey: Themes.sports)
            newTheme.updateValue("🚗🚕🏎🚓✈️🚆🚲🚁🛶", forKey: Themes.transportation)
        }
        if let tempDict = pickTheme() {
            emojiChoices = tempDict.value
            applyThemesToUI(theme: tempDict.key)
        } else {
            //defaults to Halloween game
            emojiChoices = "🦇😱🙀😈🎃👻🍭🍬🍎"
            applyThemesToUI(theme: Themes.halloween)
            print("Error in pickTheme, no elements found! Defaults to halloween")
        }

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
    private func score(for cardNumber: Int) {
        //checks if the card has already been flipped and subtracts from the score if it isn't matched
        if game.cards[cardNumber].inTracker && !game.cards[cardNumber].isMatched {
                scoreCount -= 1
        }
        //card is matched and hasn't been scored yet
        if game.cards[cardNumber].isMatched && !game.cards[cardNumber].scored {
            scoreCount += 2
            game.cards[cardNumber].scored = true
            game.cards[pCard].scored = true
        }
        //now the card has been flipped so it gets added to inTracker
        game.cards[cardNumber].inTracker = true
    }
    
    //Question 5 -> pickTheme generates a random theme from the newTheme dictionary initialized in firstGame function
    private func pickTheme() -> (key:Themes, value:String)? {
        return newTheme.randomElement()
    }
    
    func applyThemesToUI(theme: Themes) {
        if let buttons = cardButtons {
            for index in cardButtons.indices {
                buttons[index].backgroundColor = theme.style.backOfCard
            }
            buttonColor = theme.style.backOfCard
            flipCountLabel.textColor = theme.style.textColor
            flipCountLabel.backgroundColor = theme.style.backOfCard
            scoreCountLabel.textColor = theme.style.textColor
            scoreCountLabel.backgroundColor = theme.style.backOfCard
            timerLabel.textColor = theme.style.textColor
            timerLabel.backgroundColor = theme.style.backOfCard
            //view.backgroundColor = theme.style.backgroundColor
            newGameButton.setTitleColor(theme.style.textColor, for: .normal)
            newGameButton.backgroundColor = theme.style.newGameButtonColor

            self.view.backgroundColor = UIColor(patternImage: UIImage(named:theme.style.backgroundImage)!)
            
        }
        else {
            print ("Error cardButtons not present in applyThemesToUI")
        }

    }

    private var emoji = [Card:String]() //same as Dictionary<Int,String>()
    
    //default assignment for emojiChoices
    private var emojiChoices = "🦇😱🙀😈🎃👻🍭🍬🍎"
    
    private func emoji(for card: Card) -> String {
        //used to randomize cards only for the first game (newGame function does it for all other games)
        if emojiChoices.count > 0, emoji[card] == nil {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    /* Question 3 -> newGame function
     If pressed, new game needs to:
     1) Flip all the cards to face down
     2) resets flip count and score
     3) Pick a new theme
     4) call the init method for concentration
     */
    @IBAction private func newGame(_ sender: UIButton) {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp || card.isMatched {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = buttonColor
            }
        }
        flipCounter.reset()
        updateFlips()
        scoreCount = 0
        initializeThemes()
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        stopTimer()
    }
}
extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
