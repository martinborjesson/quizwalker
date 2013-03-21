//
//  Courses.h
//  quizwalker
//
//  Created by Martin Börjesson on 2013-03-17.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface Courses : NSObject

@property (nonatomic,strong) NSString *CourseName;
@property (nonatomic,strong) NSString *Subject;
@property (nonatomic) float Rating;
@property (nonatomic) float Difficulty;
@property (nonatomic) int   NumberOfVotes;
@property (strong, nonatomic) id<GMSMarker> Pointer;

@property (nonatomic,strong) NSMutableArray *Questions;
@property (nonatomic,strong) NSMutableArray *Nodes;

@end
