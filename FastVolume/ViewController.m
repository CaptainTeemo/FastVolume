//
//  ViewController.m
//  FastVolume
//
//  Created by Andrey Fedorov on 03.04.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "ViewController.h"
#import "AVSystemController.h"
#import <notify.h>


static const float ONE_BAR   = 0.0625; // 16 bars total
static const float LO_VOLUME = ONE_BAR * 4;
static const float HI_VOLUME = ONE_BAR * 10;


@interface ViewController ()
@property (nonatomic, weak) IBOutlet UISwitch *volumeState;
@end


@implementation ViewController
{
    int notifyToken;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.volumeState.transform = CGAffineTransformMakeScale(3, 3);

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(suspend)];
    [self.view addGestureRecognizer:tap];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    notify_register_dispatch("com.apple.springboard.lockcomplete",
        &notifyToken,
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
        ^(int info) {
            uint64_t locked;
            notify_get_state(notifyToken, &locked);
            if (locked) {
                [self.volumeState setOn:![self.volumeState isOn]];
                [self toggleVolume];
            }
        });

    [self syncVolume];
}


- (void)dealloc
{
    notify_cancel(notifyToken);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)suspend
{
    [[UIApplication sharedApplication] performSelector:@selector(suspend)];
}


- (void)applicationWillEnterForeground
{
    [self syncVolume];
}


- (void)setVolume:(float)value
{
    // TODO: any way also toggle vibration?
    if ([self getVolume] != value) {
        [[AVSystemController sharedAVSystemController] setVolumeTo:value forCategory:@"Ringtone"];
    }
}


- (float)getVolume
{
    float volume = 0;
    [[AVSystemController sharedAVSystemController] getVolume:&volume forCategory:@"Ringtone"];
    return volume;
}


- (void)syncVolume
{
    if ([self getVolume] < 0.5) {
        [self loVolume];
    } else {
        [self hiVolume];
    }
}


- (void)loVolume
{
    [self setVolume:LO_VOLUME];
    self.volumeState.on = NO;
}


- (void)hiVolume
{
    [self setVolume:HI_VOLUME];
    self.volumeState.on = YES;
}


- (IBAction)toggleVolume
{
    if (self.volumeState.isOn) {
        [self hiVolume];
    } else {
        [self loVolume];
    }
    [self suspend];
}

@end
