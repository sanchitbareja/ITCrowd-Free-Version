//
//  tourGuideViewController.m
//  ITCrowd
//
//  Created by Sanchit Bareja on 2/17/11.
//  Copyright 2011 Nus High. All rights reserved.
//

#import "TourGuideViewController.h"


@implementation TourGuideViewController

// Override init to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)init{
    if (self = [super init]) {
        // Custom initialization
        self.tabBarItem.title = @"Floor Plans";
        self.tabBarItem.image = [UIImage imageNamed:@"navigation_icon_black_small.png"];
    }
	
	// Obtain Data for NSArray	
	mapURLs = [[NSMutableArray alloc] init];
	mapNames = [[NSMutableArray alloc] init];
	
	mapURLsIcons = [[NSMutableArray alloc] init];
	
	urlBaseString = [NSString stringWithFormat:@"http://www.flypn.com/itcrowd/app/webroot/uploadedstuff/ITShowMaps/"];
	urlBaseStringIcons = [NSString stringWithFormat:@"http://www.flypn.com/itcrowd/app/webroot/uploadedstuff/ITShowMaps/"];
	
	//add photo names and formuate URLs to fetch photo from
	
	//parse XML file to get photoNames and photoURLs
	MyXMLParser *parser = [[MyXMLParser alloc] init];
	[parser parse:@"http://www.flypn.com/itcrowd/app/webroot/uploadedstuff/ITShowData/maps.xml"];
	
	//loop to add parser results to photoNames and photoURLs
	for (int x=0; x<[parser.results count]; x++) {
		[mapNames addObject:[parser.results objectAtIndex:x]];
		[mapURLs addObject:[urlBaseString stringByAppendingString:[[[mapNames objectAtIndex:x] stringByReplacingOccurrencesOfString:@" " withString:@"%20"] stringByAppendingString:@".jpg"]]];
		[mapURLsIcons addObject:[urlBaseStringIcons stringByAppendingString:[[[mapNames objectAtIndex:x] stringByReplacingOccurrencesOfString:@" " withString:@"%20"] stringByAppendingString:@"_tn.jpg"]]];
	}
	
	[parser release];
	return self;
}

-(void)viewDidLoad{
	[super viewDidLoad];
	
	//Navigation Bar set up
	self.navigationItem.title = @"Floor Plans";
	self.navigationController.navigationBar.tintColor = [UIColor grayColor];
	
	//tableOfFlyers set up	
	tableOfMaps = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,367) style:UITableViewStylePlain];
	tableOfMaps.delegate = self;
	tableOfMaps.dataSource = self;
	tableOfMaps.rowHeight = 100; 
	
	[self.view addSubview:tableOfMaps];
}


- (void)dealloc {
	[mapURLs release];
	[mapNames release];
	[tableOfMaps release];
    [super dealloc];
}

#pragma mark Table delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [mapNames count];
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
	frame.size.width=45; frame.size.height=tableOfMaps.rowHeight;
	frame.origin.x=0; frame.origin.y=0;
	AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
	asyncImage.tag = 999;
	
	NSURL* url = [NSURL URLWithString:[mapURLsIcons objectAtIndex:indexPath.row]];
	[asyncImage loadImageFromURL:url];
	
	[cell.contentView addSubview:asyncImage]; //add subview for picture to cell
	
	//Handle text	
	CGRect frame2;
	frame2.size.width=245; frame2.size.height=tableOfMaps.rowHeight;
	frame2.origin.x=50; frame2.origin.y=0;	
	UILabel *textDisplay = [[[UILabel alloc] initWithFrame:frame2] autorelease];
	textDisplay.tag = 998;
	
	textDisplay.numberOfLines = 0;
	textDisplay.adjustsFontSizeToFitWidth = YES;
	textDisplay.text = [mapNames objectAtIndex:indexPath.row];
	[cell.contentView addSubview:textDisplay]; //add subview for text to cell
	
	//Handle accessory	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	DetailViewController *detailView = [[DetailViewController alloc] init];
	detailView.imageURL =[NSURL URLWithString:[mapURLs objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:detailView animated:YES];
}


@end
