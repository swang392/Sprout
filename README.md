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
Sprout is a personalized health tracking app, and primarily focuses on fitness, diet, and mental health. Users can add daily and weekly tasks to their to-do list and share their daily accomplishments to a global feed. Sprout also recommends tasks to ensure that users are prioritizing all aspects of wellness. 

### App Evaluation
- **Category:** Health and Fitness (and some Social) 
- **Mobile:** Gives push notifications to remind you about daily health tasks to keep you on track. Uses Google Maps API to locate users near you.
- **Story:** Allows users to create fitness and health plans for themselves and share their self-improvement journeys with others.
- **Market:** Anyone interested in fitness and overall health would enjoy this app.
- **Habit:** Health is something people should work on daily. Expanding beyond fitness (ex: diet, mental health) makes it even more applicable for daily use. Many current fitness apps are calorie/weight focused, but creating a plan focused on building habits and growth helps change one's lifestyle.
- **Scope:** Since the plan is mostly customized, the scope of what the app does can be varied. However, the app's main focus is creating the plan and reminded the user to complete tasks.

## Product Spec

https://user-images.githubusercontent.com/24441980/128757374-c2286ee8-d83b-4e8d-b28b-013e4d6f249b.mp4

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] User can create a new account, log in, and sign out of account
- [x] User sees profile with their fitness plan and accomplishments
- [x] User can edit their profile (either during onboarding or after)
- [x] User can log in or sign up through their Facebook Account (using Facebook SDK)
- [x] User can add new tasks
- [x] User can view tasks on Home screen
- [x] User can delete tasks
- [x] User can mark tasks on their plan as complete
- [x] User can view social feed of other people's daily accomplishments
- [x] User can double tap on a post to like it 
- [x] Splash screen animation
- [x] Algorithm to suggest tasks to users using airtable database

**Optional Nice-to-have Stories**

- [x] User can see a detailed view of their tasks
- [x] User can edit profile after creating it
- [x] User can see other people's profiles
- [x] Clicking on another person's email opens the Mail app
- [x] user can see a detail view of posts
- [x] User can like accomplishments on social feed
- [x] User can comment on accomplishments on social feed
- [x] User can add user biography

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

## Schema 
### Models

User 
| Property | Type | Description |
| -------- | -------- | -------- |
| objectId | String | unique id for the user (default field) |
| username | String | username|
| password | String | password |
| name | String | display name |
| profileImageURL | String | url link to user's profile photo|
| facebook profile ?|          |          |
| goals | pointer to Goal | connects user with their current goals |

Post
| Property | Type | Description |
| -------- | -------- | -------- |
| objectId | String | unique id for the post (default field) |
| likeCount | number | number of likes on post |
| goal | pointer to Goal | connects post to the goal where the contents of the post are from |
| author | pointer to user | author ID |

Task
| Property | Type | Description |
| -------- | -------- | -------- |
| objectId | String | unique id for the task (default field) |
| createdAt | DateTime | date created |
| expiresAt | DateTime | need a mechanism to remove the completed feature every day|
| completed | BOOL | if the task is completed or not |
| type | String | groups the task into different types: fitness, diet, spiritual, etc.|


### Networking
- Social Screen
    - (Read/GET) Query posts in personal and friend feed
- Home feed
    - (GET) Query current plan
    - (GET) today's tasks
- Create a fitness Plan (from profile)
    - (CREATE) Create a new plan 
- Profile
    - (GET) Query logged in user
    - optional: (Read/GET) query user's followers and following
