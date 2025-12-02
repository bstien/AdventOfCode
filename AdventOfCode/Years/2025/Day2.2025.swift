import Foundation

extension Year2025.Day2: Runnable {
    func run(input: String) {
        let ranges = splitInput(input, separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.map(Range.parse)
        let part1Sum = part1(ranges: ranges)
        printResult(dayPart: 1, message: "Sum of ids: \(part1Sum)")
    }

    private func part1(ranges: [Range]) -> Int {
        var repeatingIds = [Int]()

        for range in ranges {
            for id in range.closedRange {
                let s = id.description
                let count = s.count
                if count % 2 != 0 { continue }

                let firstHalf = s.prefix(count / 2)
                let secondHalf = s.suffix(count / 2)

                if firstHalf == secondHalf {
                    repeatingIds.append(id)
                }
            }
        }

        return repeatingIds.reduce(0, +)
    }
}

extension Year2025.Day2 {
    struct Range {
        let min: Int
        let max: Int

        var closedRange: ClosedRange<Int> {
            min...max
        }

        static func parse(_ string: String) -> Range {
            let comps = string.split(separatedBy: "-")
            let range = comps.compactMap(Int.init)

            guard range.count == 2 else {
                fatalError("Could not read range from '\(string)'")
            }

            return Range(min: range[0], max: range[1])
        }
    }
}
