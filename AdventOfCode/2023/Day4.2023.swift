import Foundation

extension Year2023.Day4: Runnable {
    func run(input: String) {
        let lines = splitInput(input)
        let cards = parseCards(lines: lines)
        part1(cards: cards)
    }

    private func part1(cards: [Card]) {
        let total = cards.map { card in
            let intersection = card.winningNumbers.intersection(card.yourNumbers)
            return intersection.reduce(0, { sum, _ in sum == 0 ? 1 : sum * 2 })
        }.reduce(0, +)

        printResult(dayPart: 1, message: "Total: \(total)")
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
