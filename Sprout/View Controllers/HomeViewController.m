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
#import "TaskDetailsViewController.h"
#import "TaskRecommender.h"
#import "ComposePlanViewController.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) PFUser *user;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) NSMutableArray<Task *> *tasks;
@property (nonatomic) NSMutableArray *exercises;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [TaskRecommender.shared loadTaskAverages];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self createFitnessExercises];
    
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
            for (Task *task in self.tasks) {
                if ([task.type isEqual:@"Physical"]) {
                    self.myPhysicalCount++;
                }
                else if ([task.type isEqual:@"Diet"]) {
                    self.myDietCount++;
                }
                else if ([task.type isEqual:@"Mental"]) {
                    self.myMentalCount++;
                }
            }
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

- (void)createFitnessExercises {
    NSURL *url = [NSURL URLWithString:@"https://api.airtable.com/v0/appPZEtyXkEIJAxpS/Grid%20view?api_key=keyxenAzfLx3sx7xa"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            //TODO: show error
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:NSJSONReadingAllowFragments
                                                                             error:&error];
            self.exercises = dataDictionary[@"records"];
        }
    }];
    [task resume];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"editPlanSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposePlanViewController *composePlanViewController = (ComposePlanViewController*)navigationController.topViewController;
        composePlanViewController.myPhysicalCount = [NSNumber numberWithInt:self.myPhysicalCount];
        composePlanViewController.myMentalCount = [NSNumber numberWithInt:self.myMentalCount];
        composePlanViewController.myDietCount = [NSNumber numberWithInt:self.myDietCount];
        composePlanViewController.exercises = self.exercises;
    }
    else if ([segue.identifier isEqualToString:@"taskDetailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        TaskDetailsViewController *taskDetailsViewController = [segue destinationViewController];
        taskDetailsViewController.task = self.tasks[indexPath.row];
    }
}

@end
