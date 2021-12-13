import Foundation

extension Year2020.Day11: Runnable {
    func run(input: String) {
        let floorMap = splitInput(input).map { $0.map(Int.floorTile(from:)) }
        //        part1(floorMap: floorMap)
        // TODO: Part 2 is not finished
        part2(floorMap: floorMap)
    }

    private func part1(floorMap: FloorMap) {
        let height = floorMap.count
        let width = floorMap.first!.count

        var floorMap = floorMap
        var hasDoneChanges = false

        repeat {
            var changes = floorMap
            hasDoneChanges = false
            (0..<height).forEach({ y in
                (0..<width).forEach({ x in
                    if shouldChangePart1(seat: (y: y, x: x), floorMap: floorMap, height: height, width: width) {
                        changes[y][x] = -floorMap[y][x]
                        hasDoneChanges = true
                    }
                })
            })

            floorMap = changes
        } while hasDoneChanges

        let takenSeats = floorMap.map { row in
            row.filter { $0 == 1 }.reduce(0, +)
        }.reduce(0, +)

        printResult(dayPart: 1, message: "Number of taken seats after iterating: \(takenSeats)")
    }

    private func shouldChangePart1(seat: Seat, floorMap: FloorMap, height: Int, width: Int) -> Bool {
        let seatValue = floorMap[seat.y][seat.x]

        if seatValue == 0 { return false }
        var adjacentSeatsTaken = 0

        var y = seat.y - 1
        repeat {
            defer { y += 1 }
            if y < 0 || y >= height { continue }

            var x = seat.x - 1
            repeat {
                defer { x += 1 }
                if x < 0 || x >= width || (x == seat.x && y == seat.y) { continue }
                if floorMap[y][x] == 1 {
                    adjacentSeatsTaken += 1
                }
            } while x <= seat.x + 1
        } while y <= seat.y + 1

        if seatValue == 1 {
            return adjacentSeatsTaken >= 4
        }
        return adjacentSeatsTaken == 0
    }

    private func part2(floorMap: FloorMap) {
        let height = floorMap.count
        let width = floorMap.first!.count

        var floorMap = floorMap
        var hasDoneChanges = false

        repeat {
            var changes = floorMap
            hasDoneChanges = false
            (0..<height).forEach({ y in
                (0..<width).forEach({ x in
                    if shouldChangePart2(seat: (y: y, x: x), floorMap: floorMap, height: height, width: width) {
                        changes[y][x] = -floorMap[y][x]
                        hasDoneChanges = true
                    }
                })
            })

            floorMap = changes
        } while hasDoneChanges

        let takenSeats = floorMap.map { row in
            row.filter { $0 == 1 }.reduce(0, +)
        }.reduce(0, +)

        printResult(dayPart: 2, message: "Number of taken seats after iterating: \(takenSeats)")
    }


    private func shouldChangePart2(seat: Seat, floorMap: FloorMap, height: Int, width: Int) -> Bool {
        let seatValue = floorMap[seat.y][seat.x]

        if seatValue == 0 { return false }
        var adjacentSeatsTaken = 0

        func checkSeat(seat: Seat) -> Int {
            if seat.y < 0 || seat.x < 0 { return 0 }
            if seat.y >= height || seat.x >= width { return 0 }
            return floorMap[seat.y][seat.x] == 1 ? 1 : 0
        }

        let largestSide = max(width, height)
        var offset = 1
        repeat {
            adjacentSeatsTaken += [
                // Horizontal
                checkSeat(seat: Seat(y: seat.y, x: seat.x + offset)),
                checkSeat(seat: Seat(y: seat.y, x: seat.x - offset)),

                // Vertical
                checkSeat(seat: Seat(y: seat.y + offset, x: seat.x)),
                checkSeat(seat: Seat(y: seat.y + offset, x: seat.x)),

                // Horizontals
                checkSeat(seat: Seat(y: seat.y + offset, x: seat.x + offset)),
                checkSeat(seat: Seat(y: seat.y - offset, x: seat.x - offset)),
                checkSeat(seat: Seat(y: seat.y + offset, x: seat.x - offset)),
                checkSeat(seat: Seat(y: seat.y - offset, x: seat.x + offset)),
            ].reduce(0, +)
            offset += 1
        } while offset < largestSide

        if seatValue == 1 {
            return adjacentSeatsTaken >= 5
        }
        return adjacentSeatsTaken == 0
    }
}

// MARK: - Types

private typealias FloorMap = [[Int]]
private typealias Seat = (y: Int, x: Int)

private extension Int {
    static func floorTile(from value: Character) -> Int {
        switch value {
        case ".": return 0
        case "L": return -1
        case "#": return 1
        default: fatalError("Could not parse value: '\(value)'")
        }
    }
}

// MARK: - Debug

private extension Year2020.Day11 {
    func printFloorMap(_ floorMap: FloorMap) {
        let toPrint = floorMap.map { String($0.map { $0.toFloorTile }) }.joined(separator: "\n")
        print(toPrint)
        print("------\n\n")
    }
}

private extension Int {
    var toFloorTile: Character {
        switch self {
        case 0: return "."
        case -1: return "L"
        case 1: return "#"
        default: fatalError("Could not return tile from self: '\(self)'")
        }
    }
}
