//
//  DemoViewController.m
//  LWQRCodeScanner
//
//  Created by LiYonghui on 14-9-2.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#import "DemoViewController.h"
#import "LWQRCodeScanner.h"

@interface DemoViewController () <LWQRCodeScannerDelegate>

@end

@implementation DemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 50, 50);
    button.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [button setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showQRCodeScanner) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showQRCodeScanner {
    
    LWQRCodeScanner *scanner = [[LWQRCodeScanner alloc] init];
    scanner.delegate = self;
    [self.navigationController pushViewController:scanner animated:YES];
    
}

- (void)qrcodeScanner:(LWQRCodeScanner *)scanner getResult:(NSString *)result {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    [alert show];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
