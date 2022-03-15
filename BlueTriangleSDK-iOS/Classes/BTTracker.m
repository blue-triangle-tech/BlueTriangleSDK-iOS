//
//  BTTracker.m
//  BlueTriangle
//
//  Created by Julian Wilkison-Duran on 10/09/2020.
//  Copyright (c) 2020 Blue Triangle. All rights reserved.
//

#import "BTTracker.h"
#import "BTTimer.h"
#import "BTUploader.h"
#import "ThreadSafeMutableDictionary.h"

NSString *globalSiteID = @"siteID";
NSString *globalSessionID = @"sessionID";
NSString *globalGUID = @"GUID";
NSString *globalDeviceName = @"devicename";

@interface BTTracker()
@property (nonatomic, strong) ThreadSafeMutableDictionary *globalFields;
@property (nonatomic, strong) BTUploader *uploader;
@end

NSString * const kGlobalUserIDUserDefault = @"com.bluetriangle.kGlobalUserIDUserDefault";

@implementation BTTracker
+ (instancetype)sharedTracker {
    static dispatch_once_t onceQueue;
    static BTTracker *tracker = nil;

    dispatch_once(&onceQueue, ^{ tracker = [[self alloc] init]; });
    return tracker;
}

- (instancetype)init {
    if (self = [super init]) {
        self.globalFields = [ThreadSafeMutableDictionary new];
        self.uploader = [[BTUploader alloc] initWithURL:[NSURL URLWithString:@"https://d.btttag.com/analytics.rcv"]];
        [self setSessionID:[self randomID]];
        [self setGlobalUserID:[self getOrCreatGlobalUserID]];
        globalDeviceName = [self deviceName];
        
    }
    return self;
}

- (void)submitTimer:(BTTimer *)timer {
    if (!timer.hasEnded) {
        [timer end];
    }

    [timer setFields:_globalFields.dictionary];
    [_uploader upload:timer];
}

- (void)setSessionID:(NSString *)sessionID {
    [self setGlobalField:kSessionID stringValue:sessionID];
    globalSessionID = sessionID;
}

- (void)setGlobalUserID:(NSString *)globalUserID {
    [self setGlobalField:kGlobalUserID stringValue:globalUserID];
    globalGUID = globalUserID;
}

- (void)setSiteID:(NSString *)siteID {
    [_globalFields setObject:siteID forKey:kSiteID];
    globalSiteID = siteID;
}

- (void)setGlobalField:(NSString *)fieldName stringValue:(NSString *)stringValue {
    [_globalFields setObject:stringValue forKey:fieldName];
}

- (void)setGlobalField:(NSString *)fieldName integerValue:(NSInteger)integerValue {
    [_globalFields setObject:[NSString stringWithFormat:@"%ld", (long)integerValue] forKey:fieldName];
}

- (void)setGlobalField:(NSString *)fieldName floatValue:(float)floatValue {
    [_globalFields setObject:[NSString stringWithFormat:@"%f", floatValue] forKey:fieldName];
}

- (void)setGlobalField:(NSString *)fieldName doubleValue:(double)doubleValue {
    [_globalFields setObject:[NSString stringWithFormat:@"%f", doubleValue] forKey:fieldName];
}

- (void)setGlobalField:(NSString *)fieldName boolValue:(BOOL)boolValue {
    [_globalFields setObject:[NSNumber numberWithBool:boolValue].stringValue forKey:fieldName];
}

- (void)clearGlobalField:(NSString *)fieldName {
    [_globalFields removeObjectForKey:fieldName];
}

- (NSDictionary *)allGlobalFields {
    return _globalFields.dictionary;
}

- (NSString *)getOrCreatGlobalUserID {
    NSString *globalUserID = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalUserIDUserDefault];

    if (!globalUserID) {
        globalUserID = [self randomID];
        [[NSUserDefaults standardUserDefaults] setObject:globalUserID forKey:kGlobalUserIDUserDefault];
    }

    return globalUserID;
}

- (NSString *)randomID {
    NSInteger (^randomInt)(void) = ^NSInteger() {
        return (arc4random() % 1000) + 100;
    };

    NSString *randomID = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld", (long)randomInt(), (long)randomInt(), (long)randomInt(), (long)randomInt(), (long)randomInt(), (long)randomInt()];
    return [randomID substringToIndex:17];
}


- (void)raiseTestException:(NSString *)message {
  
    [NSException raise:@"Blue Triangle Test Exception" format:@"%@", message];

}

- (void)trackCrashes{
    
    NSSetUncaughtExceptionHandler(&bttExceptionHandler);
}

- (NSString*) deviceName
{
    struct utsname systemInfo;

    uname(&systemInfo);

    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];

    static NSDictionary* deviceNamesByCode = nil;

    if (!deviceNamesByCode) {

        deviceNamesByCode = @{@"i386"      : @"Simulator",
                              @"x86_64"    : @"Simulator",
                              @"iPod1,1"   : @"iPod%20Touch",        // (Original)
                              @"iPod2,1"   : @"iPod%20Touch",        // (Second Generation)
                              @"iPod3,1"   : @"iPod%20Touch",        // (Third Generation)
                              @"iPod4,1"   : @"iPod%20Touch",        // (Fourth Generation)
                              @"iPod7,1"   : @"iPod%20Touch",        // (6th Generation)
                              @"iPhone1,1" : @"iPhone",            // (Original)
                              @"iPhone1,2" : @"iPhone",            // (3G)
                              @"iPhone2,1" : @"iPhone",            // (3GS)
                              @"iPad1,1"   : @"iPad",              // (Original)
                              @"iPad2,1"   : @"iPad%202",            //
                              @"iPad3,1"   : @"iPad",              // (3rd Generation)
                              @"iPhone3,1" : @"iPhone%204",          // (GSM)
                              @"iPhone3,3" : @"iPhone%204",          // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" : @"iPhone%204S",         //
                              @"iPhone5,1" : @"iPhone%205",          // (model A1428, AT&T/Canada)
                              @"iPhone5,2" : @"iPhone%205",          // (model A1429, everything else)
                              @"iPad3,4"   : @"iPad",              // (4th Generation)
                              @"iPad2,5"   : @"iPad%20Mini",         // (Original)
                              @"iPhone5,3" : @"iPhone%205c",         // (model A1456, A1532 | GSM)
                              @"iPhone5,4" : @"iPhone%205c",         // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" : @"iPhone%205s",         // (model A1433, A1533 | GSM)
                              @"iPhone6,2" : @"iPhone%205s",         // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" : @"iPhone%206%20Plus",     //
                              @"iPhone7,2" : @"iPhone%206",          //
                              @"iPhone8,1" : @"iPhone%206S",         //
                              @"iPhone8,2" : @"iPhone%206S%20Plus",    //
                              @"iPhone8,4" : @"iPhone%20SE",         //
                              @"iPhone9,1" : @"iPhone%207",          //
                              @"iPhone9,3" : @"iPhone%207",          //
                              @"iPhone9,2" : @"iPhone%207%20Plus",     //
                              @"iPhone9,4" : @"iPhone%207%20Plus",     //
                              @"iPhone10,1": @"iPhone%208",          // CDMA
                              @"iPhone10,4": @"iPhone%208",          // GSM
                              @"iPhone10,2": @"iPhone%208%20Plus",     // CDMA
                              @"iPhone10,5": @"iPhone%208%20Plus",     // GSM
                              @"iPhone10,3": @"iPhone%20X",          // CDMA
                              @"iPhone10,6": @"iPhone%20X",          // GSM
                              @"iPhone11,2": @"iPhone%20XS",         //
                              @"iPhone11,4": @"iPhone%20XS%20Max",     //
                              @"iPhone11,6": @"iPhone%20XS%20Max",     // China
                              @"iPhone11,8": @"iPhone%20XR",         //
                              @"iPhone12,1": @"iPhone%2011",         //
                              @"iPhone12,3": @"iPhone%2011%20Pro",     //
                              @"iPhone12,5": @"iPhone%2011%20Pro%20Max", //

                              @"iPad4,1"   : @"iPad%20Air",          // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   : @"iPad%20Air",          // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   : @"iPad%20Mini",         // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   : @"iPad%20Mini",         // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7"   : @"iPad%20Mini",         // (3rd Generation iPad Mini - Wifi (model A1599))
                              @"iPad6,7"   : @"iPad%20Pro%20(12.9)", // iPad Pro 12.9 inches - (model A1584)
                              @"iPad6,8"   : @"iPad%20Pro%20(12.9)", // iPad Pro 12.9 inches - (model A1652)
                              @"iPad6,3"   : @"iPad%20Pro%20(9.7)",  // iPad Pro 9.7 inches - (model A1673)
                              @"iPad6,4"   : @"iPad%20Pro%20(9.7)"   // iPad Pro 9.7 inches - (models A1674 and A1675)
                              };
    }

    NSString* deviceName = [deviceNamesByCode objectForKey:code];

    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:

        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod%20Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else {
            deviceName = @"Unknown%20iOS%20Device";
        }
    }

    return deviceName;
}


static void bttExceptionHandler(NSException *exception) {
    //send hits data first
    NSString *hitTimerPageName =[NSString stringWithFormat:@"iOSCrash%@", globalDeviceName];
    BTTimer *hitsTimer = [BTTimer timerWithPageName:hitTimerPageName trafficSegment:@"iOS%20Crash"];
    [hitsTimer start];
    [hitsTimer end];
    NSString *timerPgTm = [hitsTimer getField:@"pgTm"];
    NSString *timerNStart = [hitsTimer getField:@"nst"];
    NSDictionary *trackerfields  =  @{@"sID" : globalSessionID,//session id
                                      @"gID" : globalGUID, //GUID
                                      @"siteID" : globalSiteID,//site id
    };
    [hitsTimer setFields:trackerfields];
    NSError *errorHits = nil;
    NSData *dataHits = [NSJSONSerialization dataWithJSONObject:hitsTimer.allFields options:kNilOptions error:&errorHits];
    NSURLSession *sessionHits = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //http://3.221.132.81/analytics.rcv
    //https://d.btttag.com/analytics.rcv
    NSURL *hitsEndPoint = [NSURL URLWithString:@"https://d.btttag.com/analytics.rcv"];
    NSMutableURLRequest *urlRequestHits = [[NSMutableURLRequest alloc] initWithURL:hitsEndPoint];
    [urlRequestHits setHTTPMethod:@"POST"];
    if (!errorHits) {
    
        NSURLSessionUploadTask *uploadTaskHits = [sessionHits uploadTaskWithRequest:urlRequestHits fromData:[dataHits base64EncodedDataWithOptions: 0] completionHandler:^(NSData *dataHits, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse *httpRespHits = (NSHTTPURLResponse*) response;
            NSLog(@"ERROR: %@ AND HTTP Status : %ld", error, (long)httpRespHits.statusCode);
        }];

        [uploadTaskHits resume];
    }
    
    //send errors data next with matching session and navigation start
    NSDate *now = [NSDate date];
    NSTimeInterval nowEpochSeconds = [now timeIntervalSince1970];
    long roundedNowEpochSeconds = lroundf(nowEpochSeconds);
    NSString* stringEpoch = [NSString stringWithFormat:@"%li", roundedNowEpochSeconds];
    //NSString *appName = NSBundle.mainBundle.infoDictionary[@"CFBundleDisplayName"];
    NSString *crashReportData =exception.debugDescription;
    NSArray *split = [crashReportData componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    split = [split filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    NSString *res = [split componentsJoinedByString:@"~~"];
    
    NSArray *crashReport = @[
                         @{@"msg" : res,
                           @"eTp" : @"NativeAppCrash",
                           @"eCnt" : @(1),
                           @"url" : @"iOS%20App",//this should be the app name
                           @"line" : @(1),
                           @"col" : @(1),
                           @"time" : stringEpoch,
                         }
                         ];
    //NSLog(@"crash report: %@",crashReport);
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:crashReport
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //3.221.132.81
    //NSString *siteurl = @"https://d.btttag.com/err.rcv?";
    //http://3.221.132.81/err.rcv?
    NSString *siteurl = @"https://d.btttag.com/err.rcv?";
    NSString *siteID = globalSiteID;
    NSString *nStart = timerNStart;
    NSString *pageName = [NSString stringWithFormat:@"iOSCrash-%@", globalDeviceName];
    NSString *txnName = @"iOS%20Crash";
    NSString *sessionID = globalSessionID;
    NSString *pgTm = timerPgTm;
    NSString *pageType = globalDeviceName;
    NSString *AB = @"Default";
    NSString *DCTR = @"Default";
    NSString *CmpN = @"";
    NSString *CmpM = @"iOS%20Crash";
    NSString *CmpS = @"Direct";
    NSString *os = @"iOS";
    NSString *browser = @"Native%20App";
    NSString *device = @"Mobile";
    
    NSString *enquiryurl = [NSString stringWithFormat:@"%@siteID=%@&nStart=%@&pageName=%@&txnName=%@&sessionID=%@&pgTm=%@&pageType=%@&AB=%@&DCTR=%@&CmpN=%@&CmpM=%@&CmpS=%@&os=%@&browser=%@&device=%@",siteurl,siteID,nStart,pageName,txnName,sessionID,pgTm,pageType,AB,DCTR,CmpN,CmpM,CmpS,os,browser,device];
    //NSLog(@"%@", enquiryurl);
    NSURL *errorRCV = [NSURL URLWithString:enquiryurl];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:errorRCV];
    [urlRequest setHTTPMethod:@"POST"];

    if (! jsonData) {
        NSLog(@"%s: error: %@", __func__, error.localizedDescription);
    } else {
                NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:urlRequest
                                                                           fromData:[jsonData base64EncodedDataWithOptions: 0]
                                                                  completionHandler:^(NSData *jsonData, NSURLResponse *response, NSError *error) {
                    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                    //NSLog(@"%@", data);
                    NSLog(@"ERROR: %@ AND HTTP Status : %ld", error, (long)httpResp.statusCode);
                }];
                [uploadTask resume];
                [NSThread sleepForTimeInterval:5.0f];
    }

}

@end

