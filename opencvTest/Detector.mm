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

void carryOn();

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"hello");
    // Do view setup here.
    system("pwd");
    carryOn();
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

#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;

void carryOn(){
    //hack for moving to resource directory. this works like a charm!
    //http://stackoverflow.com/questions/516200/relative-paths-not-working-in-xcode-c
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef resourcesURL = CFBundleCopyResourcesDirectoryURL(mainBundle);
    char path[PATH_MAX];
    if (!CFURLGetFileSystemRepresentation(resourcesURL, TRUE, (UInt8 *)path, PATH_MAX))
    {
        // error!
    }
    CFRelease(resourcesURL);
    
    chdir(path);
    std::cout << "Current Path: " << path << std::endl;
    //end of hack
    
    Mat src_image = imread("./original.png");
    Mat temp_image = imread("./sign.png");
    Mat result;
    matchTemplate(src_image,temp_image,result,TM_CCORR_NORMED);
    cv::Point maxPt;
    minMaxLoc(result,0,0,0,&maxPt);
    rectangle(src_image, maxPt, cv::Point(maxPt.x + temp_image.cols, maxPt.y
                                      + temp_image.rows), Scalar(0,255,255),2,8,0);
    namedWindow("matching display");
    imshow("matching display",src_image);
    waitKey(0);
    destroyAllWindows();
}
