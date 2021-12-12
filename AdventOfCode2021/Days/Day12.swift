import Foundation

struct Day12: Day {
    static func run(input: String) {
        let nodes = parse(input: input)
        guard let startNode = nodes.first(where: { $0.kind == .start }) else {
            printResult(result: .fail, dayPart: 1, message: "Couldn't find start node 😖")
            return
        }

        part1(startNode: startNode)
    }

    private static func part1(startNode: CaveNode) {
        let pathsWithEnding = traverse(from: startNode, dontVisit: [], path: Path(nodes: [])).filter { $0.nodes.last?.kind == .end }
        printResult(dayPart: 1, message: "# of paths, visiting small caves max once: \(pathsWithEnding.count)")
    }

    private static func traverse(
        from thisNode: CaveNode,
        dontVisit: Set<CaveNode>,
        path: Path
    ) -> [Path] {
        if dontVisit.contains(thisNode) {
            return [path]
        }

        let path = path.insertAndCopy(node: thisNode)

        if thisNode.kind == .end {
            return [path]
        }

        var dontVisit = dontVisit
        if thisNode.kind == .small || thisNode.kind == .start {
            dontVisit.insert(thisNode)
        }

        return thisNode.neighbors.flatMap {
            traverse(from: $0, dontVisit: dontVisit, path: path)
        }
    }

    // MARK: - Parsing

    private static func parse(input: String) -> Set<CaveNode> {
       let pairs = splitInput(input).map { splitInput($0, separator: "-") }
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
    var neighbors: Set<CaveNode>

    init(id: String, kind: NodeKind) {
        self.id = id
        self.kind = kind
        neighbors = []
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(kind)
    }

    static func ==(lhs: CaveNode, rhs: CaveNode) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

private struct Path {
    let nodes: [CaveNode]

    func insertAndCopy(node: CaveNode) -> Path {
        Path(nodes: nodes + [node])
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
