//
//  FibonacciSerieTableViewController.h
//  PisanoPeriod
//
//  Created by Gabriel Massana on 12/13/13.
//  Copyright (c) 2013 Gabriel Massana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FibonacciSerieTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *fibonacciNumbersArray;
@property (nonatomic) int type;
@property (nonatomic) int mod;
@property (nonatomic) int period;
@property (nonatomic) int zeros;

@end
