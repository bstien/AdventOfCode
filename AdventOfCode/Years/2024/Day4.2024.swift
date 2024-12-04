import Foundation

extension Year2024.Day4: Runnable {
    func run(input: String) {
        let grid = splitInput(input).map { Array($0) }
        part1(grid: grid)
    }

    private func part1(grid: [[Character]]) {
        let xPositions: [Position] = grid.enumerated().flatMap { yPos, line in
            line.enumerated().filter { $0.element == "X" }.map { Position(y: yPos, x: $0.offset) }
        }

        let count = xPositions.reduce(0) { count, position in
            count + Direction.allCases.filter {
                search(from: position + $0, in: grid, needle: Array("XMAS"), direction: $0, index: 1)
            }.count
        }
        printResult(dayPart: 1, message: "Count: \(count)")
    }

}

private extension [[Character]] {
    func get(_ position: Position) -> Character? {
        guard
            self.indices.contains(position.y),
            self[position.y].indices.contains(position.x)
        else { return nil }

        return self[position.y][position.x]
    }
}

private enum Direction: CaseIterable {
    case north
    case northEast
    case northWest
    case east
    case west
    case south
    case southEast
    case southWest

    var vector: Vector {
        switch self {
        case .north: Vector(y: -1, x: 0)
        case .northEast: Vector(y: -1, x: 1)
        case .northWest: Vector(y: -1, x: -1)
        case .east: Vector(y: 0, x: 1)
        case .west: Vector(y: 0, x: -1)
        case .south: Vector(y: 1, x: 0)
        case .southEast: Vector(y: 1, x: 1)
        case .southWest: Vector(y: 1, x: -1)
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
