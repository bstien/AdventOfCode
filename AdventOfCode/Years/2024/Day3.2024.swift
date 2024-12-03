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
        let regex = Regex {
            ChoiceOf {
                "don't()"
                "do()"
                Local {
                    "mul("
                    TryCapture({ OneOrMore(.digit) }, transform: { Int($0) ?? 0 })
                    ","
                    TryCapture({ OneOrMore(.digit) }, transform: { Int($0) ?? 0 })
                    ")"
                }
            }
        }

        var isEnabled = true
        var sum = 0
        let matchOutput = input
            .matches(of: regex)
            .map(\.output)

        for output in matchOutput {
            switch output.0 {
            case "don't()":
                isEnabled = false
            case "do()":
                isEnabled = true
            default:
                guard isEnabled, let lhs = output.1, let rhs = output.2 else { continue }
                sum += (lhs * rhs)
            }
        }

        printResult(dayPart: 2, message: "Sum: \(sum)")
    }
}
