//
//  VolumeControl.h
//  FastVolume
//
//  Created by Andrey Fedorov on 22.10.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "AVSystemController.h"


@interface VolumeControl : NSObject

+ (void)setVolumeForBars:(int)bars;
+ (BOOL)isVolumeInLowRegionOf:(int)lowBars high:(int)highBars;

@end
