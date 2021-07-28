//
//  SignUpViewController.m
//  Sprout
//
//  Created by Sarah Wang on 7/26/21.
//

#import "SignUpViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "HomeViewController.h"
#import "UITextView+Placeholder.h"
#import "TaskRecommender.h"

@interface SignUpViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIAlertController *blankAlert;
@property (nonatomic) UIAlertController *registrationAlert;
@property (weak, nonatomic) IBOutlet UITextView *usernameField;
@property (weak, nonatomic) IBOutlet UITextView *passwordField;
@property (weak, nonatomic) IBOutlet UITextView *nameField;
@property (weak, nonatomic) IBOutlet UITextView *emailField;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createAlerts];
    [self formatTextViews];
}

- (void)formatTextViews {
    UIColor *color = [[UIColor alloc]initWithRed:10/255.0 green:42/255.0 blue:92/255.0 alpha:1.0];
    
    self.usernameField.delegate = self;
    self.usernameField.layer.borderWidth = 1.0f;
    self.usernameField.layer.borderColor = [color CGColor];
    self.usernameField.layer.cornerRadius = 8;
    self.usernameField.placeholder = @"username";
    
    self.passwordField.delegate = self;
    self.passwordField.layer.borderWidth = 1.0f;
    self.passwordField.layer.borderColor = [color CGColor];
    self.passwordField.layer.cornerRadius = 8;
    self.passwordField.placeholder = @"password";
    
    self.nameField.delegate = self;
    self.nameField.layer.borderWidth = 1.0f;
    self.nameField.layer.borderColor = [color CGColor];
    self.nameField.layer.cornerRadius = 8;
    self.nameField.placeholder = @"name";
    
    self.emailField.delegate = self;
    self.emailField.layer.borderWidth = 1.0f;
    self.emailField.layer.borderColor = [color CGColor];
    self.emailField.layer.cornerRadius = 8;
    self.emailField.placeholder = @"email";
}

- (void)createAlerts{
    self.blankAlert = [UIAlertController alertControllerWithTitle:@"One of these fields is empty." message:@"Please try again!" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
    }];
    [self.blankAlert addAction:okAction];
    
    self.registrationAlert = [UIAlertController alertControllerWithTitle:@"Error registering user." message:@"Please try again!" preferredStyle:(UIAlertControllerStyleAlert)];
    [self.registrationAlert addAction:okAction];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:true];
}

//TODO: add pfp

- (IBAction)registerUser:(id)sender {
    [self.activityIndicator startAnimating];
    
    if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]
       || [self.nameField.text isEqual:@""] || [self.emailField.text isEqual:@""])
    {
        [self presentViewController:self.blankAlert animated:YES completion:^{
            [self.activityIndicator stopAnimating];
        }];
    }
    else
    {
        PFUser *newUser = [PFUser user];
        
        newUser.username = self.usernameField.text;
        newUser.password = self.passwordField.text;
        newUser[@"name"] = self.nameField.text;
        newUser[@"email"] = self.emailField.text;
        newUser[@"completedTasks"] = @0;
        newUser[@"totalTasks"] = @0;
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                //TODO: - Show an alert for unexpected error
                [self presentViewController:self.registrationAlert animated:YES completion:^{
                    [self.activityIndicator stopAnimating];
                }];
            } else {
                [self.activityIndicator stopAnimating];
                [self showTabBar];
            }
        }];
    }
}

- (void)showTabBar {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

    [sceneDelegate changeRootViewController:viewController];
    
    [TaskRecommender.shared countUsers];
}

@end
