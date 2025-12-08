import Foundation

protocol Runnable {
    func run(input: String)
    func run(input: String, isTest: Bool)
}

extension Runnable {
    func run(input: String) {
        fatalError("Missing implementation for \(String(describing: self)).run(input:)")
    }

    func run(input: String, isTest: Bool) {
        self.run(input: input)
    }
}
