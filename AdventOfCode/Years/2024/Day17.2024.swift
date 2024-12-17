import Foundation

extension Year2024.Day17: Runnable {
    func run(input: String) {
        part1(input: input)
        part2(input: input)
    }

    private func part1(input: String) {
        let (a, b, c, program) = parseMachine(input)
        let machine = Machine(a: a, b: b, c: c, program: program)
        let output = machine.run()
        printResult(dayPart: 1, message: "Output: \(output.map { "\($0)" }.joined(separator: ","))")
    }

    private func part2(input: String) {
        let (_, _, _, program) = parseMachine(input)
        let result = solve(goal: program, program: program)
        printResult(dayPart: 2, message: "A needs to be: \(result)")
    }
    
    /// Still brute-forcing, but splitting the issue up into smaller problems seems to be the way.
    private func solve(goal: [Int], program: [Int]) -> Int {
        // Nothing to look for – go back one step.
        if goal.isEmpty { return 0 }

        // Recursively solve for each step in the program.
        // The machine works with 3 bit opcodes/operands, so shift the number left by 3 bits (x8) to separate each "instruction layer".
        var a = solve(goal: Array(goal.dropFirst()), program: program) << 3

        // Find the next number in the goal.
        while Machine(a: a, program: program).run() != goal {
            a += 1
        }
        return a
    }

    private func parseMachine(_ input: String) -> (Int, Int, Int, [Int]) {
        let sections = splitInput(input).map { splitInput($0, separatedBy: ": ") }
        let program = splitInput(sections[3][1], separatedBy: ",").compactMap(\.toInt)
        return (Int(sections[0][1])!, Int(sections[1][1])!, Int(sections[2][1])!, program)
    }
}

class Machine {
    var a: Int
    var b: Int
    var c: Int
    var pc: Int
    let program: [Int]

    init(a: Int, b: Int = 0, c: Int = 0, pc: Int = 0, program: [Int]) {
        self.a = a
        self.b = b
        self.c = c
        self.pc = pc
        self.program = program
    }

    func run(output: (Int) -> Bool){
        while true {
            guard program.indices.contains(pc), let instruction = Instruction(rawValue: program[pc]) else {
                break
            }

            switch instruction {
            case .adv:
                a = a / squareOperand(pc: pc + 1)
            case .bxl:
                b = b^program[pc + 1]
            case .bst:
                b = comboOperand(pc: pc + 1) % 8
            case .jnz:
                if a == 0 { break }
                pc = program[pc + 1]
                continue
            case .bxc:
                b = b^c
            case .out:
                if !output(comboOperand(pc: pc + 1) % 8) { return }
            case .bdv:
                b = a / squareOperand(pc: pc + 1)
            case .cdv:
                c = a / squareOperand(pc: pc + 1)
            }

            pc += 2
        }
    }

    func run() -> [Int] {
        var output = [Int]()
        run {
            output.append($0)
            return true
        }
        return output
    }

    func squareOperand(pc: Int) -> Int {
        Int(pow(Double(2), Double(comboOperand(pc: pc))))
    }

    func comboOperand(pc: Int) -> Int {
        switch Operand(program[pc]) {
        case .literal(let int): int
        case .a: a
        case .b: b
        case .c: c
        }
    }
}

private enum Instruction: Int {
    /// The adv instruction (opcode 0) performs division. The numerator is the value in the A register.
    /// The denominator is found by raising 2 to the power of the instruction's combo operand. (So, an operand of 2 would divide A by 4 (2^2); an operand of 5 would divide A by 2^B.)
    /// The result of the division operation is truncated to an integer and then written to the A register.
    case adv = 0

    /// The bxl instruction (opcode 1) calculates the bitwise XOR of register B and the instruction's literal operand, then stores the result in register B.
    case bxl = 1

    /// The bst instruction (opcode 2) calculates the value of its combo operand modulo 8 (thereby keeping only its lowest 3 bits), then writes that value to the B register.
    case bst = 2

    /// The jnz instruction (opcode 3) does nothing if the A register is 0.
    /// However, if the A register is not zero, it jumps by setting the instruction pointer to the value of its literal operand;
    /// if this instruction jumps, the instruction pointer is not increased by 2 after this instruction.
    case jnz = 3

    /// The bxc instruction (opcode 4) calculates the bitwise XOR of register B and register C, then stores the result in register B.
    /// (For legacy reasons, this instruction reads an operand but ignores it.)
    case bxc = 4

    /// The out instruction (opcode 5) calculates the value of its combo operand modulo 8, then outputs that value. (If a program outputs multiple values, they are separated by commas.)
    case out = 5

    /// The bdv instruction (opcode 6) works exactly like the adv instruction except that the result is stored in the B register. (The numerator is still read from the A register.)
    case bdv = 6

    /// The cdv instruction (opcode 7) works exactly like the adv instruction except that the result is stored in the C register. (The numerator is still read from the A register.)
    case cdv = 7
}

private enum Operand {
    case literal(Int)
    case a
    case b
    case c

    init(_ value: Int) {
        switch value {
        case 0...3: self = .literal(value)
        case 4: self = .a
        case 5: self = .b
        case 6: self = .c
        default: fatalError("Not a valid operand: \(value)")
        }
    }
}
