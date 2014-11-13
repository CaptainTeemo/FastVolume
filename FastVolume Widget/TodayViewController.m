//
//  TodayViewController.m
//  FastVolume Widget
//
//  Created by Andrey Fedorov on 22.10.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "TodayViewController.h"
#import "VolumeControl.h"
#import "Preferences.h"
#import <NotificationCenter/NotificationCenter.h>


@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic, weak) IBOutlet UILabel *volumeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *volumeImageView;
@end


@implementation TodayViewController
{
    Preferences *preferences;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    preferences = [Preferences new];
    self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
    [self updateViews];
}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    preferences = [Preferences new];
    if ([self needUpdate]) {
        [self updateViews];
        completionHandler(NCUpdateResultNewData);
    } else {
        completionHandler(NCUpdateResultNoData);
    }
}


- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    defaultMarginInsets.bottom = 0.0f;
    return defaultMarginInsets;
}


- (BOOL)needUpdate
{
    static BOOL firstRun = YES;
    if (firstRun) {
        firstRun = NO;
        return YES;
    }
    return [VolumeControl isVolumeInLowRegionOf:preferences.lowVolumeBars high:preferences.highVolumeBars] != [self inLowVolumeState];
}


- (void)setLoVolumeState
{
    [self setVolumeTitle:@"Low  Volume" image:@"LoVolume"];
}


- (void)setHiVolumeState
{
    [self setVolumeTitle:@"High Volume" image:@"HiVolume"];
}


- (void)updateViews
{
    if ([VolumeControl isVolumeInLowRegionOf:preferences.lowVolumeBars high:preferences.highVolumeBars]) {
        [self setLoVolumeState];
    } else {
        [self setHiVolumeState];
    }
}


- (BOOL)inLowVolumeState
{
    return [self.volumeLabel.text hasPrefix:@"Low"];
}


- (void)setVolumeTitle:(NSString *)title image:(NSString *)imageName
{
    self.volumeLabel.text = title;
    self.volumeImageView.image = [UIImage imageNamed:imageName];
}


- (IBAction)toggleVolume
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.4;
    animation.type = kCATransitionFade;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    if ([self inLowVolumeState]) {
        [VolumeControl setVolumeForBars:preferences.highVolumeBars];
        [self setHiVolumeState];
    } else {
        [VolumeControl setVolumeForBars:preferences.lowVolumeBars];
        [self setLoVolumeState];
    }
    [self.view.layer addAnimation:animation forKey:nil];
}

@end
