//
//  NSTableView+CBExtension.m
//  CBApplication
//
//  Created by Thierry BOUDIERE on 01/03/2015.
//
//

#import "NSTableView+CBExtension.h"

@implementation NSTableView (CBExtension)

- (void)cbRepairLayout
{
    NSEnumerator *objectsEnumerator = [[self tableColumns] objectEnumerator];
    NSTableColumn *column;
    while (column = (NSTableColumn *)[objectsEnumerator nextObject]) {
        if ([[column dataCell] isKindOfClass:[NSTextFieldCell class]]) {
            NSTextFieldCell *cell = (NSTextFieldCell *)[column dataCell];
            [cell setFont:[NSFont monospacedDigitSystemFontOfSize:[[cell font] pointSize] weight:NSFontWeightRegular]];
        }
    }

    [self reloadData];
    [self scrollRowToVisible:[self selectedRow]];
}

- (void)cbRepairLayoutDeferred
{
    [self performSelector:@selector(cbRepairLayout) withObject:nil afterDelay:0.0 inModes:[NSArray arrayWithObjects:NSDefaultRunLoopMode, NSModalPanelRunLoopMode, nil]];
}

@end
