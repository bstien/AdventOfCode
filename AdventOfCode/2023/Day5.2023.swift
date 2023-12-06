import Foundation

extension Year2023.Day5: Runnable {
    func run(input: String) {
        let seeds = parseSeeds(input: input)
        let sections = parseSections(input: input)
        part1(seeds: seeds, sections: sections)
    }

    private func part1(seeds: [Int], sections: [Section]) {
        var minLocation = Int.max

        for seed in seeds {
            var location = seed
            for section in sections {
                for map in section.maps {
                    if map.sourceRange.contains(location) {
                        location = map.destinationStart + (location - map.sourceStart)
                        break
                    }
                }
            }

            if location < minLocation {
                minLocation = location
            }
        }

        printResult(dayPart: 1, message: "Min location: \(minLocation)")
    }

    private func parseSeeds(input: String) -> [Int] {
        let firstLine = splitInput(input)[0]
        return splitInput(firstLine, separatedBy: " ").compactMap(\.toInt)
    }

    private func parseSections(input: String) -> [Section] {
        let sections = splitInput(input, separatedBy: "\n\n")[1...]
        return sections.map { section in
            let lines = splitInput(section)[1...]

            let maps = lines
                .map { splitInput($0, separatedBy: " ").compactMap(\.toInt) }
                .map { Map(destinationStart: $0[0], sourceStart: $0[1], rangeLength: $0[2]) }

            return Section(maps: maps)
        }
    }
}

private struct Section {
    let maps: [Map]
}

private struct Map {
    let destinationRange: ClosedRange<Int>
    let sourceRange: ClosedRange<Int>
    let destinationStart: Int
    let sourceStart: Int
    let rangeLength: Int

    init(destinationStart: Int, sourceStart: Int, rangeLength: Int) {
        self.destinationStart = destinationStart
        self.sourceStart = sourceStart
        self.rangeLength = rangeLength
        self.destinationRange = (destinationStart...destinationStart+(rangeLength - 1))
        self.sourceRange = (sourceStart...sourceStart+(rangeLength - 1))
    }
}
