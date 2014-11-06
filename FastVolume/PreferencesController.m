//
//  PreferencesController.m
//  FastVolume
//
//  Created by Andrey Fedorov on 06.11.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "PreferencesController.h"


@interface PreferencesController ()
@property (weak, nonatomic) IBOutlet UILabel *lowVolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *highVolumeLabel;
@end


@implementation PreferencesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lowVolumeLabel.text = [NSString stringWithFormat:@"%d", self.lowVolumeBars];
    self.highVolumeLabel.text = [NSString stringWithFormat:@"%d", self.highVolumeBars];
    // TODO: set slider
}


- (IBAction)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
