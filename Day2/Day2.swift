//
//  Day2.swift
//  AdventOfCode2024
//
//  Created on 2024/12/03.
//

import Foundation

///comment this out when not testing
// MARK: - File Operations
// func writeTestData() throws {
//     let testData = """
//     7 6 4 2 1
//     1 2 7 8 9
//     9 7 6 2 1
//     1 3 2 4 5
//     8 6 4 4 1
//     1 3 6 7 9
//     """
    
//     // Get the current directory where the script is running
//     let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
//     let fileURL = currentDirectoryURL.appendingPathComponent("input.txt")
    
//     try testData.write(to: fileURL, atomically: true, encoding: .utf8)
//     print("Test data written to: \(fileURL.path)")
// }

func readInputFile() throws -> [[Int]] {
    // Get the current directory where the script is running
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let fileURL = currentDirectoryURL.appendingPathComponent("input.txt")
    
    let contents = try String(contentsOf: fileURL, encoding: .utf8)
    
    return contents
        .components(separatedBy: .newlines)
        .filter { !$0.isEmpty }
        .map { line in
            line.split(separator: " ")
                .compactMap { Int($0) }
        }
}

// check if the report is stable
// Check if the report is stable by checking if the difference between each number is either 0 or less than 3
// and if the report is continuosly increasing or decreasing
// if the report is not stable, return false
// But with a dampener to prevent false positives
func reportIsStable(report: [Int]) -> Bool {
    var dampener = 0
    let isIncreasing = report[0] < report[1]
    print("Report: \(report)")
    print("Expected pattern: \(isIncreasing ? "Increasing" : "Decreasing")")
    
    for i in 0..<report.count - 1 {
        let current = report[i]
        let next = report[i + 1]
        let difference = abs(current - next)
        
        let isValidDirection = isIncreasing ? current < next : current > next
        print("Checking: \(current) \(isIncreasing ? "<" : ">") \(next), Difference: \(difference)")
        
        if !isValidDirection {
            print("Expectation failed: Sequence is not \(isIncreasing ? "increasing" : "decreasing").")
            print("--------------------------------")
            if dampener == 0 {
                dampener = 1
            } else {
                return false
            }
            continue
        }
        
        if difference > 3 || current == next {
            print("Expectation failed: Difference too large or zero.")
            print("--------------------------------")
            if dampener == 0 {
                dampener = 1
            } else {
                return false
            }
        }
    }
    
    print("Expectation met for report.")
    print("Report is stable.")
    print("--------------------------------")
    return true
}

// Read the red nose reports and return the safety ratings for each report
func readRedNoseReports(reports: [[Int]]) throws -> [Bool] {
    reports.map(reportIsStable)
}

// Get the overall safety rating by counting the number of true values in the array
func getOverallSaftyRating(reportsSafteyRatings: [Bool]) -> Int {
    return reportsSafteyRatings.filter { $0 == true }.count
}

// MARK: - Main Execution
do {
    print("\nStarting program...")
    ///comment this out when not testing
    // print("Writing test data...")
    // try writeTestData()
    

    print("\nReading Data...")
    let redNoseReports = try readInputFile()
    
    print("\nLoaded reports...")
    

    print("\nReading red nose reports...")
    let reportSaftey = try readRedNoseReports(reports: redNoseReports)

    print("\nCalculating safety rating...")
    let safetyRating = getOverallSaftyRating(reportsSafteyRatings: reportSaftey)

    print("\nSafety rating: \(safetyRating)")   

    print("\nProgram complete.")
} catch {
    print("Error: \(error)")
    print("Program terminated.")
}
