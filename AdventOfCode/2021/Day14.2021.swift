import Foundation
import Algorithms

extension Year2021.Day14: Runnable {
    func run(input: String) {
        let (polymer, rules) = parse(input: input)
        let part1 = iterate(iterations: 10, polymer: polymer, rules: rules)

        printResult(dayPart: 1, message: "Sum after 10 iterations: \(part1)")
    }

    private func iterate(iterations: Int, polymer: String, rules: [String: String]) -> Int {
        var polymer = polymer

        for _ in (0..<iterations) {
            var inserted = 0
            var newPolymer = polymer
            for (index, window) in polymer.windows(ofCount: 2).enumerated() {
                if let toInsert = rules[String(window)] {
                    newPolymer.insert(contentsOf: toInsert, at: newPolymer.index(newPolymer.startIndex, offsetBy: index + inserted + 1))
                    inserted += 1
                }
            }
            polymer = newPolymer
        }

        let grouped = polymer.reduce(into: [Character: Int]()) { result, character in
            result[character, default: 0] += 1
        }

        let min = grouped.map(\.value).min()!
        let max = grouped.map(\.value).max()!
        return max - min
    }

    private func parse(input: String) -> (String, [String: String]) {
        var lines = splitInput(input)
        let polymer = lines.removeFirst()

        var rules = [String: String]()
        for line in lines {
            let split = splitInput(line, separator: " ")
            rules[split[0]] = split[2]
        }

        return (polymer, rules)
    }
}
