//
//  ViewController.m
//  ZHVolumeViewDemo
//
//  Created by linzuhan on 2018/11/23.
//  Copyright © 2018 linzuhan. All rights reserved.
//

#import "ViewController.h"
#import "ZHVolumeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZHVolumeView *volumeView = [[ZHVolumeView alloc] init];
    volumeView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 2, [UIScreen mainScreen].bounds.size.width, 2);
    volumeView.progressViewTintColor = [UIColor redColor];
    
    [self.view addSubview:volumeView];
    
    
}


@end
