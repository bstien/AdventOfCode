import Foundation

extension Year2024.Day12: Runnable {
    func run(input: String) {
        let map = splitInput(input).map(Array.init)
        part1(map: map)
    }

    private func part1(map: [[Character]]) {
        var characterPositions = [Character: Set<Position>]()
        var gardens = [Character: [Set<Position>]]()

        for y in map.indices {
            for x in map[y].indices {
                characterPositions[map[y][x], default: []].insert(Position(y: y, x: x))
            }
        }

        for character in characterPositions {
            var positions = character.value
            repeat {
                let position = positions.removeFirst()
                let garden = positions.findGarden(from: position)
                positions.subtract(garden)
                gardens[character.key, default: []].append(garden)
            } while positions.count > 0
        }

        var fenceCost = 0
        for character in gardens {
            for garden in character.value {
                let edges = garden.map { position in
                    Direction.allCases.reduce(0, { $0 + (map.get(position + $1) != character.key ? 1 : 0) })
                }.sum
                fenceCost += edges * garden.count
            }
        }

        printResult(dayPart: 1, message: "Fence cost: \(fenceCost)")
    }
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
}

extension Set where Element == Position {
    func containsNeighbors(of position: Position) -> Bool {
        Direction.allCases.contains { direction in
            self.contains(position + direction)
        }
    }

    func findGarden(from position: Position) -> Set<Position> {
        var visitedPositions: Set<Position> = [position]

        func traverse(from position: Position) -> Set<Position> {
            let neighbors = Direction.allCases.reduce(into: Set<Position>()) { set, direction in
                let nextPosition = position + direction
                if !visitedPositions.contains(nextPosition), contains(nextPosition) {
                    set.insert(nextPosition)
                }
            }
            visitedPositions.formUnion(neighbors)

            return neighbors
                .map { traverse(from: $0) }
                .reduce(into: Set<Position>()) { $0.formUnion($1) }
                .union([position])
        }

        return traverse(from: position)
    }
}

private extension [[Character]] {
    func get(_ position: Position) -> Character? {
        guard isInBounds(position) else { return nil }
        return self[position.y][position.x]
    }

    func isInBounds(_ position: Position) -> Bool {
        position.y >= 0 &&
        position.x >= 0 &&
        position.y < count &&
        position.x < self[position.y].count
    }

    func find(_ value: Character, around position: Position) -> Set<Position> {
        Direction.allCases.reduce(into: Set<Position>()) { set, direction in
            let nextPosition = position + direction
            guard get(nextPosition) == value else { return }
            set.insert(nextPosition)
        }
    }
}
