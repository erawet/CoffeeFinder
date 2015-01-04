//
//  CoffeePlace.h
//  CofeeFinder
//
//  Created by Don Wettasinghe on 1/3/15.
//  Copyright (c) 2015 Don Wettasinghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CoffeePlace : NSObject

@property (strong, nonatomic) MKMapItem *mapItem;
@property float milesDifference;


@end
