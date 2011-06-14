GKAchievementNotification
=========================

What is it?
-----------

Game Center has a notification window that slides down and informs the GKLocalPlayer that they've been authenticated. The GKAchievementNotification classes are a way to display achievements awarded to the player in the same manner as GameKit does it in iOS5.

How this fork is different?
--------
I tried using both original version from [typeonerror](https://github.com/typeoneerror/GKAchievementNotification) as well as a fork from [jfro](https://github.com/jfro/BCAchievementNotification), but they didn't work me. 
Here are the main features of this fork:
# notifications are displayed correctly on iPhone/iPad in all interface orientations
# notification view can be easily resized and repositioned
# notifications can be displayed from the non-main threads as well
# animations are using iOS4-style animation blocks
# it works for me in both iOS4 and iOS5 beta1

Unlike original branch of GKAchievementNotification, this fork will add notification to the view of your RootController, so device rotations will be handled automatically.

Using it
--------

Add the folder (.h, .m, images) to your Xcode project. The GKAchievementHandler class handles the display of the notifications. You'll primarily use that (there'd usually be no reason to create a notification directly). When your player earns an achievement, you can notify them of this via GKAchievementHandler:

<code>
// grab an achievement description from where ever you saved them
GKAchievementDescription *achievement = [[GKAchievementDescription alloc] init];

// notify the user
[[GKAchievementHandler defaultHandler] notifyAchievement:achievement];
</code>

You can also use custom messages instead of a GKAchievementDescription object:

<code>
[[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"High Roller" andMessage:@"Earned 100 points online."];
</code>

Customization
-------------

Apples Guidelines state that "it is up to you to do so in a way that fits the style of your game".  and Allan Schaffer of Apple stated in the forums that "[the] best way to do that would be to present a custom dialog using the look and feel of *your* game." This to me means you may be rejected for using Apple's artwork in a custom application. If this worries you, use the <pre>setImage:</pre> methods to change the logo displayed in the dialog or change the gk-icon.png images in your images. You can also set the image to nil to not show any image:

<code>
[[GKAchievementHandler defaultHandler] setImage:nil];
</code>

You can also edit the gk-notification.png images to change the stretchable background.

Notes
--------
If you created your project back in iOS3 days, than you probably don't have a rootController set for your window. Make sure to set using something like this in your application delegate:
<code>
	self.window.rootViewController = self.navigationController;	
</code>