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
        input.split(
            separatedBy: separatedBy,
            omittingEmptySubsequences: omittingEmptySubsequences
        )
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
        let filename = "\(year)/\(day)" + (isTest ? ".test" : "") + ".txt"
        guard let input = try? Input.get(filename) else {
            fatalError("Could not open input file \(filename)")
        }

        let titlePrefix = isTest ? "Running test" : "Solving"
        print("\(titlePrefix) – Day \(day) (\(year))")

        let start: CFTimeInterval
        let end: CFTimeInterval

        switch self {
        case let runnable as Runnable:
            start = CACurrentMediaTime()
            runnable.run(input: input, isTest: isTest)
            end = CACurrentMediaTime()
        case let asyncRunnable as AsyncRunnable:
            start = CACurrentMediaTime()
            Task.synchronous { await asyncRunnable.run(input: input) }
            end = CACurrentMediaTime()
        default:
            fatalError("\(self) is neither `Runnable` nor `AsyncRunnable`!")
        }


        let elapsed = end - start
        print("""
              Solved in \(numberFormatter.string(from: NSNumber(value: elapsed))!)s
              —————————————————————————————————
              """)
    }
}
