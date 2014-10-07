
Twitter Redux App
================
## Synopsis

This is the code for the Week 4 Project: Twitter Redux

## Number of hours spent

I spent about 10 hours on doing this project. I first updated the previous week's Twitter app with some of the suggestions from the review. Most of the challenge was making sure that 
the twitter background image profile displayed properly and there were proper delegates to navigate between the views.

## Features Implemented(required)

* Hamburger menu
..* Dragging anywhere in the view should reveal the menu.
..* The menu should include links to your profile, the home timeline, and the mentions view.

* Profile page
..* Contains the user header view
..* Contains a section with the users basic stats: # tweets, # following, # followers

* Home Timeline
..* Tapping on a user image should bring up that user's profile page (I also hooked up the detail view page's user's image to go to Profile page)


## Installation
The pods directory was also checked in so theoretically should just need to load TwitterApp.xcworkspace

## Third party libraries used

* AFNetworking (for asynchronous loading of images)
* RNActivityView (for showing the loading dialog)
* BDBOAuth1Manager
* NSDateMinimalTimeAgo


## Animated gif walkthrough
![Video Walkthrough](walkThrough.gif)
