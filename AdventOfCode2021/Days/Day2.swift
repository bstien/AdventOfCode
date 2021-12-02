import Foundation

private typealias Command = (String, Int)

struct Day2: Day {
    static func run(input: String) {
        let commands = splitInput(input).splitCommands()
        part1(commands: commands)
        part2(commands: commands)
    }

    private static func part1(commands: [Command]) {
        var distance = 0
        var depth = 0

        commands.forEach { command in
            switch command.0 {
            case "forward":
                distance += command.1
            case "up":
                depth -= command.1
            case "down":
                depth += command.1
            default:
                break
            }
        }

        printResult(dayPart: 1, message: "Distance * depth = \(distance * depth)")
    }

    private static func part2(commands: [Command]) {
        var distance = 0
        var depth = 0
        var aim = 0

        commands.forEach { command in
            switch command.0 {
            case "forward":
                distance += command.1
                depth += aim * command.1
            case "up":
                aim -= command.1
            case "down":
                aim += command.1
            default:
                break
            }
        }

        printResult(dayPart: 2, message: "Distance * depth = \(distance * depth)")
    }
}

// MARK: - Private extensions

private extension Array where Element == String {
    func splitCommands() -> [Command] {
        reduce(into: [Command]()) { result, command in
            let split = command.split(separator: " ")
            guard split.count == 2 else { return }

            let command = String(split[0])
            let count = Int(split[1]) ?? 0

            result.append((command, count))
        }
    }
}
