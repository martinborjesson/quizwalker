//
//  CreateCourseViewController.m
//  quizwalker
//
//  Created by Martin Börjesson on 2013-03-02.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import "CreateCourseViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CreateCourseViewController ()
    @property (nonatomic,strong) GMSMapView *mapView;
@end

@implementation CreateCourseViewController

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
	//Create Google Maps View
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
    //Create Node Array
    self.Nodes = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if([self.Time timeIntervalSinceNow] <= -8.00)
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

- (IBAction)MenuButtonPressed:(id)sender
{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Menu" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Last Node" otherButtonTitles:@"New Question", @"New Waypoint", @"Save Course", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex)
    {
        //Delete Node
        case 0:
            NSLog(@"Pressed button 'Delete Node'");
            [self deleteNode];
        break;
        //New Question
        case 1:
            NSLog(@"Pressed button 'New Question'");
            [self createNewQuestion];
        break;
        //New Waypoint
        case 2:
            NSLog(@"Pressed button 'New Waypoint'");
            [self createNewWaypoint];
        break;
        //Save Course
        case 3:
            NSLog(@"Pressed button 'Save Course'");
        break;
        //Cancel
        case 4:
            NSLog(@"Pressed button 'Cancel'");
        break;

        default:
        break;
    }
}

-(void)createNewQuestion
{
    CourseNode *node = [[CourseNode alloc] init];
    node.Latitude = self.Latitude;
    node.Longitude = self.Longitude;
    node.IsQuestion = YES;
    
    GMSMarkerOptions *newQuestion = [[GMSMarkerOptions alloc] init];
    newQuestion.icon = [UIImage imageNamed:@"pink_sign.png"];
    newQuestion.position = CLLocationCoordinate2DMake(self.Latitude,self.Longitude);
    newQuestion.groundAnchor = CGPointMake(0.5, 0.7);
    node.Pointer = [self.mapView addMarkerWithOptions:newQuestion];
    
    [self.Nodes insertObject:node atIndex:[self.Nodes count]];
    //Draw line?
    if([self.Nodes count] > 1)
    {
        [self createPolyLine];
    }
}

-(void)createNewWaypoint
{
    CourseNode *node = [[CourseNode alloc] init];
    node.Latitude = self.Latitude;
    node.Longitude = self.Longitude;
    node.IsQuestion = NO;
    
    GMSMarkerOptions *newWaypoint = [[GMSMarkerOptions alloc] init];
    newWaypoint.icon = [UIImage imageNamed:@"normal_pink.png"];
    newWaypoint.position = CLLocationCoordinate2DMake(self.Latitude,self.Longitude);
    newWaypoint.groundAnchor = CGPointMake(0.5, 0.5);
    node.Pointer = [self.mapView addMarkerWithOptions:newWaypoint];
    
    [self.Nodes insertObject:node atIndex:[self.Nodes count]];
    //Draw line?
    if([self.Nodes count] > 1)
    {
        [self createPolyLine];
    }
}

-(void)createPolyLine
{
    //Create Polyline
    GMSPolylineOptions *Line = [GMSPolylineOptions options];
    GMSMutablePath *path = [GMSMutablePath path];
    for(int counter=0;counter < [self.Nodes count];counter++)
    {
        //Line data
        [path addCoordinate:CLLocationCoordinate2DMake([[self.Nodes objectAtIndex:counter] Latitude], [[self.Nodes objectAtIndex:counter] Longitude])];
    }
    Line.path = path;
    Line.color = [[UIColor alloc]initWithRed:(80.0/255.0) green:(88.0/255.0) blue:(80.0/255.0) alpha:1];
    Line.width = 2.0;
    [self.mapView addPolylineWithOptions:Line];
}

-(void)deleteNode
{
    CourseNode *remove = [self.Nodes objectAtIndex:self.Nodes.count-1];
    [remove.Pointer remove];
    [self.Nodes removeLastObject];
    //Change Polyline
    if([self.Nodes count] > 1)
    {
        [self createPolyLine];
    }
}

@end
