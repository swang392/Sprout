//
//  CommentCell.h
//  Sprout
//
//  Created by Sarah Wang on 8/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (nonatomic) NSDictionary *comment;

- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
