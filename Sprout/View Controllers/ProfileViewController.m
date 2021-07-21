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

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
