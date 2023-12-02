import Foundation

extension Year2023.Day2: Runnable {
    func run(input: String) {
        let lines = splitInput(input)
        let games = parseGames(lines: lines)
        part1(games: games)
        part2(games: games)
    }

    private func part1(games: [Game]) {
        let possibleGames = games.filter { game in
            game.cubeSets.allSatisfy { cubeSet in
                cubeSet.red <= 12 &&
                cubeSet.green <= 13 &&
                cubeSet.blue <= 14
            }
        }

        let gameIdSum = possibleGames.map(\.id).reduce(0, +)
        printResult(dayPart: 1, message: "Total: \(gameIdSum)")
    }

    private func part2(games: [Game]) {
        let cubePower = games.map { game in
            guard
                let maxRed = game.cubeSets.max(by: { $0.red < $1.red })?.red,
                let maxGreen = game.cubeSets.max(by: { $0.green < $1.green })?.green,
                let maxBlue = game.cubeSets.max(by: { $0.blue < $1.blue })?.blue
            else {
                fatalError("Could not get max color count from CubeSet")
            }

            return maxRed * maxGreen * maxBlue
        }.reduce(0, +)

        printResult(dayPart: 2, message: "Cube power: \(cubePower)")
    }

    private func parseGames(lines: [String]) -> [Game] {
        lines.compactMap { line in
            let components = splitInput(line, separatedBy: ": ")

            guard let gameId = Int(splitInput(components[0], separatedBy: " ")[1]) else {
                fatalError("Could not parse gameId: \(line)")
            }

            let setComponents = splitInput(components[1], separatedBy: "; ").map {
                splitInput($0, separatedBy: ", ").map {
                    splitInput($0, separatedBy: " ")
                }
            }

            let cubeSets = setComponents.map(CubeSet.create(from:))
            return Game(id: gameId, cubeSets: cubeSets)
        }
    }
}

private struct Game {
    let id: Int
    let cubeSets: [CubeSet]
}

private class CubeSet {
    var red: Int
    var green: Int
    var blue: Int

    init() {
        red = 0
        green = 0
        blue = 0
    }

    static func create(from components: [[String]]) -> CubeSet {
        let cubeSet = CubeSet()
        components.forEach { component in
            guard component.count == 2 else {
                fatalError("CubeSet: Did not receive 2 component: \(component)")
            }

            guard let count = Int(component[0]) else {
                fatalError("CubeSet: Could not parse count: \(component)")
            }

            let color = component[1]

            switch color {
            case "red":
                cubeSet.red = count
            case "green":
                cubeSet.green = count
            case "blue":
                cubeSet.blue = count
            default:
                fatalError("CubeSet: Could not identify color \(component)")
            }
        }
        return cubeSet
    }
}
