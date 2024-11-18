import Foundation

private typealias GroupAnswer = [[Character]]

extension Year2020.Day6: Runnable {
    func run(input: String) {
        let groupAnswers = readAnswers(from: input)
        part1(answers: groupAnswers)
        part2(answers: groupAnswers)
    }

    private func part1(answers: [GroupAnswer]) {
        let uniqueAnswers = answers.map { $0.flatMap { $0 } }.map(Set.init)
        let numberOfAnswers = uniqueAnswers.reduce(0, { $0 + $1.count })
        printResult(dayPart: 1, message: "Number of questions anyone in the group answered yes to: \(numberOfAnswers)")
    }

    private func part2(answers: [GroupAnswer]) {
        let questionsAllAnsweredYesTo = answers.reduce(0, { result, groupAnswers in
            guard let firstPerson = groupAnswers.first else { return result }

            return result + firstPerson.reduce(0, { result, answer in
                result + (groupAnswers.allSatisfy({ $0.contains(answer) }) ? 1 : 0)
            })
        })

        printResult(dayPart: 2, message: "Number of questions everyone in the group answered yes to: \(questionsAllAnsweredYesTo)")
    }
}

// MARK: - Parsing

extension Year2020.Day6 {
    private func readAnswers(from input: String) -> [GroupAnswer] {
        var answers = [[String]]()
        var groupsFound = 0

        for line in splitInput(input, omittingEmptySubsequences: false) {
            if line.isEmpty {
                groupsFound += 1
                continue
            }

            if answers.count > groupsFound, !answers[groupsFound].isEmpty {
                answers[groupsFound].append(line)
            } else {
                answers.append([line])
            }
        }

        return answers.map { $0.map(Array.init) }
    }
}
