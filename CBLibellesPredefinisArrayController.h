//
//  CBLibellesPredefinisArrayController.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 24/01/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBGlobal.h"


@interface CBLibellesPredefinisArrayController : NSArrayController {
	CBTypeMouvement operation;
}

- (CBTypeMouvement)operation;
- (void)setOperation:(CBTypeMouvement)anOperation;

- (IBAction)filtreLibellesPredefinis:(id)sender;

@end
