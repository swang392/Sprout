//
//  TaskCell.h
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *taskLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeframeLabel;
@property (weak, nonatomic) IBOutlet UIButton *completedButton;
@property (nonatomic, strong) Task *task;

- (void)refreshData;

- (void)markCompleteness:(BOOL) completedStatus;

@end

NS_ASSUME_NONNULL_END
