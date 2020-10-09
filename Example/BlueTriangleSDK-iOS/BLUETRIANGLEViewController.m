//
//  BLUETRIANGLEViewController.m
//  BlueTriangleSDK-iOS
//
//  Created by Julian Wilkison-Duran on 10/09/2020.
//  Copyright (c) 2020 Blue Triangle. All rights reserved.
//

#import "BLUETRIANGLEViewController.h"
#import <BTTimer.h>
#import <BTTracker.h>

@interface BLUETRIANGLEViewController ()

@end

@implementation BLUETRIANGLEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    BTTimer *timer = [BTTimer timerWithPageName:@"page-name-1" trafficSegment:@"traffic-segment-1"];
    [timer setCampaignName:@"campaign-1"];
    [timer setCampaignMedium:@"mobile-ios"];
    [timer setField:@"CV1" stringValue:@"This is a custom Variable"];
    [timer start];
    [[BTTracker sharedTracker] submitTimer:timer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
