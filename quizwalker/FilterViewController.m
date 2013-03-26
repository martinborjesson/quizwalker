//
//  FilterViewController.m
//  quizwalker
//
//  Created by Martin Börjesson on 2013-03-13.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

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
    self.Subjects = @[NSLocalizedString(@"NO_FILTER",nil),NSLocalizedString(@"SUBJECT_AN",nil),NSLocalizedString(@"SUBJECT_ST",nil),NSLocalizedString(@"SUBJECT_SE",nil),NSLocalizedString(@"SUBJECT_HP",nil),NSLocalizedString(@"SUBJECT_GT",nil)];
    self.FilterPickerView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GoToFollow"])
    {
        switch(self.SubjectSelection)
        {
            //No filter
            case 0:
                [[segue destinationViewController] setSubject:@"NF"];
            break;
            //Anything
            case 1:
                [[segue destinationViewController] setSubject:@"AN"];
            break;
            //Science and technology
            case 2:
                [[segue destinationViewController] setSubject:@"ST"];
            break;
            //Sport and Entertainment
            case 3:
                [[segue destinationViewController] setSubject:@"SE"];
            break;
            //History and politics
            case 4:
                [[segue destinationViewController] setSubject:@"HP"];
            break;
            //Geography and travel
            case 5:
                [[segue destinationViewController] setSubject:@"GT"];
            break;
        }
    }
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
    self.SubjectSelection = row;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.Subjects objectAtIndex:row];
}

@end
