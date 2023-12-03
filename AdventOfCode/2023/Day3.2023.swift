import Foundation

extension Year2023.Day3: Runnable {
    private static let validNumbers = Array(0...9).map(String.init)

    func run(input: String) {
        let grid = splitInput(input)
        let schematic = parseSchematic(grid: grid)

        part1(schematic: schematic)
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

private struct PartNumber {
    let value: Int
    let location: Location
    let length: Int
}
