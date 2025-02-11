import SwiftUI

// MARK: - Main Content View
/// The main view that displays an image carousel, a search bar, a filtered list, and a floating button.
struct ContentView: View {
    // StateObject to manage and observe changes in the view model.
    @StateObject private var viewModel = ContentViewModel()
    
    // State variable to control whether the statistics sheet is shown.
    @State private var showStatsSheet = false
    
    // State variable to hold the statistics text that will be displayed in the statistics sheet.
    @State private var statsText = ""
    
    // The main body of the ContentView.
    var body: some View {
        VStack {  // Arrange components vertically.
            
            // MARK: - Image Carousel Section
            // A TabView is used as an image carousel that allows swiping between images.
            TabView(selection: $viewModel.selectedIndex) {
                // Loop through each index of the horizontal images array.
                ForEach(viewModel.horizontalImages.indices, id: \.self) { index in
                    ZStack { // Overlay components on top of each other.
                        // Create a rounded rectangle as a background shape with a shadow.
                        RoundedRectangle(cornerRadius: 15)
                            .shadow(radius: 5)
                        
                        // Attempt to load an image using the image name at the current index.
                        if let uiImage = UIImage(named: viewModel.horizontalImages[index]) {
                            Image(uiImage: uiImage)  // Create an Image view from the UIImage.
                                .resizable()         // Make the image resizable.
                                .scaledToFill()      // Scale the image to fill its container.
                                .clipShape(RoundedRectangle(cornerRadius: 15))  // Apply rounded corners.
                                .frame(maxWidth: .infinity, maxHeight: .infinity) // Occupy available space.
                        } else {
                            // If the image is not found in the asset catalog, use a system image.
                            Image(systemName: viewModel.horizontalImages[index])
                                .resizable()
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .frame(height: 150)  // Set a fixed height for each carousel item.
                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                    .padding(.all, 10)
                    .tag(index)          // Tag the view with its index for selection tracking.
                }
            }
            .onAppear {
                    statsText = viewModel.showStatistics()
                }
            // Set the TabView style to use a page style with visible page indicators.
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .frame(height: 170)       // Define the overall height for the carousel container.
            .padding(.horizontal)     // Add horizontal padding around the carousel.
            .padding(.top, 100)       // Add extra padding at the top.
            .padding(.bottom, 10)     // Add padding at the bottom.
            .animation(.easeInOut, value: viewModel.selectedIndex)  // Animate transitions when the selected index changes.
            
            // MARK: - Search Bar Section
            // A text field that allows the user to search/filter list items.
            TextField("Search", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle()) // Apply a rounded border style to the text field.
                .padding()               // Add inner padding within the text field.
                .background(Color.white) // Set the background color to white.
                .cornerRadius(10)        // Round the corners of the background.
                .padding(.horizontal)    // Add horizontal padding around the search bar.
            
            // MARK: - List Section
            // A List that displays items filtered based on the search query.
            List(viewModel.filteredData, id: \.self) { item in
                HStack {  // Arrange each row’s content horizontally.
                    // Left side: An image container.
                    ZStack {
                        // Create a rounded rectangle with a semi-transparent blue background.
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 50, height: 50)  // Set fixed width and height.
                        
                        // Display an image based on the current selected horizontal image.
                        if let uiImage = UIImage(named: viewModel.horizontalImages[viewModel.selectedIndex]) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 40, height: 40)  // Set the image size.
                        } else {
                            // If the image is not found, use a system image.
                            Image(systemName: viewModel.horizontalImages[viewModel.selectedIndex])
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    }
                    
                    // Right side: A vertical stack for text information.
                    VStack(alignment: .leading) {
                        Text(item)  // Display the item text (e.g., a fruit name).
                            .font(.headline)  // Use a headline font style.
                        Text(dynamicSubtitle(for: item))  // Display a dynamically generated subtitle.
                            .font(.subheadline)  // Use a subheadline font style.
                            .foregroundColor(.gray)  // Set the text color to gray.
                    }
                }
                .padding(.vertical, 5)  // Add vertical padding to each list row.
            }
        }
        // Extend the view to the top edge, ignoring the safe area.
        .edgesIgnoringSafeArea(.top)
        // Overlay the floating button on top of the main content.
        .overlay(
            FloatingButton(action: {
                statsText = viewModel.showStatistics()  // Generate statistics when the button is pressed.
                showStatsSheet = true  // Show the statistics sheet.
            })
            .padding()  // Add padding around the floating button.
            // Present a modal sheet with statistics when showStatsSheet is true.
                .sheet(isPresented: $showStatsSheet) {
                    StatisticsView(statsText: $statsText)  // Pass the binding instead of a constant.
                },
            alignment: .bottomTrailing  // Position the floating button at the bottom-right.
        )
    }
    
    // MARK: - Helper Function
    /// Generates a dynamic subtitle for a given item.
    /// - Parameter item: The string item for which to generate the subtitle.
    /// - Returns: A string that includes the character count of the item.
    func dynamicSubtitle(for item: String) -> String {
        return "Length: \(item.count) characters"  // Return the length of the item.
    }
}

// MARK: - Floating Button View
/// A custom floating button that executes a specified action when tapped.
struct FloatingButton: View {
    /// Closure that defines the action to perform when the button is pressed.
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {  // Create a button that runs the provided action.
            Image(systemName: "ellipsis")  // Use the system "ellipsis" image.
                .rotationEffect(.degrees(90))
                .foregroundColor(.white)   // Set the icon color to white.
                .padding()                 // Add padding inside the button.
                .background(Color.blue)    // Set the background color to blue.
                .clipShape(Circle())       // Clip the button into a circular shape.
                .shadow(radius: 5)         // Add a shadow to the button.
        }
    }
}

// MARK: - Statistics View
/// A view that displays statistical information in a modal sheet.
struct StatisticsView: View {
    /// A binding to the statistics text so that the view updates when the value changes.
    @Binding var statsText: String
    
    var body: some View {
        VStack {
            Text(statsText)  // Display the statistics text.
                .multilineTextAlignment(.center)  // Center-align the text if it spans multiple lines.
                .padding()  // Add padding around the text.
            Spacer()  // Push content to the top.
        }
        // Set the modal sheet to a medium height (requires iOS 16 or later).
        .presentationDetents([.medium])
    }
}
