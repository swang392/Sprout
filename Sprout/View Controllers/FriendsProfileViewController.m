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

@end

@implementation FriendsProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = self.author[@"name"];
    self.usernameLabel.text = self.author.username;
    self.userBioLabel.text = self.author[@"userBio"];
    PFFileObject *photo = self.author[@"profileImage"];
    [photo getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        self.profileImage.image = [UIImage imageWithData:imageData];
    }];
}

@end
