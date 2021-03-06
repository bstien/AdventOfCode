import Foundation

private typealias GivenNumbers = [Int]
private typealias Board = [BoardNumber]
private typealias WinResult = (lastNumber: Int, board: Board)

extension Year2021.Day4: Runnable {
    func run(input: String) {
        let inputList = splitInput(input)
        let givenNumbers = inputList.givenNumbers()
        let boards = inputList.boards()

        part1(givenNumbers: givenNumbers, boards: boards)
        part2(givenNumbers: givenNumbers, boards: boards)
    }

    private func part1(givenNumbers: GivenNumbers, boards: [Board]) {
        let winResult = play(givenNumbers: givenNumbers, boards: boards)
        printResult(winResult: winResult, dayPart: 1)
    }

    private func part2(givenNumbers: GivenNumbers, boards: [Board]) {
        var boards = boards
        var lastWinResult: WinResult?
        while true {
            if let winResult = play(givenNumbers: givenNumbers, boards: boards) {
                if boards.count == 1 {
                    lastWinResult = winResult
                    break
                } else {
                    boards.removeAll(where: { $0 == winResult.board })
                    continue
                }
            }
            break
        }

        printResult(winResult: lastWinResult, dayPart: 2)
    }

    private func printResult(winResult: WinResult?, dayPart: Int) {
        guard let winResult = winResult else {
            printResult(result: .fail, dayPart: dayPart, message: "Couldn't find the last winning board 🙁")
            return
        }

        let sumOfUnmarkedNumbers = winResult.board.sumOfUnmarkedNumbers
        let multiplied = sumOfUnmarkedNumbers * winResult.lastNumber
        printResult(dayPart: dayPart, message: "Unmarked numbers (\(sumOfUnmarkedNumbers)) * lastNumber (\(winResult.lastNumber)) = \(multiplied)")
    }

    private func play(givenNumbers: GivenNumbers, boards: [Board]) -> WinResult? {
        for (index, givenNumber) in givenNumbers.enumerated() {
            markBoards(number: givenNumber, boards: boards)

            if index >= 5 {
                if let winningBoard = boards.first(where: { checkWins(board: $0) }) {
                    return (lastNumber: givenNumber, board: winningBoard)
                }
            }
        }
        return nil
    }

    private func markBoards(number: Int, boards: [Board]) {
        boards.forEach {
            $0.filter { $0.value == number }.forEach { $0.isMarked = true }
        }
    }

    private func checkWins(board: Board) -> Bool {
        let verticalWin = stride(from: 0, through: 20, by: 5).contains(where: { index in
            checkWin(board: board, startIndex: index, increment: { $0 + 1 })
        })

        if verticalWin { return true }

        return (0..<5).contains(where: { index in
            checkWin(board: board, startIndex: index, increment: { $0 + 5 })
        })
    }

    private func checkWin(board: Board, startIndex: Int, increment: (Int) -> Int) -> Bool {
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

private class BoardNumber: Equatable {
    let value: Int
    var isMarked: Bool = false

    init(value: Int) { self.value = value }

    static func ==(lhs: BoardNumber, rhs: BoardNumber) -> Bool {
        lhs.value == rhs.value && lhs.isMarked == rhs.isMarked
    }
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
