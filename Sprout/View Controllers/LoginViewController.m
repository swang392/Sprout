//
//  LoginViewController.m
//  Sprout
//
//  Created by Sarah Wang on 7/12/21.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "HomeViewController.h"
@import FBSDKLoginKit;

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIAlertController *blankAlert;
@property (nonatomic) UIAlertController *registrationAlert;
@property (nonatomic) UIAlertController *loginAlert;
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
    FBSDKLoginManager *loginManager = [FBSDKLoginManager new];
    [loginManager logOut];
    [loginManager logInWithPermissions:@[@"public_profile", @"email"]
                         fromViewController:self
                         handler:^(FBSDKLoginManagerLoginResult *_Nullable result, NSError *_Nullable error){
        if (error == nil && !result.isCancelled) {
            self.graphRequest = [[FBSDKGraphRequest alloc]
                                                    initWithGraphPath:@"/me"
                                                    parameters:@{@"fields":@"first_name,last_name,email,picture"}
                                                    HTTPMethod:@"GET"];
            //TODO: modify graph request/the following method to get a high-res profile picture
            [self createUserThroughFB: self.graphRequest];
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)createUserThroughFB:(FBSDKGraphRequest *)request {
    //TODO: NEED TO FIX: For now i'm using the createFBUser method.
    [request startWithCompletion:^(
                       id<FBSDKGraphRequestConnecting> _Nullable connection,
                       id _Nullable result,
                       NSError *_Nullable error) {
        if (result) {
            PFUser *newUser = [PFUser user];
            newUser[@"completedTasks"] = @0;
            newUser[@"totalTasks"] = @0;
            newUser[@"name"] = [NSString stringWithFormat:@"%@ %@", result[@"first_name"], result[@"last_name"]];
            newUser[@"email"] = result[@"email"];
            newUser.password = result[@"email"];
            newUser.username = result[@"email"];
            
            PFFileObject *photo = result[@"picture"];
            NSString *photoURL = [photo valueForKeyPath:@"data"][@"url"];
            NSURL *url = [NSURL URLWithString:photoURL];
            UIImage *aImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            NSData *imageData = UIImagePNGRepresentation(aImage);
            PFFileObject *image = [PFFileObject fileObjectWithName:@"profilePhoto.png" data:imageData];
            newUser[@"profileImage"] = image;
            
            
            //TODO: check if a user with this email already exists. If so, log in without creating a new user
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
                [self showTabBar];
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
} 
@end
