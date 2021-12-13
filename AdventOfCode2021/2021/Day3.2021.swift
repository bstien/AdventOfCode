import Foundation

extension Year2021.Day3: Runnable {
    func run(input: String) {
        let inputList = splitInput(input).map { $0.asBoolList }
        part1(inputList: inputList)
        part2(inputList: inputList)
    }

    private func part1(inputList: [[Bool]]) {
        let summed = inputList
            .first!
            .enumerated()
            .map { index, _ -> [Bool] in inputList.map { $0[index] } } // Create a new array consisting of each column.
            .map { list -> Bool in list.filter { $0 }.count >= (list.count / 2) } // Reduce to the value that is represented in more than half of the array.
        let gammaRate = summed.convertToInt
        let epsilonRate = summed.flipBools.convertToInt

        printResult(dayPart: 1, message: "Gamma (\(gammaRate)) * epsilon (\(epsilonRate)) = \(gammaRate * epsilonRate)")
    }

    private func part2(inputList: [[Bool]]) {
        let oxygenGeneratorRating = reduce(inputList, strategy: .keepHigherOrTrue)
        let co2ScrubberRating = reduce(inputList, strategy: .keepLowerOrFalse)

        printResult(dayPart: 2, message: "Oxygen (\(oxygenGeneratorRating)) * CO2 (\(co2ScrubberRating)) = \(oxygenGeneratorRating * co2ScrubberRating)")
    }

    private func reduce(_ inputList: [[Bool]], strategy: Strategy) -> Int {
        var currentIndex = 0
        var list = inputList

        while true {
            var trueList = [[Bool]]()
            var falseList = [[Bool]]()

            list.forEach {
                if $0[currentIndex] {
                    trueList.append($0)
                } else {
                    falseList.append($0)
                }
            }

            if strategy == .keepHigherOrTrue {
                list = trueList.count >= falseList.count ? trueList : falseList
            } else {
                list = trueList.count < falseList.count ? trueList : falseList
            }

            currentIndex += 1
            if list.count == 1 || list.first?.count == currentIndex { break }
        }

        guard let result = list.first else {
            printResult(result: .fail, dayPart: 2, message: "Could not find a matching result.")
            fatalError()
        }
        return result.convertToInt
    }
}

// MARK: - Private types/extensions

private enum Strategy {
    case keepHigherOrTrue
    case keepLowerOrFalse
}

private extension String {
    var asBoolList: [Bool] {
        map { $0 == "1" }
    }
}

private extension Array where Element == Bool {
    var convertToInt: Int {
        let joined = map { $0 ? "1" : "0" }.joined()
        return Int(joined, radix: 2)!
    }

    var flipBools: [Bool] {
        map { !$0 }
    }
}
