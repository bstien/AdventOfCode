import Foundation

extension Year2024.Day6: Runnable {
    func run(input: String) {
        let grid = splitInput(input).map { Array($0) }
        let startPosition = grid.findStart()
        let visitedPositions = traverse(grid: grid, startPosition: startPosition, startDirection: .north)

        part1(visitedPositions: visitedPositions)
        part2(grid: grid, startPosition: startPosition, visitedPositions: visitedPositions)
    }

    private func part1(visitedPositions: Set<Position>) {
        printResult(dayPart: 1, message: "Visited positions: \(visitedPositions.count)")
    }

    private func part2(grid: [[Character]], startPosition: Position, visitedPositions: Set<Position>) {
        var obstaclePositions = Set<Position>()
        var visitedPositions = visitedPositions
        visitedPositions.remove(startPosition)

        for potentialObstaclePosition in visitedPositions {
            var modifiedGrid = grid
            modifiedGrid[potentialObstaclePosition.y][potentialObstaclePosition.x] = "#"
            var visitedObstacles = Set<VisitedObstacle>()

            traverse(
                grid: modifiedGrid,
                startPosition: startPosition,
                startDirection: .north,
                didHitObstacle: { obstaclePosition, direction in
                    let obstacle = VisitedObstacle(obstaclePosition, direction)

                    if visitedObstacles.contains(obstacle) {
                        obstaclePositions.insert(potentialObstaclePosition)
                        return true
                    } else {
                        visitedObstacles.insert(obstacle)
                        return false
                    }
                },
                didVisit: { _, _ in return false }
            )
        }

        printResult(dayPart: 2, message: "Number of obstacles: \(obstaclePositions.count)")
    }

    private func traverse(
        grid: [[Character]],
        startPosition: Position,
        startDirection: Direction
    ) -> Set<Position> {
        var visitedPositions: Set<Position> = [startPosition]
        traverse(
            grid: grid,
            startPosition: startPosition,
            startDirection: startDirection,
            didVisit: { position, _ in
                visitedPositions.insert(position)
                return false
            }
        )

        return visitedPositions
    }

    private func traverse(
        grid: [[Character]],
        startPosition: Position,
        startDirection: Direction,
        didHitObstacle: (Position, Direction) -> Bool = { _, _ in false },
        didVisit: (Position, Direction) -> Bool = { _, _ in false }
    ) {
        var position = startPosition
        var direction = startDirection
        var isInBounds = true

        repeat {
            let nextPosition = position + direction.vector
            isInBounds = grid.isInBounds(nextPosition)
            if isInBounds {
                if grid[nextPosition.y][nextPosition.x] == "#" {
                    if didHitObstacle(nextPosition, direction) {
                        break
                    }
                    direction.turnRight()
                } else {
                    position = nextPosition
                    if didVisit(position, direction) {
                        break
                    }
                }
            }
        } while isInBounds
    }
}

private enum Direction: CaseIterable, Hashable {
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

private struct VisitedObstacle: Hashable {
    let position: Position
    let direction: Direction

    init(_ position: Position, _ direction: Direction) {
        self.position = position
        self.direction = direction
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

    static func -(lhs: Position, rhs: Vector) -> Position {
        Position(y: lhs.y - rhs.y, x: lhs.x - rhs.x)
    }

    static func -(lhs: Position, rhs: Direction) -> Position {
        lhs - rhs.vector
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

private extension [Character] {
    func positions(of character: Character, yPos: Int) -> [Position] {
        enumerated().compactMap { $0.element == character ? Position(y: yPos, x: $0.offset) : nil }
    }
}
