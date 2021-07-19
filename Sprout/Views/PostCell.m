//
//  PostCell.m
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import "PostCell.h"
#import "UIImageView+AFNetworking.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) refreshData {
    [self.profileImage setImage:nil];
    
    PFUser *user = self.post.author;
    self.usernameLabel.text = user.username;
    self.captionLabel.text = self.post.caption;
}

@end
