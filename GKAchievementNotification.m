//
//  GKAchievementNotification.m
//
//  Created by Benjamin Borowski on 9/30/10.
//  Copyright 2010 Typeoneerror Studios. All rights reserved.
//  $Id$
//

#import <GameKit/GameKit.h>
#import "GKAchievementNotification.h"

#pragma mark -

@interface GKAchievementNotification(private)

- (void)delegateCallback:(SEL)selector withObject:(id)object;

@end

#pragma mark -

@implementation GKAchievementNotification(private)

- (void)delegateCallback:(SEL)selector withObject:(id)object
{
    if (self.handlerDelegate)
    {
        if ([self.handlerDelegate respondsToSelector:selector])
        {
            [self.handlerDelegate performSelector:selector withObject:object];
        }
    }
}

@end

#pragma mark -

@implementation GKAchievementNotification

@synthesize achievement=_achievement;
@synthesize background=_background;
@synthesize handlerDelegate=_handlerDelegate;
@synthesize detailLabel=_detailLabel;
@synthesize logo=_logo;
@synthesize message=_message;
@synthesize title=_title;
@synthesize textLabel=_textLabel;

#pragma mark -

- (id)initWithAchievementDescription:(GKAchievementDescription *)achievement
{
    CGRect frame = kGKAchievementDefaultSize;
    self.achievement = achievement;
    if ((self = [self initWithFrame:frame]))
    {
    }
    return self;
}

- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message
{
    CGRect frame = kGKAchievementDefaultSize;
    self.title = title;
    self.message = message;
    [self initWithFrame:frame];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        // create the GK background
        UIImage *backgroundStretch = [[UIImage imageNamed:@"gk-notification.png"] stretchableImageWithLeftCapWidth:8.0f topCapHeight:0.0f];
        UIImageView *tBackground = [[UIImageView alloc] initWithFrame:frame];
        tBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        tBackground.image = backgroundStretch;
        self.background = tBackground;
        self.opaque = NO;
        [tBackground release];
        [self addSubview:self.background];

        CGRect r1 = kGKAchievementText1;
        CGRect r2 = kGKAchievementText2;

        // create the text label
        UILabel *tTextLabel = [[UILabel alloc] initWithFrame:r1];
        tTextLabel.textAlignment = UITextAlignmentCenter;
        tTextLabel.backgroundColor = [UIColor clearColor];
        tTextLabel.textColor = [UIColor whiteColor];
        tTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f];
        tTextLabel.text = NSLocalizedString(@"Achievement Unlocked", @"Achievemnt Unlocked Message");
        tTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
        self.textLabel = tTextLabel;
        [tTextLabel release];

        // detail label
        UILabel *tDetailLabel = [[UILabel alloc] initWithFrame:r2];
        tDetailLabel.textAlignment = UITextAlignmentCenter;
        tDetailLabel.adjustsFontSizeToFitWidth = YES;
        tDetailLabel.minimumFontSize = 10.0f;
        tDetailLabel.backgroundColor = [UIColor clearColor];
        tDetailLabel.textColor = [UIColor whiteColor];
        tDetailLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0f];
        tDetailLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
        self.detailLabel = tDetailLabel;
        [tDetailLabel release];

        if (self.achievement)
        {
            self.textLabel.text = self.achievement.title;
            self.detailLabel.text = self.achievement.achievedDescription;
        }
        else
        {
            if (self.title)
            {
                self.textLabel.text = self.title;
            }
            if (self.message)
            {
                self.detailLabel.text = self.message;
            }
        }

        [self addSubview:self.textLabel];
        [self addSubview:self.detailLabel];
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    }
    return self;
}

- (void)dealloc
{
    self.handlerDelegate = nil;
    self.logo = nil;
    self.message = nil;
    self.title = nil;
    
    [_achievement release];
    [_background release];
    [_detailLabel release];
    [_logo release];
    [_textLabel release];
    
    [super dealloc];
}


#pragma mark -

-(void)animate {
    [UIView animateWithDuration:kGKAchievementAnimeTime
                          delay:0.0f 
                        options:UIViewAnimationOptionBeginFromCurrentState     
                     animations:^{ 
						 [self delegateCallback:@selector(willShowAchievementNotification:) withObject:self];
                         self.frame = CGRectMake(self.frame.origin.x, 10.0f, self.frame.size.width, self.frame.size.height);
                     } 
                     completion:^(BOOL finished){
						 [self delegateCallback:@selector(didShowAchievementNotification:) withObject:self];
                         [UIView animateWithDuration:kGKAchievementAnimeTime 
                                               delay:kGKAchievementDisplayTime 
                                             options:UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{ 
											  [self delegateCallback:@selector(willHideAchievementNotification:) withObject:self];
                                              self.frame = CGRectMake(self.frame.origin.x , -53.0f, self.frame.size.width, self.frame.size.height);
                         } 
                         completion:^(BOOL finished){
							 [self delegateCallback:@selector(didHideAchievementNotification:) withObject:self];
                             [self removeFromSuperview];
                         }];
                         
                     }];
}

- (void)setImage:(UIImage *)image
{
    if (image)
    {
        if (!self.logo)
        {
            UIImageView *tLogo = [[UIImageView alloc] initWithFrame:CGRectMake(7.0f, 6.0f, 34.0f, 34.0f)];
            tLogo.contentMode = UIViewContentModeScaleAspectFit;
            self.logo = tLogo;
            [tLogo release];
            [self addSubview:self.logo];
        }
        self.logo.image = image;
        self.textLabel.frame = kGKAchievementText1WLogo;
        self.detailLabel.frame = kGKAchievementText2WLogo;
    }
    else
    {
        if (self.logo)
        {
            [self.logo removeFromSuperview];
        }
        self.textLabel.frame = kGKAchievementText1;
        self.detailLabel.frame = kGKAchievementText2;
    }
}

@end
