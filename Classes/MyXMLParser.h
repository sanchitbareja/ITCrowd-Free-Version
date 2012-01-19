//
//  MyXMLParser.h
//  MyTableView
//
//  Created by Sanchit Bareja on 3/6/11.
//  Copyright 2011 Nus High. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyXMLParser : NSObject<NSXMLParserDelegate> {
	NSMutableArray *results;
	NSString *currentElement;
	BOOL hasReachedEndOfTag;
}

@property (retain) NSMutableArray *results;

-(void) parse:(NSString *)xmlFilePath;

@end
