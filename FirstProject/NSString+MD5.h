//
//  NSString+MD5.h
//  FirstProject
//
//  Created by zhujian on 17/11/23.
//  Copyright © 2017年 zhujian. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSString (MD5)
+ (NSString *)MD5ForLower32Bate:(NSString *)str;
+ (NSString *)ForUTF:(NSString *)URL;
+ (NSString *)UTFforNormalWord:(NSString *)str;
+ (NSString *)forEncoding:(NSString *)coding;
@end
