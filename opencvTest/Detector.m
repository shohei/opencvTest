//
//  Detector.m
//  opencvTest
//
//  Created by shohei on 7/12/16.
//  Copyright © 2016 shohei. All rights reserved.
//

#import "Detector.h"
#import <opencv2/opencv.hpp>
#import <opencv2/highgui.hpp>

@interface Detector ()

@end

@implementation Detector

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"hello");
    // Do view setup here.
}

- (IBAction)selectImage:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.allowedFileTypes = @[@"jpg", @"png"];
    [openPanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSString *selectedFilePath = openPanel.URL.path;
            const char * filePath = [selectedFilePath cStringUsingEncoding:NSUTF8StringEncoding];
            IplImage *image = cvLoadImage(filePath, CV_LOAD_IMAGE_COLOR);
            if (image != NULL) {
                NSLog(@"Image size: %d x %d", image->width, image->height);
                cvReleaseImage(&image);
            } else {
                NSLog(@"Failed to load image. %s\n%s", filePath, cvErrorStr(cvGetErrStatus()));
            }
        }
    }];
}


@end

//#include <opencv2/opencv.hpp>
//#include <opencv2/highgui.hpp>