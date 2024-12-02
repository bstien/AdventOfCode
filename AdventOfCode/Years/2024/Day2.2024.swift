import Foundation

extension Year2024.Day2: Runnable {
    func run(input: String) {
        let reports = splitInput(input).map { splitInput($0, separatedBy: " ").map { Int($0) ?? 0 } }
        let range = 1...3
        part1(reports: reports, range: range)
        part2(reports: reports, range: range)
    }

    private func part1(reports: [[Int]], range: ClosedRange<Int>) {
        let safeReports = reports.filter { isSafe(report: $0, range: range) }.count
        printResult(dayPart: 1, message: "# of safe reports: \(safeReports)")
    }

    private func part2(reports: [[Int]], range: ClosedRange<Int>) {
        let safeReports = reports.filter { report in
            if isSafe(report: report, range: range) { return true }

            // Report is not safe. Try to remove one level at a time from the report.
            // If any of them succeed the report is safe.
            for index in report.indices {
                var report = report
                report.remove(at: index)
                if isSafe(report: report, range: range) { return true }
            }
            return false
        }.count
        printResult(dayPart: 2, message: "# of safe reports: \(safeReports)")
    }

    private func isSafe(
        report: [Int],
        range: ClosedRange<Int>,
        index: Int = 0,
        direction: Direction? = nil
    ) -> Bool {
        guard report.indices.contains(index + 1) else { return true }

        let current = report[index]
        let next = report[index + 1]
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

        return isSafe(report: report, range: range, index: index + 1, direction: direction)
    }
}

private enum Direction {
    case increasing
    case decreasing
}
