//
//  LoginViewController.m
//  Sprout
//
//  Created by Sarah Wang on 7/12/21.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIAlertController *blankAlert;
@property (strong, nonatomic) UIAlertController *registrationAlert;
@property (strong, nonatomic) UIAlertController *loginAlert;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.blankAlert = [UIAlertController alertControllerWithTitle:@"Username or password is empty." message:@"Please try again!" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
    }];
    [self.blankAlert addAction:okAction];
    
    self.registrationAlert = [UIAlertController alertControllerWithTitle:@"Error registering user." message:@"Please try again!" preferredStyle:(UIAlertControllerStyleAlert)];
    [self.registrationAlert addAction:okAction];
    
    self.loginAlert = [UIAlertController alertControllerWithTitle:@"Error during user login." message:@"Please try again!" preferredStyle:(UIAlertControllerStyleAlert)];
    [self.loginAlert addAction:okAction];

}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)registerUser:(id)sender {
    [self.activityIndicator startAnimating];
    
    if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""])
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
        newUser[@"completedTasks"] = @0;
        newUser[@"totalTasks"] = @0;
        [newUser saveInBackground];

        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                [self presentViewController:self.registrationAlert animated:YES completion:^{
                    [self.activityIndicator stopAnimating];
                }];
            } else {
                NSLog(@"User registered successfully");
                [self.activityIndicator stopAnimating];
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }];
    }
}

- (IBAction)loginUser:(id)sender {
    [self.activityIndicator startAnimating];
    
    if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""])
    {
        [self presentViewController:self.blankAlert animated:YES completion:^{
            [self.activityIndicator stopAnimating];
        }];
    }
    else
    {
        NSString *username = self.usernameField.text;
        NSString *password = self.passwordField.text;
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
                [self presentViewController:self.loginAlert animated:YES completion:^{
                    [self.activityIndicator stopAnimating];
                }];
            } else {
                NSLog(@"User logged in successfully");
                [self.activityIndicator stopAnimating];
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }];
    }
}

@end
