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
    if (self)
    {
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
    self.SaveCourseTextField.delegate = self;
    //Create queue
    self.Queue = [NSOperationQueue new];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SaveButtonPressed:(id)sender
{
    //Get data
    self.courseName = self.SaveCourseTextField.text;
    //Is data ok?
    if(([self.CourseName length] > 0)&&([self isStringBlank:self.CourseName] == NO))
    {
        //Turn off buttons
        [self.SaveButton setEnabled:NO];
        [self.SubjectPicker setUserInteractionEnabled:NO];
        //Get login data
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.username = [[NSString alloc] initWithString:[defaults stringForKey:@"username"]];
        self.password = [[NSString alloc] initWithString:[defaults stringForKey:@"password"]];
        //Setup connection
        self.Connector = [[NetCommunication alloc] init];
        self.Connector.delegate = self;
        //Login to server
        [self.Connector postMessageToServerAsync:YES FileName:@"test_login.php" Parameters:[NSString stringWithFormat:@"user_name=%@&password=%@",self.username,self.password]];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"ALERT_MSG_INPUT_ERROR_TITLE",nil)
            message: NSLocalizedString(@"INPUT_ERROR_BLANK_COURSE_NAME",nil)
            delegate:nil
            cancelButtonTitle: NSLocalizedString(@"OK_BUTTON",nil)
            otherButtonTitles:nil];
        [alert show];
    }
}

-(void)answerFromServer:(NetCommunication *)controller callToServer:(NSString *)call numberOfTimes:(int)number serverAnswer:(NSString *)answer
{
    NSLog(@"ServerCall:%@ NumberOfTimes:%d ServerAnswer:%@",call,number,answer);

    if([call isEqualToString:@"test_login.php"])
    {
        if([answer isEqualToString:@"perfect"])
        {
            NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saveCourse) object:nil];
            [self.Queue addOperation:operation];
        }
    }
    if([call isEqualToString:@"test_logoff.php"])
    {
        if([answer isEqualToString:@"perfect"])
        {
            
        }
    }
}

-(void)saveCourse
{
    int counter=0,lineOrder=0,spaceCounter,questionCounter=0;
    BOOL first=YES;
    NSString *parameters=@"";
    
    while(counter < [self.Nodes count])
    {
        [parameters stringByAppendingFormat:@"line_order=%d&user_name=%@&course_name=%@",lineOrder,self.username,self.CourseName];
        if(first == YES)
        {
            [parameters stringByAppendingFormat:@"&number_of_questions=%d",[self.Questions count]];
            first = NO;
        }
        else
        {
            [parameters stringByAppendingString:@"&number_of_questions=-1"];
        }
        spaceCounter=1;
        while((spaceCounter < 5)&&(counter < [self.Nodes count]))
        {
            if([[self.Nodes objectAtIndex:counter] isQuestion] == YES)
            {
                [parameters stringByAppendingFormat:@"&pos_%d=%d&question_%d=%@",spaceCounter,[self.Nodes count],spaceCounter,[self.Questions objectAtIndex:questionCounter]];
                [parameters stringByAppendingFormat:@"&answer_%d_1=%@",spaceCounter,[[self.Questions objectAtIndex:questionCounter] Answer1]];
                [parameters stringByAppendingFormat:@"&answer_%d_2=%@",spaceCounter,[[self.Questions objectAtIndex:questionCounter] Answer2]];
                [parameters stringByAppendingFormat:@"&answer_%d_3=%@",spaceCounter,[[self.Questions objectAtIndex:questionCounter] Answer3]];
                [parameters stringByAppendingFormat:@"&correct_%d=%d",spaceCounter,[[self.Questions objectAtIndex:questionCounter] CorrectAnswer]];
                spaceCounter++;
                questionCounter++;
            }
            counter++;
        }
        while(spaceCounter < 5)
        {
            [parameters stringByAppendingFormat:@"&pos_%d=-1&question_%d=empty&answer_%d_1=empty&answer_%d_2=empty&answer_%d_3=empty&correct_%d=0",spaceCounter,spaceCounter,spaceCounter,spaceCounter,spaceCounter,spaceCounter];
            spaceCounter++;
        }
        [self.Connector postMessageToServerSync:@"" Parameters:@""];
        lineOrder++;
    }
}

-(BOOL)isStringBlank:(NSString *)stringToCheck
{
    int numberOfBlanks = 0;
    
    for(int counter=0; counter < [stringToCheck length]; counter++)
    {
        if([stringToCheck characterAtIndex:counter] == ' ')
        {
            numberOfBlanks++;
        }
    }
    if(numberOfBlanks == [stringToCheck length])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (IBAction)CancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //End input when user press return
    [textField resignFirstResponder];
    return YES;
}

@end
