//
//  Goal.h
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

@class Task;

NS_ASSUME_NONNULL_BEGIN

@interface Goal : PFObject <PFSubclassing>

@property (nonatomic, strong) NSNumber *timeframe;
@property (nonatomic, strong) NSArray<Task *> *tasks;




@end

NS_ASSUME_NONNULL_END
