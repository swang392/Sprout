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

- (void) refreshData {
    PFUser *user = self.post.author;
    
    //TODO: check if user has profile picture - if so, update to their profile picture.
    [self.profileImage setImage:nil];
    self.usernameLabel.text = user.username;
    self.captionLabel.text = self.post.caption;
    self.createdAtLabel.text = self.post.createdAt.shortTimeAgoSinceNow;
    self.progressLabel.text = [NSString stringWithFormat:@"I completed %@ of %@ tasks today!", self.post.completedTasks, self.post.totalTasks];
}

@end
