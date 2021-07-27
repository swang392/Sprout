//
//  Task.m
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import "Task.h"
#import "Parse.h"

@implementation Task

@dynamic completed;
@dynamic type;
@dynamic name;
@dynamic author;
@dynamic timeframe;

+ (nonnull NSString *)parseClassName {
    return @"Task";
}

+ (void)createTaskWithName:(NSString *)taskName
             withTimeframe:(NSString *)timeframe
                  withType:(NSString * _Nullable)type
            withCompletion:(PFBooleanResultBlock _Nullable)completion {
    Task *newTask = [Task new];
    PFUser *current = [PFUser currentUser];
    
    newTask.author = current;
    newTask.name = taskName;
    newTask.type = type;
    newTask.completed = false;
    newTask.timeframe = timeframe;
    
    current[@"totalTasks"] =  [NSNumber numberWithInt:[current[@"totalTasks"] intValue] + 1];
    [current saveInBackground];
    
    [newTask saveInBackgroundWithBlock:completion];
}

@end
