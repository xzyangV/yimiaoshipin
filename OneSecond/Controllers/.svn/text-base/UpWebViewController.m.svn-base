//
//  HelpViewController.m
//  Up
//
//  Created by amy on 13-10-17.
//  Copyright (c) 2013年 amy. All rights reserved.
//  Up帮助

#import "UpWebViewController.h"
// view
#import "TranslucentButton.h"
#import "HYActivityView.h"
#import "MBProgressHUD+CMBProgressHUD.h"

#import "ShareObject.h"
//#import "NewsShareObject.h"
#import "SDWebImageManager.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "CloseHTMLObject.h"
@interface UpWebViewController () <UIWebViewDelegate,CloseJSObjectProtocol>
{
    UIWebView *_webView;
    UIActivityIndicatorView *_indicatorView;
}
@end

@implementation UpWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.title = UPLocalizedString(@"up help", nil);
    self.navigationItem.leftBarButtonItem = [BizCommon barBackBtnWithTitle:UPLocalizedString(@"back", nil)
                                                               clickTarget:self
                                                                    action:@selector(backBtnClick)];
    

    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.scalesPageToFit = YES;
    [_webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    _webView.delegate = self;
    _webView.scalesPageToFit = NO;
    _webView.dataDetectorTypes  = UIDataDetectorTypeAll;
    [self.view addSubview:_webView];
    
    __weak typeof(self)wSelf = self;
    JSContext *context=[_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    CloseHTMLObject *close = [CloseHTMLObject new];
    close.closeDelegate = self;
    close.closeBlock = ^(void){
        [wSelf onClose];
    };
    context[@"my"]= close;
    NSString *jsStr = @"onClose()";
    [context evaluateScript:jsStr];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_indicatorView];
    
    
    
    
    [self showIndicator];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Build View


- (void)showIndicator
{
    [_indicatorView sizeToFit];
    [_indicatorView startAnimating];
    _indicatorView.center = _webView.center;
}

- (void)hideIndicator
{
    [_indicatorView stopAnimating];
}

#pragma mark Build data

- (NSString *)pageTitle
{
    return [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark Action Method

- (void)backBtnClick
{
    if (_webView.canGoBack) {
        [_webView goBack];
    }
    else{
//        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

    


//关闭h5
-(void)onClose{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}


#pragma mark - UIWebView Delegate


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
	[self hideIndicator];
    NSString *title = [self pageTitle];
    self.navigationItem.titleView = [PublicObject barTitleLabel:title];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideIndicator];
}






@end
