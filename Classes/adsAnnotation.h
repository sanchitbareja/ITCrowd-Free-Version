//
//  adsAnnotationView.h
//  ITCrowd
//
//  Created by Sanchit Bareja on 3/14/11.
//  Copyright 2011 Nus High. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface adsAnnotation : NSObject<MKAnnotation> {

	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *subtitle;
@property (retain, nonatomic) NSString *urlToLoad;
@property (retain, nonatomic) NSNumber *indexToLoad;

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
-(NSString *)title;
-(NSString *)subtitle;
-(NSString *)urlToLoad;
-(NSNumber *)indexToLoad;

@end
