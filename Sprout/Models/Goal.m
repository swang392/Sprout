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
@dynamic author;

+ (nonnull NSString *)parseClassName{
    return @"Goal";
}

@end
