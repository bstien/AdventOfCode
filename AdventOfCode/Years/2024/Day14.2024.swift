import Foundation

extension Year2024.Day14: Runnable {
    func run(input: String) {
        let robots = parseRobots(input: input)

        part1(robots: robots)
        part2(robots: robots)
    }

    private func part1(robots: [Robot]) {
        let edge = Position(x: 101, y: 103)
        var seconds = 0
        var robots = robots

        repeat {
            robots = robots.map { $0.move(maxEdge: edge) }
            seconds += 1
        } while seconds < 10000

        let xSplit = edge.x / 2
        let ySplit = edge.y / 2

        let quadrants = [
            (Position(x: 0, y: 0), Position(x: xSplit - 1, y: ySplit - 1)),
            (Position(x: xSplit + 1, y: 0), Position(x: edge.x, y: ySplit - 1)),
            (Position(x: 0, y: ySplit + 1), Position(x: xSplit - 1, y: edge.y)),
            (Position(x: xSplit + 1, y: ySplit + 1), Position(x: edge.x, y: edge.y))
        ]

        var safetyFactor = 1
        for quadrant in quadrants {
            safetyFactor *= robots.filter {
                $0.position.x >= quadrant.0.x &&
                $0.position.x <= quadrant.1.x &&
                $0.position.y >= quadrant.0.y &&
                $0.position.y <= quadrant.1.y
            }.count
        }

        printResult(dayPart: 1, message: "Safety factor: \(safetyFactor)")
    }

    private func part2(robots: [Robot]) {
        let edge = Position(x: 101, y: 103)
        var seconds = 0
        var robots = robots

        repeat {
            robots = robots.map { $0.move(maxEdge: edge) }
            seconds += 1
            let lines = robots.getMap(edge: edge)
            if lines.contains(where: { $0.contains("##################")}) {
                print("\nSeconds: \(seconds)")
                robots.printMap(edge: edge)
                break
            }
        } while seconds < 10000
    }

    private func parseRobots(input: String) -> [Robot] {
        let lines = splitInput(input)

        return lines.map { line in
            let parts = splitInput(line, separatedBy: " ")

            let positionValues = splitInput(splitInput(parts[0], separatedBy: "=")[1], separatedBy: ",").compactMap(Int.init)
            let vectorValues = splitInput(splitInput(parts[1], separatedBy: "=")[1], separatedBy: ",").compactMap(Int.init)

            return Robot(
                position: Position(x: positionValues[0], y: positionValues[1]),
                vector: Vector(x: vectorValues[0], y: vectorValues[1])
            )
        }
    }
}

private extension [Robot] {
    func printMap(edge: Position) {
        let set = Set(self.map(\.position))
        var lines = [String]()
        lines.append(String(repeating: "-", count: edge.x))
        for y in 0..<edge.y {
            var line = [String]()
            for x in 0..<edge.x {
                let count = set.contains(Position(x: x, y: y))
                line.append(count ? "#" : " ")
            }
            lines.append(line.joined())
        }
        lines.append(String(repeating: "-", count: edge.x))
        lines.forEach { print($0) }
    }

    func getMap(edge: Position) -> [String] {
        let set = Set(self.map(\.position))
        var lines = [String]()
        for y in 0..<edge.y {
            var line = [String]()
            for x in 0..<edge.x {
                let count = set.contains(Position(x: x, y: y))
                line.append(count ? "#" : " ")
            }
            lines.append(line.joined())
        }
        return lines
    }
}

private struct Robot: Hashable, CustomStringConvertible {
    var position: Position
    let vector: Vector

    var description: String {
        "p: \(position), v: \(vector)"
    }

    func move(maxEdge: Position) -> Robot {
        let newPosition = position + vector

        return Robot(
            position: Position(
                x: newPosition.x < 0 ? maxEdge.x + newPosition.x : newPosition.x % maxEdge.x,
                y: newPosition.y < 0 ? maxEdge.y + newPosition.y : newPosition.y % maxEdge.y
            ),
            vector: vector
        )
    }
}

private struct Position: Hashable, CustomStringConvertible {
    let x: Int
    let y: Int

    var description: String {
        "(y: \(y),x: \(x))"
    }

    static func +(lhs: Position, rhs: Vector) -> Position {
        Position(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

private struct Vector: Hashable, CustomStringConvertible {
    let x: Int
    let y: Int

    var description: String {
        "(y: \(y),x: \(x))"
    }
}
