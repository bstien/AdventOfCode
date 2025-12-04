import Foundation

extension Year2025.Day3: Runnable {
    func run(input: String) {
        let banks = splitInput(input).map { Array($0).map(String.init).compactMap(Int.init) }

        let part1Sum = part1(banks: banks)
        printResult(dayPart: 1, message: "Sum of batteries: \(part1Sum)")

        let part2Sum = part2(banks: banks)
        printResult(dayPart: 2, message: "Sum of batteries: \(part2Sum)")
    }

    private func part1(banks: [[Int]]) -> Int {
        banks.reduce(0) { $0 + findHighestCombination(in: $1, keepHighest: 2) }
    }

    private func part2(banks: [[Int]]) -> Int {
        banks.reduce(0) { $0 + findHighestCombination(in: $1, keepHighest: 12) }
    }

    private func findHighestCombination(in batteries: [Int], keepHighest keepCount: Int) -> Int {
        var toKeep = Array(repeating: 0, count: keepCount)
        let diff = abs(keepCount - batteries.count)

        for (index, battery) in batteries.enumerated() {
            let minIndexToCheck = max(0, index - diff)

            var hasInserted = false
            for (i, b) in toKeep.enumerated() where i >= minIndexToCheck {
                if hasInserted {
                    toKeep[i] = 0
                } else if battery > b {
                    toKeep[i] = battery
                    hasInserted = true
                }
            }
        }

        return toKeep
            .reversed()
            .enumerated()
            .reduce(0) { $0 + ($1.element * Int(pow(10, Double($1.offset)))) }
    }
}
