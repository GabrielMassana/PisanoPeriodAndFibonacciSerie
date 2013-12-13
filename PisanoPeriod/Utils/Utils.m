//
//  Utils.m
//  PisanoPeriod
//
//  Created by Gabriel Massana on 12/13/13.
//  Copyright (c) 2013 Gabriel Massana. All rights reserved.
//

#import "Utils.h"

@implementation Utils

// return iPad or iPhone Storyboard
+ (UIStoryboard *) getStoryboardType
{
    UIStoryboard*  storyboard;
    if (USER_INTERFACE_IDIOM == IPAD)
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad"  bundle:nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone"  bundle:nil];
    }
    return storyboard;
}

@end
