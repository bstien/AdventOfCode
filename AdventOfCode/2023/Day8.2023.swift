import Foundation

extension Year2023.Day8: Runnable {
    func run(input: String) {
        let instructions = parseInstructions(input: input)
        let nodes = parseNetwork(input: input)
        
        part1(instructions: instructions, nodes: nodes)
        part2(instructions: instructions, nodes: nodes)
    }

    private func part1(instructions: [Instruction], nodes: [Node]) {
        let startNode = nodes.first(where: { $0.id == "AAA" })!
        let steps = traverse(nodes: nodes, startNode: startNode, instructions: instructions, shouldStop: { $0.id == "ZZZ" })

        printResult(dayPart: 1, message: "Number of steps: \(steps)")
    }

    private func part2(instructions: [Instruction], nodes: [Node]) {
        let steps = nodes.filter { $0.id.last == "A" }
            .map { traverse(nodes: nodes, startNode: $0, instructions: instructions, shouldStop: { $0.id.last == "Z" }) }
            .reduce(1, { ($0 * $1) / Int.gcd($0, $1) })

        printResult(dayPart: 2, message: "Number of steps: \(steps)")
    }

    private func traverse(
        nodes: [Node],
        startNode: Node,
        instructions: [Instruction],
        shouldStop: (Node) -> Bool
    ) -> Int {
        var steps = 0
        let idToIndexMap = nodes.enumerated().reduce(into: [String: Int](), { $0[$1.element.id] = $1.offset })
        var currentNodeIndex = idToIndexMap[startNode.id]!

        while(true) {
            let node = nodes[currentNodeIndex]
            if shouldStop(node) { break }

            let nextNodeId = instructions[steps % instructions.count] == .l ? node.leftId : node.rightId
            guard let nextNodeIndex = idToIndexMap[nextNodeId] else {
                fatalError("No node index found for id '\(nextNodeId)'")
            }

            currentNodeIndex = nextNodeIndex
            steps += 1
        }

        return steps
    }

    private func parseInstructions(input: String) -> [Instruction] {
        guard let firstLine = splitInput(input).first else { fatalError() }
        return firstLine.compactMap(Instruction.init(rawValue:))
    }

    private func parseNetwork(input: String) -> [Node] {
        let lines = splitInput(input).dropFirst()

        return lines.map { line in
            let components = splitInput(line, separatedBy: " = ")
            let nodeMap = splitInput(components[1], separatedBy: ", ").map { $0.trimmingCharacters(in: .alphanumerics.inverted) }
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
