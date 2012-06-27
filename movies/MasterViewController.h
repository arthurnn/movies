//
//  MasterViewController.h
//  movies
//
//  Created by Arthur Neves on 12-06-14.
//  Copyright (c) 2012 arthurnn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController
<UISearchBarDelegate, NSFetchedResultsControllerDelegate, UISearchDisplayDelegate> 
{
//    __weak IBOutlet UISearchBar * searchBar;
}

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;
//@property (nonatomic, retain) NSFetchedResultsController *searchFetchedResultsController;


@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;





@end
