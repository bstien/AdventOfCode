import Foundation

extension Year2024.Day5: Runnable {
    func run(input: String) {
        let lines = splitInput(input, separatedBy: "\n\n")
        let rules = parseRules(content: lines[0])
        let updates = parseUpdates(content: lines[1])
        let incorrectUpdates = findIncorrectUpdates(rules: rules, updates: updates)
        part1(rules: rules, updates: updates, incorrectUpdates: incorrectUpdates)
    }

    private func part1(rules: [PageRule], updates: [[Int]], incorrectUpdates: [Int]) {
        var sum = 0
        for update in updates.enumerated() where !incorrectUpdates.contains(update.offset) {
            sum += update.element[update.element.count / 2]
        }
        printResult(dayPart: 1, message: "Sum: \(sum)")
    }

    // MARK: - Private methods

    private func parseRules(content: String) -> [PageRule] {
        splitInput(content).map { line in
            let values = line.split(separator: "|").map(String.init).compactMap(Int.init)
            return PageRule(first: values[0], second: values[1])
        }
    }

    private func parseUpdates(content: String) -> [[Int]] {
        splitInput(content).map { line in
            line.split(separator: ",").map(String.init).compactMap(Int.init)
        }
    }

    private func findIncorrectUpdates(rules: [PageRule], updates: [[Int]]) -> [Int] {
        var incorrectUpdates = [Int]()

        for rule in rules {
            for update in updates.enumerated() {
                if incorrectUpdates.contains(update.offset) { continue }

                if let firstIndex = update.element.firstIndex(of: rule.first) {
                    if let secondIndex = update.element.firstIndex(of: rule.second) {
                        if firstIndex > secondIndex {
                            incorrectUpdates.append(update.offset)
                        }
                    }
                }
            }
        }

        return incorrectUpdates
    }
}

private struct PageRule {
    let first: Int
    let second: Int
}
