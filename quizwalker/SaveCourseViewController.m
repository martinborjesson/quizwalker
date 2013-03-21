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
        //Turn off button
        [self.SaveButton setEnabled:NO];
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
    NSLog(@"ServerCall:%@ NumberOfTimes:%d ServerAnswer:'%@'",call,number,answer);

    if([call isEqualToString:@"test_login.php"])
    {
        if([answer isEqualToString:@"perfect\t"])
        {
            NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saveCourse) object:nil];
            [self.Queue addOperation:operation];
        }
        else
            [self error:answer];
    }
    if([call isEqualToString:@"test_logoff.php"])
    {
        if([answer isEqualToString:@"perfect\t"])
        {
            //Turn on button
            [self.SaveButton setEnabled:YES];
        }
    }
    if([call isEqualToString:@"test_save_user.php"])
    {
        if([answer isEqualToString:@"New user created"]||[answer isEqualToString:@"Right password"])
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.username forKey:@"username"];
            [defaults setObject:self.password forKey:@"password"];
            [defaults setObject:self.email forKey:@"email"];
            [defaults synchronize];
            [self.Dialog hideAnimated:YES];
            //Turn on button
            [self.SaveButton setEnabled:YES];
        }
        if([answer isEqualToString:@"Wrong password"])
        {
            //Error message
            self.Dialog.title = NSLocalizedString(@"INPUT_ERROR_WRONG_PASSWORD", nil);
            [self.Dialog showOrUpdateAnimated:YES];
        }
    }
}

-(void)saveCourse
{
    int counter=0,lineOrder=0,spaceCounter,questionCounter=0;
    Boolean first = true;
    NSString *parameters = @"";
    NSString *subject = @"";
    NSString *retur=@"";
    self.oldname=@"";
    
    NSLog(@"%d",self.SubjectSelection);
    //Set subject info
    switch (self.SubjectSelection)
    {
        case 0:
            subject = [subject stringByAppendingString:@"AN"];
        break;
        case 1:
            subject = [subject stringByAppendingString:@"ST"];
        break;
        case 2:
            subject = [subject stringByAppendingString:@"SE"];
        break;
        case 3:
            subject = [subject stringByAppendingString:@"HP"];
        break;
        case 4:
            subject = [subject stringByAppendingString:@"GT"];
        break;
    }
    NSLog(@"%@",subject);
    //Store Questions on server
    while(counter < [self.Nodes count])
    {
        parameters = [parameters stringByAppendingFormat:@"line_order=%d&user_name=%@&course_name=%@",lineOrder,self.username,self.CourseName];
        if(first == true)
        {
            parameters = [parameters stringByAppendingFormat:@"&number_of_questions=%d",[self.Questions count]];
            first = false;
        }
        else
        {
            parameters = [parameters stringByAppendingString:@"&number_of_questions=-1"];
        }
        spaceCounter=1;
        while((spaceCounter < 5)&&(counter < [self.Nodes count]))
        {
            if([[self.Nodes objectAtIndex:counter] isQuestion] == YES)
            {
                parameters = [parameters stringByAppendingFormat:@"&pos_%d=%d&question_%d=%@",spaceCounter,counter,spaceCounter,[[self.Questions objectAtIndex:questionCounter] Question]];
                parameters = [parameters stringByAppendingFormat:@"&answer_%d_1=%@",spaceCounter,[[self.Questions objectAtIndex:questionCounter] Answer1]];
                parameters = [parameters stringByAppendingFormat:@"&answer_%d_2=%@",spaceCounter,[[self.Questions objectAtIndex:questionCounter] Answer2]];
                parameters = [parameters stringByAppendingFormat:@"&answer_%d_3=%@",spaceCounter,[[self.Questions objectAtIndex:questionCounter] Answer3]];
                parameters = [parameters stringByAppendingFormat:@"&correct_%d=%d",spaceCounter,[[self.Questions objectAtIndex:questionCounter] CorrectAnswer]];
                spaceCounter++;
                questionCounter++;
            }
            counter++;
        }
        while(spaceCounter < 5)
        {
            parameters = [parameters stringByAppendingFormat:@"&pos_%d=-1&question_%d=empty&answer_%d_1=empty&answer_%d_2=empty&answer_%d_3=empty&correct_%d=0",spaceCounter,spaceCounter,spaceCounter,spaceCounter,spaceCounter,spaceCounter];
            spaceCounter++;
        }
        NSLog(@"%@",parameters);
        retur = [retur stringByAppendingFormat:@"%@:",[self.Connector postMessageToServerSync:@"test_save_questions.php" Parameters:parameters]];
        if([retur isEqualToString:@"Course already exists:"])
        {
            [self performSelectorOnMainThread:@selector(CourseExistsError) withObject:nil waitUntilDone:NO];
            return;
        }
        lineOrder++;
    }
    NSLog(@"%@",retur);
    counter=0;
    lineOrder=0;
    first=YES;
    int geoCounter;
    NSString *geoparameters=@"";
    //Store geopoints on server
    while(counter < [self.Nodes count])
    {
        geoparameters = [geoparameters stringByAppendingFormat:@"line_order=%d&user_name=%@&course_name=%@&oldname=%@",lineOrder,self.username,self.CourseName,self.oldname];
        if(first == YES)
        {
            geoparameters = [geoparameters stringByAppendingFormat:@"&number_of_geopoints=%d&subject=%@",[self.Nodes count],subject];
            first = NO;
        }
        else
        {
            geoparameters = [geoparameters stringByAppendingString:@"&number_of_geopoints=-1&subject="];
        }
        geoCounter=1;
        while((geoCounter < 5)&&(counter < [self.Nodes count]))
        {
            geoparameters = [geoparameters stringByAppendingFormat:@"&latitude_%d=%d&longitude_%d=%d",geoCounter,[self convertDoubletoInt:[[self.Nodes objectAtIndex:counter]Latitude]],geoCounter,[self convertDoubletoInt:[[self.Nodes objectAtIndex:counter]Longitude]]];
            geoCounter++;
            counter++;
        }
        while(geoCounter < 5)
        {
            geoparameters = [geoparameters stringByAppendingFormat:@"&latitude_%d=-1&longitude_%d=-1",geoCounter,geoCounter];
            geoCounter++;
        }
        retur = [retur stringByAppendingFormat:@"%@:",[self.Connector postMessageToServerSync:@"test_save_geopoints.php" Parameters:geoparameters]];
        lineOrder++;
    }
    NSLog(@"%@",retur);
    self.ReturnedValue = [retur substringToIndex:[retur length]-1];
    //Logoff
    [self performSelectorOnMainThread:@selector(logOff) withObject:nil waitUntilDone:NO];
}

-(void)error:(NSString *)value
{
    NSLog(@"%@",value);
    if(([value isEqualToString:@"User does not exist"])||([value isEqualToString:@"you are not logged in"]))
    {
        self.Dialog = [CODialog dialogWithWindow:self.view.window];
        [self.Dialog resetLayout];
        self.Dialog.dialogStyle = CODialogStyleDefault;
        self.Dialog.title = NSLocalizedString(@"LOGIN_ERROR_TITLE",nil);
        [self.Dialog addTextFieldWithPlaceholder:NSLocalizedString(@"USER",nil) secure:NO];
        [self.Dialog addTextFieldWithPlaceholder:NSLocalizedString(@"PASSWORD",nil) secure:YES];
        [self.Dialog addTextFieldWithPlaceholder:NSLocalizedString(@"EMAIL",nil) secure:NO];
        [self.Dialog addButtonWithTitle:NSLocalizedString(@"OK_BUTTON", nil) target:self selector:@selector(userDataEntered)];
        [self.Dialog showOrUpdateAnimated:YES];
    }
}

-(void)userDataEntered
{
    NSString *user = [self.Dialog textForTextFieldAtIndex:0];
    NSString *pass = [self.Dialog textForTextFieldAtIndex:1];
    NSString *email = [self.Dialog textForTextFieldAtIndex:2];
    
    //Check if data is correct
    if(([user length] > 0)&&([pass length] > 0)&&([email length] > 0)&&([self isStringBlank:user] == NO)&&([self isStringBlank:pass] == NO)&&([self isStringBlank:email] == NO))
    {
        if([self isEmailStringCorrect:email] == YES)
        {
            //Send user data to server
            [self sendUserData:user Password:pass Email:email];
        }
        else
        {
            //Error message
            self.Dialog.title = NSLocalizedString(@"INPUT_ERROR_WRONG_EMAIL", nil);
            [self.Dialog showOrUpdateAnimated:YES];
        }
    }
    else
    {
        //Error message
        self.Dialog.title = NSLocalizedString(@"INPUT_ERROR_BLANK_STRING", nil);
        [self.Dialog showOrUpdateAnimated:YES];
    }
}

-(void)sendUserData:(NSString *)username Password:(NSString *)password Email:(NSString *)email
{
    NetCommunication *connector = [[NetCommunication alloc] init];
    connector.delegate = self;
    [connector postMessageToServerAsync:YES FileName:@"test_save_user.php" Parameters:[NSString stringWithFormat:@"user_name=%@&password=%@&email=%@",username,password,email]];
    self.username = [[NSString alloc] initWithString:username];
    self.password = [[NSString alloc] initWithString:password];
    self.email = [[NSString alloc] initWithString:email];
}

-(BOOL)isEmailStringCorrect:(NSString *)stringToCheck
{
    for(int counter=0; counter < [stringToCheck length]; counter++)
    {
        if([stringToCheck characterAtIndex:counter] == '@')
        {
            return YES;
        }
    }
    return NO;
}

-(void)logOff
{
    [self.Connector postMessageToServerAsync:YES FileName:@"test_logoff.php" Parameters:[NSString stringWithFormat:@"user_name=%@&password=%@",self.username,self.password]];    
}

-(void)CourseExistsError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"ALERT_MSG_INPUT_ERROR_TITLE",nil)
        message: NSLocalizedString(@"COURSE_EXISTS_ERROR_MESSAGE",nil)
        delegate:nil
        cancelButtonTitle: NSLocalizedString(@"OK_BUTTON",nil)
        otherButtonTitles:nil];
    [alert show];
    //Turn on button
    [self.SaveButton setEnabled:YES];
}

-(int)convertDoubletoInt:(double)Double
{
    return (int)round(Double*1000000.0);
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
