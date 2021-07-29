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
@property (nonatomic) NSArray<NSString *> *stravaActivityTypes;
@property (nonatomic) NSString *dietRecommendation;
@property (nonatomic) NSString *physicalRecommendation;
@property (nonatomic) NSString *mentalRecommendation;
@property (nonatomic) NSString *backupDietRecommendation;
@property (nonatomic) NSString *backupPhysicalRecommendation;
@property (nonatomic) NSString *backupMentalRecommendation;

+ (instancetype)shared;

- (void)countUsers;

- (void)loadTaskAverages;

- (void)countAverageTasks;

- (void)getTaskTypesWithCompletion:(void(^)(NSMutableDictionary *taskDict, NSError *error))completion;

- (void)updateRecommendationWithTask:(Task *)task
                            withType:(NSString *)type;

- (void)getRecommendationWithType:(NSString *)type
                   withCompletion:(void(^)(NSString *recommendation, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
