import Foundation

extension Year2021.Day8: Runnable {
    func run(input: String) {
        let lines = splitInput(input)
        part1(lines: lines)
    }

    private func part1(lines: [String]) {
        let segments = lines.map { splitInput($0, separatedBy: "|")[1] }.flatMap { splitInput($0, separatedBy: " ") }
        let count = segments.filter { [2, 3, 4, 7].contains($0.count) }.count
        printResult(dayPart: 1, message: "# of segments matching digits 1, 4, 7 or 8: \(count)")
    }
}
