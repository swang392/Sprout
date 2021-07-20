//
//  ComposePlanViewController.m
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import "ComposePlanViewController.h"
#import "Networker.h"
#import "Task.h"

@interface ComposePlanViewController ()

@property (weak, nonatomic) IBOutlet UITextField *taskNameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskTypeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskFrequencyControl;
@property (weak, nonatomic) IBOutlet UIButton *addTaskButton;
@property (nonatomic, strong) NSMutableArray<Task *> *arrayOfTasks;
@property (strong, nonatomic) UIAlertController *addTaskAlert;

@end

@implementation ComposePlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.taskTypeControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    self.taskFrequencyControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    
    self.addTaskAlert = [UIAlertController alertControllerWithTitle:@"Please complete all fields to create a task." message:@"Try again!" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
    }];
    [self.addTaskAlert addAction:okAction];
}

- (IBAction)finishedAddingTasks:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)addTaskButton:(id)sender {
    if([self.taskNameField.text isEqual:@""] || self.taskTypeControl.selectedSegmentIndex == UISegmentedControlNoSegment || self.taskFrequencyControl.selectedSegmentIndex == UISegmentedControlNoSegment)
    {
        [self presentViewController:self.addTaskAlert animated:YES completion:^{
        }];
    }
    else {
        NSString *taskName = self.taskNameField.text;
       
        NSString *taskType = @"Physical";
        if(self.taskTypeControl.selectedSegmentIndex == 1){
            taskType = @"Diet";
        }
        else if(self.taskTypeControl.selectedSegmentIndex == 2){
            taskType = @"Mental";
        }
        else if(self.taskTypeControl.selectedSegmentIndex == 3){
            taskType = @"Miscellaneous";
        }
        
        NSString *timeframe = @"Daily";
        if(self.taskFrequencyControl.selectedSegmentIndex == 1)
            timeframe = @"Weekly";
        
        [Task createTaskWithName:taskName withTimeframe:timeframe withType:taskType withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"created task successfully");
            }
            else {
                NSLog(@"Error creating task: %@", error.localizedDescription);
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

@end
