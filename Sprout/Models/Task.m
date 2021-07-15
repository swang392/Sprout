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
@dynamic duration;
@dynamic completed;
@dynamic type;
@dynamic taskName;
@dynamic goal;

+ (nonnull NSString *)parseClassName{
    return @"Task";
}

//- (instancetype) initwithName:(NSString *)taskName withCompleted:(BOOL *)completed withDuration(NSTimeInterval *)duration;

@end
