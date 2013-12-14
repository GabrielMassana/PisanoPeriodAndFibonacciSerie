//
//  ActivityViewCustomProvider.h
//  iRiSTower
//
//  Created by Jose A. Gabriel Massana on 15/01/2013.
//
//

#import <UIKit/UIKit.h>

@interface ActivityViewCustomProvider : UIActivityItemProvider <UIActivityItemSource>

@property (nonatomic) int type;
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) NSString *stringTitle;
@property (nonatomic, strong) NSString *nNumberString;
@property (nonatomic, strong) NSString *FnNumberString;

@end
