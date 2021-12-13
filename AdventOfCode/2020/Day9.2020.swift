import Foundation

extension Year2020.Day9: Runnable {
    private var preambleLength: Int { 25 }

    func run(input: String) {
        let numbers = splitInput(input).compactMap(Int.init)

        if let invalidNumber = part1(numbers: numbers) {
            part2(numbers: numbers, invalidNumber: invalidNumber)
        }
    }

    private func part1(numbers: [Int]) -> Int? {
        var invalidNumbers = [Int]()
        var index = 0
        repeat {
            defer { index += 1 }
            let preamble = Set(numbers[index..<(index + preambleLength)])
            let number = numbers[index + preambleLength]

            let isInvalidNumber = preamble.map {
                let diff = number - $0
                return diff != $0 && preamble.contains(diff)
            }.allSatisfy({ !$0 })

            if isInvalidNumber {
                invalidNumbers.append(number)
            }
        } while numbers.count > index + preambleLength

        guard let firstInvalidNumber = invalidNumbers.first else {
            printResult(result: .fail, dayPart: 1, message: "Could not find an invalid number")
            return nil
        }

        printResult(dayPart: 1, message: "First invalid number: \(firstInvalidNumber)")
        return firstInvalidNumber
    }

    private func part2(numbers: [Int], invalidNumber: Int) {
        let list = contiguousNumbers(from: numbers, addingTo: invalidNumber)

        guard let min = list.min(), let max = list.max() else {
            printResult(result: .fail, dayPart: 2, message: "Could not get smallest/highest number from \(list)")
            return
        }

        printResult(dayPart: 2, message: "Encryption weakness = \(min + max)")
    }
}

private extension Year2020.Day9 {
    func contiguousNumbers(from numbers: [Int], addingTo value: Int) -> [Int] {
        var start = 0
        var end = 1

        repeat {
            let sum = Array(numbers[start...end]).reduce(0, +)
            if sum == value { break }

            else if sum < value {
                end += 1
            } else {
                start += 1
                end = start + 1
            }
        } while true

        return Array(numbers[start...end])
    }
}
