//
//  Task.h
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>
#import "Goal.h"

NS_ASSUME_NONNULL_BEGIN

@interface Task : PFObject<PFSubclassing>

@property (nonatomic) PFUser *author;
@property (nonatomic) BOOL completed;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *taskName;
 
+ (void)createTaskWithName:(NSString *)taskName 
                  withType:(NSString * _Nullable)type withCompletion:(PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
