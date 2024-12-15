import Foundation

extension Year2024.Day15: Runnable {
    func run(input: String) {
        let sections = splitInput(input, separatedBy: "\n\n")
        let map = parseMap(sections[0])
        let startPosition = startPosition(sections[0])
        let moves = parseMoves(sections[1])
        part1(map: map, moves: moves, startPosition: startPosition)
    }

    private func part1(map: Set<Obstacle>, moves: [Move], startPosition: Position) {
        var map = map
        var position = startPosition

        for move in moves {
            switch tryMove(from: position, move: move, map: map) {
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

    private func tryMove(
        from position: Position,
        move: Move,
        map: Set<Obstacle>,
        boxesToMove: Set<Obstacle> = []
    ) -> MoveResult {
        let nextPosition = position + move
        if let obstacle = map.first(where: { $0.position == nextPosition }) {
            switch obstacle.kind {
            case .wall:
                return .cantMove
            case .box:
                return tryMove(
                    from: nextPosition,
                    move: move,
                    map: map,
                    boxesToMove: boxesToMove.union([obstacle])
                )
            }
        } else {
            return .moveBoxes(boxesToMove)
        }
    }

    private func parseMap(_ input: String) -> Set<Obstacle> {
        var obstacles = Set<Obstacle>()
        for line in splitInput(input).enumerated() {
            for char in line.element.enumerated() {
                guard let obstacleKind = Obstacle.Kind(rawValue: char.element) else { continue }
                obstacles.insert(
                    Obstacle(
                        kind: obstacleKind,
                        position: Position(
                            y: line.offset,
                            x: char.offset
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

    private func startPosition(_ input: String) -> Position {
        for line in splitInput(input).enumerated() {
            for char in line.element.enumerated() {
                if char.element == "@" {
                    return Position(y: line.offset, x: char.offset)
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
    var position: Position

    enum Kind: Character, Hashable {
        case wall = "#"
        case box = "O"
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
