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

        var pairsToMap = polymer.windows(ofCount: 2).map { String($0) }.reduce(into: [String: Int]()) { set, string in
            set[string, default: 0] += 1
        }

        for _ in (0..<iterations) {
            var newPairsToMap = [String: Int]()
            for pair in pairsToMap {
                if let characterToAdd = rules[pair.key] {
                    countDict[characterToAdd, default: 0] += pair.value

                    let newPairA = "\(pair.key.first!)\(characterToAdd)"
                    let newPairB = "\(characterToAdd)\(pair.key.last!)"
                    newPairsToMap[newPairA, default: 0] += pair.value
                    newPairsToMap[newPairB, default: 0] += pair.value
                }
            }
            pairsToMap = newPairsToMap
        }

        let min = countDict.map(\.value).min()!
        let max = countDict.map(\.value).max()!
        return max - min
    }

    private func parse(input: String) -> (String, [String: Character]) {
        var lines = splitInput(input)
        let polymer = lines.removeFirst()

        var rules = [String: Character]()
        for line in lines {
            let split = splitInput(line, separatedBy: " ")
            rules[split[0]] = split[2].first!
        }

        return (polymer, rules)
    }
}
