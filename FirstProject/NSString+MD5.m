//
//  NSString+MD5.m
//  FirstProject
//
//  Created by zhujian on 17/11/23.
//  Copyright © 2017年 zhujian. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)
#pragma mark - 32位 小写
+ (NSString *)MD5ForLower32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}
+ (NSString *)ForUTF:(NSString *)URL {
   NSString* imgPath = [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
   NSString* imgPath1 = [imgPath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    
    return imgPath1;
}
+ (NSString *)UTFforNormalWord:(NSString *)str {
    NSString *str1 = [str  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return str1;
}
+ (NSString *)forEncoding:(NSString *)coding {
    NSString *string = [coding stringByAddingPercentEscapesUsingEncoding:
                        NSUTF8StringEncoding];
    return string;
}


@end
