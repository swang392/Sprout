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

@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSNumber *completedTasks;
@property (nonatomic, strong) NSNumber *totalTasks;
@property (nonatomic, strong) NSString *caption;

+ (void)createPost:(NSString *)caption
     withCompleted:(NSNumber *)completedTasks
         withTotal:(NSNumber *)totalTasks
    withCompletion:(PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
