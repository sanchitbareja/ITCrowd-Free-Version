//
//  reviewViewController.m
//  ITCrowd
//
//  Created by Sanchit Bareja on 2/17/11.
//  Copyright 2011 Nus High. All rights reserved.
//

#import "ReviewViewController.h"


@implementation ReviewViewController

// Override init to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)init{
    if (self = [super init]) {
        // Custom initialization
        self.tabBarItem.title = @"Reviews";
        self.tabBarItem.image = [UIImage imageNamed:@"review.png"];
    }
    return self;
}


- (void)viewDidLoad{
//set up button for navigation titleView
	UIButton *CNETwebsite = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	CNETwebsite.frame = CGRectMake(0, 0, 150, 29); 
	[CNETwebsite setTitle:@"CNET Reviews" forState:UIControlStateNormal];
	CNETwebsite.titleLabel.font = [UIFont systemFontOfSize:16];
	[CNETwebsite setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	[CNETwebsite addTarget:self action:@selector(goToCNETMobileReviewSite) forControlEvents:UIControlEventTouchUpInside];
	
//handle navigation bar items
	self.navigationItem.titleView = CNETwebsite;
	self.navigationController.navigationBar.tintColor = [UIColor grayColor];
	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"\u25C0" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"\u25B6" style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];

	self.navigationItem.leftBarButtonItem = leftButton;
	self.navigationItem.rightBarButtonItem = rightButton;

	
//handle web view	
	cnetwebView = [[UIWebView alloc] init];
	cnetwebView.delegate = self;
	cnetwebView.frame = CGRectMake(0, 0, 320, 367);
	[cnetwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.cnet.com/CReviewsHome.rbml"]]];
	
	[self.view addSubview:cnetwebView];
	
	
//memory management - release everything that we dun need to use anymore	
	[CNETwebsite release];
	[leftButton release];
	[rightButton release];	
	[cnetwebView release];
}

- (void)dealloc {
//	[webActivityIndicator release];
	[cnetwebView release];
    [super dealloc];
}

#pragma mark UIWebViewDelegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView{
	//set up activity indicator
//	webActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//	webActivityIndicator.hidesWhenStopped = YES;
//	webActivityIndicator.center = webView.center;
//	[webActivityIndicator startAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//	[webView addSubview:webActivityIndicator];
	
//	[webActivityIndicator release];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
//	[webActivityIndicator stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//	[webActivityIndicator removeFromSuperview];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//	[webActivityIndicator stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//	[webActivityIndicator removeFromSuperview];
}
																  
#pragma mark UIWebView back and forward methods
																  
- (void)goBack{
	[cnetwebView goBack];
}

- (void)goForward{
	[cnetwebView goForward];
}
			
-(void)goToCNETMobileReviewSite{
	[cnetwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.cnet.com/CReviewsHome.rbml"]]];
}

@end
