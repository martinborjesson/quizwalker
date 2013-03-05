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

@interface CreateCourseViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *LocationManager;
@property (strong, nonatomic) id<GMSMarker> CurrentLocation;
@property (strong, nonatomic) NSDate *Time;

@end
