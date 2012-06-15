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

@interface LevelHelperLoader (CONVERSION_EXTENSION) 

//you will have to call this before initWithContentOfFile if you dont want retina
//[LevelHelperLoader useRetinaOnIpad:false];
//call this on Mac also with true to use retina
+(void) useRetinaOnIpad:(bool)value;

//this will convert level to the used device
//by default convertLevel is TRUE
//only call this method to deactivate the convert level option
+(void) convertLevel:(bool)value;

//return the conver ratio for current level
-(CGPoint) convertRatio; 

-(void) updateConversionRatio; //helper method for Scene Tester
+(void) setCustomAlphaOnAll:(float)value; //helper method for Scene Tester

-(CGRect) processedUVRectFromSpriteProperty:(NSDictionary*)spriteProp;
@end	
