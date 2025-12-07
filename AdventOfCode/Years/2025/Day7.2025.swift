import Foundation

extension Year2025.Day7: Runnable {
    func run(input: String) {
        let lines = splitInput(input)

        guard let start = Array(lines[0]).firstIndex(of: "S") else {
            fatalError("Could not find starting position")
        }

        let splitters = lines.map { line in
            let array = line.enumerated().compactMap { index, char in
                if char == "^" {
                    return index
                }
                return nil
            }

            return Set(array)
        }

        let part1Sum = part1(start: start, splitters: splitters)
        printResult(dayPart: 1, message: "# of splits: \(part1Sum)")

        var cache = [Int: [Int: Int]]()
        let part2Sum = part2(column: start, row: 1, cache: &cache, splitters: splitters)
        printResult(dayPart: 2, message: "# of splits: \(part2Sum)")
    }

    private func part1(start: Int, splitters: [Set<Int>]) -> Int {
        var numberOfSplits = 0
        var beams: Set = [start]

        for line in splitters {
            let intersection = beams.intersection(line)

            numberOfSplits += intersection.count

            var newBeams = beams.subtracting(intersection)

            for split in intersection {
                newBeams.insert(split - 1)
                newBeams.insert(split + 1)
            }
            
            beams = newBeams
        }

        return numberOfSplits
    }

    private func part2(column: Int, row: Int, cache: inout [Int: [Int: Int]], splitters: [Set<Int>]) -> Int {
        if row == splitters.count - 1 { return 1 }

        if let count = cache[row]?[column] {
            return count
        }

        if splitters[row].contains(column) {
            let leftCount = part2(column: column - 1, row: row + 1, cache: &cache, splitters: splitters)
            let rightCount = part2(column: column + 1, row: row + 1, cache: &cache, splitters: splitters)

            let count = leftCount + rightCount
            cache[row, default: [:]][column] = count
            return count
        }

        return part2(column: column, row: row + 1, cache: &cache, splitters: splitters)
    }
}
