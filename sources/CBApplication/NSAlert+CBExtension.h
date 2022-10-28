//
//  NSAlert+CBExtension.h
//  CBApplication
//
//  Created by Thierry BOUDIERE on 28/10/2022.
//
//

#import <Cocoa/Cocoa.h>

@interface NSAlert (CBExtension)

+ (NSAlert *)cbAlertWithMessageText:(NSString *)message
                        firstButton:(NSString *)firstButton
                       secondButton:(NSString *)secondButton
        informativeTextWithFormat:(NSString *)format, ...;

@end
