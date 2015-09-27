//
//  ViewController.m
//  FreakingGrammariOS
//
//  Created by Juan Camilo Sacanamboy on 14/10/14.
//  Copyright (c) 2014 Peewah. All rights reserved.
//

#import "LanguagesViewController.h"
#import "MenuViewController.h"
#import <Parse/Parse.h>
#import "Pregunta.h"
#import <CustomIOSAlertView.h>

@interface LanguagesViewController ()
@end

@implementation LanguagesViewController

//Google Play Games
BOOL _silentlySigningIn;
static NSString * const kClientId = @"157934082873-s54it6ovba3igumbf60c5g7t2648qavr.apps.googleusercontent.com";


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Change text in login and logout buttons
    [_loginButton setTitle:NSLocalizedString(@"iniciaSesion", nil) forState:UIControlStateNormal];
    [_logoutButton setTitle:NSLocalizedString(@"cerrarSesion", nil) forState:UIControlStateNormal];
    
    //Assign delegate to handle the status with Google Play Games
    [GPGManager sharedInstance].statusDelegate = self;

    //Silently signing in
    _silentlySigningIn = [[GPGManager sharedInstance] signInWithClientID:kClientId silently:YES];
    
    //Refresh interfaces based on sign
    [self refreshInterfaceBasedOnSignIn];
    
    //Load languages
    self.idiomas = @[NSLocalizedString(@"idiomaEspanol", nil), NSLocalizedString(@"idiomaIngles", nil), NSLocalizedString(@"idiomaFrances", nil),NSLocalizedString(@"idiomaItaliano", nil), NSLocalizedString(@"idiomaPortugues", nil), NSLocalizedString(@"idiomaAleman", nil)];
    
    //Create colors
    self.colorEspanol = [NSArray arrayWithObjects:
                         [NSNumber numberWithInt:147],[NSNumber numberWithInt:91], [NSNumber numberWithInt:165], [NSNumber numberWithInt:1], nil];
    
    self.colorIngles = [NSArray arrayWithObjects:[NSNumber numberWithInt:233], [NSNumber numberWithInt:45], [NSNumber numberWithInt:74],[NSNumber numberWithInt:1],  nil];
    
    self.colorFrances =[NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:144], [NSNumber numberWithInt:187],[NSNumber numberWithInt:1],  nil];
    
    
    self.colorDeshabilitado  = [NSArray arrayWithObjects:[NSNumber numberWithInt:169], [NSNumber numberWithInt:169], [NSNumber numberWithInt:169],[NSNumber numberWithInt:1],  nil];
    
    self.colorLetrasDeshabilitado = [NSArray arrayWithObjects:[NSNumber numberWithInt:88], [NSNumber numberWithInt:88], [NSNumber numberWithInt:81],[NSNumber numberWithInt:1],  nil];
    
    //Table view's delegate
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//Sections
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.idiomas count];
}

//A row for each section
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


//Draw each row
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"languageCell"];
 
    
    cell.textLabel.text = [self.idiomas objectAtIndex:indexPath.section];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    //Remove cell's feedback
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //Spanish
    if(indexPath.section == 0)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:([self.colorEspanol[0] intValue]/255.0) green:([self.colorEspanol[1] intValue]/255.0) blue:([self.colorEspanol[2] intValue]/255.0) alpha:[self.colorEspanol[3] intValue]];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    //English
    else if (indexPath.section == 1)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:([self.colorIngles[0] intValue]/255.0) green:([self.colorIngles[1] intValue]/255.0) blue:([self.colorIngles[2] intValue]/255.0) alpha:[self.colorIngles[3] intValue]];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    //French
    else if (indexPath.section == 2)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:([self.colorFrances[0] intValue]/255.0) green:([self.colorFrances[1] intValue]/255.0) blue:([self.colorFrances[2] intValue]/255.0) alpha:[self.colorFrances[3] intValue]];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    //Others
    else
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:([self.colorDeshabilitado[0] intValue]/255.0) green:([self.colorDeshabilitado[1] intValue]/255.0) blue:([self.colorDeshabilitado[2] intValue]/255.0) alpha:[self.colorDeshabilitado[3] intValue]];
        cell.textLabel.textColor = [UIColor colorWithRed:([self.colorLetrasDeshabilitado[0] intValue]/255.0) green:([self.colorLetrasDeshabilitado[1] intValue]/255.0) blue:([self.colorLetrasDeshabilitado[2] intValue]/255.0) alpha:[self.colorLetrasDeshabilitado[3] intValue]];
    }
    
    
    
    return cell;
}

//Cell's heigth
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height/6;
}

//Cell's divider
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.;
}


//Check if the user select one of the available languages
-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    if([identifier isEqualToString:@"languageDetail"])
    {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        if(indexPath.section == 0)
        {
            return YES;
        }
        else if (indexPath.section == 1)
        {
            return YES;
        }
        else if (indexPath.section == 2)
        {
            return YES;
        }

    }
    
    return NO;
   
}

//Send language to the next screen
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"languageDetail"])
    {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        MenuViewController *menuVC = (MenuViewController *)segue.destinationViewController;
        
        if(indexPath.section == 0)
        {
            menuVC.language = NSLocalizedString(@"idiomaEspanol", nil);
            menuVC.backgroundColor = [UIColor colorWithRed:([self.colorEspanol[0] intValue]/255.0) green:([self.colorEspanol[1] intValue]/255.0) blue:([self.colorEspanol[2] intValue]/255.0) alpha:[self.colorEspanol[3] intValue]];
        }
        else if (indexPath.section == 1)
        {
            menuVC.language = NSLocalizedString(@"idiomaIngles", nil);
            menuVC.backgroundColor = [UIColor colorWithRed:([self.colorIngles[0] intValue]/255.0) green:([self.colorIngles[1] intValue]/255.0) blue:([self.colorIngles[2] intValue]/255.0) alpha:[self.colorIngles[3] intValue]];
        }
        else if (indexPath.section == 2)
        {
            menuVC.language = NSLocalizedString(@"idiomaFrances", nil);
            menuVC.backgroundColor = [UIColor colorWithRed:([self.colorFrances[0] intValue]/255.0) green:([self.colorFrances[1] intValue]/255.0) blue:([self.colorFrances[2] intValue]/255.0) alpha:[self.colorFrances[3] intValue]];
        }
        else
        {
            menuVC.language = nil;
            menuVC.backgroundColor = [UIColor colorWithRed:([self.colorDeshabilitado[0] intValue]/255.0) green:([self.colorDeshabilitado[1] intValue]/255.0) blue:([self.colorDeshabilitado[2] intValue]/255.0) alpha:[self.colorDeshabilitado[3] intValue]];
        }
        
    }
    
}

//It's invoked when user press the sign in button
- (IBAction)loginGame:(id)sender
{
  [[GPGManager sharedInstance] signInWithClientID:kClientId silently:NO];
}

//I'ts invoked when user press the logout button
- (IBAction)logoutGame:(id)sender
{
    [[GPGManager sharedInstance] signOut];
}

//It's invoked when the app try to signing in
-(void)didFinishGamesSignInWithError:(NSError *)error
{
    if (error)
    {
        NSLog(@"Received an error while signing in %@", [error localizedDescription]);
    } else
    {
        NSLog(@"Signed in!");
    }
    _silentlySigningIn = NO;
    [self refreshInterfaceBasedOnSignIn];
}

//It's invoked when the app try to signing out
-(void)didFinishGamesSignOutWithError:(NSError *)error
{
    if (error)
    {
        NSLog(@"Received an error while signing out %@", [error localizedDescription]);
    } else
    {
        NSLog(@"Signed out!");
    }
    _silentlySigningIn = NO;
    [self refreshInterfaceBasedOnSignIn];
}

//Refresh the interface based on sign in state
- (void)refreshInterfaceBasedOnSignIn
{
    // We'll be filling this out shortly.
    BOOL signedInToGameServices = [GPGManager sharedInstance].isSignedIn;
    self.loginButton.hidden = signedInToGameServices;
    self.logoutButton.hidden = !signedInToGameServices;
    self.loginButton.enabled = !_silentlySigningIn;
    self.logoutButton.enabled = !_silentlySigningIn;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Track screen in Analytics
    self.screenName = @"Idiomas";
}


@end
