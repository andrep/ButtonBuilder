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



//***************************************************************************

-(void)awakeFromNib 
{
	
	// copy the application support if it doesn't already exist
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    if (![myFileManager fileExistsAtPath:[@"~/Library/Application Support/Button Builder/" stringByExpandingTildeInPath]]) {
        [myFileManager copyPath:[NSString stringWithFormat:@"%@/Contents/Resources/Plugins",[[NSBundle mainBundle] bundlePath]] toPath:[@"~/Library/Application Support/Button Builder/" stringByExpandingTildeInPath] handler:nil];
    }

	[themeHandler loadThemes];
	[themeWindow toggle:self];
	
	//Calls the refresh canvas action
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(updateCanvas:) name:NSControlTextDidChangeNotification object:captionTextView];
	
	//Shows the Transparency Slider
	[[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
	
	currentFont = [NSFont fontWithName:@"Lucida Grande Bold" size:24.0];
	[self updateCanvas:self];
	[self updateBGCanvas:self];
	
	//PUT UPDATE CODE HERE FOR CANVAS
	[documentWindow setContentSize:NSMakeSize(490,350)];
	
}

- (void)toggleThemeWindow:(id)sender
{
	[themeWindow toggle:self];
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

//Show Captions Window
- (void)showCaptionWindow:(id)sender
{
    [NSApp beginSheet:captionWindow
    modalForWindow:documentWindow
    modalDelegate:self
    didEndSelector:nil
    contextInfo:nil];
}

- (IBAction)hideCaptionWindow:(id)sender
{
    [NSApp endSheet:captionWindow];
    [captionWindow orderOut:nil];
}

//Show Options Window
- (void)showOptionsWindow:(id)sender
{
    [NSApp beginSheet:optionsWindow
    modalForWindow:documentWindow
    modalDelegate:self
    didEndSelector:nil
    contextInfo:nil];
}

- (IBAction)hideOptionsWindow:(id)sender
{
    [NSApp endSheet:optionsWindow];
    [optionsWindow orderOut:nil];
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

@end

//////////////////////////////////////////////////////
//
// Toolbar Code starts here 
//
///////////////////////////////////////////////////////
//We layout the toolbars here



//***************************************************************************
