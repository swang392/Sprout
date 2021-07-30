//
//  TaskRecommender.m
//  Sprout
//
//  Created by Sarah Wang on 7/28/21.
//

#import "TaskRecommender.h"
#import "Parse/Parse.h"
#import "Task.h"

@implementation TaskRecommender

+ (instancetype)shared
{
    static dispatch_once_t nonce;
    static id instance;
    dispatch_once(&nonce, ^{
        instance = [self new];
    });
    return instance;
}

- (void)countUsers {
    PFQuery *userQuery = [PFUser query];
    [userQuery includeKey:@"objectId"];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            self.numUsers = [users count] * 1.0;
        } else {
            self.numUsers = nil;
        }
    }];
}

- (void)loadTaskAverages {
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *tasks, NSError *error) {
        if (tasks != nil) {
            self.tasks = (NSMutableArray *)tasks;
            [self countAverageTasks];
        } else {
            //TODO: handle error
        }
    }];
}

- (void)countAverageTasks {
    float physicalCount = 0.0;
    float dietCount = 0.0;
    float mentalCount = 0.0;
    
    for (Task *task in self.tasks) {
        if (![task.author.objectId isEqual:PFUser.currentUser.objectId]) {
            if ([task.type isEqual:@"Physical"]) {
                physicalCount++;
                [self updateRecommendationWithTask:task withType:@"Physical"];
            }
            else if ([task.type isEqual:@"Diet"]) {
                dietCount++;
                [self updateRecommendationWithTask:task withType:@"Diet"];
            }
            else if ([task.type isEqual:@"Mental"]) {
                mentalCount++;
                [self updateRecommendationWithTask:task withType:@"Mental"];
            }
        }
    }
    
    self.taskTypes = [NSMutableDictionary dictionary];
    [self.taskTypes setObject:[NSNumber numberWithFloat:physicalCount/self.numUsers] forKey:@"Physical"];
    [self.taskTypes setObject:[NSNumber numberWithFloat:dietCount/self.numUsers] forKey:@"Diet"];
    [self.taskTypes setObject:[NSNumber numberWithFloat:mentalCount/self.numUsers] forKey:@"Mental"];
}

- (void)getTaskTypesWithCompletion:(void(^)(NSMutableDictionary *taskDict, NSError *error))completion {
    if (self.taskTypes) {
        completion(self.taskTypes, nil);
    }
    else {
        //TODO: show error in getting types
    }
}

- (void)updateRecommendationWithTask:(Task *)task withType:(NSString *)type {
    if ([type isEqual:@"Physical"]) {
        if (task.completed) {
            self.physicalRecommendation = task.name;
        }
        else {
            self.backupPhysicalRecommendation = task.name;
        }
    }
    else if ([type isEqual:@"Mental"]) {
        if (task.completed) {
            self.mentalRecommendation = task.name;
        }
        else {
            self.backupMentalRecommendation = task.name;
        }
    }
    else if ([type isEqual:@"Diet"]) {
        if (task.completed) {
            self.dietRecommendation = task.name;
        }
        else {
            self.backupDietRecommendation = task.name;
        }
    }
}

- (void)getRecommendationWithType:(NSString *)type
                   withCompletion:(void(^)(NSString *recommendation, NSError *error))completion {
    if ([type isEqual:@"Physical"]) {
        if (self.physicalRecommendation) {
            completion(self.physicalRecommendation, nil);
        }
        else {
            completion(self.backupPhysicalRecommendation, nil);
        }
    }
    else if ([type isEqual:@"Diet"]) {
        if (self.dietRecommendation) {
            completion(self.dietRecommendation, nil);
        }
        else {
            completion(self.backupDietRecommendation, nil);
        }
    }
    else if ([type isEqual:@"Mental"]) {
        if (self.mentalRecommendation) {
            completion(self.mentalRecommendation, nil);
        }
        else {
            completion(self.backupMentalRecommendation, nil);
        }
    }
    else {
        //TODO: show error in getting types
    }
}

@end
