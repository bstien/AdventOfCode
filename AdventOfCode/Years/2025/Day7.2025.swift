import Foundation

extension Year2025.Day7: Runnable {
    func run(input: String) {
        let lines = splitInput(input)

        guard let start = Array(lines[0]).firstIndex(of: "S") else {
            fatalError("Could not find starting position")
        }

        let splitters = lines.map { line in
            line.enumerated().compactMap { index, char in
                if char == "^" {
                    return index
                }
                return nil
            }
        }

        let part1Sum = part1(start: start, splitters: splitters)
        printResult(dayPart: 1, message: "# of splits: \(part1Sum)")
    }

    private func part1(start: Int, splitters: [[Int]]) -> Int {
        var numberOfSplits = 0
        var beams: Set = [start]

        for line in splitters {
            let set = Set(line)

            let intersection = beams.intersection(set)

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
}
