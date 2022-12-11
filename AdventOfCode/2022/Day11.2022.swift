import Foundation

extension Year2022.Day11: Runnable {
    func run(input: String) {
        let monkeys = splitInput(input, separatedBy: "\n\n").map { splitInput($0) }.map(parseMonkey(lines:))

        for _ in (0..<20) {
            for monkey in monkeys {
                let items = monkey.items
                monkey.items = []

                monkey.inspections += items.count
                for item in items {
                    let worryLevel = monkey.operation.calculate(worryLevel: item) / 3
                    if worryLevel % monkey.divisionTest == 0 {
                        monkeys.first(where: { $0.id == monkey.divisionTestResult.isTrue })?.items.append(worryLevel)
                    } else {
                        monkeys.first(where: { $0.id == monkey.divisionTestResult.isFalse })?.items.append(worryLevel)
                    }
                }
            }
        }

        let topInspections = monkeys.map(\.inspections).sorted(by: { $0 > $1 }).prefix(2).reduce(1, *)
        printResult(dayPart: 1, message: "Product of top two inspection monkeys: \(topInspections)")
    }

    private func parseMonkey(lines: [String]) -> Monkey {
        let idString = lines[0].components(separatedBy: .init(charactersIn: " :"))[1]
        let id = Int(idString)!

        let items = lines[1].components(separatedBy: ": ")[1].components(separatedBy: ", ").compactMap(Int.init)

        let operationComponents = lines[2].components(separatedBy: "= old ")[1].components(separatedBy: " ")
        let rightOperand = RightOperand(value: operationComponents[1])
        let operation = Operation(string: operationComponents[0], operand: rightOperand)

        let divisionTestString = lines[3].components(separatedBy: "by ")[1]
        let divisionTest = Int(divisionTestString)!

        let isTrueString = lines[4].components(separatedBy: "monkey ")[1]
        let isTrue = Int(isTrueString)!

        let isFalseString = lines[5].components(separatedBy: "monkey ")[1]
        let isFalse = Int(isFalseString)!

        let testResult = TestResult(isTrue: isTrue, isFalse: isFalse)

        return Monkey(id: id, items: items, divisionTest: divisionTest, divisionTestResult: testResult, operation: operation)
    }
}

private extension Year2022.Day11 {
    class Monkey {
        let id: Int
        var items: [Int]
        let divisionTest: Int
        let divisionTestResult: TestResult
        let operation: Operation
        var inspections = 0

        init(id: Int, items: [Int], divisionTest: Int, divisionTestResult: TestResult, operation: Operation) {
            self.id = id
            self.items = items
            self.divisionTest = divisionTest
            self.divisionTestResult = divisionTestResult
            self.operation = operation
        }
    }

    enum Operation {
        case add(RightOperand)
        case multiply(RightOperand)

        init(string: String, operand: RightOperand) {
            if string == "+" {
                self = .add(operand)
            } else if string == "*" {
                self = .multiply(operand)
            } else {
                fatalError("Could not read Operation from '\(string)'")
            }
        }

        func calculate(worryLevel: Int) -> Int {
            switch self {
            case .add(let operand):
                switch operand {
                case .value(let value):
                    return worryLevel + value
                case .oldValue:
                    return worryLevel + worryLevel
                }
            case .multiply(let operand):
                switch operand {
                case .value(let value):
                    return worryLevel * value
                case .oldValue:
                    return worryLevel * worryLevel
                }
            }
        }
    }

    enum RightOperand {
        case value(Int)
        case oldValue

        init(value: String) {
            if value == "old" {
                self = .oldValue
            } else if let value = Int(value) {
                self = .value(value)
            } else {
                fatalError("Could not read RightOperand from '\(value)'")
            }
        }
    }

    struct TestResult {
        let isTrue: Int
        let isFalse: Int
    }
}
