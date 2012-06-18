//
//  UIColor+RGB.m
//  500px iOS
//
//  Created by Ash Furrow on 12-03-28.
//  Copyright (c) 2012 500px. All rights reserved.
//

#import "UIColor+RGB.h"

@implementation UIColor (RGB)

+(UIColor *)colorWithRed:(NSInteger)red andGreen:(NSInteger)green andBlue:(NSInteger)blue andAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)red)/255.0 green:((float)green)/255.0 blue:((float)blue)/255.0 alpha:alpha];
}

+(UIColor *)colorWithRed:(NSInteger)red andGreen:(NSInteger)green andBlue:(NSInteger)blue
{
    return [UIColor colorWithRed:red andGreen:green andBlue:blue andAlpha:1.0f];
}

@end
