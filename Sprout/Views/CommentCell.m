//
//  CommentCell.m
//  Sprout
//
//  Created by Sarah Wang on 8/2/21.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)refreshData {
    self.usernameLabel.text = nil;
    self.commentLabel.text = nil;
    
    self.usernameLabel.text = self.comment[@"name"];
    self.commentLabel.text = self.comment[@"text"];
}

@end
