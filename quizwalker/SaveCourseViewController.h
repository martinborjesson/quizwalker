//
//  SaveCourseViewController.h
//  quizwalker
//
//  Created by Martin Börjesson on 2013-03-14.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetCommunication.h"
#import "CourseNode.h"
#import "Question.h"
#import "LoginAlertBox.h"

@interface SaveCourseViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,NetCommunicationDelegate,LoginAlertBoxDelegate>
@property (weak, nonatomic) IBOutlet UITextField *SaveCourseTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *SubjectPicker;
@property (weak, nonatomic) IBOutlet UIButton *SaveButton;
@property (weak, nonatomic) IBOutlet UIButton *CancelButton;
@property (nonatomic,strong) NSArray *Subjects;

@property (nonatomic,strong) LoginAlertBox *AlertBox;

@property (nonatomic,strong) NSMutableArray *Questions;
@property (nonatomic,strong) NSMutableArray *Nodes;
@property (nonatomic,strong) NSString *CourseName;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;

@property (nonatomic,strong) NSString *oldname;
@property (nonatomic,strong) NSString *ReturnedValue;

@property (atomic) int SubjectSelection;
@property (atomic,strong) NetCommunication *Connector;

@property (nonatomic,strong) NSOperationQueue *Queue;

- (IBAction)SaveButtonPressed:(id)sender;
- (IBAction)CancelButtonPressed:(id)sender;


@end
