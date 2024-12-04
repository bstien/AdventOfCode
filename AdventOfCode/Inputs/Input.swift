import Foundation

struct Input {
    static let inputURL = URL(fileURLWithPath: #file).deletingLastPathComponent()

    static func get(_ file: String) throws -> String {
        let inputData = try Data(contentsOf: inputURL.appendingPathComponent(file))
        return String(decoding: inputData, as: UTF8.self)
    }
}
