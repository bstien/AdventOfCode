import Foundation

extension Year2022.Day12: Runnable {
    func run(input: String) {
        var mountain = splitInput(input).map { Array($0) }

        let startPoint = mountain.findPosition(of: "S")
        let endPoint = mountain.findPosition(of: "E")

        mountain = mountain.map { line in
            line.map {
                if $0 == "S" { return "a" }
                if $0 == "E" { return "z" }
                return $0
            }
        }

        let shortestRoute = exploreRoutes(from: startPoint, destination: endPoint, mountain: mountain).count - 1
        printResult(dayPart: 1, message: "Shortest route: \(shortestRoute)")
    }

    private func exploreRoutes(
        from position: Position,
        destination: Position,
        mountain: Mountain
    ) -> [Position] {
        var queue = [position]
        var parentMap = [Position: Position]()
        parentMap[position] = .nonExisting

        while (!queue.isEmpty) {
            let currentPosition = queue.removeFirst()
            let currentElevationIndex = mountain.elevationIndex(for: currentPosition)

            if currentPosition == destination {
                return route(from: currentPosition, parentMap: parentMap)
            }

            mountain.neighbors(for: currentPosition)
                .filter {
                    !parentMap.keys.contains($0) && mountain.elevationIndex(for: $0) <= currentElevationIndex + 1
                }
                .forEach { neighbor in
                    queue.append(neighbor)
                    parentMap[neighbor] = currentPosition
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

    func findPosition(of character: Character) -> Year2022.Day12.Position {
        guard
            let yPos = firstIndex(where: { $0.contains(character) }),
            let xPos = self[yPos].firstIndex(of: character)
        else {
            fatalError("Could not find character: '\(character)'")
        }

        return .init(x: xPos, y: yPos)
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
