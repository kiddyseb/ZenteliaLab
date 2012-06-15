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
#import "LHJoint.h"
@interface LevelHelperLoader (JOINTS_EXTENSION) 

-(b2Joint*) box2dJointWithUniqueName:(NSString*)name;

/*
 returns NSMutableArray containing NSValue valueWithPoints:b2Joint
 //Example of use
 for(NSValue* val in arrayReturned)
 {
    b2Joint* joint = (b2Joint*)[val pointerValue];
 }
 */
-(NSArray*) box2dJointsWithTag:(enum LevelHelper_TAG)tag;

//this method will return -1 if fail
+(int) tagForJoint:(b2Joint*)joint;
//this method will return LH_UNKNOWN_TYPE if fail
+(enum LH_JOINT_TYPE) typeForJoint:(b2Joint*)joint;
+(NSString*) uniqueNameForJoint:(b2Joint*)joint;

-(bool) removeJointWithUniqueName:(NSString*)name;
@end	
