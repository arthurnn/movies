//
//  UIColor+RGB.h
//  500px iOS
//
//  Created by Ash Furrow on 12-03-28.
//  Copyright (c) 2012 500px. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RGB)

+(UIColor *)colorWithRed:(NSInteger)red andGreen:(NSInteger)green andBlue:(NSInteger)blue andAlpha:(CGFloat)alpha;
+(UIColor *)colorWithRed:(NSInteger)red andGreen:(NSInteger)green andBlue:(NSInteger)blue;

@end
