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

//[UIColor colorWithRed:46 andGreen:51 andBlue:64 andAlpha:1]
//#define kBackgroundColor        [UIColor colorWithRed:28 andGreen:28 andBlue:28 andAlpha:1]


//@interface MovieCell ()
//
//@property (nonatomic,retain) OHAttributedLabel * actionLabel;
//@property (nonatomic,getter=isActionHighlighted) BOOL isActionHighlighted;
//
//@end


@implementation MovieCell

//@synthesize isActionHighlighted=_isActionHighlighted, isUserAvatarHighlighted=_isUserAvatarHighlighted;
//@synthesize uiAdpter=_uiAdpter, avatar=_avatar, actionImage=_actionImage,actionLabel=_actionLabel, read=_read;
@synthesize name=_name, thumbnail=_thumbnail, timestamp=_timestamp;

// max width for cell: 330
static CGRect avatarFrame = {{10, 5}, {50, 70}};
//static CGRect actionImageFrame = {{270, 11}, {48, 48}};

//static CGRect actionLabelFrame = {{70, 6}, {194, 70}};
//static UIImage *_defaultUserPic = nil;
//static UIImage *_defaultPhotoPic = nil;
//static UIImage *shadowImage = nil;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {

//        if (!_defaultUserPic)
//            _defaultUserPic = [UIImage imageNamed:@"defaultUserpic"];
//        
//        if(!_defaultPhotoPic)
//            _defaultPhotoPic = [UIImage imageNamed:@"default_photo"];
//        
//        if (!shadowImage)
//            shadowImage = [UIImage imageNamed:@"comment_avatar_shadow"];
        
//        if (nil == self.actionLabel)
//        {
//            self.actionLabel = [[OHAttributedLabel alloc] initWithFrame: actionLabelFrame ];
//            self.actionLabel.backgroundColor = [UIColor clearColor];
//            self.actionLabel.numberOfLines = 2;
//            [self addSubview:self.actionLabel];
//        }
            
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//-(void)setUiAdpter:(id<UINotificationAdapter>)adpter
//{
//    _uiAdpter = adpter;
//
//    NSString * text = [_uiAdpter notificationLabel];
//    NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:text];
//    [attrStr setFont:[UIFont systemFontOfSize:14]];
//    [attrStr setTextColor:[UIColor whiteColor]];
//    if([_uiAdpter respondsToSelector:@selector(rangesForBold)] && [_uiAdpter rangesForBold])
//        for (NSValue *v in [_uiAdpter rangesForBold]) {
//            [attrStr setTextBold:YES range:[v rangeValue]];
//        }
//
//    self.actionLabel.attributedText = attrStr;
//    
//    [self setNeedsDisplay];
//}

//-(void)layoutSubviews
//{
//    //reset the frame in order to sizeToFit
//    self.actionLabel.frame = actionLabelFrame;
//    [self.actionLabel sizeToFit];
//
//    
//    CGSize fromSize = [[_uiAdpter timeLabel] sizeWithFont:[UIFont systemFontOfSize:14]];
//    float yPos = (70 - self.actionLabel.frame.size.height - fromSize.height) / 2; 
//    CGRect frame = self.actionLabel.frame;
//    frame.origin.y = round(yPos);
//    self.actionLabel.frame = frame;
//}


-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    // clean context
//    CGContextClearRect( ctx , self.bounds);

    
    // set backgroud
//    CGContextSaveGState(ctx);
//    [kBackground set];
//    CGContextFillRect(ctx, self.bounds);
//    CGContextRestoreGState(ctx);
// 52 -- 44
    UIColor * whiteColor = [UIColor colorWithRed:52 andGreen:52 andBlue:52 andAlpha:1]; 
    UIColor * lightGrayColor = [UIColor colorWithRed:44 andGreen:44 andBlue:44];
    
    CGRect paperRect = self.bounds;
    drawLinearGradient(ctx, paperRect, whiteColor, lightGrayColor);
    
    
    
    
    // set lines
    // Add in color section
//    CGColorRef separatorColor = [UIColor colorWithRed:208.0/255.0 green:208.0/255.0 
//                                                 blue:208.0/255.0 alpha:1.0].CGColor;
//    
//    // Add at bottom
//    CGPoint startPoint = CGPointMake(paperRect.origin.x, 
//                                     paperRect.origin.y + paperRect.size.height - 1);
//    CGPoint endPoint = CGPointMake(paperRect.origin.x + paperRect.size.width - 1, 
//                                   paperRect.origin.y + paperRect.size.height - 1);
//    draw1PxStroke(ctx, startPoint, endPoint, separatorColor);
    
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
//    float yPos = (self.bounds.size.height - fromSize.height) / 2; 
    float y = 10;
    CGRect frame = CGRectMake(70, y, 220, size.height);
    [_name drawInRect:frame withFont:[UIFont boldSystemFontOfSize:16]];
    
    [[UIColor lightGrayColor] set];
    size = [_timestamp sizeWithFont:[UIFont systemFontOfSize:14]];
//    float yPos = (self.bounds.size.height - fromSize.height) / 2; 
    y = 35;
    frame = CGRectMake(70, y, 220, size.height);
    [_timestamp drawInRect:frame withFont:[UIFont systemFontOfSize:14]];
    
    
    
    CGContextRestoreGState(ctx);
    

    
    
    
    
    // left avatar
//    [shadowImage drawInRect:CGRectMake(avatarFrame.origin.x - 4, avatarFrame.origin.y - 4, avatarFrame.size.width + 8, avatarFrame.size.height + 8)];
    CGContextSaveGState(ctx);
    addRoundedRectToPath(ctx, avatarFrame, 1, 1);
    CGContextClip(ctx);
    if (_thumbnail)
        [_thumbnail drawInRect:avatarFrame];
//    else
//        [_defaultUserPic drawInRect:avatarFrame];
    CGContextRestoreGState(ctx);
    
    CGContextSetLineWidth(ctx, 2.0f);
    CGContextSetShadowWithColor(ctx, CGSizeZero, 5.0f, [UIColor blackColor].CGColor);
//    ￼CGContextFillRect(ctx, avatarFrame);
    CGContextStrokeRect(ctx, avatarFrame);
    
    
//    if (self.isUserAvatarHighlighted)
//    {
//        CGContextSaveGState(ctx);
//        addRoundedRectToPath(ctx, avatarFrame, 5, 5);
//        CGContextClip(ctx);
//        [[UIColor colorWithWhite:0.0f alpha:0.6f] set];
//        CGContextFillRect(ctx, avatarFrame);
//        CGContextRestoreGState(ctx);
//    } 
    
}



inline static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

//
//#pragma mark - Button-Pressing Methods
//-(void)setIsActionHighlighted:(BOOL)isActionHighlighted
//{
//    BOOL needsDisplay = isActionHighlighted != self.isActionHighlighted;
//    _isActionHighlighted = isActionHighlighted;
//    if (needsDisplay)
//        [self setNeedsDisplay];
//}
//
//-(void)setIsUserAvatarHighlighted:(BOOL)isUserAvatarHighlighted
//{
//    BOOL needsDisplay = isUserAvatarHighlighted != self.isUserAvatarHighlighted;
//    _isUserAvatarHighlighted = isUserAvatarHighlighted;
//    if (needsDisplay)
//        [self setNeedsDisplay];
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//
//    if (touches.count == 1)
//    {
//        UITouch *touch = [touches anyObject];
//        
//        if (CGRectContainsPoint(actionImageFrame, [touch locationInView:self]))
//        {
//            self.isActionHighlighted = YES;
//        }
//        
//        if (CGRectContainsPoint(avatarFrame, [touch locationInView:self]))
//        {
//            self.isUserAvatarHighlighted = YES;
//        }
//    }
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesMoved:touches withEvent:event];
//    
//    self.isActionHighlighted = NO;
//    self.isUserAvatarHighlighted = NO;
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesEnded:touches withEvent:event];
//    
//    UITouch *touch = [touches anyObject];
//    CGPoint pointInSelf = [touch locationInView:self];
//    
////    if (self.isUserNameHighlighted)
////    {        
//        BOOL pointContainedInUserNameFrame = CGRectContainsPoint(actionImageFrame, pointInSelf);
//        
//        if (pointContainedInUserNameFrame)
//        {
//            if([self.uiAdpter respondsToSelector:@selector(pushActionViews:)])
//                [self.uiAdpter pushActionViews:AppDelegate.galleryViewController.navigationController];
//            
//            self.isActionHighlighted = NO;
//        }
////    }
//    
//    BOOL pointContainedInUserAvatarFrame = CGRectContainsPoint(CGRectInset(avatarFrame, -15, -15), pointInSelf);
//    if (pointContainedInUserAvatarFrame)
//    {
//        if([self.uiAdpter respondsToSelector:@selector(pushThumbnailViews:)])
//            [self.uiAdpter pushThumbnailViews:AppDelegate.galleryViewController.navigationController];
//
//        self.isUserAvatarHighlighted = NO;
//    }
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesCancelled:touches withEvent:event];
//    
//    self.isActionHighlighted = NO;
//    self.isUserAvatarHighlighted = NO;
//}



@end
