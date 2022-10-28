//
//  NSAlert+CBExtension.m
//  CBApplication
//
//  Created by Thierry BOUDIERE on 28/10/2022.
//
//

#import "NSAlert+CBExtension.h"

@implementation NSAlert (CBExtension)

+ (NSAlert *)cbAlertWithMessageText:(NSString *)message
                        firstButton:(NSString *)firstButton
                       secondButton:(NSString *)secondButton
        informativeTextWithFormat:(NSString *)format, ...
{
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert setAlertStyle:NSAlertStyleWarning];
    [alert setMessageText:message];
    
    [alert addButtonWithTitle:firstButton];
    if (secondButton != nil) {
        [alert addButtonWithTitle:secondButton];
    }

    va_list argList;
    va_start(argList, format);
    NSString *informativeText = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    [alert setInformativeText:informativeText];
    [informativeText release];

    return [alert autorelease];
}

@end
