import Foundation

extension Year2023.Day3: Runnable {
    private static let validNumbers = Array(0...9).map(String.init)

    func run(input: String) {
        let grid = splitInput(input)
        let schematic = parseSchematic(grid: grid)

        part1(schematic: schematic)
        part2(schematic: schematic, grid: grid)
    }

    private func part1(schematic: Schematic) {
        let validParts = schematic.partNumbers.filter {
            for y in (-1...1) {
                for x in (-1...($0.length)) {
                    if y == 0, x >= 0, x < $0.length {
                        continue
                    }
                    
                    if schematic.symbolLocations.contains(Location(x: $0.location.x + x, y: $0.location.y + y)) {
                        return true
                    }
                }
            }
            return false
        }

        let partSum = validParts.reduce(0, { $0 + $1.value })
        printResult(dayPart: 1, message: "Part sum: \(partSum)")
    }

    private func part2(schematic: Schematic, grid: [String]) {
        let gearRatios = schematic.symbolLocations.compactMap { symbolLocation -> Int? in
            guard grid[symbolLocation.y][symbolLocation.x] == "*" else { return nil }
            
            var adjacentPartNumbers = Set<PartNumber>()

            for y in (-1...1) {
                let absoluteY = symbolLocation.y + y
                if absoluteY < 0 { continue }

                let potentialPartNumbers = schematic.partNumbers.filter { $0.location.y == absoluteY }

                for x in (-1...1) {
                    let absoluteX = symbolLocation.x + x
                    if (y == 0 && x == 0) || absoluteX < 0 {
                        continue
                    }

                    potentialPartNumbers.forEach {
                        if $0.locationRange.contains(absoluteX) {
                            adjacentPartNumbers.insert($0)
                        }
                    }
                }

                // Early return, if we have more than we need.
                if adjacentPartNumbers.count > 2 { return nil }
            }

            guard adjacentPartNumbers.count == 2 else { return nil }

            return adjacentPartNumbers.map(\.value).reduce(1, *)
        }.reduce(0, +)

        printResult(dayPart: 2, message: "Gear ratio total: \(gearRatios)")
    }

    private func parseSchematic(grid: [String]) -> Schematic {
        var symbolLocations = Set<Location>()
        var partNumbers = [PartNumber]()

        var y = 0
        var x = 0

        while y < grid.count {
            while x < grid[y].count {
                let character = grid[y][x]
                
                if Self.validNumbers.contains(character) {
                    let partNumber = readPartNumber(line: grid[y], location: Location(x: x, y: y))
                    partNumbers.append(partNumber)
                    x += partNumber.length
                } else if character != "." {
                    symbolLocations.insert(Location(x: x, y: y))
                    x += 1
                } else {
                    x += 1
                }
            }
            x = 0
            y += 1
        }

        return Schematic(symbolLocations: symbolLocations, partNumbers: partNumbers)
    }

    private func readPartNumber(line: String, location: Location) -> PartNumber {
        var numbers = [String]()
        
        var index = location.x
        while(index < line.count) {
            let character = line[index]

            guard Self.validNumbers.contains(character) else { break }
            index += 1
            numbers.append(character)
        }

        guard let intValue = Int(numbers.joined(separator: "")) else {
            fatalError("Could not map found numbers to Int: \(numbers)")
        }

        return PartNumber(value: intValue, location: location, length: index - location.x)
    }
}

private struct Location: Hashable {
    let x: Int
    let y: Int
}

private struct Schematic {
    let symbolLocations: Set<Location>
    let partNumbers: [PartNumber]
}

private struct PartNumber: Hashable {
    let value: Int
    let location: Location
    let length: Int

    var locationRange: ClosedRange<Int> {
        location.x...location.x + (length - 1)
    }
}
