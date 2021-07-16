//
//  Post.m
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import "Post.h"

@implementation Post

@dynamic likeCount;
@dynamic author;

+ (nonnull NSString *)parseClassName{
    return @"Post";
}

@end
