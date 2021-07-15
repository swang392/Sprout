//
//  HomeViewController.m
//  Sprout
//
//  Created by Sarah Wang on 7/13/21.
//

#import "HomeViewController.h"
#import "Parse/Parse.h"
#import "TaskCell.h"
#import "Task.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSMutableArray *arrayOfTasks;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.user = PFUser.currentUser;
    
    [self queryTasks:20];
}

- (void) queryTasks:(int) numPosts {
    //TODO: add refresh control. Later on: sort by category?
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    //[query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"taskName"];
    [query includeKey:@"type"];
    [query includeKey:@"completed"];
    
    query.limit = numPosts;
    
    [query whereKey:@"author" equalTo:self.user];

    [query findObjectsInBackgroundWithBlock:^(NSArray *arrayOfTasks, NSError *error) {
        if (arrayOfTasks != nil) {
            self.arrayOfTasks = (NSMutableArray *)arrayOfTasks;
            [self.tableView reloadData];
            //self.morePostsLoading = false;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    [self.tableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
    
    Task *task = self.arrayOfTasks[indexPath.row];
    
    cell.taskLabel.text = task.taskName;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfTasks.count;
}

@end
