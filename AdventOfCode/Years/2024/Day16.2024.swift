import Foundation

extension Year2024.Day16: Runnable {
    func run(input: String) {
        let (start, end, map) = parseMap(input)

        part1(start: start, end: end, map: map)
    }

    private func part1(start: Position, end: Position, map: Set<Position>) {
        var cache = [Position: (Int, Int)]()

        func traverse(
            position: Position,
            direction: Direction,
            end: Position,
            map: Set<Position>,
            visited: Set<Position> = [],
            numberOfTurns: Int = 0
        ) -> [MapResult] {
            if visited.contains(position) { return [] }
            if position == end { return [MapResult(steps: visited, numberOfTurns: numberOfTurns)] }

            var visited = visited
            visited.insert(position)

            // Don't continue if a cheaper path has visited this same position.
            if let cachedCount = cache[position], cachedCount.0 <= visited.count, cachedCount.1 <= numberOfTurns {
                return []
            } else {
                cache[position] = (visited.count, numberOfTurns)
            }

            let availablePaths = map.paths(from: position, direction: direction)
            return availablePaths.flatMap {
                traverse(
                    position: $0.0,
                    direction: $0.1,
                    end: end,
                    map: map,
                    visited: visited,
                    numberOfTurns: numberOfTurns + ($0.1 == direction ? 0 : 1)
                )
            }
        }

        let results = traverse(position: start, direction: .east, end: end, map: map, visited: [])
        let minSteps = results.map { $0.steps.count + ($0.numberOfTurns * 1000) }.min()
        guard let minSteps else {
            printResult(result: .fail, dayPart: 1, message: "Could not get min number of steps")
            return
        }

        printResult(dayPart: 1, message: "Min # of steps: \(minSteps)")
    }

    private func parseMap(_ input: String) -> (start: Position, end: Position, map: Set<Position>) {
        let lines = splitInput(input).map(Array.init)
        var start: Position?
        var end: Position?
        var map = Set<Position>()

        for y in lines.indices {
            for x in lines[y].indices {
                switch lines[y][x] {
                case "S": start = Position(y: y, x: x)
                case "E": end = Position(y: y, x: x)
                case "#": map.insert(Position(y: y, x: x))
                default: break
                }
            }
        }

        guard let start, let end else { fatalError("Could not find start and/or end") }
        return (start, end, map)
    }
}

private extension Set where Element == Position {
    func paths(from position: Position, direction: Direction) -> [(Position, Direction)] {
        [direction, direction.turnLeft, direction.turnRight].compactMap {
            guard !contains(position + $0) else { return nil }
            return (position + $0, $0)
        }
    }
}

private struct MapResult {
    let steps: Set<Position>
    let numberOfTurns: Int
}

private struct Position: Hashable, CustomStringConvertible {
    let y: Int
    let x: Int

    var description: String {
        "(y: \(y),x: \(x))"
    }

    static func +(lhs: Position, rhs: Vector) -> Position {
        Position(y: lhs.y + rhs.y, x: lhs.x + rhs.x)
    }

    static func +(lhs: Position, rhs: Direction) -> Position {
        lhs + rhs.vector
    }
}

private struct Vector: Hashable {
    let y: Int
    let x: Int
}

private enum Direction: Hashable {
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

    var turnRight: Direction {
        switch self {
        case .north: .east
        case .east: .south
        case .south: .west
        case .west: .north
        }
    }

    var turnLeft: Direction {
        switch self {
        case .north: .west
        case .east: .north
        case .south: .east
        case .west: .south
        }
    }
}
