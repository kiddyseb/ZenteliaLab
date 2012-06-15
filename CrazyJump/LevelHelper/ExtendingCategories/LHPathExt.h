//  This file is part of LevelHelper
//  http://www.levelhelper.org
//
//  Created by Bogdan Vladu
//  Copyright 2011 Bogdan Vladu. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//  The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//  Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//  This notice may not be removed or altered from any source distribution.
//  By "software" the author refers to this code file and not the application 
//  that was used to generate this file.
//  You do not have permission to use this code or any part of it if you don't
//  own a license to LevelHelper application.
////////////////////////////////////////////////////////////////////////////////

#import "LevelHelperLoader.h"

@interface LevelHelperLoader (PATH_EXTENSION) 

//------------------------------------------------------------------------------
//ALL METHODS ARE DEPRECATED
//SEE LHSprite.h for exactly the same methods but easier to use
//------------------------------------------------------------------------------

-(void) pausePathMovement:(bool)pauseStatus ofSprite:(LHSprite*)ccsprite NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
-(void) cancelPathMovementForSprite:(LHSprite*)sprite NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);

//in case you want a notifier for a specific sprite only. The notifier signature should be the same as above.
//this will cancel the normal notifier for all the paths.
-(void) registerNotifierOnPathEndPoints:(id)obj selector:(SEL)sel forSprite:(LHSprite*)spr NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);

-(void) moveSpriteWithUniqueName:(NSString*)sprName onPathWithUniqueName:(NSString*)pathUniqueName 
						   speed:(float)pathSpeed 
				 startAtEndPoint:(bool)startAtEndPoint
						isCyclic:(bool)isCyclic
			   restartAtOtherEnd:(bool)restartOtherEnd
                 axisOrientation:(int)axis
                           flipX:(bool)flipx
                           flipY:(bool)flipy
                   deltaMovement:(bool)dMove NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);

-(void) pausePathMovement:(bool)pauseStatus ofSpriteWithUniqueName:(NSString*)sprName NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
-(void) cancelPathMovementForSpriteWithUniqueName:(NSString*)spriteName NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
-(void) registerNotifierOnPathEndPoints:(id)obj selector:(SEL)sel forSpriteWithUniqueName:(NSString*)name NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
@end	
