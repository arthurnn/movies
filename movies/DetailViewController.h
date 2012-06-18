//
//  DetailViewController.h
//  movies
//
//  Created by Arthur Neves on 12-06-14.
//  Copyright (c) 2012 arthurnn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
