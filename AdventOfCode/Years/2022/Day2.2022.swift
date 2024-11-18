import Foundation

extension Year2022.Day2: Runnable {
    func run(input: String) {
        let input = splitInput(input.lowercased()).map { splitInput($0, separatedBy: " ") }
        part1(input: input)
        part2(input: input)
    }

    private func part1(input: [[String]]) {
        let yourPoints = input
            .map { $0.map(Hand.init) }
            .map { (their: $0[0], your: $0[1]) }
            .reduce(0, { result, game in
                result + game.your.duel(against: game.their).points + game.your.points
            })

        printResult(dayPart: 1, message: "Your points: \(yourPoints)")
    }

    private func part2(input: [[String]]) {
        let yourPoints = input
            .map { (hand: Hand(value: $0[0]), outcome: Outcome(value: $0[1])) }
            .reduce(0, { result, game in
                result + game.hand.findHand(for: game.outcome).points + game.outcome.points
            })

        printResult(dayPart: 2, message: "Your points: \(yourPoints)")
    }
}

private extension Year2022.Day2 {
    enum Outcome {
        case win, lose, draw

        init(value: String) {
            if "x" == value {
                self = .lose
            } else if "y" == value {
                self = .draw
            } else if "z" == value {
                self = .win
            } else {
                fatalError("No outcome matching value: '\(value)'")
            }
        }

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

    enum Hand: Int, CaseIterable {
        case rock = 1
        case paper
        case scissors

        var points: Int {
            rawValue
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

        init(points: Int) {
            guard let hand = Hand(rawValue: points) else {
                fatalError("No hand found for points: \(points)")
            }
            self = hand
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

        func findHand(for outcome: Outcome) -> Hand {
            switch outcome {
            case .win:
                return Hand(points: (points % Self.allCases.count) + 1)
            case .lose:
                let index = points - 2
                return Self.allCases[index < 0 ? Self.allCases.count - 1 : index]
            case .draw:
                return self
            }
        }
    }
}

