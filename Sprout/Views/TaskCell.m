//
//  TaskCell.m
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import "TaskCell.h"
#import "Task.h"
#import "Parse/Parse.h"

@implementation TaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)refreshData {
    self.timeframeLabel.text = self.task.timeframe;
    self.taskLabel.text = self.task.name;
    if(self.task.completed){
        [self markAsCompleted];
    }
    else{
        [self markAsIncompleted];
    }
}
- (IBAction)didTapCompleted:(id)sender {
    if(self.task.completed){
        self.task.completed = false;
        [self.task saveInBackground];
        
        [self markAsIncompleted];
    }
    else {
        self.task.completed = true;
        [self.task saveInBackground];
        
        [self markAsCompleted];
    }
}

- (void)markAsCompleted {
    UIImage *image = [UIImage systemImageNamed:@"checkmark.square.fill" withConfiguration:[UIImageSymbolConfiguration configurationWithScale:(UIImageSymbolScaleLarge)]];
    [self.completedButton setImage:image forState:UIControlStateNormal];
    UIColor *customColor = [[UIColor alloc]initWithRed:10/255.0 green:42/255.0 blue:92/255.0 alpha:1.0];
    [self.completedButton setTintColor:customColor];
}

- (void)markAsIncompleted {
    UIImage *image = [UIImage systemImageNamed:@"square" withConfiguration:[UIImageSymbolConfiguration configurationWithScale:(UIImageSymbolScaleLarge)]];
    [self.completedButton setImage:image forState:UIControlStateNormal];
    UIColor *customColor = [[UIColor alloc]initWithRed:10/255.0 green:42/255.0 blue:92/255.0 alpha:1.0];
    [self.completedButton setTintColor:customColor];
    
}

@end
