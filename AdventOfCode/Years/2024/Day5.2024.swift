import Foundation

extension Year2024.Day5: Runnable {
    func run(input: String) {
        let lines = splitInput(input, separatedBy: "\n\n")
        let rules = parseRules(content: lines[0])
        let updates = parseUpdates(content: lines[1])
        let incorrectUpdates = findIncorrectUpdates(rules: rules, updates: updates)

        part1(rules: rules, updates: updates, incorrectUpdates: incorrectUpdates)
        part2(rules: rules, updates: updates, incorrectUpdates: incorrectUpdates)
    }

    private func part1(rules: [PageRule], updates: [[Int]], incorrectUpdates: Set<Int>) {
        var sum = 0
        for update in updates.enumerated() where !incorrectUpdates.contains(update.offset) {
            sum += update.element[update.element.count / 2]
        }
        printResult(dayPart: 1, message: "Sum: \(sum)")
    }

    private func part2(rules: [PageRule], updates: [[Int]], incorrectUpdates: Set<Int>) {
        var updates = updates.enumerated().filter { incorrectUpdates.contains($0.offset) }.map(\.element)
        let numberOfUpdates = updates.count

        for index in (0..<numberOfUpdates) {
            var line = updates[index]
            var hasMadeChanges = false

            repeat {
                hasMadeChanges = false
                for rule in rules {
                    guard
                        let firstIndex = line.firstIndex(of: rule.first),
                        let secondIndex = line.firstIndex(of: rule.second),
                        secondIndex < firstIndex
                    else {
                        continue
                    }

                    hasMadeChanges = true
                    let element = line[firstIndex]
                    line.remove(at: firstIndex)
                    line.insert(element, at: secondIndex)
                }
            } while hasMadeChanges

            updates[index] = line
        }

        var sum = 0
        for update in updates {
            sum += update[update.count / 2]
        }
        printResult(dayPart: 2, message: "Sum: \(sum)")
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

    private func findIncorrectUpdates(rules: [PageRule], updates: [[Int]]) -> Set<Int> {
        var incorrectUpdates = Set<Int>()

        for rule in rules {
            for update in updates.enumerated() {
                guard
                    !incorrectUpdates.contains(update.offset),
                    let firstIndex = update.element.firstIndex(of: rule.first),
                    let secondIndex = update.element.firstIndex(of: rule.second),
                    secondIndex < firstIndex
                else { continue }

                incorrectUpdates.insert(update.offset)
            }
        }

        return incorrectUpdates
    }
}

private struct PageRule {
    let first: Int
    let second: Int
}
