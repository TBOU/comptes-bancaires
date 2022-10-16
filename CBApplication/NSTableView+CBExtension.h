//
//  NSTableView+CBExtension.h
//  CBApplication
//
//  Created by Thierry BOUDIERE on 01/03/2015.
//
//

#import <Cocoa/Cocoa.h>

@interface NSTableView (CBExtension)

- (void)cbRepairLayout;
- (void)cbRepairLayoutDeferred;

@end
