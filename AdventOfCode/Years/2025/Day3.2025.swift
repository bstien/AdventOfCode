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
        var nextIndexToInsert = 0

        for (index, battery) in batteries.enumerated() {
            let minIndexToCheck = max(0, index - abs(keepCount - batteries.count))

            var hasInserted = false
            for (i, b) in toKeep.enumerated() {
                if i < minIndexToCheck {
                    continue
                }

                if hasInserted {
                    toKeep[i] = 0
                } else if battery > b {
                    toKeep[i] = battery
                    nextIndexToInsert = i
                    hasInserted = true
                }
            }
            nextIndexToInsert += 1
        }


        let sum = toKeep
            .reversed()
            .enumerated()
            .reduce(0) { $0 + ($1.element * max(1, Int(pow(10, Double($1.offset))))) }

        return sum
    }
}
