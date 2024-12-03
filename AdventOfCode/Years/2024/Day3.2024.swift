import Foundation
import RegexBuilder

extension Year2024.Day3: Runnable {
    func run(input: String) {
        part1(input: input)
        part2(input: input)
    }

    private func part1(input: String) {
        let regex = Regex {
            "mul("
            TryCapture({ OneOrMore(.digit) }, transform: { Int($0) ?? 0 })
            ","
            TryCapture({ OneOrMore(.digit) }, transform: { Int($0) ?? 0 })
            ")"
        }

        let sum = input
            .matches(of: regex)
            .map(\.output)
            .reduce(0) { $0 + ($1.1 * $1.2) }
        printResult(dayPart: 1, message: "Sum: \(sum)")
    }

    private func part2(input: String) {
    }
}
