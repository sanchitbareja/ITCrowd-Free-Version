//
//  uploadFlyersViewController.h
//  ITCrowd
//
//  Created by Sanchit Bareja on 2/17/11.
//  Copyright 2011 Nus High. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "asyncimageview.h"
#import "MyXMLParser.h"
#import "DetailViewController.h"

@interface UploadFlyersViewController : UIViewController<UINavigationControllerDelegate, 
														UIImagePickerControllerDelegate,  
														UITableViewDelegate, 
														UITableViewDataSource,
														UISearchBarDelegate,
														UITextFieldDelegate,
														UIAlertViewDelegate> 
{

	UITableView *tableOfFlyers;
	UISearchBar *sBar;

	NSString *urlBaseString;
	NSString *urlBaseStringIcons;
	
	NSMutableArray *dataSourcePhotoNames;
	NSMutableArray *photoNames;
	NSMutableArray *photoURLs;
	NSMutableArray *dataSourcePhotoURLs;
	NSMutableArray *photoURLsIcons;
	NSMutableArray *dataSourcePhotoURLsIcons;
}

@end
