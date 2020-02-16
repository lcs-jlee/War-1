import Foundation

//create a Suit enumeration
enum Suit: Int {
    case heart = 0, spade, diamond, club
}

//create a Value enumeration
enum Value: Int {
    case two = 2, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
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


// The structure for Beggar your Neighbour
struct beggarYourNeighbour {
    // Empty deck of cards
    var deck: [Card] = []
    
        
    var isPlayerTurn = true
    var player: [Card] = []
    var computer: [Card] = []
    var middle: [Card] = []
    
    
    mutating func generateDeck(deck: [Card]) -> [Card] {
        var fullDeck = deck
        
        // Populating the deck
        for i in 1...4 {
            for j in 2...14 {
                fullDeck.append(Card(suit: Suit(rawValue: i)!, value: Value(rawValue: j)!))
            }
        }
        
        return fullDeck
    }
    
    // Deal cards to both of the players' hands
    mutating func dealCards() {
        while deck.count > 0 {
            
            // Get a random value between 0 and the end of the deck array
            var randomCardPosition = Int.random(in: 0...deck.count - 1)
            
            // Add to the player's hand
            player.append(deck[randomCardPosition])
            
            // Remove the card from the deck
            deck.remove(at: randomCardPosition)
            
            //picking the card position for the computer
            randomCardPosition = Int.random(in: 0...deck.count - 1)
            
            //adds to the computers hand
            computer.append(deck[randomCardPosition])
            
            // Remove the card from the deck
            deck.remove(at: randomCardPosition)
            
            print(randomCardPosition)
        }
        
        
    }
    
    mutating func addToMiddle(theCard: Card, playerTurn: Bool) {
        middle.append(theCard)
        if playerTurn{
            player.remove(at: 0)
        } else{
            computer.remove(at: 0)
        }
        
        //check()
    }
    
    
    

    mutating func check(theCard: Card, playerTurn: Bool) {
        if theCard.value.rawValue >= 11 {
            //repeat
            if playerTurn {
                repeatComputer(thePlayerCard: theCard)
            }
        } else{
            //opposition's turn normally
        }
        
    }
    

    mutating func playTheGame() {
        
        
    }
    
    mutating func repeatComputer (thePlayerCard: Card) {
        for _ in 0...thePlayerCard.value.rawValue - 10 {
            middle.insert(computer[0], at: 0)
            computer.remove(at: 0)
            check(theCard: middle[0], playerTurn: isPlayerTurn)
            
            
            
        }
    }
    
    mutating func repeatPlayer (theComputerCard: Card) {
        for _ in 0...theComputerCard.value.rawValue - 10 {
            //check()
            addToMiddle(theCard: theComputerCard, playerTurn: isPlayerTurn)
            
        }
    }
    
}

