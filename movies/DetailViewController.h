//
//  DetailViewController.h
//  movies
//
//  Created by Arthur Neves on 12-06-14.
//  Copyright (c) 2012 arthurnn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController 
<UISplitViewControllerDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *poster;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

- (IBAction)watchedTap:(id)sender;

@end
