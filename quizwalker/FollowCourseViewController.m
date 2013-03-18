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
    self.Latitude = 59.32893;
    self.Longitude = 18.06419;
    
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
    //Create queue
    self.Queue = [NSOperationQueue new];
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
    NSLog(@"ServerCall:%@ NumberOfTimes:%d ServerAnswer:'%@'",call,number,answer);
    
    if([call isEqualToString:@"test_login.php"])
    {
        if([answer isEqualToString:@"perfect\t"])
        {
            NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(searchForCourses) object:nil];
            [self.Queue addOperation:operation];
        }
    }
    if([call isEqualToString:@"test_logoff.php"])
    {
        if([answer isEqualToString:@"perfect\t"])
        {

        }
    }
    
}

- (void) searchForCourses
{
    Boolean success = YES;
    NSString *parameters = @"";
    NSString *retur = @"";

    //Find nearby courses
    parameters = [parameters stringByAppendingFormat:@"user_name=%@&longitude=%d&latitude=%d&subject=%@",self.username,[self convertDoubletoInt:self.Longitude],[self convertDoubletoInt:self.Latitude],self.subject];
    NSLog(@"%@",parameters);
    retur = [retur stringByAppendingString:[self.Connector postMessageToServerSync:@"test_get_nearby_courses.php" Parameters:parameters]];
    if(([retur isEqualToString:@"User does not exist"])||([retur isEqualToString:@"you are not logged in"])||([retur isEqualToString:@"nothing found"]))
    {
        success = NO;
        [self performSelectorOnMainThread:@selector(error) withObject:retur waitUntilDone:NO];
    }
    if(success == YES)
    {
        if([self.Courses count] > 0)
            [self.Courses removeAllObjects];
        retur = [retur substringToIndex:([retur length]-1)];
        NSArray *list = [retur componentsSeparatedByString:@";"];
        NSString *questions;
        NSString *geopoints;
        for(int counter=0; counter < [list count]; counter=counter+5)
        {
            Courses *newObject = [[Courses alloc] init];
            newObject.CourseName = [list objectAtIndex:counter];
            newObject.Subject = [list objectAtIndex:counter+1];
            newObject.Rating = [[list objectAtIndex:counter+2] floatValue];
            newObject.Difficulty = [[list objectAtIndex:counter+3] floatValue];
            newObject.NumberOfVotes = [[list objectAtIndex:counter+4] intValue];
            
            parameters = @"";
            questions = @"";
            geopoints = @"";
            parameters = [parameters stringByAppendingFormat:@"user_name=%@&course_name=%@",self.username,[list objectAtIndex:counter]];
            questions = [questions stringByAppendingString:[self.Connector postMessageToServerSync:@"test_get_questions.php" Parameters:parameters]];
            geopoints = [geopoints stringByAppendingString:[self.Connector postMessageToServerSync:@"test_get_geopoints.php" Parameters:parameters]];
            questions = [questions substringToIndex:([questions length]-1)];
            geopoints = [geopoints substringToIndex:([geopoints length]-1)];
            NSArray *questionList = [questions componentsSeparatedByString:@";"];
            NSArray *geoList = [geopoints componentsSeparatedByString:@";"];
            for(int Geocounter=0;Geocounter < [geoList count]; Geocounter=Geocounter+2)
            {
                CourseNode *newCourseNodeObject = [[CourseNode alloc] init];
                newCourseNodeObject.Latitude = [self convertIntToDouble:[[geoList objectAtIndex:Geocounter] intValue]];
                newCourseNodeObject.Longitude = [self convertIntToDouble:[[geoList objectAtIndex:Geocounter+1] intValue]];
                [newCourseNodeObject setIsQuestion:NO];
                [newObject.Nodes insertObject:newCourseNodeObject atIndex:[newObject.Nodes count]];
                
            }
            for(int Questioncounter=0;Questioncounter < [questionList count]; Questioncounter=Questioncounter+6)
            {
                Question *newQuestionObject = [[Question alloc] init];
                newQuestionObject.Question = [questionList objectAtIndex:Questioncounter+1];
                newQuestionObject.Answer1 = [questionList objectAtIndex:Questioncounter+2];
                newQuestionObject.Answer2 = [questionList objectAtIndex:Questioncounter+3];
                newQuestionObject.Answer3 = [questionList objectAtIndex:Questioncounter+4];
                newQuestionObject.CorrectAnswer = [[questionList objectAtIndex:Questioncounter+5] intValue];
                [newObject.Questions insertObject:newQuestionObject atIndex:[newObject.Questions count]];
                [[newObject.Nodes objectAtIndex:[[questionList objectAtIndex:Questioncounter] intValue]] setIsQuestion:YES];
            }
        }
    }
    //Logoff
    [self performSelectorOnMainThread:@selector(logOff) withObject:nil waitUntilDone:NO];
}

-(void)logOff
{
    [self.Connector postMessageToServerAsync:YES FileName:@"test_logoff.php" Parameters:[NSString stringWithFormat:@"user_name=%@&password=%@",self.username,self.password]];
}

-(void)error:(NSString *)value
{
    NSLog(@"%@",value);
}

- (IBAction)SearchButtonPressed:(id)sender
{
    //Get login data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.username = [[NSString alloc] initWithString:[defaults stringForKey:@"username"]];
    self.password = [[NSString alloc] initWithString:[defaults stringForKey:@"password"]];
    //Setup connection
    self.Connector = [[NetCommunication alloc] init];
    self.Connector.delegate = self;
    //Login to server
    [self.Connector postMessageToServerAsync:YES FileName:@"test_login.php" Parameters:[NSString stringWithFormat:@"user_name=%@&password=%@",self.username,self.password]];
}

-(int)convertDoubletoInt:(double)Double
{
    return (int)round(Double*1000000.0);
}

-(double)convertIntToDouble:(int)Integer
{
    return (Integer/1000000.0);
}
                  
@end
