//
//  PostDetailsViewController.m
//  Sprout
//
//  Created by Sarah Wang on 7/23/21.
//

#import "PostDetailsViewController.h"
#import "Post.h"
#import "DateTools.h"
#import "CommentCell.h"
#import "FriendsProfileViewController.h"

@interface PostDetailsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *postCommentButton;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) UIAlertController *postCommentAlert;
@property (weak, nonatomic) IBOutlet UIView *doubleTapWindow;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshData];
    
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    
    [self createAlerts];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(reloadComments) forControlEvents:UIControlEventValueChanged];
    [self.commentTableView insertSubview:self.refreshControl atIndex:0];
    
    [self createTapGestures];
    
    UIColor *color = [[UIColor alloc]initWithRed:243/255.0 green:222/255.0 blue:229/255.0 alpha:1.5];
    self.commentTextView.layer.borderWidth = 1.5f;
    self.commentTextView.layer.borderColor = [color CGColor];
    self.commentTextView.layer.cornerRadius = 8;
}

- (void)createTapGestures {
    UITapGestureRecognizer *doubleTapGesture = [UITapGestureRecognizer new];
    doubleTapGesture.numberOfTapsRequired = 2;
    [doubleTapGesture addTarget:self action:@selector(clickedLike)];
    [self.doubleTapWindow addGestureRecognizer:doubleTapGesture];
    
    UITapGestureRecognizer *friendsProfileGesture = [UITapGestureRecognizer new];
    friendsProfileGesture.numberOfTapsRequired = 1;
    [friendsProfileGesture addTarget:self action:@selector(goToFriendsProfile)];
    [self.profileImageView addGestureRecognizer:friendsProfileGesture];
}

- (void)createAlerts {
    self.postCommentAlert = [UIAlertController alertControllerWithTitle:@"Please write a message to comment on this post." message:@"Try again!" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
    }];
    [self.postCommentAlert addAction:okAction];
}

- (void)refreshData {
    PFUser *author = self.post.author;
    PFFileObject *photo = author[@"profileImage"];
    [photo getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        self.profileImageView.image = [UIImage imageWithData:imageData];
    }];
    self.timestampLabel.text = self.post.createdAt.shortTimeAgoSinceNow;
    if ([author[@"name"] isEqual:nil]) {
        self.usernameLabel.text = nil;
        self.nameLabel.text = author.username;
    }
    else {
        self.usernameLabel.text = author.username;
        self.nameLabel.text = author[@"name"];
    }
    self.progressLabel.text = [NSString stringWithFormat:@"I completed %@ of %@ tasks today!", self.post.completedTasks, self.post.totalTasks];
    self.captionLabel.text = self.post.caption;
    self.timestampLabel.text = self.post.createdAt.shortTimeAgoSinceNow;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d likes", [self.post.likeCount intValue]];
    
    if ([self.post.usersWhoLiked containsObject:PFUser.currentUser.objectId]) {
        [self updateLikeButton:YES];
    }
    else {
        [self updateLikeButton:NO];
    }
    self.commentCountLabel.text = [NSString stringWithFormat:@"%d comments", [self.post.commentCount intValue]];
}

- (IBAction)didTapLike:(id)sender {
    [self clickedLike];
}

- (void)clickedLike {
    if ([self.post.usersWhoLiked containsObject:PFUser.currentUser.objectId])
    {
        [self.post removeObject:PFUser.currentUser.objectId forKey:@"usersWhoLiked"];
        
        self.post.likeCount = @([self.post.likeCount intValue] - 1);
        [self.post saveInBackground];
        
        self.likeCountLabel.text = [NSString stringWithFormat:@"%d likes", [self.post.likeCount intValue]];
        [self updateLikeButton:NO];
    }
    else {
        [self.post addObject:PFUser.currentUser.objectId forKey:@"usersWhoLiked"];
        
        self.post.likeCount = @([self.post.likeCount intValue] + 1);
        [self.post saveInBackground];
        
        self.likeCountLabel.text = [NSString stringWithFormat:@"%d likes", [self.post.likeCount intValue]];
        [self updateLikeButton:YES];
    }
}

- (void)updateLikeButton:(BOOL)buttonStatus {
    UIColor *color = [[UIColor alloc]initWithRed:243/255.0 green:222/255.0 blue:229/255.0 alpha:1.5];
    if (buttonStatus)
    {
        UIImage *image = [UIImage systemImageNamed:@"heart.fill" withConfiguration:[UIImageSymbolConfiguration configurationWithScale:(UIImageSymbolScaleLarge)]];
        [self.likeButton setImage:image forState:UIControlStateNormal];
        [self.likeButton setTintColor:color];
    }
    else {
        UIImage *image = [UIImage systemImageNamed:@"heart" withConfiguration:[UIImageSymbolConfiguration configurationWithScale:(UIImageSymbolScaleLarge)]];
        [self.likeButton setImage:image forState:UIControlStateNormal];
        [self.likeButton setTintColor:color];
    }
}

- (void)reloadComments {
    [self.commentTableView reloadData];
    [self.refreshControl endRefreshing];
}

- (IBAction)postComment:(id)sender {
    if ([self.commentTextView.text isEqual:@""]) {
        [self presentViewController:self.postCommentAlert animated:YES completion:^{}];
    }
    else {
        NSDictionary *comment = [[NSDictionary alloc] initWithObjectsAndKeys:self.commentTextView.text, @"text", PFUser.currentUser[@"name"], @"name", nil];
        [self.post addObject:comment forKey:@"comments"];
        self.post.commentCount = @([self.post.commentCount intValue] + 1);
        [self.post saveInBackground];
        
        self.commentCountLabel.text = [NSString stringWithFormat:@"%d comments", [self.post.commentCount intValue]];
        
        self.commentTextView.text = @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.post.commentCount intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [self.commentTableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    NSDictionary *comment = [self.post.comments objectAtIndex:indexPath.row];
    
    cell.comment = comment;
    [cell refreshData];
    
    return cell;
}

- (void)goToFriendsProfile {
    [self performSegueWithIdentifier:@"friendsProfileSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"friendsProfileSegue"]) {
        FriendsProfileViewController *viewController = [segue destinationViewController];
        viewController.author = self.post.author;
    }
}
@end
