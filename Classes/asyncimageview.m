//
//  AsyncImageView.m
//  Postcard
//
//  Created by markj on 2/18/09.
//  Copyright 2009 Mark Johnson. You have permission to copy parts of this code into your own projects for any use.
//  www.markj.net
//

#import "AsyncImageView.h"


// This class demonstrates how the URL loading system can be used to make a UIView subclass
// that can download and display an image asynchronously so that the app doesn't block or freeze
// while the image is downloading. It works fine in a UITableView or other cases where there
// are multiple images being downloaded and displayed all at the same time. 

@implementation AsyncImageView

- (void)dealloc {
//	[activityIndicator release];
//	[scrollView2 release];
//	[imageView release];
	[connection cancel]; //in case the URL is still downloading
	[connection release];
	[data release]; 
    [super dealloc];
}

#pragma mark URL connection methods

//this method should be called first after Asyncimageview object is created. remember to set up asyncimage.tag = 999;
- (void)loadImageFromURL:(NSURL*)url {
	if (connection!=nil) { [connection release]; } //in case we are downloading a 2nd image
	if (data!=nil) { [data release]; }
	
	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; //notice how delegate set to self object
	//TODO error handling, what if connection is nil?

	//set up activityIndicator 
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];	
	activityIndicator.hidesWhenStopped = YES;
	activityIndicator.center = self.center;
	[activityIndicator startAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[self addSubview:activityIndicator];
	
	[activityIndicator release];

}


//the URL connection calls this repeatedly as data arrives
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (data==nil) { data = [[NSMutableData alloc] initWithCapacity:2048]; } 
	[data appendData:incrementalData];
}

//the URL connection calls this once all the data has downloaded
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	//so self data now has the complete image 
	[connection release];
	connection=nil;
	if ([[self subviews] count]>0) {
		//then this must be another image, the old one is still in subviews
		[[[self subviews] objectAtIndex:0] removeFromSuperview]; //so remove it (releases it also)
	}
	
	[activityIndicator stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityIndicator removeFromSuperview];
	
	scrollView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	scrollView2.maximumZoomScale = 10.0;
	scrollView2.minimumZoomScale = 1.0;// minimumZoomScale = 1.0 because imageView.frame is already made to fit within the view
	scrollView2.clipsToBounds = YES;
	scrollView2.delegate = self;
	
	//make an image view for the image
	imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]];
	//make sizing choices based on your needs, experiment with these. maybe not all the calls below are needed.
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight );
	imageView.frame = self.bounds;
	
	[scrollView2 addSubview:imageView];
	[self addSubview:scrollView2];
	
	[imageView setNeedsLayout];
	[self setNeedsLayout];

//memory management	
	[imageView release];
	[scrollView2 release];
	
	[data release]; //don't need this any more, its in the UIImageView now
	data=nil;
}

#pragma mark UIScrollViewDelegate methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	CGSize boundsSize = scrollView2.bounds.size;
	CGRect frameToCenter = imageView.frame;
	// center horizontally
	if (frameToCenter.size.width < boundsSize.width) {
		frameToCenter.origin.x = ((boundsSize.width-frameToCenter.size.width)/2);
	}
	else {
		frameToCenter.origin.x = 0;
	}
	// center vertically
	if (frameToCenter.size.height < boundsSize.height) {
		frameToCenter.origin.y = ((boundsSize.height-frameToCenter.size.height)/2);
	}
	else {
		frameToCenter.origin.y = 0;
	}
	
	imageView.frame = frameToCenter;
}

#pragma mark Misc methods
//just in case you want to get the image directly, here it is in subviews
//need to check code - getImage may not work as it is empty
- (UIImageView*) getImage {
	UIImageView* iv = [[scrollView2 subviews] objectAtIndex:0];
	return iv;
}

@end
