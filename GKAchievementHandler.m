//
//  GKAchievementHandler.m
//
//  Created by Benjamin Borowski on 9/30/10.
//  Copyright 2010 Typeoneerror Studios. All rights reserved.
//  $Id$
//

#import <GameKit/GameKit.h>
#import "GKAchievementHandler.h"
#import "GKAchievementNotification.h"

static GKAchievementHandler *defaultHandler = nil;

#pragma mark -

@interface GKAchievementHandler(private)

- (void)displayNotification:(GKAchievementNotification *)notification;

@end

#pragma mark -

@implementation GKAchievementHandler(private)

- (void)displayNotification:(GKAchievementNotification *)notification
{
    if (self.image != nil)
    {
        [notification setImage:self.image];
    }
    else
    {
        [notification setImage:nil];
    }

    UIView *_topView = [[[[UIApplication sharedApplication] keyWindow] rootViewController ] view];
    [_topView addSubview:notification];
    // adjust size and position of notification view
    CGFloat width = 284.0f;
    CGFloat middle_x = 0;
    UIViewController *controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        width = 445.0f;
    }
    else {
        if (controller.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || controller.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            width = 443.0f;
        }
    }
    
    if ( controller.interfaceOrientation == UIInterfaceOrientationPortrait || controller.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        middle_x = _topView.frame.size.width/2;
    }
    else {
        middle_x = _topView.frame.size.height/2;
    }
    
    notification.frame = CGRectMake(0, -53.0, width, 52.0f);
    notification.center = CGPointMake(middle_x, notification.center.y);
    [notification animate];
}

@end

#pragma mark -

@implementation GKAchievementHandler

@synthesize image=_image;

#pragma mark -

+ (GKAchievementHandler *)defaultHandler
{
    if (!defaultHandler) defaultHandler = [[self alloc] init];
    return defaultHandler;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _queue = [[NSMutableArray alloc] initWithCapacity:0];
        self.image = [UIImage imageNamed:@"gk-icon.png"];
    }
    return self;
}

- (void)dealloc
{
    [_queue release];
    [_image release];
    [super dealloc];
}

#pragma mark -

- (void)notifyAchievement:(GKAchievementDescription *)achievement
{
    GKAchievementNotification *notification = [[[GKAchievementNotification alloc] initWithAchievementDescription:achievement] autorelease];
    notification.handlerDelegate = self;

    [_queue addObject:notification];
    if ([_queue count] && isShown == NO)
    {
        isShown = YES;
        [self displayNotification:notification];
    }
}

- (void)notifyAchievementTitle:(NSString *)title andMessage:(NSString *)message
{
    GKAchievementNotification *notification = [[[GKAchievementNotification alloc] initWithTitle:title andMessage:message] autorelease];
    notification.handlerDelegate = self;

    [_queue addObject:notification];
    if ([_queue count] && isShown == NO)
    {
        isShown = YES;
        [self performSelectorOnMainThread:@selector(displayNotification:) withObject:notification waitUntilDone:YES];
    }
}

#pragma mark -
#pragma mark GKAchievementHandlerDelegate implementation

- (void)didHideAchievementNotification:(GKAchievementNotification *)notification
{
    if ([_queue count]) {
        [_queue removeObjectAtIndex:0];
    }
    if ([_queue count])
    {
        [self displayNotification:(GKAchievementNotification *)[_queue objectAtIndex:0]];
    }
    else {
        isShown = NO;
    }
}

@end
