//
//  ContentViewModelTests.swift
//  DevExamSwiftUiTests
//
//  Created by balamuruganc on 11/02/25.
//

import XCTest
@testable import DevExamSwiftUi

final class ContentViewModelTests: XCTestCase {
    
    /// The instance of ContentViewModel we will use for testing.
    var viewModel: ContentViewModel!
    
    /// Set up a fresh instance of ContentViewModel before each test.
    override func setUp() {
        super.setUp()
        viewModel = ContentViewModel()
    }
    
    /// Clean up after each test.
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    /// Test that when the search text is empty, the filteredData returns the full list for the current selectedIndex.
    func testFilteredDataEmptySearch() {
        // Given: searchText is empty and selectedIndex is 0
        viewModel.searchText = ""
        viewModel.selectedIndex = 0
        
        // When: retrieving filteredData
        let filtered = viewModel.filteredData
        
        // Then: filteredData should be equal to the entire verticalData list at index 0.
        let expected = viewModel.verticalData[0]
        XCTAssertEqual(filtered, expected, "Filtered data should equal the full list when searchText is empty.")
    }
    
    /// Test that when search text is provided, filteredData returns only the matching items.
    func testFilteredDataNonEmptySearch() {
        // Given: searchText is "a" and selectedIndex is 0.
        // For verticalData[0] = ["apple", "banana", "orange", "blueberry"],
        // only "apple", "banana", and "orange" contain the letter "a".
        viewModel.searchText = "a"
        viewModel.selectedIndex = 0
        
        // When: retrieving filteredData
        let filtered = viewModel.filteredData
        
        // Then: filteredData should contain only the matching items.
        let expected = ["apple", "banana", "orange"]
        XCTAssertEqual(filtered, expected, "Filtered data should include items containing 'a'.")
    }
    
    /// Test that showStatistics() returns a correctly formatted string that includes
    /// the list header and expected character frequencies.
    func testShowStatistics() {
        // Given: Use the verticalData at index 0 which is:
        // ["apple", "banana", "orange", "blueberry"]
        viewModel.selectedIndex = 0
        
        // When: calling showStatistics()
        let stats = viewModel.showStatistics()
        
        // Then: the returned string should contain the header "List 1 (4 items)"
        XCTAssertTrue(stats.contains("List 1 (4 items)"), "Statistics should contain the correct list header.")
        
        // And: the statistics should include the correct frequency for known characters.
        // Based on verticalData[0]:
        // "apple"    -> a:1, p:2, l:1, e:1
        // "banana"   -> b:1, a:3, n:2
        // "orange"   -> o:1, r:1, a:1, n:1, g:1, e:1
        // "blueberry"-> b:2, l:1, u:1, e:2, r:2, y:1
        // Total frequency for 'a' = 5 and for 'e' = 4.
        XCTAssertTrue(stats.contains("a = 5"), "Statistics should include the frequency for 'a'.")
        XCTAssertTrue(stats.contains("e = 4"), "Statistics should include the frequency for 'e'.")
        
        // And: one of the characters with frequency 3 (for example, 'b', 'n', or 'r') should appear.
        let possibleThirdFrequencies = ["b = 3", "n = 3", "r = 3"]
        let containsThird = possibleThirdFrequencies.contains { stats.contains($0) }
        XCTAssertTrue(containsThird, "Statistics should include one of the characters with frequency 3.")
    }
}
