# Gaia-iOS
__CodePath Group Project__
Authored By: R. Alex Clark, John Henning, Carlos Avogadro

## Project Description
Gaia is an iOS application that acts as a catalogue of wildlife. Using the custom image classification API using a convolutional neural network, the user is able to document any wildlife encountered using simply the iPhone camera. Gaia will enable users to compete with their friends for the largest collection of documented wildlife. The collected images of the encountered wildlife will provide helpful metrics such as geographic location of encounter, date & time, and lifetime encounters with captured organisms.

## User Stories
- [x] Setup the neural network API to communicate with Gaia and classify images. Will be setup on different server
- [x] Setup the camera capture view enabling user to snap photos of subjects, this acts as the landing view for the application
- [x] Create view for users' catalogue of taken images, this would be accessed from the landing view
- [ ] Create view for handling the post image capture event, which appears once the user takes an image using the capture button on the landing view

### Optional Features
- [x] Create application icon and launchscreen assets
- [ ] Create view for users' score, this would be a pulldown from the landing view
- [ ] Log In & Sign Up Screens for tracking unique users
- [ ] Users can import images from their own camera roll into Gaia
- [ ] Custom API training for the network to better identify the animals
- [ ] Crowdsource the tag training for more accurate selection
- [ ] Leaderboard for tracking other users scores based on logged in username
- [ ] Create view for geographic tracking of photo locations, displayed on a map view

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

### API Endpoints Used
* [The Unofficial Wikipedia API](http://www.programmableweb.com/api/wikipedia)
* [Google Maps API](https://developers.google.com/maps/)

### External Libraries Used
* [CameraManager Cocoapod](https://cocoapods.org/pods/CameraManager)

### Resources
* [CodePath Guide To Creating Custom Camera View](http://guides.codepath.com/ios/Creating-a-Custom-Camera-View)
* [Swift Swipe View for Home Screen](https://github.com/lbrendanl/SwiftSwipeView)

* * *

## Submission Checkpoints

### Submission 1 (3/10/16) - 33% of User Stories
![Gaia-iOS-Submission-1](https://cloud.githubusercontent.com/assets/6467543/13731804/127d51be-e949-11e5-9029-146e871b5b9b.gif)


