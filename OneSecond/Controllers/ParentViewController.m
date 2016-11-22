//
//  ParentViewController.m
//  Up
//
//  Created by zhangyx on 13-11-21.
//  Copyright (c) 2013年 amy. All rights reserved.
//

#import "ParentViewController.h"

@interface ParentViewController ()

@end

@implementation ParentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (kIsIOS7) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (DeviceSizeType)sizeType
{
    if ([UIScreen mainScreen].bounds.size.width > 400) {
        return DeviceSizeType55;
    }
    else if ([UIScreen mainScreen].bounds.size.width > 320 && [UIScreen mainScreen].bounds.size.width < 400) {
        return DeviceSizeType47;
    }
    else if (([UIScreen mainScreen].bounds.size.width == 320) && [UIScreen mainScreen].bounds.size.height > 480) {
        return DeviceSizeType40;
    }
    else {
        return DeviceSizeType35;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
