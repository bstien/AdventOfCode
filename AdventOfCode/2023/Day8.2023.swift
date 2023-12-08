import Foundation

extension Year2023.Day8: Runnable {
    func run(input: String) {
        let instructions = parseInstructions(input: input)
        let nodes = parseNetwork(input: input)
        part1(instructions: instructions, nodes: nodes)
    }

    private func part1(instructions: [Instruction], nodes: [Node]) {
        let startId = "AAA"
        let endId = "ZZZ"

        let idToIndexMap = nodes.enumerated().reduce(into: [String: Int](), { $0[$1.element.id] = $1.offset })

        var steps = 0
        var currentNodeIndex = idToIndexMap[startId]!

        while(true) {
            let node = nodes[currentNodeIndex]
            if node.id == endId { break }

            let nextNodeId = instructions[steps % instructions.count] == .l ? node.leftId : node.rightId
            guard let nextNodeIndex = idToIndexMap[nextNodeId] else {
                fatalError("No node index found for id '\(nextNodeId)'")
            }

            currentNodeIndex = nextNodeIndex
            steps += 1
        }

        printResult(dayPart: 1, message: "Number of steps: \(steps)")
    }

    private func parseInstructions(input: String) -> [Instruction] {
        guard let firstLine = splitInput(input).first else { fatalError() }
        return firstLine.compactMap(Instruction.init(rawValue:))
    }

    private func parseNetwork(input: String) -> [Node] {
        let lines = splitInput(input).dropFirst()

        return lines.map { line in
            let components = splitInput(line, separatedBy: " = ")
            let nodeMap = splitInput(components[1], separatedBy: ", ").map { $0.trimmingCharacters(in: .letters.inverted) }
            return Node(id: components[0], leftId: nodeMap[0], rightId: nodeMap[1])
        }
    }
}

private enum Instruction: Character {
    case l = "L"
    case r = "R"
}

private struct Node {
    let id: String
    let leftId: String
    let rightId: String
}
