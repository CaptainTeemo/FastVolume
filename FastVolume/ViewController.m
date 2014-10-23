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
static const float LO_VOLUME = ONE_BAR * 5;
static const float HI_VOLUME = ONE_BAR * 10;


@interface ViewController ()
@property (nonatomic, weak) IBOutlet UISwitch *volumeState;
@end


@implementation ViewController
{
    int notifyToken;
    BOOL canShowHelp;
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

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
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
    canShowHelp = YES;
    [self showHelp];
}


- (void)dealloc
{
    notify_cancel(notifyToken);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)suspend
{
    [self hideHelp];
#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnresolvedMessage"
    [[UIApplication sharedApplication] performSelector:@selector(suspend)];
#pragma clang diagnostic pop
}


- (NSArray *)helpViews
{
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (id elem in self.view.subviews) {
        if ([elem isKindOfClass:[UILabel class]] || [elem isKindOfClass:[UIImageView class]]) {
            UIView *v = elem;
            [views addObject:v];
        }
    }
    return views;
}


- (void)showHelp
{
    static BOOL rotated = NO;
    static BOOL inProgress = NO;
    if (inProgress) return;
    if (!canShowHelp) return;
    inProgress = YES;

    dispatch_time_t x = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 4);
    dispatch_after(x, dispatch_get_main_queue(), ^{
        if (!canShowHelp) {
            inProgress = NO;
            return;
        }
        if (!rotated) {
            rotated = YES;
            double angle[5] = {
                M_PI_4 * 2.5,
                M_PI_4 * 3.5,
                M_PI_4 * 4.5,
                M_PI_4 * 7,
                M_PI_4 * -0.3,
            };
            for (int i = 1; i <= 5; i++) {
                UIImageView *arrowImageView = (UIImageView *)[self.view viewWithTag:i + 100];
                arrowImageView.transform = CGAffineTransformMakeRotation((CGFloat)angle[i - 1]);
            }
        }

        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionFade;
        transition.duration = 1.2;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        for (UIView *v in [self helpViews]) {
            v.hidden = NO;
        }
        [self.view.layer addAnimation:transition forKey:nil];
        inProgress = NO;
    });
}


- (void)hideHelp
{
    for (UIView *v in [self helpViews]) {
        v.hidden = YES;
    }
}


- (void)applicationWillResignActive
{
    canShowHelp = NO;
    [self hideHelp];
}

- (void)applicationDidBecomeActive
{
    canShowHelp = YES;
    [self showHelp];
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
