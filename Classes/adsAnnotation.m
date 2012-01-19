//
//  adsAnnotationView.m
//  ITCrowd
//
//  Created by Sanchit Bareja on 3/14/11.
//  Copyright 2011 Nus High. All rights reserved.
//

#import "adsAnnotation.h"


@implementation adsAnnotation

@synthesize coordinate, title, subtitle, urlToLoad, indexToLoad;

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
	coordinate = newCoordinate;
}

-(NSString *)title{
	return title;
}
-(NSString *)subtitle{
	return subtitle;
}
-(NSString *)urlToLoad{
	return urlToLoad;
}

-(NSNumber *)indexToLoad{
	return indexToLoad;
}

@end
