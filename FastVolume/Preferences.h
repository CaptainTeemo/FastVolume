//
//  Preferences.h
//  FastVolume
//
//  Created by Andrey Fedorov on 13.11.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

@import Foundation;


@interface Preferences : NSObject

- (int)lowVolumeBars;
- (int)highVolumeBars;
- (void)setVolumeLimitsLow:(int)low high:(int)high;

@end
