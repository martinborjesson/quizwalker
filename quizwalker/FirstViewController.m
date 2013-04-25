//
//  ViewController.m
//  quizwalker
//
//  Created by Martin Börjesson on 2013-02-24.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"username"] == nil)
    {
        self.AlertBox = [[LoginAlertBox alloc] initWithTitle:NSLocalizedString(@"NEW_USER_TITLE", nil) Window:self.view.window];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
