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
            let numberSections = splitInput(components[1], separatedBy: "|")

            let numbers = numberSections.map {
                Set(splitInput($0, separatedBy: " ").compactMap { $0.toInt })
            }

            return Card(winningNumbers: numbers[0], yourNumbers: numbers[1])
        }
    }
}

private struct Card {
    let winningNumbers: Set<Int>
    let yourNumbers: Set<Int>
}
