import Foundation

private typealias GivenNumbers = [Int]
private typealias Board = [BoardNumber]

struct Day4: Day {
    static func run(input: String) {
        let inputList = splitInput(input)
        let givenNumbers = inputList.givenNumbers()
        let boards = inputList.boards()

        part1(givenNumbers: givenNumbers, boards: boards)
    }

    private static func part1(givenNumbers: GivenNumbers, boards: [Board]) {
        for (index, givenNumber) in givenNumbers.enumerated() {
            markBoards(number: givenNumber, boards: boards)

            if index >= 5 {
                if let winningBoard = boards.first(where: { checkWins(board: $0) }) {
                    let sumOfUnmarkedNumbers = winningBoard.sumOfUnmarkedNumbers
                    let multiplied = sumOfUnmarkedNumbers * givenNumber
                    printResult(dayPart: 1, message: "Unmarked numbers (\(sumOfUnmarkedNumbers)) * givenNumber (\(givenNumber)) = \(multiplied)")
                    return
                }
            }
        }
    }

    private static func markBoards(number: Int, boards: [Board]) {
        boards.forEach {
            $0.filter { $0.value == number }.forEach { $0.isMarked = true }
        }
    }

    private static func checkWins(board: Board) -> Bool {
        // Horizontal
        let verticalWin = stride(from: 0, through: 20, by: 5).contains(where: { index in
            return checkWin(board: board, startIndex: index, increment: { $0 + 1 })
        })

        if verticalWin { return true }

        return (0..<5).contains(where: { index in
            checkWin(board: board, startIndex: index, increment: { $0 + 5 })
        })
    }

    private static func checkWin(board: Board, startIndex: Int, increment: (Int) -> Int) -> Bool {
        var currentIndex = startIndex
        for _ in 0..<5 {
            if !board.indices.contains(currentIndex) || !board[currentIndex].isMarked {
                return false
            }

            currentIndex = increment(currentIndex)
        }
        return true
    }
}

// MARK: - Private types/extensions

private extension Board {
    var sumOfUnmarkedNumbers: Int {
        filter { !$0.isMarked }.map(\.value).reduce(0, +)
    }
}

private class BoardNumber {
    let value: Int
    var isMarked: Bool = false

    init(value: Int) { self.value = value }
}

private extension Array where Element == String {
    func givenNumbers() -> GivenNumbers {
        first?.split(separator: ",").compactMap { Int($0) } ?? []
    }

    func boards() -> [Board] {
        var currentIndex = 1
        var boards = [Board]()

        while currentIndex < count {
            let lines = self[currentIndex...currentIndex+4]
            let newBoard = lines
                .map { $0.split(separator: " ") }
                .flatMap { $0 }
                .compactMap { Int($0) }
                .map(BoardNumber.init(value:))
            boards.append(newBoard)
            currentIndex += 5
        }
        return boards
    }
}
