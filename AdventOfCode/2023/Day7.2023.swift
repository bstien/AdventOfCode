import Foundation

extension Year2023.Day7: Runnable {
    func run(input: String) {
        let hands = parseHands(input: input)
        part1(hands: hands)
    }

    private func part1(hands: [Hand]) {
        let sorted = hands.sorted(by: {
            if $0.kindValue > $1.kindValue { return false }
            if $0.kindValue < $1.kindValue { return true }

            for pair in zip($0.hand, $1.hand) {
                if pair.0 == pair.1 { continue }
                return pair.0.rawValue < pair.1.rawValue
            }

            return true
        })

        let winnings = sorted.enumerated().reduce(0, { sum, tuple in
            sum + (tuple.element.bet * (tuple.offset + 1))
        })

        printResult(dayPart: 1, message: "Winnings: \(winnings)")
    }

    private func parseHands(input: String) -> [Hand] {
        splitInput(input).map {
            let components = splitInput($0, separatedBy: " ")

            guard let bet = components[1].toInt else { fatalError("Could not parse Int: '\(components[1])'") }

            return Hand(hand: components[0], bet: bet)
        }
    }

    private struct Hand {
        let kind: HandKind
        let hand: [Card]
        let bet: Int

        var kindValue: Int {
            kind.rawValue
        }

        init(hand: String, bet: Int) {
            self.kind = Self.parseHandKind(hand: hand)
            self.hand = hand.compactMap(Card.init(character:))
            self.bet = bet
        }

        private static func parseHandKind(hand: String) -> HandKind {
            let grouped = hand.grouped(by: { $0 }).mapValues(\.count)

            let keyCount = grouped.keys.count
            let values = grouped.values
            
            if keyCount == 1 { return .fiveOfAKind }
            if keyCount == hand.count { return .highCard }
            if values.contains(4) { return .fourOfAKind }
            if values.contains(3) { return keyCount == 2 ? .fullHouse : .threeOfAKind }

            return values.filter { $0 == 2 }.count == 2 ? .twoPair : .onePair
        }
    }

    private enum HandKind: Int {
        case highCard
        case onePair
        case twoPair
        case threeOfAKind
        case fullHouse
        case fourOfAKind
        case fiveOfAKind
    }

    private enum Card: Int {
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case ten
        case jack
        case queen
        case king
        case ace

        init(character: Character) {
            switch character {
            case "2": self = .two
            case "3": self = .three
            case "4": self = .four
            case "5": self = .five
            case "6": self = .six
            case "7": self = .seven
            case "8": self = .eight
            case "9": self = .nine
            case "T": self = .ten
            case "J": self = .jack
            case "Q": self = .queen
            case "K": self = .king
            case "A": self = .ace
            default:
                fatalError("Could not find card for '\(character)'")
            }
        }
    }
}
