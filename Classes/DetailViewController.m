//
//  DetailViewController.m
//  ITCrowd
//
//  Created by Sanchit Bareja on 3/7/11.
//  Copyright 2011 Nus High. All rights reserved.
//

#import "DetailViewController.h"
#import "asyncimageview.h"

@implementation DetailViewController

@synthesize imageURL;


-(void)dealloc{
	[asyncImage release];
	[super dealloc];
}

-(void)viewDidLoad{
	
	asyncImage = [[[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)] autorelease];
	asyncImage.tag = 999;
	[asyncImage loadImageFromURL:imageURL];
	[self.view addSubview:asyncImage];
	
	
//set up navigation bar including a right bar button	
//	self.navigationItem.title = @"Flyer Details";
	
	UIBarButtonItem *saveImageButton = [[UIBarButtonItem alloc] initWithTitle:@"Save Flyer To Library" style:UIBarButtonItemStyleBordered target:self action:@selector(saveImageToLibrary)];
	self.navigationItem.rightBarButtonItem = saveImageButton;
	[saveImageButton release];		
}

-(void)saveImageToLibrary{
	UIImageWriteToSavedPhotosAlbum([asyncImage getImage].image, nil, nil, nil);
}
@end
