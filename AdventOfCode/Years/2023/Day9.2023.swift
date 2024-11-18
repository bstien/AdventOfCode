import Foundation

extension Year2023.Day9: Runnable {
    func run(input: String) {
        let numbers = parse(input: input)
        part1(numbers: numbers)
        part2(numbers: numbers)
    }

    private func part1(numbers: [[Int]]) {
        let total = numbers
            .map { findDifferences(line: $0) }
            .map { findNextValue(differences: $0) }
            .sum

        printResult(dayPart: 1, message: "Total: \(total)")
    }

    private func part2(numbers: [[Int]]) {
        let total = numbers
            .map { findDifferences(line: $0) }
            .map { findPreviousValue(differences: $0) }
            .sum

        printResult(dayPart: 2, message: "Total: \(total)")
    }

    private func findNextValue(differences: [[Int]]) -> Int {
        var index = differences.count - 1
        var nextValue = 0

        while index > 0 {
            nextValue = nextValue + differences[index - 1].last!
            index -= 1
        }

        return nextValue
    }

    private func findPreviousValue(differences: [[Int]]) -> Int {
        var index = differences.count - 1
        var nextValue = 0

        while index > 0 {
            nextValue = differences[index - 1].first! - nextValue
            index -= 1
        }

        return nextValue
    }

    private func findDifferences(line: [Int], differences: [[Int]] = []) -> [[Int]] {
        var differences = differences

        if differences.isEmpty { differences.append(line) }

        let newDiff = line.windows(ofCount: 2).map { $0[$0.endIndex - 1] - $0[$0.startIndex] }
        differences.append(newDiff)

        if newDiff.allSatisfy({ $0 == 0 }) {
            return differences
        }

        return findDifferences(line: newDiff, differences: differences)
    }

    private func parse(input: String) -> [[Int]] {
        splitInput(input).map { splitInput($0, separatedBy: " ").compactMap(\.toInt) }
    }
}
