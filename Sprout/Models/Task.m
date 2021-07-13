//
//  Task.m
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import "Task.h"

@implementation Task

@dynamic createdAt;
@dynamic expiresAt;
@dynamic completed;
@dynamic type;

+ (nonnull NSString *)parseClassName{
    return @"Task";
}

@end
