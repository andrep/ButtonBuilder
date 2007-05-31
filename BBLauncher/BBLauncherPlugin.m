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
//  BBLauncherPlugin.m
//  Button Builder Launcher
//
//  Created by Ollie Levy on 4/18/07.
//  Copyright © 2006 - 2007 Vortex Themes.
//

#import "BBLauncherPlugin.h"

@implementation BBLauncherPlugin

///////////////////////////////////////////////////////////////////
//
// BBLauncher Plugin 
//
// These are the basic object life-cycle methods
//
///////////////////////////////////////////////////////////////////

- (id)init
{
    if ((self = [super init]) != nil){
		[NSBundle loadNibNamed:@"BBLauncher" owner:self];
	}
    return self;
}

///////////////////////////////////////////////////////////////////
//
// Save and restore plugin settings
//
// This is where you can save and restore your plugin's data to 
// and from the .rw3 file
//
///////////////////////////////////////////////////////////////////

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init]) {
    }
    return self;
}

//Save Data
- (void)encodeWithCoder:(NSCoder *)aCoder 
{
}


///////////////////////////////////////////////////////////////////
//
// Plugin Output
//
// This is where you return your plugin's content to RapidWeaver. 
// 
// Note: These methods will probably be called on a thread other than
// the main one so beware of calling APIs which are not background
// thread safe e.g. AppleScript, some parts of QuickTime, etc
//
///////////////////////////////////////////////////////////////////

- (id)contentHTML:(NSDictionary*)params
{
	return nil;
}

- (NSString *)sidebarHTML:(NSDictionary*)params
{
	return nil;
}

- (NSArray *)extraFilesNeededInExportFolder:(NSDictionary*)params
{
	return nil;
}

///////////////////////////////////////////////////////////////////
//
// Plugin boilerplate
//
// This is the basic machinery required of a plugin by RapidWeaver 
// to supply information like the plugin's name and icon
//
///////////////////////////////////////////////////////////////////

- (id) pageFromPageID:(NSString*)pageID
{
  return nil;
}

+ (NSEnumerator *) pluginsAvailable;
{
  return nil;
}

+ (NSString *) pluginName
{
  NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];
  
  return NSLocalizedStringFromTableInBundle(@"PluginName", nil, mainBundle, @"Localizable");
}

+ (NSString *) pluginType
{
  NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];
  
  return NSLocalizedStringFromTableInBundle(@"PluginType", nil, mainBundle, @"Localizable");
}

+ (NSString *) pluginAuthor
{ 
  return @"Ollie Levy"; 
}

+ (NSImage *) pluginIcon
{ 
  return nil;
}

+ (NSString *) pluginDescription;
{	
  NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];
  
  return NSLocalizedStringFromTableInBundle(@"PluginDescription", nil, mainBundle, @"Localizable");
}

- (NSView *) userInteractionAndEditingView
{ 
  return nil; 
}

- (NSWindow *) documentWindow;
{
  return _documentWindow;
}

- (void) setDocumentWindow:(NSWindow *)documentWindow
{
  _documentWindow = documentWindow;
  [_documentWindow retain];
}

- (NSString *) uniqueID
{
  return _uniqueID;
}

- (void) setUniqueID:(NSString *)aUniqueID
{
  _uniqueID = aUniqueID;
  [_uniqueID retain];
}

///////////////////////////////////////////////////////////////////
//
// Plugin bindings
//
// Here we handle the connection between our internal data and
// the user interface. These bindings are defined in BBLauncher.nib
//
///////////////////////////////////////////////////////////////////

- (IBAction)website:(id)sender
{
NSWorkspace *myWorkspace = [NSWorkspace sharedWorkspace];
NSURL *mySite = [NSURL URLWithString:@"http://www.ttpsoftware.com/"];
[myWorkspace openURL:mySite];
}

@end