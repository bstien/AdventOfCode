import Foundation

private typealias Grid = [[Tile]]

extension Year2023.Day10: Runnable {
    func run(input: String) {
        let grid = splitInput(input).map { $0.compactMap(Tile.init(rawValue:)) }
        part1(grid: grid)
    }

    private func part1(grid: Grid) {
        let loopPositions = findLoop(grid: grid)
        printResult(dayPart: 1, message: "Animal is at step: \(loopPositions.count / 2)")
    }

    private func findLoop(grid: Grid) -> Set<Position> {
        guard let startPosition = grid.startPosition else { fatalError() }

        for startDirection in Direction.allCases {
            var loopPositions = Set<Position>()
            
            var dir = startDirection
            var pos = startPosition + startDirection.travelVector
            
            guard grid.contains(pos) else { continue }

            while true {
                loopPositions.insert(pos)
                let tile = grid[pos.y][pos.x]
                if tile == .start { return loopPositions }

                guard let nextDir = nextDirection(tile: tile, direction: dir) else { break }
                dir = nextDir
                pos = pos + dir.travelVector
            }
        }

        fatalError("Could not find loop...!")
    }

    private func nextDirection(tile: Tile, direction: Direction) -> Direction? {
        if tile == .start { return direction }

        switch direction {
        case .north:
            if tile == .northSouthPipe { return direction }
            if tile == .southEastBend { return .east }
            if tile == .southWestBend { return .west }

            return nil
        case .east:
            if tile == .eastWestPipe { return direction }
            if tile == .northWestBend { return .north }
            if tile == .southWestBend { return .south }

            return nil
        case .west:
            if tile == .eastWestPipe { return direction }
            if tile == .northEastBend { return .north }
            if tile == .southEastBend { return .south }

            return nil
        case .south:
            if tile == .northSouthPipe { return direction }
            if tile == .northEastBend { return .east }
            if tile == .northWestBend { return .west }

            return nil
        }
    }
}

private struct Position: Hashable {
    let y: Int
    let x: Int

    static func +(lhs: Position, rhs: Position) -> Position {
        Position(y: lhs.y + rhs.y, x: lhs.x + rhs.x)
    }
}

private enum Direction: CaseIterable {
    case north
    case east
    case west
    case south

    var travelVector: Position {
        switch self {
        case .north: Position(y: -1, x: 0)
        case .east: Position(y: 0, x: 1)
        case .west: Position(y: 0, x: -1)
        case .south: Position(y: 1, x: 0)
        }
    }
}

private enum Tile: Character {
    case start = "S"
    case ground = "."

    case northSouthPipe = "|"
    case eastWestPipe = "-"

    case northWestBend = "J"
    case northEastBend = "L"
    case southWestBend = "7"
    case southEastBend = "F"
}

private extension Grid {
    var startPosition: Position? {
        for (yPos, _) in self.enumerated() {
            for (xPos, tile) in self[yPos].enumerated() {
                if tile == .start { return Position(y: yPos, x: xPos) }
            }
        }

        return nil
    }

    func contains(_ position: Position) -> Bool {
        indices.contains(position.y) && self[position.y].indices.contains(position.x)
    }
}
