//
//  eateriesViewController.m
//  ITCrowd
//
//  Created by Sanchit Bareja on 2/17/11.
//  Copyright 2011 Nus High. All rights reserved.
//

#import "EateriesViewController.h"
#import <MapKit/MapKit.h>
#include <unistd.h>

@implementation EateriesViewController

// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)init{
    if (self = [super init]) {
        // Custom initialization
        self.tabBarItem.title = @"Promos Nearby";
        self.tabBarItem.image = [UIImage imageNamed:@"ads_icon_black_small.png"];
		ChalkboardAPIKey = @"CI4vRmejSTkZPjx9YSrydl7VTDtxKdel8gYKCZwUWAjPr7bwld";
		
		//instantiate location and location manager
		myLocationManager = [[CLLocationManager alloc] init];
		myLocationManager.delegate = self;
		myLocationManager.desiredAccuracy = 100;
		[myLocationManager startUpdatingLocation];
		
		//instantiate arrays for ads
		adsNameList = [[NSMutableArray alloc] init];
		adPicURLs = [[NSMutableArray alloc] init];
		baseURLs = [[NSMutableArray alloc] init];
		adsLatitude = [[NSMutableArray alloc] init];
		adsLongitude = [[NSMutableArray alloc] init];
		adsPromoDescription = [[NSMutableArray alloc] init];
		
		//instantiate map view
		mapView2 = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320,367)];
		mapView2.delegate = self;
		//mapView2.centerCoordinate = myLocationManager.location.coordinate;
		mapView2.showsUserLocation = YES;
		
		//check if location is updated from last location	
		//CLLocation lol = (MKMapView)mapView.userLocation.location;
		//coord = lol.coordinate;
		NSTimeInterval age = [myLocationManager.location.timestamp timeIntervalSinceNow];
		if(age > -0.01) {
			coord = myLocationManager.location.coordinate;
			span = MKCoordinateSpanMake(0.01, 0.01); //{latitudeDelta,longitudeDelta}
		}
		else {
			coord = CLLocationCoordinate2DMake(1.361, 103.819);
			span = MKCoordinateSpanMake(0.20, 0.20); //{latitudeDelta,longitudeDelta}
		}		
		
		mapView2.region = MKCoordinateRegionMake(coord,span);
		
		//get Ads and add them to mapView2.annotations
		NSString *urlString = [NSString stringWithFormat:@"http://developer.yourchalkboard.com/promo/api/all/?token=%@&lat=%f&lng=%f&count=50", ChalkboardAPIKey, myLocationManager.location.coordinate.latitude, myLocationManager.location.coordinate.longitude];
		NSURL *url = [NSURL URLWithString:urlString];
		
		// Get the contents of the URL as a string, and parse the JSON into Foundation objects.
		NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
		NSDictionary *results = [jsonString JSONValue];
		
		// Now we need to dig through the resulting objects.
		
		
		// Read the documentation and make liberal use of the debugger or logs.
		NSArray *ads = [results objectForKey:@"results"];
		for (NSDictionary *ad in ads) {
			// Get the information for each ad
			NSString *name = [ad objectForKey:@"name"];
			NSString *baseURLString = [ad objectForKey:@"url"];
			NSString *picURL = [ad objectForKey:@"pic"];
			NSString *adLat = [ad objectForKey:@"lat"];
			NSString *adLng = [ad objectForKey:@"lng"];
			NSString *adDescription = [ad objectForKey:@"promo"];
			[adsNameList addObject:(name.length > 0 ? name : @"Untitled")];
			[adPicURLs addObject:picURL];
			[baseURLs addObject:baseURLString];
			[adsLatitude addObject:adLat];
			[adsLongitude addObject:adLng];
			[adsPromoDescription addObject:adDescription];
		}
		
	}
	
	return self;
}

-(void)viewDidLoad{
	[super viewDidLoad];
	
	//set up segmented button control	
	NSArray *array = [[NSArray alloc] initWithObjects:@"Map",@"List",nil];
	segmentedControl = [[UISegmentedControl alloc] initWithItems:array];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.selectedSegmentIndex = 0;
	[segmentedControl setWidth:80 forSegmentAtIndex:0];
	[segmentedControl setWidth:80 forSegmentAtIndex:1];
	segmentedControl.tintColor = [UIColor grayColor];
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	
	self.navigationItem.titleView = segmentedControl;
	
	//set up refreshAds button
	refreshAds = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAdsAction)];
	refreshAds.style = UIBarButtonItemStylePlain;
	self.navigationItem.rightBarButtonItem = refreshAds;
	
	//set up Navigation Bar
	self.navigationController.navigationBar.tintColor = [UIColor grayColor];
	
	//set up activity indicator
	webActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	
	//instantiate map view
	[self.view addSubview:mapView2];
	
	//instantiate table view and add it to self.view but make sure it is behind mapView2
	tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0,0, 320, 367)];
	tableView2.delegate = self;
	tableView2.dataSource = self;
	tableView2.rowHeight = 100;
	
	[self.view addSubview:tableView2];
	[self.view bringSubviewToFront:mapView2];
	
	//ad annotations (custom view)	
	for (int x=0; x<[adsNameList count]; x++) {
		adsAnnotation  *adAnnotation = [[adsAnnotation alloc] init];
		[adAnnotation setCoordinate:CLLocationCoordinate2DMake([[adsLatitude objectAtIndex:x] floatValue], [[adsLongitude objectAtIndex:x] floatValue])];
		adAnnotation.title = [adsNameList objectAtIndex:x];
		adAnnotation.subtitle = [adsPromoDescription objectAtIndex:x];
		adAnnotation.urlToLoad = [[baseURLs objectAtIndex:x] 
								  stringByAppendingString:[NSString stringWithFormat:@"?token=%@&lat=%f&lng=%f",ChalkboardAPIKey,
														   myLocationManager.location.coordinate.latitude,
														   myLocationManager.location.coordinate.longitude]];
		adAnnotation.indexToLoad = [NSNumber numberWithInt:x];
		[mapView2 addAnnotation:adAnnotation];
		[adAnnotation release];
	}
	
}

- (void)dealloc {
	[myLocationManager stopUpdatingLocation];
	[adsNameList release];
	[adPicURLs release];
	[baseURLs release];
	[adsLatitude release];
	[adsLongitude release];
	[adsPromoDescription release];
	[myLocationManager release];
	[mapView2 release];
	[webActivityIndicator release];
	[refreshAds release];
    [super dealloc];
}

#pragma mark segmentedControl methods

-(void)segmentAction:(id)sender{
	UISegmentedControl *segmentedControl2 = (UISegmentedControl *)sender;
	if (segmentedControl2.selectedSegmentIndex == 0) {
		[self.view bringSubviewToFront:mapView2];
	}
	if (segmentedControl2.selectedSegmentIndex == 1) {
		[self.view bringSubviewToFront:tableView2];
	}
	
}

#pragma mark MKMapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	static NSString *defaultPinID = @"adAnnotation";
	MKPinAnnotationView *retval = nil;
	
	if ([annotation isMemberOfClass:[adsAnnotation class]]) {
		UIButton *adsDetail = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		adsDetail.tag = [[annotation indexToLoad] intValue];
		[adsDetail addTarget:self action:@selector(getAds:) forControlEvents:UIControlEventTouchUpInside];
		retval = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
		retval.canShowCallout = YES;
		retval.rightCalloutAccessoryView = adsDetail;
		retval.animatesDrop = YES;
	}
    return retval;
}

-(void)getAds:(id)sender{
	NSInteger selectedIndex = [sender tag];
	UIViewController *adsViewController = [[[UIViewController alloc] init] autorelease];
	adsViewController.title = @"Promotion";
	UIWebView *adsWebView = [[[UIWebView alloc] init] autorelease];
	adsWebView.delegate = self;
	NSString *urlReqestString = [[baseURLs objectAtIndex:selectedIndex] 
								 stringByAppendingString:[NSString stringWithFormat:@"?token=%@&lat=%f&lng=%f",ChalkboardAPIKey,
														  myLocationManager.location.coordinate.latitude,
														  myLocationManager.location.coordinate.longitude]];
	[adsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlReqestString]]];
	adsViewController.view = adsWebView;
	[self.navigationController pushViewController:adsViewController animated:YES];
}

#pragma mark UITableViewDelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [adsNameList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
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
	frame.size.width=45; frame.size.height=tableView.rowHeight;
	frame.origin.x=0; frame.origin.y=0;
	AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
	asyncImage.tag = 999;
	
	//	NSURL* url = [NSURL URLWithString:[photoURLsIcons objectAtIndex:indexPath.row]];
	NSURL* url = [NSURL URLWithString:[adPicURLs objectAtIndex:indexPath.row]];
	[asyncImage loadImageFromURL:url];
	
	[cell.contentView addSubview:asyncImage]; //add subview for picture to cell
	
	//Handle text	
	CGRect frame2;
	frame2.size.width=245; frame2.size.height=tableView.rowHeight;
	frame2.origin.x=50; frame2.origin.y=0;	
	UILabel *textDisplay = [[[UILabel alloc] initWithFrame:frame2] autorelease];
	textDisplay.tag = 998;
	
	textDisplay.numberOfLines = 0;
	textDisplay.adjustsFontSizeToFitWidth = YES;
	textDisplay.text = [adsNameList objectAtIndex:indexPath.row];
	[cell.contentView addSubview:textDisplay]; //add subview for text to cell
	
	//Handle accessory	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	UIViewController *adsViewController = [[[UIViewController alloc] init] autorelease];
	adsViewController.title = @"Promotion";
	UIWebView *adsWebView = [[[UIWebView alloc] init] autorelease];
	adsWebView.delegate = self;
	NSString *urlReqestString = [[baseURLs objectAtIndex:indexPath.row] 
								 stringByAppendingString:[NSString stringWithFormat:@"?token=%@&lat=%f&lng=%f",ChalkboardAPIKey,
														  myLocationManager.location.coordinate.latitude,
														  myLocationManager.location.coordinate.longitude]];
	[adsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlReqestString]]];
	adsViewController.view = adsWebView;
	[self.navigationController pushViewController:adsViewController animated:YES];
}

#pragma mark UIWebViewDelegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView{
	webActivityIndicator.hidesWhenStopped = YES;
	webActivityIndicator.center = webView.center;
	[webActivityIndicator startAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[webView addSubview:webActivityIndicator];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
	[webActivityIndicator stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[webActivityIndicator removeFromSuperview];
}

#pragma mark Refresh Ads Action

-(void)refreshAdsAction{
	NSLog(@"refreshAdsAction clicked!");
	coord = myLocationManager.location.coordinate;
	span = MKCoordinateSpanMake(0.01, 0.01); //{latitudeDelta,longitudeDelta}
	NSLog(@"CLLocationCoordinate2D coord = %f,%f",coord.latitude,coord.longitude);
	mapView2.region = MKCoordinateRegionMake(coord,span);
	
	//we need to empty the arrays that store the ads before we refresh with new set of ads
	[adsNameList removeAllObjects];
	[adPicURLs removeAllObjects];
	[baseURLs removeAllObjects];
	[adsLatitude removeAllObjects];
	[adsLongitude removeAllObjects];
	[adsPromoDescription removeAllObjects];
	
	//we need to remove all the old annotations
	[mapView2 removeAnnotations:mapView2.annotations];
	mapView2.showsUserLocation = YES;
	
	//get Ads and add them to mapView2.annotations
	NSString *urlString = [NSString stringWithFormat:@"http://developer.yourchalkboard.com/promo/api/all/?token=%@&lat=%f&lng=%f&count=50", ChalkboardAPIKey, myLocationManager.location.coordinate.latitude, myLocationManager.location.coordinate.longitude];
	NSURL *url = [NSURL URLWithString:urlString];
	
    // Get the contents of the URL as a string, and parse the JSON into Foundation objects.
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *results = [jsonString JSONValue];
	
    // Now we need to dig through the resulting objects.
    // Read the documentation and make liberal use of the debugger or logs.
    NSArray *ads = [results objectForKey:@"results"];
    for (NSDictionary *ad in ads) {
        // Get the information for each ad
        NSString *name = [ad objectForKey:@"name"];
		NSString *baseURLString = [ad objectForKey:@"url"];
		NSString *picURL = [ad objectForKey:@"pic"];
		NSString *adLat = [ad objectForKey:@"lat"];
		NSString *adLng = [ad objectForKey:@"lng"];
		NSString *adDescription = [ad objectForKey:@"promo"];
        [adsNameList addObject:(name.length > 0 ? name : @"Untitled")];
		[adPicURLs addObject:picURL];
		[baseURLs addObject:baseURLString];
		[adsLatitude addObject:adLat];
		[adsLongitude addObject:adLng];
		[adsPromoDescription addObject:adDescription];
	}
	
	//ad annotations (custom view)	
	for (int x=0; x<[adsNameList count]; x++) {
		adsAnnotation  *adAnnotation = [[adsAnnotation alloc] init];
		[adAnnotation setCoordinate:CLLocationCoordinate2DMake([[adsLatitude objectAtIndex:x] floatValue], [[adsLongitude objectAtIndex:x] floatValue])];
		adAnnotation.title = [adsNameList objectAtIndex:x];
		adAnnotation.subtitle = [adsPromoDescription objectAtIndex:x];
		adAnnotation.urlToLoad = [[baseURLs objectAtIndex:x] 
								  stringByAppendingString:[NSString stringWithFormat:@"?token=%@&lat=%f&lng=%f",ChalkboardAPIKey,
														   myLocationManager.location.coordinate.latitude,
														   myLocationManager.location.coordinate.longitude]];
		adAnnotation.indexToLoad = [NSNumber numberWithInt:x];
		[mapView2 addAnnotation:adAnnotation];
		[adAnnotation release];
	}
	
	//reload table data	
	[tableView2 reloadData];
	
}

@end
