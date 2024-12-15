import Foundation

extension Year2024.Day15: Runnable {
    func run(input: String) {
        let sections = splitInput(input, separatedBy: "\n\n")
        let moves = parseMoves(sections[1])

        part1(mapSection: sections[0], moves: moves)
        part2(mapSection: sections[0], moves: moves)
    }

    private func part1(mapSection: String, moves: [Move]) {
        var map = parseMap(mapSection, obstacleSize: .single)
        var position = startPosition(mapSection, doubleWidth: false)

        for move in moves {
            switch tryMovePart1(from: position, move: move, map: map) {
            case .cantMove:
                break
            case .moveBoxes(let boxesToMove):
                position = position + move
                map = map.subtracting(boxesToMove)
                boxesToMove.forEach {
                    var box = $0
                    box.position = box.position + move
                    map.insert(box)
                }
            }
        }

        let sum = map.filter { $0.kind == .box }.reduce(0) {
            $0 + ($1.position.y * 100) + $1.position.x
        }

        printResult(dayPart: 1, message: "Sum: \(sum)")
    }

    private func part2(mapSection: String, moves: [Move]) {
        var map = parseMap(mapSection, obstacleSize: .double)
        var position = startPosition(mapSection, doubleWidth: true)

        for move in moves {
            switch tryMovePart2(from: position, move: move, map: map) {
            case .cantMove:
                break
            case .moveBoxes(let boxesToMove):
                position = position + move
                map = map.subtracting(boxesToMove)
                boxesToMove.forEach {
                    var box = $0
                    box.position = box.position + move
                    map.insert(box)
                }
            }
        }

        let sum = map.filter { $0.kind == .box }.reduce(0) {
            $0 + ($1.position.y * 100) + $1.position.x
        }

        printResult(dayPart: 2, message: "Sum: \(sum)")
    }

    private func tryMovePart1(
        from position: Position,
        move: Move,
        map: Set<Obstacle>,
        boxesToMove: Set<Obstacle> = []
    ) -> MoveResult {
        let nextPosition = position + move
        if let obstacle = map.first(where: { $0.isHit(nextPosition) }) {
            switch obstacle.kind {
            case .wall:
                return .cantMove
            case .box:
                return tryMovePart1(
                    from: obstacle.position,
                    move: move,
                    map: map,
                    boxesToMove: boxesToMove.union([obstacle])
                )
            }
        } else {
            return .moveBoxes(boxesToMove)
        }
    }

    private func tryMovePart2(
        from position: Position,
        move: Move,
        map: Set<Obstacle>,
        boxesToMove: Set<Obstacle> = []
    ) -> MoveResult {
        let nextPosition = position + move
        if let obstacle = map.first(where: { $0.isHit(nextPosition) }) {
            switch obstacle.kind {
            case .wall:
                return .cantMove
            case .box:
                switch move {
                case .south, .north:
                    let r1 = tryMovePart2(
                        from: obstacle.position,
                        move: move,
                        map: map,
                        boxesToMove: boxesToMove.union([obstacle])
                    )
                    let r2 = tryMovePart2(
                        from: obstacle.rightHalf,
                        move: move,
                        map: map,
                        boxesToMove: boxesToMove.union([obstacle])
                    )

                    switch (r1, r2) {
                    case (.moveBoxes(let lhs), .moveBoxes(let rhs)):
                        return .moveBoxes(lhs.union(rhs))
                    default:
                        return .cantMove
                    }
                case .west:
                    return tryMovePart2(
                        from: obstacle.position,
                        move: move,
                        map: map,
                        boxesToMove: boxesToMove.union([obstacle])
                    )
                case .east:
                    return tryMovePart2(
                        from: obstacle.rightHalf,
                        move: move,
                        map: map,
                        boxesToMove: boxesToMove.union([obstacle])
                    )
                }
            }
        } else {
            return .moveBoxes(boxesToMove)
        }
    }

    private func parseMap(_ input: String, obstacleSize: Obstacle.Size) -> Set<Obstacle> {
        var obstacles = Set<Obstacle>()
        for line in splitInput(input).enumerated() {
            for char in line.element.enumerated() {
                guard let obstacleKind = Obstacle.Kind(rawValue: char.element) else { continue }
                obstacles.insert(
                    Obstacle(
                        kind: obstacleKind,
                        size: obstacleSize,
                        position: Position(
                            y: line.offset,
                            x: obstacleSize == .single ? char.offset : char.offset * 2
                        )
                    )
                )
            }
        }
        return obstacles
    }

    private func parseMoves(_ input: String) -> [Move] {
        splitInput(input).flatMap { line in
            line.compactMap(Move.init)
        }
    }

    private func startPosition(_ input: String, doubleWidth: Bool) -> Position {
        for line in splitInput(input).enumerated() {
            for char in line.element.enumerated() {
                if char.element == "@" {
                    return Position(
                        y: line.offset,
                        x: doubleWidth ? char.offset * 2 : char.offset
                    )
                }
            }
        }
        fatalError("Could not find start position")
    }
}

private enum MoveResult {
    case cantMove
    case moveBoxes(Set<Obstacle>)
}

private struct Obstacle: Hashable {
    let kind: Kind
    let size: Size
    var position: Position

    var rightHalf: Position {
        position + Move.east
    }

    func isHit(_ otherPosition: Position) -> Bool {
        switch size {
        case .single:
            return position == otherPosition
        case .double:
            return position == otherPosition || rightHalf == otherPosition
        }
    }

    enum Kind: Character, Hashable {
        case wall = "#"
        case box = "O"
    }

    enum Size: Hashable {
        case single
        case double
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

    static func +(lhs: Position, rhs: Move) -> Position {
        lhs + rhs.vector
    }
}

private struct Vector: Hashable {
    let y: Int
    let x: Int
}

private enum Move: Character, Hashable {
    case north = "^"
    case east = ">"
    case west = "<"
    case south = "v"

    var vector: Vector {
        switch self {
        case .north: Vector(y: -1, x: 0)
        case .east: Vector(y: 0, x: 1)
        case .west: Vector(y: 0, x: -1)
        case .south: Vector(y: 1, x: 0)
        }
    }
}
