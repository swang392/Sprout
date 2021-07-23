//
//  PostDetailsViewController.m
//  Sprout
//
//  Created by Sarah Wang on 7/23/21.
//

#import "PostDetailsViewController.h"
#import "Post.h"
#import "DateTools.h"

@interface PostDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshData];
}

- (void)refreshData {
    PFUser *currUser = self.post.author;
    PFFileObject *photo = currUser[@"profileImage"];
    [photo getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        self.profileImageView.image = [UIImage imageWithData:imageData];
    }];
    self.timestampLabel.text = self.post.createdAt.shortTimeAgoSinceNow;
    if([currUser[@"name"] isEqual:nil]){
        self.usernameLabel.text = nil;
        self.nameLabel.text = currUser.username;
    }
    else{
        self.usernameLabel.text = currUser.username;
        self.nameLabel.text = currUser[@"name"];
    }
    self.progressLabel.text = [NSString stringWithFormat:@"I completed %@ of %@ tasks today!", self.post.completedTasks, self.post.totalTasks];
    self.captionLabel.text = self.post.caption;
    self.timestampLabel.text = self.post.createdAt.shortTimeAgoSinceNow;
}

@end
