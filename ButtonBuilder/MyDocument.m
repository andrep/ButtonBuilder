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

#import "MyDocument.h"
#import "BBThemeHandler.h"
#import "BBImageController.h"

//***************************************************************************

@implementation MyDocument

//***************************************************************************


//Set up the Toolbar name and the toolbar Items
static NSString* ToolbarIdentifier				= @"Main Toolbar Identifier";
static NSString* Item1ToolbarItemIdentifier 	= @"Themes Identifier";
static NSString* Item2ToolbarItemIdentifier 	= @"Options Identifier";
static NSString* Item3ToolbarItemIdentifier 	= @"Font Identifier";
static NSString* Item4ToolbarItemIdentifier 	= @"Export Identifier";


//***************************************************************************

-(void)awakeFromNib 
{
	
	// copy the application support if it doesn't already exist
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    if (![myFileManager fileExistsAtPath:[@"~/Library/Application Support/Button Builder/" stringByExpandingTildeInPath]]) {
        [myFileManager copyPath:[NSString stringWithFormat:@"%@/Contents/Resources/Plugins",[[NSBundle mainBundle] bundlePath]] toPath:[@"~/Library/Application Support/Button Builder/" stringByExpandingTildeInPath] handler:nil];
    }

	[themeHandler loadThemes];
	
	//Calls the refresh canvas action
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(updateCanvas:) name:NSControlTextDidChangeNotification object:captionTextView];
	
	//Shows the Transparency Slider
	[[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
	
	currentFont = [NSFont fontWithName:@"Lucida Grande Bold" size:24.0];
	//[self updateCanvas:self];
	[self updateBGCanvas:self];
	
	//PUT UPDATE CODE HERE FOR CANVAS
	[documentWindow setContentSize:NSMakeSize(668,387)];
	
	//Center windows if first launch
	if (![myFileManager fileExistsAtPath:[@"~/Library/Preferences/com.realmacsoftware.ButtonBuilder4.plist" stringByExpandingTildeInPath]]) {
		[documentWindow center];
		[inspectorWindow center];
	}
	
	//Set last update text field if not yet run
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SULastCheckTime"] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:@"Not Yet Run" forKey:@"SULastCheckTime"];
	}
	
}

//Get Button Caption
- (NSString *)getCaption;
{
	return [captionTextView stringValue];
}

//Get Text Colour
- (NSColor *)getTextColor
{
	NSColor *sampleColor;
	sampleColor = [textColorWell color];
	return sampleColor;
}

//Get BG Colour
- (NSColor *)getBGColor
{
	NSColor *sampleColor;
	sampleColor = [bgcolorWell color];
	return sampleColor;
}

//Get Overlay Colour
- (NSColor *)getOverlayColor
{
	NSColor *sampleColor;
	sampleColor = [overlayColorWell color];
	return sampleColor;
}

//get Shadow Display
- (int)shadowDisplay;
{
	if ([shadowCheckBox state] == 0)
		return 1;
	else
		return 0;
}

//set Slider Value
-(void)setSliderValue:(float)i
{
	[widthSlider setMinValue:i];
}


- (IBAction)updateBGCanvas:(id)sender;
{
	NSImage* compositeImage = [[NSImage alloc] initWithSize:NSMakeSize(1,1)];
	
	[compositeImage lockFocus]; {
		
		//Creates the Graphic
		NSRect theRect = NSMakeRect(0,0,1,1);
		NSBezierPath *thePath = [NSBezierPath bezierPathWithRect:theRect];
		
		//Background: Draw
		[[self getBGColor] set];
		[thePath fill];
	} [compositeImage unlockFocus];

	[bgCanvas setImage:compositeImage];
	[compositeImage release];
}

- (IBAction)updateCanvas:(id)sender
{
	[imageController drawImage];
	[imageCanvas setImage:[imageController finalImage]];
	[[imageController finalImage] release];
	[documentWindow setDocumentEdited:YES];
	[self updateChangeCount:NSChangeDone];
	
	[positionTextField setStringValue:[NSString stringWithFormat:@"%f", [fontPosxStepper intValue]]];
	[verticalTextField setStringValue:[NSString stringWithFormat:@"%f", [fontPosStepper intValue]]];
	[opacityTextField setStringValue:[NSString stringWithFormat:@"%f", [opacitySlider floatValue]]];
	[widthTextField setStringValue:[NSString stringWithFormat:@"%f", [widthSlider intValue]]];
	[scaleTextField setStringValue:[NSString stringWithFormat:@"%f", [scaleSlider floatValue]]];

}

- (float)buttonSize
{
	return [scaleSlider floatValue];
}

- (float)buttonOpacity
{
	return [opacitySlider floatValue];
}


- (int)buttonWidth
{
	return [widthSlider intValue];
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	[self updateCanvas:self];
}


-(void)exportPopUpAction:(id)sender
{
	//NSString *path = [[documentWindow title] stringByDeletingLastPathComponent];
	//NSString *currentExtension = [sender titleOfSelectedItem];
	//path = [NSString stringWithFormat:@"%@.%@", path, currentExtension];
	if ([exportPopUp indexOfSelectedItem] == 0) {
		[sp setRequiredFileType:(@"png")];}
	else{
		[sp setRequiredFileType:(@"jpg")];
		}
		//[sp setRequiredFileType:[sender titleOfSelectedItem]]; //we could use this if the text in the popup was lowercase.
}

////Export Image as JPG
- (IBAction)exportImageAs:(id)sender
{
	int result;
	
	//Save as Image
    sp = [NSSavePanel savePanel];
	[sp setAccessoryView:saveOptionView];
	[sp setCanSelectHiddenExtension:YES];
	//[sp setRequiredFileType:[exportPopUp titleOfSelectedItem]];
		if ([exportPopUp indexOfSelectedItem] == 0) {
		[sp setRequiredFileType:(@"png")];}
	else{
		[sp setRequiredFileType:(@"jpg")];
		}
	result = [sp runModalForDirectory:NSHomeDirectory() file:[documentWindow title]];
	
	 if (result == NSOKButton) {
		
		if ([exportPopUp indexOfSelectedItem] == 0) {
		NSBitmapImageRep *imagePNG = [[NSBitmapImageRep alloc] initWithData:[[imageController finalImage] TIFFRepresentation]];
		NSNumber *ditherTransparency = [NSNumber numberWithBool:YES]; 
		NSDictionary *propertyDict = [NSDictionary dictionaryWithObject:ditherTransparency forKey:NSImageInterlaced];
		NSData *dataPNG = [imagePNG representationUsingType:NSPNGFileType properties:propertyDict];
		
		[dataPNG writeToFile:[sp filename] atomically:YES];
		[imagePNG release];
		}
			
	else {
		
	//Create the button with BG
	NSBitmapImageRep *image2 = [[NSBitmapImageRep alloc] initWithData:[[imageController finalImage] TIFFRepresentation]];
	NSImage* compositeImage = [[NSImage alloc] initWithSize:NSMakeSize([image2 size].width,[image2 size].height)];
	
	[compositeImage lockFocus]; 
		{
		//Creates the Graphic
		NSRect theRect = NSMakeRect(0,0,[image2 size].width,[image2 size].height);
		NSBezierPath *thePath = [NSBezierPath bezierPathWithRect:theRect];
		
		//Background: Draw
		[[self getBGColor] set];
		[thePath fill];
		
		[[imageController finalImage] dissolveToPoint: NSMakePoint(0,0) fraction:(1.0)];
		
		}
	[compositeImage unlockFocus];
	
	//Export Code
		NSBitmapImageRep *image = [[NSBitmapImageRep alloc] initWithData:[compositeImage TIFFRepresentation]];
		//NSNumber *quality = 95;
		NSDictionary *jpegProperties = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.9] forKey:NSImageCompressionFactor];
		NSData *data = [image representationUsingType:NSJPEGFileType properties:jpegProperties];
		[data writeToFile:[sp filename] atomically:YES];
		[image release];
	}
	}
}

//Launch: WindowController has loaded
- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
	
	//Toolbar:
	NSToolbar *toolbar = [[[NSToolbar alloc] initWithIdentifier: ToolbarIdentifier] autorelease];
    [toolbar setAllowsUserCustomization: YES];
    [toolbar setAutosavesConfiguration: YES];
    [toolbar setDisplayMode: NSToolbarDisplayModeIconAndLabel];
    [toolbar setDelegate: self];
    [documentWindow setToolbar: toolbar];


	//Sets up the interface on load document:)
	if (loadedData)
	{
		NSColor *tempTextColor = [NSUnarchiver unarchiveObjectWithData:[loadedData objectForKey:@"textColor"]];
		NSColor *tempOverlayColor = [NSUnarchiver unarchiveObjectWithData:[loadedData objectForKey:@"overlayColor"]];
		NSColor *tempBGColor = [NSUnarchiver unarchiveObjectWithData:[loadedData objectForKey:@"bgColor"]];
		
		[widthSlider setFloatValue:[[loadedData objectForKey:@"buttonWidth"] floatValue]];
		[captionTextView setStringValue:[loadedData objectForKey:@"captionText"]];
		[themeHandler setRowNumber:[[loadedData objectForKey:@"selectedTheme"] intValue]];
		currentFont = [NSFont fontWithName:[loadedData objectForKey:@"fontName"] size:[[loadedData objectForKey:@"fontSize"]floatValue]];
		[textColorWell setColor:tempTextColor];
		[shadowCheckBox setIntValue:[[loadedData objectForKey:@"shadowDisplay"] intValue]];
		[overlayColorWell setColor:tempOverlayColor];
		[fontPosStepper setIntValue:[[loadedData objectForKey:@"fontYPos"] intValue]];
		[scaleSlider setFloatValue:[[loadedData objectForKey:@"buttonSize"] floatValue]];
		[opacitySlider setFloatValue:[[loadedData objectForKey:@"buttonOpacity"] floatValue]];
		[bgcolorWell setColor:tempBGColor];
		[self updateCanvas:self];
		[self updateBGCanvas:self];
	}

	[documentWindow setDocumentEdited:NO];
	[self updateChangeCount:NSChangeCleared];

}

//////////////////////////////////////////////////////
//
// Font Stuff
//
///////////////////////////////////////////////////////

////Open Font Panel
- (void)setFont:(id)sender
{
	[[NSFontManager sharedFontManager] setSelectedFont:[NSFont fontWithName:[self getFontName] size:[self getFontSize]] isMultiple:NO];
	[[NSFontManager sharedFontManager] orderFrontFontPanel:self];
	[[NSFontPanel sharedFontPanel] makeKeyAndOrderFront:sender];
}

////Accessor method to change currentFont
- (void)changeFont:(id)fontManager
{ 
	NSFont *newFont;
    [currentFont release];
	newFont=[NSFont userFontOfSize:nil];
    currentFont = [fontManager convertFont:newFont];
	[self updateCanvas:self];
}

////Get Font Name
- (NSString *)getFontName
{
	if ([currentFont fontName] != nil)
		return [currentFont fontName];
	else
		return @"Lucida Grande Bold";
}

////Get's Font Size
- (float)getFontSize
{
		return [currentFont pointSize];
}

//get's the value from the FontPosStepper
- (int)getFontPos
{
 return [fontPosStepper intValue];
}

- (int)getFontPosx
{
	if ([fontPos indexOfSelectedItem] == 0)
		return 4 + [fontPosxStepper intValue];
	else if ([fontPos indexOfSelectedItem] == 1)
		return 2 + [fontPosxStepper intValue];
	else
		return 1 - [fontPosxStepper intValue];
}

//////////////////////////////////////////////////////
//
// MultiDocument Stuff Starts Here
//
///////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    if (self) {
		}
    return self;
}

- (NSString *)windowNibName
{
 	return @"MyDocument";
}



//Save File Methods
- (void)encodeWithCoder:(NSCoder *)coder
{
		NSData *textColorData = [NSArchiver archivedDataWithRootObject:[self getTextColor]];
		NSData *overlayColorData = [NSArchiver archivedDataWithRootObject:[self getOverlayColor]];
		NSData *bgColorData = [NSArchiver archivedDataWithRootObject:[self getBGColor]];
		
		saveData = [[NSMutableDictionary alloc] 
		initWithObjectsAndKeys:
		[NSNumber numberWithFloat:[widthSlider floatValue]], @"buttonWidth",
		[captionTextView  stringValue], @"captionText",
		[NSNumber numberWithInt:[themeHandler getRowNumber]],@"selectedTheme",
		[self getFontName],@"fontName",
		[NSNumber numberWithFloat:[self getFontSize]], @"fontSize",
		textColorData,@"textColor",
		[NSNumber numberWithInt:[shadowCheckBox intValue]],@"shadowDisplay",
		overlayColorData,@"overlayColor",
		[NSNumber numberWithInt:[fontPosStepper intValue]],@"fontYPos",
		[NSNumber numberWithFloat:[scaleSlider floatValue]], @"buttonSize",
		[NSNumber numberWithFloat:[opacitySlider floatValue]], @"buttonOpacity",
		bgColorData,@"bgColor",
		nil];
		
	[coder encodeObject:saveData];
	[saveData release];
}

- (NSData *)dataRepresentationOfType:(NSString *)aType
{
	NSData *dataRepresentation = nil;
	dataRepresentation = [NSArchiver archivedDataWithRootObject:self];
	[documentWindow setDocumentEdited:NO];
	return dataRepresentation;
}


//Load File Methods
-initWithCoder:(NSCoder *)coder
{
	saveData = [[coder decodeObject] retain];
	return saveData;
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType
{
	loadedData = [NSUnarchiver unarchiveObjectWithData:data];
	return YES;
}

//////////////////////////////////////////////////////
//
// Toolbar Code starts here 
//
///////////////////////////////////////////////////////
//We layout the toolbars here
- (NSToolbarItem *) toolbar: (NSToolbar *)aToolbar itemForItemIdentifier: (NSString *) itemIdent willBeInsertedIntoToolbar:(BOOL) willBeInserted {
    NSToolbarItem *toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier: itemIdent] autorelease];
  
      if ([itemIdent isEqualToString:Item1ToolbarItemIdentifier]) {
        [toolbarItem setLabel: @"Theme"];
        [toolbarItem setPaletteLabel: @"Theme"];
        [toolbarItem setImage: [NSImage imageNamed: @"themes.png"]];
        [toolbarItem setTarget: self];
        [toolbarItem setAction: @selector(toggleThemeWindow:)];
   	} else if ([itemIdent isEqual: Item2ToolbarItemIdentifier]) {
        [toolbarItem setLabel: @"Font"];
        [toolbarItem setPaletteLabel: @"Font"];
        [toolbarItem setImage: [NSImage imageNamed: @"font.png"]];
        [toolbarItem setTarget: self];
        [toolbarItem setAction: @selector(setFont:)];
	} else if ([itemIdent isEqual: Item3ToolbarItemIdentifier]) {
        [toolbarItem setLabel: @"Export"];
        [toolbarItem setPaletteLabel: @"Export"];
        [toolbarItem setImage: [NSImage imageNamed: @"export.png"]];
        [toolbarItem setTarget: self];
        [toolbarItem setAction: @selector(exportImageAs:)];
	} else if ([itemIdent isEqual: Item4ToolbarItemIdentifier]) {
        [toolbarItem setLabel: @"Options"];
        [toolbarItem setPaletteLabel: @"Options"];
        [toolbarItem setImage: [NSImage imageNamed: @"hud.png"]];
        [toolbarItem setTarget: self];
        [toolbarItem setAction: @selector(showOptionsWindow:)];
    } else { 
        toolbarItem = nil;
    }
    return toolbarItem;
}

//The defualt Toolbar Setup
- (NSArray *) toolbarDefaultItemIdentifiers: (NSToolbar *)aToolbar {
    return [NSArray arrayWithObjects: 
    Item1ToolbarItemIdentifier, 
    NSToolbarSeparatorItemIdentifier, 
    Item2ToolbarItemIdentifier,
    Item3ToolbarItemIdentifier, 
	NSToolbarFlexibleSpaceItemIdentifier,
	Item4ToolbarItemIdentifier, 
	nil];
}

//Customize sheet
- (NSArray *) toolbarAllowedItemIdentifiers: (NSToolbar *)aToolbar {
    return [NSArray arrayWithObjects: 
    Item1ToolbarItemIdentifier, 
    Item2ToolbarItemIdentifier,
    Item3ToolbarItemIdentifier,
    NSToolbarCustomizeToolbarItemIdentifier, 
    NSToolbarFlexibleSpaceItemIdentifier, 
    NSToolbarSpaceItemIdentifier, 
    NSToolbarSeparatorItemIdentifier, nil];
}

@end