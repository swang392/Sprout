//
//  FriendsProfileViewController.h
//  Sprout
//
//  Created by Sarah Wang on 8/3/21.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendsProfileViewController : UIViewController

@property (nonatomic) PFUser *author;
@property (nonatomic) NSString *userEmail;

@end

NS_ASSUME_NONNULL_END
