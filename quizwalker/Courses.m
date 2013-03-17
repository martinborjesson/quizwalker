//
//  Courses.m
//  quizwalker
//
//  Created by Martin Börjesson on 2013-03-17.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import "Courses.h"

@implementation Courses

- (id)init
{
    self = [super init];
    if (self)
    {
        self.Questions = [[NSMutableArray alloc] init];
        self.Nodes = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
