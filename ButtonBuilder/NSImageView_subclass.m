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

#import "NSImageView_subclass.h"

//***************************************************************************

@implementation NSImageView_subclass

/*"	This subclass of NSImageView exists to force an image to display at full size (not scale when resized), and to force the image to be an even number of pixels high and tall so that the image doesn't "blur" in order to stay perfectly centered within a resizeable superview.  To work as expected, this view should be right inside another custom view, so that attempts to resize the view just get the superview's size.
"*/

/* Override of setImage makes sure that the image is an even number of pixels wide and high, and that it doesn't scale when resized.
*/

- (void)setImage:(NSImage*)inImage
{
	NSSize theSize = [inImage size];
	if (0 != ((int)theSize.width  % 2)) { theSize.width ++; }
	if (0 != ((int)theSize.height % 2)) { theSize.height++; }
	[inImage setScalesWhenResized:NO];	// make the image larger by 1 pixel without rescaling
	[inImage setSize:theSize];

	[super setImage: inImage];	// store the main image
	NSLog (@"Setimage");
}

/* Override to force the size to be an even number of pixels.  View should be right inside of another custom view, so to just size the view to be as big as the superview.
*/

- (void)resizeWithOldSuperviewSize:(NSSize)oldFrameSize
{
	NSRect tSuperRect=[[self superview] frame];
	if (0 != ((int)tSuperRect.size.width  % 2)) { tSuperRect.size.width --; }
	if (0 != ((int)tSuperRect.size.height % 2)) { tSuperRect.size.height--; }

	[self setFrame:tSuperRect];
	NSLog (@"Resize");
}

@end

//***************************************************************************
