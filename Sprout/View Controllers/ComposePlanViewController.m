//
//  ComposePlanViewController.m
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import "ComposePlanViewController.h"
#import "Networker.h"
#import "Task.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"

@interface ComposePlanViewController ()

@property (weak, nonatomic) IBOutlet UITextField *taskNameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskTypeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskFrequencyControl;
@property (weak, nonatomic) IBOutlet UIButton *addTaskButton;
@property (nonatomic) UIAlertController *addTaskAlert;
@property (nonatomic) UIAlertController *recommendationAlert;
@property (nonatomic) NSMutableArray<Task *> *tasks;
@property (nonatomic) NSMutableDictionary *taskTypes;
@property (nonatomic) int userCount;
@property (nonatomic) int myPhysicalCount;
@property (nonatomic) int myMentalCount;
@property (nonatomic) int myDietCount;

@end

@implementation ComposePlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self countUsers];
    
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
            if(!succeeded){
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

- (void)countUsers {
    PFQuery *userQuery = [PFUser query];
    [userQuery includeKey:@"objectId"];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            self.userCount = [users count] - 1.0;
            NSLog(@"user count %d", self.userCount);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)recommendTasks {
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *tasks, NSError *error) {
        if (tasks != nil) {
            self.tasks = (NSMutableArray *)tasks;
            [self countAverageTasks];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
 
- (void)countAverageTasks {
    float physicalCount = 0.0;
    float dietCount = 0.0;
    float mentalCount = 0.0;
    
    for (Task *task in self.tasks) {
        if (![task.author.objectId isEqual:PFUser.currentUser.objectId]) {
            if ([task.type isEqual:@"Physical"]) {
                physicalCount++;
            }
            else if ([task.type isEqual:@"Diet"]) {
                dietCount++;
            }
            else if ([task.type isEqual:@"Mental"]) {
                mentalCount++;
            }
        }
        else {
            if ([task.type isEqual:@"Physical"]) {
                self.myPhysicalCount++;
            }
            else if ([task.type isEqual:@"Diet"]) {
                self.myDietCount++;
            }
            else if ([task.type isEqual:@"Mental"]) {
                self.myPhysicalCount++;
            }
        }
    }
    
    //TODO: delete this stuff later
    NSLog(@"physical count %f", physicalCount/self.userCount);
    NSLog(@"diet count %f", dietCount/self.userCount);
    NSLog(@"mental count %f", mentalCount/self.userCount);
    NSLog(@"my physical count %d", self.myPhysicalCount);
    NSLog(@"my diet count %d", self.myDietCount);
    NSLog(@"my mental count %d", self.myMentalCount);
    
    self.taskTypes = [NSMutableDictionary dictionary];
    [self.taskTypes setObject:[NSNumber numberWithInteger:physicalCount/self.userCount] forKey:@"Physical"];
    [self.taskTypes setObject:[NSNumber numberWithInteger:dietCount/self.userCount] forKey:@"Diet"];
    [self.taskTypes setObject:[NSNumber numberWithInteger:mentalCount/self.userCount] forKey:@"Mental"];
    
    [self presentRecommendationAlert];
}

- (void)presentRecommendationAlert {
    NSString *alertText = nil;
    BOOL presentRecommendation = false;
    
    if (self.myPhysicalCount < [[self.taskTypes objectForKey:@"Physical"] intValue]) {
        alertText = @"Other Sprout users have more physical health tasks!";
        presentRecommendation = true;
    }
    else if (self.myMentalCount < [[self.taskTypes objectForKey:@"Mental"] intValue]) {
        alertText = @"Other Sprout users have more mental health tasks!";
        presentRecommendation = true;
    }
    else if (self.myDietCount < [[self.taskTypes objectForKey:@"Diet"] intValue]) {
        alertText = @"Other Sprout users have more diet-related tasks!";
        presentRecommendation = true;
    }
    
    if (presentRecommendation) {
        self.recommendationAlert = [UIAlertController alertControllerWithTitle:@"Need a recommendation?" message:alertText preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //handle response here
        }];
        [self.recommendationAlert addAction:okAction];
        [self presentViewController:self.recommendationAlert animated:YES completion:^{
        }];
    }
}

@end
