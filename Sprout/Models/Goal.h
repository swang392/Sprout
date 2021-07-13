//
//  Goal.h
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Goal : PFObject <PFSubclassing>

@property (nonatomic, strong) NSNumber *timeframe;
@property (nonatomic, strong) NSArray *tasks;
@property (nonatomic, strong) PFUser *author;
//author
//createdat?
//post

@end

NS_ASSUME_NONNULL_END
