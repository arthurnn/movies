//
//  MovieCell.m
//  arthurnn iOS
//
//  Created by Arthur Neves on 12-05-07.
//  Copyright (c) 2012 arthurnn. All rights reserved.
//

#import "MovieCell.h"
#import "UIColor+RGB.h"
#import "Common.h"

#define kBackground  [UIColor colorWithRed:52 andGreen:52 andBlue:52 andAlpha:1]

@implementation MovieCell

@synthesize name=_name, thumbnail=_thumbnail, timestamp=_timestamp;

static CGRect avatarFrame = {{10, 5}, {50, 70}};



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        // do stuff
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIColor * whiteColor = [UIColor colorWithRed:52 andGreen:52 andBlue:52 andAlpha:1]; 
    UIColor * lightGrayColor = [UIColor colorWithRed:44 andGreen:44 andBlue:44];
    
    CGRect paperRect = self.bounds;
    drawLinearGradient(ctx, paperRect, whiteColor, lightGrayColor);
    
    
    
    
    // set lines
    // Add in color section
    
    CGContextSaveGState(ctx);
    CGContextSetLineWidth(ctx, 1.0f);
    [[[UIColor whiteColor] colorWithAlphaComponent:0.1f] setStroke];
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, 0);
    CGContextStrokePath(ctx);
    
    [[UIColor blackColor] setStroke];
    CGContextMoveToPoint(ctx, 0, self.bounds.size.height );
    CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height);
    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);
    
    
    // set date label
    CGContextSaveGState(ctx);
    [[UIColor whiteColor] set];
    
    
    CGSize size = [_name sizeWithFont:[UIFont boldSystemFontOfSize:16]];
    float y = 10;
    CGRect frame = CGRectMake(70, y, 220, size.height);
    [_name drawInRect:frame withFont:[UIFont boldSystemFontOfSize:16]];
    
    [[UIColor lightGrayColor] set];
    size = [_timestamp sizeWithFont:[UIFont systemFontOfSize:14]];
    y = 35;
    frame = CGRectMake(70, y, 220, size.height);
    [_timestamp drawInRect:frame withFont:[UIFont systemFontOfSize:14]];
    
    
    
    CGContextRestoreGState(ctx);
    
    CGContextSaveGState(ctx);
    CGContextClip(ctx);
    if (_thumbnail)
        [_thumbnail drawInRect:avatarFrame];
    CGContextRestoreGState(ctx);
    
    CGContextSetLineWidth(ctx, 2.0f);
    CGContextSetShadowWithColor(ctx, CGSizeZero, 5.0f, [UIColor blackColor].CGColor);
    CGContextStrokeRect(ctx, avatarFrame);
    
}

@end
