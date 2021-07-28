//
//  TaskRecommender.h
//  Sprout
//
//  Created by Sarah Wang on 7/28/21.
//

#import <Foundation/Foundation.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskRecommender : NSObject

@property (nonatomic) int numUsers;
@property (nonatomic) NSArray<Task *> *tasks;
@property (nonatomic) NSMutableDictionary *taskTypes;

+ (instancetype)shared;

- (void)countUsers;

- (void)loadTaskAverages;

- (void)countAverageTasks;

- (void)getTaskTypesWithCompletion:(void(^)(NSMutableDictionary *taskDict, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
