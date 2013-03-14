//
//  NetCommunication.m
//  quizwalker
//
//  Created by Martin Börjesson on 2013-03-12.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import "NetCommunication.h"

@interface NetCommunication()

@end

@implementation NetCommunication

static NSString *server = @"uberskull.ddns.info";

-(id) init
{
    self = [super init];
    if(self != nil)
    {
        self.ReturnData = [[NSMutableData alloc] init];
    }
    return self;
}

-(void) postMessageToServer:(BOOL)encrypted FileName:(NSString *)filename Parameters:(NSString *)para
{
    //if there is a connection going on just cancel it.
    [self.Connection cancel];
    
    //initialize url that is going to be fetched.
    NSString *sendTo = nil;
    if(encrypted)
    {
        sendTo = [NSString stringWithFormat:@"%@%@%@%@",@"https://",server,@"/",filename];
    }
    else
    {
        sendTo = [NSString stringWithFormat:@"%@%@%@%@",@"http://",server,@"/",filename];
    }
    NSURL *url = [NSURL URLWithString:sendTo];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    
    //set request content type we MUST set this value.
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    [request setHTTPBody:[para dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.Connection = connection;
    
    //start the connection
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
    [self.ReturnData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"DidFailWithError");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    NSString *htmlString = [[NSString alloc] initWithData:self.ReturnData encoding:NSUTF8StringEncoding];
    
    if ([self.delegate respondsToSelector:@selector(answerFromServer:serverAnswer:)])
    {
        [self.delegate answerFromServer:self serverAnswer:htmlString];
    }
}

-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"didReceiveAuthenticationChallenge");
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}

@end
