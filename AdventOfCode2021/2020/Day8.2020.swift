import Foundation

extension Year2020.Day8: Runnable {
    func run(input: String) {
        let instructions = parseInstructions(from: input)
        part1(instructions: instructions)
        part2(instructions: instructions)
    }

    private func part1(instructions: [Instruction]) {
        let result = runProgram(instructions: instructions)

        if result.infiniteLoop {
            printResult(dayPart: 1, message: "Value of acc when trying to run an instruction a second time: \(result.acc)")
        } else {
            printResult(result: .fail, dayPart: 1, message: "Program terminated without problems")
        }
    }

    private func part2(instructions: [Instruction]) {
        var changedInstructions = Set<Int>()
        var result: (acc: Int, infiniteLoop: Bool)?

        repeat {
            var instructionsToTest = instructions
            guard let jmpOrNop = instructions.enumerated().first(where: { !changedInstructions.contains($0.offset) && $0.element.operation != .acc })
                else { break }

            let offset = jmpOrNop.offset
            let operation = jmpOrNop.element.operation
            let value = jmpOrNop.element.value
            instructionsToTest[offset] = operation == .jmp ? Instruction(operation: .nop, value: value) : Instruction(operation: .jmp, value: value)

            changedInstructions.insert(offset)

            result = runProgram(instructions: instructionsToTest)

            if let result = result, !result.infiniteLoop { break }
        } while true

        guard let finalResult = result else {
            printResult(result: .fail, dayPart: 2, message: "Did not get a result :(")
            return
        }

        if finalResult.infiniteLoop {
            printResult(result: .fail, dayPart: 2, message: "Got stuck in an infinite loop...")
        } else {
            printResult(dayPart: 2, message: "Value in accumulator after changing a single instruction: \(finalResult.acc)")
        }
    }
}

// MARK: - Running the program

extension Year2020.Day8 {
    private func runProgram(instructions: [Instruction]) -> (acc: Int, infiniteLoop: Bool) {
        var visitedInstructions = Set<Int>()
        var programCounter = 0
        var accumulator = 0

        repeat {
            visitedInstructions.insert(programCounter)
            let instruction = instructions[programCounter]

            switch instruction.operation {
            case .acc:
                accumulator += instruction.value
                programCounter += 1
            case .jmp:
                programCounter += instruction.value
            case .nop:
                programCounter += 1
            }
        } while instructions.indices.contains(programCounter) && !visitedInstructions.contains(programCounter)

        return (acc: accumulator, infiniteLoop: visitedInstructions.contains(programCounter))
    }
}

// MARK: - Parsing

extension Year2020.Day8 {
    private func parseInstructions(from input: String) -> [Instruction] {
        splitInput(input).reduce(into: [Instruction]()) { result, line in
            let split = line.split(separator: " ").map(String.init)

            guard let intValue = Int(split[1]), let operation = Operation(rawValue: split[0]) else { return }
            result.append(Instruction(operation: operation, value: intValue))
        }
    }
}

// MARK: - Private types

private enum Operation: String {
    case jmp, acc, nop
}

private struct Instruction {
    let operation: Operation
    let value: Int
}
