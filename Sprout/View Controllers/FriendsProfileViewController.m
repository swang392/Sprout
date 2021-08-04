//
//  FriendsProfileViewController.m
//  Sprout
//
//  Created by Sarah Wang on 8/3/21.
//

#import "FriendsProfileViewController.h"

@interface FriendsProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userBioLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *mailButton;

@end

@implementation FriendsProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshData];
}

- (void)refreshData {
    self.nameLabel.text = self.author[@"name"];
    self.usernameLabel.text = self.author.username;
    self.userBioLabel.text = self.author[@"userBio"];
    self.emailLabel.text = self.userEmail;
    PFFileObject *photo = self.author[@"profileImage"];
    [photo getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        self.profileImage.image = [UIImage imageWithData:imageData];
    }];
}

- (IBAction)didTapMailButton:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"mailto:%@", self.userEmail];
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        //TODO: show error
    }
}

@end
