import Foundation


extension Year2022.Day5: Runnable {
    func run(input: String) {
        let lines = splitInput(input)
        var crates = [Int: [Character]]()

        let crateLines = lines.prefix(while: { !$0.starts(with: /\s\d/) })
        let instructionLines = lines.dropFirst(crateLines.count + 1)

        // Setup crates.
        for line in crateLines {
            let slices = splitInput(line, separatedBy: " ", omittingEmptySubsequences: false)
            var sliceIndex = 0
            var position = 1
            repeat {
                defer { position += 1 }

                let slice = slices[sliceIndex]
                if slice.isEmpty {
                    sliceIndex += 4
                    continue
                }

                crates[position, default: []].insert(slice.characterAt(1), at: 0)
                sliceIndex += 1
            } while sliceIndex < slices.count
        }

        // Read move instructions.
        let instructionRegex = try Regex(/move (\d+) from (\d+) to (\d+)/)
        let instructions = instructionLines.map { line in
            guard let match = line.firstMatch(of: instructionRegex) else {
                fatalError("Line did not match regex: '\(line)'")
            }

            let intValues = match.output[1...3].compactMap {
                guard let substring = $0.substring, let int = Int(substring) else {
                    fatalError()
                }
                return int
            }

            return MoveInstruction(count: intValues[0], from: intValues[1], to: intValues[2])
        }

        instructions.forEach { instruction in
            var stackToRemoveFrom = crates[instruction.from, default: []]
            let cratesToMove = stackToRemoveFrom.suffix(instruction.count)
            stackToRemoveFrom.removeLast(instruction.count)

            cratesToMove.reversed().forEach {
                crates[instruction.to, default: []].append($0)
            }
            crates[instruction.from] = stackToRemoveFrom
        }


        let topCrates = String(crates.keys.sorted().compactMap { crates[$0]?.last })
        printResult(dayPart: 1, message: "Top crates after moving: \(topCrates)")
    }
}

private extension Year2022.Day5 {
    typealias MoveInstruction = (count: Int, from: Int, to: Int)
}
