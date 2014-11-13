//
//  PreferencesController.m
//  FastVolume
//
//  Created by Andrey Fedorov on 06.11.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "PreferencesController.h"
#import "NMRangeSlider.h"


@interface PreferencesController ()
@property (weak, nonatomic) IBOutlet UILabel *lowVolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *highVolumeLabel;
@property (weak, nonatomic) IBOutlet NMRangeSlider *volumeLimitsSlider;
@end


@implementation PreferencesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureMetalThemeForSlider:self.volumeLimitsSlider];

    // MAX value should be set first
    self.volumeLimitsSlider.maximumValue = 16.0;
    self.volumeLimitsSlider.minimumValue = 1.0;
    self.volumeLimitsSlider.upperValue = 16.0;
    self.volumeLimitsSlider.lowerValue = 1.0;
    self.volumeLimitsSlider.minimumRange = 3.0;
    self.volumeLimitsSlider.stepValue = 1.0;
    self.volumeLimitsSlider.stepValueContinuously = YES;
    [self.volumeLimitsSlider addTarget:self action:@selector(sliderDidMove:) forControlEvents:UIControlEventValueChanged];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.lowVolumeLabel.hidden = NO;
    self.highVolumeLabel.hidden = NO;
    [self.volumeLimitsSlider setLowerValue:(float)self.lowVolumeBars upperValue:(float)self.highVolumeBars animated:YES];
    [self updateSliderLabels];
}


- (void) configureMetalThemeForSlider:(NMRangeSlider*) slider
{
    UIImage* image = nil;

    image = [UIImage imageNamed:@"slider-metal-trackBackground"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    slider.trackBackgroundImage = image;

    image = [UIImage imageNamed:@"slider-metal-track"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)];
    slider.trackImage = image;

    image = [UIImage imageNamed:@"slider-metal-handle"];
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-1, 2, 1, 2)];
    slider.lowerHandleImageNormal = image;
    slider.upperHandleImageNormal = image;

    image = [UIImage imageNamed:@"slider-metal-handle-highlighted"];
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-1, 2, 1, 2)];
    slider.lowerHandleImageHighlighted = image;
    slider.upperHandleImageHighlighted = image;
}



- (void)updateSliderLabels
{
    CGPoint lowerCenter;
    lowerCenter.x = (self.volumeLimitsSlider.lowerCenter.x + self.volumeLimitsSlider.frame.origin.x);
    lowerCenter.y = (self.volumeLimitsSlider.center.y - 30.0f);
    self.lowVolumeLabel.center = lowerCenter;
    self.lowVolumeLabel.text = [NSString stringWithFormat:@"%d", (int)self.volumeLimitsSlider.lowerValue];

    CGPoint upperCenter;
    upperCenter.x = (self.volumeLimitsSlider.upperCenter.x + self.volumeLimitsSlider.frame.origin.x);
    upperCenter.y = (self.volumeLimitsSlider.center.y - 30.0f);
    self.highVolumeLabel.center = upperCenter;
    self.highVolumeLabel.text = [NSString stringWithFormat:@"%d", (int)self.volumeLimitsSlider.upperValue];
}


- (void)sliderDidMove:(NMRangeSlider *)slider
{
    [self updateSliderLabels];
    self.lowVolumeBars = (int)self.volumeLimitsSlider.lowerValue;
    self.highVolumeBars = (int)self.volumeLimitsSlider.upperValue;
}


- (IBAction)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
