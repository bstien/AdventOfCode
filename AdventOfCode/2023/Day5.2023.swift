import Foundation

extension Year2023.Day5: Runnable {
    func run(input: String) {
        let sections = parseSections(input: input)

        let seeds = parseSeeds(input: input)
        part1(seeds: seeds, sections: sections)

        let seedRanges = createSeedRanges(seeds: seeds)
        part2(seedRanges: seedRanges, sections: sections)
    }

    private func part1(seeds: [Int], sections: [Section]) {
        var minLocation = Int.max

        for seed in seeds {
            let location = getEndLocation(seed: seed, sections: sections)

            if location < minLocation {
                minLocation = location
            }
        }

        printResult(dayPart: 1, message: "Min location: \(minLocation)")
    }

    private func part2(seedRanges: [SeedRange], sections: [Section]) {
        var minLocation = Int.max
        let sectionsReversed = Array(sections.reversed())

        for endLocation in (0 ... Int.max) {
            var location = endLocation

            for section in sectionsReversed {
                for map in section.maps {
                    if map.destinationRange.contains(location) {
                        location = map.sourceStart + (location - map.destinationStart)
                        break
                    }
                }
            }

            if seedRanges.contains(where: { $0.contains(location) }) {
                minLocation = endLocation
                break
            }
        }

        printResult(dayPart: 2, message: "Min location: \(minLocation)")
    }

    private func getEndLocation(seed: Int, sections: [Section]) -> Int {
        var location = seed
        for section in sections {
            for map in section.maps {
                if map.sourceRange.contains(location) {
                    location = map.destinationStart + (location - map.sourceStart)
                    break
                }
            }
        }

        return location
    }

    private func parseSeeds(input: String) -> [Int] {
        let firstLine = splitInput(input)[0]
        return splitInput(firstLine, separatedBy: " ").compactMap(\.toInt)
    }

    private func createSeedRanges(seeds: [Int]) -> [SeedRange] {
        seeds.chunks(ofCount: 2).map {
            // God damn array slices.
            ($0[$0.startIndex] ... $0[$0.startIndex] + ($0[$0.endIndex - 1] - 1))
        }
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

private typealias SeedRange = ClosedRange<Int>

private struct Section {
    let maps: [Map]
}

private struct Map {
    let destinationStart: Int
    let destinationRange: ClosedRange<Int>
    let sourceStart: Int
    let sourceRange: ClosedRange<Int>

    init(destinationStart: Int, sourceStart: Int, rangeLength: Int) {
        self.destinationStart = destinationStart
        self.destinationRange = (destinationStart...destinationStart+(rangeLength - 1))
        self.sourceStart = sourceStart
        self.sourceRange = (sourceStart...sourceStart+(rangeLength - 1))
    }
}
