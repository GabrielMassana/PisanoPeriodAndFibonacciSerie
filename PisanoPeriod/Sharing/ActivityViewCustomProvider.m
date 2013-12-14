//
//  ActivityViewCustomProvider.m
//  iRiSTower
//
//  Created by Jose A. Gabriel Massana on 15/01/2013.
//
//

#import "ActivityViewCustomProvider.h"
#import "JKBigInteger.h"

#define URL_TWITTER_CHARACTERS 24
#define IMAGE_TWITTER_CHARACTERS 33

@implementation ActivityViewCustomProvider

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    
    if (self.type == 0 || self.type == 1)
    {
        
        if ([activityType isEqualToString:UIActivityTypeMail] || [activityType isEqualToString:UIActivityTypePostToFacebook] || [activityType isEqualToString:UIActivityTypeMessage] || [activityType isEqualToString:UIActivityTypeCopyToPasteboard]   )
        {
            NSString *returnString;
            returnString = [NSString stringWithFormat:@" %@\n\n%@",self.stringTitle, [self getStringFibinocciData]];
            return returnString;
        }
        
    }
    else if (self.type == 2)
    {
        NSString *returnString;
        returnString = [NSString stringWithFormat:@"Fibonacci(%@): %@",self.nNumberString, self.FnNumberString];
        return returnString;

    }
    
    return nil;
}

- (NSString*) getStringFibinocciData
{
    NSMutableString *string = [[NSMutableString alloc]init];
    
    for (JKBigInteger *bigInteger in self.arrayData)
    {
       [string  appendString:[NSString stringWithFormat:@"%@,\n", bigInteger]];
    }
    
    return string;
}


@end
