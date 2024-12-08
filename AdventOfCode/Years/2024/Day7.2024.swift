import Foundation

extension Year2024.Day7: Runnable {
    func run(input: String) {
        let calibrations = parseCalibrations(input)
        part1(calibrations: calibrations)
    }

    private func part1(calibrations: [Int: [Int]]) {
        var validSum = 0
        for calibration in calibrations {
            let isValid = check(values: calibration.value, testValue: calibration.key)
            if isValid {
                validSum += calibration.key
            }
        }

        printResult(dayPart: 1, message: "Valid calibrations: \(validSum)")
    }

    private func check(index: Int = 0, values: [Int], testValue: Int, sum: Int = 0) -> Bool {
        guard values.indices.contains(index) else { return sum == testValue }
        guard sum <= testValue else { return false }

        let value = values[index]
        let additionSum = sum + value
        let multiplicationSum = max(sum, 1) * value

        return check(index: index + 1, values: values, testValue: testValue, sum: additionSum) ||
        check(index: index + 1, values: values, testValue: testValue, sum: multiplicationSum)
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
