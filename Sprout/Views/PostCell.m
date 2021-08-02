//
//  PostCell.m
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import "PostCell.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)refreshData {
    [self.profileImage setImage:nil];
    self.usernameLabel.text = nil;
    self.captionLabel.text = nil;
    self.createdAtLabel.text = nil;
    self.progressLabel.text = nil;
    
    PFUser *user = self.post.author;
    
    if ([user[@"name"] isEqual:@""]) {
        self.usernameLabel.text = user.username;
    }
    else {
        self.usernameLabel.text  = user[@"name"];
    }
    self.captionLabel.text = self.post.caption;
    self.createdAtLabel.text = self.post.createdAt.shortTimeAgoSinceNow;
    self.progressLabel.text = [NSString stringWithFormat:@"I completed %@ of %@ tasks today!", self.post.completedTasks, self.post.totalTasks];
    PFFileObject *photo = user[@"profileImage"];
    [photo getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        self.profileImage.image = [UIImage imageWithData:imageData];
    }];
    
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d likes", [self.post.likeCount intValue]];
    if ([self.post.usersWhoLiked containsObject:PFUser.currentUser.objectId]) {
        [self updateLikeButton:YES];
    }
    else {
        [self updateLikeButton:NO];
    }
    self.commentCountLabel.text = [NSString stringWithFormat:@"%d comments", [self.post.commentCount intValue]];
}

- (void)updateLikeButton:(BOOL)buttonStatus {
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

@end
