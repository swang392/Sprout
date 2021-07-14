//
//  Goal.m
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import "Goal.h"

@implementation Goal

@dynamic timeframe;
@dynamic tasks;

//^^ why are these dynamic?

+ (nonnull NSString *)parseClassName{
    return @"Goal";
}

+ (Goal *) postGoal:(NSArray * _Nullable)tasks withTimeframe:(NSNumber * _Nullable)timeframe withCompletion:(PFBooleanResultBlock _Nullable)completion {
    Goal *newGoal = [Goal new];
    newGoal.timeframe = timeframe;
    newGoal.tasks = tasks;
    
    [newGoal saveInBackgroundWithBlock: completion];
    return newGoal;
}

@end

//
//@implementation Goal
//@end
//
//@implementation GoalBuilder
//
//+ (nullable Goal *)buildGoalFromRemoteGoal:(ParseGoal *)goal
//{
//    // make sure there's an author
//    // make sure it's not expired
//    // do all data validation
//    // return goal if it's valid still
//}
//
//@end
