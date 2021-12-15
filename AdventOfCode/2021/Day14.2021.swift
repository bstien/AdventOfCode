import Foundation
import Algorithms

extension Year2021.Day14: Runnable {
    func run(input: String) {
        let (polymer, rules) = parse(input: input)

        let part1 = start(iterations: 10, polymer: polymer, rules: rules)
        printResult(dayPart: 1, message: "Sum after 10 iterations: \(part1)")

        let part2 = start(iterations: 40, polymer: polymer, rules: rules)
        printResult(dayPart: 2, message: "Sum after 40 iterations: \(part2)")
    }

    func start(iterations: Int, polymer: String, rules: [String: Character]) -> Int {
        var countDict = polymer.reduce(into: [Character: Int]()) { result, character in
            result[character, default: 0] += 1
        }

        polymer.windows(ofCount: 2).forEach { pair in
            iterate(iterations: iterations, characters: String(pair), rules: rules, countDict: &countDict)
        }

        let min = countDict.map(\.value).min()!
        let max = countDict.map(\.value).max()!
        return max - min
    }

    func iterate(iterations: Int, characters: String, rules: [String: Character], countDict: inout [Character: Int]) {
        guard
            iterations != 0,
            let characterToAdd = rules[characters]
        else { return }

        countDict[characterToAdd, default: 0] += 1

        let pairA = "\(characters.first!)\(characterToAdd)"
        let pairB = "\(characterToAdd)\(characters.last!)"
        iterate(iterations: iterations - 1, characters: pairA, rules: rules, countDict: &countDict)
        iterate(iterations: iterations - 1, characters: pairB, rules: rules, countDict: &countDict)
    }

    private func parse(input: String) -> (String, [String: Character]) {
        var lines = splitInput(input)
        let polymer = lines.removeFirst()

        var rules = [String: Character]()
        for line in lines {
            let split = splitInput(line, separator: " ")
            rules[split[0]] = split[2].first!
        }

        return (polymer, rules)
    }
}
