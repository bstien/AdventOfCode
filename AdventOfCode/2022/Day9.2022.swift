import Foundation

extension Year2022.Day9: Runnable {
    func run(input: String) {
        let moves = splitInput(input).map { line in
            let components = line.components(separatedBy: " ")
            return Move(direction: Direction(value: components[0]), length: Int(components[1])!)
        }

        var headPosition = Position(x: 0, y: 0)
        var tailPosition = Position(x: 0, y: 0)
        var tailPositions = Set<Position>()

        tailPositions.insert(tailPosition)

        for move in moves {
            for _ in (1...move.length) {
                headPosition = headPosition.move(direction: move.direction)
                if doesTailNeedToMove(head: headPosition, tail: tailPosition) {
                    tailPosition = tailPosition.move(direction: move.direction, parent: headPosition)
                    tailPositions.insert(tailPosition)
                }
            }
        }

        printResult(dayPart: 1, message: "Number of positions tail has visited: \(tailPositions.count)")
    }

    private func doesTailNeedToMove(head: Position, tail: Position) -> Bool {
        [head.x - tail.x, head.y - tail.y].contains { !(-1...1).contains($0) }
    }
}

private extension Year2022.Day9 {
    typealias Move = (direction: Direction, length: Int)

    struct Position: Hashable {
        let x: Int
        let y: Int

        func move(direction: Direction) -> Position {
            switch direction {
            case .up: return Position(x: x, y: y - 1)
            case .down: return Position(x: x, y: y + 1)
            case .left: return Position(x: x - 1, y: y)
            case .right: return Position(x: x + 1, y: y)
            }
        }

        func move(direction: Direction, parent: Position) -> Position {
            switch direction {
            case .up: return Position(x: parent.x, y: y - 1)
            case .down: return Position(x: parent.x, y: y + 1)
            case .left: return Position(x: x - 1, y: parent.y)
            case .right: return Position(x: x + 1, y: parent.y)
            }
        }
    }

    enum Direction {
        case up, down, left, right

        init(value: String) {
            switch value {
            case "U": self = .up
            case "D": self = .down
            case "L": self = .left
            case "R": self = .right
            default: fatalError("Direction not found for '\(value)'")
            }
        }
    }
}
