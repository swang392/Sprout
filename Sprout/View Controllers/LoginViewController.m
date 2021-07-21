//
//  LoginViewController.m
//  Sprout
//
//  Created by Sarah Wang on 7/12/21.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
@import FBSDKLoginKit;
#import "SceneDelegate.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIAlertController *blankAlert;
@property (strong, nonatomic) UIAlertController *registrationAlert;
@property (strong, nonatomic) UIAlertController *loginAlert;
@property (nonatomic) FBSDKGraphRequest *graphRequest;

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

- (IBAction)continueWithFacebook:(id)sender {
    //TODO: allow users to create account through Facebook or log in through facebook. rn this is registering user
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    [loginManager logInWithPermissions:@[@"public_profile", @"email"]
                         fromViewController:self
                         handler:^(FBSDKLoginManagerLoginResult *_Nullable result, NSError *_Nullable error){
        if (error == nil && !result.isCancelled) {
            //TODO: graph request is being created, but competion block in createUserThroughFB isn't being called. need to fix.
            self.graphRequest = [[FBSDKGraphRequest alloc]
                                        initWithGraphPath:@"/me"
                                        parameters:@{@"fields":@"first_name,last_name,email"}
                                          //removed picture from parameters for debugging purposes
                                        HTTPMethod:@"GET"];

            [self createUserThroughFB: self.graphRequest];
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)createUserThroughFB:(FBSDKGraphRequest *)request {
    [request startWithCompletion:^(
                       id<FBSDKGraphRequestConnecting> _Nullable connection,
                       id _Nullable result,
                       NSError *_Nullable error) {
        if (result) {
            PFUser *newUser = [PFUser user];
            newUser[@"completedTasks"] = @0;
            newUser[@"totalTasks"] = @0;
            newUser[@"firstName"] = result[@"first_name"];
            newUser[@"lastName"] = result[@"last_name"];
            newUser[@"email"] = result[@"email"];
            newUser.username = result[@"email"];
            //newUser[@"profileImage"] = result[@"picture"];
            
            //TODO: check if a user with this email already exists. If so, log in without creating a new user
            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                if (error != nil) {
                    //TODO: - Show an alert for unexpected error
                    [self presentViewController:self.registrationAlert animated:YES completion:^{
                        [self.activityIndicator stopAnimating];
                    }];
                } else {
                    [self.activityIndicator stopAnimating];
                    [self performSegueWithIdentifier:@"loginSegue" sender:nil];
                }
            }];
        }
    }];
    
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

        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                //TODO: - Show an alert for unexpected error
                [self presentViewController:self.registrationAlert animated:YES completion:^{
                    [self.activityIndicator stopAnimating];
                }];
            } else {
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
                //TODO: - Show an alert for unexpected error
                [self presentViewController:self.loginAlert animated:YES completion:^{
                    [self.activityIndicator stopAnimating];
                }];
            } else {
                [self.activityIndicator stopAnimating];
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }];
    }
}

@end
