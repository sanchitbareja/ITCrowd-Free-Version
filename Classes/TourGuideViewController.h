//
//  tourGuideViewController.h
//  ITCrowd
//
//  Created by Sanchit Bareja on 2/17/11.
//  Copyright 2011 Nus High. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "asyncimageview.h"
#import "MyXMLParser.h"
#import "DetailViewController.h"

@interface TourGuideViewController : UIViewController<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource> {
	
	UITableView *tableOfMaps;
	
	NSString *urlBaseString;
	NSString *urlBaseStringIcons;
	
	NSMutableArray *mapNames;
	NSMutableArray *mapURLs;
	NSMutableArray *mapURLsIcons;
}

@end
