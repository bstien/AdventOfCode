import Foundation
import QuartzCore

enum Result {
    case success
    case fail
}

protocol Runnable {
    func run(input: String)
}

class Day {
    let year: Int
    let day: Int

    required init(year: Int, day: Int) {
        self.year = year
        self.day = day
    }
}

extension Day {
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 3
        return formatter
    }

    // MARK: - Internal methods

    func solve(includeTest: Bool = false) {
        if includeTest {
            solveAndPrint(isTest: includeTest)
        }

        solveAndPrint()
    }

    func splitInput(_ input: String, separator: Character = "\n", omittingEmptySubsequences: Bool = true) -> [String] {
        input.split(separator: separator, omittingEmptySubsequences: omittingEmptySubsequences).map(String.init)
    }

    func printResult(result: Result = .success, dayPart: Int, message: String) {
        switch result {
        case .success:
            print("✅ Part \(dayPart): \(message)")
        case .fail:
            print("⚠️ Part \(dayPart): \(message)")
        }
    }

    // MARK: - Private methods

    private func solveAndPrint(isTest: Bool = false) {
        guard let selfRunnable = self as? Runnable else {
            fatalError("\(self) is not Runnable!")
        }

        let filename = "\(year).\(day)" + (isTest ? ".test" : "") + ".txt"
        guard let input = try? Input.get(filename) else {
            fatalError("Could not open input file \(filename)")
        }

        let titlePrefix = isTest ? "Running test" : "Solving"
        print("\(titlePrefix) – Day \(day) (\(year))")

        let start = CACurrentMediaTime()
        selfRunnable.run(input: input)
        let end = CACurrentMediaTime()

        let elapsed = end - start
        print("""
              Solved in \(numberFormatter.string(from: NSNumber(value: elapsed))!)s
              —————————————————————————————————
              """)
    }

    private func readInputFromFile() -> String? {
        try? Input.get("y\(year)d\(day).txt")
    }

    private func readTestInputFromFile() -> String? {
        try? Input.get("y\(year)d\(day).test.txt")
    }
}
