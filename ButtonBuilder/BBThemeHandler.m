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

#import "BBThemeHandler.h"
#import "MyDocument.h"

//***************************************************************************

@implementation BBThemeHandler

-(void)loadThemes;
{
	[[themeTableView tableColumnWithIdentifier:@"preview"] setDataCell:[NSImageCell new]];
	
	NSString *imagePath = [NSString stringWithFormat:@"~/Library/Application Support/Button Builder/"];
	NSLog(imagePath);
	
	themeArray=[[NSMutableArray alloc] init];
	myfilemanager = [[NSFileManager alloc] init];
    myfilemanager = [NSFileManager defaultManager];

	[themeArray setArray:[myfilemanager directoryContentsAtPath:[imagePath stringByExpandingTildeInPath]]];
    int i;
    for (i=[themeArray count]-1;i>=0;i--) {
        if ([[[themeArray objectAtIndex:i] lowercaseString] isEqualToString:@".ds_store"]) {
            [themeArray removeObjectAtIndex:i];}
		}
		[myfilemanager release];
}


- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [themeArray count];
}


- (int)getRowNumber
{
	return [themeTableView selectedRow];
}

- (void)setRowNumber:(int)i
{
	[themeTableView selectRow:i byExtendingSelection:NO];
	[themeTableView scrollRowToVisible:[themeTableView selectedRow]];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
	NSImage* preview = [[NSImage alloc] initWithContentsOfFile:[[NSString stringWithFormat:@"~/Library/Application Support/Button Builder/%@/preview.png",[themeArray objectAtIndex:row]] stringByExpandingTildeInPath]];
	return preview;
	
}

-(NSImage*)getLeftImage
{
	NSImage* leftImage = [[NSImage alloc] initWithContentsOfFile:[[NSString stringWithFormat:@"~/Library/Application Support/Button Builder/%@/button_left.png",[themeArray objectAtIndex:[themeTableView selectedRow]]] stringByExpandingTildeInPath]];
	return leftImage;
}

-(NSImage*)getMiddleImage
{
	NSImage* middleImage = [[NSImage alloc] initWithContentsOfFile:[[NSString stringWithFormat:@"~/Library/Application Support/Button Builder/%@/button_middle.png",[themeArray objectAtIndex:[themeTableView selectedRow]]] stringByExpandingTildeInPath]];
	return middleImage;
}

-(NSImage*)getRightImage
{
	NSImage* rightImage = [[NSImage alloc] 
	
	initWithContentsOfFile:[[NSString stringWithFormat:@"~/Library/Application Support/Button Builder/%@/button_right.png",[themeArray objectAtIndex:[themeTableView selectedRow]]] stringByExpandingTildeInPath]];
	
	
	return rightImage;
}

@end

//***************************************************************************
