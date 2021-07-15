//
//  Networker.h
//  Sprout
//
//  Created by Sarah Wang on 7/15/21.
//

#import <Foundation/Foundation.h>
#import "Task.h"
#import "Post.h"
#import "Goal.h"


NS_ASSUME_NONNULL_BEGIN

@interface Networker : NSObject

+ (void)createGoal:(NSArray * _Nullable)tasks withTimeframe:(NSNumber *)timeframe withCompletion:(PFBooleanResultBlock _Nullable)completion;

+ (void)createPostWithGoal:(Goal *)goal withAuthor:(PFUser *)author withLikeCount:(NSNumber *)likeCount withCompletion:(PFBooleanResultBlock _Nullable)completion;

+ (void)createTaskWithName:(NSString *)taskName withDuration:(NSTimeInterval * _Nullable)duration
                  withType:(NSString * _Nullable)type withStatus:(BOOL *)completed withGoal:(Goal *)goal
                    withCompletion:(PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
