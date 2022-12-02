import Foundation

extension Year2022.Day2: Runnable {
    func run(input: String) {
        let games = splitInput(input.lowercased())
            .map { splitInput($0, separatedBy: " ").map(Hand.init) }
            .map { Game(their: $0[0], your: $0[1]) }

        let yourPoints = games.reduce(0, { result, game in
            result + game.your.duel(against: game.their).points + game.your.points
        })

        printResult(dayPart: 1, message: "Your points: \(yourPoints)")
    }
}

private extension Year2022.Day2 {
    typealias Game = (their: Hand, your: Hand)

    enum Outcome {
        case win, lose, draw

        var points: Int {
            switch self {
            case .win:
                return 6
            case .lose:
                return 0
            case .draw:
                return 3
            }
        }
    }

    enum Hand: CaseIterable {
        case rock, paper, scissors

        var points: Int {
            switch self {
            case .rock: return 1
            case .paper: return 2
            case .scissors: return 3
            }
        }

        init(value: String) {
            if ["a", "x"].contains(value) {
                self = .rock
            } else if ["b", "y"].contains(value) {
                self = .paper
            } else if ["c", "z"].contains(value) {
                self = .scissors
            } else {
                fatalError("No hands matching value: '\(value)'")
            }
        }

        func duel(against other: Hand) -> Outcome {
            if self == other {
                return .draw
            }

            if other.points == points % Self.allCases.count + 1 {
                return .lose
            }

            return .win
        }
    }
}

