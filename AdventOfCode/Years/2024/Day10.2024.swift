import Foundation

extension Year2024.Day10: Runnable {
    func run(input: String) {
        let map = splitInput(input).map { Array($0).map(String.init).compactMap(Int.init) }

        part1(map: map)
        part2(map: map)
    }

    private func part1(map: [[Int]]) {
        let trailheads = map.trailheads
        let paths = trailheads
            .map { traverse(map, from: $0, nextNeedle: 1) }
            .reduce(0) { $0 + $1.count }

        printResult(dayPart: 1, message: "Complete paths: \(paths)")
    }

    private func part2(map: [[Int]]) {
        let trailheads = map.trailheads
        let paths = trailheads
            .map { traversePart2(map, from: $0, nextNeedle: 1) }
            .reduce(0, +)

        printResult(dayPart: 2, message: "Complete paths: \(paths)")
    }
    
    /// Traverse until we find a 9 and return a set of seen 9s.
    private func traverse(
        _ map: [[Int]],
        from position: Position,
        nextNeedle needle: Int
    ) -> Set<Position> {
        let surroundingPaths = map.find(needle, around: position)
        if needle == 9 { return surroundingPaths }
        return surroundingPaths
            .map { traverse(map, from: $0, nextNeedle: needle + 1) }
            .reduce(into: Set(), { $0.formUnion($1) })
    }

    /// Traverse until we find a 9 and return the count of seen 9s.
    private func traversePart2(
        _ map: [[Int]],
        from position: Position,
        nextNeedle needle: Int
    ) -> Int {
        let surroundingPaths = map.find(needle, around: position)
        if needle == 9 { return surroundingPaths.count }
        return surroundingPaths
            .map { traversePart2(map, from: $0, nextNeedle: needle + 1) }
            .reduce(0, +)
    }
}

private extension [[Int]] {
    var trailheads: Set<Position> {
        var trailheads = Set<Position>()
        for y in indices {
            for x in self[y].indices {
                if self[y][x] == 0 {
                    trailheads.insert(Position(y: y, x: x))
                }
            }
        }
        return trailheads
    }

    func get(_ position: Position) -> Int? {
        guard isInBounds(position) else { return nil }
        return self[position.y][position.x]
    }

    func isInBounds(_ position: Position) -> Bool {
        position.y >= 0 &&
        position.x >= 0 &&
        position.y < count &&
        position.x < self[position.y].count
    }

    func find(_ value: Int, around position: Position) -> Set<Position> {
        Direction.allCases.reduce(into: Set()) { set, direction in
            let nextPosition = position + direction
            guard get(nextPosition) == value else { return }
            set.insert(nextPosition)
        }
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

    static func -(lhs: Position, rhs: Vector) -> Position {
        Position(y: lhs.y - rhs.y, x: lhs.x - rhs.x)
    }

    static func -(lhs: Position, rhs: Direction) -> Position {
        lhs - rhs.vector
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
