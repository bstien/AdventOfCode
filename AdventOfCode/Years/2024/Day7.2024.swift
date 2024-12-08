import Foundation

extension Year2024.Day7: Runnable {
    func run(input: String) {
        let calibrations = parseCalibrations(input)
        part1(calibrations: calibrations)
        part2(calibrations: calibrations)
    }

    private func part1(calibrations: [Int: [Int]]) {
        let sum = checkCalibrations(calibrations, useCombine: false)
        printResult(dayPart: 1, message: "Valid calibrations: \(sum)")
    }

    private func part2(calibrations: [Int: [Int]]) {
        let sum = checkCalibrations(calibrations, useCombine: true)
        printResult(dayPart: 2, message: "Valid calibrations: \(sum)")
    }

    private func checkCalibrations(_ calibrations: [Int: [Int]], useCombine: Bool) -> Int {
        calibrations
            .filter { check(values: $0.value, testValue: $0.key, useCombine: useCombine) }
            .reduce(0) { $0 + $1.key }
    }

    private func check(
        index: Int = 0,
        values: [Int],
        testValue: Int,
        sum: Int = 0,
        useCombine: Bool
    ) -> Bool {
        guard values.indices.contains(index) else { return sum == testValue }
        guard sum <= testValue else { return false }

        let value = values[index]
        let additionSum = sum + value
        let multiplicationSum = max(sum, 1) * value
        let joinSum = Int("\(sum)\(value)")!

        return check(index: index + 1, values: values, testValue: testValue, sum: additionSum, useCombine: useCombine) ||
        check(index: index + 1, values: values, testValue: testValue, sum: multiplicationSum, useCombine: useCombine) ||
        (useCombine ? check(index: index + 1, values: values, testValue: testValue, sum: joinSum, useCombine: useCombine) : false)
    }

    private func parseCalibrations(_ input: String) -> [Int: [Int]] {
        let lines = splitInput(input)

        return lines.reduce(into: [Int: [Int]]()) { result, line in
            let tokens = splitInput(line, separatedBy: ":")
            let key = Int(tokens[0])!
            let values = splitInput(tokens[1], separatedBy: " ").compactMap(Int.init)
            result[key] = values
        }
    }
}
