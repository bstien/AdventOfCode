import Foundation

extension Year2022.Day8: Runnable {
    func run(input: String) {
        let forest = splitInput(input).map { $0.map { Int(String($0))! } }
        let width = forest.first!.count
        let height = forest.count

        var visibleTrees = Set<VisibleTree>()
        let widthRange = (0..<width)
        let heightRange = (0..<height)
        Direction.allCases.forEach { direction in
            var position = direction.startPosition(width: width, height: height)

            var lastVisibleTreeHeight = -1
            repeat {
                if !heightRange.contains(position.y) || !widthRange.contains(position.x) {
                    lastVisibleTreeHeight = -1
                    position = direction.nextRowPosition(from: position, width: width, height: height)
                }

                guard let tree = forest.tree(for: position) else { break }

                if tree > lastVisibleTreeHeight {
                    lastVisibleTreeHeight = tree
                    visibleTrees.insert(VisibleTree(position: position, height: tree))

                    if tree == 9 {
                        lastVisibleTreeHeight = -1
                        position = direction.nextRowPosition(from: position, width: width, height: height)
                        continue
                    }
                }

                position = direction.nextPosition(from: position)
            } while true
        }

        printResult(dayPart: 1, message: "Number of visible trees: \(visibleTrees.count)")
    }
}

private extension Array where Element == [Int] {
    func tree(for position: Year2022.Day8.Position) -> Int? {
        guard indices.contains(position.y), self[position.y].indices.contains(position.x) else {
            return nil
        }
        return self[position.y][position.x]
    }
}

private extension Year2022.Day8 {
    struct Position: Hashable {
        let x: Int
        let y: Int
    }

    enum Direction: CaseIterable {
        case top, left, right, bottom

        func startPosition(width: Int, height: Int) -> Position {
            switch self {
            case .top: return Position(x: 0, y: 0)
            case .left: return Position(x: 0, y: 0)
            case .right: return Position(x: width - 1, y: 0)
            case .bottom: return Position(x: 0, y: height - 1)
            }
        }

        func nextPosition(from currentPosition: Position) -> Position {
            switch self {
            case .top: return Position(x: currentPosition.x, y: currentPosition.y + 1)
            case .left: return Position(x: currentPosition.x + 1, y: currentPosition.y)
            case .right: return Position(x: currentPosition.x - 1, y: currentPosition.y)
            case .bottom: return Position(x: currentPosition.x, y: currentPosition.y - 1)
            }
        }

        func nextRowPosition(from currentPosition: Position, width: Int, height: Int) -> Position {
            switch self {
            case .top: return Position(x: currentPosition.x + 1, y: 0)
            case .left: return Position(x: 0, y: currentPosition.y + 1)
            case .right: return Position(x: width - 1, y: currentPosition.y + 1)
            case .bottom: return Position(x: currentPosition.x + 1, y: height - 1)
            }
        }
    }

    struct VisibleTree: Hashable {
        let position: Position
        let height: Int
    }
}
