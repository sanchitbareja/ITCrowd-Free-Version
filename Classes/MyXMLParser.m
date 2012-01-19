//
//  MyXMLParser.m
//  MyTableView
//
//  Created by Sanchit Bareja on 3/6/11.
//  Copyright 2011 Nus High. All rights reserved.
//

#import "MyXMLParser.h"


@implementation MyXMLParser

@synthesize results;

-(void) parse:(NSString *)xmlFilePath
{
	self.results  = [[NSMutableArray alloc] init];  
	currentElement = [[NSString alloc] init];
	NSURL* xmlURL = [NSURL URLWithString:xmlFilePath];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	parser.delegate = self;  
	[parser parse];
	
//	[xmlURL release]; //crashed because of this line for dunno what reason!
	[parser release];
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *) qualifiedName attributes:(NSDictionary *)attributeDict{
	if ([elementName isEqualToString:@"NAME"]) {
		currentElement = @"NAME";
		hasReachedEndOfTag = NO;
		
	}
	else {
		currentElement = nil;
	}

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if ([elementName isEqualToString:@"NAME"]) {
		hasReachedEndOfTag = YES;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	if ([currentElement isEqualToString:@"NAME"] && hasReachedEndOfTag == NO) {
		[results addObject:string];
	}
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
		
}

-(void)dealloc{
	
	
	[results release];
	[currentElement release];
	
	[super dealloc];
}

@end
