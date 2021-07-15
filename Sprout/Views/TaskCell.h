//
//  TaskCell.h
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *taskLabel;
@property (weak, nonatomic) IBOutlet UIButton *completedButton;

@end

NS_ASSUME_NONNULL_END
