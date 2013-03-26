//
//  CreateCourseViewController.h
//  quizwalker
//
//  Created by Martin Börjesson on 2013-03-02.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "CourseNode.h"

@interface CreateCourseViewController : UIViewController <CLLocationManagerDelegate,UIActionSheetDelegate>

- (IBAction)MenuButtonPressed:(id)sender;

@property (strong, nonatomic) CLLocationManager *LocationManager;
@property (strong, nonatomic) id<GMSMarker> CurrentLocation;
@property (strong,nonatomic) id<GMSPolyline> MapConnector;
@property (strong, nonatomic) NSDate *Time;

@property (nonatomic,strong) NSMutableArray *Questions;
@property (nonatomic,strong) NSMutableArray *Nodes;

@property (nonatomic) double Latitude;
@property (nonatomic) double Longitude;

@end
