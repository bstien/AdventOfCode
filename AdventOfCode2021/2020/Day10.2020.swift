import Foundation

extension Year2020.Day10: Runnable {
    func run(input: String) {
        var adapters = splitInput(input).compactMap(Int.init).sorted()
        adapters = [0] + adapters + [adapters.max()! + 3]

        part1(adapters: adapters)
        part2(adapters: adapters)
    }

    func part1(adapters: [Int]) {
        var previousAdapter = adapters.first!
        var joltDifference = [Int: Int]()

        for adapter in adapters {
            let diff = adapter - previousAdapter
            joltDifference[diff, default: 0] += 1
            previousAdapter = adapter
        }

        let result = joltDifference[1, default: 0] * joltDifference[3, default: 0]
        printResult(dayPart: 1, message: "Joltdifferences multiplied: \(result)")
    }

    func part2(adapters: [Int]) {
        func traverse(fromIndex: Int) -> Int {
            let adapter = adapters[fromIndex]
            var index = fromIndex + 1

            if index == adapters.count { return 1 }

            var count = 0
            repeat {
                count += traverse(fromIndex: index)
                index += 1
            } while index < adapters.count && adapters[index] - adapter <= 3

            return count
        }

        let adapterCount = adapters.count
        var sums = Array(repeating: 0, count: adapterCount)

        sums[adapterCount - 1] = traverse(fromIndex: adapterCount - 1)
        sums[adapterCount - 2] = traverse(fromIndex: adapterCount - 2)
        sums[adapterCount - 3] = traverse(fromIndex: adapterCount - 3)

        var startIndex = adapterCount - 4
        repeat {
            defer { startIndex -= 1 }
            var currentIndex = startIndex + 1
            repeat {
                sums[startIndex] += sums[currentIndex]
                currentIndex += 1
            } while adapters[currentIndex] - adapters[startIndex] <= 3
        } while startIndex >= 0

        let result = sums[0]
        printResult(dayPart: 2, message: "Number of unique adapter combinations: \(result)")
    }
}
