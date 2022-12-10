import Foundation

extension Year2022.Day10: Runnable {
    func run(input: String) {
        let commands = splitInput(input).map(Command.init)

        var register = 1
        var currentCycle = 0
        let notableCycles = [20, 60, 100, 140, 180, 220]
        var signalStrengths = [Int]()

        func checkcycle() {
            if notableCycles.contains(currentCycle) {
                signalStrengths.append(currentCycle * register)
            }
        }

        for command in commands {
            switch command {
            case .noop:
                currentCycle += 1
                checkcycle()
            case .add(let value):
                currentCycle += 1
                checkcycle()
                currentCycle += 1
                checkcycle()
                register += value
            }
        }

        printResult(dayPart: 1, message: "Sum of notable cycles: \(signalStrengths.reduce(0, +))")
    }
}

private extension Year2022.Day10 {
    enum Command {
        case noop, add(Int)

        init(line: String) {
            let components = line.components(separatedBy: " ")

            if components[0] == "noop" {
                self = .noop
            } else if components[0] == "addx" {
                let value = Int(components[1])!
                self = .add(value)
            } else {
                fatalError("No command for '\(line)'")
            }
        }
    }
}
