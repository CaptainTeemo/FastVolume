//
//  VolumeControl.m
//  FastVolume
//
//  Created by Andrey Fedorov on 22.10.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "VolumeControl.h"


static const float VOLUME_PER_BAR = 0.0625;


@implementation VolumeControl

+ (void)setVolumeForBars:(int)bars
{
    // TODO: any way also toggle vibration?
    float value = bars * VOLUME_PER_BAR;
    if (self.volume != value) {
        [[AVSystemController sharedAVSystemController] setVolumeTo:value forCategory:@"Ringtone"];
    }
}


+ (float)volume
{
    float volume = 0;
    [[AVSystemController sharedAVSystemController] getVolume:&volume forCategory:@"Ringtone"];
    return volume;
}


+ (BOOL)isVolumeInLowRegionOf:(int)lowBars high:(int)highBars
{
    float middle = lowBars + (highBars - lowBars) / 2.0f;
    return self.volume < middle * VOLUME_PER_BAR;
}

@end
