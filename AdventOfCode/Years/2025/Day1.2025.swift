import Foundation

extension Year2025.Day1: Runnable {
    func run(input: String) {
        let lines = splitInput(input)
        let rotations = lines.map(Rotation.parse)
        let landingOnZero = part1(start: 50, rotations: rotations)

        printResult(dayPart: 1, message: "Number of times at 0: \(landingOnZero)")
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

            if position >= 100 {
                position = position.remainderReportingOverflow(dividingBy: 100).partialValue
            } else if position < 0 {
                position = position.remainderReportingOverflow(dividingBy: -100).partialValue
            }

            if position == 0 {
                landingsOnZero += 1
            }
        }

        return landingsOnZero
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
