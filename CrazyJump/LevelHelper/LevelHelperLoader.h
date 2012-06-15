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
//
//  Version history
//  ...............
//  v0.1 First version for LevelHelper 1.4
//  ....
//  v1.1 29Dec11 - added support for beginEnd contact in the collision handling 
//               - most of the times this is what you need to use
//               - sprites created dynamically are now referenced by LH in order
//               - to not have a crash when you replace the scene if you forget to remove those sprites
//               - added markSpriteForRemoval, removeMarkedSprites in order to remove a sprite while in contact
//                 Usage: - while in a callback for a collision call [loader markSpriteForRemoval:sprite];
//                 then call [loader removeMarkedSprites] at the end of tick method
//  v1.1.1 4iJan12- fixed some collision related issues
//  v1.2 4 Jan 12 - added new methods in LHSprite, LHBezierNode, LHParallaxNode
//               - marked as deprecated methods that will be removed in the future.
//               - read comments on each methods to see what you have to use instead
//  v1.2.1 - Added support for an animation to start from a specific frame
//  v1.3 - added support for custom LHSprite classes - see API Documentation
//         new file was required - include LHCustomSpriteMgr.h in your LevelHelper/Nodes folder
//  v1.4 - Fixed LHBezierNode - better drawing, retina ratio fixed, better box2d fixtures
//  v1.5 - Better drawing in LHBezierNode, added blending methods BezierNode (see API Documentation)
//         added removing of Parallax Nodes with child sprites
//         fixed warnings caused by extending categories
//  v1.6 - added TOUCH EVENT Handling - see API Documentation - add new file LHTouchMgr to your project
//  v1.6.1 - Fixed a touch issue when changing an animation on a sprite.
//  v1.6.2 - Fixed recursion in LHSprite caused by CCSprite design
//           Fixed LHSprite not getting released because it was retained by touch events
//           Fixed LHBezierNode not getting released because it was retained by touch events
//  v1.6.3 - Added ability to swallow touches for tag - see LHTouchMgr
//           Added ability to set priority of touches - see LHTouchMgr
//  v1.7   - Full support for ARC. Just enable ARC in your project and everything should work.
//           Fixed bezier tile shape box2d assert in special cases
//  v1.7.1 23Jan12 Fixed an issue with markedSprite: removeMarkedSprites
//  v1.7.2 25Jan12 Deprecated paralaxNodeWithUniqueName and added parallaxNodeWithUniqueName (2 ll)
//
//  v1.8  25Jan12   -Added bezierA, bezierB in LHContactInfo
//                  -Added jointList in LHSprite
//                  -Added markJointForRemoval markJointsOnSpriteForRemoval markBezierForRemoval 
//                  in order to safely remove this objects while in contact 
//                  -Added postInitialization in LHSprite to use with custom sprite classes after complete init
//                  -Fixed removal of LHJoint when removing a sprite durring gameplay
//  v1.8.1 26Jan 12 -Added (LHJoint*) jointWithUniqueName:(NSString*)name;
//							-(bool) removeAllAttachedJoints;
//							-(bool) removeJoint:(LHJoint*)jt;
//					inside LHSprite.h (see comments)
//  v1.9   28Jan 12 -Added support for mouse events on Mac
//  v1.9.1 30Jan 12 -Added newPhysical methods with scale for the body since scale is the only property that you cannot change after
//                   construction of the body (this was also a request)
//  v2.0  31Jan 12 - Updated Touch Events on LHSprite to support the movement of the CCLayer
//                 - Changed implementation on newPhysical with scale support 
//  v2.1 01Feb 12  - Fixed dontStretchArtOnIpad issue with beziers
//                 - Fixed touches not getting swallowed on sprites and beziers
//                 - Fixed a certain collision manager issue where in certain conditions callback was not called
//                 - Added ability to add any type of CCNode subclass object (e.g. CCSprite, CCParticleSystemQuad) to a LHParrallaxNode
//  v2.1.1 01Feb 12- Fixed shape border scale issue
//  v2.2   06Feb 12- Fixed LHJoint for ARC
//                   spriteWithUniqueName now returns LHSprite instead of id
//                   Added warning for removeFromParentAndCleanUp - it should not be used - use [loader removeSprite:sprite] or [sprite removeSelf];
//                   Fixed parallaxnode release when using your own custom ccnodes in it.
//  v2.5   10Feb 12- Now sprites that have "Handled By SH" activated are loaded from the spritehelper scene - this makes saving the level after you modified
//                   a spritehelper scene not needed anymore
//                   Continuos Parallax Scrolling has more FPS now. (tested with iPhone2G and a very big parallax - got it running from 8fps to 22fps)
//                 - Addded spritesWithTag ordered - returned array will be ordered by sprite unique name as you choose
//                 - Image subfolder is not kept in LHSettings anymore (request)
//                 - Added support for move path with delta and start path movement at launch
//                 - Added following methods (see example of usage near the method declaration)
//                  -(LHSprite*) newSpriteWithName:(NSString*)name fromSpriteHelperScene:(NSString*)sceneName;
//                  -(LHSprite*) newBatchSpriteWithName:(NSString*)name fromSpriteHelperScene:(NSString*)sceneName;
//                  -(LHSprite*) newPhysicalSpriteWithName:(NSString*)name fromSpriteHelperScene:(NSString*)sceneName;
//                  -(LHSprite*) newPhysicalBatchSpriteWithName:(NSString*)name fromSpriteHelperScene:(NSString*)sceneName;
// v2.5.1 23 Feb 12 - Fixed strech art on ipad when using custom screen size
// v2.5.2 03 Mar 12 - Fixed startAtLaunch path movement
//                  - Added following methods in LHSprite class
//                              -(void)setCollisionFilterCategory:(int)category;
//                              -(void)setCollisionFilterMask:(int)mask;
//                              -(void)setCollisionFilterGroup:(int)group;
//                              -(void)makeDynamic;
//                              -(void)makeStatic;
//                              -(void)makeKinematic;

// v2.5.3 05 Mar 12 - Fixed touch handling with new sprites that dont use batch nodes.
//                  - Added support for touches on sprite to NOT use the physic shape if thats what you want.
//                  - Changed NSMutableArray to CCArray in the parallax implementation - better performance
//                  - fixed visibility issue caused by parallax implementation
//                  - Added new methods in order to be able to create new custom type sprites 
//                         see comments in this file in the new section
//                  - deprecated some methods because of warnings when using ARC - new methods were renamed from
//                       newSprite ... to createSprite...
// v2.5.4 06 Mar 12 - Fixed path movement for sprites that are inside a parallax node
// v2.5.4.1 07 Mar 12 - added check for unsaved levels to work with new 1.4.7 version of LH
// v2.6 16 Mar 12 - Added Physic Cutting Engine
//                - Fixed bug for touch on tag
//                - Fixed bug for touch on tag not getting released
//                - Updated code for Cocos2d 2.0 (latest version)
// v2.6.1 18 Mar 12 - Fixed createSprite fromSpriteHelperScene - crashing when using sprites with quad shapes
//                  - Fixed ARC issue in LHSprite.h
// v2.6.2 18 Mar 12 - Fixed ARC issues in LHCuttingEngineMgr
// v2.6.3 18 Mar 12 - Fixes all Cocos2d 2.0 deprecated methods
// v2.7   19 Mar 12 - Big update to the parallax node - this is the update you all been waithing for.
//                    It brings big speed improvement - 40FPS on iPhone2G
//                    Because parallax movement is now time based all your Continuos parallaxes speed will have to be modified
//                    Usually what used to be 0.2 now its 200 - for the speed property
// v2.7.1   21 Mar 12 - Fixed retina touches
//                  - Fixed body shape scale issue 
// v2.7.2   30 Mar 12 - Fixed crash when creating a physical sprite from a spritehelper doc
//                    - Added remove touch observer on a sprite 
// v2.7.3   28 Apr 12 - Fixed a problem where continuos parallax scrolling had sprites dissapear to early when scaling was involved
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "LHSprite.h"
#import "LHJoint.h"
#import "LHParallaxNode.h"
#import "LHBezierNode.h"
#import "LHBatch.h"
#import "LHContactNode.h"
#import "LHTouchMgr.h"
#import "LHCustomSpriteMgr.h"
#import "LHCuttingEngineMgr.h"

#if __has_feature(objc_arc) && __clang_major__ >= 3
#define LH_ARC_ENABLED 1
#endif // __has_feature(objc_arc)

enum LevelHelper_TAG 
{ 
	DEFAULT_TAG 	= 0,
	NUMBER_OF_TAGS 	= 1
};

enum LH_ACTIONS_TAGS
{
    LH_PATH_ACTION_TAG,
    LH_ANIM_ACTION_TAG
};

#if TARGET_OS_EMBEDDED || TARGET_OS_IPHONE || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64

#define LHRectFromString(str) CGRectFromString(str)
#define LHPointFromString(str) CGPointFromString(str)
#define LHPoint CGPoint
#define LHRect  CGRect
#define LHMakePoint(x, y) CGPointMake(x, y)

#else

#define LHRectFromString(str) NSRectToCGRect(NSRectFromString(str))
#define LHPointFromString(str) NSPointToCGPoint(NSPointFromString(str))
#define LHPoint NSPoint
#define LHRect NSRect
#define LHMakePoint(x, y) CGPointMake(x, y)

#endif
CGRect LHRectFromValue(NSValue* val);
NSValue* LHValueWithRect(CGRect rect);
CGPoint LHPointFromValue(NSValue* val);
NSValue* LHValueWithCGPoint(CGPoint pt);


@interface LevelHelperLoader : NSObject {
	
	NSArray* lhSprites;	//array of NSDictionary with keys GeneralProperties (NSDictionary) 
    //and PhysicProperties (NSDictionary)
	NSArray* lhJoints;	//array of NSDictionary
    NSArray* lhParallax;//array of NSDictionary 
    NSArray* lhBeziers; //array of NSDictionary
    NSArray* lhAnims;   //array of NSDictionary
    NSMutableDictionary* lhBatchInfo;//key - imageName - value NSDictionary 
	
    NSMutableDictionary* animationsInLevel; //key - uniqueAnimationName value - LHAnimation*
	NSMutableDictionary* spritesInLevel;	//key - uniqueSpriteName	value - LHSprite*
    NSMutableDictionary* jointsInLevel;     //key - uniqueJointName     value - LHJoint*
    NSMutableDictionary* parallaxesInLevel; //key - uniqueParallaxName  value - LHParallaxNode*
	NSMutableDictionary* beziersInLevel;    //key - uniqueBezierName    value - LHBezierNode*
	NSMutableDictionary* batchNodesInLevel;	//key - imageName			value - LHBatch*
    

	NSDictionary* wb; //world boundaries Info
    NSMutableDictionary* physicBoundariesInLevel; //keys//LHPhysicBoundarieTop
                                                        //LHPhysicBoundarieLeft
                                                        //LHPhysicBoundarieBottom
                                                        //LHPhysicBoundarieRight 
                                                    //value - LHSprite*    
    
    NSMutableString* imageFolder;
    NSMutableSet* markedSprites;
    NSMutableSet* markedJoints;
    NSMutableSet* markedBeziers;
    
	bool addSpritesToLayerWasUsed;
	bool addObjectsToWordWasUsed;
    
    CGPoint safeFrame;
    CGRect  gameWorldRect;
    CGPoint gravity;
	
    id  pathNotifierId;
    SEL pathNotifierSel;
    
    id      animNotifierId;
    SEL     animNotifierSel;
    bool    notifOnLoopForeverAnim;
    
    id  loadingProgressId;
    SEL loadingProgressSel;
        
	CCLayer* cocosLayer; //weak ptr
    b2World* box2dWorld; //weak ptr
    
    LHContactNode* contactNode;
}
//------------------------------------------------------------------------------
-(id) initWithContentOfFile:(NSString*)levelFile;
-(id) initWithContentOfFileFromInternet:(NSString*)webAddress;
//url can be a web address / imgFolder needs to be local
-(id) initWithContentOfFileAtURL:(NSURL*)levelURL imagesPath:(NSString*)imgFolder;
-(id) initWithContentOfFile:(NSString*)levelFile 
			 levelSubfolder:(NSString*)levelFolder;
//------------------------------------------------------------------------------

//will call this selector during loading the level (addObjectsToWorld or addSpritesToLayer)
//the registered method needs to have this signature -void loadingProgress:(NSNumber*)percentage
//percentage should be used like this [percentage floatValue] and will return a value from 0.0f to 1.0f
-(void)registerLoadingProgressObserver:(id)object selector:(SEL)selector;

//LOADING
-(void) addObjectsToWorld:(b2World*)world cocos2dLayer:(CCLayer*)cocosLayer;

//use addObjectsToWorld and set all your sprites to NO PHYSICS
//a vanilla - no box2d library required will come soon
-(void) addSpritesToLayer:(CCLayer*)cocosLayer  NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
//------------------------------------------------------------------------------
//UTILITIES
+(void) dontStretchArtOnIpad;
+(void) preloadBatchNodes; //by default LH only loads what it needs

//------------------------------------------------------------------------------
//PAUSING THE GAME
//this will pause all path movement and all parallaxes
//use  [[CCDirector sharedDirector] pause]; for everything else
+(bool)isPaused;
+(void)setPaused:(bool)value; //pass true to pause, false to unpause

//------------------------------------------------------------------------------
//COLLISION HANDLING
//see API Documentation on the website to see how to use this
-(void) useLevelHelperCollisionHandling;

//method will be called twice per fixture, once at start and once at end of the collision".
//because bodies can be formed from multiple fixture method may be called as many times as different fixtures enter in contact.

//e.g. a car enters in collision with a stone, the stone first touched the bumper, (triggers collision 1)
//then the stone enters under the car and touches the under part of the car (trigger collision 2)
-(void) registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)tagA
                                               andTagB:(enum LevelHelper_TAG)tagB
                                            idListener:(id)obj
                                           selListener:(SEL)selector;

-(void) cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)tagA
                                             andTagB:(enum LevelHelper_TAG)tagB;
              

//this methods will be called durring the lifetime of the collision - many times
-(void) registerPreCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)tagA 
                                       andTagB:(enum LevelHelper_TAG)tagB 
                                    idListener:(id)obj 
                                   selListener:(SEL)selector;

-(void) cancelPreCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)tagA 
                                      andTagB:(enum LevelHelper_TAG)tagB;

-(void) registerPostCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)tagA 
                                        andTagB:(enum LevelHelper_TAG)tagB 
                                     idListener:(id)obj 
                                    selListener:(SEL)selector;

-(void) cancelPostCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)tagA 
                                       andTagB:(enum LevelHelper_TAG)tagB;

//------------------------------------------------------------------------------
//SPRITES
//by default returns LHSprite* type but if you use CustomSpriteMgr it will return an object of the appropriate type
-(LHSprite*) spriteWithUniqueName:(NSString*)name; 
-(NSArray*)  spritesWithTag:(enum LevelHelper_TAG)tag; //returns array with LHSprite*

//sort argument 
//pass NSOrderedAscending -> sort ascending by name
//     NSOrderedSame,     -> no sort - leaves the sprites as they are found in the level
//     NSOrderedDescending-> sort descending by name
-(NSArray*)  spritesWithTag:(enum LevelHelper_TAG)tag ordered:(NSComparisonResult)sortOrder;
-(NSArray*)  allSprites;
-(bool) removeSprite:(LHSprite*)ccsprite;
-(bool) removeSpritesWithTag:(enum LevelHelper_TAG)tag;
-(bool) removeAllSprites;

//call this is you want to remove a sprite containg a physical body in one of the contact callbacks
//to actually remove the sprite call -removeMarkedSprites at the end of the tick method
-(void) markSpriteForRemoval:(LHSprite*)ccsprite;
-(void) removeMarkedSprites; //actually removes the sprites that were marked for removal



/*More methods in LHSpitesExt.h - download from http://www.levelhelper.org*/
//------------------------------------------------------------------------------
//CREATION

//New sprite and associated body will be released automatically
//or you can use removeFromParentAndCleanup:YES, CCSprite method, to do it at a specific time
//you must set the desired position after creation

//sprites returned needs to be added in the layer by you
//new sprite unique name for the returned sprite will be
//[OLDNAME]_LH_NEW__SPRITE_XX and [OLDNAME]_LH_NEW_BODY_XX

//deprecated because of warnings on ARC - use the next method
-(LHSprite*) newSpriteWithUniqueName:(NSString *)name NS_DEPRECATED(10_0, 10_4, 2_0, 2_0); //no physic body
-(LHSprite*) createSpriteWithUniqueName:(NSString *)name; //no physic body

//deprecated because of warnings on ARC - use the next method
-(LHSprite*) newPhysicalSpriteWithUniqueName:(NSString*)name NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);//with physic body
-(LHSprite*) createPhysicalSpriteWithUniqueName:(NSString*)name;

//deprecated because of warnings on ARC - use the next method
-(LHSprite*) newPhysicalSpriteWithUniqueName:(NSString *)name 
                                newBodyScale:(CGSize*)newScale NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);

-(LHSprite*) createPhysicalSpriteWithUniqueName:(NSString *)name 
                                   newBodyScale:(CGSize*)newScale;

//sprites are added in the coresponding batch node automatically
//new sprite unique name for the returned sprite will be
//[OLDNAME]_LH_NEW_BATCH_SPRITE_XX and [OLDNAME]_LH_NEW_BATCH_BODY_XX

//deprecated because of warnings on ARC - use the next method
-(LHSprite*) newBatchSpriteWithUniqueName:(NSString*)name NS_DEPRECATED(10_0, 10_4, 2_0, 2_0); //no physic body
-(LHSprite*) createBatchSpriteWithUniqueName:(NSString*)name;

//deprecated because of warnings on ARC - use the next method
-(LHSprite*) newPhysicalBatchSpriteWithUniqueName:(NSString*)name NS_DEPRECATED(10_0, 10_4, 2_0, 2_0); //with physic body
-(LHSprite*) createPhysicalBatchSpriteWithUniqueName:(NSString*)name;

//deprecated because of warnings on ARC - use the next method
-(LHSprite*) newPhysicalBatchSpriteWithUniqueName:(NSString *)name 
                                     newBodyScale:(CGSize*)newScale NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
-(LHSprite*) createPhysicalBatchSpriteWithUniqueName:(NSString *)name 
                                        newBodyScale:(CGSize*)newScale;


/*EXAMPLE
LHSprite* spr = [lh newSpriteWithName:@"SpriteNameInsideSpriteHelper" fromSpriteHelperScene:@"SpriteHeleprSceneNameWithoutExtension"];
[self addChild:spr];
[spr setPosition:location];
 //set other properties like tag here
*/

//deprecated because of warnings on ARC - use the next method
-(LHSprite*) newSpriteWithName:(NSString*)name 
         fromSpriteHelperScene:(NSString*)sceneName NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);

-(LHSprite*) createSpriteWithName:(NSString*)name 
            fromSpriteHelperScene:(NSString*)sceneName;


//use this in order to create sprites of custom types
-(LHSprite*) createSpriteWithName:(NSString*)name 
            fromSpriteHelperScene:(NSString*)sceneName tag:(LevelHelper_TAG)tag;

/*EXAMPLE
 LHSprite* spr = [lh newBatchSpriteWithName:@"SpriteNameInsideSpriteHelper" fromSpriteHelperScene:@"SpriteHeleprSceneNameWithoutExtension"];
 [spr setPosition:location];
 //set other properties like tag here
 */
//use this in order to create sprites of custom types
-(LHSprite*) newBatchSpriteWithName:(NSString*)name 
              fromSpriteHelperScene:(NSString*)sceneName NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);

-(LHSprite*) createBatchSpriteWithName:(NSString*)name 
                 fromSpriteHelperScene:(NSString*)sceneName;

//use this in order to create sprites of custom types
-(LHSprite*) createBatchSpriteWithName:(NSString*)name 
              fromSpriteHelperScene:(NSString*)sceneName 
                                tag:(LevelHelper_TAG)tag;


/*EXAMPLE
LHSprite* spr = [lh newPhysicalSpriteWithName:@"SpriteNameInsideSpriteHelper" fromSpriteHelperScene:@"SpriteHeleprSceneNameWithoutExtension"];
[self addChild:spr];
[spr transformPosition:location];
//set other properties like tag here
 */
//use this in order to create sprites of custom types
-(LHSprite*) newPhysicalSpriteWithName:(NSString*)name 
                 fromSpriteHelperScene:(NSString*)sceneName NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);

-(LHSprite*) createPhysicalSpriteWithName:(NSString*)name 
                 fromSpriteHelperScene:(NSString*)sceneName;

//use this in order to create sprites of custom types
-(LHSprite*) createPhysicalSpriteWithName:(NSString*)name 
              fromSpriteHelperScene:(NSString*)sceneName 
                                tag:(LevelHelper_TAG)tag;


/*EXAMPLE
 LHSprite* spr = [lh newPhysicalBatchSpriteWithName:@"SpriteNameInsideSpriteHelper" fromSpriteHelperScene:@"SpriteHeleprSceneNameWithoutExtension"];
 [spr transformPosition:location];
 //set other properties like tag here
 */
-(LHSprite*) newPhysicalBatchSpriteWithName:(NSString*)name 
                      fromSpriteHelperScene:(NSString*)sceneName NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);

-(LHSprite*) createPhysicalBatchSpriteWithName:(NSString*)name 
                      fromSpriteHelperScene:(NSString*)sceneName;

//use this in order to create sprites of custom types
-(LHSprite*) createPhysicalBatchSpriteWithName:(NSString*)name 
                 fromSpriteHelperScene:(NSString*)sceneName 
                                   tag:(LevelHelper_TAG)tag;


/*More methods in LHCreationExt.h - download from http://www.levelhelper.org*/
//------------------------------------------------------------------------------
//JOINTS
-(LHJoint*) jointWithUniqueName:(NSString*)name;
-(NSArray*) jointsWithTag:(enum LevelHelper_TAG)tag; //returns array with LHJoint*
-(NSArray*) allJoints;
-(void) removeJointsWithTag:(enum LevelHelper_TAG)tag;
-(bool) removeJoint:(LHJoint*)joint;
-(bool) removeAllJoints;

//call this is you want to remove a joint containg a physical body in one of the contact callbacks
//to actually remove the joint call -removeMarkedJoints at the end of the tick method
//do not call this method on both types inside beginOrEnd callback, call only on begin or on end type
-(void) markJointForRemoval:(LHJoint*)jt; 
-(void) markJointsAttachedToSpriteForRemoval:(LHSprite*)spr;
-(void) removeMarkedJoints; //actually removes the joints that were marked for removal

/*More methods in LHJointsExt.h - download from http://www.levelhelper.org*/
//------------------------------------------------------------------------------
//PARALLAX
-(LHParallaxNode*) parallaxNodeWithUniqueName:(NSString*)uniqueName;

//please use the method with correct name from above
-(LHParallaxNode*) paralaxNodeWithUniqueName:(NSString*)uniqueName NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);

-(NSArray*) allParallaxes;
-(void) removeParallaxNode:(LHParallaxNode*)node;//does not remove the sprites
-(void) removeParallaxNode:(LHParallaxNode*)node removeChildSprites:(bool)rem;
-(void) removeAllParallaxes; //does not remove the sprites
-(void) removeAllParallaxesAndChildSprites:(bool)remChilds;
//------------------------------------------------------------------------------
//BEZIER
-(LHBezierNode*) bezierNodeWithUniqueName:(NSString*)name;
-(NSArray*)      allBezierNodes;
-(void)          removeBezier:(LHBezierNode*)bezier;
-(void)          removeAllBezierNodes;

//call this is you want to remove a bezier containg a physical body in one of the contact callbacks
//to actually remove the bezier call -removeMarkedBeziers at the end of the tick method
//do not call this method on both types inside beginOrEnd callback, call only on begin or on end type
-(void) markBezierForRemoval:(LHBezierNode*) node; 
-(void) removeMarkedBeziers; //actually removes the beziers that were marked for removal
//------------------------------------------------------------------------------
//GRAVITY
-(bool) isGravityZero;
-(void) createGravity:(b2World*)world;
//------------------------------------------------------------------------------
//PHYSIC BOUNDARIES
-(void) createPhysicBoundaries:(b2World*)_world;

//this method should be used when using dontStretchArtOnIpad
//see api documentatin for more info
-(void) createPhysicBoundariesNoStretching:(b2World *)_world;

-(CGRect) physicBoundariesRect;
-(bool) hasPhysicBoundaries;

-(b2Body*) leftPhysicBoundary;
-(LHSprite*) leftPhysicBoundarySprite;
-(b2Body*) rightPhysicBoundary;
-(LHSprite*) rightPhysicBoundarySprite;
-(b2Body*) topPhysicBoundary;
-(LHSprite*) topPhysicBoundarySprite;
-(b2Body*) bottomPhysicBoundary;
-(LHSprite*) bottomPhysicBoundarySprite;
-(void) removePhysicBoundaries;
//------------------------------------------------------------------------------
//LEVEL INFO
-(CGSize) gameScreenSize; //the device size set in loaded level
-(CGRect) gameWorldSize; //the size of the game world
//------------------------------------------------------------------------------
//BATCH
-(unsigned int) numberOfBatchNodesUsed;
-(LHBatch*)batchNodeForFile:(NSString*)image; //this will load the batch if its not loaded;
//call this when you want to release the memory for images you no longer use - like no longer running an animation
-(void) removeUnusedBatchesFromMemory; 

/*More methods in LHBatchExt.h - download from http://www.levelhelper.org*/
//------------------------------------------------------------------------------
//ANIMATION
//USE THE METHODS AVAILABLE IN LHSprite.h
-(void) startAnimationWithUniqueName:(NSString *)animName 
                            onSprite:(LHSprite*)ccsprite NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);

-(void) stopAnimationOnSprite:(LHSprite*)ccsprite NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);

//this will not start the animation - it will just prepare it
-(void) prepareAnimationWithUniqueName:(NSString*)animName 
                              onSprite:(LHSprite*)sprite NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);


//needs to be called before addObjectsToWorld or addSpritesToLayer
//signature for registered method should be like this: -(void) spriteAnimHasEnded:(CCSprite*)spr animationName:(NSString*)animName
//registration is done like this: [loader registerNotifierOnAnimationEnds:self selector:@selector(spriteAnimHasEnded:animationName:)];
//this will trigger for all type of animations even for the ones controlled by you will next/prevFrameFor...
-(void) registerNotifierOnAllAnimationEnds:(id)obj selector:(SEL)sel;
/*
 by default the notification on animation end works only on non-"loop forever" animations
 if you want to receive notifications on "loop forever" animations enable this behaviour
 before addObjectsToWorld by calling the following function
 */
-(void) enableNotifOnLoopForeverAnimations;

/*More methods in LHAnimationsExt.h - download from http://www.levelhelper.org*/
//------------------------------------------------------------------------------
//PATH
//use the method available in LHSprite.h instead
-(void) moveSprite:(LHSprite *)ccsprite onPathWithUniqueName:(NSString*)uniqueName 
			 speed:(float)pathSpeed 
   startAtEndPoint:(bool)startAtEndPoint
          isCyclic:(bool)isCyclic
 restartAtOtherEnd:(bool)restartOtherEnd
   axisOrientation:(int)axis
             flipX:(bool)flipx
             flipY:(bool)flipy
     deltaMovement:(bool)dMove NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);//describe path movement without setting the sprite position on the actual points on the path

//DISCUSSION
//signature for registered method should be like this: -(void)spriteMoveOnPathEnded:(LHSprite*)spr pathUniqueName:(NSString*)str;
//registration is done like this: [loader registerNotifierOnPathEndPoints:self selector:@selector(spriteMoveOnPathEnded:pathUniqueName:)];
-(void) registerNotifierOnAllPathEndPoints:(id)obj selector:(SEL)sel;

/*More methods in LHPathExt.h - download from http://www.levelhelper.org*/
//------------------------------------------------------------------------------
//PHYSICS
+(void) setMeterRatio:(float)ratio; //default is 32.0f
+(float) meterRatio; //same as pointsToMeterRatio - provided for simplicity as static method

+(float) pixelsToMeterRatio;
+(float) pointsToMeterRatio;

+(b2Vec2) pixelToMeters:(CGPoint)point; //Cocos2d point to Box2d point
+(b2Vec2) pointsToMeters:(CGPoint)point; //Cocos2d point to Box2d point

+(CGPoint) metersToPoints:(b2Vec2)vec; //Box2d point to Cocos2d point
+(CGPoint) metersToPixels:(b2Vec2)vec; //Box2d point to Cocos2d pixels
//------------------------------------------------------------------------------
//needed when deriving this class
-(void) setSpriteProperties:(LHSprite*)ccsprite 
           spriteProperties:(NSDictionary*)spriteProp;

//Others
-(NSString*) imageFolder;

//object is of type LHSprite or LHBezierNode
+(void)setTouchDispatcherForObject:(id)object tag:(int)tag;
+(void)removeTouchDispatcherFromObject:(id)object;
////////////////////////////////////////////////////////////////////////////////
@end









































