//
//  LWQRCodeScanner.m
//  LycheeClient
//
//  Created by LiYonghui on 14-6-5.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#import "LWQRCodeScanner.h"

#define UIColorWithRGB(r, g, b)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]

@interface QRCodeScanBox : UIView

- (CGRect)rectForMetadataOutputRectOfInterest;

@end

@implementation QRCodeScanBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = [UIImage imageNamed:@"LWQRCodeScanner.bundle/scan_box"];
    [image resizableImageWithCapInsets:UIEdgeInsetsMake(100, 100, 100, 100) resizingMode:UIImageResizingModeStretch];
    [image drawInRect:CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetWidth(rect))];
    
    CGRect fillRect = CGRectMake(0, CGRectGetWidth(rect), CGRectGetWidth(rect), CGRectGetHeight(rect) - CGRectGetWidth(rect));
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] CGColor]);
    CGContextFillRect(context, fillRect);
    
    NSString *text = NSLocalizedString(@"将二维码放在框内，即可自动扫描", nil);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSDictionary *options = @{NSFontAttributeName: [UIFont systemFontOfSize:13],
                              NSForegroundColorAttributeName: UIColorWithRGB(175, 175, 175),
                              NSParagraphStyleAttributeName: paragraphStyle};
    
    CGRect textRect = CGRectMake(0, CGRectGetWidth(rect), CGRectGetWidth(rect), 15);
    [text drawInRect:textRect withAttributes:options];
}

- (CGRect)rectForMetadataOutputRectOfInterest {
    CGFloat leftPaddng = 50;
    CGFloat topPadding = 50;
    CGFloat width = CGRectGetWidth(self.bounds) - leftPaddng * 2;
    CGRect rect = CGRectMake(leftPaddng, topPadding, width, width);
    return rect;
}

@end

@interface LWQRCodeScanner () <UIAlertViewDelegate> {
    
    UIView *_previewerView;
    
    QRCodeScanBox *_scanBoxView;
    
    AVCaptureVideoPreviewLayer *_videoPreviewLayer;
    AVCaptureSession *_captureSession;
    dispatch_queue_t _scannerQueue;
}

@end

@implementation LWQRCodeScanner

- (void)dealloc
{
    
}

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
    
    self.view.backgroundColor = [UIColor blackColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _previewerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _previewerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _previewerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_previewerView];
    
    _scanBoxView = [[QRCodeScanBox alloc] initWithFrame:_previewerView.bounds];
    _scanBoxView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_previewerView addSubview:_scanBoxView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startScaning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopScaning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark

- (void)playSound {
    
}



- (dispatch_queue_t)scannerQueue {
    
    if (!_scannerQueue) {
        _scannerQueue = dispatch_queue_create("QRCodeScanner", NULL);
    }
    
    return _scannerQueue;
}


- (void)startScaning {
    
    NSLog(@"scanbox : %@", _scanBoxView);
    
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[error localizedDescription]
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    
    
    
    
    [_captureSession addOutput:captureMetadataOutput];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _videoPreviewLayer.frame = _previewerView.layer.bounds;
    _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_previewerView.layer addSublayer:_videoPreviewLayer];
    
    [_previewerView bringSubviewToFront:_scanBoxView];
    
    CGRect rectOfInterest = [_videoPreviewLayer metadataOutputRectOfInterestForRect:[_scanBoxView rectForMetadataOutputRectOfInterest]];
    captureMetadataOutput.rectOfInterest = rectOfInterest;
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:[self scannerQueue]];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    [_captureSession startRunning];

}

-(void)stopScaning{

    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
    _videoPreviewLayer = nil;

}



-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {

        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            [self performSelectorOnMainThread:@selector(playSound) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(stopScaning) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(showScaningResult:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
        }
    }
    
}


- (void)showScaningResult:(NSString *)result {
    
    if ([_delegate respondsToSelector:@selector(qrcodeScanner:getResult:)]) {
        [_delegate qrcodeScanner:self getResult:result];
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
