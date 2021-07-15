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
