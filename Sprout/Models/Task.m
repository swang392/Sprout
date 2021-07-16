//
//  Task.m
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import "Task.h"

@implementation Task

@dynamic completed;
@dynamic type;
@dynamic taskName;
@dynamic author;
@dynamic timeframe;

+ (nonnull NSString *)parseClassName{
    return @"Task";
}

+ (void)createTaskWithName:(NSString *)taskName withTimeframe:(NSString *)timeframe
                  withType:(NSString * _Nullable)type
            withCompletion:(PFBooleanResultBlock _Nullable)completion{
    Task *newTask = [Task new];
    
    newTask.author = [PFUser currentUser];
    newTask.taskName = taskName;
    newTask.type = type;
    newTask.completed = false;
    newTask.timeframe = timeframe;
    
    [newTask saveInBackgroundWithBlock:completion];
}

@end
