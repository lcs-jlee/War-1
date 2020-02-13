import Foundation

//create a Suit enumeration
enum Suit: Int {
    case heart = 0, spade, diamond, club
}

//create a Value enumeration
enum Value: Int {
    case two = 0, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
}


// Create a structure for a Hand
struct Hand {
    var cards: [Card] = []
    
    // Draw a card
    mutating func draw() -> Card {
        // Defines the drawn card
        let drawnCard = cards.first!
        
        // Removes the card from the array of cards
        self.cards.remove(at: 0)
        
        // Returns the drawn card
        return drawnCard
        
    }
}
//define what a card has (Suit and value)
struct Card {
    var suit: Suit
    var value: Value
    
    // Does this card beat another card?
    func beats(otherCard : Card) -> Bool {
        //compare which card value is higher
        if self.value.rawValue > otherCard.value.rawValue {
            return true
        }
        else {
            return false
        }
    }
}

// Game is not over yet
//all our variables
var gameIsOver = false
var playerWins = 0
var computerWins = 0
var totalRounds = 0
var totalWars = 0

//create a full deck array (empty) to add cards to
var fullDeck = Hand()

//generate a full deck of cards with loops and add them to the full deck
for generatedSuit in 0...3 {
    for generatedValue in 0...12 {
        fullDeck.cards.append(Card(suit: Suit(rawValue: generatedSuit)!, value: Value(rawValue: generatedValue)!))
    }
}

//create the two players hands arrays
var playerHand = Hand()
var computerHand = Hand()

//shuffle the deck and divide up the cards into each player's hand
for i in 0...51 {
    
    //get the index of a random card in the full deck
    let randomIndex = Int.random(in: 0...(fullDeck.cards.count - 1))
    //get a reference to what card will be given to a player
    let cardToMove: Card = fullDeck.cards[randomIndex]
    
    //decide which player to give the card to
    if i % 2 == 0 {
        playerHand.cards.append(cardToMove)
    } else {
        computerHand.cards.append(cardToMove)
    }
    
    //remove the card from the full deck
    fullDeck.cards.remove(at: randomIndex)
    
}

//create bounty arrays
var playerBounty: [Card] = []
var computerBounty: [Card] = []

func war(playerCard: Card, computerCard: Card) {
    
    for _ in 0...2 {
        
        // Add the top card to the bounty & remove from the player hand
        playerBounty.append(playerHand.draw())
        
        // Add the top card to the bounty & remove from the computer hand
        computerBounty.append(computerHand.draw())
    }
    
    // Draw a card to be compared in war
    let playerWarCard = playerHand.draw()
    let computerWarCard = computerHand.draw()
    
    // Compare the war cards
    if playerWarCard.beats(otherCard: computerWarCard) {
        // If player wins
        // Add bounty + war cards to the player's hand
        playerHand.cards.append(contentsOf: computerBounty)
        playerHand.cards.append(contentsOf: playerBounty)
        playerHand.cards.append(playerWarCard)
        playerHand.cards.append(computerWarCard)
        
        // Remove the bounties
        playerBounty.removeAll()
        computerBounty.removeAll()
        
        print("The player won the war!")
        
    } else if computerWarCard.beats(otherCard: playerWarCard) {
        // If computer wins
        // Add bounty + war cards to the computer's hand
        computerHand.cards.append(contentsOf: computerBounty)
        computerHand.cards.append(contentsOf: playerBounty)
        computerHand.cards.append(playerWarCard)
        computerHand.cards.append(computerWarCard)
        
        // Remove the bounties
        playerBounty.removeAll()
        computerBounty.removeAll()
        
        print("The computer won the war!")
        
    } else {
        // If they tie
        // Do another war
        print("Another war!!!")
        totalWars += 1
        
        if playerHand.cards.count > 3 && computerHand.cards.count > 3 {
            war(playerCard: playerWarCard, computerCard: computerWarCard)
        } else if playerHand.cards.count < 3 {
            gameIsOver = true
            announceWinner(winnerIs: "computer")
        } else if computerHand.cards.count < 3 {
            gameIsOver = true
            announceWinner(winnerIs: "player")
        } else {
            gameIsOver = true
            announceWinner(winnerIs: "someone")
        }
        
    }
    
}

func playHand() {
    //pick the top card from each hand
    let playerCard = playerHand.draw()
    let computerCard = computerHand.draw()
    
    
    //compare which card value is higher
    if playerCard.beats(otherCard: computerCard) {
        playerHand.cards.append(computerCard)
        playerHand.cards.append(playerCard)
        print("The player won round \(totalRounds).")
        playerWins += 1
    } else if computerCard.beats(otherCard: playerCard) {
        computerHand.cards.append(computerCard)
        computerHand.cards.append(playerCard)
        print("The computer won round \(totalRounds).")
        computerWins += 1
    } else {
        print("It's a war!")
        war(playerCard: playerCard, computerCard: computerCard)
        totalWars += 1
    }
    
    totalRounds += 1
    
}

//function to print out a winner message
func announceWinner(winnerIs: String) {
    print("The winner is... \(winnerIs)! The player won \(playerWins) rounds and the computer won \(computerWins) rounds. A total of \(totalRounds) rounds were played, \(totalWars) of which were wars!")
}

func play() {
    // If number of computer cards is greater than 3
    if computerHand.cards.count > 3 {
        // Play the hand
        playHand()
    } else {
        // Player has won, end game
        gameIsOver = true
        announceWinner(winnerIs: "player")
    }
    // If number of player cards is greater than 3
    if playerHand.cards.count > 3 {
        // Play the hand
        playHand()
    } else {
        // Computer has won, end game
        gameIsOver = true
        announceWinner(winnerIs: "computer")
    }
}

while gameIsOver == false {
    if playerHand.cards.count > 3 && computerHand.cards.count > 3 {
        play()
    } else if playerHand.cards.count < 3 {
        gameIsOver = true
        announceWinner(winnerIs: "computer")
    } else if computerHand.cards.count < 3 {
        gameIsOver = true
        announceWinner(winnerIs: "player")
    } else {
        gameIsOver = true
        announceWinner(winnerIs: "someone")
    }
}
