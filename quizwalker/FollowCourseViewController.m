//
//  FollowCourseViewController.m
//  quizwalker
//
//  Created by Martin Börjesson on 2013-03-13.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import "FollowCourseViewController.h"

@interface FollowCourseViewController ()
   @property (nonatomic,strong) GMSMapView *mapView;
@end

@implementation FollowCourseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:59.32893
                                                            longitude:18.06419
                                                                 zoom:16];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.view = self.mapView;
    
    //Start GPS
    self.LocationManager = [[CLLocationManager alloc] init];
    [self.LocationManager setDelegate:self];
    [self.LocationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.LocationManager startUpdatingLocation];
    //Load marker
    GMSMarkerOptions *CurrentPosition = [[GMSMarkerOptions alloc] init];
    CurrentPosition.icon = [UIImage imageNamed:@"normal_cyan.png"];
    CurrentPosition.groundAnchor = CGPointMake(0.5, 0.5);
    self.CurrentLocation = [self.mapView addMarkerWithOptions:CurrentPosition];
    //Set time
    self.Time = [NSDate date];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //Get last location
    CLLocationCoordinate2D loc = [locations.lastObject coordinate];
    //Store coordinates
    self.Latitude = loc.latitude;
    self.Longitude = loc.longitude;
    //update marker position
    self.CurrentLocation.position = CLLocationCoordinate2DMake(loc.latitude,loc.longitude);
    if([self.Time timeIntervalSinceNow] <= -4.00)
    {
        [self updatePosition];
    }
}

- (void)updatePosition
{
    //Update view area
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.5f];
    [self.mapView animateToLocation:self.CurrentLocation.position];
    [self.mapView animateToBearing:0];
    [self.mapView animateToViewingAngle:0];
    [CATransaction commit];
    //Reset time
    self.Time = [NSDate date];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error!");
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.LocationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.LocationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)answerFromServer:(NetCommunication *)controller callToServer:(NSString *)call numberOfTimes:(int)number serverAnswer:(NSString *)answer
{
    
}

- (IBAction)SearchButtonPressed:(id)sender
{

}

@end
