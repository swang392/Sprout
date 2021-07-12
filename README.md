Original App Design Project - Sarah Wang
===

# Sprout - Personal Fitness Plan

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Sprout is a personal fitness app, that allows you to create custom fitness and wellness plans that suits your needs. You can share your daily accomplishments with friends on the app.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Health and Fitness (and some Social) 
- **Mobile:** Gives push notifications to remind you about daily health tasks to keep you on track. Uses Google Maps API to locate users near you.
- **Story:** Allows users to create fitness and health plans for themselves and share their self-improvement journeys with others.
- **Market:** Anyone interested in fitness and overall health would enjoy this app.
- **Habit:** Health is something people should work on daily. Expanding beyond fitness (ex: diet, mental health) makes it even more applicable for daily use. Many current fitness apps are calorie/weight focused, but creating a plan focused on building habits and growth helps change one's lifestyle.
- **Scope:** Since the plan is mostly customized, the scope of what the app does can be varied. However, the app's main focus is creating the plan and reminded the user to complete tasks.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can create a new account, log in, and sign out of account
* User can create a new fitness plan
* user can search for other users
* User can add friends
* User can see locations of other friends
* Social feed of other people's daily accomplishments
* User sees profile with their fitness plan and accomplishments
* user can edit/save/delete plan
* User can mark tasks on their plan as complete



**Optional Nice-to-have Stories**

* Only certain friends can view a travel plan (access page)
* User can see a list of their followers
* User can see a list of their following
* User can like accomplishments on social feed
* User can comment on accomplishments on social feed

### 2. Screen Archetypes

* Login Screen
    * User can login
* Registration Screen
    * User can create a new account
* Social Feed
    * User can see friends daily accomplishments (ex: 5/6 tasks completed today)
* Homepage
    * Shows daily tasks and overview of current plan
    * Allows user to check off tasks
    * allows you to create new plans or edit current one
* Creation
    * User can create a new plan
* Search
    * User can search for other users
    * User can follow/unfollow users 
    * User can see other plans on friends profiles

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home Feed
* My Trips
* Search for Users

**Flow Navigation** (Screen to Screen)

* Login Screen
    => Home
* Registration Screen
    => Home
* Stream
    => View friends accomplishments (and later, like/comment)
* Creation
    => Multiple screens for creation process 
          => Duration of plan
          => Fitness schedule
          => Which wellness/health goals do you want to do every day
    => Home after saving plan
* Search
    => None
* My Plan
    => edit, delete, save


## Wireframes
<img src="https://i.imgur.com/jvp9vyB.jpg" width=600>


### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models


Goal
| Property | Type | Description |
| -------- | -------- | -------- |
| objectId | string | unique id for the user goal (default field) |
| author | pointer to user | image author |
| timeframe | Number |number of days in the schedule|
| createdAt | DateTime | date when post is created (default field)|
| dailyTasks | NSMutableArray | list of daily tasks |
| fitnessPlan | NSMutableArray | fitness schedule|
| post | pointer to post | posts daily accomplishments|
| completedTasks | NSMutableArray | array of booleans for tasks that were completed, gets passed to the post |

User 
| Property | Type | Description |
| -------- | -------- | -------- |
| objectId | String | unique id for the user goal (default field) |
| username | String | username|
| password | String | password |
| name | String | display name |
| profileImageURL | String | url link to user's profile photo|
| facebook profile ?|          |          |
| currentPlan | pointer to goal?|          |

Daily Post
| Property | Type | Description |
| -------- | -------- | -------- |
| objectId | String | unique id for the user goal (default field) |
| likeCount | number | number of likes on post |
| completedCount | number | number of trues on completedTask  |
| author | pointer to user | author ID |


### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
