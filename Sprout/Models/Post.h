//
//  Post.h
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import <Parse/Parse.h>
#import "Goal.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) Goal *goal;
@property (nonatomic, strong) PFUser *author;

@end

NS_ASSUME_NONNULL_END
