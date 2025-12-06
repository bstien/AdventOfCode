import Foundation
import Algorithms

extension Year2025.Day6: Runnable {
    func run(input: String) {
        let lines = splitInput(input)
        let numberGrid = Array(lines[0..<lines.count - 1])
        let numbers = numberGrid.map { $0.split(separatedBy: " ").compactMap(Int.init) }
        let operations = lines[lines.count - 1].split(separatedBy: " ").map(Operation.parse)

        let part1Sum = part1(numbers: numbers, operations: operations)
        printResult(dayPart: 1, message: "Sum of part 1: \(part1Sum)")

        let part2Sum = part2(grid: numberGrid, operations: operations)
        printResult(dayPart: 2, message: "Sum of part 2: \(part2Sum)")
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

    private func part2(grid: [String], operations: [Operation]) -> Int {
        let grid = grid.map { Array($0) }
        var totalSum = 0
        var delimiters = [Int]()

        // Find all empty columns, aka. delimiters.
        for column in grid[0].indices {
            var allAreEmpty = true

            for row in grid {
                if row[column] != " " {
                    allAreEmpty = false
                    break
                }
            }

            if allAreEmpty {
                delimiters.append(column)
            }
        }

        // Insert bounds for row.
        delimiters = [-1] + delimiters + [grid[0].count]

        for (index, window) in delimiters.windows(ofCount: 2).enumerated() {
            guard let lowerBound = window.first, let upperBound = window.last else {
                fatalError("Could not get upper/lower bound")
            }

            var numbers = [Int]()

            // Collect characters from each column and create numbers from them.
            for column in (lowerBound+1 ... upperBound-1) {
                var string = ""
                for row in grid where row[column] != " " {
                    string.append(row[column])
                }

                if let number = Int(string) {
                    numbers.append(number)
                }
            }

            // Sum the numbers.
            let operation = operations[index]
            totalSum += numbers.reduce(operation.initialSum, operation.sum)
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
