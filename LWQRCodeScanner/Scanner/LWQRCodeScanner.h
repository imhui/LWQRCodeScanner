//
//  LWQRCodeScanner.h
//  LycheeClient
//
//  Created by LiYonghui on 14-6-5.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class LWQRCodeScanner;
@protocol LWQRCodeScannerDelegate <NSObject>

@optional
- (void)qrcodeScanner:(LWQRCodeScanner *)scanner getResult:(NSString *)result;

@end

@interface LWQRCodeScanner : UIViewController <AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, assign) id<LWQRCodeScannerDelegate> delegate;
@end
