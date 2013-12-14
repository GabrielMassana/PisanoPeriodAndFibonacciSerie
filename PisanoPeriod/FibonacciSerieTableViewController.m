//
//  FibonacciSerieTableViewController.m
//  PisanoPeriod
//
//  Created by Gabriel Massana on 12/13/13.
//  Copyright (c) 2013 Gabriel Massana. All rights reserved.
//

#import "FibonacciSerieTableViewController.h"
#import "Utils.h"
#import "ActivityViewCustomProvider.h"

@interface FibonacciSerieTableViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableViewCell *tableViewCell;

@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIPopoverController *pickerPopover;

@end

@implementation FibonacciSerieTableViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f]];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setFrame:CGRectMake(0,30,50,30)];
    [self.backButton setBackgroundColor:[UIColor clearColor]];
    [self.backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backButton setTitle:@"<" forState:UIControlStateNormal];
    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"EuphemiaUCAS" size:25]];
    [self.backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 35, SCREEN_WIDTH-80, 30)];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setTextColor:[UIColor colorWithRed:0.0f/255.0f green:128.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:25]];
    [self.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.titleLabel setMinimumScaleFactor:0.1];
    [self.view addSubview:self.titleLabel];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setFrame:CGRectMake(SCREEN_WIDTH-40, 35, 30, 30)];
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"share_button"] forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.shareButton];
    
    if (self.type == 0)
    {
        [self.titleLabel setText:@"Fibonacci Serie"];
        [self.backButton setFrame:CGRectMake(0,35,50,30)];

    }
    else if (self.type == 1)
    {
        if (self.zeros == 1)
        {
            [self.titleLabel setText:[NSString stringWithFormat:@"F(mod %d)\nperiod: %d", self.mod, [self.fibonacciNumbersArray count]]];

        }
        else
        {
            [self.titleLabel setText:[NSString stringWithFormat:@"F(mod %d)\nperiod: %d", self.mod, [self.fibonacciNumbersArray count]]];

        }
        
        [self.titleLabel setNumberOfLines:0];
        [self.titleLabel setFrame:CGRectMake(40, 25, SCREEN_WIDTH-80, 40)];
    }
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT-70) style:UITableViewStylePlain];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];
    
    self.tableViewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    DLog(@"COUNT = %d", [self.fibonacciNumbersArray count]);
    
}

-(NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fibonacciNumbersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (self.type == 0)
    {
        [cell.textLabel setText:[NSString stringWithFormat:@"F(%d): %@",indexPath.row, [self.fibonacciNumbersArray objectAtIndex:indexPath.row]]];
    }
    else if (self.type == 1)
    {
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",[self.fibonacciNumbersArray objectAtIndex:indexPath.row]]];

    }
    
    [cell.textLabel setMinimumScaleFactor:0.1f];
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark Sharing

- (void) shareButtonClicked
{
    ActivityViewCustomProvider *customProvider = [[ActivityViewCustomProvider alloc]init];
    [customProvider setArrayData:self.fibonacciNumbersArray];
    [customProvider setStringTitle:self.titleLabel.text];
    [customProvider setType:self.type];
    
    NSArray *activityItems = [[NSArray alloc]initWithObjects:customProvider, @"",  nil];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];

    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePostToWeibo, UIActivityTypePostToTwitter];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self presentViewController:activityVC animated:TRUE completion:nil];
    }
    else
    {
        self.pickerPopover = [[UIPopoverController alloc]initWithContentViewController:activityVC];
        [self.pickerPopover presentPopoverFromRect:CGRectMake(743, 40, 0, 0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

#pragma mark buttons

- (void) backButtonClicked: (id) sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
