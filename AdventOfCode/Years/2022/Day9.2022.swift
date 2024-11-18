import Foundation

extension Year2022.Day9: Runnable {
    func run(input: String) {
        let moves = splitInput(input).map { line in
            let components = line.components(separatedBy: " ")
            return Move(direction: Direction(value: components[0]), length: Int(components[1])!)
        }

        simulateRopeDrag(moves: moves, numberOfKnots: 2, dayPart: 1)
        simulateRopeDrag(moves: moves, numberOfKnots: 10, dayPart: 2)
    }

    private func simulateRopeDrag(moves: [Move], numberOfKnots: Int, dayPart: Int) {
        var lastKnot = Knot()
        let knots = [lastKnot] + (1..<numberOfKnots).map { _ in
            let knot = Knot(parent: lastKnot)
            lastKnot = knot
            return knot
        }

        var tailPositions = Set<Position>()
        tailPositions.insert(lastKnot.position)

        for move in moves {
            for _ in (1...move.length) {
                for knot in knots {
                    knot.move(direction: move.direction)

                    if knot == lastKnot {
                        tailPositions.insert(lastKnot.position)
                    }
                }
            }
        }

        printResult(dayPart: dayPart, message: "Number of positions tail has visited: \(tailPositions.count)")
    }
}

private extension Year2022.Day9 {
    typealias Move = (direction: Direction, length: Int)

    class Knot: Hashable {
        var parent: Knot?
        var position: Position

        init(parent: Knot? = nil, position: Position = Position(x: 0, y: 0)) {
            self.parent = parent
            self.position = position
        }

        func move(direction: Direction) {
            if let parentPosition = parent?.position {
                let diffX = parentPosition.x - position.x
                let diffY = parentPosition.y - position.y

                if [diffY, diffX].contains(where: { !(-1...1).contains($0) }) {
                    position = Position(
                        x: position.x + diffX.clamp(min: -1, max: 1),
                        y: position.y + diffY.clamp(min: -1, max: 1)
                    )
                }
            } else {
                switch direction {
                case .up: position = Position(x: position.x, y: position.y - 1)
                case .down: position = Position(x: position.x, y: position.y + 1)
                case .left: position = Position(x: position.x - 1, y: position.y)
                case .right: position = Position(x: position.x + 1, y: position.y)
                }
            }
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(parent)
            hasher.combine(position)
        }

        static func ==(lhs: Knot, rhs: Knot) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
    }

    struct Position: Hashable {
        let x: Int
        let y: Int
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

private extension Int {
    func clamp(min: Int, max: Int) -> Int {
        Swift.min(max, Swift.max(self, min))
    }
}
