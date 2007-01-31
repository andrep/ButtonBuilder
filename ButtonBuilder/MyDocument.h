//***************************************************************************

/* Copyright (C) 2002-2007 Realmac Software Limited <dan.counsell@realmacsoftware.com>
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU Lesser General Public License as published by
* the Free Software Foundation; either version 2.1 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*/

//***************************************************************************

#import <Cocoa/Cocoa.h>

@interface MyDocument : NSDocument
{
	//Windows
	IBOutlet NSWindow   *documentWindow;
	IBOutlet id themeWindow;
	IBOutlet id captionWindow;
	IBOutlet id optionsWindow;
	IBOutlet id saveOptionView;
	
	//Controllers
	IBOutlet id imageController; //BBImageController
	IBOutlet id themeHandler; //BBThemeHandler
	
	//Interface Controls
	IBOutlet id imageCanvas;
	IBOutlet id bgCanvas;
	IBOutlet id scaleSlider;
	IBOutlet id widthSlider;
	IBOutlet id captionTextView;
	IBOutlet id textColorWell;
	IBOutlet id overlayColorWell;
	IBOutlet id bgcolorWell;
	IBOutlet id shadowCheckBox;
	IBOutlet id fontPosStepper;
	IBOutlet id opacitySlider;
	IBOutlet id	exportPopUp;
	NSMutableDictionary *saveData;
	NSWindow *loadedData;
	
	NSSavePanel *sp;
	
	NSMutableDictionary *fontAttributes;
	NSFont *currentFont;
}

- (IBAction)updateCanvas:(id)sender;
- (IBAction)updateBGCanvas:(id)sender;
- (IBAction)exportImageAs:(id)sender;
- (IBAction)hideCaptionWindow:(id)sender;
- (IBAction)hideOptionsWindow:(id)sender;
- (IBAction)exportPopUpAction:(id)sender;

- (void)toggleThemeWindow:(id)sender;
- (void)showCaptionWindow:(id)sender;
- (void)showOptionsWindow:(id)sender;
- (void)refreshCanvas:(id)sender;
- (float)buttonSize;
- (float)buttonOpacity;
- (int)buttonWidth;
- (NSString *)getCaption;
- (NSColor *)getTextColor;
- (NSColor *)getOverlayColor;
- (NSColor *)getBGColor;
- (void)changeFont:(id)fontManager;
- (void)setFont:(id)sender;
- (float)getFontSize;
- (NSString *)getFontName;
- (int)shadowDisplay;
- (void)setSliderValue:(float)i;
- (int)getFontPos;
	
@end

