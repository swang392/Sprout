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

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *expiresAt;
@property (nonatomic) BOOL *completed;
@property (nonatomic, strong) NSString *type;

@end

NS_ASSUME_NONNULL_END
