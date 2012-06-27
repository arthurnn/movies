//
//  MasterViewController.m
//  movies
//
//  Created by Arthur Neves on 12-06-14.
//  Copyright (c) 2012 arthurnn. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "Movie.h"
#import "AppDelegate.h"
#import "MovieCell.h"
#import "UIColor+RGB.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@interface MasterViewController ()
{
    NSArray * searchResults;
}
@property (nonatomic) BOOL searchIsActive;
- (void)configureCell:(MovieCell *)cell atIndexPath:(NSIndexPath *)indexPath withTable:(UITableView *)tableView;

@end

@implementation MasterViewController

@synthesize searchDisplayController;
@synthesize searchBar;
@synthesize detailViewController = _detailViewController;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize searchIsActive;

//@synthesize searchFetchedResultsController = _searchFetchedResultsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Movies", @"Movies");
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:15 andGreen:15 andBlue:15 andAlpha:0.5f];
    

    self.searchBar.tintColor = [UIColor colorWithRed:15 andGreen:15 andBlue:15 andAlpha:0.9f];
    
//    NSFetchRequest *fetchRequest =  self.fetchedResultsController.fetchRequest;
//    
//    
//    self.searchFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Search"];
//    self.searchFetchedResultsController.delegate = self;
//    
//    searchBar.tintColor = [UIColor colorWithRed:15 andGreen:15 andBlue:15 andAlpha:0.5f];
    
//    UISearchBar *tempSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, -44, self.view.frame.size.width, 44)];
////    tempSearchBar.delegate = self;
//    tempSearchBar.autoresizingMask = UIViewAutoresizingNone;
//    searchBar = tempSearchBar;
//    searchBar.placeholder = @"Search";
//    [self.view addSubview:tempSearchBar]; 
    
}

- (void)viewDidUnload
{
    [self setSearchDisplayController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}



- (CGImageRef) resizeImage:(CGImageRef)originalImage
{
    CGColorSpaceRef colorspace = CGImageGetColorSpace(originalImage);
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 320,
                                                 480,
                                                 CGImageGetBitsPerComponent(originalImage),
                                                 CGImageGetBytesPerRow(originalImage)/CGImageGetWidth(originalImage)*320,
                                                 colorspace,
                                                 CGImageGetAlphaInfo(originalImage));
    
//    if(context == NULL)
//        return nil;
    
    // Removed clipping code
    
    // draw image to context
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), originalImage);
    
    // extract resulting image from context
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    
    return imgRef;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    //    return [[[self fetchedResultsControllerForTableView:tableView] sections] count];
    //return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(tableView == self.tableView){
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];    
        //    id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsControllerForTableView:tableView] sections] objectAtIndex:section];    
        return [sectionInfo numberOfObjects];
    }else{
        return [searchResults count];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MovieCell";
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }

    [self configureCell:cell atIndexPath:indexPath withTable:tableView];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = nil;
    if(tableView==self.tableView){
        object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    }else{
        object = [searchResults objectAtIndex:indexPath.row];    
    }
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.detailViewController) {
	        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil];
	    }
        self.detailViewController.detailItem = object;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } else {
        self.detailViewController.detailItem = object;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - Fetched results controller

//- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView
//{
//    return tableView == self.tableView ? self.fetchedResultsController : self.searchFetchedResultsController;
//}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    __fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    __fetchedResultsController.delegate = self;
    //self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller 
{
    if ([self searchIsActive]) {
        [[[self searchDisplayController] searchResultsTableView] beginUpdates];
    }
    else  {
        [self.tableView beginUpdates];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
//    UITableView *tableView = self.tableView;
    UITableView *tableView = controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;

    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
        {
//            UITableViewCell *cs = [tableView cellForRowAtIndexPath:indexPath];
            MovieCell *c = (MovieCell *)[tableView cellForRowAtIndexPath:indexPath];
            [self configureCell:c atIndexPath:indexPath withTable:tableView];
            break;
        }
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
    if ([self searchIsActive]) {
        [[[self searchDisplayController] searchResultsTableView] endUpdates];
    }
    else  {
        [self.tableView endUpdates];
    }
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(MovieCell *)cell atIndexPath:(NSIndexPath *)indexPath withTable:(UITableView *)tableView
{
//    __block Movie *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    __block Movie *object = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
    
    __block id object;
    if(tableView!=self.tableView){
        if([searchResults count])
            object = [searchResults objectAtIndex:indexPath.row];
    }else{
        object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    if(!object)
        return;
    
    cell.timestamp = [[object valueForKey:@"timestamp"] description];
    cell.name = [object valueForKey:@"name"];
    cell.thumbnail = nil;
    cell.selectedBackgroundView = [[UIView alloc] init];    
//    cell.selectedBackgroundView.backgroundColor = [UIColor grayColor];
    NSData *thumnailData = [object valueForKey:@"thumbnailData"];
    if(thumnailData){
        cell.thumbnail = [UIImage imageWithData:thumnailData];
        NSLog(@"Image size: %@", NSStringFromCGSize(cell.thumbnail.size));
    }else{
        dispatch_async(kBgQueue, ^{
            NSString * t_url = [object valueForKey:@"thumbnailUrl"];
            if(t_url){
                NSLog(@"thumbnail %@",t_url);
                NSData *fetchedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:t_url]];
                CGImageRef r = [self resizeImage:[UIImage imageWithData:fetchedData].CGImage];
                fetchedData = UIImageJPEGRepresentation([UIImage imageWithCGImage:r], 1);
                cell.thumbnail = [UIImage imageWithData:fetchedData];
                [object setValue:fetchedData forKey:@"thumbnailData"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell setNeedsDisplay];
                });
            }

        });
        
    }
    [cell setNeedsDisplay];
            
    
}

//#pragma mark Content Filtering
//- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scope
//{
//    // update the filter, in this case just blow away the FRC and let lazy evaluation create another with the relevant search info
//    self.searchFetchedResultsController.delegate = nil;
//    self.searchFetchedResultsController = nil;
//    // if you care about the scope save off the index to be used by the serchFetchedResultsController
//    //self.savedScopeButtonIndex = scope;
//}
//
//
//#pragma mark -
//#pragma mark Search Bar 
//- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView;
//{
//    // search is done so get rid of the search FRC and reclaim memory
//    self.searchFetchedResultsController.delegate = nil;
//    self.searchFetchedResultsController = nil;
//}
//
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    [self filterContentForSearchText:searchString 
//                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
//    
//    // Return YES to cause the search result table view to be reloaded.
//    return YES;
//}


//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
//{
//    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] 
//                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
//    
//    // Return YES to cause the search result table view to be reloaded.
//    return YES;
//}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if([searchText length]> 3)
    {
        searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSLog(@"search: %@", searchText);
        __block NSString * url = [NSString stringWithFormat:@"http://sg.media-imdb.com/suggests/%c/%@.json", [searchText characterAtIndex:0], searchText];
        
        
        dispatch_async(kBgQueue, ^{
            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"GET"];
            
            NSHTTPURLResponse *response;
            NSError *error = nil;
            //        [UIApplication pushNetworkActivity];
            NSData *moviesResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            //        [UIApplication popNetworkActivity];
            
//            NSString *fetchedString = [[NSString alloc] initWithData:moviesResponse encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",fetchedString);
            
            [self performSelectorOnMainThread:@selector(fetchedData:) 
                                   withObject:moviesResponse waitUntilDone:YES];
        });
    }
      
    
}

- (void)fetchedData:(NSData *)responseJSONP {
    
    NSMutableString *resultString = [[NSMutableString alloc] initWithData:responseJSONP encoding:NSUTF8StringEncoding];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"\\w+\\$\\w+?\\((\\{.*\\})\\)"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    
    [regex replaceMatchesInString:resultString
                          options:0
                            range:NSMakeRange(0, [resultString length])
                     withTemplate:@"$1"];
    
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:[resultString dataUsingEncoding: NSUTF8StringEncoding]                          options:kNilOptions 
                          error:&error];
    
    if (error) {
//        NSLog(@" %@ error: %@", resultString, error);
        return;
    }
    NSArray* movies = [json objectForKey:@"d"];
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[movies count]];
    for (id o in movies) {
        NSString * mid = [o objectForKey:@"id"];
        if([[mid substringToIndex:2] isEqualToString:@"tt"])
        {
            NSMutableDictionary * m = [NSMutableDictionary dictionary];
            [m setValue:[o objectForKey:@"l"] forKey:@"name"];
            [m setValue:[[o objectForKey:@"i"] objectAtIndex:0] forKey:@"thumbnailUrl"];
            [tmp addObject:m];
        }

    }
    
    if([tmp count]){
        searchResults = [NSArray arrayWithArray:tmp];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
        
//    NSLog(@"movies: %@", movies);
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:nil];
    
    return YES;
}

/*
 - (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
 {
 return YES;
 }
 */

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    [self setSearchIsActive:YES];
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchDisplayController.searchResultsTableView.backgroundColor = nil;
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor colorWithRed:15 andGreen:15 andBlue:15 andAlpha:0.5f];
    
    searchResults = nil;
    return;
}

//- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller 
//{
//    NSFetchRequest *aRequest = [[self fetchedResultsController] fetchRequest];
//    
//    [aRequest setPredicate:nil];
//    
//    NSError *error = nil;
//    if (![[self fetchedResultsController] performFetch:&error]) {
//        // Handle error
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }  
//    
//    [self setSearchIsActive:NO];
//    return;
//}
@end
