//
//  Networker.h
//  Sprout
//
//  Created by Sarah Wang on 7/15/21.
//

#import <Foundation/Foundation.h>
#import "Task.h"
#import "Post.h"


NS_ASSUME_NONNULL_BEGIN

@interface Networker : NSObject

+ (void)createTaskWithName:(NSString *)taskName withType:(NSString * _Nullable)type withStatus:(BOOL *)completed
                    withCompletion:(PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
