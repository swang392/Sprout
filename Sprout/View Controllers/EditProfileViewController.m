//
//  EditProfileViewController.m
//  Sprout
//
//  Created by Sarah Wang on 7/20/21.
//

#import "EditProfileViewController.h"
#import "Parse/Parse.h"

@interface EditProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *pickPhotoButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextView *userBioField;
@property (nonatomic) PFUser *user;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshData];
    
    UIColor *color = [[UIColor alloc]initWithRed:243/255.0 green:222/255.0 blue:229/255.0 alpha:1.5];
    self.userBioField.layer.borderWidth = 1.5f;
    self.userBioField.layer.borderColor = [color CGColor];
    self.userBioField.layer.cornerRadius = 8;
}

- (void)refreshData {
    self.user = PFUser.currentUser;
    self.userNameField.text = self.user[@"name"];
    self.emailField.text = self.user[@"email"];
    self.userBioField.text = self.user[@"userBio"];
    
    if (self.user[@"profileImage"] != nil) {
        PFFileObject *temp_file = self.user[@"profileImage"];
        [temp_file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            UIImage *thumbnailImage = [UIImage imageWithData:imageData];
            UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:thumbnailImage];
            self.profilePicView.image = thumbnailImageView.image;
        }];
    }
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)saveButton:(id)sender {
    self.user[@"name"] = self.userNameField.text;
    self.user[@"email"] = self.emailField.text;
    self.user[@"userBio"] = self.userBioField.text;
    NSData *imageData = UIImagePNGRepresentation(self.profilePicView.image);
    if (imageData != nil) {
        PFFileObject *image = [PFFileObject fileObjectWithName:@"profilePhoto.png" data:imageData];
        self.user[@"profileImage"] = image;
    }
    [PFUser.currentUser saveInBackground];
    
    [self refreshData];
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

//methods from codepath
- (IBAction)selectProfileImage:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    CGSize temp_size = CGSizeMake(600, 600);
    UIImage *temp = [self resizeImage:editedImage withSize:temp_size];
    [self.profilePicView setImage:editedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
