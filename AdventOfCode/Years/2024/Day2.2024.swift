import Foundation

extension Year2024.Day2: Runnable {
    func run(input: String) {
        let reports = splitInput(input).map { splitInput($0, separatedBy: " ").map { Int($0) ?? 0 } }
        part1(reports: reports)
    }

    private func part1(reports: [[Int]]) {
        let count = reports.filter { isSafe(level: $0, range: 1...3) }.count
        printResult(dayPart: 1, message: "# of safe levels: \(count)")
    }

    private func isSafe(level: [Int], range: ClosedRange<Int>, index: Int = 0, direction: Direction? = nil) -> Bool {
        guard level.indices.contains(index + 1) else { return true }

        let current = level[index]
        let next = level[index + 1]
        let diff = next - current
        var direction = direction

        switch direction {
        case .increasing:
            guard range.contains(diff) else { return false }
        case .decreasing:
            guard diff < 0, range.contains(abs(diff)) else { return false }
        case nil:
            guard range.contains(abs(diff)) else { return false }
            direction = diff < 0 ? .decreasing : .increasing
        }

        return isSafe(level: level, range: range, index: index + 1, direction: direction)
    }
}

private enum Direction {
    case increasing
    case decreasing
}
