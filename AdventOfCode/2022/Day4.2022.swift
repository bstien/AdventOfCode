import Foundation

extension Year2022.Day4: Runnable {
    func run(input: String) {
        let elfPairs = splitInput(input).map { line -> ElfPair in
            let elves = splitInput(line, separatedBy: ",")
                .map {
                    splitInput($0, separatedBy: "-").compactMap(Int.init)
                }
            return ElfPair(lhs: elves[0][0]...elves[0][1], rhs: elves[1][0]...elves[1][1])
        }

        part1(elfPairs: elfPairs)
        part2(elfPairs: elfPairs)
    }

    private func part1(elfPairs: [ElfPair]) {
        let fullyOverlapping = elfPairs
            .filter { elfPair in
                let (lhs, rhs) = (elfPair.lhs, elfPair.rhs)
                return [(lhs, rhs), (rhs, lhs)].contains { (first, second) in
                    if first.isSingleSection {
                        return second.contains(first.lowerBound)
                    }

                    if first.lowerBound <= second.lowerBound, first.upperBound >= second.upperBound {
                        return true
                    }

                    return false
                }
            }
            .count

        printResult(dayPart: 1, message: "Number of overlapping pairs: \(fullyOverlapping)")
    }

    private func part2(elfPairs: [ElfPair]) {
        let overlappingSections = elfPairs
            .filter { elfPair in
                let (lhs, rhs) = (elfPair.lhs, elfPair.rhs)

                if lhs.isSingleSection, rhs.contains(lhs.lowerBound) {
                    return true
                } else if rhs.isSingleSection, lhs.contains(rhs.lowerBound) {
                    return true
                }

                return lhs.contains(where: { rhs.contains($0) })
            }
            .count

        printResult(dayPart: 2, message: "Number of overlapping sections: \(overlappingSections)")
    }
}

private extension Year2022.Day4 {
    typealias ElfPair = (lhs: ClosedRange<Int>, rhs: ClosedRange<Int>)
}

private extension ClosedRange where Element == Int {
    var isSingleSection: Bool {
        lowerBound == upperBound
    }
}
