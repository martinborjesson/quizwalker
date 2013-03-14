//
//  SaveCourseViewController.m
//  quizwalker
//
//  Created by Martin Börjesson on 2013-03-14.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import "SaveCourseViewController.h"

@interface SaveCourseViewController ()

@end

@implementation SaveCourseViewController

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
    self.Subjects = @[NSLocalizedString(@"SUBJECT_AN",nil),NSLocalizedString(@"SUBJECT_ST",nil),NSLocalizedString(@"SUBJECT_SE",nil),NSLocalizedString(@"SUBJECT_HP",nil),NSLocalizedString(@"SUBJECT_GT",nil)];
    self.SubjectPicker.delegate = self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.Subjects count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"didSelectRow:%d",row);
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.Subjects objectAtIndex:row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SaveButtonPressed:(id)sender
{

}

- (IBAction)CancelButtonPressed:(id)sender
{

}

@end
