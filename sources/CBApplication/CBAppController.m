//
//  CBAppController.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import "CBAppController.h"
#import "CBGlobal.h"


@implementation CBAppController

+ (void)initialize
{
	NSString *userDefaultsValuesPath;
	NSDictionary *userDefaultsValuesDict;
	
	userDefaultsValuesPath = [[NSBundle mainBundle] pathForResource:@"UserDefaults" ofType:@"plist"];
	userDefaultsValuesDict = [NSDictionary dictionaryWithContentsOfFile:userDefaultsValuesPath];
	[[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsValuesDict];
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
    [[NSDocumentController sharedDocumentController] setAutosavingDelay:60.0];
}

- (IBAction)affichePreferences:(id)sender
{
	if (!prefController) {
		prefController = [[CBPrefController alloc] init];
	}
	[prefController showWindow:self];
}

- (void)dealloc
{
	[prefController release];
	[super dealloc];
}

@end
