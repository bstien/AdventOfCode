import Foundation

extension Year2023.Day1: Runnable {
    func run(input: String) {
        let lines = splitInput(input)
        part1(lines: lines)
        part2(lines: lines)
    }

    private func part1(lines: [String]) {
        let total = findTotal(from: lines, includeSpelledNumbers: false)
        printResult(dayPart: 1, message: "Total: \(total)")
    }

    private func part2(lines: [String]) {
        let total = findTotal(from: lines, includeSpelledNumbers: true)
        printResult(dayPart: 2, message: "Total: \(total)")
    }

    private func findTotal(from lines: [String], includeSpelledNumbers: Bool) -> Int {
        lines.compactMap { line in
            let firstOccurences = findOccurences(in: line, includeSpelledNumbers: includeSpelledNumbers)
            let lastOccurences = findOccurences(in: line, includeSpelledNumbers: includeSpelledNumbers, compareOption: .backwards)

            guard
                let first = firstOccurences.min(by: { $0.position < $1.position }),
                let last = lastOccurences.max(by: { $0.position < $1.position })
            else { return nil }

            return (first.intValue * 10) + last.intValue
        }.reduce(0, +)
    }

    private func findOccurences(in line: String, includeSpelledNumbers: Bool, compareOption: String.CompareOptions = []) -> [NumberOccurrence] {
        func findOccurrence(of string: String, intValue: Int) -> NumberOccurrence? {
            guard let range = line.range(of: string, options: compareOption) else { return nil }
            return NumberOccurrence(intValue: intValue, position: range.lowerBound.utf16Offset(in: line))
        }

        return numberMapping.flatMap { mapping in
            [
                findOccurrence(of: String(mapping.intValue), intValue: mapping.intValue),
                includeSpelledNumbers ? findOccurrence(of: mapping.spelled, intValue: mapping.intValue) : nil
            ]
        }.compactMap { $0 }
    }


    private var numberMapping: [(intValue: Int, spelled: String)] {
        [
            (intValue: 1, spelled: "one"),
            (intValue: 2, spelled: "two"),
            (intValue: 3, spelled: "three"),
            (intValue: 4, spelled: "four"),
            (intValue: 5, spelled: "five"),
            (intValue: 6, spelled: "six"),
            (intValue: 7, spelled: "seven"),
            (intValue: 8, spelled: "eight"),
            (intValue: 9, spelled: "nine")
        ]
    }
}

private struct NumberOccurrence {
    let intValue: Int
    let position: Int
}
