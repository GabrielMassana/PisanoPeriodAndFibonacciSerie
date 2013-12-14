//
//  InitialViewController.m
//  PisanoPeriod
//
//  Created by Gabriel Massana on 12/13/13.
//  Copyright (c) 2013 Gabriel Massana. All rights reserved.
//

// Theory
// http://webspace.ship.edu/msrenault/fibonacci/fiblist.htm
// http://youtu.be/Nu-lW-Ifyec
// http://en.wikipedia.org/wiki/Pisano_period
// http://en.wikipedia.org/wiki/Fibonacci_number

#import "InitialViewController.h"
#import "Utils.h"
#import <Accelerate/Accelerate.h>
#import "JKBigInteger.h"
#import "FibonacciSerieTableViewController.h"
#import "ActivityViewCustomProvider.h"

@interface InitialViewController ()

@property (nonatomic, strong) NSMutableArray *fibonacciNumbersArray;
@property (nonatomic, strong) NSMutableArray *pisanoPeriodNumbersArray;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic) int initialY;

@property (nonatomic, strong) UILabel *fibonacciSerieLabel;
@property (nonatomic, strong) UILabel *fibonacciNNumberLabel;
@property (nonatomic, strong) UILabel *pisanoPeriodLabel;

@property (nonatomic, strong) UIView *fibonacciSerieView;
@property (nonatomic, strong) UITextField *fibonacciSerieTextField;

@property (nonatomic, strong) UIView *fibonacciNNumberView;
@property (nonatomic, strong) UITextField *fibonacciNNumberTextField;

@property (nonatomic, strong) UIView *oneFibonacciNNumberView;
@property (nonatomic, strong) UITextField *oneFibonacciNNumberTextField;

@property (nonatomic, strong) UIView *pisanoPeriodView;
@property (nonatomic, strong) UITextField *pisanoPeriodTextField;

@property (nonatomic, strong) UILabel *nLabel;
@property (nonatomic, strong) UILabel *fnLabel;
@property (nonatomic, strong) UILabel *serieLengthLabel;
@property (nonatomic, strong) UILabel *modLabel;

@property (nonatomic, strong) UIView *spinerView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;


@property (nonatomic, strong) dispatch_queue_t secondHighQueue;

@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIPopoverController *pickerPopover;

@property (nonatomic) int zeros;


@end

@implementation InitialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f]];
    
    self.fibonacciNumbersArray = [[NSMutableArray alloc]init];
    self.pisanoPeriodNumbersArray = [[NSMutableArray alloc]init];

    self.secondHighQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.scrollView];
    
    self.initialY = 50;
    
    self.fibonacciSerieLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.initialY, SCREEN_WIDTH-20, 25)];
    [self.fibonacciSerieLabel setBackgroundColor:[UIColor clearColor]];
    [self.fibonacciSerieLabel setTextAlignment:NSTextAlignmentLeft];
    [self.fibonacciSerieLabel setTextColor:[UIColor darkGrayColor]];
    [self.fibonacciSerieLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:25]];
    [self.fibonacciSerieLabel setText:@"Fibonacci Serie"];
    [self.scrollView addSubview:self.fibonacciSerieLabel];

    self.initialY += 30;

    self.fibonacciSerieView = [[UIView alloc]initWithFrame:CGRectMake(-1, self.initialY, SCREEN_WIDTH+2, 50)];
    [self.fibonacciSerieView setBackgroundColor:[UIColor whiteColor]];
    [[self.fibonacciSerieView layer] setBorderWidth:0.5f];
    [[self.fibonacciSerieView layer] setBorderColor:[UIColor blackColor].CGColor];
    [self.scrollView addSubview:self.fibonacciSerieView];
    
    self.serieLengthLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 50)];
    [self.serieLengthLabel setBackgroundColor:[UIColor clearColor]];
    [self.serieLengthLabel setTextAlignment:NSTextAlignmentLeft];
    [self.serieLengthLabel setTextColor:[UIColor colorWithRed:0.0f/255.0f green:128.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [self.serieLengthLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20]];
    [self.serieLengthLabel setText:@"Serie length:"];
    [self.fibonacciSerieView addSubview:self.serieLengthLabel];

    self.fibonacciSerieTextField = [[UITextField alloc] initWithFrame:CGRectMake(150, 0, SCREEN_WIDTH-160, 50)] ;
    [self.fibonacciSerieTextField setBorderStyle:UITextBorderStyleNone];
    [self.fibonacciSerieTextField setBackgroundColor:[UIColor whiteColor]];
    [self.fibonacciSerieTextField setText:@""];
    [self.fibonacciSerieTextField setPlaceholder:@"Select length"];
    self.fibonacciSerieTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.fibonacciSerieTextField setTextAlignment:NSTextAlignmentLeft];
    [self.fibonacciSerieTextField setReturnKeyType:UIReturnKeyDone];
    [self.fibonacciSerieTextField setDelegate:self];
    [self.fibonacciSerieTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.fibonacciSerieTextField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    [self.fibonacciSerieView addSubview:self.fibonacciSerieTextField];

    UIToolbar* fibonacciSerieTextFieldToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    fibonacciSerieTextFieldToolbar.barStyle = UIBarStyleBlackTranslucent;
    fibonacciSerieTextFieldToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneFibonacciSerieTextFieldToolbarClicked:)],
                           nil];
    [fibonacciSerieTextFieldToolbar sizeToFit];
    self.fibonacciSerieTextField.inputAccessoryView = fibonacciSerieTextFieldToolbar;

    self.initialY += 60;
    
    self.fibonacciNNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.initialY, (SCREEN_WIDTH/2)-10, 25)];
    [self.fibonacciNNumberLabel setBackgroundColor:[UIColor clearColor]];
    [self.fibonacciNNumberLabel setTextAlignment:NSTextAlignmentLeft];
    [self.fibonacciNNumberLabel setTextColor:[UIColor darkGrayColor]];
    [self.fibonacciNNumberLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:25]];
    [self.fibonacciNNumberLabel setText:@"Fn"];
    [self.scrollView addSubview:self.fibonacciNNumberLabel];
    
    self.initialY += 30;

    self.fibonacciNNumberView = [[UIView alloc]initWithFrame:CGRectMake(-1, self.initialY, SCREEN_WIDTH+2, 50)];
    [self.fibonacciNNumberView setBackgroundColor:[UIColor whiteColor]];
    [[self.fibonacciNNumberView layer] setBorderWidth:0.5f];
    [[self.fibonacciNNumberView layer] setBorderColor:[UIColor blackColor].CGColor];
    [self.scrollView addSubview:self.fibonacciNNumberView];
    
    self.nLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 30, 50)];
    [self.nLabel setBackgroundColor:[UIColor clearColor]];
    [self.nLabel setTextAlignment:NSTextAlignmentLeft];
    [self.nLabel setTextColor:[UIColor colorWithRed:0.0f/255.0f green:128.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [self.nLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20]];
    [self.nLabel setText:@"n:"];
    [self.fibonacciNNumberView addSubview:self.nLabel];
    
    self.fibonacciNNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH-60, 50)] ;
    [self.fibonacciNNumberTextField setBorderStyle:UITextBorderStyleNone];
    [self.fibonacciNNumberTextField setBackgroundColor:[UIColor whiteColor]];
    [self.fibonacciNNumberTextField setText:@""];
    [self.fibonacciNNumberTextField setPlaceholder:@"Select n"];
    self.fibonacciNNumberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.fibonacciNNumberTextField setTextAlignment:NSTextAlignmentLeft];
    [self.fibonacciNNumberTextField setReturnKeyType:UIReturnKeyDone];
    [self.fibonacciNNumberTextField setDelegate:self];
    [self.fibonacciNNumberTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.fibonacciNNumberTextField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    [self.fibonacciNNumberView addSubview:self.fibonacciNNumberTextField];
    
    UIToolbar* fibonacciNNumberTextFieldToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    fibonacciNNumberTextFieldToolbar.barStyle = UIBarStyleBlackTranslucent;
    fibonacciNNumberTextFieldToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneFibonacciNNumberTextFieldToolbarClicked:)],
                           nil];
    [fibonacciNNumberTextFieldToolbar sizeToFit];
    self.fibonacciNNumberTextField.inputAccessoryView = fibonacciNNumberTextFieldToolbar;
    
    self.initialY += 49;

    self.oneFibonacciNNumberView = [[UIView alloc]initWithFrame:CGRectMake(-1, self.initialY, SCREEN_WIDTH+2, 50)];
    [self.oneFibonacciNNumberView setBackgroundColor:[UIColor whiteColor]];
    [[self.oneFibonacciNNumberView layer] setBorderWidth:0.5f];
    [[self.oneFibonacciNNumberView layer] setBorderColor:[UIColor blackColor].CGColor];
    [self.scrollView addSubview:self.oneFibonacciNNumberView];
    
    self.fnLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 30, 50)];
    [self.fnLabel setBackgroundColor:[UIColor clearColor]];
    [self.fnLabel setTextAlignment:NSTextAlignmentLeft];
    [self.fnLabel setTextColor:[UIColor colorWithRed:0.0f/255.0f green:128.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [self.fnLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20]];
    [self.fnLabel setText:@"Fn:"];
    [self.oneFibonacciNNumberView addSubview:self.fnLabel];
    
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setFrame:CGRectMake(SCREEN_WIDTH-40, 10, 30, 30)];
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"share_button"] forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.shareButton setAlpha:0.0f];
    [self.oneFibonacciNNumberView addSubview:self.shareButton];
    
    self.oneFibonacciNNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH-130, 50)] ;
    [self.oneFibonacciNNumberTextField setBorderStyle:UITextBorderStyleNone];
    [self.oneFibonacciNNumberTextField setBackgroundColor:[UIColor whiteColor]];
    [self.oneFibonacciNNumberTextField setText:@""];
    [self.oneFibonacciNNumberTextField setPlaceholder:@"Fn number"];
    self.oneFibonacciNNumberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.oneFibonacciNNumberTextField setTextAlignment:NSTextAlignmentLeft];
    [self.oneFibonacciNNumberTextField setReturnKeyType:UIReturnKeyDone];
    [self.oneFibonacciNNumberTextField setDelegate:self];
    [self.oneFibonacciNNumberTextField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    [self.oneFibonacciNNumberTextField setAdjustsFontSizeToFitWidth:YES];
    [self.oneFibonacciNNumberTextField setMinimumFontSize:1];
    [self.oneFibonacciNNumberView addSubview:self.oneFibonacciNNumberTextField];

    self.initialY += 60;
    
    self.pisanoPeriodLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.initialY, SCREEN_WIDTH-20, 25)];
    [self.pisanoPeriodLabel setBackgroundColor:[UIColor clearColor]];
    [self.pisanoPeriodLabel setTextAlignment:NSTextAlignmentLeft];
    [self.pisanoPeriodLabel setTextColor:[UIColor darkGrayColor]];
    [self.pisanoPeriodLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:25]];
    [self.pisanoPeriodLabel setText:@"Pisano period: F(mod m)"];
    [self.scrollView addSubview:self.pisanoPeriodLabel];
    
    self.initialY += 30;
    
    self.pisanoPeriodView = [[UIView alloc]initWithFrame:CGRectMake(-1, self.initialY, SCREEN_WIDTH+2, 50)];
    [self.pisanoPeriodView setBackgroundColor:[UIColor whiteColor]];
    [[self.pisanoPeriodView layer] setBorderWidth:0.5f];
    [[self.pisanoPeriodView layer] setBorderColor:[UIColor blackColor].CGColor];
    [self.scrollView addSubview:self.pisanoPeriodView];
    
    self.pisanoPeriodLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 50)];
    [self.pisanoPeriodLabel setBackgroundColor:[UIColor clearColor]];
    [self.pisanoPeriodLabel setTextAlignment:NSTextAlignmentLeft];
    [self.pisanoPeriodLabel setTextColor:[UIColor colorWithRed:0.0f/255.0f green:128.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [self.pisanoPeriodLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20]];
    [self.pisanoPeriodLabel setText:@"m:"];
    [self.pisanoPeriodView addSubview:self.pisanoPeriodLabel];
    
    self.pisanoPeriodTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH-70, 50)] ;
    [self.pisanoPeriodTextField setBorderStyle:UITextBorderStyleNone];
    [self.pisanoPeriodTextField setBackgroundColor:[UIColor whiteColor]];
    [self.pisanoPeriodTextField setText:@""];
    [self.pisanoPeriodTextField setPlaceholder:@"Select m"];
    self.pisanoPeriodTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.pisanoPeriodTextField setTextAlignment:NSTextAlignmentLeft];
    [self.pisanoPeriodTextField setReturnKeyType:UIReturnKeyDone];
    [self.pisanoPeriodTextField setDelegate:self];
    [self.pisanoPeriodTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.pisanoPeriodTextField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    [self.pisanoPeriodView addSubview:self.pisanoPeriodTextField];

    UIToolbar* pisanoPeriodTextFieldToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    pisanoPeriodTextFieldToolbar.barStyle = UIBarStyleBlackTranslucent;
    pisanoPeriodTextFieldToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(donePisanoPeriodTextFieldToolbarClicked:)],
                           nil];
    [pisanoPeriodTextFieldToolbar sizeToFit];
    self.pisanoPeriodTextField.inputAccessoryView = pisanoPeriodTextFieldToolbar;

    self.initialY += 60;

    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.initialY)];
    
    
    
    self.spinerView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100) / 2, 100, 100, 100)];
    [self.spinerView setBackgroundColor:[UIColor colorWithRed:25.0f/255.0f green:25.0f/255.0f blue:25.0f/255.0f alpha:0.7f]];
    [self.spinerView setAlpha:0.0f];
    [self.view addSubview:self.spinerView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((100-37) / 2, (100-37) / 2, 37, 37)];
    [self.activityIndicatorView startAnimating];
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.spinerView addSubview:self.activityIndicatorView];

    
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

#pragma mark Fibonacci Calculus

- (NSMutableArray*) getXFibonacciNumbersFromNumber:(NSString*) numberString
{
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    
    JKBigInteger *first = [[JKBigInteger alloc] initWithString:@"0"];
    JKBigInteger *second = [[JKBigInteger alloc] initWithString:@"1"];
    JKBigInteger *fibonacci = [[JKBigInteger alloc] init];

    if ([numberString intValue] == 0)
    {
        [returnArray addObject:first];
    }
    else
    {
        [returnArray addObject:first];
        [returnArray addObject:second];
        
        while ([returnArray count] < [numberString integerValue]+1)
        {
            fibonacci = [first add:second];
            first = second;
            second = fibonacci;
            [returnArray addObject:fibonacci];
        }
    }
    
    return returnArray;
}

- (NSString*) getTheNFibonacciNumberFromNumber:(NSString*) numberString
{
    self.fibonacciNumbersArray = [self getXFibonacciNumbersFromNumber:[NSString stringWithFormat:@"%d",  [numberString intValue]]];
    return [NSString stringWithFormat:@"%@", [self.fibonacciNumbersArray objectAtIndex:[self.fibonacciNumbersArray count] -1]];
}

// Pisano Period Code
- (NSMutableArray *) getPisanoPeriodForModM: (NSString*) m andFLength: (NSString*) fLength
{
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    NSMutableArray *modNumbers = [[NSMutableArray alloc]init];
    
    
    self.fibonacciNumbersArray = [self getXFibonacciNumbersFromNumber:fLength];
    
    JKBigInteger *modM = [[JKBigInteger alloc]initWithString:m];
    
    for (JKBigInteger *bigInteger in self.fibonacciNumbersArray)
    {
        [modNumbers addObject:[bigInteger remainder:modM]];
    }
    
    int zeroOneOne = 0;
    BOOL zero = FALSE;
    BOOL one1 = FALSE;
    self.zeros = 0;
    
    for (int i = 0; i < [modNumbers count]; i++)
    {
        [returnArray addObject:[modNumbers objectAtIndex:i]];
        
        if ([[NSString stringWithFormat:@"%@",[modNumbers objectAtIndex:i]] integerValue] == 0)
        {
            zero = TRUE;
            self.zeros += 1;
            if ([modNumbers count] > i+1)
            {
                if ([[NSString stringWithFormat:@"%@",[modNumbers objectAtIndex:i+1]] integerValue] == 1 && zero)
                {
                    one1 = TRUE;
                    if ([modNumbers count ] >i+2)
                    {
                        if ([[NSString stringWithFormat:@"%@",[modNumbers objectAtIndex:i+2]] integerValue] == 1 && zero && one1)
                        {
                            zero = FALSE;
                            one1 = FALSE;
                            zeroOneOne += 1;
                        }
                    }
                    else
                    {
                        zero = FALSE;
                        one1 = FALSE;
                    }
                }
            }                
            else
            {
                zero = FALSE;
            }
        }
        if (zeroOneOne == 2)
        {
            self.zeros -=1;
            [returnArray removeObjectAtIndex:[returnArray count]-1];
            break;
        }
    }
    
    if (zeroOneOne != 2)
    {
        zeroOneOne = 0;
        long length = [fLength integerValue] * 2;
        return [self getPisanoPeriodForModM:m andFLength:[NSString stringWithFormat:@"%ld",length]];

    }
    
    return returnArray;
}

#pragma mark buttons

- (void) doneFibonacciNNumberTextFieldToolbarClicked: (id) sender
{
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.initialY)];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    if ([self.fibonacciNNumberTextField.text isEqualToString:@""] || self.fibonacciNNumberTextField.text == nil)
    {
        [self.fibonacciNNumberTextField resignFirstResponder];
        [self.oneFibonacciNNumberTextField setText:@""];
        [self.shareButton setAlpha:0.0f];
        
        
        [self.fibonacciNNumberTextField setUserInteractionEnabled:YES];
        [self.fibonacciSerieTextField setUserInteractionEnabled:YES];
        [self.pisanoPeriodTextField setUserInteractionEnabled:YES];

    }
    else
    {
        [self.fibonacciNNumberTextField resignFirstResponder];
        
        [self.spinerView setAlpha:1.0f];
        dispatch_async(self.secondHighQueue, ^
                       {
                           NSString *fibonacciNumber = [self getTheNFibonacciNumberFromNumber:self.fibonacciNNumberTextField.text];
                           
                           dispatch_sync(dispatch_get_main_queue(), ^
                                         {
                                             [self.oneFibonacciNNumberTextField setText:fibonacciNumber];
                                             [self.spinerView setAlpha:0.0f];
                                             [self.shareButton setAlpha:1.0f];
                                             
                                             [self.fibonacciNNumberTextField setUserInteractionEnabled:YES];
                                             [self.fibonacciSerieTextField setUserInteractionEnabled:YES];
                                             [self.pisanoPeriodTextField setUserInteractionEnabled:YES];

                                         });
                       });
    }
}

- (void) doneFibonacciSerieTextFieldToolbarClicked: (id) sender
{
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.initialY)];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    if ([self.fibonacciSerieTextField.text isEqualToString:@""] || self.fibonacciSerieTextField.text == nil)
    {
        [self.fibonacciSerieTextField resignFirstResponder];
        
        [self.shareButton setAlpha:0.0f];

        [self.fibonacciNNumberTextField setUserInteractionEnabled:YES];
        [self.fibonacciSerieTextField setUserInteractionEnabled:YES];
        [self.pisanoPeriodTextField setUserInteractionEnabled:YES];

    }
    else
    {
        [self.spinerView setAlpha:1.0f];
        dispatch_async(self.secondHighQueue, ^
                       {
                           self.fibonacciNumbersArray = [self getXFibonacciNumbersFromNumber:self.fibonacciSerieTextField.text];
                           dispatch_sync(dispatch_get_main_queue(), ^
                                         {
                                             FibonacciSerieTableViewController *fibonacciSerieTable = [[Utils getStoryboardType] instantiateViewControllerWithIdentifier:@"FibonacciSerieTableViewController"];
                                             [fibonacciSerieTable setFibonacciNumbersArray:self.fibonacciNumbersArray];
                                             [fibonacciSerieTable setType:0];
                                             [self presentViewController:fibonacciSerieTable animated:YES completion:nil];
                                             [self.spinerView setAlpha:0.0f];
                                             
                                             [self.fibonacciNNumberTextField setUserInteractionEnabled:YES];
                                             [self.fibonacciSerieTextField setUserInteractionEnabled:YES];
                                             [self.pisanoPeriodTextField setUserInteractionEnabled:YES];
                                         });
                       });
    }
}

- (void) donePisanoPeriodTextFieldToolbarClicked: (id) sender
{

    DLog(@"donePisanoPeriodTextFieldToolbarClicked");
    
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.initialY)];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
    
    if ([self.pisanoPeriodTextField.text isEqualToString:@""] || self.pisanoPeriodTextField.text == nil)
    {
        [self.pisanoPeriodTextField resignFirstResponder];
        
        [self.shareButton setAlpha:0.0f];
        
        [self.fibonacciNNumberTextField setUserInteractionEnabled:YES];
        [self.fibonacciSerieTextField setUserInteractionEnabled:YES];
        [self.pisanoPeriodTextField setUserInteractionEnabled:YES];
    }
    else if ([self.pisanoPeriodTextField.text intValue] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"F(mod m)"
                                                        message:@"Sorry, m can't be 0"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        [self.pisanoPeriodTextField resignFirstResponder];
        
        [self.shareButton setAlpha:0.0f];
        
        [self.fibonacciNNumberTextField setUserInteractionEnabled:YES];
        [self.fibonacciSerieTextField setUserInteractionEnabled:YES];
        [self.pisanoPeriodTextField setUserInteractionEnabled:YES];

    }
    else if ([self.pisanoPeriodTextField.text intValue] == 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"F(mod m)"
                                                        message:@"Sorry, m can't be 1"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        [self.pisanoPeriodTextField resignFirstResponder];
        
        [self.shareButton setAlpha:0.0f];
        
        [self.fibonacciNNumberTextField setUserInteractionEnabled:YES];
        [self.fibonacciSerieTextField setUserInteractionEnabled:YES];
        [self.pisanoPeriodTextField setUserInteractionEnabled:YES];

    }
    else
    {
        [self.spinerView setAlpha:1.0];

        dispatch_async(self.secondHighQueue, ^
                       {
                           self.pisanoPeriodNumbersArray = [self getPisanoPeriodForModM:self.pisanoPeriodTextField.text andFLength:@"25"];
                           dispatch_sync(dispatch_get_main_queue(), ^
                                         {
                                             FibonacciSerieTableViewController *fibonacciSerieTable = [[Utils getStoryboardType] instantiateViewControllerWithIdentifier:@"FibonacciSerieTableViewController"];
                                             [fibonacciSerieTable setFibonacciNumbersArray:self.pisanoPeriodNumbersArray];
                                             [fibonacciSerieTable setType:1];
                                             [fibonacciSerieTable setZeros:self.zeros];
                                             [fibonacciSerieTable setMod:[self.pisanoPeriodTextField.text intValue]];
                                             [self presentViewController:fibonacciSerieTable animated:YES completion:nil];
                                             [self.spinerView setAlpha:0.0];
                                             
                                             [self.fibonacciNNumberTextField setUserInteractionEnabled:YES];
                                             [self.fibonacciSerieTextField setUserInteractionEnabled:YES];
                                             [self.pisanoPeriodTextField setUserInteractionEnabled:YES];
                                         });
                       });
    }
}


#pragma mark TextField delegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self.oneFibonacciNNumberTextField setUserInteractionEnabled:NO];
    
    if (textField == self.oneFibonacciNNumberTextField)
    {
        [self.oneFibonacciNNumberTextField resignFirstResponder];
    }
    else if (textField == self.fibonacciNNumberTextField)
    {
        [self.fibonacciNNumberTextField setText:@""];
        [self.oneFibonacciNNumberTextField setText:@""];
        
        [self.fibonacciSerieTextField setUserInteractionEnabled:NO];
        [self.pisanoPeriodTextField setUserInteractionEnabled:NO];
        
        [self.shareButton setAlpha:0.0f];

        
    }
    else if (textField == self.fibonacciSerieTextField)
    {
        [self.fibonacciSerieTextField setText:@""];
        
        [self.fibonacciNNumberTextField setUserInteractionEnabled:NO];
        [self.pisanoPeriodTextField setUserInteractionEnabled:NO];

    }
    else if (textField == self.pisanoPeriodTextField)
    {
        [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.initialY + 270)];
        
        [self.fibonacciNNumberTextField setUserInteractionEnabled:NO];
        [self.fibonacciSerieTextField setUserInteractionEnabled:NO];
        
        if (SCREEN_HEIGHT == 480)
        {
            [self.scrollView setContentOffset:CGPointMake(0, 160) animated:YES];
        }
        else if (SCREEN_HEIGHT > 480 && USER_INTERFACE_IDIOM != IPAD)
        {
            [self.scrollView setContentOffset:CGPointMake(0, 72) animated:YES];
        }
        
        [self.pisanoPeriodTextField setText:@""];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *validRegEx =@"^[0-9]*$"; //change this regular expression as your requirement
    
    NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
    
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
    
    if (myStringMatchesRegEx)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


#pragma mark Sharing

- (void) shareButtonClicked
{
    ActivityViewCustomProvider *customProvider = [[ActivityViewCustomProvider alloc]init];
    [customProvider setArrayData:self.fibonacciNumbersArray];
    [customProvider setNNumberString:self.fibonacciNNumberTextField.text];
    [customProvider setFnNumberString:self.oneFibonacciNNumberTextField.text];
    [customProvider setType:2];
    
    NSArray *activityItems = [[NSArray alloc]initWithObjects:customProvider, @"",  nil];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePostToWeibo];
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.fibonacciNNumberTextField)
    {
        [self doneFibonacciNNumberTextFieldToolbarClicked:nil];
    }
    else if (textField == self.fibonacciSerieTextField)
    {
        [self doneFibonacciSerieTextFieldToolbarClicked:nil];
    }
    else if (textField == self.pisanoPeriodTextField)
    {
        [self donePisanoPeriodTextFieldToolbarClicked:nil];
    }

    return NO;
}

@end
