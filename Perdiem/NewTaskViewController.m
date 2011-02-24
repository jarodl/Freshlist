//
//  NewTaskViewController.m
//  Perdiem
//
//  Created by Jarod Luebbert on 2/12/11.
//  Copyright 2011 Jarod Luebbert. All rights reserved.
//

#import "NewTaskViewController.h"
#import "CustomNavigationBar.h"
#import "Globals.h"
#import "Task.h"

@implementation NewTaskViewController

@synthesize task;
@synthesize newTaskField;
@synthesize saveTaskButton;
@synthesize cancelButton;
@synthesize delegate;

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  saveTaskButton.enabled = NO;
  newTaskField.text = @"";
  [newTaskField becomeFirstResponder];
}

- (void)saveTask
{
  task.content = newTaskField.text;
  NSDate *now = [NSDate date];
  task.timeStamp = now;
//  task.completed = [NSNumber numberWithBool:NO];
  
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *comps = [[NSDateComponents alloc] init];
  [comps setDay:1];
  // move the expiration date forward one day
  NSDate *expirationDate = [gregorian dateByAddingComponents:comps toDate:now options:0];
  [comps release];
  // then set the time to midnight
  NSDateComponents *expirationComps = [gregorian components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit) fromDate:expirationDate];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"M/d/yyyy"];
  expirationDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%i/%i/%i",
                                                  [expirationComps month], [expirationComps day], [expirationComps year]]];
  [dateFormatter release];
  [gregorian release];
  
  task.expiration = expirationDate;
  
  NSError *error = nil;
	if (![task.managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}	
  
  [self.delegate newTaskViewController:self didAddTask:task];
}

- (void)cancel
{
  [task.managedObjectContext deleteObject:task];
  
  NSError *error = nil;
	if (![task.managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}		
  
  [self.delegate newTaskViewController:self didAddTask:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
  /*
   Reduce the size of the text view so that it's not obscured by the keyboard.
   Animate the resize so that it's in sync with the appearance of the keyboard.
   */
  NSDictionary *userInfo = [notification userInfo];
  
  // Get the origin of the keyboard when it's displayed.
  NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
  
  // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
  CGRect keyboardRect = [aValue CGRectValue];
  keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
  
  CGFloat keyboardTop = keyboardRect.origin.y;
  CGRect newTextViewFrame = self.view.bounds;
  newTextViewFrame.size.height = keyboardTop - (self.view.bounds.origin.y);
  
  // Get the duration of the animation.
  NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSTimeInterval animationDuration;
  [animationDurationValue getValue:&animationDuration];
  
  // Animate the resize of the text view's frame in sync with the keyboard's appearance.
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:animationDuration];
  
  newTaskField.frame = newTextViewFrame;
  
  [UIView commitAnimations];
}

- (void)textViewDidChange:(UITextView *)textView
{
  saveTaskButton.enabled = ![textView.text isEqualToString:@""];
}

- (void)dealloc
{
  [newTaskField release];
  [saveTaskButton release];
  [cancelButton release];
  [task release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
  
  newTaskField.backgroundColor = TableBackgroundColor;
  newTaskField.textColor = TableViewCellTextColor;
  
  self.title = @"New Task";
  
  cancelButton = [self customBarButtonItemWithText:@"Cancel" withImageName:@"customBarButton"];
  self.navigationItem.leftBarButtonItem = cancelButton;
  UIButton* leftButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
  [leftButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
  
  saveTaskButton = [self customBarButtonItemWithText:@"Save" withImageName:@"customBarButton"];
  self.navigationItem.rightBarButtonItem = saveTaskButton;
  UIButton* rightButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
  [rightButton addTarget:self action:@selector(saveTask) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  newTaskField = nil;
  saveTaskButton = nil;
  cancelButton = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

@end
