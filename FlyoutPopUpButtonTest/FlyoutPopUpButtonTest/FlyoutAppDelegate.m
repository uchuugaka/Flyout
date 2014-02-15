	//
	//  ALTOAppDelegate.m
	//  FlyoutPopUpButtonTest

#import "FlyoutAppDelegate.h"

@implementation FlyoutAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
		// Insert code here to initialize your application
	[_popUpButton setMenu:_selectionMenu];
		// Recursively traverses a menu and any submenus in the menu to give them all a same action.
	[self addSelector:@selector(selectSenderAndMakeSelectionMenuShowSender:) toAllMenuItemsInArray:_flyOutMenu.itemArray];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNSPopUpButtonWillPopUpNotification:) name:NSPopUpButtonWillPopUpNotification object:_popUpButton];
}
/* This method is recursively called to make all NSMenuItems (except the ones tha thave submenus) including items in submenus have the same selector. That way they all do the same thing. In our case, they all do selectSenderAndMakeSelectionMenuShowSender: which sets the selection in the menu and clears previous selections, updates our reference to the item selected and updates the _selectionMenu for display when the NSPopUpButton is not clicked. */
- (void)addSelector:(SEL)aSelector toAllMenuItemsInArray:(NSArray *)items {
	for (NSMenuItem *aMenuItem in items) {
		if (aMenuItem.hasSubmenu) {
			[self addSelector:aSelector toAllMenuItemsInArray:aMenuItem.submenu.itemArray];
		} else {
			[aMenuItem setAction:aSelector];
		}
	}
	
}

/* This method is called */
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

/* This action method set to the NSPopUpButton is called when the menu selection is done. We cold do more here maybe, but basically, this is to verify everything else worked. */
- (IBAction)popUpButtonAction:(id)sender {
	NSLog(@"[%@ %@: %@]", self, NSStringFromSelector(_cmd), sender);
	NSMenuItem *selectedMenuItem = [_popUpButton selectedItem];
	NSLog(@" selectedMenuItem=%@", selectedMenuItem);
}

/* This NSMenuDelegate method is almost useless because the menu is really already there when this is called. Crap. Don't bother with it. */
- (void)menuWillOpen:(NSMenu *)menu {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	
	if ([menu isEqualTo:_selectionMenu]) {
		NSLog(@" _selectionMenu %@", menu);
	} else if ([menu isEqualTo:_flyOutMenu]) {
		NSLog(@" _flyOUtMenu %@", menu);
			//		[_flyOutMenu accessibilityPerformAction:NSAccessibilityShowMenuAction];
		
		[_currentSelectedMenuItem menu];
	}
}

/* When the menu is closed, we set it to the _selectionMenu which has been updated to have only a copy of the NSMenuItem that was selected in the other menu. This makes it look seamless. */
- (void)menuDidClose:(NSMenu *)menu {
	
	[_popUpButton setMenu:_selectionMenu];
}
/* This notification is better and faster than the NSMenuDelegate method, so it's needed here. We use it to swap in the _flyOutMenu and also to make sure the _flyOutMenu only has the item selected that we selected last time. */
- (void)handleNSPopUpButtonWillPopUpNotification:(NSNotification *)aNotification {
	[_popUpButton setMenu:_flyOutMenu];
	[self makeSureOnlyCurrentSelectedItemIsSelectedInMenu:_flyOutMenu];
}
/* This recursive method makes sure the _flyOutMenu has the same selection made last time. We call it in the handleNSPopUpButtonWillPopUpNotification: method, before the menu appears. */
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
