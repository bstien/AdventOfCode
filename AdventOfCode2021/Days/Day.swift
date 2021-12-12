import Foundation
import QuartzCore

enum Result {
    case success
    case fail
}

protocol Day {
    static func run(input: String)
}

extension Day {
    static private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 3
        return formatter
    }

    static func solve(includeTest: Bool = false) {
        if includeTest {
            runTest()
        }

        guard let input = readInputFromFile() else {
            fatalError("Could not open input file \(Self.self).txt")
        }

        print("Solving \(Self.self)")

        let start = CACurrentMediaTime()
        run(input: input)
        let end = CACurrentMediaTime()

        let elapsed = end - start
        print("Solved \(Self.self) in \(numberFormatter.string(from: NSNumber(value: elapsed))!)s")

        print("—————————————————————————————————")
    }

    private static func runTest() {
        guard let input = readTestInputFromFile() else {
            fatalError("Could not open test input file \(Self.self).test.txt")
        }

        print("Running test for \(Self.self)")

        let start = CACurrentMediaTime()
        run(input: input)
        let end = CACurrentMediaTime()

        let elapsed = end - start
        print("Solved \(Self.self) in \(numberFormatter.string(from: NSNumber(value: elapsed))!)s")

        print("—————————————————————————————————")
    }

    private static func readInputFromFile() -> String? {
        try? Input.get("\(Self.self).txt")
    }

    private static func readTestInputFromFile() -> String? {
        try? Input.get("\(Self.self).test.txt")
    }

    static func splitInput(_ input: String, separator: Character = "\n", omittingEmptySubsequences: Bool = true) -> [String] {
        input.split(separator: separator, omittingEmptySubsequences: omittingEmptySubsequences).map(String.init)
    }

    static func printResult(result: Result = .success, dayPart: Int, message: String) {
        switch result {
        case .success:
            print("✅ Part \(dayPart): \(message)")
        case .fail:
            print("⚠️ Part \(dayPart): \(message)")
        }
    }
}
