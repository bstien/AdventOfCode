import Foundation
import AppKit

private typealias Grid = [[Tile]]

extension Year2023.Day10: Runnable {
    func run(input: String) {
        let grid = splitInput(input).map { $0.compactMap(Tile.init(rawValue:)) }
        let loop = findLoop(grid: grid)

        part1(loop: loop)
        part2(loop: loop, grid: grid)
    }

    private func part1(loop: Loop) {
        printResult(dayPart: 1, message: "Animal is at step: \(loop.points.count / 2)")
    }

    private func part2(loop: Loop, grid: Grid) {
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
            var dir = startDirection
            var pos = startPosition + startDirection.travelVector
            let loop = Loop(startPosition: startPosition)

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
        switch (direction, tile) {
        case (_, .start): direction
        
        case (.north, .northSouthPipe): direction
        case (.north, .southEastBend): .east
        case (.north, .southWestBend): .west

        case (.east, .eastWestPipe): direction
        case (.east, .northWestBend): .north
        case (.east, .southWestBend): .south

        case (.west, .eastWestPipe): direction
        case (.west, .northEastBend): .north
        case (.west, .southEastBend): .south

        case (.south, .northSouthPipe): direction
        case (.south, .northEastBend): .east
        case (.south, .northWestBend): .west

        default: nil
        }
    }
}

private class Loop {
    var points: Set<Position>
    let path: NSBezierPath

    init(startPosition: Position) {
        points = []
        path = NSBezierPath()
        path.move(to: startPosition.toPoint)
    }

    func add(_ position: Position) {
        points.insert(position)
        path.line(to: position.toPoint)
    }
}

private struct Position: Hashable {
    let y: Int
    let x: Int
    var toPoint: NSPoint { NSPoint(x: x, y: y) }

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
}
