//
//  Networker.m
//  Sprout
//
//  Created by Sarah Wang on 7/15/21.
//

#import "Networker.h"
#import "Task.h"
#import "Post.h"
//#import "Goal.h"

@implementation Networker

/*

+ (void)createPostWithGoal:(Goal *)goal withAuthor:(PFUser *)author withLikeCount:(NSNumber *)likeCount withCompletion:(PFBooleanResultBlock _Nullable)completion {
    Post *newPost = [Post new];
    
    newPost.goal = goal;
    newPost.author = author;
    newPost.likeCount = 0;
    
    [newPost saveInBackgroundWithBlock:completion];
}
 */

+ (void)createTaskWithName:(NSString *)taskName withType:(NSString * _Nullable)type withStatus:(BOOL *)completed
            withCompletion:(PFBooleanResultBlock _Nullable)completion{
    Task *newTask = [Task new];
    
    newTask.taskName = taskName;
    newTask.type = type;
    newTask.completed = completed;
    
    [newTask saveInBackgroundWithBlock:completion];
}

@end
