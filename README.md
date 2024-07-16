InstaPost
InstaPost is an iOS application that allows users to view and manage posts. The app has a user-friendly interface and follows modern material design principles. This README file provides instructions on setting up and running the application, as well as an overview of its features and technical specifications.

Features
User Authentication: A login screen with email and password validation.
Posts Display: Displays a list of posts fetched from a network API.
Favorites Management: Users can mark posts as favorites and view them in a separate tab.
Offline Support: The list of posts is available even when the network is not available.
Technical Specifications
Programming Language: Swift
Design Pattern: MVVM (Model-View-ViewModel)
Networking: URLSession with Codable for network calls
Reactive Programming: Rxswift for reactive programming

Requirements
iOS 13.0+
Xcode 14.0+
CocoaPods

Installation
Clone the repository:
git clone https://github.com/amitsinghmarch07/InstPost.git

cd InstPost

Install dependencies:
pod install

Open the project in Xcode:
open InstPost.xcworkspace

Configuration

API Configuration
The app uses the JSONPlaceholder API to fetch posts and comments. No additional configuration is required for the API as the base URL is already set in the project.

Base URL: https://jsonplaceholder.typicode.com
Endpoints:
Posts: /posts
Comments: /posts/{post_id}/comments
Usage
Run the App: Select a simulator or a physical device and run the app by clicking the "Run" button in Xcode or using the shortcut Cmd + R.

Login Screen: Enter a valid email address and a password between 8-15 characters. The "Submit" button will be enabled only when both fields are valid. Click "Submit" to proceed to the next screen.

Posts Screen:

The posts screen has two tabs: "Posts" and "Favorites".
The "Posts" tab displays a list of posts fetched from the network. You can mark posts as favorites by clicking on them.
The "Favorites" tab displays the list of posts that have been marked as favorites.

Folder Structure

Models: Contains the data models used in the app.
Factory: Contains the view models that handle the business logic.
CoreDataEntities: Contains CoreData modals
Utils: Contains extension and constant files
Services: Contains api service classes
Post: Contains POST screen controller and viewmodal
Favorite: Contains FAVORITE screen controller and viewmodal
Login:: Contains LOGIN screen controller and viewmodal

Contributing
Contributions are welcome! Please fork the repository and submit a pull request for any enhancements or bug fixes.

Contact
For any questions or inquiries, please contact ammi431@gmail.com.
![LoginScreen](https://github.com/amitsinghmarch07/InstPost/assets/35914384/2ef73d99-8820-4d35-aa89-cb1f22abecc3)
![PostsScreen](https://github.com/amitsinghmarch07/InstPost/assets/35914384/30aa7cb3-6d02-4a4e-b5a5-15c78476b7b7)
![FavoriteScreen](https://github.com/amitsinghmarch07/InstPost/assets/35914384/b4353ae7-051b-4b0b-a25a-74b4ae5f5975)

