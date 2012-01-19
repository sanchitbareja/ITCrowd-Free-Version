//
//  adsCalloutView.h
//  ITCrowd
//
//  Created by Sanchit Bareja on 3/14/11.
//  Copyright 2011 Nus High. All rights reserved.
//
/*

	This class will replace the pin that appears in the MKMapView. Customize drawRect to get own pin.

*/
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface adsCalloutView : MKAnnotationView {

	NSString *companyName;
	
}

@property (retain) NSString *companyName;
//@property (retain, nonatomic) NSString *promoText;
//@property (retain, nonatomic) NSString *promoURL;
//@property (retain, nonatomic) NSString *promoPic;


@end
