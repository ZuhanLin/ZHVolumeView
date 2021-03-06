//
//  ZHVolumeView.m
//  VolumeDemo
//
//  Created by linzuhan on 2018/11/23.
//  Copyright © 2018 ibobei. All rights reserved.
//

#import "ZHVolumeView.h"
#import <MediaPlayer/MPVolumeView.h>
#import <AVFoundation/AVFAudio.h>

@interface ZHVolumeView ()

@property (nonatomic, strong) MPVolumeView *systemVolumeView;
@property (nonatomic, weak) UISlider *systemVolumeSlider;

@property (nonatomic, strong) UIProgressView *volumeProgressView;

@end

@implementation ZHVolumeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)customInit
{
    _value = 0.f;
    _progressViewTintColor = [UIColor whiteColor];
    _progressViewHeight = 1.f;
    
    // init systemVolumeView
    self.systemVolumeView = [[MPVolumeView alloc] init];
    self.systemVolumeView.showsRouteButton = NO;
    self.systemVolumeView.showsVolumeSlider = YES;
    
    [self.systemVolumeView sizeToFit];
    [self.systemVolumeView setFrame:CGRectMake(-10000, -10000, 10, 10)];
    
    [self addSubview:self.systemVolumeView];
    [self.systemVolumeView userActivity];
    
    for (UIView *view in self.systemVolumeView.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"MPVolumeSlider")]) {
            self.systemVolumeSlider = (UISlider *)view;
            break;
        }
    }
    
    // set default volume
    float systemVolume = [[AVAudioSession sharedInstance] outputVolume];
    [self setValue:systemVolume];
    
    // set default volume value 0.5
//    [self.systemVolumeSlider setValue:0.5];
    
    // init volumeProgressView
    self.volumeProgressView = [[UIProgressView alloc] init];
    self.volumeProgressView.tintColor = _progressViewTintColor;
    self.volumeProgressView.trackTintColor = [UIColor clearColor];
    self.volumeProgressView.progress = _value;
    self.volumeProgressView.hidden = YES;
    self.volumeProgressView.alpha = 0.f;
    [self addSubview:self.volumeProgressView];
    [self.volumeProgressView setFrame:CGRectMake(0, 0, 100, 2)];
    
    // register Observers
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(systemVolumeDidChanged:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

- (void)setValue:(float)value
{
    _value = value;
    
    self.volumeProgressView.progress = value;
}

- (void)setProgressViewTintColor:(UIColor *)progressViewTintColor
{
    _progressViewTintColor = progressViewTintColor;
    
    self.volumeProgressView.tintColor = _progressViewTintColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.volumeProgressView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 2);
    self.volumeProgressView.transform = CGAffineTransformMakeScale(1.0, _progressViewHeight / 2.0);
}

- (void)setProgressValue:(float)value
{
    _value = value;
    
    [self.volumeProgressView setProgress:value animated:YES];
    
    [self showProgressView:YES];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideProgressView) object:nil];
    [self performSelector:@selector(hideProgressView) withObject:nil afterDelay:2];
}

- (void)showProgressView:(BOOL)animated
{
    self.volumeProgressView.hidden = NO;
    
    if (animated) {
        [UIView animateWithDuration:0.4
                         animations:^{
                             self.volumeProgressView.alpha = 1.f;
                         } completion:^(BOOL finished) {
                             
                         }];
    } else {
        self.volumeProgressView.alpha = 1.f;
    }
}

- (void)hideProgressView
{
    if (self.volumeProgressView.hidden == YES) {
        return;
    }
    
    [UIView animateWithDuration:0.6
                     animations:^{
                         self.volumeProgressView.alpha = 0.f;
                     } completion:^(BOOL finished) {
                         if (finished) {
                             self.volumeProgressView.hidden = YES;
                         }
                     }];

}

- (void)systemVolumeDidChanged:(NSNotification *)notification
{
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    
    NSString *string1 = [[notification userInfo] objectForKey:@"AVSystemController_AudioCategoryNotificationParameter"];
    NSString *string2 = [[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"];
    if (([string1 isEqualToString:@"Audio/Video"] || [string1 isEqualToString:@"Ringtone"])
        && [string2 isEqualToString:@"ExplicitVolumeChange"]) {
        
        [self setProgressValue:volume];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    
}

@end
