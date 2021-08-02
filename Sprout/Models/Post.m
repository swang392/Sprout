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
@dynamic completedTasks;
@dynamic totalTasks;
@dynamic caption;
@dynamic usersWhoLiked;
@dynamic commentCount;
@dynamic comments;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void)createPost:(NSString *)caption
     withCompleted:(NSNumber *)completedTasks
         withTotal:(NSNumber *)totalTasks
    withCompletion:(PFBooleanResultBlock _Nullable)completion {
    Post *newPost = [Post new];
    
    newPost.author = [PFUser currentUser];
    newPost.likeCount = @(0);
    newPost.completedTasks = completedTasks;
    newPost.totalTasks = totalTasks;
    newPost.caption = caption;
    newPost.usersWhoLiked = [NSArray new];
    newPost.commentCount = @(0);
    newPost.comments = [NSArray new];
    
    [newPost saveInBackgroundWithBlock:completion];
}

@end
