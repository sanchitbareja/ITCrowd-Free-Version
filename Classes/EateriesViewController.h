//
//  eateriesViewController.h
//  ITCrowd
//
//  Created by Sanchit Bareja on 2/17/11.
//  Copyright 2011 Nus High. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <CoreLocation/CoreLocation.h>
#import "asyncimageview.h"
#import "JSON.h"
#import "adsAnnotation.h"
#import "adsCalloutView.h"

@interface EateriesViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UINavigationControllerDelegate> {
	
	MKMapView *mapView2;
	UISegmentedControl *segmentedControl;
	UITableView *tableView2;
	UIActivityIndicatorView *webActivityIndicator;
	UIBarButtonItem *refreshAds;
	
	CLLocationManager *myLocationManager; //used to obtain location of iphone
	
	NSMutableArray *adsNameList;
	NSMutableArray *adPicURLs;
	NSMutableArray *baseURLs;
	NSMutableArray *adsLatitude;
	NSMutableArray *adsLongitude;
	NSMutableArray *adsPromoDescription;
	
	CLLocationCoordinate2D coord;
	MKCoordinateSpan span;
	
	NSString *ChalkboardAPIKey;
}

-(void)segmentAction:(id)sender;
-(void)refreshAdsAction;

@end

