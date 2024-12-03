import Foundation

// Add this at the very top, after the import
print("Program starting...")

// // Function to write sample data to a file (for testing)
// func writeSampleData(to fileName: String) throws {
//     let fileURL = FileManager.default.currentDirectoryPath + "/" + fileName
//     let sampleData = """
//     1 5
//     2 6
//     3 7
//     4 8
//     """
//     try sampleData.write(to: URL(fileURLWithPath: fileURL), atomically: true, encoding: .utf8)
//     print("Sample data written to \(fileURL) successfully.")
// }

// Function to read and process the file, returning the arrays
func readAndProcessFile(_ fileName: String) throws -> ([Int], [Int]) {
    let fileURL = FileManager.default.currentDirectoryPath + "/" + fileName
    let contents = try String(contentsOf: URL(fileURLWithPath: fileURL), encoding: .utf8)
    
    // Initialize empty arrays to store our columns
    var column1: [Int] = []
    var column2: [Int] = []
    
    // Split the contents into lines
    let lines = contents.components(separatedBy: .newlines)
    
    // Process each line
    for (lineNumber, line) in lines.enumerated() {
        // Skip empty lines
        guard !line.isEmpty else { continue }
        
        // Split the line by spaces
        let numbers = line.split(separator: " ")
        
        // Make sure we have exactly 2 numbers
        if numbers.count == 2 {
            // Convert strings to integers and add to arrays
            if let num1 = Int(numbers[0]), let num2 = Int(numbers[1]) {
                column1.append(num1)
                column2.append(num2)
            } else {
                print("Error: Non-integer value found on line \(lineNumber + 1).")
            }
        } else {
            print("Error: Line \(lineNumber + 1) does not contain exactly two numbers.")
        }
    }
    
    // Return the arrays
    return (column1, column2)
}

// Function to print the arrays in a formatted way (optional)
func printColumns(_ column1: [Int], _ column2: [Int]) {
    // Check if we have data to display
    guard !column1.isEmpty && !column2.isEmpty else {
        print("No valid data to display.")
        return
    }
    
    // Print arrays in a nicely formatted way
    print("\nColumn 1    Column 2")
    print("--------    --------")
    for i in 0..<column1.count {
        print(String(format: "%-10d %-10d", column1[i], column2[i]))
    }
}

// order columns by least to greatest

func orderColumns(column1: [Int], column2: [Int]) -> ([Int], [Int]) {
    // colums are sorted by least to greatest
    return (column1.sorted(), column2.sorted())
}

func findDistance(column1: [Int], column2: [Int]) -> [Int] {
    var distances: [Int] = []

    // find the distance between each point
    for (element1, element2) in zip(column1, column2) {
        print("Element 1: \(element1)")
        print("Element 2: \(element2)")
        print("Finding distance between points...")
        let distanceBetweenPoints = abs(element1 - element2)
        print("Distance between points: \(distanceBetweenPoints)")
        distances.append(distanceBetweenPoints)
    }
    print("Distance between points: \(distances)")
    return distances
}

func findTotalDistance(distances: [Int]) -> Int {
    return distances.reduce(0, +)
}


// coufinding simularites 

func findSimularites(num: Int, column2: [Int]) -> Int {
    // finding how many times a number appears in the column
    let simularites = column2.filter { $0 == num }.count
    print("Simularites: \(simularites)")
    return num * simularites
}

// find simularitesScore

func findSimularitesScore(column1: [Int], column2: [Int]) -> Int {
    var simularitesScore: Int = 0
    for num in column1 {
        let simularites = findSimularites(num: num, column2: column2)
        simularitesScore += simularites
    }
    return simularitesScore
}

// Main program execution
do {
    print("Entering main execution block...")
    let fileName = "input.txt"
    
    print("Current directory: \(FileManager.default.currentDirectoryPath)")
    
    // // (Optional) Write sample data to the file
    // print("Attempting to write sample data...")
    // try writeSampleData(to: fileName)
    
    // Read and process the file, obtaining the arrays
    print("Attempting to read file...")
    let (column1, column2) = try readAndProcessFile(fileName)
    print("Column 1: \(column1)")
    print("Column 2: \(column2)")
    // Print the arrays
    print("Printing columns...")
    printColumns(column1, column2)

    // order columns by least to greatest
    let (orderedColumn1, orderedColumn2) = orderColumns(column1: column1, column2: column2)
    print("Ordered column 1: \(orderedColumn1)")
    print("Ordered column 2: \(orderedColumn2)")

    // find the distance between each point
    let distanceBetweenPoints = findDistance(column1: orderedColumn1, column2: orderedColumn2)
    print("finnished finding distance between points")

    // find the total distance
    print("Finding total distance...")
    let totalDistance = findTotalDistance(distances: distanceBetweenPoints)
    print("Total distance: \(totalDistance)")


    // find the simularites score
    print("Finding simularites score...")
    let simularitesScore = findSimularitesScore(column1: orderedColumn1, column2: orderedColumn2)
    print("Simularites score: \(simularitesScore)")
} catch {
    print("An error occurred: \(error)")  // Changed to print full error, not just description
    print("Error type: \(type(of: error))")
}

print("Program finished.")