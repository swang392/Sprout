//
//  SceneDelegate.h
//  Sprout
//
//  Created by Sarah Wang on 7/12/21.
//

#import <UIKit/UIKit.h>

@interface SceneDelegate : UIResponder <UIWindowSceneDelegate>

@property (strong, nonatomic) UIWindow * window;

- (void)changeRootViewController:(UIViewController *)viewController;

@end

