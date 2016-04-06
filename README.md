# Gaia-iOS
__CodePath Group Project__
Authored By: R. Alex Clark, John Henning, Carlos Avogadro

## Project Description
Gaia is an iOS application that acts as a catalogue of wildlife. Using the custom image classification API using a convolutional neural network, the user is able to document any wildlife encountered using simply the iPhone camera. Gaia will enable users to compete with their friends for the largest collection of documented wildlife. The collected images of the encountered wildlife will provide helpful metrics such as geographic location of encounter, date & time, and lifetime encounters with captured organisms.

## User Stories
- [x] ~~Setup the neural network API to communicate with Gaia and classify images. Will be setup on different server~~ Neural Network's predictions not accurate enough
- [x] Setup Clarifai API 
- [x] Setup the camera capture view enabling user to snap photos of subjects, this acts as the landing view for the application
- [x] Create view for users' catalogue of taken images, this would be accessed from the landing view
- [x] Create view for handling the post image capture event, which appears once the user takes an image using the capture button on the landing view

### Optional Features
- [x] Create application icon and launchscreen assets
- [x] Create view for users' score
- [ ] Modal view of cell picture w/ content about animal & capture details
- [x] Log In & Sign Up Screens for tracking unique users
- [ ] Users can delete previously taken photos
- [ ] Overlay cell details onto cell & modal photo rather than as labels
- [ ] Button for more tags on successful photo capture
- [ ] Animation for successful / failure to capture
- [ ] Custom transitions to score & map
- [ ] Specific tags, as well as 'Generic' tags for family/species (would be shown in button or if no specfic match found)
- [x] Leaderboard for tracking other users scores based on logged in username
- [ ] Use chameleon framework for UI color and design
- [ ] Use pop for animations
- [ ] Setup autolayout for application's views and the scrollview container
- [x] Create view for geographic tracking of photo locations, displayed on a map view

### Database Models
We will be using Parse for our database server, using hosting from MongoLab.

__Database Structure__
* User Table
  * Username
  * Email
  * Password
  * Total Score from Captured Entries
* Entry Table
  * Google Coordinates of Capture
  * Image Link
  * Species (FK to Animal.Species)
  * Extinction Status
  * Score For Entry
  * Attached User (FK to User.Username)
  * Image Location

### API Endpoints Used
* [The Unofficial Wikipedia API](http://www.programmableweb.com/api/wikipedia)
* [Google Maps API](https://developers.google.com/maps/)
* [Clarfai API](http://www.developer.clarifai.com/)

### External Libraries Used
* [CameraManager Cocoapod](https://cocoapods.org/pods/CameraManager)

### Resources
* [CodePath Guide To Creating Custom Camera View](http://guides.codepath.com/ios/Creating-a-Custom-Camera-View)
* [Swift Swipe View for Home Screen](https://github.com/lbrendanl/SwiftSwipeView)

* * *

## Submission Checkpoints

### Submission 1 (3/10/16) - 33% of User Stories
![Gaia-iOS-Submission-1](https://cloud.githubusercontent.com/assets/6467543/13731804/127d51be-e949-11e5-9029-146e871b5b9b.gif)

### Submission 2 (3/17/16) - 66% of User Stories
[Submission Gif (was too large)](http://i.imgur.com/ZLAekpN.gifv)

### Submission 3 (3/23/16) - All Basic User Stories Completed

__Basic Flow of Application__  
![gaia-submission-3](https://cloud.githubusercontent.com/assets/6467543/14035691/7b5e14d6-f207-11e5-960a-1b2642d3b349.gif)

__Tagging Accuracy__  
![gaia-submission-3-tagging](https://cloud.githubusercontent.com/assets/6467543/14035753/2521e5b0-f208-11e5-87c5-1da8165bd7ae.gif)

### Optionals Submission (3/31/16)
![gaia-submission-optionals](https://cloud.githubusercontent.com/assets/6467543/14199032/9be085e8-f7ae-11e5-8a41-ade40e48ea67.gif)




