import SwiftUI

// Define a view model class that conforms to the ObservableObject protocol so that SwiftUI views can react to data changes.
class ContentViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Stores the text used for filtering the vertical list.
    @Published var searchText: String = ""
    
    /// Represents the index of the currently selected list from verticalData.
    @Published var selectedIndex: Int = 0
    
    // MARK: - Data Sources
    
    /// An array of image name strings to be displayed in a horizontal scroll view.
    let horizontalImages = [
        "A_breathtaking_nature_scene_featuring_a_serene_mou",
        "A_breathtaking_nature_scene_featuring_a_serene_wat",
        "A_scenic_coastal_view_with_waves_crashing_on_a_roc",
        "A_tranquil_forest_scene_with_a_winding_path_leadin"
    ]
    
    /// A 2D array where each sub-array contains a list of fruit names for vertical display.
    let verticalData: [[String]] = [
        ["apple", "banana", "orange", "blueberry"],
        ["grape", "melon", "kiwi", "strawberry"],
        ["pear", "pineapple", "mango", "cherry"],
        ["fig", "date", "plum", "papaya"]
    ]
    
    // MARK: - Computed Properties
    
    /// Returns a filtered list of items from the currently selected vertical list.
    ///
    /// - If `searchText` is empty, it returns the full list.
    /// - Otherwise, it returns only those items that contain `searchText` (case-insensitive).
    var filteredData: [String] {
        if searchText.isEmpty {
            // No filtering needed if the search text is empty.
            return verticalData[selectedIndex]
        } else {
            // Filter the current list by checking if each item contains the search text, ignoring case.
            return verticalData[selectedIndex].filter { item in
                item.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    // MARK: - Functions
    
    /// Generates a statistics summary for the currently selected vertical list.
    ///
    /// The summary includes:
    /// - The list number (adjusted to be 1-based).
    /// - The total number of items in the list.
    /// - The top 3 most frequent characters found in all the list items.
    ///
    /// - Returns: A formatted string containing the statistics.
    func showStatistics() -> String {
        // Retrieve the current list based on the selected index.
        let currentList = verticalData[selectedIndex]
        
        // Calculate the frequency of each character in the current list.
        let counts = characterFrequency(list: currentList)
        
        // Start building the statistics string with the list number and item count.
        var statsText = "List \(selectedIndex + 1) (\(currentList.count) items)\n"
        
        // Append the top 3 most frequent characters and their counts to the statistics string.
        for (char, count) in counts.prefix(3) {
            statsText += "\(char) = \(count)\n"
        }
        
        // Return the complete statistics string.
        return statsText
    }
    
    /// A private helper function that calculates the frequency of each character in a list of strings.
    ///
    /// - Parameter list: An array of strings whose characters will be analyzed.
    /// - Returns: An array of tuples, each containing a character and its frequency, sorted in descending order by frequency.
    private func characterFrequency(list: [String]) -> [(Character, Int)] {
        // Create an empty dictionary to store character frequencies.
        var frequencyDictionary: [Character: Int] = [:]
        
        // Loop through each word in the list.
        for word in list {
            // Loop through each character in the word.
            for char in word {
                // Increment the count for the character, using 0 as the default value if it hasn't been added yet.
                frequencyDictionary[char, default: 0] += 1
            }
        }
        
        // Convert the dictionary into an array of (Character, Int) tuples and sort it by frequency in descending order.
        return frequencyDictionary.sorted { $0.value > $1.value }
    }
}

