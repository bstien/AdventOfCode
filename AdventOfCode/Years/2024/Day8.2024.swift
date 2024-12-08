import Foundation

extension Year2024.Day8: Runnable {
    func run(input: String) {
        let grid = splitInput(input).map(Array.init)
        let antennaMap = parseAntennaMap(from: grid)

        part1(grid: grid, antennaMap: antennaMap)
        part2(grid: grid, antennaMap: antennaMap)
    }

    private func part1(grid: [[Character]], antennaMap: [Character: [Position]]) {
        var antinodes = Set<Position>()
        var seenAntennaPairs = [Position: Set<Position>]()

        for antennaKind in antennaMap.keys {
            guard let antennaPositions = antennaMap[antennaKind] else { continue }
            for antenna in antennaPositions {
                for otherAntenna in antennaPositions {
                    guard antenna != otherAntenna, !(seenAntennaPairs[antenna]?.contains(otherAntenna) ?? false) else {
                        continue
                    }

                    seenAntennaPairs[antenna, default: []].insert(otherAntenna)
                    seenAntennaPairs[otherAntenna, default: []].insert(antenna)

                    let diff = antenna.diff(to: otherAntenna)
                    antinodes.insert(antenna + diff)
                    antinodes.insert(otherAntenna - diff)
                }
            }
        }

        let antinodeCount = antinodes.filter { grid.isInBounds($0) }.count
        printResult(dayPart: 1, message: "# of antinodes: \(antinodeCount)")
    }

    private func part2(grid: [[Character]], antennaMap: [Character: [Position]]) {
        var antinodes = Set<Position>()
        var seenAntennaPairs = [Position: Set<Position>]()

        for antennaKind in antennaMap.keys {
            guard let antennaPositions = antennaMap[antennaKind] else { continue }
            for antenna in antennaPositions {
                for otherAntenna in antennaPositions {
                    guard antenna != otherAntenna, !(seenAntennaPairs[antenna]?.contains(otherAntenna) ?? false) else {
                        continue
                    }

                    seenAntennaPairs[antenna, default: []].insert(otherAntenna)
                    seenAntennaPairs[otherAntenna, default: []].insert(antenna)

                    let diff = antenna.diff(to: otherAntenna)
                    antinodes.formUnion(findAntinodes(from: antenna, grid: grid, diff: diff, operator: +))
                    antinodes.formUnion(findAntinodes(from: otherAntenna, grid: grid, diff: diff, operator: -))
                }
            }
        }

        printResult(dayPart: 2, message: "# of antinodes: \(antinodes.count)")
    }

    private func findAntinodes(
        from position: Position,
        grid: [[Character]],
        diff: Position,
        operator: (Position, Position) -> Position
    ) -> Set<Position> {
        guard grid.isInBounds(position) else { return [] }
        let antinodes = findAntinodes(from: `operator`(position, diff), grid: grid, diff: diff, operator: `operator`)
        return Set([position]).union(antinodes)
    }

    private func parseAntennaMap(from grid: [[Character]]) -> [Character: [Position]] {
        var antennaMap: [Character: [Position]] = [:]

        for y in grid.indices {
            for x in grid[y].indices {
                let character = grid[y][x]
                if character == "." { continue }
                antennaMap[character, default: []].append(Position(y: y, x: x))
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
