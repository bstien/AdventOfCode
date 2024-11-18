import Foundation

extension Year2021.Day12: Runnable {
    func run(input: String) {
        guard let startNode = parseNodes(input: input).first(where: { $0.kind == .start }) else {
            printResult(result: .fail, dayPart: 1, message: "Couldn't find start node 😖")
            return
        }

        let part1 = traverse(from: startNode)
        let part2 = traverse(from: startNode, visitSmallNodeTwice: true)

        printResult(dayPart: 1, message: "# of paths, visiting small caves max once: \(part1)")
        printResult(dayPart: 2, message: "# of paths, visiting one small cave at max twice: \(part2)")
    }

    private func traverse(
        from thisNode: CaveNode,
        dontVisit: Set<CaveNode> = [],
        visitSmallNodeTwice: Bool = false
    ) -> Int {
        guard (visitSmallNodeTwice && thisNode.kind != .start) || !dontVisit.contains(thisNode) else {
            return 0
        }

        if thisNode.kind == .end {
            return 1
        }

        var visitSmallNodeTwice = visitSmallNodeTwice
        if visitSmallNodeTwice, dontVisit.contains(thisNode) {
            visitSmallNodeTwice = false
        }

        var dontVisit = dontVisit
        if thisNode.kind == .small || thisNode.kind == .start {
            dontVisit.insert(thisNode)
        }

        return thisNode.neighbors.map {
            traverse(from: $0, dontVisit: dontVisit, visitSmallNodeTwice: visitSmallNodeTwice)
        }.reduce(0, +)
    }

    private func parseNodes(input: String) -> Set<CaveNode> {
       let pairs = splitInput(input).map { splitInput($0, separatedBy: "-") }
        return pairs.reduce(into: Set<CaveNode>()) { set, pair in
            let a = set.getOrCreate(id: pair[0])
            let b = set.getOrCreate(id: pair[1])
            a.neighbors.insert(b)
            b.neighbors.insert(a)
        }
    }
}

// MARK: - Private types / extensions

private enum NodeKind: Hashable {
    case start
    case small
    case big
    case end
}

private class CaveNode: Hashable {
    let id: String
    let kind: NodeKind
    var neighbors: Set<CaveNode> = []

    init(id: String, kind: NodeKind) {
        self.id = id
        self.kind = kind
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: CaveNode, rhs: CaveNode) -> Bool {
        lhs.id == rhs.id
    }
}

private extension Set where Element == CaveNode {
    mutating func getOrCreate(id: String) -> CaveNode {
        if let match = self.first(where: { $0.id == id }) {
            return match
        }

        let kind: NodeKind
        switch id {
        case "start":
            kind = .start
        case "end":
            kind = .end
        case let x where x == x.lowercased():
            kind = .small
        default:
            kind = .big
        }

        let node = CaveNode(id: id, kind: kind)
        insert(node)
        return node
    }
}
