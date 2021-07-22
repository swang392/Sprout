//
//  ProfileViewController.m
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"
@import FBSDKLoginKit;

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameField;
@property (nonatomic) PFUser *user;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = PFUser.currentUser;
    
    if([self.user[@"name"] isEqual:@""]){
        self.nameField.text = self.user.username;
    }
    else{
        self.nameField.text = self.user[@"name"];
    }
    PFFileObject *photo = self.user[@"profileImage"];
    [photo getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        self.profileImageView.image = [UIImage imageWithData:imageData];
    }];
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error)  {
        [[FBSDKLoginManager alloc] logOut];
        if (FBSDKAccessToken.currentAccessTokenIsActive) {
            [[FBSDKLoginManager alloc] logOut];
        }
    }];
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *controller = [storyboard  instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = controller;
}

@end
