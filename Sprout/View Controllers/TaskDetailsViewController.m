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
    //TODO: add button stuff so users can complete/not complete here.
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

@end
