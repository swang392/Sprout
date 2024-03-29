//
//  ComposePostViewController.m
//  Sprout
//
//  Created by Sarah Wang on 7/19/21.
//

#import "ComposePostViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Post.h"
#import "Task.h"

@interface ComposePostViewController ()
@property (weak, nonatomic) IBOutlet UITextView *composeTextView;
@property (nonatomic) PFUser *user;
@property (nonatomic) UIAlertController *postAlert;

@end

@implementation ComposePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *color = [[UIColor alloc]initWithRed:243/255.0 green:222/255.0 blue:229/255.0 alpha:1.0];
    self.composeTextView.layer.borderWidth = 1.5f;
    self.composeTextView.layer.borderColor = [color CGColor];
    self.composeTextView.layer.cornerRadius = 8;
    self.user = PFUser.currentUser;
    
    [self createAlerts];
}

- (void) createAlerts {
    self.postAlert = [UIAlertController alertControllerWithTitle:@"Please write a caption to post." message:@"Try again!" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
    }];
    [self.postAlert addAction:okAction];
}

- (IBAction)cancelPost:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTapShare:(id)sender {
    if ([self.composeTextView.text isEqual:@""]) {
        [self presentViewController:self.postAlert animated:YES completion:^{
        }];
    }
    else {
        NSNumber *totalTasks = self.user[@"totalTasks"];
        NSNumber *completedTasks = self.user[@"completedTasks"];
        NSString *caption = self.composeTextView.text;
        
        [Post createPost:caption withCompleted:completedTasks withTotal:totalTasks withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (!succeeded) {
                //TODO: - Show an alert for unexpected error
            }
        }];
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:true];
}

@end
