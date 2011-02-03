#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

int main(int argc, const char *argv[]) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSLog(@"log here");

	[pool release];
	return 0;
}

