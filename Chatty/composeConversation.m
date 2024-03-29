//
//  composeMessage.m
//  Chatty
//
//  Created by Omar Thanawalla on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "composeConversation.h"
#import "KeychainItemWrapper.h"
#import "AFNetworking.h"
#import "AFChattyAPIClient.h"

@implementation composeConversation
@synthesize myTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //force the keyboard to open
    [myTextView becomeFirstResponder];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)cancelButton
{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];   
}

-(IBAction)sendButton
{

    //grab the text from textView
    NSString * messageContent = myTextView.text;
    
    if([messageContent rangeOfString:@"@"].location == NSNotFound)
    {
        //alert the user that he must direct the conversation towards someone
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You must direct conversation towards someone to start a new convo."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }else
    {
        
        //submit the text to the server
        //were going to fake it and just add it to the array for the moment
        //grab credentials
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"ChattyAppLoginData" accessGroup:nil];
        NSString * email = [keychain objectForKey:(__bridge id)kSecAttrAccount];
        NSString * password = [keychain objectForKey:(__bridge id)kSecValueData];
        
        //try connecting with credentials
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                email, @"email",
                                password, @"password",
                                messageContent, @"message",
                                nil];
        
        // NSURL *url = [NSURL URLWithString:@"http://localhost:3000"];
        // AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        //
        //    [httpClient getPath:@"/my_conversation" parameters:nil
        //     //if login works, log a message to the console
        //                success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //                    NSLog(@"Response: %@", responseObject);
        //                    [self.presentingViewController dismissModalViewControllerAnimated:YES];
        //
        //                }
        //                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //                    NSLog(@"Error from postPath: %@",[error localizedDescription]);
        //                    self.dialogue.text = @"Error in sending. Try again later beautiful.";
        //                    //else you cant connect, therefore push modalview login onto the stack
        //                    //[self performSegueWithIdentifier:@"loggedIn" sender:self];
        //                }];
        //
        //
        [[AFChattyAPIClient sharedClient] postPath:@"/message" parameters:params
         //if login works, log a message to the console
                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                               NSLog(@"Response was good, here it is: %@", responseObject);
                                               [self.presentingViewController dismissModalViewControllerAnimated:YES];
                                               
                                           } 
                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               NSLog(@"Error from postPath: %@",[error localizedDescription]);
                                               //else you cant connect, therefore push modalview login onto the stack
                                           }];
    }
}
@end
