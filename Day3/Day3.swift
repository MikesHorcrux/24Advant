///
///day 3 of Code Advent
//


import Foundation



// Function to write sample data to a file (for testing)
func writeSampleData(to fileName: String) throws {
    let fileURL = FileManager.default.currentDirectoryPath + "/" + fileName
    let sampleData = """
    xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
    """
    try sampleData.write(to: URL(fileURLWithPath: fileURL), atomically: true, encoding: .utf8)
    print("Sample data written to \(fileURL) successfully.")
}

// Function to read and process the file, extracting mul patterns
func readAndExtractMulPatterns(_ fileName: String) throws -> [[Int]] {
    let fileURL = FileManager.default.currentDirectoryPath + "/" + fileName
    let contents = try String(contentsOf: URL(fileURLWithPath: fileURL), encoding: .utf8)
    
    // Regex pattern to match mul(X,Y)
    let pattern = "mul\\((\\d+),(\\d+)\\)"
    let regex = try NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: contents.utf16.count)
    
    var results: [[Int]] = []
    
    let matches = regex.matches(in: contents, options: [], range: range)
    for match in matches {
        if let firstNumberRange = Range(match.range(at: 1), in: contents),
           let secondNumberRange = Range(match.range(at: 2), in: contents) {
            let firstNumber = Int(contents[firstNumberRange])!
            let secondNumber = Int(contents[secondNumberRange])!
            results.append([firstNumber, secondNumber])
        }
    }
    
    return results
}


// Function to read and process the file, extracting mul patterns after "Do" and not after "Don't"
func extractMulPatternsAfterDo(_ fileName: String) throws -> [[Int]] {
    let fileURL = FileManager.default.currentDirectoryPath + "/" + fileName
    let contents = try String(contentsOf: URL(fileURLWithPath: fileURL), encoding: .utf8)
    
    // Regex pattern to match "do()", "don't()", and "mul(X,Y)"
    let pattern = "(do\\(\\)|don't\\(\\))|mul\\((\\d+),(\\d+)\\)"
    let regex = try NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: contents.utf16.count)
    
    var results: [[Int]] = []
    var shouldCapture = true  // Start enabled by default
    
    let matches = regex.matches(in: contents, options: [], range: range)
    for match in matches {
        if let matchTextRange = Range(match.range(at: 1), in: contents) {
            // This is a "do()" or "don't()" match
            let matchText = String(contents[matchTextRange])
            shouldCapture = matchText == "do()"
        } else if shouldCapture,
                  let firstNumberRange = Range(match.range(at: 2), in: contents),
                  let secondNumberRange = Range(match.range(at: 3), in: contents),
                  let firstNumber = Int(contents[firstNumberRange]),
                  let secondNumber = Int(contents[secondNumberRange]) {
            // This is a mul pattern match
            results.append([firstNumber, secondNumber])
        }
    }
    
    return results
}

///extract mul patterns from a string
func extractMulPatterns(from text: String) -> [[Int]] {
    let pattern = "mul\\((\\d+),(\\d+)\\)"
    let regex = try! NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: text.utf16.count)
    
    var results: [[Int]] = []
    
    let matches = regex.matches(in: text, options: [], range: range)
    for match in matches {
        if let firstNumberRange = Range(match.range(at: 1), in: text),
           let secondNumberRange = Range(match.range(at: 2), in: text) {
            let firstNumber = Int(text[firstNumberRange])!
            let secondNumber = Int(text[secondNumberRange])!
            results.append([firstNumber, secondNumber])
        }
    }
    
    return results
}

///multiply patterns
func multiplyPatterns(patterns: [[Int]]) -> [Int] {
    return patterns.map { $0.reduce(1, *) }
}

///sum patterns
func sumPatterns(patterns: [Int]) -> Int {
    return patterns.reduce(0, +)
}


do {
    print("Starting program...")
   // print("Writing sample data...")
   // try writeSampleData(to: "sample.txt")
    print("Reading and extracting mul patterns...")
    let patterns = try readAndExtractMulPatterns("sample.txt")
    print("Multiplying patterns...")
    let multiplied = multiplyPatterns(patterns: patterns)
    print("Summing patterns...")
    let summed = sumPatterns(patterns: multiplied)
    print("Sum of multiplied patterns: \(summed)")

    print("Reading and extracting mul patterns after 'Do'...")
    let patternsAfterDo = try extractMulPatternsAfterDo("sample.txt")
    print("Multiplying patterns after 'Do'...")
    let multipliedAfterDo = multiplyPatterns(patterns: patternsAfterDo)
    print("Summing patterns after 'Do'...")
    let summedAfterDo = sumPatterns(patterns: multipliedAfterDo)
    print("Sum of multiplied patterns after 'Do': \(summedAfterDo)")

    print("Program completed successfully.")
} catch {
    print("Error: \(error)")
}
