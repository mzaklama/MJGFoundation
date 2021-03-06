//
//  MainViewController.m
//  MJGFoundationUICatalog
//
//  Created by Matt Galloway on 07/01/2012.
//  Copyright (c) 2012 Matt Galloway. All rights reserved.
//

#import "MainViewController.h"

#import "MJGChoiceViewController.h"
#import "MJGFullscreenImageViewController.h"
#import "MJGFullscreenWebViewController.h"
#import "MJGImageGalleryViewController.h"

#import "Example2DPinchGestureRecognizerViewController.h"
#import "ExampleMJGRateViewViewController.h"

@interface MainViewController () <MJGChoiceViewControllerDelegate, MJGFullscreenWebViewControllerDelegate>
@end

@implementation MainViewController

- (id)init {
    if ((self = [super initWithNibName:@"MainViewController" bundle:nil])) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MJGFoundation UI Catalog";
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 4; break;
        case 1:
            return 1; break;
        case 2:
            return 1; break;
        default:
            return 0; break;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"View controllers"; break;
        case 1:
            return @"Gesture recognizers"; break;
        case 2:
            return @"Views"; break;
        default:
            return nil; break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = indexPath.section;
    int row = indexPath.row;
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    if (section == 0) {
        if (row == 0) {
            cell.textLabel.text = @"Choice";
        } else if (row == 1) {
            cell.textLabel.text = @"Fullscreen Image";
        } else if (row == 2) {
            cell.textLabel.text = @"Fullscreen Web";
        } else if (row == 3) {
            cell.textLabel.text = @"Image Gallery";
        }
    } else if (section == 1) {
        if (row == 0) {
            cell.textLabel.text = @"2D Pinch Gesture";
        }
    } else if (section == 2) {
        if (row == 0) {
            cell.textLabel.text = @"Rating View";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = indexPath.section;
    int row = indexPath.row;
    
    UIViewController *vcToPush = nil;
    UIViewController *vcToModal = nil;
    
    if (section == 0) {
        if (row == 0) {
            NSDictionary *choices = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"itema", @"Item A", 
                                     @"itemb", @"Item B", 
                                     @"itemc", @"Item C", 
                                     @"itemd", @"Item D", 
                                     nil];
            MJGChoiceViewController *vc = [[MJGChoiceViewController alloc] initWithChoices:choices];
            vc.delegate = self;
            vcToModal = vc;
        } else if (row == 1) {
            MJGFullscreenImageViewController *vc = [[MJGFullscreenImageViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.beermap.co/images/home_header_bg.jpg"]];
            vcToPush = vc;
        } else if (row == 2) {
            MJGFullscreenWebViewController *vc = [[MJGFullscreenWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.beermap.co/"]];
            vc.delegate = self;
            vcToModal = vc;
        } else if (row == 3) {
            MJGImageGalleryViewController *vc = [[MJGImageGalleryViewController alloc] initWithImages:nil];
            vcToPush = vc;
        }
    } else if (section == 1) {
        if (row == 0) {
            Example2DPinchGestureRecognizerViewController *vc = [[Example2DPinchGestureRecognizerViewController alloc] init];
            vcToPush = vc;
        }
    } else if (section == 2) {
        if (row == 0) {
            ExampleMJGRateViewViewController *vc = [[ExampleMJGRateViewViewController alloc] init];
            vcToPush = vc;
        }
    }
    
    if (vcToPush) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [self.navigationController pushViewController:vcToPush animated:YES];
        } else {
            self.splitViewController.viewControllers = [NSArray arrayWithObjects:self, vcToPush, nil];
        }
    } else if (vcToModal) {
        [self presentModalViewController:vcToModal animated:YES];
    }
}


#pragma mark - MJGChoiceViewControllerDelegate

- (void)choiceViewController:(MJGChoiceViewController *)viewController finishedWithKey:(id)key andValue:(id)value {
    [self dismissModalViewControllerAnimated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Choice" 
                                                    message:[NSString stringWithFormat:@"You chose\n%@ => %@", key, value] 
                                                                              delegate:nil 
                                                                     cancelButtonTitle:nil 
                                                                     otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)choiceViewControllerCancelled:(MJGChoiceViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - MJGFullscreenWebViewControllerDelegate

- (void)fullscreenWebViewControllerDidFinish:(MJGFullscreenWebViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
}

@end
