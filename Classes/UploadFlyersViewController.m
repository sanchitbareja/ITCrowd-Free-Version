//
//  uploadFlyersViewController.m
//  ITCrowd
//
//  Created by Sanchit Bareja on 2/17/11.
//  Copyright 2011 Nus High. All rights reserved.
//

#import "UploadFlyersViewController.h"

@implementation UploadFlyersViewController

- (id)init{
    if (self = [super init]) {
        // Custom initialization
		self.tabBarItem.title = @"Flyers";
        self.tabBarItem.image = [UIImage imageNamed:@"flyers.png"];
		
    }
	
// Obtain Data for NSArray	
	photoURLs = [[NSMutableArray alloc] init];
	photoNames = [[NSMutableArray alloc] init];
	dataSourcePhotoNames = [[NSMutableArray alloc] init];
	dataSourcePhotoURLs = [[NSMutableArray alloc] init];
	photoURLsIcons = [[NSMutableArray alloc] init];
	dataSourcePhotoURLsIcons = [[NSMutableArray alloc] init];
	
	urlBaseString = [NSString stringWithFormat:@"http://www.flypn.com/itcrowd/app/webroot/uploadedstuff/"];
	urlBaseStringIcons = [NSString stringWithFormat:@"http://www.flypn.com/itcrowd/app/webroot/uploadedstuff/"];
	
	//add photo names and formuate URLs to fetch photo from
	
	//parse XML file to get photoNames and photoURLs
	MyXMLParser *parser = [[MyXMLParser alloc] init];
	[parser parse:@"http://www.flypn.com/itcrowd/app/webroot/uploadedstuff/ITShowData/flyers.xml"];
	
	//loop to add parser results to photoNames and photoURLs
	for (int x=0; x<[parser.results count]; x++) {
		[photoNames addObject:[parser.results objectAtIndex:x]];
		[dataSourcePhotoNames addObject:[parser.results objectAtIndex:x]];
		[photoURLs addObject:[urlBaseString stringByAppendingString:[[[photoNames objectAtIndex:x] stringByReplacingOccurrencesOfString:@" " withString:@"%20"] stringByAppendingString:@".jpg"]]];
		[dataSourcePhotoURLs addObject:[urlBaseString stringByAppendingString:[[[photoNames objectAtIndex:x] stringByReplacingOccurrencesOfString:@" " withString:@"%20"] stringByAppendingString:@".jpg"]]];
		[photoURLsIcons addObject:[urlBaseStringIcons stringByAppendingString:[[[photoNames objectAtIndex:x] stringByReplacingOccurrencesOfString:@" " withString:@"%20"] stringByAppendingString:@"_tn.jpg"]]];
		[dataSourcePhotoURLsIcons addObject:[urlBaseStringIcons stringByAppendingString:[[[photoNames objectAtIndex:x] stringByReplacingOccurrencesOfString:@" " withString:@"%20"] stringByAppendingString:@"_tn.jpg"]]];
	}
	
	[parser release];
	
    return self;
}

- (void)viewDidLoad{
	[super viewDidLoad];

//title of Navigation Bar	
	self.navigationItem.title = @"Flyers";
	self.navigationController.navigationBar.tintColor = [UIColor grayColor];

//tableOfFlyers set up	
	tableOfFlyers = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,367) style:UITableViewStylePlain];
	tableOfFlyers.delegate = self;
	tableOfFlyers.dataSource = self;
	tableOfFlyers.rowHeight = 100; 
	
	[self.view addSubview:tableOfFlyers];
	
//search bar set up
	
	sBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,320,30)];
	sBar.delegate = self;
	sBar.placeholder = @"Search here (e.g. Laptops)";
	sBar.tintColor = [UIColor grayColor];
	tableOfFlyers.tableHeaderView = sBar;

	//hide search bar underneath navigation bar initially.
	tableOfFlyers.contentOffset = CGPointMake(0, sBar.frame.size.height);
	
}

- (void)dealloc {
	[tableOfFlyers release];
	[dataSourcePhotoURLs release];
	[dataSourcePhotoNames release];
	[photoURLs release];
    [photoNames release];
	[photoURLsIcons release];
	[dataSourcePhotoURLsIcons release];
	
    [super dealloc];
}

#pragma mark UISearchBar delegate methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// only show the status bar's cancel button while in edit mode
	[sBar setShowsCancelButton:YES animated:YES];
	sBar.autocorrectionType = UITextAutocorrectionTypeNo;
	// flush the previous search content
	sBar.text = @"";
//	[photoNames removeAllObjects];
//	[photoURLs removeAllObjects];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	sBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[photoNames removeAllObjects];// remove all data that belongs to previous search
	[photoURLs removeAllObjects];// remove all data that belongs to previous search
	[photoURLsIcons removeAllObjects];// remove all data that belongs to previous search 
	if([searchText isEqualToString:@""]||searchText==nil){
		[tableOfFlyers reloadData];
//		return;
	}
	NSInteger counter = 0;
	NSInteger counter2 = 0;
	for(NSString *name in dataSourcePhotoNames)
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
		NSRange r = [[name lowercaseString] rangeOfString:[searchText lowercaseString]];
		if(r.location != NSNotFound){
			[photoNames addObject:[dataSourcePhotoNames objectAtIndex:counter]];
			[photoURLs addObject:[dataSourcePhotoURLs objectAtIndex:counter]];
			[photoURLsIcons addObject:[dataSourcePhotoURLsIcons objectAtIndex:counter]];
			
			counter2++;
		}
		counter++;
		
		[pool release];
		
		[tableOfFlyers reloadData];
	}
	
	[tableOfFlyers reloadData];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	// if a valid search was entered but the user wanted to cancel, bring back the main list content
	[photoNames removeAllObjects];
	[photoNames addObjectsFromArray:dataSourcePhotoNames];
	[photoURLs removeAllObjects];
	[photoURLs addObjectsFromArray:dataSourcePhotoURLs];
	[photoURLsIcons removeAllObjects];
	[photoURLsIcons addObjectsFromArray:dataSourcePhotoURLsIcons];
	@try{
		[tableOfFlyers reloadData];
	}
	@catch(NSException *e){
		
	}
	[sBar setShowsCancelButton:NO animated:YES];
	[sBar resignFirstResponder];
}

// called when Search (in our case "Done") button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	[searchBar resignFirstResponder];
}

#pragma mark - UITableView Delegate methods implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [photoNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	static NSString *CellIdentifier = @"ImageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
				 initWithFrame:CGRectZero reuseIdentifier:CellIdentifier]
				autorelease];
    } else {
		AsyncImageView* oldImage = (AsyncImageView*)[cell.contentView viewWithTag:999];
		UILabel* oldText = (UILabel*)[cell.contentView viewWithTag:998];
		//remove old subviews from cell if not the subviews will overlap!
		[oldImage removeFromSuperview];
		[oldText removeFromSuperview];
    }
	
	
//Handle image	

	CGRect frame;
	frame.size.width=45; frame.size.height=tableOfFlyers.rowHeight;
	frame.origin.x=0; frame.origin.y=0;
	AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
	asyncImage.tag = 999;
	
	NSURL* url = [NSURL URLWithString:[photoURLsIcons objectAtIndex:indexPath.row]];
	[asyncImage loadImageFromURL:url];
	
	[cell.contentView addSubview:asyncImage]; //add subview for picture to cell

//Handle text	
	CGRect frame2;
	frame2.size.width=245; frame2.size.height=tableOfFlyers.rowHeight;
	frame2.origin.x=50; frame2.origin.y=0;	
	UILabel *textDisplay = [[[UILabel alloc] initWithFrame:frame2] autorelease];
	textDisplay.tag = 998;
	
	textDisplay.numberOfLines = 0;
	textDisplay.adjustsFontSizeToFitWidth = YES;
	textDisplay.text = [photoNames objectAtIndex:indexPath.row];
	[cell.contentView addSubview:textDisplay]; //add subview for text to cell

//Handle accessory	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	DetailViewController *detailView = [[DetailViewController alloc] init];
	detailView.imageURL =[NSURL URLWithString:[photoURLs objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:detailView animated:YES];
}

@end
