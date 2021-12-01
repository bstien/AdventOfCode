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
    static func solve(input: String? = nil) {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 3

        guard let input = input ?? readInputFromFile() else {
            print("Could not open input file \(Self.self).txt")
            return
        }

        print("Solving \(Self.self)")

        let start = CACurrentMediaTime()
        run(input: input)
        let end = CACurrentMediaTime()

        let elapsed = end - start
        print("Solved \(Self.self) in \(formatter.string(from: NSNumber(value: elapsed))!)s")

        print("—————————————————————————————————")
    }

    private static func readInputFromFile() -> String? {
        try? Input.get("\(Self.self).txt")
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
