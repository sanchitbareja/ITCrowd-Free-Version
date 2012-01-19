//
//  reviewViewController.h
//  ITCrowd
//
//  Created by Sanchit Bareja on 2/17/11.
//  Copyright 2011 Nus High. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ReviewViewController : UIViewController<UIWebViewDelegate> {
	
	UIWebView *cnetwebView;
//	UIActivityIndicatorView *webActivityIndicator;

}

-(void)goBack;
-(void)goForward;
-(void)goToCNETMobileReviewSite;

@end
