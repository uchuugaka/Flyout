//
//  ALTOAppDelegate.h
//  FlyoutPopUpButtonTest

#import <Cocoa/Cocoa.h>

@interface ALTOAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSPopUpButton *popUpButton;
@property (weak) IBOutlet NSMenu *selectionMenu;
@property (weak) IBOutlet NSMenu *flyOutMenu;
@property NSMenuItem *currentSelectedMenuItem;
@end
