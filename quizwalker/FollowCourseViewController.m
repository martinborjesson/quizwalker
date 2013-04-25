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
    //init courses
    self.Courses = [[NSMutableArray alloc] init];
    //init course values
    self.CurrentCourse = -1;
    self.QuestionCount = 0;
    self.Score = 0;
    self.WaitForQuestion = NO;
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
    //Start following a course?
    if([self.Courses count] > 0)
    {
        //Are we currently following a course?
        if(self.CurrentCourse == -1)
        {
            //No, have the user triggered a course?
            for(int counter=0; counter < [self.Courses count]; counter++)
            {
                double lati = [[[[self.Courses objectAtIndex:counter] Nodes] objectAtIndex:0] Latitude];
                double longi = [[[[self.Courses objectAtIndex:counter] Nodes] objectAtIndex:0] Longitude];
                double checkbox = 200.0/1000000.0;
                if((self.Latitude >= (lati-checkbox))&&(self.Latitude <= (lati+checkbox))&&(self.Longitude >= (longi-checkbox))&&(self.Longitude <= (longi+checkbox)))
                {
                    //Yes, start course
                    self.CurrentCourse = counter;
                    [self startQuizwalk];
                }
            }
        }
        else
        {
            if(self.WaitForQuestion == NO)
            {
                //Next question
                NSMutableArray *nodes = [[self.Courses objectAtIndex:self.CurrentCourse] Nodes];
                int questionCounter=0,counter=0;
                while(counter < [nodes count])
                {
                    if([[nodes objectAtIndex:counter] isQuestion])
                    {
                        questionCounter++;
                        if(questionCounter == self.QuestionCount+1)
                            break;
                    }
                    counter++;
                }
                double lati = [[[[self.Courses objectAtIndex:self.CurrentCourse] Nodes] objectAtIndex:counter] Latitude];
                double longi = [[[[self.Courses objectAtIndex:self.CurrentCourse] Nodes] objectAtIndex:counter] Longitude];
                double checkbox = 200.0/1000000.0;
                if((self.Latitude >= (lati-checkbox))&&(self.Latitude <= (lati+checkbox))&&(self.Longitude >= (longi-checkbox))&&(self.Longitude <= (longi+checkbox)))
                {
                    [self performSegueWithIdentifier:@"GoToQuestion" sender:self];
                    self.WaitForQuestion = YES;
                }
            }
        }
    }
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

- (void)startQuizwalk
{
    //Start the course
    self.QuestionCount = 0;
    //Remove old markers on the map
    [self.mapView clear];
    //Recreate user marker
    GMSMarkerOptions *CurrentPosition = [[GMSMarkerOptions alloc] init];
    CurrentPosition.icon = [UIImage imageNamed:@"normal_cyan.png"];
    CurrentPosition.groundAnchor = CGPointMake(0.5, 0.5);
    CurrentPosition.position = CLLocationCoordinate2DMake(self.Latitude,self.Longitude);
    self.CurrentLocation = [self.mapView addMarkerWithOptions:CurrentPosition];
    //Get the course then draw it
    NSMutableArray *TheCourse = [[self.Courses objectAtIndex:self.CurrentCourse] Nodes];
    for(int counter=0; counter < [TheCourse count]; counter++)
    {
        GMSMarkerOptions *newObject = [[GMSMarkerOptions alloc] init];
        if([[TheCourse objectAtIndex:counter] isQuestion] == YES)
        {
            newObject.icon = [UIImage imageNamed:[self getCourseObjectColour:self.CurrentCourse Type:true]];
            newObject.groundAnchor = CGPointMake(0.5, 0.7);
        }
        else
        {
            newObject.icon = [UIImage imageNamed:[self getCourseObjectColour:self.CurrentCourse Type:false]];
            newObject.groundAnchor = CGPointMake(0.5, 0.5);
        }
        newObject.position = CLLocationCoordinate2DMake([[TheCourse objectAtIndex:counter] Latitude],[[TheCourse objectAtIndex:counter] Longitude]);
        [[TheCourse objectAtIndex:counter] setPointer:[self.mapView addMarkerWithOptions:newObject]];
    }
    //Draw line?
    if([TheCourse count] > 1)
    {
        //Yes
        if(self.MapConnector != nil)
            [self.MapConnector remove];
        [self createPolyLine];
    }
    //[self performSegueWithIdentifier:@"GoToQuestion" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GoToQuestion"])
    {
        AnswerQuestionViewController *aqvc = [segue destinationViewController];
        aqvc.delegate = self;
        Question *currentQuestion = [[[self.Courses objectAtIndex:self.CurrentCourse] Questions] objectAtIndex:self.QuestionCount];
        [aqvc setQuestion:[currentQuestion Question]];
        [aqvc setAnswer1:[currentQuestion Answer1]];
        [aqvc setAnswer2:[currentQuestion Answer2]];
        [aqvc setAnswer3:[currentQuestion Answer3]];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error!");
}

-(void)ReturnAnswer:(AnswerQuestionViewController *)controller SelectedAnswer:(int)answer
{
    Question *quest = [[[self.Courses objectAtIndex:self.CurrentCourse] Questions] objectAtIndex:self.QuestionCount];
    if([quest CorrectAnswer] == answer)
        self.Score++;
    self.QuestionCount++;
    //Are we finished?
    if(self.QuestionCount == [[[self.Courses objectAtIndex:self.CurrentCourse] Questions] count])
    {
        NSString *output = [[NSString alloc] initWithFormat:@"%@%d",NSLocalizedString(@"COURSE_FINISHED_MESSAGE", nil),self.Score];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"COURSE_FINISHED_TITLE",nil)
            message: output
            delegate:nil
            cancelButtonTitle: NSLocalizedString(@"OK_BUTTON",nil)
            otherButtonTitles:nil];
        [alert show];
        self.CurrentCourse = -1;
        self.QuestionCount = 0;
        self.score = 0;
        //Draw
        if([self.Courses count] > 0)
        {
            [self performSelectorOnMainThread:@selector(drawCourses) withObject:nil waitUntilDone:YES];
        }

    }
    [controller dismissViewControllerAnimated:YES completion:nil];
    self.WaitForQuestion = NO;
}

-(void)createPolyLine
{
    //Create Polyline
    GMSPolylineOptions *Line = [GMSPolylineOptions options];
    GMSMutablePath *path = [GMSMutablePath path];
    NSMutableArray *nodes = [[self.Courses objectAtIndex:self.CurrentCourse] Nodes];
    for(int counter=0;counter < [nodes count];counter++)
    {
        //Line data
        [path addCoordinate:CLLocationCoordinate2DMake([[nodes objectAtIndex:counter] Latitude], [[nodes objectAtIndex:counter] Longitude])];
    }
    Line.path = path;
    Line.color = [[UIColor alloc]initWithRed:(80.0/255.0) green:(88.0/255.0) blue:(80.0/255.0) alpha:1];
    Line.width = 2.0;
    self.MapConnector = [self.mapView addPolylineWithOptions:Line];
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
        else
            [self error:answer];
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
        [self performSelectorOnMainThread:@selector(error:) withObject:retur waitUntilDone:YES];
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
            [self.Courses insertObject:newObject atIndex:[self.Courses count]];
        }
    }
    //Logoff
    [self performSelectorOnMainThread:@selector(logOff) withObject:nil waitUntilDone:YES];
    //Set Current course
    self.CurrentCourse = -1;
    self.QuestionCount = 0;
    self.score = 0;
    //Draw
    if([self.Courses count] > 0)
    {
        [self performSelectorOnMainThread:@selector(drawCourses) withObject:nil waitUntilDone:YES];
    }
}

-(void)logOff
{
    [self.Connector postMessageToServerAsync:YES FileName:@"test_logoff.php" Parameters:[NSString stringWithFormat:@"user_name=%@&password=%@",self.username,self.password]];
}

-(void)drawCourses
{
    [self.mapView clear];
    //Recreate user marker
    GMSMarkerOptions *CurrentPosition = [[GMSMarkerOptions alloc] init];
    CurrentPosition.icon = [UIImage imageNamed:@"normal_cyan.png"];
    CurrentPosition.groundAnchor = CGPointMake(0.5, 0.5);
    CurrentPosition.position = CLLocationCoordinate2DMake(self.Latitude,self.Longitude);
    self.CurrentLocation = [self.mapView addMarkerWithOptions:CurrentPosition];
    //Place other markers
    for (int counter=0;counter < [self.Courses count]; counter++)
    {
        NSString *courseImage = [self getCourseObjectColour:counter Type:true];
        //Create object
        GMSMarkerOptions *newStartPoint = [[GMSMarkerOptions alloc] init];
        newStartPoint.icon = [UIImage imageNamed:courseImage];
        CourseNode *node = [[[self.Courses objectAtIndex:counter] Nodes] objectAtIndex:0];
        NSLog(@"%f %f",[node Latitude],[node Longitude]);
        newStartPoint.position = CLLocationCoordinate2DMake([node Latitude],[node Longitude]);
        newStartPoint.groundAnchor = CGPointMake(0.5, 0.7);
        [[self.Courses objectAtIndex:counter] setPointer:[self.mapView addMarkerWithOptions:newStartPoint]];
    }
}

- (NSString *)getCourseObjectColour:(int)counter Type:(BOOL)type
{
    NSString *courseColour;
    if([[[self.Courses objectAtIndex:counter] Subject] isEqualToString:@"AN"])
    {
        if(type == true)
            courseColour = @"pink_sign.png";
        else
            courseColour = @"normal_pink.png";
    }
    if([[[self.Courses objectAtIndex:counter] Subject] isEqualToString:@"ST"])
    {
        if(type == true)
            courseColour = @"green_sign.png";
        else
            courseColour = @"normal_green.png";
    }
    if([[[self.Courses objectAtIndex:counter] Subject] isEqualToString:@"SE"])
    {
        if(type == true)
            courseColour = @"purple_sign.png";
        else
            courseColour = @"normal_purple.png";
    }
    if([[[self.Courses objectAtIndex:counter] Subject] isEqualToString:@"HP"])
    {
        if(type == true)
            courseColour = @"yellow_sign.png";
        else
            courseColour = @"normal_yellow.png";
    }
    if([[[self.Courses objectAtIndex:counter] Subject] isEqualToString:@"GT"])
    {
        if(type == true)
            courseColour = @"blue_sign.png";
        else
            courseColour = @"normal_blue.png";
    }
    return courseColour;
}

-(void)error:(NSString *)value
{
    NSLog(@"%@",value);
    if(([value isEqualToString:@"User does not exist"])||([value isEqualToString:@"you are not logged in"]))
    {
        if(self.AlertBox == nil)
        {
            self.AlertBox = [[LoginAlertBox alloc] initWithTitle:NSLocalizedString(@"LOGIN_ERROR_TITLE", nil) Window:self.view.window];
            self.AlertBox.delegate = self;
        }
        else
            [self.AlertBox showWithTitle:NSLocalizedString(@"LOGIN_ERROR_TITLE",nil)];
    }
    if([value isEqualToString:@"Wrong password"])
    {
        if(self.AlertBox == nil)
        {
            self.AlertBox = [[LoginAlertBox alloc] initWithTitle:NSLocalizedString(@"INPUT_ERROR_WRONG_PASSWORD", nil) Window:self.view.window];
            self.AlertBox.delegate = self;
        }
        else
            [self.AlertBox showWithTitle:NSLocalizedString(@"INPUT_ERROR_WRONG_PASSWORD",nil)];
    }
    if([value isEqualToString:@"nothing found"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"NOTHING_FOUND_TITLE",nil)
            message: NSLocalizedString(@"NOTHING_FOUND_ERROR_MESSAGE",nil)
            delegate:nil
            cancelButtonTitle: NSLocalizedString(@"OK_BUTTON",nil)
            otherButtonTitles:nil];
        [alert show];
    }
}

-(void)UserDataUpdated:(LoginAlertBox *)alertBox username:(NSString *)user password:(NSString *)pass email:(NSString *)em
{
    self.username = user;
    self.password = pass;
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

