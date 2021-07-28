//
//  TaskRecommender.m
//  Sprout
//
//  Created by Sarah Wang on 7/28/21.
//

#import "TaskRecommender.h"

@implementation TaskRecommender

static TaskRecommender *recommendations = nil;

+ (id)sharedTaskRecommender
{
    if (!recommendations) {
        recommendations = [TaskRecommender new];
    }
    return recommendations;
}

- (id)init
{
    if (!recommendations) {
        recommendations = [super init];
    }
    return recommendations;
}

@end
