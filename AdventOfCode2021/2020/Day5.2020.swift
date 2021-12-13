import Foundation

private struct Seat {
    let row: Int
    let column: Int
    var seatId: Int { row * 8 + column }
}

extension Year2020.Day5: Runnable {
    func run(input: String) {
        let seats = splitInput(input).map(parseSeat)
        part1(seats: seats)
        part2(seats: seats)
    }

    private func part1(seats: [Seat]) {
        let highestId = seats.map(\.seatId).max()
        printResult(dayPart: 1, message: "Highest seat ID: \(highestId!)")
    }

    private func part2(seats: [Seat]) {
        let takenSeatIds = seats.map(\.seatId).sorted()

        guard
            let minId = takenSeatIds.first,
                let maxId = takenSeatIds.last,
                let mySeat = (minId...maxId).filter({ !takenSeatIds.contains($0) }).first
            else {
            printResult(result: .fail, dayPart: 2, message: "Could not find my seath ☹️")
            return
        }

        printResult(dayPart: 2, message: "My seat ID: \(mySeat)")
    }
}

// MARK: - Parsing

extension Year2020.Day5 {
    private func parseSeat(from line: String) -> Seat {
        var rowHigh = 127
        var rowLow = 0
        var colHigh = 7
        var colLow = 0

        for char in Array(line) {
            switch char {
            case "F":
                rowHigh = rowHigh - (rowHigh - rowLow) / 2 - 1
            case "B":
                rowLow = rowLow + (rowHigh - rowLow) / 2 + 1
            case "L":
                colHigh = colHigh - (colHigh - colLow) / 2 - 1
            case "R":
                colLow = colLow + (colHigh - colLow) / 2 + 1
            default: break
            }
        }

        return Seat(row: rowLow, column: colLow)
    }
}
