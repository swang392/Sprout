//
//  ComposePlanViewController.h
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComposePlanViewController : UIViewController

@property (nonatomic) NSNumber *myPhysicalCount;
@property (nonatomic) NSNumber *myMentalCount;
@property (nonatomic) NSNumber *myDietCount;
@property (nonatomic) NSMutableArray *exercises;

@end

NS_ASSUME_NONNULL_END
