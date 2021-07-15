//
//  Networker.m
//  Sprout
//
//  Created by Sarah Wang on 7/15/21.
//

#import "Networker.h"
#import "Task.h"
#import "Post.h"
#import "Goal.h"

@implementation Networker

+ (void)createGoal:(NSArray * _Nullable)tasks withTimeframe:(NSNumber *)timeframe withCompletion:(PFBooleanResultBlock _Nullable)completion {
    Goal *newGoal = [Goal new];
    
    newGoal.timeframe = timeframe;
    newGoal.tasks = tasks;
    
    [newGoal saveInBackgroundWithBlock:completion];
}

+ (void)createPostWithGoal:(Goal *)goal withAuthor:(PFUser *)author withLikeCount:(NSNumber *)likeCount withCompletion:(PFBooleanResultBlock _Nullable)completion {
    Post *newPost = [Post new];
    
    newPost.goal = goal;
    newPost.author = author;
    newPost.likeCount = 0;
    
    [newPost saveInBackgroundWithBlock:completion];
}

+ (void)createTaskWithName:(NSString *)taskName withDuration:(NSTimeInterval * _Nullable)duration
                  withType:(NSString * _Nullable)type withStatus:(BOOL *)completed withGoal:(Goal *)goal
            withCompletion:(PFBooleanResultBlock _Nullable)completion{
    Task *newTask = [Task new];
    
    newTask.taskName = taskName;
    newTask.duration = duration;
    newTask.type = type;
    newTask.completed = completed;
    newTask.goal = goal;
    
    [newTask saveInBackgroundWithBlock:completion];
}

@end
