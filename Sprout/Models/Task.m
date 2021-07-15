//
//  Task.m
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import "Task.h"

@implementation Task

//@dynamic createdAt;
//@dynamic expiresAt;
//@dynamic taskStatus;
//@dynamic duration;
@dynamic completed;
@dynamic type;
@dynamic taskName;
@dynamic author;
//@dynamic goal;

+ (nonnull NSString *)parseClassName{
    return @"Task";
}

+ (void)createTaskWithName:(NSString *)taskName
                  withType:(NSString * _Nullable)type
            withCompletion:(PFBooleanResultBlock _Nullable)completion{
    Task *newTask = [Task new];
    
    newTask.author = [PFUser currentUser];
    newTask.taskName = taskName;
    newTask.type = type;
    newTask.completed = false;
    
    [newTask saveInBackgroundWithBlock:completion];
}

@end
