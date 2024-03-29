//
//  Movie.h
//  movies
//
//  Created by Arthur Neves on 12-07-08.
//  Copyright (c) 2012 arthurnn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Movie : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * thumbnailData;
@property (nonatomic, retain) NSString * thumbnailUrl;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber * watched;
@property (nonatomic, retain) NSNumber * wanted;

@end
