import Foundation

extension Year2021.Day10: Runnable {
    func run(input: String) {
        let characters = splitInput(input).map { $0.map { $0 } }
        part1(characters: characters)
        part2(characters: characters)
    }

    private func part1(characters: [[Character]]) {
        var illegalCharacters = [Character: Int]()

        for line in characters {
            var stack = [Character]()
            for character in line {
                if Character.openingCharacters.contains(character) {
                    stack.append(character)
                } else if Character.closingCharacters.contains(character) {
                    guard let last = stack.popLast() else { return }
                    if !(character.openingCharacter == last) {
                        illegalCharacters[character, default: 0] += 1
                    }
                }
            }
        }

        let sum = illegalCharacters.compactMap { character, count in
            character.illegalValue.map { $0 * count}
        }.reduce(0, +)

        printResult(dayPart: 1, message: "Sum of illegal characters: \(sum)")
    }

    private func part2(characters: [[Character]]) {
        var sums = [Int]()

        for line in characters {
            var stack = [Character]()
            var isCorrupt = false
            for character in line {
                if Character.openingCharacters.contains(character) {
                    stack.append(character)
                } else if Character.closingCharacters.contains(character) {
                    if !(character.openingCharacter == stack.popLast()!) {
                        isCorrupt = true
                    }
                }
            }

            if !isCorrupt {
                let sum = stack.reversed().compactMap { $0.closingCharacter?.legalValue }.reduce(into: 0, { result, value in
                    result = (result * 5) + value
                })
                sums.append(sum)
            }
        }

        let middleSum = sums.sorted()[sums.count / 2]

        printResult(dayPart: 2, message: "Middle sum: \(middleSum)")
    }
}

// MARK: - Private extensions

private extension Character {
    private static var pairs: [(open: Character, close: Character)] {
        [
            (open: "<", close: ">"),
            (open: "[", close: "]"),
            (open: "(", close: ")"),
            (open: "{", close: "}")
        ]
    }

    static var openingCharacters: [Character] {
        pairs.map(\.open)
    }

    static var closingCharacters: [Character] {
        pairs.map(\.close)
    }

    var illegalValue: Int? {
        switch self {
        case ")": return 3
        case "]": return 57
        case "}": return 1197
        case ">": return 25137
        default: return nil
        }
    }

    var legalValue: Int? {
        switch self {
        case ")": return 1
        case "]": return 2
        case "}": return 3
        case ">": return 4
        default: return nil
        }
    }

    var closingCharacter: Character? {
        Self.pairs.first(where: { $0.open == self})?.close
    }

    var openingCharacter: Character? {
        Self.pairs.first(where: { $0.close == self})?.open
    }
}
