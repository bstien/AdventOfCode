import Foundation
import RegexBuilder

extension Year2024.Day13: Runnable {
    func run(input: String) {
        let games = parseGames(input: input)
        part1(games: games)
        part2(games: games)
    }

    private func part1(games: [Game]) {
        let tokensNeeded = games.compactMap(solve(game:))
            .map { $0.bPresses + ($0.aPresses * 3) }
            .sum

        printResult(dayPart: 1, message: "# of tokens needed: \(tokensNeeded)")
    }

    private func part2(games: [Game]) {
        let games = games.map {
            Game(
                buttonA: $0.buttonA,
                buttonB: $0.buttonB,
                prize: Position(
                    x: $0.prize.x + 10000000000000,
                    y: $0.prize.y + 10000000000000
                )
            )
        }

        let tokensNeeded = games
            .compactMap(solve(game:))
            .map { $0.bPresses + ($0.aPresses * 3) }
            .sum
        printResult(dayPart: 2, message: "# of tokens needed: \(tokensNeeded)")
    }

    private func parseGames(input: String) -> [Game] {
        let regex = Regex {
            "Button A: X+"
            TryCapture({ OneOrMore(.digit) }, transform: { Int($0) ?? 0 })
            ", Y+"
            TryCapture({ OneOrMore(.digit) }, transform: { Int($0) ?? 0 })
            One(.newlineSequence)

            "Button B: X+"
            TryCapture({ OneOrMore(.digit) }, transform: { Int($0) ?? 0 })
            ", Y+"
            TryCapture({ OneOrMore(.digit) }, transform: { Int($0) ?? 0 })
            One(.newlineSequence)

            "Prize: X="
            TryCapture({ OneOrMore(.digit) }, transform: { Int($0) ?? 0 })
            ", Y="
            TryCapture({ OneOrMore(.digit) }, transform: { Int($0) ?? 0 })
        }

        return splitInput(input, separatedBy: "\n\n").compactMap { instruction in
            guard let match = instruction.firstMatch(of: regex)?.output else { fatalError() }

            return Game(
                buttonA: Vector(x: match.1, y: match.2),
                buttonB: Vector(x: match.3, y: match.4),
                prize: Position(x: match.5, y: match.6)
            )
        }
    }

    private func solve(game: Game) -> (aPresses: Int, bPresses: Int)? {
        let determinant = game.buttonA.x * game.buttonB.y - game.buttonA.y * game.buttonB.x
        if determinant == 0 {
            return nil
        }

        let numerator1 = game.buttonB.y * game.prize.x - game.buttonB.x * game.prize.y
        let numerator2 = -game.buttonA.y * game.prize.x + game.buttonA.x * game.prize.y

        if !numerator1.isMultiple(of: determinant) || !numerator2.isMultiple(of: determinant) {
            return nil
        }

        let n1 = numerator1 / determinant
        let n2 = numerator2 / determinant

        let position = Position(
            x: n1 * game.buttonA.x + n2 * game.buttonB.x,
            y: n1 * game.buttonA.y + n2 * game.buttonB.y
        )

        if position != game.prize {
            return nil
        }

        return (n1, n2)
    }
}

private struct Game {
    let buttonA: Vector
    let buttonB: Vector
    let prize: Position
}

private struct Position: Hashable {
    let x: Int
    let y: Int
}

private struct Vector: Hashable {
    let x: Int
    let y: Int
}
