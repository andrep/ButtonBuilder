//***************************************************************************

/* Copyright (C) 2002-2007 Realmac Software Limited <dan.counsell@realmacsoftware.com>
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

#import "PreferencesController.h"

//***************************************************************************

#define WINDOW_TITLE_HEIGHT 78

static NSString *GeneralToolbarItemIdentifier				= @"General";
static NSString *UpdatesToolbarItemIdentifier				= @"Updates";

@implementation PreferencesController

- (void)awakeFromNib
{
	id toolbar = [[[NSToolbar alloc] initWithIdentifier:@"preferencesToolbar"] autorelease];
    [toolbar setAllowsUserCustomization:NO];
    [toolbar setAutosavesConfiguration:NO];
	[toolbar setSizeMode:NSToolbarSizeModeDefault];
	[toolbar setDisplayMode:NSToolbarDisplayModeIconAndLabel];
	[toolbar setDelegate:self];
	[toolbar setSelectedItemIdentifier:GeneralToolbarItemIdentifier];
	[[self window] setToolbar:toolbar];
	[[self window] setTitle:GeneralToolbarItemIdentifier];
	
	[self setActiveView:generalPreferenceView animate:NO];
	
	[[self window] setShowsToolbarButton:NO];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar
{
	return [NSArray arrayWithObjects:
		GeneralToolbarItemIdentifier,
		UpdatesToolbarItemIdentifier,
		nil];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar 
{
	return [NSArray arrayWithObjects:
		GeneralToolbarItemIdentifier,
		UpdatesToolbarItemIdentifier,
		nil];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar
{
	return [NSArray arrayWithObjects:
		GeneralToolbarItemIdentifier,
		UpdatesToolbarItemIdentifier,
		nil];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)identifier willBeInsertedIntoToolbar:(BOOL)willBeInserted 
{
	NSToolbarItem *item = [[[NSToolbarItem alloc] initWithItemIdentifier:identifier] autorelease];
	if ([identifier isEqualToString:GeneralToolbarItemIdentifier]) {
		[item setLabel:GeneralToolbarItemIdentifier];
		[item setImage:[NSImage imageNamed:@"general"]];
		[item setTarget:self];
		[item setAction:@selector(toggleActivePreferenceView:)];
	} else if ([identifier isEqualToString:UpdatesToolbarItemIdentifier]) {
		[item setLabel:UpdatesToolbarItemIdentifier];
		[item setImage:[NSImage imageNamed:@"updates"]];
		[item setTarget:self];
		[item setAction:@selector(toggleActivePreferenceView:)];
	} else
		item = nil;
	return item; 
}

- (void)toggleActivePreferenceView:(id)sender
{
	NSView *view;	
	if ([[sender itemIdentifier] isEqualToString:GeneralToolbarItemIdentifier])
		view = generalPreferenceView;
	else if ([[sender itemIdentifier] isEqualToString:UpdatesToolbarItemIdentifier])
		view = updatesPreferenceView;
	
	[self setActiveView:view animate:YES];
	[[self window] setTitle:[sender itemIdentifier]];
}

- (void)setActiveView:(NSView *)view animate:(BOOL)flag
{
	NSRect windowFrame = [[self window] frame];
	windowFrame.size.height = [view frame].size.height + WINDOW_TITLE_HEIGHT;
	windowFrame.size.width = [view frame].size.width;
	windowFrame.origin.y = NSMaxY([[self window] frame]) - ([view frame].size.height + WINDOW_TITLE_HEIGHT);
	
	if ([[activeContentView subviews] count] != 0)
		[[[activeContentView subviews] objectAtIndex:0] removeFromSuperview];
	[[self window] setFrame:windowFrame display:YES animate:flag];
	
	[activeContentView setFrame:[view frame]];
	[activeContentView addSubview:view];
}

@end

//***************************************************************************
