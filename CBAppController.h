//
//  CBAppController.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBPrefController.h"


@interface CBAppController : NSObject {
	CBPrefController *prefController;
}

- (IBAction)affichePreferences:(id)sender;

@end
