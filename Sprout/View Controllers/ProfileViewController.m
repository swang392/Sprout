//
//  ProfileViewController.m
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

@import FBSDKLoginKit;
#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *userBioLabel;
@property (nonatomic) PFUser *user;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = PFUser.currentUser;
    
    [self refreshData];
    
    NSTimer *refreshTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:refreshTimer forMode:NSDefaultRunLoopMode];
}

- (void)refreshData {
    if ([self.user[@"name"] isEqual:@""]) {
        self.nameLabel.text = self.user.username;
    }
    else{
        self.nameLabel.text = self.user[@"name"];
    }
    self.usernameLabel.text = self.user.username;
    self.emailLabel.text = self.user[@"email"];
    self.userBioLabel.text = self.user[@"userBio"];
    PFFileObject *photo = self.user[@"profileImage"];
    [photo getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        self.profileImageView.image = [UIImage imageWithData:imageData];
    }];
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error)  {
        [[FBSDKLoginManager alloc] logOut];
    }];
    
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *controller = [storyboard  instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = controller;
}

@end
