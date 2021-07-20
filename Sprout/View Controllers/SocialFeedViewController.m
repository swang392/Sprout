//
//  SocialFeedViewController.m
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import "SocialFeedViewController.h"
#import "Parse/Parse.h"
#import "PostCell.h"
#import "AppDelegate.h"
#import "DateTools.h"

@interface SocialFeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray<Post *> *posts;
@property (nonatomic, strong) PFUser *user;

@end

@implementation SocialFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self queryPosts:20];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void) queryPosts:(int) numPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = numPosts;

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = (NSMutableArray *)posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)refreshData:(UIRefreshControl *)refreshControl {
    [self queryPosts:20];
    [refreshControl endRefreshing]; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.posts[indexPath.row];
    
    [cell.profileImage setImage:nil];
    cell.usernameLabel.text = nil;
    cell.progressLabel.text = nil;
    cell.usernameLabel.text = nil;
    cell.post = post;
    
    [cell refreshData]; 
    return cell;
}

@end
