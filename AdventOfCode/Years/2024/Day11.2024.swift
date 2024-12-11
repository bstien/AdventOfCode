import Foundation

extension Year2024.Day11: Runnable {
    func run(input: String) {
        let stones = splitInput(input.trimmingCharacters(in: .whitespacesAndNewlines), separatedBy: " ").compactMap(Int.init)

        part1(stones: stones)
        part2(stones: stones)
    }

    private func part1(stones: [Int]) {
        let stoneCount = calculateStones(stones: stones, iterations: 25)
        printResult(dayPart: 1, message: "# of stones: \(stoneCount)")
    }

    private func part2(stones: [Int]) {
        let stoneCount = calculateStones(stones: stones, iterations: 75)
        printResult(dayPart: 2, message: "# of stones: \(stoneCount)")
    }

    private func calculateStones(stones: [Int], iterations: Int) -> Int {
        var blink = 0
        var stones = stones.reduce(into: [Int: Int](), { $0[$1, default: 0] += 1 })

        repeat {
            let currentStones = stones
            for stone in currentStones {
                // If the stone is engraved with the number 0, it is replaced by a stone engraved with the number 1.
                // If the stone is engraved with a number that has an even number of digits, it is replaced by two stones. The left half of the digits are engraved on the new left stone, and the right half of the digits are engraved on the new right stone. (The new numbers don't keep extra leading zeroes: 1000 would become stones 10 and 0.)
                // If none of the other rules apply, the stone is replaced by a new stone; the old stone's number multiplied by 2024 is engraved on the new stone.
                if stone.key == 0 {
                    stones[1, default: 0] += stone.value
                } else if String(stone.key).count.isMultiple(of: 2) {
                    // Holy crap, this SUCKS...!
                    let stringStone = String(stone.key)
                    let leftHalf = Int(String(stringStone.prefix(stringStone.count / 2))) ?? 0
                    let rightHalf = Int(String(stringStone.suffix(stringStone.count / 2))) ?? 0
                    stones[leftHalf, default: 0] += stone.value
                    stones[rightHalf, default: 0] += stone.value
                } else {
                    let newKey = stone.key * 2024
                    stones[newKey, default: 0] += stone.value
                }

                stones[stone.key, default: 0] -= stone.value
            }
            blink += 1
        } while blink < iterations

        return stones.values.reduce(0, +)
    }
}
