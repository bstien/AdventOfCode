import Foundation

extension Year2025.Day5: Runnable {
    typealias FreshRange = ClosedRange<Int>

    func run(input: String) {
        let splitInput = splitInput(input, separatedBy: "\n\n")
        let ranges = splitInput[0].split(separatedBy: "\n").map(ClosedRange<Int>.parse(_:))
        let ids = splitInput[1].split(separatedBy: "\n").compactMap { Int($0) }

        let part1Sum = part1(ids: ids, ranges: ranges)
        printResult(dayPart: 1, message: "# of fresh ingredients: \(part1Sum)")
    }

    private func part1(ids: [Int], ranges: [FreshRange]) -> Int {
        var freshIngredientCount = 0
        for id in ids {
            if ranges.contains(where: { $0.contains(id) }) {
                freshIngredientCount += 1
            }
        }

        return freshIngredientCount
    }
}

private extension ClosedRange<Int> {
    static func parse(_ string: String) -> Self {
        let split = string.split(separator: "-").compactMap { Int($0) }

        guard let lower = split.first, let upper = split.last else {
            fatalError()
        }

        return lower...upper
    }
}
