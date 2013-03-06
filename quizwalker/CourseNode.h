//
//  CourseNode.h
//  quizwalker
//
//  Created by Martin Börjesson on 2013-03-06.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface CourseNode : NSObject

@property (nonatomic) double Latitude;
@property (nonatomic) double Longitude;
@property (nonatomic) BOOL IsQuestion;
@property (strong, nonatomic) id<GMSMarker> Pointer;

@end
