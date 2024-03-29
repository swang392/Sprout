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

@interface SignUpViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIAlertController *blankAlert;
@property (nonatomic) UIAlertController *registrationAlert;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createAlerts];
    
    [self formatTextFields];
}

- (void)formatTextFields {
    UIColor *color = [[UIColor alloc]initWithRed:97/255.0 green:179/255.0 blue:121/255.0 alpha:1.0];
    
    self.usernameField.layer.borderWidth = 1.0f;
    self.usernameField.layer.borderColor = [color CGColor];
    self.usernameField.layer.cornerRadius = 8;
    
    self.passwordField.layer.borderWidth = 1.0f;
    self.passwordField.layer.borderColor = [color CGColor];
    self.passwordField.layer.cornerRadius = 8;
    
    self.nameField.layer.borderWidth = 1.0f;
    self.nameField.layer.borderColor = [color CGColor];
    self.nameField.layer.cornerRadius = 8;
    
    self.emailField.layer.borderWidth = 1.0f;
    self.emailField.layer.borderColor = [color CGColor];
    self.emailField.layer.cornerRadius = 8;
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

- (IBAction)registerUser:(id)sender {
    [self.activityIndicator startAnimating];
    
    if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]
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
        NSData *imageData = UIImagePNGRepresentation(self.profilePicView.image);
        PFFileObject *image = [PFFileObject fileObjectWithName:@"profilePhoto.png" data:imageData];
        newUser[@"profileImage"] = image;
        
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

//methods from codepath
- (IBAction)selectProfileImage:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    CGSize temp_size = CGSizeMake(600, 600);
    UIImage *temp = [self resizeImage:editedImage withSize:temp_size];
    [self.profilePicView setImage:editedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showTabBar {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    [sceneDelegate changeRootViewController:viewController];
    
    [TaskRecommender.shared countUsers];
}

@end
