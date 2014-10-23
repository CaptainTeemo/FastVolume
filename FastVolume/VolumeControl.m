//
//  VolumeControl.m
//  FastVolume
//
//  Created by Andrey Fedorov on 22.10.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "VolumeControl.h"


@implementation VolumeControl

+ (void)setVolume:(float)value
{
    // TODO: any way also toggle vibration?
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

@end
