import Foundation

extension Year2022.Day13: Runnable {
    func run(input: String) {
        let pairs = splitInput(input).map { Array($0).filter { $0 != "," } }.chunks(ofCount: 2).map(Array.init)

        for pair in pairs {
            let left = pair[0].block()
            let right = pair[1].block()
            _ = traverse(left: left, right: right)
        }
    }

    private func traverse(left: [Character], right: [Character]) -> Bool? {
        if left[0] == "[" && right[0] == "[" {
            return traverse(left: left.block(), right: right.block())
        }

        print("-----------------")
        return nil
    }
}

private typealias List = [Character]

private extension List {
    func block(from start: Int = 0) -> [Character] {
        Array(self[blockRange(from: start)])
    }

    func blockRange(from start: Int) -> ClosedRange<Int> {
        var bracketsSeen = 0
        let bracketClosePosition = self[start..<count].enumerated().first { index, character in
            if character == "[" {
                bracketsSeen += 1
            } else if character == "]" {
                bracketsSeen -= 1
                if bracketsSeen == 0 {
                    return true
                }
            }
            return false
        }!.offset

        return start...bracketClosePosition
    }
}

private struct Node {

}

private extension Character {
    var toInt: Int? {
        Int(String(self))
    }
}
