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

//***************************************************************************

@interface BBThemeHandler : NSObject
{	
	IBOutlet id  documentController; //MyDocument
		
    IBOutlet id themeTableView;
	NSMutableArray *themeArray;
    NSFileManager *myfilemanager;
}

//---------------------------------------------------------------------------

- (void) loadThemes;
- (int) getRowNumber;
- (void) setRowNumber:(int)i;
- (NSImage*) getLeftImage;
- (NSImage*) getMiddleImage;
- (NSImage*) getRightImage;

@end

//***************************************************************************
