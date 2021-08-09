//
//  SplashScreenViewController.m
//  Sprout
//
//  Created by Sarah Wang on 7/30/21.
//

#import "SplashScreenViewController.h"
#import "FLAnimatedImage.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"

@interface SplashScreenViewController ()

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *launchScreenImage;

@end

@implementation SplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createGif];
    
    [self performSelector:@selector(goToLoginScreen) withObject:self afterDelay:4.0];
}

- (void)createGif {
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://i.imgur.com/ZWXcdRf.gif"]]];
    self.launchScreenImage.animatedImage = image;
    [self.view addSubview:self.launchScreenImage];
}

- (void)goToLoginScreen {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    [sceneDelegate changeRootViewController:viewController];
    
    //TODO: add fade into login screen
}

@end
