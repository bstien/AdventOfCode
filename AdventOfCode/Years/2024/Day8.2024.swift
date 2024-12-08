import Foundation

extension Year2024.Day8: Runnable {
    func run(input: String) {
        let grid = splitInput(input).map(Array.init)
        let antennaMap = parseAntennaMap(from: grid)

        part1(grid: grid, antennaMap: antennaMap)
    }

    private func part1(grid: [[Character]], antennaMap: [Character: [Position]]) {
        var antinodes = Set<Position>()
        for antennaKind in antennaMap.keys {
            guard let antennaPositions = antennaMap[antennaKind] else { continue }
            for antennaPosition in antennaPositions {
                for otherAntenna in antennaPositions {
                    if antennaPosition == otherAntenna { continue }
                    
                    let diff = antennaPosition.diff(to: otherAntenna)
                    antinodes.insert(antennaPosition + diff)
                    antinodes.insert(otherAntenna - diff)
                }
            }
        }

        let antinodeCount = antinodes.filter { grid.isInBounds($0) }.count
        printResult(dayPart: 1, message: "# of antinodes: \(antinodeCount)")
    }

    private func parseAntennaMap(from grid: [[Character]]) -> [Character: [Position]] {
        var antennaMap: [Character: [Position]] = [:]

        for y in grid.indices {
            for x in grid[y].indices {
                let character = grid[y][x]
                if character == "." { continue }

                var list = antennaMap[character, default: []]
                list.append(Position(y: y, x: x))
                antennaMap[character] = list
            }
        }

        return antennaMap
    }
}

private struct Position: Hashable {
    let y: Int
    let x: Int

    func diff(to other: Position) -> Position {
        Position(y: y - other.y, x: x - other.x)
    }

    static func +(lhs: Position, rhs: Position) -> Position {
        Position(y: lhs.y + rhs.y, x: lhs.x + rhs.x)
    }

    static func -(lhs: Position, rhs: Position) -> Position {
        Position(y: lhs.y - rhs.y, x: lhs.x - rhs.x)
    }
}

private extension [[Character]] {
    func isInBounds(_ position: Position) -> Bool {
        indices.contains(position.y) && self[position.y].indices.contains(position.x)
    }
}
