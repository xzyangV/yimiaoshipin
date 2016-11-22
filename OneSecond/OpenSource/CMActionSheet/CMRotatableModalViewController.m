//
//  CMRotatableModalViewController
//
//  Created by Constantine Mureev on 09.08.12.
//  Copyright (c) 2012 Team Force LLC. All rights reserved.
//

#import "CMRotatableModalViewController.h"

@implementation CMRotatableModalViewController

@synthesize rootViewController;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (interfaceOrientation == self.rootViewController.interfaceOrientation) {
        return YES;
    } else {
        return NO;
    }
}

@end
