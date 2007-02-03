//***************************************************************************

/* Copyright (C) 2004-2007 Realmac Software Limited <dan.counsell@realmacsoftware.com>
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

#import "BTBController.h"

//***************************************************************************

static NSString* ToolbarIdentifier = @"Example Toolbar Identifier";
static NSString* Item1ToolbarItemIdentifier = @"Item 1 Identifier";
static NSString* Item2ToolbarItemIdentifier = @"Item 2 Item Identifier";

//***************************************************************************

@implementation BTBController

//***************************************************************************

- (void)awakeFromNib
{
    NSToolbar *toolbar = [[[NSToolbar alloc] initWithIdentifier: ToolbarIdentifier] autorelease];
    
    [toolbar setAllowsUserCustomization: YES];
    [toolbar setAutosavesConfiguration: YES];
    [toolbar setDisplayMode: NSToolbarDisplayModeIconAndLabel];
	
    [toolbar setDelegate: self];
	
    [mainWindow setToolbar: toolbar];
	
	[mainWindow center];
}

//---------------------------------------------------------------------------

- (IBAction)updateThemeView:(id)sender
{
	[self autoPopulate];
	[self createPreview];
	[previewWell setImage: compositeImage];
}

- (IBAction)showHelp:(id)sender
{
	[NSApp showHelp:self];
}

- (IBAction)ExportTheme:(id)sender
{
	[previewWell setImage: compositeImage];	
	
	//save stuff
	int result;
	
    NSSavePanel *sp = [NSSavePanel savePanel];
	//[sp setCanSelectHiddenExtension:YES];
    //[sp setRequiredFileType:@"png"];
	result = [sp runModalForDirectory:NSHomeDirectory() file:(@"My Theme")];
	
	if (result == NSOKButton)
	{
		//Create Folder
		NSFileManager *theManager = [NSFileManager defaultManager];
		NSString *theDestination = [sp filename];
		[theManager createDirectoryAtPath:theDestination attributes:nil];
		
		NSLog (@"Path %@", theDestination);
		
		//Save Preview Image
		NSBitmapImageRep *image = [[NSBitmapImageRep alloc] initWithData:[compositeImage TIFFRepresentation]];
		NSNumber *ditherTransparency = [NSNumber numberWithBool:YES]; 
		NSDictionary *propertyDict = [NSDictionary dictionaryWithObject:ditherTransparency forKey:NSImageInterlaced];
		NSData *data = [image representationUsingType:NSPNGFileType properties:propertyDict];
		[data writeToFile:[theDestination stringByAppendingString:@"/preview.png"] atomically:NO];
		
		//Save Left Image
		image = [[NSBitmapImageRep alloc] initWithData:[workingRepLeft TIFFRepresentation]];
		data = [image representationUsingType:NSPNGFileType properties:propertyDict];
		[data writeToFile:[theDestination stringByAppendingString:@"/button_left.png"] atomically:NO];
		
		//Save Middle Image
		image = [[NSBitmapImageRep alloc] initWithData:[workingRepMiddle TIFFRepresentation]];
		data = [image representationUsingType:NSPNGFileType properties:propertyDict];
		[data writeToFile:[theDestination stringByAppendingString:@"/button_middle.png"] atomically:NO];
		
		//Save Right Image
		image = [[NSBitmapImageRep alloc] initWithData:[workingRepRight TIFFRepresentation]];
		data = [image representationUsingType:NSPNGFileType properties:propertyDict];
		[data writeToFile:[theDestination stringByAppendingString:@"/button_right.png"] atomically:NO];
		
		[image release];
		
		NSLog (@"Saving Done");
	}
}

-(void)autoPopulate
{
	//get left image
	NSImage* workingRepLeft2 = [leftWell image];

	NSImage* compositeImage2 = [[NSImage alloc] initWithSize:NSMakeSize(1,[workingRepLeft2 size].height)]; 
	
	[compositeImage2 lockFocus];
	{
		[workingRepLeft2 compositeToPoint: NSZeroPoint fromRect:NSMakeRect([workingRepLeft2 size].width-1, 0, 1, [workingRepLeft2 size].height) operation:NSCompositeCopy];
	}
	[compositeImage2 unlockFocus];
	
	//paste it into middle scection.
	[middleWell setImage: compositeImage2];	
	

	///////////////// THIS BIT DOESN'T WORK - it should flip the left piece of the button horizontally ////////////
	
	//Get Left Image
	/**NSBitmapImageRep *workingRepLeft3 = [leftWell image];

	NSImage* compositeImage3 = [[NSImage alloc] initWithSize:NSMakeSize([workingRepLeft2 size].width,[workingRepLeft2 size].height)]; 
	[compositeImage3 lockFocus];
	{
		//[workingRepLeft3 setFlipped:TRUE];
		[workingRepLeft3 compositeToPoint:NSMakePoint(0,0) operation:NSCompositeSourceOver];
	}
	[compositeImage3 unlockFocus];
	
	[rightWell setImage: compositeImage3];	**/
}


-(void)createPreview
{
	workingRepLeft = [leftWell image];
	workingRepMiddle = [middleWell image];
	workingRepRight = [rightWell image];
	
	compositeImage = [[NSImage alloc] initWithSize:NSMakeSize([workingRepLeft size].width*3,[workingRepLeft size].height)]; 
	[compositeImage lockFocus];
	{
		[workingRepLeft dissolveToPoint: NSMakePoint(0,0) fraction:1.0];
		[workingRepRight dissolveToPoint: NSMakePoint([workingRepLeft size].width*2,0) fraction:1.0];
		
		NSImage *tempImage = workingRepMiddle;
		[tempImage setScalesWhenResized:YES];
		NSSize newSize;
		newSize.width = [workingRepLeft size].width;
		newSize.height = [workingRepLeft size].height;
		[tempImage setSize:newSize];
		[workingRepMiddle dissolveToPoint: NSMakePoint([workingRepLeft size].width,0) fraction:(1.0)];
	}
	
	[compositeImage unlockFocus];

	NSImage* scaleThisImage = compositeImage;
	NSImageRep* workingRep = [scaleThisImage bestRepresentationForDevice:nil];
	
	NSImage* finalImage = [[NSImage alloc] initWithSize:NSMakeSize([workingRepLeft size].width*3,[workingRepLeft size].height)];
	
	[finalImage lockFocus];
	{
		[[NSGraphicsContext currentContext] setImageInterpolation: NSImageInterpolationHigh];
		[workingRep drawInRect:NSMakeRect(0,0,128,100)];
	}
	[finalImage unlockFocus];
}

//***************************************************************************

//////////////////////////////////////////////////////
//
// Toolbar Code starts here 
//
///////////////////////////////////////////////////////

//We layout the toolbars here
- (NSToolbarItem*) toolbar:(NSToolbar*)aToolbar itemForItemIdentifier:(NSString*)itemIdent willBeInsertedIntoToolbar:(BOOL)willBeInserted
{
    NSToolbarItem *toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier: itemIdent] autorelease];
	
	if ([itemIdent isEqualToString:Item1ToolbarItemIdentifier])
	{
        [toolbarItem setLabel: @"Help"];
        [toolbarItem setPaletteLabel: @"Help"];
        [toolbarItem setImage: [NSImage imageNamed: @"helpIcon"]];
        [toolbarItem setTarget: self];
        [toolbarItem setAction: @selector(showHelp:)];
    }
	else if ([itemIdent isEqual: Item2ToolbarItemIdentifier])
	{
        [toolbarItem setLabel: @"Export"];
        [toolbarItem setPaletteLabel: @"Export"];
        [toolbarItem setImage: [NSImage imageNamed: @"export"]];
        [toolbarItem setTarget: self];
        [toolbarItem setAction: @selector(ExportTheme:)];
	}
	else
	{ 
        toolbarItem = nil;
    }
	
    return toolbarItem;
}


//The defualt Toolbar Setup
- (NSArray *) toolbarDefaultItemIdentifiers: (NSToolbar *)aToolbar
{
    return [NSArray arrayWithObjects: 
	Item1ToolbarItemIdentifier, 
	NSToolbarSeparatorItemIdentifier,
	Item2ToolbarItemIdentifier,nil];
}

//Customize sheet
- (NSArray *) toolbarAllowedItemIdentifiers: (NSToolbar *)aToolbar
{
    return [NSArray arrayWithObjects: Item1ToolbarItemIdentifier, Item2ToolbarItemIdentifier,NSToolbarCustomizeToolbarItemIdentifier, NSToolbarFlexibleSpaceItemIdentifier, NSToolbarSpaceItemIdentifier, NSToolbarSeparatorItemIdentifier, nil];
}


@end

//***************************************************************************
