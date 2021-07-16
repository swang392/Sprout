//
//  Networker.m
//  Sprout
//
//  Created by Sarah Wang on 7/15/21.
//

#import "Networker.h"
#import "Task.h"
#import "Post.h"

@implementation Networker

+ (void)createTaskWithName:(NSString *)taskName withType:(NSString * _Nullable)type withStatus:(BOOL *)completed
            withCompletion:(PFBooleanResultBlock _Nullable)completion{
    Task *newTask = [Task new];
    
    newTask.name = taskName;
    newTask.type = type;
    newTask.completed = completed;
    
    [newTask saveInBackgroundWithBlock:completion];
}

@end
