//
//  AppDelegate.m
//  Sprout
//
//  Created by Sarah Wang on 7/12/21.
//

@import FBSDKLoginKit;
#import "AppDelegate.h"
#import "Parse/Parse.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
        
             
        NSString *applicationId= [dict objectForKey: @"applicationId"];
        NSString *clientKey = [dict objectForKey: @"clientKey"];
            
        configuration.server = @"https://parseapi.back4app.com";
        configuration.applicationId = applicationId;
        configuration.clientKey = clientKey;
        
        }];

    [Parse initializeWithConfiguration:config];
    [FBSDKApplicationDelegate.sharedInstance application:UIApplication.sharedApplication didFinishLaunchingWithOptions:launchOptions];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
