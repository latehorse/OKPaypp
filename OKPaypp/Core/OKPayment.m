//
//  OKPayment.m
//  OKPaypp
//
//  Created by yuhanle on 07/05/2018.
//
//

#import "OKPayment.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

#ifdef DEBUG
#define OKPayppLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define OKPayppLog(...)
#endif

NSString * const kOKPayOrderKey = @"order";

@interface OKPayment () <WXApiDelegate>

@end

@implementation OKPayment

#pragma mark - WXApiDelegate
- (void)onReq:(BaseReq *)req {
    
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        OKPayppError *error = nil;
        if (resp.errCode) {
            OKPayppLog(@"Wxpay result error: %@ %@", @(resp.errCode), resp.errStr);
            error = [[OKPayppError alloc] init];
            error.code = OKPayErrCancelled;
        }
        
        if (_payCompletionBlock) {
            _payCompletionBlock(resp.errStr, error);
        }
    }
}

#pragma mark - OKPayment
- (void)prepareWithSettings:(OKPayDefaultConfigurator *)payDefaultConfigurator {
    self.appScheme = payDefaultConfigurator.appScheme;
}

- (NSObject *)generatePayOrder:(NSObject *)charge {
    if ([charge isKindOfClass:[NSDictionary class]]) {
        return ((NSDictionary *)charge)[kOKPayOrderKey];
    }
    if ([charge isKindOfClass:[NSString class]]) {
        NSString *json = (NSString *)charge;
        NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (dict) {
            return dict[kOKPayOrderKey];
        }
    }
    return nil;
}

- (void)jumpToPay:(NSObject *)order result:(OKPayppCompletion)completionBlock {
    [self jumpToPay:order viewController:nil result:completionBlock];
}

- (void)jumpToPay:(NSObject *)order viewController:(nullable UIViewController*)viewController result:(OKPayppCompletion)completionBlock {
    if ([order isKindOfClass:[NSString class]]) {
        [[AlipaySDK defaultService] payOrder:(NSString *)order fromScheme:self.appScheme callback:^(NSDictionary *resultDic) {
            NSString *result = resultDic[@"result"];
            if (result.length > 0) {
                
            }else {
                
            }
        }];
    }else {
        if ([WXApi isWXAppInstalled]) {
            OKPayppLog(@"wx is not installed");
            error = [[OKPayppError alloc] init];
            error.code = OKPayErrWxNotInstalled;
            
            if (completionBlock) {
                completionBlock(nil, error);
            }
            return;
        }
        
        if ([WXApi isWXAppSupportApi]) {
            OKPayppLog(@"wxapi is not support");
            error = [[OKPayppError alloc] init];
            error.code = OKPayErrWxAppNotSupported;
            
            if (completionBlock) {
                completionBlock(nil, error);
            }
            return;
        }
        
        NSDictionary *response = (NSDictionary *)order;
        PayReq *req = [[PayReq alloc] init];
        req.partnerId = [response objectForKey:@"partnerid"];
        req.prepayId = [response objectForKey:@"prepayid"];
        req.package = [response objectForKey:@"package"];
        req.nonceStr = [response objectForKey:@"noncestr"];
        req.timeStamp = [[response objectForKey:@"timestamp"]intValue];
        req.sign = [response objectForKey:@"sign"];
        
        if ([WXApi sendReq:req]) {
            
        }
    }
}

#pragma mark - Public Method
- (BOOL)isAppInstalled {
    return [WXApi isWXAppInstalled];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    __block BOOL success = NO;
    if ([WXApi handleOpenURL:url delegate:self]) {
        success = YES;
    }else {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSString *result = resultDic[@"result"];
            NSInteger code = [resultDic[@"code"] integerValue];
            OKPayppError *error = nil;
            if (code != 0) {
                success = NO;
                error = [[OKPayppError alloc] init];
                error.code = OKPayErrCancelled;
            }else {
                success = YES;
            }
            
            if (self.payCompletionBlock) {
                self.payCompletionBlock(result, error);
            }
        }];
    }
    
    return success;
}

- (BOOL)registerApp:(NSString *)appid {
    return [WXApi registerApp:appid];
}

- (void)setDebugMode:(BOOL)enabled {
    if (enabled) {
        [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
            OKPayppLog(@"%@", log);
        }];
    }else {
        [WXApi stopLog];
    }
}

@end
