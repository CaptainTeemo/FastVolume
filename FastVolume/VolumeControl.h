//
//  VolumeControl.h
//  FastVolume
//
//  Created by Andrey Fedorov on 22.10.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "AVSystemController.h"


static const float ONE_BAR = 0.0625; // 16 bars total
static const float LO_VOLUME = ONE_BAR * 5;
static const float HI_VOLUME = ONE_BAR * 10;


@interface VolumeControl : NSObject

+ (void)setVolume:(float)value;
+ (float)volume;

@end
