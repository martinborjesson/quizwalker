//
//  SaveCourseViewController.h
//  quizwalker
//
//  Created by Martin Börjesson on 2013-03-14.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveCourseViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *SaveCourseTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *SubjectPicker;

@property (strong,nonatomic) NSArray *Subjects;

- (IBAction)SaveButtonPressed:(id)sender;
- (IBAction)CancelButtonPressed:(id)sender;


@end
