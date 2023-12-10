import Foundation
import AppKit

private typealias Grid = [[Tile]]

extension Year2023.Day10: Runnable {
    func run(input: String) {
        let grid = splitInput(input).map { $0.compactMap(Tile.init(rawValue:)) }
        part1(grid: grid)
        part2(grid: grid)
    }

    private func part1(grid: Grid) {
        let loop = findLoop(grid: grid)
        printResult(dayPart: 1, message: "Animal is at step: \(loop.points.count / 2)")
    }

    private func part2(grid: Grid) {
        let loop = findLoop(grid: grid)
        var tilesWithinLoop = 0

        for yPos in 0 ..< grid.count {
            for xPos in 0 ..< grid[yPos].count {
                guard !loop.points.contains(Position(y: yPos, x: xPos)) else { continue }

                if loop.path.contains(NSPoint(x: xPos, y: yPos)) {
                    tilesWithinLoop += 1
                }
            }
        }

        printResult(dayPart: 2, message: "# of tiles within loop: \(tilesWithinLoop)")
    }

    private func findLoop(grid: Grid) -> Loop {
        guard let startPosition = grid.startPosition else { fatalError() }

        for startDirection in Direction.allCases {
            let loop = Loop()

            var dir = startDirection
            var pos = startPosition + startDirection.travelVector

            loop.path.move(to: NSPoint(x: startPosition.x, y: startPosition.y))

            guard grid.contains(pos) else { continue }

            while true {
                loop.add(pos)

                let tile = grid[pos.y][pos.x]
                if tile == .start { return loop }

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

private class Loop {
    var points: Set<Position>
    let path: NSBezierPath

    init() {
        points = []
        path = NSBezierPath()
    }

    func add(_ position: Position) {
        points.insert(position)
        path.line(to: NSPoint(x: position.x, y: position.y))
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
