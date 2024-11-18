import Foundation
import QuartzCore

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

    func solve(runTask: Bool = true, runTest: Bool = false) {
        if runTest {
            solveAndPrint(isTest: true)
        }

        if runTask {
            solveAndPrint()
        }
    }

    func splitInput(_ input: String, separatedBy: String = "\n", omittingEmptySubsequences: Bool = true) -> [String] {
        input
            .components(separatedBy: separatedBy)
            .compactMap { element in
                if omittingEmptySubsequences, element.isEmpty {
                    return nil
                }
                return element
            }
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

        let filename = "\(year)/\(year).\(day)" + (isTest ? ".test" : "") + ".txt"
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
}
