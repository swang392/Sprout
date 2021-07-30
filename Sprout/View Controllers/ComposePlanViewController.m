//
//  ComposePlanViewController.m
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#include <stdlib.h>
#import "ComposePlanViewController.h"
#import "Networker.h"
#import "Task.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "TaskRecommender.h"

@interface ComposePlanViewController ()

@property (weak, nonatomic) IBOutlet UITextField *taskNameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskTypeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskFrequencyControl;
@property (weak, nonatomic) IBOutlet UIButton *addTaskButton;
@property (nonatomic) UIAlertController *addTaskAlert;
@property (nonatomic) UIAlertController *recommendationAlert;
@property (nonatomic) NSMutableArray<Task *> *myTasks;

@end

@implementation ComposePlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.taskTypeControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    self.taskFrequencyControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    
    [self createAlerts];
    
    [self recommendTasks];
}

- (void)createAlerts {
    self.addTaskAlert = [UIAlertController alertControllerWithTitle:@"Please complete all fields to create a task." message:@"Try again!" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
    }];
    [self.addTaskAlert addAction:okAction];
}

- (IBAction)finishedAddingTasks:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)addTaskButton:(id)sender {
    if ([self.taskNameField.text isEqual:@""] || self.taskTypeControl.selectedSegmentIndex == UISegmentedControlNoSegment || self.taskFrequencyControl.selectedSegmentIndex == UISegmentedControlNoSegment)
    {
        [self presentViewController:self.addTaskAlert animated:YES completion:^{
        }];
    }
    else {
        NSString *taskName = self.taskNameField.text;
        
        NSString *taskType = @"Physical";
        if (self.taskTypeControl.selectedSegmentIndex == 1) {
            taskType = @"Diet";
        }
        else if (self.taskTypeControl.selectedSegmentIndex == 2) {
            taskType = @"Mental";
        }
        else if (self.taskTypeControl.selectedSegmentIndex == 3) {
            taskType = @"Miscellaneous";
        }
        
        NSString *timeframe = @"Daily";
        if (self.taskFrequencyControl.selectedSegmentIndex == 1) {
            timeframe = @"Weekly";
        }
        
        [Task createTaskWithName:taskName withTimeframe:timeframe withType:taskType withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (!succeeded) {
                //TODO: - Show an alert for unexpected error
            }
        }];
        
        self.taskNameField.text = nil;
        self.taskTypeControl.selectedSegmentIndex = UISegmentedControlNoSegment;
        self.taskFrequencyControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    }
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:true];
}

- (void)recommendTasks {
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query whereKey:@"author" equalTo:PFUser.currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *tasks, NSError *error) {
        if (tasks != nil) {
            self.myTasks = (NSMutableArray *)tasks;
            [self presentRecommendationAlert];
        } else {
            //TODO: handle error
        }
    }];
}

- (void)presentRecommendationAlert {
    [TaskRecommender.shared getTaskTypesWithCompletion:^(NSMutableDictionary * _Nonnull taskDict, NSError * _Nonnull error) {
        NSString *alertHeaderText = nil;
        __block NSString *alertText= nil;
        __block NSString *recommendationType = nil;
        
        BOOL presentRecommendation = false;
        
        if ([self.myPhysicalCount intValue] < [[taskDict objectForKey:@"Physical"] floatValue]) {
            alertHeaderText = @"Need a recommendation? Add a physical health task!";
            presentRecommendation = true;
            recommendationType = @"Physical";
        }
        else if ([self.myMentalCount intValue] < [[taskDict objectForKey:@"Mental"] floatValue]) {
            alertHeaderText = @"Need a recommendation? Add a mental health task!";
            presentRecommendation = true;
            recommendationType = @"Mental";
        }
        else if ([self.myDietCount intValue] < [[taskDict objectForKey:@"Diet"] floatValue]) {
            alertHeaderText = @"Need a recommendation? Add a diet-related task!";
            presentRecommendation = true;
            recommendationType = @"Diet";
        }
        
        [TaskRecommender.shared getRecommendationWithType:recommendationType withCompletion:^(NSString * _Nonnull recommendation, NSError * _Nonnull error) {
            if (presentRecommendation) {
                alertText = [NSString stringWithFormat:@"Another Sprout user has the following task: %@", recommendation];
                if ([recommendationType isEqual:@"Physical"]) {
                    int random = arc4random_uniform(88);
                    alertText = [NSString stringWithFormat:@"Try out this exercise: %@", self.exercises[random][@"fields"][@"Exercise"]];
                }
                self.recommendationAlert = [UIAlertController alertControllerWithTitle:alertHeaderText message:alertText preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //handle response here
                }];
                [self.recommendationAlert addAction:okAction];
                [self presentViewController:self.recommendationAlert animated:YES completion:^{
                }];
            }
        }];
    }];
}

@end
