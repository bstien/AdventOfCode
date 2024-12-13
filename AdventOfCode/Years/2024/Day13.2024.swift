import Foundation
import RegexBuilder

extension Year2024.Day13: Runnable {
    func run(input: String) {
        let games = parseGames(input: input)
        part1(games: games)
    }

    private func part1(games: [Game]) {
        var tokensNeeded = 0

        games.forEach { game in
            for bPresses in (0...game.prize.minPress(of: game.buttonB)) {
                let bPos = game.buttonB * bPresses
                var aPresses = 0
                repeat {
                    let endPos = bPos + (game.buttonA * aPresses)
                    if endPos > game.prize { break }
                    if endPos == game.prize {
                        tokensNeeded += bPresses + (aPresses * 3)
                        return
                    }
                    aPresses += 1
                } while true
            }
        }

        printResult(dayPart: 1, message: "# of tokens needed: \(tokensNeeded)")
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
}

private struct Game {
    let buttonA: Vector
    let buttonB: Vector
    let prize: Position
}

private struct Position: Hashable, CustomStringConvertible {
    let x: Int
    let y: Int

    var description: String {
        "(x: \(x), y: \(y))"
    }

    func minPress(of vector: Vector) -> Int {
        let minX = Int(ceil(Double(x) / Double(vector.x)))
        let minY = Int(ceil(Double(y) / Double(vector.y)))
        return max(minX, minY)
    }

    static func +(lhs: Position, rhs: Vector) -> Position {
        Position(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func +(lhs: Position, rhs: Position) -> Position {
        Position(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func <(lhs: Position, rhs: Position) -> Bool {
        lhs.x < rhs.x && lhs.y < rhs.y
    }

    static func >(lhs: Position, rhs: Position) -> Bool {
        lhs.x > rhs.x && lhs.y > rhs.y
    }
}

private struct Vector: Hashable, CustomStringConvertible {
    let x: Int
    let y: Int

    var description: String {
        "(x: \(x), y: \(y))"
    }

    static func *(vector: Vector, multiplier: Int) -> Position {
        Position(x: vector.x * multiplier, y: vector.y * multiplier)
    }
}
