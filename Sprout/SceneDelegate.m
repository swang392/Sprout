//
//  SceneDelegate.m
//  Sprout
//
//  Created by Sarah Wang on 7/12/21.
//

@import FBSDKLoginKit;
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "TaskRecommender.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (PFUser.currentUser) {
        [TaskRecommender.shared countUsers];
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    }
    else {
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    }
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts
{
    UIOpenURLContext *context = URLContexts.allObjects.firstObject;
    [FBSDKApplicationDelegate.sharedInstance application:UIApplication.sharedApplication
                                               openURL:context.URL
                                     sourceApplication:context.options.sourceApplication
                                            annotation:context.options.annotation];
}

- (void)changeRootViewController:(UIViewController *)viewController{
    self.window.rootViewController = viewController;
}
@end
