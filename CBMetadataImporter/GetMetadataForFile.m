#include <Foundation/Foundation.h>
#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h> 

/* -----------------------------------------------------------------------------
    Get metadata attributes from file
   
   This function's job is to extract useful information your file format supports
   and return it as a dictionary
   ----------------------------------------------------------------------------- */

Boolean GetMetadataForFile(void* thisInterface, 
			   CFMutableDictionaryRef attributes, 
			   CFStringRef contentTypeUTI,
			   CFStringRef pathToFile)
{

	Boolean success = NO;
	NSAutoreleasePool *pool;
	pool = [[NSAutoreleasePool alloc] init];
	
	NSString *cbaUTI = @"com.thierryboudiere.comptesbancaires.cba";
	NSString *cbxUTI = @"com.thierryboudiere.comptesbancaires.cbx";
	
	if ([cbaUTI isEqualToString:(NSString *)contentTypeUTI]) {
		
		NSData *myData = [NSData dataWithContentsOfFile:(NSString *)pathToFile];
		
		if (myData != nil) {
			
			@try {
				
				NSKeyedUnarchiver *keyedUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:myData];
				NSString *myMetadata = [keyedUnarchiver decodeObjectForKey:@"metadata"];
				
				if (myMetadata != nil) {
					[(NSMutableDictionary *)attributes setObject:myMetadata forKey:(NSString *)kMDItemTextContent];
					success = YES;
				}
				[keyedUnarchiver finishDecoding];
				[keyedUnarchiver release];
			}
			@catch (NSException *exception) {
			}
		}
	
	}
	else if ([cbxUTI isEqualToString:(NSString *)contentTypeUTI]) {
		
		NSError *outError;
		NSXMLDocument *myXMLDocument = [[NSXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:(NSString *)pathToFile] options:0 error:&outError];
		
		if (myXMLDocument != nil) {
			
			NSArray *myChildElements = [[myXMLDocument rootElement] elementsForName:@"metadata"];
			
			if (myChildElements != nil && [myChildElements count] > 0) {
			
				NSString *myMetadata = [[myChildElements objectAtIndex:0] stringValue];
				
				if (myMetadata != nil) {
					[(NSMutableDictionary *)attributes setObject:myMetadata forKey:(NSString *)kMDItemTextContent];
					success = YES;
				}
			}
			
			[myXMLDocument release];
		}
	}
	
	[pool release];
    return success;
}
