//
//  DetailViewController.h
//  ITCrowd
//
//  Created by Sanchit Bareja on 3/7/11.
//  Copyright 2011 Nus High. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "asyncimageview.h"

@interface DetailViewController : UIViewController {

	NSURL *imageURL;	
	AsyncImageView *asyncImage;
}

@property (retain) NSURL *imageURL;

-(void)saveImageToLibrary;

@end
