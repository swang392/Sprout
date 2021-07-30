//
//  TaskDetailsViewController.m
//  Sprout
//
//  Created by Sarah Wang on 7/23/21.
//

#import "TaskDetailsViewController.h"

@interface TaskDetailsViewController () <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *completedButton;
@property (weak, nonatomic) IBOutlet UILabel *timeframeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation TaskDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshData];
}

- (void)refreshData {
    self.taskNameLabel.text = self.task.name;
    self.timeframeLabel.text = self.task.timeframe;
    self.typeLabel.text = self.task.type;
    
    [self markCompleteness:self.task.completed];
}

- (IBAction)deleteTask:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query whereKey:@"name" equalTo:self.task.name];
    [query whereKey:@"author" equalTo:self.task.author];
    [query findObjectsInBackgroundWithBlock:^(NSArray *tasks, NSError *error) {
        if (tasks != nil) {
            for (Task *task in tasks) {
                [task deleteInBackground];
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
    //TODO: make tasks refresh without pulling to refresh.
}

- (IBAction)didTapCompleted:(id)sender {
    PFUser *current = [PFUser currentUser];
    self.task.completed = !self.task.completed;
    if (self.task.completed) {
        current[@"completedTasks"] =  [NSNumber numberWithInt:[current[@"completedTasks"] intValue] + 1];
    }
    else {
        current[@"completedTasks"] =  [NSNumber numberWithInt:[current[@"completedTasks"] intValue] - 1];
    }
    [current saveInBackground];
    [self.task saveInBackground];
    [self markCompleteness:self.task.completed];
}

- (void)markCompleteness:(BOOL) completedStatus {
    if (completedStatus) {
        UIImage *image = [UIImage systemImageNamed:@"checkmark.square.fill" withConfiguration:[UIImageSymbolConfiguration configurationWithScale:(UIImageSymbolScaleLarge)]];
        [self.completedButton setImage:image forState:UIControlStateNormal];
        UIColor *customColor = [[UIColor alloc]initWithRed:10/255.0 green:42/255.0 blue:92/255.0 alpha:1.0];
        [self.completedButton setTintColor:customColor];
    }
    else {
        UIImage *image = [UIImage systemImageNamed:@"square" withConfiguration:[UIImageSymbolConfiguration configurationWithScale:(UIImageSymbolScaleLarge)]];
        [self.completedButton setImage:image forState:UIControlStateNormal];
        UIColor *customColor = [[UIColor alloc]initWithRed:10/255.0 green:42/255.0 blue:92/255.0 alpha:1.0];
        [self.completedButton setTintColor:customColor];
    }
}

@end
