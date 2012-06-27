//
//  DetailViewController.m
//  movies
//
//  Created by Arthur Neves on 12-06-14.
//  Copyright (c) 2012 arthurnn. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
{
    double _headerImageYOffset;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize scrollView = _scrollView;
@synthesize poster = _poster;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    CGRect f = self.view.frame;
    f.size.height = 1000;
    self.view.frame = f;
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timestamp"] description];
        self.poster.image = [UIImage imageWithData:[self.detailItem valueForKey:@"thumbnailData"]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    // Create an empty table header view with small bottom border view
    UIView *tableHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, 220.0)];
    UIView *blackBorderView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 219.0, self.view.frame.size.width, 1.0)];
    blackBorderView.backgroundColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.8];
    [tableHeaderView addSubview: blackBorderView];
        
//    _tableView.tableHeaderView = tableHeaderView;
    [self.scrollView addSubview:tableHeaderView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationController.navigationBar.translucent = YES;
//        self.navigationController.navigationBar.hidden = YES;
    });
    
    
    
    _headerImageYOffset = -50.0;
    CGRect headerImageFrame = self.poster.frame;
    headerImageFrame.origin.y = _headerImageYOffset;
    self.poster.frame = headerImageFrame;
    
    
    [self.scrollView setContentSize:CGSizeMake(320, 600)];	
}

- (void)viewDidUnload
{
    [self setPoster:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
		
- (IBAction)watchedTap:(id)sender
{
//    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:[DELEGATE managedObjectContext]];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:[DELEGATE managedObjectContext]];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timestamp"];
    
    [newManagedObject setValue:[self.detailItem valueForKey:@"name"] forKey:@"name"];
    [newManagedObject setValue:[self.detailItem valueForKey:@"thumbnailData"] forKey:@"thumbnailData"];
    
    [DELEGATE saveContext];
    
    
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGRect headerImageFrame = self.poster.frame;
    
    if (scrollOffset < 0) {
        // Adjust image proportionally
        headerImageFrame.origin.y = _headerImageYOffset - ((scrollOffset / 3));
    } else {
        // We're scrolling up, return to normal behavior
        headerImageFrame.origin.y = _headerImageYOffset - scrollOffset;
    }
    self.poster.frame = headerImageFrame;
}

@end
