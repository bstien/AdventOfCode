import Foundation

extension Year2022.Day3: Runnable {
    func run(input: String) {
        let lines = splitInput(input)
        let itemPriorityOrder = ("a"..."z").characters + ("A"..."Z").characters

        let part1 = part1(lines: lines)
        let part2 = part2(lines: lines)

        [part1, part2].enumerated().forEach {
            let sum = $0.element.map { overlappingItem in
                guard let index = itemPriorityOrder.firstIndex(where: { $0 == overlappingItem }) else {
                    fatalError("Could not find priority for item '\(overlappingItem)'")
                }

                return index + 1
            }.reduce(0, +)

            printResult(dayPart: $0.offset + 1, message: "Sum of overlapping items: \(sum)")
        }
    }

    private func part1(lines: [String]) -> [Character] {
        lines
            .map {
                let backpackSize = $0.count / 2
                return Backpacks(lhs: String($0.prefix(backpackSize)), rhs: String($0.suffix(backpackSize)))
            }
            .map { backpacks -> Character in
                guard let firstOverlappingItem = backpacks.lhs.first(where: { backpacks.rhs.contains($0) }) else {
                    fatalError("Could not find overlapping item in backpacks. lhs: '\(backpacks.lhs)' – rhs: '\(backpacks.rhs)'")
                }

                return firstOverlappingItem
            }
    }

    private func part2(lines: [String]) -> [Character] {
        lines
            .chunks(ofCount: 3)
            .map { lines in
                let lastTwoBackpacks = lines.dropFirst()
                guard let firstOverlappingItem = lines.first?.first(where: { item in
                    lastTwoBackpacks.allSatisfy { $0.contains(item) }
                }) else {
                    fatalError("No overlapping items found for group: \(lines)")
                }

                return firstOverlappingItem
            }
    }
}

private extension Year2022.Day3 {
    typealias Backpacks = (lhs: String, rhs: String)
}

private extension ClosedRange where Bound == Unicode.Scalar {
    var range: ClosedRange<UInt32>  { lowerBound.value...upperBound.value }
    var scalars: [Unicode.Scalar]   { range.compactMap(Unicode.Scalar.init) }
    var characters: [Character]     { scalars.map(Character.init) }
}
