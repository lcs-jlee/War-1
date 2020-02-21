import Foundation

//create a Suit enumeration
enum Suit: Int {
    case heart = 1, spade, diamond, club
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
    
    var countTurns = 1
    var isPlayerTurn = true
    var player: [Card] = []
    var computer: [Card] = []
    var middle: [Card] = []
    var isGameOver = true
    
    mutating func generateDeck() {
        
        
        // Populating the deck
        for i in 1...4 {
            for j in 2...14 {
                deck.append(Card(suit: Suit(rawValue: i)!, value: Value(rawValue: j)!))
            }
        }
        
        
    }
    
    // Deal cards to both of the players' hands
    mutating func dealCards() {
        generateDeck()
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
            
            //print(randomCardPosition)
        }
        
        
    }
    
    mutating func addToMiddle(theCard: Card, playerTurn: Bool) {
        if player.count < 1 {
            whoIsWinner(winner: "Computer")
        } else if computer.count < 1 {
            whoIsWinner(winner: "Player")
        }else {
            print("Computer has \(computer.count) cards")
            print("Player has \(player.count) cards")
            print("Middle has \(middle.count) cards")
            middle.insert(theCard, at: 0)
            
            if playerTurn{
                
                    player.remove(at: 0)
                    print("Player put \(theCard.suit) \(theCard.value)")
                    print("========================================================")
                
                
            } else{
                
                    computer.remove(at: 0)
                    print("Computer put \(theCard.suit) \(theCard.value)")
                    print("========================================================")
                
                
            }
            
        }
        

    }

    mutating func check(theCard: Card, playerTurn: Bool, isRepeating: Bool) {
        if computer.count < 1{
            whoIsWinner(winner: "Player")
            
        }
        else if player.count < 1{
            whoIsWinner(winner: "Computer")
            
        } else {
            if theCard.value.rawValue >= 11 {
                //repeat
                if playerTurn {
                    isPlayerTurn.toggle()
                    repeatComputer(thePlayerCard: theCard)
                } else {
                    isPlayerTurn.toggle()
                    repeatPlayer(theComputerCard: theCard)
                }
            } else if isRepeating == false{
                  isPlayerTurn.toggle()
                  playTheGame()
            }
        }
        
        
    }
    
    
    mutating func repeatComputer (thePlayerCard: Card) {
        var repeatedTimes = 0
        for _ in 0...thePlayerCard.value.rawValue - 11 {
            if computer.count > 0 {
                addToMiddle(theCard: computer[0], playerTurn: isPlayerTurn)
                if middle.count > 0 {
                    check(theCard: middle[0], playerTurn: isPlayerTurn, isRepeating: true)
                }
                repeatedTimes += 1
                
            }
        }
        if repeatedTimes == thePlayerCard.value.rawValue - 10 {
            player.append(contentsOf: middle)
            middle.removeAll()
            addToMiddle(theCard: computer[0], playerTurn: isPlayerTurn)
            isPlayerTurn.toggle()
        }
    }
    
    mutating func repeatPlayer (theComputerCard: Card) {
        var repeatedTimes = 0
        for _ in 0...theComputerCard.value.rawValue - 11 {
            if player.count > 0 {
                addToMiddle(theCard: player[0], playerTurn: isPlayerTurn)
                if middle.count > 0 {
                    check(theCard: middle[0], playerTurn: isPlayerTurn, isRepeating: true)
                }
                repeatedTimes += 1
            }
            
        }
        if repeatedTimes == theComputerCard.value.rawValue - 10 {
            computer.append(contentsOf: middle)
            middle.removeAll()
            addToMiddle(theCard: player[0], playerTurn: isPlayerTurn)
            isPlayerTurn.toggle()
        }
    }
    
    mutating func playTheGame() {
        
        if computer.count < 1{
            whoIsWinner(winner: "Player")
            
        }
        else if player.count < 1{
            whoIsWinner(winner: "Computer")
            
        }
        else {
            if isPlayerTurn {
                addToMiddle(theCard: player[0], playerTurn: isPlayerTurn)
                check(theCard: middle[0], playerTurn: isPlayerTurn, isRepeating: false)
                
            } else {
                addToMiddle(theCard: computer[0], playerTurn: isPlayerTurn)
                check(theCard: middle[0], playerTurn: isPlayerTurn, isRepeating: false)
                
            }
        }
        
    }
    
    mutating func start() {
        while isGameOver == true {
            dealCards()
            isGameOver = false
        
        }
        
        while isGameOver == false {
            playTheGame()
    }
  }
    
    mutating func whoIsWinner(winner: String) {
        
        if winner == "Player" && isGameOver == false
        {
            print("========================================================")
            print("VICTORY")
            isGameOver = true
            
        }
        else if winner == "Computer" && isGameOver == false
        {
            print("========================================================")
            print("DEFEATED")
            isGameOver = true

        }
    }
    
    
    
}

var newGame = beggarYourNeighbour()
newGame.start()
