import Foundation

extension Year2022.Day7: Runnable {
    func run(input: String) {
        let lines = splitInput(input)
        let rootFolder = traverseFilesystem(lines: lines)

        let sizeOfSmallFolders = sizeOfFolders(within: rootFolder).filter { $0 <= 100_000 }.reduce(0, +)
        printResult(dayPart: 1, message: "Size of small folders: \(sizeOfSmallFolders)")

        let amountToDelete = 30_000_000 - (70_000_000 - rootFolder.size)
        let sizeOfFolderToDelete = sizeOfFolders(within: rootFolder).sorted().first { $0 >= amountToDelete }!
        printResult(dayPart: 2, message: "Size of folder to delete: \(sizeOfFolderToDelete)")
    }

    private func sizeOfFolders(within folder: Folder) -> [Int] {
        folder.childFolders.map(\.size) + folder.childFolders.flatMap { sizeOfFolders(within: $0) }
    }

    private func traverseFilesystem(lines: [String]) -> Folder {
        var lineIndex = 0
        var rootFolder: Folder?
        var currentFolder: Folder?

        repeat {
            let line = lines[lineIndex]
            let command = Command(line: line)

            switch command {
            case .cd(let argument):
                if currentFolder != nil {
                    if argument == ".." {
                        currentFolder = currentFolder?.parent
                    } else {
                        currentFolder = currentFolder?.findFolder(with: argument)
                    }
                } else {
                    rootFolder = Folder(name: argument)
                    currentFolder = rootFolder
                }
                lineIndex += 1
            case .ls:
                var children = [SizeCalculatable]()
                var nextLine = lineIndex + 1

                repeat {
                    let line = lines[nextLine]

                    if line.hasPrefix("$") {
                        break
                    }

                    children.append(parseOutput(line: line, parent: currentFolder))
                    nextLine += 1
                } while nextLine < lines.count

                currentFolder?.children = children
                lineIndex = nextLine
            }
        } while lineIndex < lines.count

        guard let rootFolder else { fatalError("Wasn't able to parse rootFolder") }
        return rootFolder
    }

    private func parseOutput(line: String, parent: Folder?) -> SizeCalculatable {
        let components = line.components(separatedBy: " ")

        if components[0] == "dir" {
            return Folder(name: components[1], parent: parent)
        } else {
            guard let size = Int(components[0]) else {
                fatalError("Could not map '\(components[0])' to Int")
            }
            return File(name: components[1], size: size)
        }
    }
}

private protocol SizeCalculatable {
    var size: Int { get }
}

private extension Year2022.Day7 {
    enum Command {
        case ls
        case cd(dir: String)

        init(line: String) {
            let components = line.components(separatedBy: " ")

            if components[1] == "ls" {
                self = .ls
            } else if components[1] == "cd" {
                self = .cd(dir: components[2])
            } else {
                fatalError("No command matching '\(line)'")
            }
        }
    }

    struct File: SizeCalculatable {
        let name: String
        let size: Int

        init(name: String, size: Int) {
            self.name = name
            self.size = size
        }
    }

    class Folder: SizeCalculatable {
        let name: String
        var parent: Folder?
        var children = [SizeCalculatable]()

        var childFolders: [Folder] {
            children.compactMap { $0 as? Folder }
        }

        var size: Int {
            children.map(\.size).reduce(0, +)
        }

        init(name: String, parent: Folder? = nil) {
            self.name = name
            self.parent = parent
        }

        func findFolder(with folderName: String) -> Folder {
            guard let folder = children.compactMap({ $0 as? Folder }).first(where: { $0.name == folderName }) else {
                fatalError("Folder '\(name)' doesn't have a child folder with name '\(folderName)'")
            }
            return folder
        }
    }
}
