//
//  Post.h
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (nonatomic) NSNumber *likeCount;
@property (nonatomic) PFUser *author;
@property (nonatomic) NSNumber *completedTasks;
@property (nonatomic) NSNumber *totalTasks;
@property (nonatomic) NSString *caption;
@property (nonatomic) NSArray *usersWhoLiked;

+ (void)createPost:(NSString *)caption
     withCompleted:(NSNumber *)completedTasks
         withTotal:(NSNumber *)totalTasks
    withCompletion:(PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
