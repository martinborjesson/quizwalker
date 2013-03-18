//
//  FilterViewController.h
//  quizwalker
//
//  Created by Martin Börjesson on 2013-03-13.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowCourseViewController.h"

@interface FilterViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *FilterPickerView;

@property (strong,nonatomic) NSArray *Subjects;
@property (nonatomic) int SubjectSelection;

@end
