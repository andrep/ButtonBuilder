//***************************************************************************

/* Copyright (C) 2006-2007 Vortex Themes <ollie@vortex-themes.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

//***************************************************************************

//
//  BBLauncherMenu.m
//  Button Builder Launcher
//
//  Created by Ollie Levy on 4/18/07.
//  Copyright © 2006 - 2007 Vortex Themes.
//

#import "BBLauncherMenu.h"

@implementation BBLauncherMenu

+ (void)load
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationDidFinishLaunching:)
												 name:NSApplicationDidFinishLaunchingNotification
											   object:nil];
}

+ (void)applicationDidFinishLaunching:(id)ignored
{
	NSMenu *theMenuBar = [NSApp mainMenu];
	int i;

	NSMenuItem *theView = [[theMenuBar  itemArray] objectAtIndex:[[theMenuBar itemArray]count]-2];
	NSMenu *myMenu = [theView submenu];
	
	BOOL foundFour=FALSE;
	int locationThree=-1;

	NSArray *menus=[myMenu itemArray];
	for (i=0;i<[menus count];i++) {
		NSMenuItem *myItem=[menus objectAtIndex:i];
		if ([[myItem keyEquivalent] isEqualToString:@"T"])
			foundFour=TRUE;
	}
	
		NSMenuItem *item=[[NSMenuItem alloc] initWithTitle:@"Launch Button Builder"
												action:@selector(openButtonBuilder:)
										 keyEquivalent:@"B"];
		[item setKeyEquivalentModifierMask:NSShiftKeyMask];
		[item setTarget:[self class]];
		if ((!foundFour) && locationThree>0) {
			[myMenu insertItem:item atIndex:locationThree+1];
		} else {
			[myMenu addItem:item];
	}

}

+ (IBAction) openButtonBuilder:(id)sender
{
	[[NSWorkspace sharedWorkspace] launchApplication:@"Button Builder"];
}

@end