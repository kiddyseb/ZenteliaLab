//  This file is part of LevelHelper
//  http://www.levelhelper.org
//
//  LHConversion.mm
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
#import "LHConversionExt.h"
#import "LHSettings.h"

@implementation LevelHelperLoader (CONVERSION_EXTENSION)
////////////////////////////////////////////////////////////////////////////////
+(void) useRetinaOnIpad:(bool)value
{
	[[LHSettings sharedInstance] setUseRetinaOnIpad:value];
}
////////////////////////////////////////////////////////////////////////////////
+(void) convertLevel:(bool)value
{
	[[LHSettings sharedInstance] setConvertLevel:value];
}
////////////////////////////////////////////////////////////////////////////////
-(CGPoint) convertRatio
{
    return [[LHSettings sharedInstance] convertRatio];
}
////////////////////////////////////////////////////////////////////////////////
-(void) updateConversionRatio
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	[[LHSettings sharedInstance] setConvertRatio:CGPointMake(winSize.width/safeFrame.x, 
                                                             winSize.height/safeFrame.y) 
                                  usesCustomSize:NO];	
}
////////////////////////////////////////////////////////////////////////////////
+(void) setCustomAlphaOnAll:(float)value
{
	[[LHSettings sharedInstance] setCustomAlpha:value];
}
////////////////////////////////////////////////////////////////////////////////
-(CGRect) processedUVRectFromSpriteProperty:(NSDictionary*)spriteProp
{
    CGRect uv = LHRectFromString([spriteProp objectForKey:@"UV"]);
    
    if([[LHSettings sharedInstance] isIpad])
    {
        uv.origin.x *=2.0f;
        uv.origin.y *=2.0f;
        uv.size.width *=2.0f;
        uv.size.height *=2.0f;
    }
	
    return uv;
}
////////////////////////////////////////////////////////////////////////////////
@end
