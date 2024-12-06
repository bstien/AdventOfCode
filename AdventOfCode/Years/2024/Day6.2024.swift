import Foundation

extension Year2024.Day6: Runnable {
    func run(input: String) {
        let grid = splitInput(input).map { Array($0) }
        let startPosition = grid.findStart()
        let visitedPositions = traverse(grid: grid, startPosition: startPosition)

        part1(visitedPositions: visitedPositions)
    }

    private func part1(visitedPositions: Set<Position>) {
        printResult(dayPart: 1, message: "Visited positions: \(visitedPositions.count)")
    }

    private func traverse(
        grid: [[Character]],
        startPosition: Position
    ) -> Set<Position> {
        var visitedPositions: Set<Position> = [startPosition]
        var position = startPosition
        var direction = Direction.north
        var isInBounds = true

        repeat {
            let nextPosition = position + direction.vector
            isInBounds = grid.isInBounds(nextPosition)
            if isInBounds {
                if grid[nextPosition.y][nextPosition.x] == "#" {
                    direction.turnRight()
                } else {
                    position = nextPosition
                    visitedPositions.insert(position)
                }
            }
        } while isInBounds

        return visitedPositions
    }
}

private enum Direction: CaseIterable {
    case north
    case east
    case west
    case south

    var vector: Vector {
        switch self {
        case .north: Vector(y: -1, x: 0)
        case .east: Vector(y: 0, x: 1)
        case .west: Vector(y: 0, x: -1)
        case .south: Vector(y: 1, x: 0)
        }
    }

    mutating func turnRight() {
        switch self {
        case .north: self = .east
        case .east: self = .south
        case .south: self = .west
        case .west: self = .north
        }
    }
}

private struct Vector: Hashable {
    let y: Int
    let x: Int
}

private struct Position: Hashable {
    let y: Int
    let x: Int

    static func +(lhs: Position, rhs: Vector) -> Position {
        Position(y: lhs.y + rhs.y, x: lhs.x + rhs.x)
    }

    static func +(lhs: Position, rhs: Direction) -> Position {
        lhs + rhs.vector
    }
}

private extension [[Character]] {
    func findStart() -> Position {
        for row in self.enumerated() {
            if let index = row.element.firstIndex(of: "^") {
                return Position(y: row.offset, x: index)
            }
        }
        fatalError("Could not find start!")
    }

    func isInBounds(_ position: Position) -> Bool {
        self.indices.contains(position.y) && self[position.y].indices.contains(position.x)
    }
}
