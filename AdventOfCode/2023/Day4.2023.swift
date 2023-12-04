import Foundation

extension Year2023.Day4: Runnable {
    func run(input: String) {
        let lines = splitInput(input)
        let cards = parseCards(lines: lines)
        part1(cards: cards)
        part2(cards: cards)
    }

    private func part1(cards: [Card]) {
        let total = cards.map { card in
            let intersection = card.winningNumbers.intersection(card.yourNumbers)
            return intersection.reduce(0, { sum, _ in sum == 0 ? 1 : sum * 2 })
        }.reduce(0, +)

        printResult(dayPart: 1, message: "Total: \(total)")
    }

    private func part2(cards: [Card]) {
        var cardWinnings = (0..<cards.count).reduce(into: [Int: Int](), { $0[$1] = 1})
        
        cards.enumerated().forEach { index, card in
            let newCardsWon = card.winningNumbers.intersection(card.yourNumbers).count

            if newCardsWon == 0 { return }

            for i in (1...newCardsWon) {
                cardWinnings[index + i, default: 1] += 1 * cardWinnings[index, default: 1]
            }
        }

        let totalCardsWon = cardWinnings.values.reduce(0, +)
        printResult(dayPart: 2, message: "Total: \(totalCardsWon)")
    }

    private func parseCards(lines: [String]) -> [Card] {
        lines.map { line in
            let components = splitInput(line, separatedBy: ":")

            guard let cardId = splitInput(components[0], separatedBy: " ")[1].toInt else {
                fatalError("Could not parse cardId: '\(components[0])'")
            }

            let numberSections = splitInput(components[1], separatedBy: "|")

            let winningNumbers = splitInput(numberSections[0], separatedBy: " ").compactMap { $0.toInt }
            let yourNumbers = splitInput(numberSections[1], separatedBy: " ").compactMap { $0.toInt }

            return Card(id: cardId, winningNumbers: Set(winningNumbers), yourNumbers: Set(yourNumbers))
        }
    }
}

private struct Card {
    let id: Int
    let winningNumbers: Set<Int>
    let yourNumbers: Set<Int>
}
