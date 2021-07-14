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


+ (Goal *) postGoal:(NSArray * _Nullable)tasks withTimeframe:(NSNumber * _Nullable)timeframe withCompletion:(PFBooleanResultBlock _Nullable)completion;

//+ (void) postGoal: (NSNumber )
//+ (void) postGoal:(NSArray * _Nullable)users withName:(NSString * _Nullable)name withLocation:(NSString * _Nullable)location withStartDate:(NSDate * _Nullable)startDate withEndDate:(NSDate * _Nullable)endDate


@end

NS_ASSUME_NONNULL_END
