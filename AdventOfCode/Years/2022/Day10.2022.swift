import Foundation

extension Year2022.Day10: Runnable {
    func run(input: String) {
        let commands = splitInput(input).map(Command.init)

        part1(commands: commands)
        part2(commands: commands)
    }

    private func part1(commands: [Command]) {
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

    private func part2(commands: [Command]) {
        var register = 1
        var currentCycle = 0
        var outputLines = [Int: String]()

        func drawOutput() {
            let lineLength = 40
            if (register-1...register+1).contains(currentCycle % lineLength) {
                outputLines[currentCycle / lineLength, default: ""] += "[]"
            } else {
                outputLines[currentCycle / lineLength, default: ""] += "  "
            }
        }

        for command in commands {
            drawOutput()
            switch command {
            case .noop:
                currentCycle += 1
            case .add(let value):
                currentCycle += 1
                drawOutput()
                currentCycle += 1
                register += value
            }
        }

        let screen = outputLines.keys.sorted().map { outputLines[$0, default: ""] }.joined(separator: "\n")
        printResult(dayPart: 2, message: "Screen:\n\(screen)")
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
