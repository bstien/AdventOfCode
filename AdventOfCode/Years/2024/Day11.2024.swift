import Foundation

extension Year2024.Day11: Runnable {
    func run(input: String) {
        let stones = splitInput(input.trimmingCharacters(in: .whitespacesAndNewlines), separatedBy: " ").compactMap(Int.init)

        part1(stones: stones)
    }

    private func part1(stones: [Int]) {
        var blink = 0
        var stones = stones

        // If the stone is engraved with the number 0, it is replaced by a stone engraved with the number 1.
        // If the stone is engraved with a number that has an even number of digits, it is replaced by two stones. The left half of the digits are engraved on the new left stone, and the right half of the digits are engraved on the new right stone. (The new numbers don't keep extra leading zeroes: 1000 would become stones 10 and 0.)
        // If none of the other rules apply, the stone is replaced by a new stone; the old stone's number multiplied by 2024 is engraved on the new stone.
        repeat {
            for index in stride(from: stones.endIndex - 1, through: 0, by: -1) {
                let stone = stones[index]

                if stone == 0 {
                    stones[index] = 1
                } else if String(stone).count.isMultiple(of: 2) {
                    let stringStone = String(stone)
                    let leftHalf = Int(String(stringStone.prefix(stringStone.count / 2))) ?? 0
                    let rightHalf = Int(String(stringStone.suffix(stringStone.count / 2))) ?? 0
                    stones[index] = leftHalf
                    stones.insert(rightHalf, at: index + 1)
                } else {
                    stones[index] = stone * 2024
                }
            }
            blink += 1
        } while blink < 25

        printResult(dayPart: 1, message: "# of stones: \(stones.count)")
    }
}
