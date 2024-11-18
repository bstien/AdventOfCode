import Foundation

private typealias Cost = Int

extension Year2021.Day15: Runnable {
    func run(input: String) {
        let caveMap = splitInput(input).map { $0.map { Int(String($0))! } }
        part1(caveMap: caveMap)
    }

    private func part1(caveMap: [[Int]]) {
        let (startNode, endNode) = parseNodes(map: caveMap)
        findPath(from: startNode, to: endNode)
    }

    private func findPath(from start: Node, to end: Node) {
        var nodesToCheck = Set<Node>()
        var ignored = Set<Node>()

        nodesToCheck.insert(start)

        while !nodesToCheck.isEmpty {
            let current = nodesToCheck.min(by: { end.cost(from: $0) >= end.cost(from: $1) })!
            nodesToCheck.remove(current)
            ignored.insert(current)

            if current == end {
                return
            }

            for neighbor in current.neighbors {
                if ignored.contains(neighbor) || nodesToCheck.contains(neighbor) { continue }

                if nodesToCheck.isEmpty {
                    nodesToCheck.insert(neighbor)
                } else {

                }
            }
        }
    }

//    private func findPath(from startNode: Node, to goalNode: Node) -> [Node] {
//        guard startNode != goalNode else { return [goalNode] }
//        var possibleSteps = [Step]()
//        var eliminatedNodes: Set = [startNode]
//
//        while !possibleSteps.isEmpty {
//            let step = possibleSteps.removeFirst()
//            guard step.node != goalNode else { return reconstructPath(from: step) }
//            eliminatedNodes.insert(step.node)
//            let nextNodes = nodesAdjacent(to: step.node).subtracting(eliminatedNodes)
//            for node in nextNodes {
//                // FIXME: don't create a step because in some cases it is never used
//                let nextStep = createStep(from: step, to: node, goal: goalNode)
//                let index = possibleSteps.binarySearch(element: nextStep)
//                if index<possibleSteps.count && possibleSteps[index] == nextStep {
//                    if nextStep.stepCost < possibleSteps[index].stepCost {
//                        possibleSteps[index].previous = step
//                    }
//                } else {
//                    possibleSteps.sortedInsert(newElement: nextStep)
//                }
//            }
//        }
//        return []
//    }

    private func parseNodes(map: [[Int]]) -> (start: Node, end: Node) {
        var nodes = Set<Node>()

        func createNode(x: Int, y: Int) -> Node? {
            if let existing = nodes.get(x: x, y: y) { return existing }
            guard let value = map.valueFor(x: x, y: y) else { return nil }
            return Node(position: Position(x: x, y: y), value: value)
        }

        func insertNeighbors(for node: Node) {
            node.neighbors = [
                createNode(x: node.position.x + 1, y: node.position.y),
                createNode(x: node.position.x - 1, y: node.position.y),
                createNode(x: node.position.x, y: node.position.y + 1),
                createNode(x: node.position.x, y: node.position.y - 1)
            ].compactMap { $0 }
        }

        for y in (0..<map.count) {
            for x in (0..<map[y].count) {
                let node = createNode(x: x, y: y)!
                insertNeighbors(for: node)
                nodes.insert(node)
            }
        }

        let startNode = nodes.first(where: { $0.position == Position(x: 0, y: 0) })!
        let endNode = nodes.first(where: { $0.position == Position(x: map[0].count - 1, y: map.count - 1) })!

        return (start: startNode, end: endNode)
    }
}

// MARK: - Private types / extensions

private extension Set where Element == Node {
    func get(x: Int, y: Int) -> Node? {
        first(where: { $0.position == Position(x: x, y: y) })
    }
}

private extension Array where Element == [Int] {
    func valueFor(x: Int, y: Int) -> Int? {
        guard y >= 0, y < count, x >= 0, x < self[y].count else { return nil }
        return self[y][x]
    }
}

private struct Position: Hashable {
    let x: Int
    let y: Int
}

private class Node: Hashable {
    let position: Position
    let value: Int
    var parent: Node? = nil
    var neighbors = [Node]()

    init(position: Position, value: Int) {
        self.position = position
        self.value = value
    }

    func cost(from fromNode: Node) -> Int {
        value +
        (position.x - fromNode.position.x) +
        (position.y - fromNode.position.y)
    }

    static func ==(lhs: Node, rhs: Node) -> Bool {
        lhs.position == rhs.position
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
    }
}

private class Step {
    let node: Node
    var previous: Step?
    let index: Int

    let stepCost: Int
    let goalCost: Int

    init(to destination: Node, stepCost: Cost, goalCost: Int) {
        node = destination
        self.stepCost = stepCost
        self.goalCost = goalCost
        index = 0
    }

    init(from previous: Step, to node: Node, stepCost: Int, goalCost: Int) {
        (self.node, self.previous) = (node, previous)
        self.stepCost = stepCost
        self.goalCost = goalCost
        index = previous.index + 1
    }

    func cost() -> Int {
        stepCost + goalCost
    }
}
