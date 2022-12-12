import Foundation

extension Year2022.Day12: Runnable {
    func run(input: String) {
        var mountain = splitInput(input).map { Array($0) }

        let partOneStartPoint = mountain.findPositions(of: "S").first!
        let endPoint = mountain.findPositions(of: "E").first!

        mountain = mountain.map { line in
            line.map { character -> Character in
                if character == "S" { return "a" }
                if character == "E" { return "z" }
                return character
            }
        }

        let part1 = exploreRoutes(from: partOneStartPoint, destinations: [endPoint], mountain: mountain, canMove: {
            mountain.elevationIndex(for: $1) <= mountain.elevationIndex(for: $0) + 1
        })
        printResult(dayPart: 1, message: "Shortest route: \(part1.count - 1)")

        let partTwoStartPoints = mountain.findPositions(of: "a")
        let part2 = exploreRoutes(from: endPoint, destinations: partTwoStartPoints, mountain: mountain, canMove: {
            mountain.elevationIndex(for: $1) >= mountain.elevationIndex(for: $0) - 1
        })
        printResult(dayPart: 2, message: "Shortest route: \(part2.count - 1)")
    }

    private func exploreRoutes(
        from position: Position,
        destinations: [Position],
        mountain: Mountain,
        canMove: (_ from: Position, _ to: Position) -> Bool
    ) -> [Position] {
        var queue = [position]
        var parentMap = [Position: Position]()
        parentMap[position] = .nonExisting

        while (!queue.isEmpty) {
            let currentPosition = queue.removeFirst()

            if destinations.contains(currentPosition) {
                return route(from: currentPosition, parentMap: parentMap)
            }

            mountain.neighbors(for: currentPosition)
                .filter {
                    !parentMap.keys.contains($0) && canMove(currentPosition, $0)
                }
                .forEach {
                    queue.append($0)
                    parentMap[$0] = currentPosition
                }
        }

        return []
    }

    private func route(from position: Position, parentMap: [Position: Position]) -> [Position] {
        var route = [Position]()
        var current = position

        repeat {
            route.append(current)
            current = parentMap[current, default: .nonExisting]
        } while current != .nonExisting

        return route
    }
}

private extension Year2022.Day12 {
    typealias Mountain = [[Character]]

    struct Position: Hashable {
        let x: Int
        let y: Int

        static var nonExisting = Position(x: -100, y: -100)
    }
}

private extension Year2022.Day12.Mountain {
    static var elevationRange = ("a"..."z").characters

    func elevationIndex(for position: Year2022.Day12.Position) -> Int {
        Self.elevationRange.firstIndex(of: value(for: position))!
    }

    func contains(position: Year2022.Day12.Position) -> Bool {
        indices.contains(position.y) && self[position.y].indices.contains(position.x)
    }

    func value(for position: Year2022.Day12.Position) -> Character {
        self[position.y][position.x]
    }

    func neighbors(for position: Year2022.Day12.Position) -> [Year2022.Day12.Position] {
        [
            .init(x: position.x + 1, y: position.y),
            .init(x: position.x - 1, y: position.y),
            .init(x: position.x, y: position.y + 1),
            .init(x: position.x, y: position.y - 1)
        ].filter {
            contains(position: $0)
        }
    }

    func findPositions(of toFind: Character) -> [Year2022.Day12.Position] {
        enumerated().flatMap { y, row in
            row.enumerated().compactMap { x, character in
                if character == toFind {
                    return Year2022.Day12.Position(x: x, y: y)
                }
                return nil
            }
        }
    }

    func printGrid(visited: [Year2022.Day12.Position]) {
        let toPrint = enumerated().map { y, row in
            row.enumerated().map { x, character in
                if visited.contains(.init(x: x, y: y)) {
                    return "X"
                } else {
                    return "."
                }
            }.joined()
        }.joined(separator: "\n")

        print(toPrint)
        print("--------------")
    }
}
