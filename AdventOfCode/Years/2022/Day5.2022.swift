import Foundation

extension Year2022.Day5: Runnable {
    func run(input: String) {
        let lines = splitInput(input)

        let crateLines = lines.prefix(while: { !$0.starts(with: /\s\d/) })
        var crates = parseCrates(lines: crateLines)

        let instructionLines = lines.dropFirst(crateLines.count + 1)
        let instructions = parseInstructions(lines: instructionLines)

        moveCrates(strategy: .single, crates: crates, instructions: instructions)
        moveCrates(strategy: .multiple, crates: crates, instructions: instructions)
    }

    private func moveCrates(strategy: MoveStrategy, crates: [Int: [Character]], instructions: [MoveInstruction]) {
        var crates = crates

        instructions.forEach { instruction in
            var stackToRemoveFrom = crates[instruction.from, default: []]
            let cratesToMove = stackToRemoveFrom.suffix(instruction.count)
            stackToRemoveFrom.removeLast(instruction.count)
            crates[instruction.from] = stackToRemoveFrom

            switch strategy {
            case .single:
                crates[instruction.to]?.append(contentsOf: cratesToMove.reversed())
            case .multiple:
                crates[instruction.to]?.append(contentsOf: cratesToMove)
            }
        }

        let topCrates = String(crates.keys.sorted().compactMap { crates[$0]?.last })
        printResult(dayPart: strategy.rawValue, message: "Top crates after moving: \(topCrates)")
    }

    private func parseCrates(lines: some Collection<String>) -> [Int: [Character]] {
        var crates = [Int: [Character]]()
        lines.flatMap { $0.chunks(ofCount: 4).enumerated() }.forEach { chunk in
            if chunk.element.first == " " { return }
            crates[chunk.offset + 1, default: []].insert(chunk.element.characterAt(1), at: 0)
        }
        return crates
    }

    private func parseInstructions(lines: some Collection<String>) -> [MoveInstruction] {
        let regex = Regex(/move (\d+) from (\d+) to (\d+)/)
        return lines.map { line -> MoveInstruction in
            guard let match = line.firstMatch(of: regex) else {
                fatalError("Line did not match regex: '\(line)'")
            }

            let intValues = match.output[1...3].compactMap(\.substring).compactMap { Int($0) }
            return MoveInstruction(count: intValues[0], from: intValues[1], to: intValues[2])
        }
    }
}

private extension Year2022.Day5 {
    typealias MoveInstruction = (count: Int, from: Int, to: Int)

    private enum MoveStrategy: Int {
        case single = 1, multiple
    }
}
