#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import <BlueTriangleSDK_iOS/BlueTriangle.h>
#import <BlueTriangleSDK_iOS/BTTimer.h>
#import <BlueTriangleSDK_iOS/BTTracker.h>
#import <BlueTriangleSDK_iOS/BTUploader.h>
#import <BlueTriangleSDK_iOS/BTUploadOperation.h>
#import <BlueTriangleSDK_iOS/ThreadSafeMutableDictionary.h>

FOUNDATION_EXPORT double BlueTriangleSDK_iOSVersionNumber;
FOUNDATION_EXPORT const unsigned char BlueTriangleSDK_iOSVersionString[];

