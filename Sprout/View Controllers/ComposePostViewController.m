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
@property (nonatomic, strong) PFUser *user;

@end

@implementation ComposePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.composeTextView.layer.borderWidth = 1.5f;
    self.composeTextView.layer.borderColor = [[UIColor colorWithRed:10/255.0 green:42/255.0 blue:92/255.0 alpha:1.0] CGColor];
    self.composeTextView.layer.cornerRadius = 8;
    self.user = PFUser.currentUser;
}

- (IBAction)didTapShare:(id)sender {
    NSNumber *totalTasks = self.user[@"totalTasks"];
    NSNumber *completedTasks = self.user[@"completedTasks"];
    NSString *caption = self.composeTextView.text;
    
    [Post createPost:caption withCompleted:completedTasks withTotal:totalTasks withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"created post successfully");
            [self dismissViewControllerAnimated:true completion:nil];
        }
        else {
            NSLog(@"Error creating task: %@", error.localizedDescription);
        }
    }];
}

@end
