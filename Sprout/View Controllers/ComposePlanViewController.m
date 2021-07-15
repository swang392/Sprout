//
//  ComposePlanViewController.m
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import "ComposePlanViewController.h"
#import "Goal.h"
#import "Networker.h"
#import "Task.h"

@interface ComposePlanViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *timeframeControl;
@property (weak, nonatomic) IBOutlet UIButton *saveTimeframe;
@property (weak, nonatomic) IBOutlet UITextField *taskNameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskTypeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskFrequencyControl;
@property (weak, nonatomic) IBOutlet UIButton *addTaskButton;
@property (weak, nonatomic) IBOutlet UIButton *saveGoal;
@property (nonatomic, strong) NSNumber *timeframe;
@property (nonatomic, strong) NSMutableArray<Task *> *arrayOfTasks;

//typedef double NSTimeInterval;

@end

@implementation ComposePlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)saveTimeFrame:(id)sender {
    _timeframe = @7;
    if(self.timeframeControl.selectedSegmentIndex == 1)
    {
        _timeframe = @14;
        NSLog(@"%@", _timeframe);
    }
    if(self.timeframeControl.selectedSegmentIndex == 2)
    {
        _timeframe = @21;
        NSLog(@"%@", _timeframe);
    }
}

- (IBAction)addTaskButton:(id)sender {
    NSString *taskName = self.taskNameField.text;
    
    NSTimeInterval duration = 86400.0;
    if(self.taskFrequencyControl.selectedSegmentIndex == 1)
    {
        duration = 604800.0;
    }
    
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
    BOOL completed = false;
    Task *newTask = [[Task alloc] initTaskWithName:taskName withType:taskType withStatus:&completed];
    //Task *newTask = [[Task alloc] initTaskWithName:taskName withDuration:&duration withType:taskType withStatus:&completed];
}

- (IBAction)saveGoal:(id)sender {
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:true];
}

@end
