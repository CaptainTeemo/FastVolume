//
//  Preferences.m
//  FastVolume
//
//  Created by Andrey Fedorov on 13.11.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "Preferences.h"


// 16 bars total
static const int DEFAULT_LOW_VOLUME_BARS = 5;
static const int DEFAULT_HIGH_VOLUME_BARS = 10;

static NSString *const kLowVolumeKey = @"LowVolumeKey";
static NSString *const kHighVolumeKey = @"HighVolumeKey";


@implementation Preferences
{
    int _lowBars;
    int _highBars;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *userDefaults = [self userDefaults];
        _lowBars = (int)[userDefaults integerForKey:kLowVolumeKey];
        _highBars = (int)[userDefaults integerForKey:kHighVolumeKey];

        if (_lowBars == 0) _lowBars = DEFAULT_LOW_VOLUME_BARS;
        if (_highBars == 0) _highBars = DEFAULT_HIGH_VOLUME_BARS;
    }
    return self;
}


- (NSUserDefaults *)userDefaults
{
    return [[NSUserDefaults alloc] initWithSuiteName:@"group.com.myriad.FastVolume.Preferences"];
}


- (int)lowVolumeBars
{
    return _lowBars;
}


- (int)highVolumeBars
{
    return _highBars;
}


- (void)setVolumeLimitsLow:(int)low high:(int)high
{
    _lowBars = low;
    _highBars = high;
    NSUserDefaults *userDefaults = [self userDefaults];
    [userDefaults setInteger:low forKey:kLowVolumeKey];
    [userDefaults setInteger:high forKey:kHighVolumeKey];
    [userDefaults synchronize];
}

@end
