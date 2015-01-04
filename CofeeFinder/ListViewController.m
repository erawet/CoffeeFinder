//
//  ListViewController.m
//  CofeeFinder
//
//  Created by Don Wettasinghe on 1/3/15.
//  Copyright (c) 2015 Don Wettasinghe. All rights reserved.
//

#import "ListViewController.h"
#import "CoffeePlace.h"
#import "DetailViewController.h"

@interface ListViewController () <CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate >

@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property NSArray *coffeePlasesArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager=[CLLocationManager new];
    self.locationManager.delegate=self;
    
    [self updateCurrentLocation];
    
}

-(void)updateCurrentLocation
{
    
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
}

-(void)findCofeePlaces:(CLLocation*)location
{
    MKLocalSearchRequest *request=[MKLocalSearchRequest new];
    request.naturalLanguageQuery=@"coffee";
    request.region=MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(.05, .05));
    
    MKLocalSearch *search=[[MKLocalSearch alloc]initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        NSArray *mapItems=response.mapItems;
        NSMutableArray *tempArray=[NSMutableArray new];
        
        for (int i=0; i<5; i++) {
            MKMapItem *mapItem=[mapItems objectAtIndex:i];
            CLLocationDistance metersAway =[mapItem.placemark.location distanceFromLocation:location];
            float milesDifference=metersAway/1609.34;
            
            CoffeePlace *coffeePlace=[[CoffeePlace alloc]init];
            coffeePlace.mapItem=mapItem;
            coffeePlace.milesDifference=milesDifference;
            
            [tempArray addObject:coffeePlace];
           // NSLog(@"%@", coffeePlace.mapItem.name);
        }
        
        NSSortDescriptor *sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:@"milesDifference" ascending:true];
        NSArray *sortedArray=[tempArray sortedArrayUsingDescriptors:@[sortDescriptor]];
        self.coffeePlasesArray= [NSArray arrayWithArray:sortedArray];
        
        [self.tableView reloadData];
        
//        for (CoffeePlace *coffeePlace in self.coffeePlasesArray) {
//            NSLog(@"%f", coffeePlace.milesDifference);
//        }
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.coffeePlasesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text=[[[self.coffeePlasesArray objectAtIndex:indexPath.row] mapItem]name];
    
    return cell;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation= locations.firstObject;
    NSLog(@"%@", self.currentLocation);
    [self.locationManager stopUpdatingLocation];
    [self findCofeePlaces:self.currentLocation];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *detailVC=[segue destinationViewController];
    detailVC.coffeePlace=[self.coffeePlasesArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    detailVC.currentLocation=self.currentLocation;
}

@end
