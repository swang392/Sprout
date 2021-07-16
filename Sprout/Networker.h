//
//  Networker.h
//  Sprout
//
//  Created by Sarah Wang on 7/15/21.
//

#import <Foundation/Foundation.h>
#import "Task.h"
#import "Post.h"
//#import "Goal.h"


NS_ASSUME_NONNULL_BEGIN

@interface Networker : NSObject

+ (void)createGoal:(NSMutableArray * _Nullable)tasks withTimeframe:(NSNumber *)timeframe withCompletion:(PFBooleanResultBlock _Nullable)completion;

//+ (void)createPostWithGoal:(Goal *)goal withAuthor:(PFUser *)author withLikeCount:(NSNumber *)likeCount withCompletion:(PFBooleanResultBlock _Nullable)completion;

+ (void)createTaskWithName:(NSString *)taskName withType:(NSString * _Nullable)type withStatus:(BOOL *)completed
                    withCompletion:(PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
