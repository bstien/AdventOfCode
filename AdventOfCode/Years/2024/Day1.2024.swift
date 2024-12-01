import Foundation

extension Year2024.Day1: Runnable {
    func run(input: String) {
        let values = splitInput(input).map { splitInput($0, separatedBy: " ").map { Int($0) ?? 0 } }
        part1(values)
    }

    private func part1(_ values: [[Int]]) {
        let leftValues = values.map { $0[0] }.sorted()
        let rightValues = values.map { $0[1] }.sorted()

        var totalDiff = 0
        for value in zip(leftValues, rightValues) {
            totalDiff += abs(value.0 - value.1)
        }
        printResult(dayPart: 1, message: "Total diff: \(totalDiff)")
    }

    private func part2(_ values: [[Int]]) {
    }
}
