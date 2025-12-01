import Foundation

extension Year2025.Day1: Runnable {
    func run(input: String) {
        let lines = splitInput(input)
        let rotations = lines.map(Rotation.parse)

        let landingOnZero = part1(start: 50, rotations: rotations)
        printResult(dayPart: 1, message: "Number of times landing at 0: \(landingOnZero)")

        let passingZero = part2(start: 50, rotations: rotations)
        printResult(dayPart: 2, message: "Number of times passing 0: \(passingZero)")
    }

    private func part1(start: Int, rotations: [Rotation]) -> Int {
        var position = start
        var landingsOnZero = 0

        for rotation in rotations {
            switch rotation {
            case .l(let value):
                position = position - value
            case .r(let value):
                position = position + value
            }

            let division = position.quotientAndRemainder(dividingBy: 100)

            if position > 100 {
                position = position.remainderReportingOverflow(dividingBy: 100).partialValue
            } else if position < 0 {
                let remainder = position.remainderReportingOverflow(dividingBy: -100).partialValue
                position = remainder + 100
            }

            if position == 100 {
                position = 0
            }

            if position == 0 {
                landingsOnZero += 1
            }
        }

        return landingsOnZero
    }

    private func part2(start: Int, rotations: [Rotation]) -> Int {
        var position = start
        var passingsOfZero = 0

        for rotation in rotations {
            let startsAtZero = position == 0

            switch rotation {
            case .l(let value):
                position = position - value
            case .r(let value):
                position = position + value
            }

            let division = position.quotientAndRemainder(dividingBy: 100)
            passingsOfZero += abs(division.quotient)

            if position < 0 && position.isMultiple(of: -100) {
                passingsOfZero += 1
            } else if position == 0 {
                passingsOfZero += 1
            } else if division.remainder < 0 && !startsAtZero {
                passingsOfZero += 1
            }

            if division.remainder > 0 {
                position = division.remainder
            } else if division.remainder < 0 {
                position = 100 - abs(division.remainder)
            } else {
                position = 0
            }
        }

        return passingsOfZero
    }
}

extension Year2025.Day1 {
    enum Rotation {
        case l(Int)
        case r(Int)

        static func parse(_ line: String) -> Rotation {
            var line = line
            let letter = line.removeFirst()
            let value = Int(line)!

            switch letter.lowercased() {
            case "l":
                return .l(value)
            case "r":
                return .r(value)
            default:
                fatalError("Unexpected letter: \(letter)")
            }
        }
    }
}
