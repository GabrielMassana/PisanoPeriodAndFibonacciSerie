//
//  Utils.h
//  PisanoPeriod
//
//  Created by Gabriel Massana on 12/13/13.
//  Copyright (c) 2013 Gabriel Massana. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define USER_INTERFACE_IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD                    UIUserInterfaceIdiomPad

@interface Utils : NSObject

+ (UIStoryboard *) getStoryboardType;

@end
