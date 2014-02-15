//
//  ALTOAppDelegate.m
//  FlyoutPopUpButtonTest

#import "ALTOAppDelegate.h"

@implementation ALTOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	[_popUpButton setMenu:_selectionMenu];
	[self addSelector:@selector(selectSenderAndMakeSelectionMenuShowSender:) toAllMenuItemsInArray:_flyOutMenu.itemArray];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNSPopUpButtonWillPopUpNotification:) name:NSPopUpButtonWillPopUpNotification object:_popUpButton];
}

- (void)addSelector:(SEL)aSelector toAllMenuItemsInArray:(NSArray *)items {
	for (NSMenuItem *aMenuItem in items) {
		if (aMenuItem.hasSubmenu) {
			[self addSelector:aSelector toAllMenuItemsInArray:aMenuItem.submenu.itemArray];
		} else {
			[aMenuItem setAction:aSelector];
		}
	}

}
- (IBAction)selectSenderAndMakeSelectionMenuShowSender:(id)sender {
	NSMenuItem *selectedItem = (NSMenuItem *)sender;
	if (_currentSelectedMenuItem != nil) {
		if (![_currentSelectedMenuItem isEqualTo:selectedItem]) {
			[_currentSelectedMenuItem setState:NSOffState];
		}
	}
	
	[selectedItem setState:NSOnState];
	[self setCurrentSelectedMenuItem:selectedItem];
	
	[_selectionMenu removeAllItems];
	[_selectionMenu addItem:selectedItem.copy];
}

- (IBAction)popUpButtonAction:(id)sender {
	NSLog(@"[%@ %@: %@]", self, NSStringFromSelector(_cmd), sender);
	NSMenuItem *selectedMenuItem = [_popUpButton selectedItem];
	NSLog(@" selectedMenuItem=%@", selectedMenuItem);
}

- (void)menuWillOpen:(NSMenu *)menu {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	
	if ([menu isEqualTo:_selectionMenu]) {
		NSLog(@" %@", menu);
	} else if ([menu isEqualTo:_flyOutMenu]) {
		NSLog(@" %@", menu);
	}
}

- (void)menuDidClose:(NSMenu *)menu {
	
	[_popUpButton setMenu:_selectionMenu];
}

- (void)handleNSPopUpButtonWillPopUpNotification:(NSNotification *)aNotification {
	[_popUpButton setMenu:_flyOutMenu];
	[self makeSureOnlyCurrentSelectedItemIsSelectedInMenu:_flyOutMenu];
}

- (void)makeSureOnlyCurrentSelectedItemIsSelectedInMenu:(NSMenu *)aMenu {
	for (NSMenuItem *aMenuItem in aMenu.itemArray) {
		if (aMenuItem.hasSubmenu) {
			[self makeSureOnlyCurrentSelectedItemIsSelectedInMenu:aMenuItem.submenu];
		} else {
			if ([aMenuItem isEqualTo:_currentSelectedMenuItem]) {
				[aMenuItem setState:NSOnState];
			} else {
				[aMenuItem setState:NSOffState];
			}
		}
	}
}

@end
