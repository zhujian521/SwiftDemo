//
//  UIButton+btn.m
//  
//
//  Created by zhujian on 17/11/23.
//
//

#import "UIButton+btn.h"
@implementation UIButton (btn)
- (void)setUpNormalAndSelect {
    [self setBackgroundImage:[UIImage imageNamed:@"chongzhi_sel"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"chongzhi_nor"] forState:UIControlStateDisabled];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
    
}

@end
