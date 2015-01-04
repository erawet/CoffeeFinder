//
//  DetailViewController.m
//  CofeeFinder
//
//  Created by Don Wettasinghe on 1/4/15.
//  Copyright (c) 2015 Don Wettasinghe. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.coffeePlace.mapItem.name;
    [self getPathDirections:self.currentLocation.coordinate withDestination:self.coffeePlace.mapItem.placemark.location.coordinate];
}

-(void)getPathDirections:(CLLocationCoordinate2D)source withDestination:(CLLocationCoordinate2D)destination
{
    MKPlacemark *placemaekSrc=[[MKPlacemark alloc]initWithCoordinate:source addressDictionary:nil];
    MKMapItem *mapItemSrc=[[MKMapItem alloc]initWithPlacemark:placemaekSrc];
    
    MKPlacemark *placemaekDest=[[MKPlacemark alloc]initWithCoordinate:destination addressDictionary:nil];
    MKMapItem *mapItemDest=[[MKMapItem alloc]initWithPlacemark:placemaekDest];
    
    MKDirectionsRequest *request=[[MKDirectionsRequest alloc]init];
    [request setSource:mapItemSrc];
    [request setDestination:mapItemDest];
    [request setTransportType:MKDirectionsTransportTypeWalking];
    request.requestsAlternateRoutes=NO;
    
    MKDirections *direction =[[MKDirections alloc]initWithRequest:request];
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        MKRoute *route=response.routes.lastObject;
        
        NSString *allSteps=[NSString new];
        
        for (int i=0; i<route.steps.count; i++) {
            MKRouteStep *step=[route.steps lastObject];
            NSString *newSteps=step.instructions;
            allSteps=[allSteps stringByAppendingString:newSteps];
            allSteps=[allSteps stringByAppendingString:@"\n\n"];
        }
        self.textView.text=allSteps;
        
    }];
}

@end
