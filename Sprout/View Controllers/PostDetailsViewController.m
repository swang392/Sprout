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
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshData];
}

- (void)refreshData {
    PFUser *author = self.post.author;
    PFFileObject *photo = author[@"profileImage"];
    [photo getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        self.profileImageView.image = [UIImage imageWithData:imageData];
    }];
    self.timestampLabel.text = self.post.createdAt.shortTimeAgoSinceNow;
    if ([author[@"name"] isEqual:nil]) {
        self.usernameLabel.text = nil;
        self.nameLabel.text = author.username;
    }
    else {
        self.usernameLabel.text = author.username;
        self.nameLabel.text = author[@"name"];
    }
    self.progressLabel.text = [NSString stringWithFormat:@"I completed %@ of %@ tasks today!", self.post.completedTasks, self.post.totalTasks];
    self.captionLabel.text = self.post.caption;
    self.timestampLabel.text = self.post.createdAt.shortTimeAgoSinceNow;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d likes", [self.post.likeCount intValue]];
    
    NSLog(@"%@", self.post.usersWhoLiked);
    if ([self.post.usersWhoLiked containsObject:PFUser.currentUser.objectId]) {
        [self updateLikeButton:YES];
    }
    else {
        [self updateLikeButton:NO];
    }
}

- (IBAction)doubleTapped:(id)sender {
    [self clickedLike];
}

- (IBAction)didTapLike:(id)sender {
    [self clickedLike];
}

- (void)clickedLike {
    if ([self.post.usersWhoLiked containsObject:PFUser.currentUser.objectId])
    {
        [self.post removeObject:PFUser.currentUser.objectId forKey:@"usersWhoLiked"];
        
        self.post.likeCount = @([self.post.likeCount intValue] - 1);
        [self.post saveInBackground];
        
        self.likeCountLabel.text = [NSString stringWithFormat:@"%d likes", [self.post.likeCount intValue]];
        [self updateLikeButton:NO];
    }
    else {
        [self.post addObject:PFUser.currentUser.objectId forKey:@"usersWhoLiked"];
       
        self.post.likeCount = @([self.post.likeCount intValue] + 1);
        [self.post saveInBackground];
        
        self.likeCountLabel.text = [NSString stringWithFormat:@"%d likes", [self.post.likeCount intValue]];
        [self updateLikeButton:YES];
    }
}

- (void)updateLikeButton:(BOOL) buttonStatus {
    UIColor *color = [[UIColor alloc]initWithRed:97/255.0 green:179/255.0 blue:121/255.0 alpha:1.0];
    if (buttonStatus)
    {
        UIImage *image = [UIImage systemImageNamed:@"heart.fill" withConfiguration:[UIImageSymbolConfiguration configurationWithScale:(UIImageSymbolScaleLarge)]];
        [self.likeButton setImage:image forState:UIControlStateNormal];
        [self.likeButton setTintColor:color];
    }
    else {
        UIImage *image = [UIImage systemImageNamed:@"heart" withConfiguration:[UIImageSymbolConfiguration configurationWithScale:(UIImageSymbolScaleLarge)]];
        [self.likeButton setImage:image forState:UIControlStateNormal];
        [self.likeButton setTintColor:color];
    }
}

@end
