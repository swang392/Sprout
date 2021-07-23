//
//  TaskDetailsViewController.h
//  Sprout
//
//  Created by Sarah Wang on 7/23/21.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskDetailsViewController : UIViewController

@property (strong, nonatomic) Task *task;

@end

NS_ASSUME_NONNULL_END
