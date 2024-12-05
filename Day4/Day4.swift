import Foundation

// Function to write the sample grid to an input file
func writeGridToFile(grid: [String], fileName: String) throws {
    let gridContent = grid.joined(separator: "\n")
    let currentDirectoryPath = FileManager.default.currentDirectoryPath
    let fileURL = URL(fileURLWithPath: currentDirectoryPath).appendingPathComponent(fileName)
    try gridContent.write(to: fileURL, atomically: true, encoding: .utf8)
    print("Grid successfully written to \(fileURL.path)")
}

// Function to read the grid from an input file
func readGridFromFile(fileName: String) throws -> [[Character]] {
    let currentDirectoryPath = FileManager.default.currentDirectoryPath
    let fileURL = URL(fileURLWithPath: currentDirectoryPath).appendingPathComponent(fileName)
    let fileContent = try String(contentsOf: fileURL, encoding: .utf8)
    let lines = fileContent.components(separatedBy: .newlines).filter { !$0.isEmpty }
    let grid = lines.map { Array($0) }
    print("Grid successfully read from \(fileURL.path)")
    return grid
}

// Part 1: Function to find all occurrences of "XMAS" in the grid
func findingXMAS(puzzle: [[Character]], word: String) -> Int {
    let rows = puzzle.count
    let cols = puzzle[0].count
    let wordChars = Array(word)
    var totalOccurrences = 0

    // Define all 8 directions
    let directions: [(dx: Int, dy: Int)] = [
        (-1, 0),  // Up
        (1, 0),   // Down
        (0, -1),  // Left
        (0, 1),   // Right
        (-1, -1), // Up-Left
        (-1, 1),  // Up-Right
        (1, -1),  // Down-Left
        (1, 1)    // Down-Right
    ]

    for row in 0..<rows {
        for col in 0..<cols {
            for (dx, dy) in directions {
                var currentRow = row
                var currentCol = col
                var found = true
                // Check if the starting character matches
                if puzzle[currentRow][currentCol] != wordChars[0] {
                    continue
                }
                // Check the rest of the word
                for charIndex in 1..<wordChars.count {
                    currentRow += dx
                    currentCol += dy

                    if currentRow < 0 || currentRow >= rows ||
                       currentCol < 0 || currentCol >= cols ||
                       puzzle[currentRow][currentCol] != wordChars[charIndex] {
                        found = false
                        break
                    }
                }

                if found {
                    totalOccurrences += 1
                }
            }
        }
    }

    return totalOccurrences
}

// Part 2: Corrected Function to find all X-MAS patterns in the grid
func findingXMAS_Part2(puzzle: [[Character]]) -> Int {
    let rows = puzzle.count
    let cols = puzzle[0].count
    var totalOccurrences = 0

    // Directions representing diagonals
    let diagonals = [
        (dx: -1, dy: -1), // Up-Left to Down-Right
        (dx: -1, dy: 1)   // Up-Right to Down-Left
    ]

    // Possible patterns: 'MAS' and 'SAM'
    let patterns: [[Character]] = [
        Array("MAS"),
        Array("SAM")
    ]

    for row in 0..<rows {
        for col in 0..<cols {
            // Check if the current cell is 'A'
            if puzzle[row][col] == "A" {
                var foundInBothDiagonals = true

                // Check both diagonals
                for (dx, dy) in diagonals {
                    var foundInThisDiagonal = false

                    for pattern in patterns {
                        // Positions before and after 'A' along the diagonal
                        let positions = [
                            (row + dx, col + dy), // Before 'A', should be pattern[0]
                            (row - dx, col - dy)  // After 'A', should be pattern[2]
                        ]

                        let lettersToMatch = [pattern[0], pattern[2]]

                        if checkPattern(puzzle: puzzle, positions: positions, pattern: lettersToMatch) {
                            foundInThisDiagonal = true
                            break
                        }
                    }

                    if !foundInThisDiagonal {
                        foundInBothDiagonals = false
                        break
                    }
                }

                if foundInBothDiagonals {
                    totalOccurrences += 1
                }
            }
        }
    }

    return totalOccurrences
}

// Helper function to check if a pattern matches at given positions
func checkPattern(puzzle: [[Character]], positions: [(Int, Int)], pattern: [Character]) -> Bool {
    for (index, (row, col)) in positions.enumerated() {
        if row < 0 || row >= puzzle.count || col < 0 || col >= puzzle[0].count {
            return false
        }
        if puzzle[row][col] != pattern[index] {
            return false
        }
    }
    return true
}

// Main execution
do {
    print("Program Started")
    print("--------------------------------")
    // Read the grid from the input file
    print("Reading grid from input.txt")
    let grid = try readGridFromFile(fileName: "input.txt")

    // Part 1: Count occurrences of the word "XMAS"
    print("Counting occurrences of the word 'XMAS' in the grid")
    let wordToSearch = "XMAS"
    let occurrencesPart1 = findingXMAS(puzzle: grid, word: wordToSearch)
    print("The word \(wordToSearch) appears \(occurrencesPart1) times in the grid.")
    print("--------------------------------")

    // Part 2: Count occurrences of X-MAS patterns
    print("Counting X-MAS patterns in the grid")
    let occurrencesPart2 = findingXMAS_Part2(puzzle: grid)
    print("The X-MAS pattern appears \(occurrencesPart2) times in the grid.")
    print("--------------------------------")

    print("Program Ended")
} catch {
    print("An error occurred: \(error)")
}