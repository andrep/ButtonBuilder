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

#import "BBImageController.h"
#import "BBThemeHandler.h"
#import "MyDocument.h"

//***************************************************************************

@implementation BBImageController

- (void)dealloc
{
	[compositeImage release];
	
	[super dealloc];
}

- (void) drawImage 
{
	// Load buttons from theme handler
	NSImage* workingRepLeft = [themeHandler getLeftImage];
	NSImage* workingRepMiddle = [themeHandler getMiddleImage];
	NSImage* workingRepRight = [themeHandler getRightImage];
	
	int buttonHeight = [workingRepLeft size].height;
	int buttonWidth = [workingRepLeft size].width;
	
	//makes sure the width slider's minimum is set correctly
	[documentController setSliderValue:[workingRepLeft size].width+[workingRepLeft size].width+1];

	compositeImage = [[NSImage alloc] initWithSize:NSMakeSize([documentController buttonWidth],[workingRepLeft size].height)];
	[compositeImage lockFocus];
	{
		//Background: Draw
		NSRect theRect = NSMakeRect(0,0,[documentController buttonWidth],[workingRepLeft size].height);
		NSBezierPath *thePath = [NSBezierPath bezierPathWithRect:theRect];
		[[NSColor colorWithCalibratedRed:0 green:0 blue:100 alpha:0.0] set];
		[thePath fill];
		
		[[NSGraphicsContext currentContext] setImageInterpolation: NSImageInterpolationHigh];
		
		[workingRepLeft dissolveToPoint: NSMakePoint(0,0) fraction:([documentController buttonOpacity])];
		[workingRepRight dissolveToPoint: NSMakePoint([documentController buttonWidth]- [workingRepRight size].width,0) fraction:([documentController buttonOpacity])];
		
		NSImage* tempImage = workingRepMiddle;
		[tempImage setScalesWhenResized:YES];
		NSSize newSize;
		newSize.width = [documentController buttonWidth]-buttonWidth*2;
		newSize.height = buttonHeight;
		[tempImage setSize:newSize];
		[workingRepMiddle dissolveToPoint: NSMakePoint([workingRepLeft size].width,0) fraction:([documentController buttonOpacity])];
		
	
		//Colour Effect
		NSRect sourceRect2 = NSMakeRect(0,0,[documentController buttonWidth],buttonHeight); 
		[[documentController getOverlayColor] set];
		NSRectFillUsingOperation(sourceRect2, NSCompositeSourceAtop);
		
		
		///////////////////////////////
		// Text Stuff Below
		///////////////////////////////
		
		//Text: Size & Font
		NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
		[attributes setObject:[NSFont fontWithName:[documentController getFontName] size:[documentController getFontSize]] forKey:NSFontAttributeName];
		
		//Get Text Colour
		[attributes setObject:[documentController getTextColor] forKey:NSForegroundColorAttributeName];
		
		//Get Caption
		NSString *theString = [documentController getCaption];

		//Text: Position
		NSPoint theTextPos;
		NSSize stringSize;
		stringSize = [theString sizeWithAttributes:attributes];
		theTextPos.x = 0 + ([documentController buttonWidth] - stringSize.width)/2;
		theTextPos.y = 0 + (buttonHeight - stringSize.height)/2 + [documentController getFontPos];
		
		if ([documentController shadowDisplay] == 0){
			//Text: Shadow
			NSShadow* theShadow = [[NSShadow alloc] init];
			[theShadow setShadowOffset:NSMakeSize(0, -2.0)];
			[theShadow setShadowBlurRadius:3];
			[theShadow setShadowColor: [NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0.6] ];
			[attributes setObject:theShadow forKey:NSShadowAttributeName];

			//Text: Draw
			[theString drawAtPoint:theTextPos withAttributes:attributes];
			[theShadow release];}
		else{
			[theString drawAtPoint:theTextPos withAttributes:attributes];
		}
		
		//Release used objects from memory
		[workingRepLeft release];
		[workingRepRight release];
		[workingRepMiddle release];
		
	}
	[compositeImage unlockFocus];
}


//Sends back the final image and scales it here too
- (NSImage*) finalImage; 
{
	//use this to scale the graphic before sending it to the ImageController	
	NSImage* scaleThisImage = compositeImage;
	NSImageRep *workingRep = [scaleThisImage bestRepresentationForDevice:nil];
	
	NSImage* finalImage = [[NSImage alloc] initWithSize:NSMakeSize([workingRep size].width* [documentController buttonSize],[workingRep size].height* [documentController buttonSize])];


	[finalImage lockFocus];
	{
	[[NSGraphicsContext currentContext] setImageInterpolation: NSImageInterpolationHigh];
	[workingRep drawInRect:NSMakeRect(0,0,[workingRep size].width * [documentController buttonSize],[workingRep size].height* [documentController buttonSize])];
	}
	[finalImage unlockFocus];
	
	NSString *myString = [NSString stringWithFormat:@"%ix%i Pixels",(int)[finalImage size].width,(int)[finalImage size].height];
	[sizeTextField setStringValue: myString];

	return finalImage;
    //return compositeImage;
}

@end

//***************************************************************************
