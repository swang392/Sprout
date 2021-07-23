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
@property (nonatomic) PFUser *user;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) NSMutableArray<Task *> *tasks;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.user = PFUser.currentUser;
    [self queryTasks:20];
}

- (void) queryTasks:(int) numPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query includeKey:@"author"];
    [query includeKey:@"taskName"];
    [query includeKey:@"type"];
    [query includeKey:@"completed"];
    [query includeKey:@"timeframe"];
    
    query.limit = numPosts;
    
    [query whereKey:@"author" equalTo:self.user];

    [query findObjectsInBackgroundWithBlock:^(NSArray *tasks, NSError *error) {
        if (tasks != nil)
        {
            self.tasks = [NSMutableArray arrayWithArray:tasks];
            [self.tableView reloadData];
        } else {
            //TODO: - Show an alert for unexpected error
        }
    }];
}

- (void)refreshData:(UIRefreshControl *)refreshControl {
    [self queryTasks:20];
    [refreshControl endRefreshing];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
    Task *task = self.tasks[indexPath.row];
    UIImage *image = [UIImage systemImageNamed:@"square" withConfiguration:[UIImageSymbolConfiguration configurationWithScale:(UIImageSymbolScaleLarge)]];
    [cell.completedButton setImage:image forState:UIControlStateNormal];
    UIColor *color = [[UIColor alloc]initWithRed:10/255.0 green:42/255.0 blue:92/255.0 alpha:1.0];
    [cell.completedButton setTintColor:color];

    cell.taskLabel.text = nil;
    cell.timeframeLabel.text = nil;
    
    cell.taskLabel.text = task.name;
    cell.timeframeLabel.text = task.timeframe;
    cell.task = task;
    [cell markCompleteness:task.completed];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tasks.count;
}

@end
