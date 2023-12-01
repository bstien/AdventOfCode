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
            let occurrences = numberMapping.flatMap { mapping in
                var occurrences = [findOccurrences(of: String(mapping.0), in: line, intValue: mapping.0)]

                if includeSpelledNumbers {
                    occurrences += [findOccurrences(of: mapping.1, in: line, intValue: mapping.0)]
                }
                return occurrences
            }.compactMap { $0 }

            guard
                let first = occurrences.min(by: { $0.first < $1.first }),
                let last = occurrences.max(by: { $0.last < $1.last })
            else { return nil }

            return (first.intValue * 10) + last.intValue
        }.reduce(0, +)
    }

    private func findOccurrences(of string: String, in line: String, intValue: Int) -> NumberOccurrence? {
        let ranges = line.ranges(of: string).compactMap { $0 }

        guard
            let first = ranges.compactMap({ $0.lowerBound.encodedOffset }).min(),
            let last = ranges.compactMap({ $0.upperBound.encodedOffset }).max()
        else { return nil }

        return NumberOccurrence(intValue: intValue, first: first, last: last)
    }

    private var numberMapping: [(Int, String)] {
        [
            (1, "one"),
            (2, "two"),
            (3, "three"),
            (4, "four"),
            (5, "five"),
            (6, "six"),
            (7, "seven"),
            (8, "eight"),
            (9, "nine")
        ]
    }
}

struct NumberOccurrence {
    let intValue: Int
    let first: Int
    let last: Int
}
