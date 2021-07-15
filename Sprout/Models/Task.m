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
//@dynamic goal;

+ (nonnull NSString *)parseClassName{
    return @"Task";
}

+ (void)createTaskWithName:(NSString *)taskName withDuration:(NSTimeInterval * _Nullable)duration
                  withType:(NSString * _Nullable)type withStatus:(BOOL *)completed
            withCompletion:(PFBooleanResultBlock _Nullable)completion{
    Task *newTask = [Task new];
    
    newTask.taskName = taskName;
    newTask.duration = duration;
    newTask.type = type;
    newTask.completed = completed;
    //newTask.goal = goal;
    
    [newTask saveInBackgroundWithBlock:completion];
    //return newTask;
}


- (instancetype)initTaskWithName:(NSString *)taskName
                        withType:(NSString * _Nullable)type withStatus:(BOOL * _Nullable)completed{
    if(self = [super init]){
        self.taskName = taskName;
        //self.duration = duration;
        self.type = type;
        self.completed = completed;
    }
    return self;
}
/*
- (instancetype)initTaskWithName:(NSString *)taskName withDuration:(NSTimeInterval * _Nullable)duration
                        withType:(NSString * _Nullable)type withStatus:(BOOL * _Nullable)completed{
    if(self = [super init]){
        self.taskName = taskName;
        self.duration = duration;
        self.type = type;
        self.completed = completed;
    }
    return self;
}
 */
//- (instancetype) initwithName:(NSString *)taskName withCompleted:(BOOL *)completed withDuration(NSTimeInterval *)duration;

@end
