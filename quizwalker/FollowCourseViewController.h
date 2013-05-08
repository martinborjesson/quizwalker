//
//  FollowCourseViewController.h
//  quizwalker
//
//  Created by Martin Börjesson on 2013-03-13.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <QuartzCore/QuartzCore.h>
#import "LoginAlertBox.h"
#import "NetCommunication.h"
#import "Courses.h"
#import "Question.h"
#import "CourseNode.h"
#import "AnswerQuestionViewController.h"

@interface FollowCourseViewController : UIViewController <CLLocationManagerDelegate,NetCommunicationDelegate,ReturnAnswerDelegate,LoginAlertBoxDelegate,UIActionSheetDelegate>

- (IBAction)SearchButtonPressed:(id)sender;

@property (strong, nonatomic) CLLocationManager *LocationManager;
@property (strong, nonatomic) id<GMSMarker> CurrentLocation;
@property (strong,nonatomic) id<GMSPolyline> MapConnector;
@property (strong, nonatomic) NSDate *Time;

@property (strong, nonatomic) NSMutableArray *Courses;
@property (nonatomic,strong) LoginAlertBox *AlertBox;

@property (nonatomic,strong) NSOperationQueue *Queue;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;

@property (nonatomic,strong) NSString *subject;
@property (nonatomic) int CurrentCourse;
@property (nonatomic) int QuestionCount;
@property (nonatomic) int Score;

@property (nonatomic) BOOL WaitForQuestion;

@property (atomic,strong) NetCommunication *Connector;

@property (nonatomic) double Latitude;
@property (nonatomic) double Longitude;

@end
