import Foundation

extension Year2025.Day6: Runnable {
    func run(input: String) {
        let lines = splitInput(input)
        let numbers = lines[0..<lines.count - 1].map { $0.split(separatedBy: " ").compactMap(Int.init) }
        let operations = lines[lines.count - 1].split(separatedBy: " ").map(Operation.parse)

        let part1Sum = part1(numbers: numbers, operations: operations)
        printResult(dayPart: 1, message: "Sum of part 1: \(part1Sum)")
    }

    private func part1(numbers: [[Int]], operations: [Operation]) -> Int {
        var totalSum = 0
        for (index, operation) in operations.enumerated() {
            var groupSum = operation.initialSum

            for group in numbers {
                groupSum = operation.sum(groupSum, group[index])
            }

            totalSum += groupSum
        }
        return totalSum
    }
}

extension Year2025.Day6 {
    enum Operation {
        case add
        case multiply

        var initialSum: Int {
            switch self {
            case .add: 0
            case .multiply: 1
            }
        }

        var sum: (Int, Int) -> Int {
            switch self {
            case .add: return (+)
            case .multiply: return (*)
            }
        }

        static func parse(_ s: String) -> Operation {
            switch s {
            case "+": .add
            case "*": .multiply
            default: fatalError("Unknown operation: \(s)")
            }
        }
    }
}
