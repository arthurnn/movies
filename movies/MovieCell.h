//
//  MovieCell.h
//  arthurnn iOS
//
//  Created by Arthur Neves on 12-05-07.
//  Copyright (c) 2012 arthurnn. All rights reserved.
//

#import <UIKit/UIKit.h>


//@protocol PXNotificationCellDelegate <NSObject>
//
//-(void)didTapThumbnail:(UITableViewCell*)cell;
//
//@end


@interface MovieCell : UITableViewCell
{
}

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * timestamp;
@property (nonatomic, strong) UIImage * thumbnail;

           
@end
