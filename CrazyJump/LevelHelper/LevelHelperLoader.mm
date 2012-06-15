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

#import "LevelHelperLoader.h"
#import <Foundation/Foundation.h>
#import "LHSettings.h"

#import "LHSprite.h"
#import "LHAnimationNode.h"
#import "LHJoint.h"
#import "LHBatch.h"
#import "LHPathNode.h"
#import "LHBezierNode.h"
#import "LHParallaxNode.h"
#import "SHDocumentLoader.h"
//------------------------------------------------------------------------------
@interface LHSprite (LH_SPRITE_LOADER_PARENT) 
-(void)setParentLoader:(LevelHelperLoader*)loader;
-(void)setTagTouchBeginObserver:(LHObserverPair*)pair;
-(void)setTagTouchMovedObserver:(LHObserverPair*)pair;
-(void)setTagTouchEndedObserver:(LHObserverPair*)pair;
-(void) removeFromCocos2dParentNode:(BOOL)cleanup; //added in order to send ERROR message to user in the overloaded LHSprite removeFromParentAndCleanUp method
@end
@implementation LHSprite (LH_SPRITE_LOADER_PARENT)
-(void)setParentLoader:(LevelHelperLoader*)loader{
    parentLoader = loader;   
}
-(void)setTagTouchBeginObserver:(LHObserverPair*)pair{
    tagTouchBeginObserver = pair;
}
-(void)setTagTouchMovedObserver:(LHObserverPair*)pair{
    tagTouchMovedObserver = pair;
}
-(void)setTagTouchEndedObserver:(LHObserverPair*)pair{
    tagTouchEndedObserver = pair;
}
-(void) removeFromCocos2dParentNode:(BOOL)cleanup{
    [super removeFromParentAndCleanup:cleanup];
}
@end
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface LHBezierNode (LH_BEZIER_LOADER_PARENT) 
-(void)setTagTouchBeginObserver:(LHObserverPair*)pair;
-(void)setTagTouchMovedObserver:(LHObserverPair*)pair;
-(void)setTagTouchEndedObserver:(LHObserverPair*)pair;
@end
@implementation LHBezierNode (LH_BEZIER_LOADER_PARENT)
-(void)setTagTouchBeginObserver:(LHObserverPair*)pair{
    tagTouchBeginObserver = pair;
}
-(void)setTagTouchMovedObserver:(LHObserverPair*)pair{
    tagTouchMovedObserver = pair;
}
-(void)setTagTouchEndedObserver:(LHObserverPair*)pair{
    tagTouchEndedObserver = pair;
}
@end
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
@interface LHParallaxNode (LH_PARALLAX_LOADER_PARENT) 
-(void) setRemoveChildSprites:(bool)val;
@end
@implementation LHParallaxNode (LH_PARALLAX_LOADER_PARENT)
-(void) setRemoveChildSprites:(bool)val{
    removeSpritesOnDelete = val;
}
@end
//------------------------------------------------------------------------------


#if TARGET_OS_EMBEDDED || TARGET_OS_IPHONE || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64

CGPoint LHPointFromValue(NSValue* val)
{
    return [val CGPointValue];
}

NSValue* LHValueWithRect(CGRect rect)
{
    return [NSValue valueWithCGRect:rect];
}

NSValue* LHValueWithCGPoint(CGPoint pt)
{
    return [NSValue valueWithCGPoint:pt];
}

CGRect LHRectFromValue(NSValue* val)
{
    return [val CGRectValue];
}

#else

CGPoint LHPointFromValue(NSValue* val)
{
    NSPoint pt = [val pointValue];
    return CGPointMake(pt.x, pt.y);
}

NSValue* LHValueWithRect(CGRect rect)
{
    return [NSValue valueWithRect:NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
}

NSValue* LHValueWithPoint(NSPoint pt)
{
    return [NSValue valueWithPoint:pt];
}

NSValue* LHValueWithCGPoint(CGPoint pt)
{
    return [NSValue valueWithPoint:NSMakePoint(pt.x, pt.y)];
}

CGRect LHRectFromValue(NSValue* val)
{
    return NSRectToCGRect([val rectValue]);
}

#endif


////////////////////////////////////////////////////////////////////////////////
@interface LevelHelperLoader (Private)
//------------------------------------------------------------------------------
-(void) addBatchNodesToLayer:(CCLayer*)_cocosLayer;
-(void) addBatchNodeToLayer:(CCLayer*)_cocosLayer batch:(LHBatch*)info;
-(void) releaseAllBatchNodes;
//------------------------------------------------------------------------------
-(void) createAllAnimationsInfo;
-(void) createAnimationFromDictionary:(NSDictionary*)spriteProp 
                           onCCSprite:(LHSprite*)ccsprite;
//------------------------------------------------------------------------------
-(void) createAllBeziers;
//------------------------------------------------------------------------------
-(void) createPathOnSprite:(LHSprite*)ccsprite 
            withProperties:(NSDictionary*)spriteProp;
//------------------------------------------------------------------------------
-(void) createSpritesWithPhysics;
-(void) setFixtureDefPropertiesFromDictionary:(NSDictionary*)spritePhysic 
									  fixture:(b2FixtureDef*)shapeDef;
-(b2Body*) b2BodyFromDictionary:(NSDictionary*)spritePhysic
			   spriteProperties:(NSDictionary*)spriteProp
						   data:(LHSprite*)ccsprite 
						  world:(b2World*)_world
                    customScale:(CGSize*)customScale;
-(void) releaseAllSprites;
//------------------------------------------------------------------------------
-(void) createParallaxes;
-(LHParallaxNode*) parallaxNodeFromDictionary:(NSDictionary*)parallaxDict 
                                        layer:(CCLayer*)layer;
-(void) releaseAllParallaxes;
//------------------------------------------------------------------------------
-(void) createJoints;
-(LHJoint*) jointFromDictionary:(NSDictionary*)joint world:(b2World*)world;
-(void) releaseAllJoints;
//------------------------------------------------------------------------------
-(void) releasePhysicBoundaries;
//------------------------------------------------------------------------------
-(void)loadLevelHelperSceneFile:(NSString*)levelFile 
					inDirectory:(NSString*)subfolder
				   imgSubfolder:(NSString*)imgFolder;

-(void) loadLevelHelperSceneFromDictionary:(NSDictionary*)levelDictionary 
							  imgSubfolder:(NSString*)imgFolder;

-(void)loadLevelHelperSceneFileFromWebAddress:(NSString*)webaddress;

-(void)processLevelFileFromDictionary:(NSDictionary*)dictionary;

-(void) createPhysicBoundariesHelper:(b2World*)_world 
                        convertRatio:(CGPoint)wbConv 
                              offset:(CGPoint)pos_offset;

-(LHSprite*) spriteFromDictionary:(NSDictionary*)spriteProp;

-(LHSprite*) spriteWithBatchFromDictionary:(NSDictionary*)spriteProp 
								 batchNode:(LHBatch*)batch;

//this 3 methods should be overloaded together
//first one is for physic sprites 
-(void) setCustomAttributesForPhysics:(NSDictionary*)spriteProp 
								 body:(b2Body*)body
							   sprite:(LHSprite*)sprite;
//this second one is for the case where you dont use physics or you have sprites
//with "NO PHYSIC" as physic type
-(void) setCustomAttributesForNonPhysics:(NSDictionary*)spriteProp 
								  sprite:(LHSprite*)sprite;
//the third one is for bezier shapes that are not paths
-(void) setCustomAttributesForBezierBodies:(NSDictionary*)bezierProp 
                                      node:(CCNode*)sprite body:(b2Body*)body;


@end

@implementation LevelHelperLoader

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
-(void) initObjects
{
	lhBatchInfo = [[NSMutableDictionary alloc] init];
    batchNodesInLevel = [[NSMutableDictionary alloc] init];	
    
	spritesInLevel = [[NSMutableDictionary alloc] init];
    jointsInLevel = [[NSMutableDictionary alloc] init];
	beziersInLevel = [[NSMutableDictionary alloc] init];
    parallaxesInLevel = [[NSMutableDictionary alloc] init];
    animationsInLevel = [[NSMutableDictionary alloc] init];
    physicBoundariesInLevel = [[NSMutableDictionary alloc] init];
    
    markedSprites = [[NSMutableSet alloc] init];
    markedBeziers = [[NSMutableSet alloc] init];
    markedJoints  = [[NSMutableSet alloc] init];
    
	addSpritesToLayerWasUsed = false;
	addObjectsToWordWasUsed = false;
    
    imageFolder = [[NSMutableString alloc] init];
    
	[[LHSettings sharedInstance] setLhPtmRatio:32.0f];
	
    notifOnLoopForeverAnim = false;
}
////////////////////////////////////////////////////////////////////////////////
-(id) initWithContentOfFile:(NSString*)levelFile
{
	NSAssert(nil!=levelFile, @"Invalid file given to LevelHelperLoader");
	
	if(!(self = [super init]))
	{
		NSLog(@"LevelHelperLoader ****ERROR**** : [super init] failer ***");
		return self;
	}
	
	[self initObjects];
	[self loadLevelHelperSceneFile:levelFile inDirectory:@"" imgSubfolder:@""];
	
	
	return self;
}
////////////////////////////////////////////////////////////////////////////////
-(id) initWithContentOfFileFromInternet:(NSString*)webAddress
{
	NSAssert(nil!=webAddress, @"Invalid file given to LevelHelperLoader");
	
	if(!(self = [super init]))
	{
		NSLog(@"LevelHelperLoader ****ERROR**** : [super init] failer ***");
		return self;
	}
	
	[self initObjects];
	[self loadLevelHelperSceneFileFromWebAddress:webAddress];
	
	return self;
}
////////////////////////////////////////////////////////////////////////////////
-(id) initWithContentOfFile:(NSString*)levelFile 
			 levelSubfolder:(NSString*)levelFolder
{
	NSAssert(nil!=levelFile, @"Invalid file given to LevelHelperLoader");
	
	if(!(self = [super init]))
	{
		NSLog(@"LevelHelperLoader ****ERROR**** : [super init] failer ***");
		return self;
	}
	
	[self initObjects];
	
	[self loadLevelHelperSceneFile:levelFile inDirectory:levelFolder imgSubfolder:@""];
	
	return self;	
}
////////////////////////////////////////////////////////////////////////////////
-(void)registerLoadingProgressObserver:(id)object selector:(SEL)selector{
    loadingProgressId = object;
    loadingProgressSel = selector;
}
//------------------------------------------------------------------------------
-(void) callLoadingProgressObserverWithValue:(float)val
{
    if(loadingProgressId != nil && loadingProgressSel != nil)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [loadingProgressId performSelector:loadingProgressSel 
                                withObject:[NSNumber numberWithFloat:val]];
#pragma clang diagnostic pop
    }
}
////////////////////////////////////////////////////////////////////////////////
-(id) initWithContentOfFileAtURL:(NSURL*)levelURL imagesPath:(NSString*)imgFolder
{
    NSAssert(nil!=levelURL, @"Invalid URL given to LevelHelperLoader");
	
	if(!(self = [super init]))
	{
		NSLog(@"LevelHelperLoader ****ERROR**** : [super init] failer ***");
		return self;
	}
	
	[self initObjects];
	
    NSDictionary* levelDictionary = [NSDictionary dictionaryWithContentsOfURL:levelURL];
    
	[self loadLevelHelperSceneFromDictionary:levelDictionary imgSubfolder:imgFolder];
	
	return self;	

}
-(id) initWithContentOfDictionary:(NSDictionary*)levelDictionary
					  imageFolder:(NSString*)imgFolder;
{
	NSAssert(nil!=levelDictionary, @"Invalid dictionary given to LevelHelperLoader");
	
	if(!(self = [super init]))
	{
		NSLog(@"LevelHelperLoader ****ERROR**** : [super init] failer ***");
		return self;
	}
	
	[self initObjects];
	
	[self loadLevelHelperSceneFromDictionary:levelDictionary imgSubfolder:imgFolder];
	
	return self;	
}
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
-(void) addSpritesToLayer:(CCLayer*)_cocosLayer
{	
	NSAssert(addObjectsToWordWasUsed!=true, @"You can't use method addSpritesToLayer because you already used addObjectToWorld. Only one of the two can be used."); 
	NSAssert(addSpritesToLayerWasUsed!=true, @"You can't use method addSpritesToLayer again. You can only use it once. Create a new LevelHelperLoader object if you want to load the level again."); 
	
	addSpritesToLayerWasUsed = true;
	
	cocosLayer = _cocosLayer;
	
	[self addBatchNodesToLayer:cocosLayer];
	
    [self createAllAnimationsInfo];
    
    //we need to first create the path so we can assign the path to sprite on creation
    //    for(NSDictionary* bezierDict in lhBeziers)
    //    {
    //        //NSString* uniqueName = [bezierDict objectForKey:@"UniqueName"];
    //        if([[bezierDict objectForKey:@"IsPath"] boolValue])
    //        {
    //            [self createBezierPath:bezierDict];
    //        }
    //    }
    
    
	for(NSDictionary* dictionary in lhSprites)
	{
		NSDictionary* spriteProp = [dictionary objectForKey:@"GeneralProperties"];
		
		//find the coresponding batch node for this sprite
        //LHBatch* bNode = [batchNodesInLevel objectForKey:[spriteProp objectForKey:@"Image"]];
		//CCSpriteBatchNode *batch = [bNode spriteBatchNode];
		
        LHBatch* bNode = [self batchNodeForFile:[spriteProp objectForKey:@"Image"]];
        
        if(bNode)
        {
            CCSpriteBatchNode *batch = [bNode spriteBatchNode];
            if(nil != batch)
            {
                LHSprite* ccsprite = [self spriteWithBatchFromDictionary:spriteProp batchNode:bNode];
                if(nil != ccsprite)
                {
                    [batch addChild:ccsprite];
                    [spritesInLevel setObject:ccsprite forKey:[spriteProp objectForKey:@"UniqueName"]];
                
                    [self setCustomAttributesForNonPhysics:spriteProp
                                                    sprite:ccsprite];
                }
            
                if(![[spriteProp objectForKey:@"PathName"] isEqualToString:@"None"])
                {
                    //we have a path we need to follow
                    [self createPathOnSprite:ccsprite
                              withProperties:spriteProp];
                }
            
                [self createAnimationFromDictionary:spriteProp onCCSprite:ccsprite];
                [ccsprite postInitialization];
            }
        }
	}
    
    for(NSDictionary* parallaxDict in lhParallax)
    {
        //NSMutableDictionary* nodeInfo = [[[NSMutableDictionary alloc] init] autorelease];
        //       CCNode* node = [self parallaxNodeFromDictionary:parallaxDict layer:cocosLayer];
        
        //   if(nil != node)
        // {
        //[nodeInfo setObject:[parallaxDict objectForKey:@"ContinuousScrolling"] forKey:@"ContinuousScrolling"];
        //[//nodeInfo setObject:[parallaxDict objectForKey:@"Speed"] forKey:@"Speed"];
        //[nodeInfo setObject:[parallaxDict objectForKey:@"Direction"] forKey:@"Direction"];
        //[nodeInfo setObject:node forKey:@"Node"];
        //         [ccParallaxInScene setObject:node forKey:[parallaxDict objectForKey:@"UniqueName"]];
        //}
    }
}
////////////////////////////////////////////////////////////////////////////////
-(void) addObjectsToWorld:(b2World*)world 
			 cocos2dLayer:(CCLayer*)_cocosLayer
{
	
	NSAssert(addSpritesToLayerWasUsed!=true, @"You can't use method addObjectsToWorld because you already used addSpritesToLayer. Only one of the two can be used."); 
	NSAssert(addObjectsToWordWasUsed!=true, @"You can't use method addObjectsToWorld again. You can only use it once. Create a new LevelHelperLoader object if you want to load the level again."); 
	
	addObjectsToWordWasUsed = true;
	
	cocosLayer = _cocosLayer;
    box2dWorld = world;
	
    //order is important
    
	[self addBatchNodesToLayer:cocosLayer];
    [self callLoadingProgressObserverWithValue:0.20];
    [self createAllAnimationsInfo];    
    [self callLoadingProgressObserverWithValue:0.30f];
    [self createAllBeziers];
    [self callLoadingProgressObserverWithValue:0.50f];
    [self createSpritesWithPhysics];
    [self createParallaxes];
    [self callLoadingProgressObserverWithValue:0.90f];
	[self createJoints];
    [self callLoadingProgressObserverWithValue:1.0f];
}
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
+(bool)isPaused{
    return [[LHSettings sharedInstance] levelPaused];
}
+(void)setPaused:(bool)value{
    
    [[LHSettings sharedInstance] setLevelPaused:value];    
}
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
+(void) dontStretchArtOnIpad{
    [[LHSettings sharedInstance] setStretchArt:false];
}
+(void) preloadBatchNodes{
    [[LHSettings sharedInstance] setPreloadBatchNodes:true];
}
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
-(void) useLevelHelperCollisionHandling{
    if(0 == box2dWorld){
        NSLog(@"LevelHelper WARNING: Please call useLevelHelperCollisionHandling after addObjectsToWorld");
        return;
    }
    
    contactNode = [LHContactNode contactNodeWithWorld:box2dWorld];
    if(nil != cocosLayer)
    {
        [cocosLayer addChild:contactNode];
    }
}
//------------------------------------------------------------------------------
-(void) registerBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)tagA
                                          andTagB:(enum LevelHelper_TAG)tagB
                                       idListener:(id)obj
                                      selListener:(SEL)selector{
    if(nil == contactNode){
        NSLog(@"LevelHelper WARNING: Please call registerPreColisionCallbackBetweenTagA after useLevelHelperCollisionHandling");
    }
    [contactNode registerBeginOrEndColisionCallbackBetweenTagA:(int)tagA 
                                                  andTagB:(int)tagB 
                                               idListener:obj 
                                              selListener:selector];

}
-(void) cancelBeginOrEndCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)tagA
                                        andTagB:(enum LevelHelper_TAG)tagB{
    if(nil == contactNode){
        NSLog(@"LevelHelper WARNING: Please call registerPreColisionCallbackBetweenTagA after useLevelHelperCollisionHandling");
    }
    [contactNode cancelBeginOrEndColisionCallbackBetweenTagA:(int)tagA 
                                                andTagB:(int)tagB];

}

-(void) registerPreCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)tagA 
                                    andTagB:(enum LevelHelper_TAG)tagB 
                                 idListener:(id)obj 
                                selListener:(SEL)selector{

    if(nil == contactNode){
        NSLog(@"LevelHelper WARNING: Please call registerPreColisionCallbackBetweenTagA after useLevelHelperCollisionHandling");
    }
    [contactNode registerPreColisionCallbackBetweenTagA:(int)tagA 
                                                andTagB:(int)tagB 
                                             idListener:obj 
                                            selListener:selector];
}
//------------------------------------------------------------------------------
-(void) cancelPreCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)tagA 
                                      andTagB:(enum LevelHelper_TAG)tagB
{
    if(nil == contactNode){
        NSLog(@"LevelHelper WARNING: Please call registerPreColisionCallbackBetweenTagA after useLevelHelperCollisionHandling");
    }
    [contactNode cancelPreColisionCallbackBetweenTagA:(int)tagA 
                                              andTagB:(int)tagB];
}
//------------------------------------------------------------------------------
-(void) registerPostCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)tagA 
                                        andTagB:(enum LevelHelper_TAG)tagB 
                                     idListener:(id)obj 
                                    selListener:(SEL)selector{
    if(nil == contactNode){
        NSLog(@"LevelHelper WARNING: Please call registerPostColisionCallbackBetweenTagA after useLevelHelperCollisionHandling");
    }
    [contactNode registerPostColisionCallbackBetweenTagA:(int)tagA 
                                                 andTagB:(int)tagB 
                                              idListener:obj 
                                             selListener:selector];
    
}
//------------------------------------------------------------------------------
-(void) cancelPostCollisionCallbackBetweenTagA:(enum LevelHelper_TAG)tagA 
                                      andTagB:(enum LevelHelper_TAG)tagB
{
    if(nil == contactNode){
        NSLog(@"LevelHelper WARNING: Please call registerPreColisionCallbackBetweenTagA after useLevelHelperCollisionHandling");
    }
    [contactNode cancelPostColisionCallbackBetweenTagA:(int)tagA 
                                              andTagB:(int)tagB];
}
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
-(CGSize) gameScreenSize
{
    return CGSizeMake(safeFrame.x, safeFrame.y);
}

//------------------------------------------------------------------------------
-(CGRect) gameWorldSize
{
    CGPoint  wbConv = [[LHSettings sharedInstance] convertRatio];
	
    CGRect ws = gameWorldRect;
    
    ws.origin.x *= wbConv.x;
    ws.origin.y *= wbConv.y;
    ws.size.width *= wbConv.x;
    ws.size.height *= wbConv.y;
    
    return ws;
}
//------------------------------------------------------------------------------
-(unsigned int) numberOfBatchNodesUsed
{
	return (int)[batchNodesInLevel count] -1;
}
////////////////////////////////////////////////////////////////////////////////
-(void) dealloc
{   
    [[LHCuttingEngineMgr sharedInstance] destroyAllPrevioslyCutSprites];
    [[LHTouchMgr sharedInstance] removeTouchBeginObserver:cocosLayer];
    
    [self releasePhysicBoundaries];
	[self removeAllBezierNodes];	
	[self releaseAllParallaxes];
    [self releaseAllJoints];	
    [self releaseAllSprites];
    [self releaseAllBatchNodes];
    
#ifndef LH_ARC_ENABLED
	[lhSprites release];
	[lhJoints release];
    [lhParallax release];
    [lhBeziers release];
    [lhAnims release];
    [animationsInLevel release];
    [lhBatchInfo release];
    [markedSprites release];
    [markedBeziers release];
    [markedJoints release];
    [imageFolder release];
#endif
    
    if(nil != contactNode){
        [contactNode removeFromParentAndCleanup:YES];
    }
#ifndef LH_ARC_ENABLED        
    [super dealloc];
#endif
}
////////////////////////////////////////////////////////////////////////////////
///////////////////////////PRIVATE METHODS//////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
-(void) addBatchNodesToLayer:(CCLayer*)_cocosLayer
{
    if(![[LHSettings sharedInstance] preloadBatchNodes])
        return;
     
    
	NSArray *keys = [batchNodesInLevel allKeys];
	int tag = 0;
	for(NSString* key in keys){
		LHBatch* info = [batchNodesInLevel objectForKey:key];
		[_cocosLayer addChild:[info spriteBatchNode] z:[info z] tag:tag];
		tag++;
	}
}

-(void) addBatchNodeToLayer:(CCLayer*)_cocosLayer batch:(LHBatch*)info
{
    if(info!= nil && _cocosLayer != nil)
    {
        [_cocosLayer addChild:[info spriteBatchNode] z:[info z]];
    }
}

//------------------------------------------------------------------------------
-(void)releaseAllBatchNodes{
	[batchNodesInLevel removeAllObjects];
#ifndef LH_ARC_ENABLED
    [batchNodesInLevel release];
#endif
    batchNodesInLevel = nil;
}
////////////////////////////////////////////////////////////////////////////////
//ANIMATIONS
////////////////////////////////////////////////////////////////////////////////
-(void) createAllAnimationsInfo
{
    for(NSDictionary* animInfo in lhAnims)
    {
        NSString* uniqueAnimName = [animInfo objectForKey:@"UniqueName"];
        
        NSArray* framesInfo = [animInfo objectForKey:@"Frames"];
        
        bool loop           = [[animInfo objectForKey:@"LoopForever"] boolValue];
        float animSpeed     = [[animInfo objectForKey:@"Speed"] floatValue];
        int repetitions     = [[animInfo objectForKey:@"Repetitions"] intValue];
        bool startAtLaunch  = [[animInfo objectForKey:@"StartAtLaunch"] boolValue];
        
        NSString* image = [animInfo objectForKey:@"Image"];
                
        LHAnimationNode* animNode = [LHAnimationNode animationNodeWithUniqueName:uniqueAnimName];
        [animNode setLoop:loop];
        [animNode setSpeed:animSpeed];
        [animNode setRepetitions:repetitions];
        [animNode setStartAtLaunch:startAtLaunch];
        [animNode setImageName:image];
        [animNode setFramesInfo:framesInfo];
                
        [animationsInLevel setObject:animNode forKey:uniqueAnimName];
    }
}
//------------------------------------------------------------------------------
-(void) createAnimationFromDictionary:(NSDictionary*)spriteProp 
                           onCCSprite:(LHSprite*)ccsprite{
	
	
	NSString* animName = [spriteProp objectForKey:@"AnimName"];
	if(![animName isEqualToString:@""])
	{
        LHAnimationNode* animNode = [animationsInLevel objectForKey:animName];
        if(nil != animNode)
        {
            if([animNode startAtLaunch])
            {
                LHBatch* batch = [self batchNodeForFile:[animNode imageName]];
                
                if(batch)
                {
                    [animNode setBatchNode:[batch spriteBatchNode]];
                    [animNode computeFrames];
                    
                    [animNode runAnimationOnSprite:ccsprite 
                                 startingFromFrame:0
                                   withNotifierObj:animNotifierId 
                                       notifierSel:animNotifierSel 
                                       notifOnLoop:notifOnLoopForeverAnim];
                }
            }
            else
            {
                [ccsprite prepareAnimationNamed:animName];
            }
        }
	}
}
//------------------------------------------------------------------------------
-(void) startAnimationWithUniqueName:(NSString *)animName 
                            onSprite:(LHSprite*)ccsprite{    
    
    [ccsprite startAnimationNamed:animName 
                   endObserverObj:animNotifierId 
                   endObserverSel:animNotifierSel 
        shouldObserverLoopForever:notifOnLoopForeverAnim];
    
//    LHAnimationNode* animNode = [animationsInLevel objectForKey:animName];
//    if(nil != animNode){
//        
//        LHBatch* batch = [self batchNodeForFile:[animNode imageName]];
//        
//        if(batch)
//        {
//            [animNode setBatchNode:[batch spriteBatchNode]];
//            [animNode computeFrames];
//        
//            [animNode runAnimationOnSprite:ccsprite 
//                           withNotifierObj:animNotifierId 
//                               notifierSel:animNotifierSel 
//                               notifOnLoop:notifOnLoopForeverAnim];
//        }
//    }
}
//------------------------------------------------------------------------------
-(void) stopAnimationOnSprite:(LHSprite*)ccsprite{
    if(nil != ccsprite){
        [ccsprite stopActionByTag:LH_ANIM_ACTION_TAG];
        [ccsprite setAnimation:nil];
    }    
}
//------------------------------------------------------------------------------
-(void) prepareAnimationWithUniqueName:(NSString*)animName 
                              onSprite:(LHSprite*)sprite{
    LHAnimationNode* animNode = [animationsInLevel objectForKey:animName];
    if(animNode == nil)
        return;
    
    LHBatch* batch = [self batchNodeForFile:[animNode imageName]];
    
    if(batch)
    {
        [animNode setBatchNode:[batch spriteBatchNode]];
        [animNode computeFrames];
        [sprite setAnimation:animNode];
    }
}
//------------------------------------------------------------------------------
-(void) registerNotifierOnAllAnimationEnds:(id)obj selector:(SEL)sel{
    animNotifierId = obj;
    animNotifierSel = sel;
}
//------------------------------------------------------------------------------
-(void) enableNotifOnLoopForeverAnimations{
    notifOnLoopForeverAnim = true;
}
////////////////////////////////////////////////////////////////////////////////
//GRAVITY
////////////////////////////////////////////////////////////////////////////////
-(bool) isGravityZero{
    if(gravity.x == 0 && gravity.y == 0)
        return true;
    return false;
}
//------------------------------------------------------------------------------
-(void) createGravity:(b2World*)world{
	if([self isGravityZero])
		NSLog(@"LevelHelper Warning: Gravity is not defined in the level. Are you sure you want to set a zero gravity?");
    world->SetGravity(b2Vec2(gravity.x, gravity.y));
}
////////////////////////////////////////////////////////////////////////////////
//PHYSIC BOUNDARIES
////////////////////////////////////////////////////////////////////////////////
-(b2Body*)physicBoundarieForKey:(NSString*)key{
    LHSprite* spr = [physicBoundariesInLevel objectForKey:key];
    if(nil == spr)
        return 0;
    return [spr body];
}
//------------------------------------------------------------------------------
-(b2Body*) leftPhysicBoundary{
    return [self physicBoundarieForKey:@"LHPhysicBoundarieLeft"];
}
-(LHSprite*) leftPhysicBoundarySprite{
    return [physicBoundariesInLevel objectForKey:@"LHPhysicBoundarieLeft"];
}
//------------------------------------------------------------------------------
-(b2Body*) rightPhysicBoundary{
	return [self physicBoundarieForKey:@"LHPhysicBoundarieRight"];
}
-(LHSprite*) rightPhysicBoundarySprite{
    return [physicBoundariesInLevel objectForKey:@"LHPhysicBoundarieRight"];
}
//------------------------------------------------------------------------------
-(b2Body*) topPhysicBoundary{
    return [self physicBoundarieForKey:@"LHPhysicBoundarieTop"];
}
-(LHSprite*) topPhysicBoundarySprite{
    return [physicBoundariesInLevel objectForKey:@"LHPhysicBoundarieTop"];
}
//------------------------------------------------------------------------------
-(b2Body*) bottomPhysicBoundary{
    return [self physicBoundarieForKey:@"LHPhysicBoundarieBottom"];
}
-(LHSprite*) bottomPhysicBoundarySprite{
    return [physicBoundariesInLevel objectForKey:@"LHPhysicBoundarieBottom"];
}
//------------------------------------------------------------------------------
-(bool) hasPhysicBoundaries{
	if(wb == nil){
		return false;
	}
    CGRect rect = LHRectFromString([wb objectForKey:@"WBRect"]);    
    if(rect.size.width == 0 || rect.size.height == 0)
        return false;
	return true;
}
//------------------------------------------------------------------------------
-(CGRect) physicBoundariesRect{
    CGPoint  wbConv = [[LHSettings sharedInstance] convertRatio];
    CGRect rect = LHRectFromString([wb objectForKey:@"WBRect"]);    
    rect.origin.x = rect.origin.x*wbConv.x,
    rect.origin.y = rect.origin.y*wbConv.y;
    rect.size.width = rect.size.width*wbConv.x;
    rect.size.height= rect.size.height*wbConv.y;
    return rect;
}
//------------------------------------------------------------------------------
-(void) createPhysicBoundariesNoStretching:(b2World *)_world{
    
    CGPoint pos_offset = [[LHSettings sharedInstance] possitionOffset];
    CGPoint  wbConv = [[LHSettings sharedInstance] convertRatio];
    
    [self createPhysicBoundariesHelper:_world convertRatio:wbConv 
                                offset:CGPointMake(pos_offset.x/2.0f, 
                                                   pos_offset.y/2.0f)];
}
//------------------------------------------------------------------------------
-(void) createPhysicBoundaries:(b2World*)_world{
    
    CGPoint  wbConv = [[LHSettings sharedInstance] realConvertRatio];
    [self createPhysicBoundariesHelper:_world convertRatio:wbConv offset:CGPointMake(0.0f, 0.0f)];
}
//------------------------------------------------------------------------------
-(void) createPhysicBoundariesHelper:(b2World*)_world 
                        convertRatio:(CGPoint)wbConv 
                              offset:(CGPoint)pos_offset{
	if(![self hasPhysicBoundaries]){
        NSLog(@"LevelHelper WARNING - Please create physic boundaries in LevelHelper in order to call method \"createPhysicBoundaries\"");
        return;
    }	
    

    
    b2BodyDef bodyDef;		
	bodyDef.type = b2_staticBody;
	bodyDef.position.Set(0.0f, 0.0f);
    b2Body* wbBodyT = _world->CreateBody(&bodyDef);
	b2Body* wbBodyL = _world->CreateBody(&bodyDef);
	b2Body* wbBodyB = _world->CreateBody(&bodyDef);
	b2Body* wbBodyR = _world->CreateBody(&bodyDef);
	
	{
#ifndef LH_ARC_ENABLED
        LHSprite* spr = [[[LHSprite alloc] initSprite] autorelease];
#else
        LHSprite* spr = [[LHSprite alloc] initSprite];
#endif
		[spr setTag:[[wb objectForKey:@"TagLeft"] intValue]]; 
		[spr setVisible:false];
		[spr setUniqueName:@"LHPhysicBoundarieLeft"];
        [spr setBody:wbBodyL];    
#ifndef LH_ARC_ENABLED
        wbBodyL->SetUserData(spr);
#else
        wbBodyL->SetUserData((__bridge void*)spr);
#endif
        [physicBoundariesInLevel setObject:spr forKey:@"LHPhysicBoundarieLeft"];
	}
	
	{
#ifndef LH_ARC_ENABLED
		LHSprite* spr = [[[LHSprite alloc] initSprite] autorelease];
#else
        LHSprite* spr = [[LHSprite alloc] initSprite];
#endif
		[spr setTag:[[wb objectForKey:@"TagRight"] intValue]]; 

		[spr setVisible:false];
		[spr setUniqueName:@"LHPhysicBoundarieRight"];
        [spr setBody:wbBodyR];  
#ifndef LH_ARC_ENABLED
        wbBodyR->SetUserData(spr);
#else
        wbBodyR->SetUserData((__bridge void*)spr);
#endif
        [physicBoundariesInLevel setObject:spr forKey:@"LHPhysicBoundarieRight"];
	}
	
	{
#ifndef LH_ARC_ENABLED
		LHSprite* spr = [[[LHSprite alloc] initSprite] autorelease];
#else
        LHSprite* spr = [[LHSprite alloc] initSprite];
#endif
		[spr setTag:[[wb objectForKey:@"TagTop"] intValue]]; 
		[spr setVisible:false];
		[spr setUniqueName:@"LHPhysicBoundarieTop"];
        [spr setBody:wbBodyT];  
        
#ifndef LH_ARC_ENABLED
        wbBodyT->SetUserData(spr);        
#else
        wbBodyT->SetUserData((__bridge void*)spr);        
#endif
        [physicBoundariesInLevel setObject:spr forKey:@"LHPhysicBoundarieTop"];
	}
	
	{
#ifndef LH_ARC_ENABLED
		LHSprite* spr = [[[LHSprite alloc] initSprite] autorelease];
#else
        LHSprite* spr = [[LHSprite alloc] initSprite];
#endif
		[spr setTag:[[wb objectForKey:@"TagBottom"] intValue]]; 
		[spr setVisible:false];
		[spr setUniqueName:@"LHPhysicBoundarieBottom"];
        [spr setBody:wbBodyB];  
#ifndef LH_ARC_ENABLED
        wbBodyB->SetUserData(spr);        
#else
        wbBodyB->SetUserData((__bridge void*)spr);        
#endif
        [physicBoundariesInLevel setObject:spr forKey:@"LHPhysicBoundarieBottom"];
	}
	
	wbBodyT->SetSleepingAllowed([[wb objectForKey:@"CanSleep"] boolValue]);  
	wbBodyL->SetSleepingAllowed([[wb objectForKey:@"CanSleep"] boolValue]);  
	wbBodyB->SetSleepingAllowed([[wb objectForKey:@"CanSleep"] boolValue]);  
	wbBodyR->SetSleepingAllowed([[wb objectForKey:@"CanSleep"] boolValue]);  
	
	
    CGRect rect = LHRectFromString([wb objectForKey:@"WBRect"]);    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
	
    
    
    #ifndef LH_SCENE_TESTER
        rect.origin.x += pos_offset.x;
        rect.origin.y += pos_offset.y;
    #else
        rect.origin.x += pos_offset.x*2.0f;
        rect.origin.y += pos_offset.y*2.0f;
    #endif
    {//TOP
        b2EdgeShape shape;
		
        b2Vec2 pos1 = b2Vec2(rect.origin.x/[[LHSettings sharedInstance] lhPtmRatio]*wbConv.x,
							 (winSize.height - rect.origin.y*wbConv.y)/[[LHSettings sharedInstance] lhPtmRatio]);
        
        b2Vec2 pos2 = b2Vec2((rect.origin.x + rect.size.width)*wbConv.x/[[LHSettings sharedInstance] lhPtmRatio], 
							 (winSize.height - rect.origin.y*wbConv.y)/[[LHSettings sharedInstance] lhPtmRatio]);		
		shape.Set(pos1, pos2);
		
        b2FixtureDef fixture;
        [self setFixtureDefPropertiesFromDictionary:wb fixture:&fixture];
        fixture.shape = &shape;
        wbBodyT->CreateFixture(&fixture);
    }
	
    {//LEFT
        b2EdgeShape shape;
		
		b2Vec2 pos1 = b2Vec2(rect.origin.x*wbConv.x/[[LHSettings sharedInstance] lhPtmRatio],
							 (winSize.height - rect.origin.y*wbConv.y)/[[LHSettings sharedInstance] lhPtmRatio]);
        
		b2Vec2 pos2 = b2Vec2((rect.origin.x*wbConv.x)/[[LHSettings sharedInstance] lhPtmRatio], 
							 (winSize.height - (rect.origin.y + rect.size.height)*wbConv.y)/[[LHSettings sharedInstance] lhPtmRatio]);
        shape.Set(pos1, pos2);
		
        b2FixtureDef fixture;
        [self setFixtureDefPropertiesFromDictionary:wb fixture:&fixture];
        fixture.shape = &shape;
        wbBodyL->CreateFixture(&fixture);
    }
	
    {//RIGHT
        b2EdgeShape shape;
        
        b2Vec2 pos1 = b2Vec2((rect.origin.x + rect.size.width)*wbConv.x/[[LHSettings sharedInstance] lhPtmRatio],
							 (winSize.height - rect.origin.y*wbConv.y)/[[LHSettings sharedInstance] lhPtmRatio]);
        
        b2Vec2 pos2 = b2Vec2((rect.origin.x+ rect.size.width)*wbConv.x/[[LHSettings sharedInstance] lhPtmRatio], 
							 (winSize.height - (rect.origin.y + rect.size.height)*wbConv.y)/[[LHSettings sharedInstance] lhPtmRatio]);
        shape.Set(pos1, pos2);
		
        b2FixtureDef fixture;
        [self setFixtureDefPropertiesFromDictionary:wb fixture:&fixture];
        fixture.shape = &shape;
        wbBodyR->CreateFixture(&fixture);
    }
	
    {//BOTTOM
        b2EdgeShape shape;
        
        b2Vec2 pos1 = b2Vec2(rect.origin.x*wbConv.x/[[LHSettings sharedInstance] lhPtmRatio],
							 (winSize.height - (rect.origin.y + rect.size.height)*wbConv.y)/[[LHSettings sharedInstance] lhPtmRatio]);
        
        b2Vec2 pos2 = b2Vec2((rect.origin.x+ rect.size.width)*wbConv.x/[[LHSettings sharedInstance] lhPtmRatio], 
							 (winSize.height - (rect.origin.y + rect.size.height)*wbConv.y)/[[LHSettings sharedInstance] lhPtmRatio]);
        shape.Set(pos1, pos2);
		
        b2FixtureDef fixture;
        [self setFixtureDefPropertiesFromDictionary:wb fixture:&fixture];
        fixture.shape = &shape;
        wbBodyB->CreateFixture(&fixture);
    }
}
//------------------------------------------------------------------------------
-(void) removePhysicBoundaries{    
    [physicBoundariesInLevel removeAllObjects];
}
//------------------------------------------------------------------------------
-(void) releasePhysicBoundaries{
    [self removePhysicBoundaries];
#ifndef LH_ARC_ENABLED
    [physicBoundariesInLevel release];
#endif
    physicBoundariesInLevel = nil;
}
////////////////////////////////////////////////////////////////////////////////
//PHYSICS
////////////////////////////////////////////////////////////////////////////////
+(void) setMeterRatio:(float)ratio{
	[[LHSettings sharedInstance] setLhPtmRatio:ratio];
}
//------------------------------------------------------------------------------
+(float) meterRatio{
	return [[LHSettings sharedInstance] lhPtmRatio];
}
//------------------------------------------------------------------------------
+(float) pixelsToMeterRatio{
    return [[LHSettings sharedInstance] lhPtmRatio]*[[LHSettings sharedInstance] convertRatio].x;
}
//------------------------------------------------------------------------------
+(float) pointsToMeterRatio{
    return [[LHSettings sharedInstance] lhPtmRatio];
}
//------------------------------------------------------------------------------
+(b2Vec2) pixelToMeters:(CGPoint)point{
    return b2Vec2(point.x / [LevelHelperLoader pixelsToMeterRatio], point.y / [LevelHelperLoader pixelsToMeterRatio]);
}
//------------------------------------------------------------------------------
+(b2Vec2) pointsToMeters:(CGPoint)point{
    return b2Vec2(point.x / [[LHSettings sharedInstance] lhPtmRatio], point.y / [[LHSettings sharedInstance] lhPtmRatio]);
}
//------------------------------------------------------------------------------
+(CGPoint) metersToPoints:(b2Vec2)vec{
    return CGPointMake(vec.x*[[LHSettings sharedInstance] lhPtmRatio], vec.y*[[LHSettings sharedInstance] lhPtmRatio]);
}
//------------------------------------------------------------------------------
+(CGPoint) metersToPixels:(b2Vec2)vec{
    return ccpMult(CGPointMake(vec.x, vec.y), [LevelHelperLoader pixelsToMeterRatio]);
}
////////////////////////////////////////////////////////////////////////////////
//BEZIERS
////////////////////////////////////////////////////////////////////////////////
-(void) createAllBeziers{
	for(NSDictionary* bezierDict in lhBeziers){
		LHBezierNode* node = [LHBezierNode nodeWithDictionary:bezierDict 
												   cocosLayer:cocosLayer
												  physicWorld:box2dWorld
                                                       parent:self];
		
        NSString* uniqueName = [bezierDict objectForKey:@"UniqueName"];
		if(nil != node){
            
            int tag = [[bezierDict objectForKey:@"Tag"] intValue];
            [LevelHelperLoader setTouchDispatcherForObject:node tag:tag];
            
			[beziersInLevel setObject:node forKey:uniqueName];
			int z = [[bezierDict objectForKey:@"ZOrder"] intValue];
			[cocosLayer addChild:node z:z];
		}		
    }
}
//------------------------------------------------------------------------------
-(LHBezierNode*) bezierNodeWithUniqueName:(NSString*)name{
	return [beziersInLevel objectForKey:name];
}
//------------------------------------------------------------------------------
-(NSArray*) allBezierNodes{
    return [beziersInLevel allValues];
}
//------------------------------------------------------------------------------
-(void) removeBezier:(LHBezierNode*)bezier shouldRemoveMarked:(bool)marked{
    if(NULL == bezier)
        return;
    [beziersInLevel removeObjectForKey:[bezier uniqueName]];
    [LevelHelperLoader removeTouchDispatcherFromObject:bezier];
    [bezier removeFromParentAndCleanup:YES];
    if(marked)
        [markedBeziers removeObject:bezier];
}
//------------------------------------------------------------------------------
-(void) removeBezier:(LHBezierNode*)bezier{    
    [self removeBezier:bezier shouldRemoveMarked:YES];
}
//------------------------------------------------------------------------------
-(void) removeAllBezierNodes{
    NSArray* keys = [beziersInLevel allKeys];
    for(NSString* key in keys){
        LHBezierNode* node = [beziersInLevel objectForKey:key];
        if(nil != node){
            [self removeBezier:node];
        }
    }
    [beziersInLevel removeAllObjects];
#ifndef LH_ARC_ENABLED
    [beziersInLevel release];	
#endif
    beziersInLevel = nil;
}
//------------------------------------------------------------------------------
-(void) markBezierForRemoval:(LHBezierNode*) node{
    if(node)
        [markedBeziers addObject:node];
}
//------------------------------------------------------------------------------
-(void) removeMarkedBeziers{
    for(LHBezierNode* node in markedBeziers){
        [self removeBezier:node shouldRemoveMarked:NO];
    }
    [markedBeziers removeAllObjects];
}
////////////////////////////////////////////////////////////////////////////////
//PATH
////////////////////////////////////////////////////////////////////////////////
-(void) createPathOnSprite:(LHSprite*)ccsprite 
            withProperties:(NSDictionary*)spriteProp{
    if(nil == ccsprite || nil == spriteProp)
        return;
    
    NSString* uniqueName = [spriteProp objectForKey:@"PathName"];
    bool isCyclic = [[spriteProp objectForKey:@"PathIsCyclic"] boolValue];
    float pathSpeed = [[spriteProp objectForKey:@"PathSpeed"] floatValue];
    int startPoint = [[spriteProp objectForKey:@"PathStartPoint"] intValue]; //0 is first 1 is end
    bool pathOtherEnd = [[spriteProp objectForKey:@"PathOtherEnd"] boolValue]; //false means will restart where it finishes
    int axisOrientation = [[spriteProp objectForKey:@"PathOrientation"] intValue]; //false means will restart where it finishes
    
    bool flipX = [[spriteProp objectForKey:@"PathFlipX"] boolValue];
    bool flipY = [[spriteProp objectForKey:@"PathFlipY"] boolValue];
	
    bool deltaMove = [[spriteProp objectForKey:@"PathMoveDelta"] boolValue];
    
    if(nil == [spriteProp objectForKey:@"PathMoveDelta"])
        deltaMove = true;
    
    bool startAtLaunch = [[spriteProp objectForKey:@"PathStartAtLaunch"] boolValue];
    
    if(nil == [spriteProp objectForKey:@"PathStartAtLaunch"])
        startAtLaunch = true;
    
    [ccsprite moveOnPathWithUniqueName:uniqueName
                                 speed:pathSpeed
                       startAtEndPoint:startPoint 
                              isCyclic:isCyclic 
                     restartAtOtherEnd:pathOtherEnd 
                       axisOrientation:axisOrientation 
                                 flipX:flipX 
                                 flipY:flipY 
                         deltaMovement:deltaMove 
                        endObserverObj:pathNotifierId 
                        endObserverSel:pathNotifierSel];    
    
    if(!startAtLaunch)
        [ccsprite pausePathMovement:YES];
}
//------------------------------------------------------------------------------
-(void) moveSprite:(LHSprite *)ccsprite onPathWithUniqueName:(NSString*)uniqueName 
			 speed:(float)pathSpeed 
   startAtEndPoint:(bool)startAtEndPoint
          isCyclic:(bool)isCyclic
 restartAtOtherEnd:(bool)restartOtherEnd
   axisOrientation:(int)axis
             flipX:(bool)flipx
             flipY:(bool)flipy
     deltaMovement:(bool)dMove;

{
    if(nil == ccsprite || uniqueName == nil)
        return;
	
	LHBezierNode* node = [self bezierNodeWithUniqueName:uniqueName];
	
	if(nil != node)
	{
		LHPathNode* pathNode = [node addSpriteOnPath:ccsprite
                                               speed:pathSpeed
                                     startAtEndPoint:startAtEndPoint
                                            isCyclic:isCyclic 
                                   restartAtOtherEnd:restartOtherEnd
                                     axisOrientation:axis
                                               flipX:flipx
                                               flipY:flipy
                                       deltaMovement:dMove];
        
        if(nil != pathNode)
        {
            [pathNode setPathNotifierObject:pathNotifierId];
            [pathNode setPathNotifierSelector:pathNotifierSel];
        }
	}
}
-(id)pathNotifierId{
    return pathNotifierId;
}
-(SEL)pathNotifierSEL{
    return pathNotifierSel;
}
//------------------------------------------------------------------------------
-(void) registerNotifierOnAllPathEndPoints:(id)obj selector:(SEL)sel{
    pathNotifierId = obj;
    pathNotifierSel = sel;
}
////////////////////////////////////////////////////////////////////////////////
//SPRITES
////////////////////////////////////////////////////////////////////////////////
-(LHSprite*) spriteWithUniqueName:(NSString*)name{
    return [spritesInLevel objectForKey:name];	
}
//------------------------------------------------------------------------------
-(NSArray*)spritesWithTag:(enum LevelHelper_TAG)tag
{
#ifndef LH_ARC_ENABLED
	NSMutableArray* array = [[[NSMutableArray alloc] init] autorelease];
#else
    NSMutableArray* array = [[NSMutableArray alloc] init];
#endif
	NSArray *keys = [spritesInLevel allKeys];
	for(NSString* key in keys){
		LHSprite* ccSprite = [spritesInLevel objectForKey:key];
		if(nil != ccSprite && [ccSprite tag] == (int)tag){
			[array addObject:ccSprite];
		}
	}
	return array;
}
//------------------------------------------------------------------------------
-(NSArray*)  spritesWithTag:(enum LevelHelper_TAG)tag ordered:(NSComparisonResult)sortOrder{
 
    
    NSMutableArray* spritesWithTag = (NSMutableArray*)[self spritesWithTag:tag];
    
    if(sortOrder == NSOrderedAscending)
    {
        [spritesWithTag sortUsingSelector:@selector(sortAscending:)];        
    }
    else if(sortOrder == NSOrderedDescending)
    {
        [spritesWithTag sortUsingSelector:@selector(sortDescending:)]; 
    }
    
    return spritesWithTag;
}
//------------------------------------------------------------------------------
-(NSArray*)  allSprites{
    return [spritesInLevel allValues];
}
//------------------------------------------------------------------------------
-(void)createSpritesWithPhysics{
    
    for(int i = 0; i < (int)[lhSprites count]; ++i)
	{
        NSDictionary* dictionary = [lhSprites objectAtIndex:i];
		NSDictionary* spriteProp = [dictionary objectForKey:@"GeneralProperties"];
		NSDictionary* physicProp = [dictionary objectForKey:@"PhysicProperties"];
		
#ifndef LH_SCENE_TESTER
        bool handledBySH = [[physicProp objectForKey:@"HandledBySH"] boolValue];
        if(handledBySH)
        {
            NSString* shName = [spriteProp objectForKey:@"SHName"];
            NSString* shScene= [[[spriteProp objectForKey:@"SHScene"] lastPathComponent] stringByDeletingPathExtension];        
            
            physicProp = [[SHDocumentLoader sharedInstance] physicsDictionaryForSpriteNamed:shName inDocument:shScene];
        }
#endif
        
        LHBatch* bNode = [self batchNodeForFile:[spriteProp objectForKey:@"Image"]];
        
        if(bNode)
        {
            //LHBatch* bNode = [batchNodesInLevel objectForKey:[spriteProp objectForKey:@"Image"]];
            CCSpriteBatchNode *batch = [bNode spriteBatchNode];
            if(nil != batch)
            {
                LHSprite* ccsprite = [self spriteWithBatchFromDictionary:spriteProp batchNode:bNode];
            
                if(![[LHSettings sharedInstance] isCoronaUser])
                    [batch addChild:ccsprite z:[[spriteProp objectForKey:@"ZOrder"] intValue]];
                else
                    [cocosLayer addChild:ccsprite];
            
                NSString* uniqueName = [spriteProp objectForKey:@"UniqueName"];
                int bodyType = 3;
                if(nil != [physicProp objectForKey:@"Type"])
                    bodyType = [[physicProp objectForKey:@"Type"] intValue];
                else
                    bodyType = [[physicProp objectForKey:@"PhysicType"] intValue];
                
                if(bodyType != 3) //3 means no physic
                {
                    b2Body* body = [self b2BodyFromDictionary:physicProp
                                             spriteProperties:spriteProp
                                                         data:ccsprite 
                                                        world:box2dWorld
                                                  customScale:nil];
                
                    if(0 != body)
                        [ccsprite setBody:body];
                
                    [spritesInLevel setObject:ccsprite forKey:uniqueName];			
                }
                else {
                    [spritesInLevel setObject:ccsprite forKey:uniqueName];
                    [self setCustomAttributesForNonPhysics:spriteProp
                                                    sprite:ccsprite];
                }
            
                if(//![[spriteProp objectForKey:@"IsInParallax"] boolValue] &&
                   ![[spriteProp objectForKey:@"PathName"] isEqualToString:@"None"])
                {
                    [self createPathOnSprite:ccsprite
                              withProperties:spriteProp];
                }
            
                [self createAnimationFromDictionary:spriteProp onCCSprite:ccsprite];
                [ccsprite postInitialization];
            }
        }
        
        //calculate progress loading
        float val = ((float)(i+1.0f)/(float)[lhSprites count])*0.30f;
        [self callLoadingProgressObserverWithValue:0.50f+val];
	}
}
//------------------------------------------------------------------------------
-(void) setFixtureDefPropertiesFromDictionary:(NSDictionary*)spritePhysic 
									  fixture:(b2FixtureDef*)shapeDef
{
	shapeDef->density = [[spritePhysic objectForKey:@"Density"] floatValue];
	shapeDef->friction = [[spritePhysic objectForKey:@"Friction"] floatValue];
	shapeDef->restitution = [[spritePhysic objectForKey:@"Restitution"] floatValue];
	
	shapeDef->filter.categoryBits = [[spritePhysic objectForKey:@"Category"] intValue];
	shapeDef->filter.maskBits = [[spritePhysic objectForKey:@"Mask"] intValue];
	shapeDef->filter.groupIndex = [[spritePhysic objectForKey:@"Group"] intValue];
    
    shapeDef->isSensor = [[spritePhysic objectForKey:@"IsSensor"] boolValue];
    
    if(nil != [spritePhysic objectForKey:@"IsSenzor"]){//in case we load a 1.3 level
	    shapeDef->isSensor = [[spritePhysic objectForKey:@"IsSenzor"] boolValue];
    }
}
//------------------------------------------------------------------------------
-(b2Body*) b2BodyFromDictionary:(NSDictionary*)spritePhysic
			   spriteProperties:(NSDictionary*)spriteProp
						   data:(LHSprite*)ccsprite 
						  world:(b2World*)_world
                    customScale:(CGSize*)customScale
{
	b2BodyDef bodyDef;	
	
    NSNumber* pType = [spritePhysic objectForKey:@"Type"]; //LH
    
    if(nil == pType)
    {
        pType = [spritePhysic objectForKey:@"PhysicType"];//SH
    }
	int bodyType = [pType intValue];
    
	if(bodyType == 3) //in case the user wants to create a body with a sprite that has type as "NO_PHYSIC"
		bodyType = 2;
	bodyDef.type = (b2BodyType)bodyType;
	
	CGPoint pos = [ccsprite position];	
	bodyDef.position.Set(pos.x/[[LHSettings sharedInstance] lhPtmRatio],pos.y/[[LHSettings sharedInstance] lhPtmRatio]);
    
	bodyDef.angle = CC_DEGREES_TO_RADIANS(-1*[[spriteProp objectForKey:@"Angle"] floatValue]);
    
#ifndef LH_ARC_ENABLED
    bodyDef.userData = ccsprite;
#else
    bodyDef.userData = (__bridge void*)ccsprite;
#endif
    
	b2Body* body = _world->CreateBody(&bodyDef);
    
    NSNumber* fixRot = [spritePhysic objectForKey:@"FixedRot"]; //LH
    if(nil == fixRot)
        fixRot = [spritePhysic objectForKey:@"IsFixedRot"];//SH
    
	body->SetFixedRotation([fixRot boolValue]);
	
    NSString* linearVel = [spritePhysic objectForKey:@"LinearVelocity"];//LH
	CGPoint linearVelocity = CGPointZero;
    if (nil != linearVel) {
        linearVelocity = LHPointFromString(linearVel);
    }
    else {
        linearVelocity.x = [[spritePhysic objectForKey:@"LinearVelocityX"] floatValue];
        linearVelocity.y = [[spritePhysic objectForKey:@"LinearVelocityY"] floatValue];
    }
    
	
    float linearDamping = [[spritePhysic objectForKey:@"LinearDamping"] floatValue]; 
    float angularVelocity = [[spritePhysic objectForKey:@"AngularVelocity"] floatValue];
    float angularDamping = [[spritePhysic objectForKey:@"AngularDamping"] floatValue];     
    
    bool isBullet = [[spritePhysic objectForKey:@"IsBullet"] boolValue];
    bool canSleep = [[spritePhysic objectForKey:@"CanSleep"] boolValue];
	
	
	NSArray* fixtures = [spritePhysic objectForKey:@"ShapeFixtures"];//LH
    
    if(nil == fixtures)
        fixtures = [spritePhysic objectForKey:@"Fixtures"];//SH
    
    CGPoint scale = LHPointFromString([spriteProp objectForKey:@"Scale"]);
    
    CGPoint size = CGPointZero;
    if([spriteProp objectForKey:@"Size"]){
        size = LHPointFromString([spriteProp objectForKey:@"Size"]);    
    }
    else {
        CGRect frm = LHRectFromString([spriteProp objectForKey:@"Frame"]);
        size = CGPointMake(frm.size.width, frm.size.height);
    }
    
    CGPoint border = CGPointZero;
    NSString* shapeBor = [spritePhysic objectForKey:@"ShapeBorder"]; //LH
    if(nil != shapeBor){
        border = LHPointFromString(shapeBor);
    }
    else {
        border.x = [[spritePhysic objectForKey:@"ShapeBorderW"]floatValue];//SH
        border.y = [[spritePhysic objectForKey:@"ShapeBorderH"]floatValue];//SH
    }
    
    CGPoint offset = CGPointZero;
    NSString* shapePosOff = [spritePhysic objectForKey:@"ShapePositionOffset"];//LH
    
    if(nil != shapePosOff){
        offset = LHPointFromString(shapePosOff);
    }
    else {
        offset.x = [[spritePhysic objectForKey:@"ShapePositionOffsetX"] floatValue];//SH
        offset.y = [[spritePhysic objectForKey:@"ShapePositionOffsetY"] floatValue];//SH
    }
	
    NSNumber* gravityScl = [spritePhysic objectForKey:@"GravityScale"]; //LH
    
    float gravityScale = 1.0f; 
    if(nil != gravityScl)
        gravityScale = [gravityScl floatValue];
	
    scale.x *= [[LHSettings sharedInstance] convertRatio].x;
    scale.y *= [[LHSettings sharedInstance] convertRatio].y;        
    
    if(customScale){
        scale.x *= customScale->width;
        scale.y *= customScale->height;
    }

//   NSLog(@"CUSTOM SCALE %f %f - size %f %f", scale.x, scale.y, size.x, size.y);
//	if(scale.x == 0)
//		scale.x = 0.01;
//	if(scale.y == 0)
//		scale.y = 0.01;
	
	if(fixtures == nil || (int)[fixtures count] == 0 || (int)[(NSArray*)[fixtures objectAtIndex:0] count] == 0)
	{
		b2PolygonShape shape;
		b2FixtureDef fixture;
		b2CircleShape circle;
		[self setFixtureDefPropertiesFromDictionary:spritePhysic fixture:&fixture];
		
		if([[spritePhysic objectForKey:@"IsCircle"] boolValue])
		{
            if([[LHSettings sharedInstance] convertLevel])
            {
			    //this is for the ipad scale on circle look weird if we dont do this
                float scaleSpr = [ccsprite scaleX];
                [ccsprite setScaleY:scaleSpr];
            }
            
			float circleScale = scale.x; //if we dont do this we dont have collision
			if(circleScale < 0)
				circleScale = -circleScale;
						
            float radius = ((size.x - border.x/2.0f)*circleScale/2.0f)/[[LHSettings sharedInstance] lhPtmRatio];
            
			if(radius < 0)
				radius *= -1;
			circle.m_radius = radius; 
			
			circle.m_p.Set(offset.x/2.0f/[[LHSettings sharedInstance] lhPtmRatio], -offset.y/2.0f/[[LHSettings sharedInstance] lhPtmRatio]);
			
			fixture.shape = &circle;
            body->CreateFixture(&fixture);
		}
		else
		{
            //THIS WAS ADDED BECAUSE I DISCOVER A BUG IN BOX2d
            //that makes linearImpulse to not work the body is in contact with
            //a box object
            int vsize = 4;
			b2Vec2 *verts = new b2Vec2[vsize];
			b2PolygonShape shape;
			
            float ptm = [[LHSettings sharedInstance] lhPtmRatio];
            
            if(scale.x * scale.y < 0.0f)
            {
                verts[3].x = ( (-1* size.x + border.x/2.0f)*scale.x/2.0f+offset.x/2.0f)/ptm;
                verts[3].y = ( (-1* size.y + border.y/2.0f)*scale.y/2.0f-offset.y/2.0f)/ptm;
                
                verts[2].x = ( (+ size.x - border.x/2.0f)*scale.x/2.0f+offset.x/2.0f)/ptm;
                verts[2].y = ( (-1* size.y + border.y/2.0f)*scale.y/2.0f-offset.y/2.0f)/ptm;
                
                verts[1].x = ( (+ size.x - border.x/2.0f)*scale.x/2.0f+offset.x/2.0f)/ptm;
                verts[1].y = ( (+ size.y - border.y/2.0f)*scale.y/2.0f-offset.y/2.0f)/ptm;
                
                verts[0].x = ( (-1* size.x + border.x/2.0f)*scale.x/2.0f+offset.x/2.0f)/ptm;
                verts[0].y = ( (+ size.y - border.y/2.0f)*scale.y/2.0f-offset.y/2.0f)/ptm;
            }
            else
            {
                verts[0].x = ( (-1* size.x + border.x/2.0f)*scale.x/2.0f+offset.x/2.0f)/ptm;
                verts[0].y = ( (-1* size.y + border.y/2.0f)*scale.y/2.0f-offset.y/2.0f)/ptm;
                
                verts[1].x = ( (+ size.x - border.x/2.0f)*scale.x/2.0f+offset.x/2.0f)/ptm;
                verts[1].y = ( (-1* size.y + border.y/2.0f)*scale.y/2.0f-offset.y/2.0f)/ptm;
                
                verts[2].x = ( (+ size.x - border.x/2.0f)*scale.x/2.0f+offset.x/2.0f)/ptm;
                verts[2].y = ( (+ size.y - border.y/2.0f)*scale.y/2.0f-offset.y/2.0f)/ptm;
                
                verts[3].x = ( (-1* size.x + border.x/2.0f)*scale.x/2.0f+offset.x/2.0f)/ptm;
                verts[3].y = ( (+ size.y - border.y/2.0f)*scale.y/2.0f-offset.y/2.0f)/ptm;
                
            }

            
			shape.Set(verts, vsize);		
            
			fixture.shape = &shape;
            body->CreateFixture(&fixture);
            delete[] verts;
		}
	}
	else
	{
		for(NSArray* curFixture in fixtures)
		{
			int size = (int)[curFixture count];
			b2Vec2 *verts = new b2Vec2[size];
			b2PolygonShape shape;
			int i = 0;
			for(NSString* pointStr in curFixture)
			{
				CGPoint point = LHPointFromString(pointStr);
				verts[i] = b2Vec2((point.x*(scale.x)+offset.x/2.0f)/[[LHSettings sharedInstance] lhPtmRatio], 
								  (point.y*(scale.y)-offset.y/2.0f)/[[LHSettings sharedInstance] lhPtmRatio]);
				++i;
			}
			shape.Set(verts, size);		
			b2FixtureDef fixture;
			[self setFixtureDefPropertiesFromDictionary:spritePhysic fixture:&fixture];
			fixture.shape = &shape;
			body->CreateFixture(&fixture);
			delete[] verts;
		}
	}
	
    [self setCustomAttributesForPhysics:spriteProp 
								   body:body
								 sprite:ccsprite];
	
	body->SetGravityScale(gravityScale);
	body->SetSleepingAllowed(canSleep);    
    body->SetBullet(isBullet);
    body->SetLinearVelocity(b2Vec2(linearVelocity.x, linearVelocity.y));
    body->SetAngularVelocity(angularVelocity);
    body->SetLinearDamping(linearDamping);
    body->SetAngularDamping(angularDamping);
	
	
	return body;
	
}
//------------------------------------------------------------------------------
-(void)releaseAllSprites{
    [self removeAllSprites];
    [markedSprites removeAllObjects];
	[spritesInLevel removeAllObjects];
#ifndef LH_ARC_ENABLED
    [spritesInLevel release];
#endif
    spritesInLevel = nil;
}
//------------------------------------------------------------------------------
-(bool)removeSprite:(LHSprite *)ccsprite shouldRemoveMarkedSprites:(bool)shouldRemoveMarked
{
	if(nil == ccsprite)
		return false;
    
    if([ccsprite respondsToSelector:@selector(uniqueName)]){
        
        for(LHJoint* jt in [ccsprite jointList])
            [markedJoints removeObject:jt];
        
        [LevelHelperLoader removeTouchDispatcherFromObject:ccsprite];
        [spritesInLevel removeObjectForKey:[ccsprite uniqueName]];
    }
    if(shouldRemoveMarked){
        [markedSprites removeObject:ccsprite];
    }
    [ccsprite removeFromCocos2dParentNode:YES];	
	return true;
}
//------------------------------------------------------------------------------
-(bool) removeSprite:(LHSprite*)ccsprite{
    return [self removeSprite:ccsprite shouldRemoveMarkedSprites:YES];
}
//------------------------------------------------------------------------------
-(bool) removeSpritesWithTag:(enum LevelHelper_TAG)tag{
	NSArray *keys = [spritesInLevel allKeys];
    if(nil == keys)
        return false;
	for(NSString* key in keys){
        LHSprite* spr = [self spriteWithUniqueName:key];
        if(nil != spr){
            if(tag == [spr tag]){
                [self removeSprite:spr];
            }
        }
	}
	return true;	
}
//------------------------------------------------------------------------------
-(bool) removeAllSprites{	
	NSArray *keys = [spritesInLevel allKeys];
    if(keys == nil)
        return false;
	for(NSString* key in keys){
        if(key != nil){
            LHSprite* spr = [self spriteWithUniqueName:key];
            [self removeSprite:spr];
        }
	}
	return true;	
}
//------------------------------------------------------------------------------
-(void) markSpriteForRemoval:(LHSprite*)ccsprite{
    
    if(nil == ccsprite)
        return;
        
    [markedSprites addObject:ccsprite];
}
//------------------------------------------------------------------------------
-(void) removeMarkedSprites
{
    for(LHSprite* spr in markedSprites){
        [self removeSprite:spr shouldRemoveMarkedSprites:NO];
    }
    [markedSprites removeAllObjects];
}
//------------------------------------------------------------------------------
-(LHSprite*) createSpriteWithGeneralPropDictionary:(NSDictionary*)spriteProp andName:(NSString*)name
{
    LHSprite* ccsprite =  [self spriteFromDictionary:spriteProp];
        
    NSString* uName = [NSString stringWithFormat:@"%@_LH_NEW_SPRITE_%d", 
                       name, [[LHSettings sharedInstance] newBodyId]];
    [ccsprite setUniqueName:uName];
    [spritesInLevel setObject:ccsprite forKey:uName];
    [ccsprite postInitialization];
    return ccsprite;
}
//------------------------------------------------------------------------------
-(LHSprite*) createSpriteWithUniqueName:(NSString *)name{
    for(NSDictionary* dictionary in lhSprites){
		NSDictionary* spriteProp = [dictionary objectForKey:@"GeneralProperties"];
		if([[spriteProp objectForKey:@"UniqueName"] isEqualToString:name]){            
            return [self createSpriteWithGeneralPropDictionary:spriteProp andName:name];
        }
    }
    return nil;
}
-(LHSprite*) newSpriteWithUniqueName:(NSString *)name{
    return [self createSpriteWithUniqueName:name];
}
//------------------------------------------------------------------------------
-(LHSprite*) createPhysicalSpriteWithUniqueName:(NSString*)name{
    return [self createPhysicalSpriteWithUniqueName:name newBodyScale:nil];
}
-(LHSprite*) newPhysicalSpriteWithUniqueName:(NSString*)name{
    return [self createPhysicalSpriteWithUniqueName:name];
}
//------------------------------------------------------------------------------
-(LHSprite*)createPhysicalSpriteWithGeneralProp:(NSDictionary*)spriteProp 
                                   physicalProp:(NSDictionary*)physicProp 
                                      bodyScale:(CGSize*)newScale
                                        andName:(NSString*)name
{
    
    LHSprite* ccsprite = [self spriteFromDictionary:spriteProp];
    
    if(newScale){
        [ccsprite setScaleX:newScale->width];
        [ccsprite setScaleY:newScale->height];
    }
    
    b2Body* body =  [self b2BodyFromDictionary:physicProp
                              spriteProperties:spriteProp
                                          data:ccsprite 
                                         world:box2dWorld
                                   customScale:newScale];
    
    if(0 != body)
        [ccsprite setBody:body];
    
    NSString* uName = [NSString stringWithFormat:@"%@_LH_NEW_BODY_%d", 
                       name, [[LHSettings sharedInstance] newBodyId]];
    [ccsprite setUniqueName:uName];
    
    [spritesInLevel setObject:ccsprite forKey:uName];
    [ccsprite postInitialization];
    return ccsprite;
}
-(LHSprite*) createPhysicalSpriteWithUniqueName:(NSString *)name newBodyScale:(CGSize*)newScale{
    for(NSDictionary* dictionary in lhSprites){
		NSDictionary* spriteProp = [dictionary objectForKey:@"GeneralProperties"];
		if([[spriteProp objectForKey:@"UniqueName"] isEqualToString:name]){            
            NSDictionary* physicProp = [dictionary objectForKey:@"PhysicProperties"];
           
            
            return [self createPhysicalSpriteWithGeneralProp:spriteProp
                                                physicalProp:physicProp
                                                   bodyScale:newScale
                                                     andName:name];
        }
    }
    return nil;    
}
-(LHSprite*) newPhysicalSpriteWithUniqueName:(NSString *)name newBodyScale:(CGSize*)newScale{
    return [self createPhysicalSpriteWithUniqueName:name newBodyScale:newScale];
}
//------------------------------------------------------------------------------
-(LHSprite*)createBatchSpriteWithGeneralPropDictionary:(NSDictionary*)spriteProp andName:(NSString*)name
{
    LHBatch* bNode = [self batchNodeForFile:[spriteProp objectForKey:@"Image"]];
    //LHBatch* bNode = [batchNodesInLevel objectForKey:[spriteProp objectForKey:@"Image"]];
    if(nil != bNode){
        CCSpriteBatchNode *batch = [bNode spriteBatchNode];
        if(nil != batch){
            LHSprite* ccsprite = [self spriteWithBatchFromDictionary:spriteProp batchNode:bNode];
            [batch addChild:ccsprite z:[[spriteProp objectForKey:@"ZOrder"] intValue]];
            
            NSString* uName = [NSString stringWithFormat:@"%@_LH_NEW_BATCH_SPRITE_%d", 
                               name, [[LHSettings sharedInstance] newBodyId]];
            [ccsprite setUniqueName:uName];
            [spritesInLevel setObject:ccsprite forKey:uName];
            [ccsprite postInitialization];
            return ccsprite;
        }
    }
    return nil;
}
//------------------------------------------------------------------------------
-(LHSprite*) createBatchSpriteWithUniqueName:(NSString*)name{
	for(NSDictionary* dictionary in lhSprites)
    {
		NSDictionary* spriteProp = [dictionary objectForKey:@"GeneralProperties"];
		if([[spriteProp objectForKey:@"UniqueName"] isEqualToString:name]){             
            return [self createBatchSpriteWithGeneralPropDictionary:spriteProp andName:name];
        }
    }
    return nil;
}
-(LHSprite*) newBatchSpriteWithUniqueName:(NSString *)name{
    return [self createBatchSpriteWithUniqueName:name];
}
//------------------------------------------------------------------------------
-(LHSprite*) createPhysicalBatchSpriteWithUniqueName:(NSString*)name{
    return [self createPhysicalBatchSpriteWithUniqueName:name newBodyScale:nil];
}
-(LHSprite*) newPhysicalBatchSpriteWithUniqueName:(NSString *)name{
    return [self createPhysicalBatchSpriteWithUniqueName:name];
}
//------------------------------------------------------------------------------
-(LHSprite*)createPhysicalBatchSpriteWithGeneralProp:(NSDictionary*)spriteProp
                                          physicProp:(NSDictionary*)physicProp
                                           bodyScale:(CGSize*)newScale
                                                name:(NSString*)name
{
    //find the coresponding batch node for this sprite
    //LHBatch* bNode = [batchNodesInLevel objectForKey:[spriteProp objectForKey:@"Image"]];
    LHBatch* bNode = [self batchNodeForFile:[spriteProp objectForKey:@"Image"]];
    if(nil != bNode){
        CCSpriteBatchNode *batch = [bNode spriteBatchNode];
        if(nil != batch){
            LHSprite* ccsprite = [self spriteWithBatchFromDictionary:spriteProp batchNode:bNode];
            [batch addChild:ccsprite z:[[spriteProp objectForKey:@"ZOrder"] intValue]];
            
            if(newScale){
                [ccsprite setScaleX:newScale->width];
                [ccsprite setScaleY:newScale->height];
            }
            
            b2Body* body =  [self b2BodyFromDictionary:physicProp
                                      spriteProperties:spriteProp
                                                  data:ccsprite 
                                                 world:box2dWorld
                                           customScale:newScale];
            
            if(0 != body)
                [ccsprite setBody:body];
            
            NSString* uName = [NSString stringWithFormat:@"%@_LH_NEW_BATCH_BODY_%d", 
                               name, [[LHSettings sharedInstance] newBodyId]];
            [ccsprite setUniqueName:uName];
            [spritesInLevel setObject:ccsprite forKey:uName];
            [ccsprite postInitialization];
            return ccsprite;
        }
    }
    return nil;
}
//------------------------------------------------------------------------------
-(LHSprite*) createPhysicalBatchSpriteWithUniqueName:(NSString *)name newBodyScale:(CGSize*)newScale{
    for(NSDictionary* dictionary in lhSprites)
    {
		NSDictionary* spriteProp = [dictionary objectForKey:@"GeneralProperties"];
		if([[spriteProp objectForKey:@"UniqueName"] isEqualToString:name]){            
            NSDictionary* physicProp = [dictionary objectForKey:@"PhysicProperties"];
            
            return [self createPhysicalBatchSpriteWithGeneralProp:spriteProp
                                                       physicProp:physicProp
                                                        bodyScale:newScale
                                                             name:name];
        }
    }
    return nil;
}
-(LHSprite*) newPhysicalBatchSpriteWithUniqueName:(NSString *)name newBodyScale:(CGSize*)newScale{
    return [self createPhysicalBatchSpriteWithUniqueName:name newBodyScale:newScale];
}
//------------------------------------------------------------------------------
-(LHSprite*) createSpriteWithName:(NSString*)name 
            fromSpriteHelperScene:(NSString*)sceneName{
    
    NSDictionary* spriteProp = [[SHDocumentLoader sharedInstance] textureDictionaryForSpriteNamed:name inDocument:sceneName];
    
    if(nil != spriteProp){
        return [self createSpriteWithGeneralPropDictionary:spriteProp andName:name];        
    }
    return nil;
}
-(LHSprite*) newSpriteWithName:(NSString*)name fromSpriteHelperScene:(NSString*)sceneName{
    return [self createSpriteWithName:name 
                fromSpriteHelperScene:sceneName];
}
//------------------------------------------------------------------------------
-(LHSprite*) createSpriteWithName:(NSString*)name fromSpriteHelperScene:(NSString*)sceneName tag:(LevelHelper_TAG)tag
{
    NSDictionary* spriteProp = [[SHDocumentLoader sharedInstance] textureDictionaryForSpriteNamed:name inDocument:sceneName];
    
    if(nil != spriteProp){
        
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:spriteProp];
        [dic setObject:[NSNumber numberWithInt:tag] forKey:@"Tag"];
        
        return [self createSpriteWithGeneralPropDictionary:dic andName:name];        
    }
    return nil;
}
//------------------------------------------------------------------------------
-(LHSprite*) createBatchSpriteWithName:(NSString*)name 
                 fromSpriteHelperScene:(NSString*)sceneName{
 
    NSDictionary* spriteProp = [[SHDocumentLoader sharedInstance] textureDictionaryForSpriteNamed:name inDocument:sceneName];
    
    if(spriteProp){      
        return [self createBatchSpriteWithGeneralPropDictionary:spriteProp andName:name];
    }
    return nil;
}
-(LHSprite*) newBatchSpriteWithName:(NSString*)name fromSpriteHelperScene:(NSString*)sceneName{
   return [self createBatchSpriteWithName:name 
                    fromSpriteHelperScene:sceneName];
}
//------------------------------------------------------------------------------
-(LHSprite*) createBatchSpriteWithName:(NSString*)name fromSpriteHelperScene:(NSString*)sceneName tag:(LevelHelper_TAG)tag
{
    NSDictionary* spriteProp = [[SHDocumentLoader sharedInstance] textureDictionaryForSpriteNamed:name inDocument:sceneName];
    
    if(spriteProp){      
        
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:spriteProp];
        [dic setObject:[NSNumber numberWithInt:tag] forKey:@"Tag"];
        
        return [self createBatchSpriteWithGeneralPropDictionary:dic andName:name];
    }
    return nil;    
}
//------------------------------------------------------------------------------
-(LHSprite*) createPhysicalSpriteWithName:(NSString*)name 
                    fromSpriteHelperScene:(NSString*)sceneName{
    
    NSDictionary* spriteProp = [[SHDocumentLoader sharedInstance] textureDictionaryForSpriteNamed:name inDocument:sceneName];
    NSDictionary* physicProp = [[SHDocumentLoader sharedInstance] physicsDictionaryForSpriteNamed:name inDocument:sceneName];
    
    if(spriteProp && physicProp)
    {
	        return [self createPhysicalSpriteWithGeneralProp:spriteProp
                                                physicalProp:physicProp
                                                   bodyScale:nil
                                                     andName:name];
    }
    return nil;    
}
-(LHSprite*) newPhysicalSpriteWithName:(NSString*)name fromSpriteHelperScene:(NSString*)sceneName{
    return [self createPhysicalSpriteWithName:name 
                        fromSpriteHelperScene:sceneName];
}
//------------------------------------------------------------------------------
-(LHSprite*) createPhysicalSpriteWithName:(NSString*)name 
                 fromSpriteHelperScene:(NSString*)sceneName 
                                   tag:(LevelHelper_TAG)tag
{
    NSDictionary* spriteProp = [[SHDocumentLoader sharedInstance] textureDictionaryForSpriteNamed:name inDocument:sceneName];
    NSDictionary* physicProp = [[SHDocumentLoader sharedInstance] physicsDictionaryForSpriteNamed:name inDocument:sceneName];
    
    if(spriteProp && physicProp)
    {
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:spriteProp];
        [dic setObject:[NSNumber numberWithInt:tag] forKey:@"Tag"];
        
        return [self createPhysicalSpriteWithGeneralProp:dic
                                            physicalProp:physicProp
                                               bodyScale:nil
                                                 andName:name];
    }
    return nil;    
}
//------------------------------------------------------------------------------
-(LHSprite*) createPhysicalBatchSpriteWithName:(NSString*)name 
                         fromSpriteHelperScene:(NSString*)sceneName{
    
    NSDictionary* spriteProp = [[SHDocumentLoader sharedInstance] textureDictionaryForSpriteNamed:name inDocument:sceneName];
    NSDictionary* physicProp = [[SHDocumentLoader sharedInstance] physicsDictionaryForSpriteNamed:name inDocument:sceneName];
    
    if(spriteProp && physicProp)
    {            
            return [self createPhysicalBatchSpriteWithGeneralProp:spriteProp
                                                       physicProp:physicProp
                                                        bodyScale:nil
                                                             name:name];
    }
    return nil;
}
-(LHSprite*) newPhysicalBatchSpriteWithName:(NSString*)name fromSpriteHelperScene:(NSString*)sceneName{
    return [self createPhysicalBatchSpriteWithName:name 
                             fromSpriteHelperScene:sceneName];
}
//------------------------------------------------------------------------------
-(LHSprite*) createPhysicalBatchSpriteWithName:(NSString*)name 
                      fromSpriteHelperScene:(NSString*)sceneName 
                                        tag:(LevelHelper_TAG)tag
{
    NSDictionary* spriteProp = [[SHDocumentLoader sharedInstance] textureDictionaryForSpriteNamed:name inDocument:sceneName];
    NSDictionary* physicProp = [[SHDocumentLoader sharedInstance] physicsDictionaryForSpriteNamed:name inDocument:sceneName];
    
    if(spriteProp && physicProp)
    {            
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:spriteProp];
        [dic setObject:[NSNumber numberWithInt:tag] forKey:@"Tag"];
        
        return [self createPhysicalBatchSpriteWithGeneralProp:dic
                                                   physicProp:physicProp
                                                    bodyScale:nil
                                                         name:name];
    }
    return nil;

}
//------------------------------------------------------------------------------
-(LHSprite*) spriteFromDictionary:(NSDictionary*)spriteProp{
    
    CGRect uv = CGRectZero;
    
    NSString* uvInfo = [spriteProp objectForKey:@"UV"];
    if(nil == uvInfo){
        uvInfo = [spriteProp objectForKey:@"Frame"];
    }
    uv = LHRectFromString(uvInfo);
    
    NSString* img = [[LHSettings sharedInstance] 
                                    imagePath:[spriteProp objectForKey:@"Image"] 
                                    imageFolder:imageFolder];
    
    if([[LHSettings sharedInstance] shouldScaleImageOnRetina:img])
    {
        uv.origin.x *=2.0f;
        uv.origin.y *=2.0f;
        uv.size.width *=2.0f;
        uv.size.height *=2.0f;
    }
    int sprTag = [[spriteProp objectForKey:@"Tag"] intValue];
    Class spriteClass = [[LHCustomSpriteMgr sharedInstance] customSpriteClassForTag:(LevelHelper_TAG)sprTag];

	LHSprite *ccsprite = [spriteClass spriteWithFile:img
                                                rect:uv];
    
	[self setSpriteProperties:ccsprite spriteProperties:spriteProp];
	return ccsprite;
}
//------------------------------------------------------------------------------
-(LHSprite*) spriteWithBatchFromDictionary:(NSDictionary*)spriteProp 
								 batchNode:(LHBatch*)lhBatch{
    
    CGRect uv = CGRectZero;    
    NSString* uvInfo = [spriteProp objectForKey:@"UV"];
    if(nil == uvInfo){
        uvInfo = [spriteProp objectForKey:@"Frame"];
    }
    uv = LHRectFromString(uvInfo);
    
    if(lhBatch == nil)
        return nil;
    
    CCSpriteBatchNode* batch = [lhBatch spriteBatchNode];
    
    if(batch == nil)
        return nil;
    
    NSString* img = [[LHSettings sharedInstance] 
                                        imagePath:[lhBatch uniqueName]
                                        imageFolder:imageFolder];
    
    if([[LHSettings sharedInstance] shouldScaleImageOnRetina:img])
    {
        uv.origin.x *=2.0f;
        uv.origin.y *=2.0f;
        uv.size.width *=2.0f;
        uv.size.height *=2.0f;
    }
    
    LHSprite *ccsprite = nil;
    
    int sprTag = [[spriteProp objectForKey:@"Tag"] intValue];
    Class spriteClass = [[LHCustomSpriteMgr sharedInstance] customSpriteClassForTag:(LevelHelper_TAG)sprTag];
    
    if(![[LHSettings sharedInstance] isCoronaUser])
    {
        ccsprite = [spriteClass spriteWithBatchNode:batch 
                                               rect:uv];
    }
    else
    {
        ccsprite = [spriteClass spriteWithFile:img
                                       rect:uv];
    }
        
	[self setSpriteProperties:ccsprite spriteProperties:spriteProp];
	return ccsprite;	
}
//------------------------------------------------------------------------------
-(void) setSpriteProperties:(LHSprite*)ccsprite
           spriteProperties:(NSDictionary*)spriteProp
{
    NSString* uName = [spriteProp objectForKey:@"UniqueName"];
    if(nil == uName)
        uName = [spriteProp objectForKey:@"Name"];
    [ccsprite setUniqueName:uName];
    
    
	//convert position from LH to Cocos2d coordinates
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	CGPoint position = LHPointFromString([spriteProp objectForKey:@"Position"]);
	
	position.x *= [[LHSettings sharedInstance] convertRatio].x;
	position.y *= [[LHSettings sharedInstance] convertRatio].y;
    
    position.y = winSize.height - position.y;
    
    CGPoint pos_offset = [[LHSettings sharedInstance] possitionOffset];
    
    position.x += pos_offset.x;
    position.y -= pos_offset.y;
    
	[ccsprite setPosition:position];
	[ccsprite setRotation:[[spriteProp objectForKey:@"Angle"] floatValue]];
	[ccsprite setOpacity:255*[[spriteProp objectForKey:@"Opacity"] floatValue]*[[LHSettings sharedInstance] customAlpha]];
	CGRect color = LHRectFromString([spriteProp objectForKey:@"Color"]);
	[ccsprite setColor:ccc3(255*color.origin.x, 255*color.origin.y, 255*color.size.width)];
	CGPoint scale = LHPointFromString([spriteProp objectForKey:@"Scale"]);
    
    NSNumber* isDrawable = [spriteProp objectForKey:@"IsDrawable"]; 
    
   // NSLog(@"DRAWABLE %@ - spr %d %@", isDrawable, [isDrawable boolValue], [ccsprite uniqueName]);
    
    if(isDrawable)
        [ccsprite setVisible:[isDrawable boolValue]];
    
    int tag = [[spriteProp objectForKey:@"Tag"] intValue];
    
    [ccsprite setTag:tag];
    
	scale.x *= [[LHSettings sharedInstance] convertRatio].x;
	scale.y *= [[LHSettings sharedInstance] convertRatio].y;
	    
    NSString* img = [[LHSettings sharedInstance] 
                                            imagePath:[spriteProp objectForKey:@"Image"]
                                            imageFolder:imageFolder];
    
    [ccsprite setRealScale:CGSizeMake(scale.x, scale.y)];
    
    if([[LHSettings sharedInstance] shouldScaleImageOnRetina:img])
    {
        scale.x /=2.0f;
        scale.y /=2.0f;        
    }
    
    //this is to fix a noise issue on cocos2d.
   // scale.x += 0.0005f*scale.x;
   // scale.y += 0.0005f*scale.y;
    
    [ccsprite setImageFile:img];
    
       
	[ccsprite setScaleX:scale.x];
	[ccsprite setScaleY:scale.y];

    [ccsprite setParentLoader:self];
    
    [LevelHelperLoader setTouchDispatcherForObject:ccsprite tag:tag];
}

-(NSString*) imageFolder{
    return imageFolder;
}

////////////////////////////////////////////////////////////////////////////////
//PARALLAX
////////////////////////////////////////////////////////////////////////////////
-(LHParallaxNode*) parallaxNodeWithUniqueName:(NSString*)uniqueName{
    return [parallaxesInLevel objectForKey:uniqueName];
}
-(LHParallaxNode*) paralaxNodeWithUniqueName:(NSString*)uniqueName{
    return [self parallaxNodeWithUniqueName:uniqueName];
}
//------------------------------------------------------------------------------
-(NSArray*) allParallaxes{
    return [parallaxesInLevel allValues];
}
//------------------------------------------------------------------------------
-(void) createParallaxes
{
    for(NSDictionary* parallaxDict in lhParallax){
		LHParallaxNode* node = [self parallaxNodeFromDictionary:parallaxDict layer:cocosLayer];
        if(nil != node){
			[parallaxesInLevel setObject:node forKey:[parallaxDict objectForKey:@"UniqueName"]];
		}
    }
}
//------------------------------------------------------------------------------
-(LHParallaxNode*) parallaxNodeFromDictionary:(NSDictionary*)parallaxDict 
                                        layer:(CCLayer*)layer 
{
	LHParallaxNode* node = [LHParallaxNode nodeWithDictionary:parallaxDict loader:self];
    
    if(layer != nil && node != nil){
        int z = [[parallaxDict objectForKey:@"ZOrder"] intValue];
        [layer addChild:node z:z];
    }
    NSArray* spritesInfo = [parallaxDict objectForKey:@"Sprites"];
    for(NSDictionary* sprInf in spritesInfo){
        float ratioX = [[sprInf objectForKey:@"RatioX"] floatValue];
        float ratioY = [[sprInf objectForKey:@"RatioY"] floatValue];
        NSString* sprName = [sprInf objectForKey:@"SpriteName"];
        
		LHSprite* spr = [self spriteWithUniqueName:sprName];
		if(nil != node && spr != nil){
			[node addSprite:spr parallaxRatio:ccp(ratioX, ratioY)];
		}
    }
    return node;
}
//------------------------------------------------------------------------------
-(void)removeParallaxNode:(LHParallaxNode*)node{
    [self removeParallaxNode:node removeChildSprites:NO];
}
//------------------------------------------------------------------------------
-(void) removeParallaxNode:(LHParallaxNode*)node removeChildSprites:(bool)rem{
    
    if(NULL == node)
        return;    
    
    [node setRemoveChildSprites:rem];
    [parallaxesInLevel removeObjectForKey:[node uniqueName]];
    [node removeFromParentAndCleanup:YES];
}
//------------------------------------------------------------------------------
-(void) removeAllParallaxes{
    [self removeAllParallaxesAndChildSprites:NO];
}
//------------------------------------------------------------------------------
-(void) removeAllParallaxesAndChildSprites:(bool)remChilds{

    NSArray* keys = [parallaxesInLevel allKeys];
    
	for(NSString* key in keys){
		LHParallaxNode* par = [parallaxesInLevel objectForKey:key];
		if(nil != par){
            [par setRemoveChildSprites:remChilds];
            [par removeFromParentAndCleanup:YES];
		}
	}
	[parallaxesInLevel removeAllObjects];
}
//------------------------------------------------------------------------------
-(void) releaseAllParallaxes
{
    [self removeAllParallaxes];
#ifndef LH_ARC_ENABLED
	[parallaxesInLevel release];
#endif
    parallaxesInLevel = nil;
}
////////////////////////////////////////////////////////////////////////////////
//JOINTS
////////////////////////////////////////////////////////////////////////////////
-(LHJoint*) jointFromDictionary:(NSDictionary*)joint world:(b2World*)world
{
    b2Joint* boxJoint = 0;
    
	if(nil == joint)
		return 0;
	
	if(world == 0)
		return 0;
    
    LHSprite* sprA = [spritesInLevel objectForKey:[joint objectForKey:@"ObjectA"]];
    b2Body* bodyA = [sprA body];
	
    LHSprite* sprB = [spritesInLevel objectForKey:[joint objectForKey:@"ObjectB"]];
    b2Body* bodyB = [sprB body];
	
    CGPoint sprPosA = [sprA position];
    CGPoint sprPosB = [sprB position];
    
    CGSize scaleA =[sprA realScale];
    CGSize scaleB =[sprB realScale];
    
	if(NULL == bodyA || 
       NULL == bodyB )
		return NULL;
	
	CGPoint anchorA = LHPointFromString([joint objectForKey:@"AnchorA"]);
	CGPoint anchorB = LHPointFromString([joint objectForKey:@"AnchorB"]);
    
	bool collideConnected = [[joint objectForKey:@"CollideConnected"] boolValue];
	
    int tag = [[joint objectForKey:@"Tag"] intValue];
    int type = [[joint objectForKey:@"Type"] intValue];
    
	b2Vec2 posA, posB;
	
	float convertX = [[LHSettings sharedInstance] convertRatio].x;
	float convertY = [[LHSettings sharedInstance] convertRatio].y;
        
    if(![[joint objectForKey:@"CenterOfMass"] boolValue])
    {        
        posA = b2Vec2((sprPosA.x + anchorA.x*scaleA.width)/[[LHSettings sharedInstance] lhPtmRatio], 
                      (sprPosA.y - anchorA.y*scaleA.height)/[[LHSettings sharedInstance] lhPtmRatio]);
        
        posB = b2Vec2((sprPosB.x + anchorB.x*scaleB.width)/[[LHSettings sharedInstance] lhPtmRatio], 
                      (sprPosB.y - anchorB.y*scaleB.height)/[[LHSettings sharedInstance] lhPtmRatio]);

    }
    else {		
        posA = bodyA->GetWorldCenter();
        posB = bodyB->GetWorldCenter();
    }
	
	if(0 != bodyA && 0 != bodyB)
	{
		switch (type)
		{
			case LH_DISTANCE_JOINT:
			{
				b2DistanceJointDef jointDef;
				
				jointDef.Initialize(bodyA, 
									bodyB, 
									posA,
									posB);
				
				jointDef.collideConnected = collideConnected;
				
				jointDef.frequencyHz = [[joint objectForKey:@"Frequency"] floatValue];
				jointDef.dampingRatio = [[joint objectForKey:@"Damping"] floatValue];
				
				if(0 != world)
				{
					boxJoint = (b2DistanceJoint*)world->CreateJoint(&jointDef);
				}
			}	
				break;
				
			case LH_REVOLUTE_JOINT:
			{
				b2RevoluteJointDef jointDef;
				
				jointDef.lowerAngle = CC_DEGREES_TO_RADIANS([[joint objectForKey:@"LowerAngle"] floatValue]);
				jointDef.upperAngle = CC_DEGREES_TO_RADIANS([[joint objectForKey:@"UpperAngle"] floatValue]);
				jointDef.motorSpeed = [[joint objectForKey:@"MotorSpeed"] floatValue]; //Usually in radians per second. ?????
				jointDef.maxMotorTorque = [[joint objectForKey:@"MaxTorque"] floatValue]; //Usually in N-m.  ?????
				jointDef.enableLimit = [[joint objectForKey:@"EnableLimit"] boolValue];
				jointDef.enableMotor = [[joint objectForKey:@"EnableMotor"] boolValue];
				jointDef.collideConnected = collideConnected;    
				
				jointDef.Initialize(bodyA, bodyB, posA);
				
				if(0 != world)
				{
					boxJoint = (b2RevoluteJoint*)world->CreateJoint(&jointDef);
				}
			}
				break;
				
			case LH_PRISMATIC_JOINT:
			{
				b2PrismaticJointDef jointDef;
				
				// Bouncy limit
				CGPoint axisPt = LHPointFromString([joint objectForKey:@"Axis"]);
				
				b2Vec2 axis(axisPt.x, axisPt.y);
				axis.Normalize();
				
				jointDef.Initialize(bodyA, bodyB, posA, axis);
				
				jointDef.motorSpeed = [[joint objectForKey:@"MotorSpeed"] floatValue];
				jointDef.maxMotorForce = [[joint objectForKey:@"MaxMotorForce"] floatValue];
				
				
				jointDef.lowerTranslation =  CC_DEGREES_TO_RADIANS([[joint objectForKey:@"LowerTranslation"] floatValue]);
				jointDef.upperTranslation = CC_DEGREES_TO_RADIANS([[joint objectForKey:@"UpperTranslation"] floatValue]);
				
				jointDef.enableMotor = [[joint objectForKey:@"EnableMotor"] boolValue];
				jointDef.enableLimit = [[joint objectForKey:@"EnableLimit"] boolValue];
				jointDef.collideConnected = collideConnected;   
				if(0 != world)
				{
					boxJoint = (b2PrismaticJoint*)world->CreateJoint(&jointDef);
				}
			}	
				break;
				
			case LH_PULLEY_JOINT:
			{
				b2PulleyJointDef jointDef;
				
				CGPoint grAnchorA = LHPointFromString([joint objectForKey:@"GroundAnchorA"]);
				CGPoint grAnchorB = LHPointFromString([joint objectForKey:@"GroundAnchorB"]);
				
				CGSize winSize = [[CCDirector sharedDirector] winSizeInPixels];
				
				grAnchorA.y = winSize.height - convertY*grAnchorA.y;
				grAnchorB.y = winSize.height - convertY*grAnchorB.y;
				
				b2Vec2 groundAnchorA = b2Vec2(convertX*grAnchorA.x/[[LHSettings sharedInstance] lhPtmRatio], 
											  grAnchorA.y/[[LHSettings sharedInstance] lhPtmRatio]);
				
				b2Vec2 groundAnchorB = b2Vec2(convertX*grAnchorB.x/[[LHSettings sharedInstance] lhPtmRatio], 
											  grAnchorB.y/[[LHSettings sharedInstance] lhPtmRatio]);
				
				float ratio = [[joint objectForKey:@"Ratio"] floatValue];
				jointDef.Initialize(bodyA, bodyB, groundAnchorA, groundAnchorB, posA, posB, ratio);				
				jointDef.collideConnected = collideConnected;   
				
				if(0 != world)
				{
					boxJoint = (b2PulleyJoint*)world->CreateJoint(&jointDef);
				}
			}
				break;
				
			case LH_GEAR_JOINT:
			{
				b2GearJointDef jointDef;
				
				jointDef.bodyA = bodyB;
				jointDef.bodyB = bodyA;
				
				if(bodyA == 0)
					return 0;
				if(bodyB == 0)
					return 0;
				
                LHJoint* jointAObj = [self jointWithUniqueName:[joint objectForKey:@"JointA"]];
                b2Joint* jointA = [jointAObj joint];
                
                LHJoint* jointBObj = [self jointWithUniqueName:[joint objectForKey:@"JointB"]];
                b2Joint* jointB = [jointBObj joint];
                
				if(jointA == 0)
					return 0;
				if(jointB == 0)
					return 0;
				
				
				jointDef.joint1 = jointA;
				jointDef.joint2 = jointB;
				
				jointDef.ratio =[[joint objectForKey:@"Ratio"] floatValue];
				jointDef.collideConnected = collideConnected;
				if(0 != world)
				{
					boxJoint = (b2GearJoint*)world->CreateJoint(&jointDef);
				}
			}	
				break;
				
				
			case LH_WHEEL_JOINT: //aka line joint
			{
				b2WheelJointDef jointDef;
				
				CGPoint axisPt = LHPointFromString([joint objectForKey:@"Axis"]);
				b2Vec2 axis(axisPt.x, axisPt.y);
				axis.Normalize();
				
				jointDef.motorSpeed = [[joint objectForKey:@"MotorSpeed"] floatValue]; //Usually in radians per second. ?????
				jointDef.maxMotorTorque = [[joint objectForKey:@"MaxTorque"] floatValue]; //Usually in N-m.  ?????
				jointDef.enableMotor = [[joint objectForKey:@"EnableMotor"] boolValue];
				jointDef.frequencyHz = [[joint objectForKey:@"Frequency"] floatValue];
				jointDef.dampingRatio = [[joint objectForKey:@"Damping"] floatValue];
				
				jointDef.Initialize(bodyA, bodyB, posA, axis);
				jointDef.collideConnected = collideConnected; 
				
				if(0 != world)
				{
					boxJoint = (b2WheelJoint*)world->CreateJoint(&jointDef);
				}
			}
				break;				
			case LH_WELD_JOINT:
			{
				b2WeldJointDef jointDef;
				
				jointDef.frequencyHz = [[joint objectForKey:@"Frequency"] floatValue];
				jointDef.dampingRatio = [[joint objectForKey:@"Damping"] floatValue];
				
				jointDef.Initialize(bodyA, bodyB, posA);
				jointDef.collideConnected = collideConnected; 
				
				if(0 != world)
				{
					boxJoint = (b2WheelJoint*)world->CreateJoint(&jointDef);
				}
			}
				break;
				
			case LH_ROPE_JOINT: //NOT WORKING YET AS THE BOX2D JOINT FOR THIS TYPE IS A TEST JOINT
			{
				
				b2RopeJointDef jointDef;
				
				jointDef.localAnchorA = bodyA->GetPosition();
				jointDef.localAnchorB = bodyB->GetPosition();
				jointDef.bodyA = bodyA;
				jointDef.bodyB = bodyB;
				jointDef.maxLength = [[joint objectForKey:@"MaxLength"] floatValue];
				jointDef.collideConnected = collideConnected; 
				
				if(0 != world)
				{
					boxJoint = (b2RopeJoint*)world->CreateJoint(&jointDef);
				}
			}
				break;
				
			case LH_FRICTION_JOINT:
			{
				b2FrictionJointDef jointDef;
				
				jointDef.maxForce = [[joint objectForKey:@"MaxForce"] floatValue];
				jointDef.maxTorque = [[joint objectForKey:@"MaxTorque"] floatValue];
				
				jointDef.Initialize(bodyA, bodyB, posA);
				jointDef.collideConnected = collideConnected; 
				
				if(0 != world)
				{
					boxJoint = (b2FrictionJoint*)world->CreateJoint(&jointDef);
				}
				
			}
				break;
				
			default:
				NSLog(@"Unknown joint type in LevelHelper file.");
				break;
		}
	}
    
    LHJoint* levelJoint = [LHJoint jointWithUniqueName:[joint objectForKey:@"UniqueName"]];
    [levelJoint setTag:tag];
    [levelJoint setType:(LH_JOINT_TYPE)type];
    [levelJoint setJoint:boxJoint];
#ifndef LH_ARC_ENABLED
    boxJoint->SetUserData(levelJoint);
#else
    boxJoint->SetUserData((__bridge void*)levelJoint);
#endif
    
	return levelJoint;
}
//------------------------------------------------------------------------------
-(LHJoint*) jointWithUniqueName:(NSString*)name{
    return [jointsInLevel objectForKey:name];
}
//------------------------------------------------------------------------------
-(NSArray*) jointsWithTag:(enum LevelHelper_TAG)tag;{
	NSArray *keys = [jointsInLevel allKeys];
#ifndef LH_ARC_ENABLED
    NSMutableArray* jointsWithTag = [[[NSMutableArray alloc] init] autorelease];
#else
    NSMutableArray* jointsWithTag = [[NSMutableArray alloc] init];
#endif
	for(NSString* key in keys){
        LHJoint* levelJoint = [jointsInLevel objectForKey:key];
        if([levelJoint tag] == tag){
            [jointsWithTag addObject:levelJoint];
        }
	}
    return jointsWithTag;
}
//------------------------------------------------------------------------------
-(NSArray*) allJoints{
    return [jointsInLevel allValues];
}
//------------------------------------------------------------------------------
-(void) createJoints{
    
    for(NSDictionary* jointDict in lhJoints)
	{
		LHJoint* boxJoint = [self jointFromDictionary:jointDict world:box2dWorld];
		
		if(nil != boxJoint)
        {
			[jointsInLevel setObject:boxJoint
                              forKey:[jointDict objectForKey:@"UniqueName"]];	
		}
	}	
}
//------------------------------------------------------------------------------
-(bool) removeAllJoints{
    [markedJoints removeAllObjects];
	[jointsInLevel removeAllObjects];
    return true;
}
//------------------------------------------------------------------------------
-(void) releaseAllJoints{
    [self removeAllJoints];
#ifndef LH_ARC_ENABLED
    [jointsInLevel release];
#endif
    jointsInLevel = nil;
}
//------------------------------------------------------------------------------
-(void) removeJointsWithTag:(enum LevelHelper_TAG)tag{
	NSArray *keys = [jointsInLevel allKeys];
	for(NSString* key in keys){
		LHJoint* joint = [jointsInLevel objectForKey:key];
        if([joint tag] == tag){
            [markedJoints removeObject:joint];
            [jointsInLevel removeObjectForKey:key];
        }
	}
}
//------------------------------------------------------------------------------
-(bool) removeJoint:(LHJoint *)joint shouldRemoveMarked:(bool)marked
{
    if(0 == joint)
		return false;
    
    if(marked)
        [markedJoints removeObject:joint];
    
    [jointsInLevel removeObjectForKey:[joint uniqueName]];
    
    return true;
}
-(bool) removeJoint:(LHJoint*)joint{
    return [self removeJoint:joint shouldRemoveMarked:YES];
}



//------------------------------------------------------------------------------
-(void) markJointForRemoval:(LHJoint*)jt{
    if(jt != NULL)
        [markedJoints addObject:jt];
}
//------------------------------------------------------------------------------
-(void) markJointsAttachedToSpriteForRemoval:(LHSprite*)spr{
    if(NULL == spr)
        return;
    NSArray* joints = [spr jointList];
    if(joints == NULL)
        return;
    for(LHJoint* jt in joints){
        [self markJointForRemoval:jt];
    }
}
//------------------------------------------------------------------------------
-(void) removeMarkedJoints{
    for(LHJoint* jt in markedJoints){
        [self removeJoint:jt shouldRemoveMarked:NO];
    }
    [markedJoints removeAllObjects];
}
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
+(void)setTouchDispatcherForObject:(id)object tag:(int)tag
{
    [object setTagTouchBeginObserver:[[LHTouchMgr sharedInstance] onTouchBeginObserverForTag:tag]];
    [object setTagTouchMovedObserver:[[LHTouchMgr sharedInstance] onTouchMovedObserverForTag:tag]];
    [object setTagTouchEndedObserver:[[LHTouchMgr sharedInstance] onTouchEndedObserverForTag:tag]];
    
    bool swallow = [[LHTouchMgr sharedInstance] shouldTouchesBeSwallowedForTag:tag];
    int priority = [[LHTouchMgr sharedInstance] priorityForTag:tag];
#if COCOS2D_VERSION >= 0x00020000 
    CCDirectorIOS *director = (CCDirectorIOS*) [CCDirector sharedDirector];
    CCTouchDispatcher *touchDisPatcher = [director touchDispatcher];
    [touchDisPatcher addTargetedDelegate:object 
                                priority:priority 
                         swallowsTouches:swallow];
#else
    
    [object setSwallowTouches:swallow];
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:object 
                                                     priority:priority 
                                              swallowsTouches:swallow];
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
    [[CCEventDispatcher sharedDispatcher] addMouseDelegate:object priority:priority];
#endif

#endif
    
}
//------------------------------------------------------------------------------
+(void)removeTouchDispatcherFromObject:(id)object
{
#if COCOS2D_VERSION >= 0x00020000 
    CCDirectorIOS *director = (CCDirectorIOS*) [CCDirector sharedDirector];
    CCTouchDispatcher *touchDisPatcher = [director touchDispatcher];
    [touchDisPatcher removeDelegate:object];
#else    
    

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:object];    
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
    [[CCEventDispatcher sharedDispatcher] removeMouseDelegate:object];
#endif

#endif
    
}
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
-(void) setCustomAttributesForPhysics:(NSDictionary*)spriteProp 
								 body:(b2Body*)body
							   sprite:(LHSprite*)sprite
{
    
}
-(void) setCustomAttributesForNonPhysics:(NSDictionary*)spriteProp 
                                  sprite:(LHSprite*)sprite
{
    
}

-(void) setCustomAttributesForBezierBodies:(NSDictionary*)bezierProp 
                                      node:(CCNode*)sprite body:(b2Body*)body
{
    
}
////////////////////////////////////////////////////////////////////////////////
-(void)loadLevelHelperSceneFile:(NSString*)levelFile inDirectory:(NSString*)subfolder imgSubfolder:(NSString*)imgFolder
{
	NSString *path = [[NSBundle mainBundle] pathForResource:levelFile ofType:@"plhs" inDirectory:subfolder]; 
	
	NSAssert(nil!=path, @"Invalid level file. Please add the LevelHelper scene file to Resource folder. Please do not add extension in the given string.");
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	
	[self processLevelFileFromDictionary:dictionary];
}

-(void)loadLevelHelperSceneFileFromWebAddress:(NSString*)webaddress
{	
	NSURL *url = [NSURL URLWithString:webaddress];
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:url];
	
	if(dictionary == nil)
		NSLog(@"Provided web address is wrong or connection error.");
	
	[self processLevelFileFromDictionary:dictionary];
}

-(void) loadLevelHelperSceneFromDictionary:(NSDictionary*)levelDictionary 
							  imgSubfolder:(NSString*)imgFolder
{	
    [imageFolder setString:imgFolder];
	[self processLevelFileFromDictionary:levelDictionary];
}

-(LHBatch*) loadBatchNodeWithImage:(NSString*)image
{
    if(nil == image)
        return nil;
    
    NSDictionary* imageInfo = [lhBatchInfo objectForKey:image];
    
    if(nil == imageInfo)
        return nil;
    
    CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithFile:[[LHSettings sharedInstance] imagePath:image
                                                                                               imageFolder:imageFolder]];
    
    LHBatch* bNode = [LHBatch batchWithUniqueName:image];
    [bNode setSpriteBatchNode:batch];
    [bNode setZ:[[imageInfo objectForKey:@"OrderZ"] intValue]];
    [batchNodesInLevel setObject:bNode forKey:image];		
    return bNode;
}

-(LHBatch*)batchNodeForFile:(NSString*)image //this will load the batch if its not loaded
{
    LHBatch* bNode = [batchNodesInLevel objectForKey:image];
    if(nil != bNode){
        return bNode;
    }
    else{
        bNode = [self loadBatchNodeWithImage:image];
        [self addBatchNodeToLayer:cocosLayer batch:bNode];
        return bNode;
    }
    return nil;
}
-(void) removeUnusedBatchesFromMemory{
    NSArray* keys = [batchNodesInLevel allKeys];
    
    for(NSString* key in keys)
    {
        LHBatch* bNode = [batchNodesInLevel objectForKey:key];
        
        if(bNode)
        {
            CCSpriteBatchNode* cNode = [bNode spriteBatchNode];
            
            if(0 == (int)[[cNode descendants] count])
            {
                [batchNodesInLevel removeObjectForKey:key];
            }
        }
    }    
}

-(void)processLevelFileFromDictionary:(NSDictionary*)dictionary
{
	if(nil == dictionary)
		return;
	
	bool fileInCorrectFormat =	[[dictionary objectForKey:@"Author"] isEqualToString:@"Bogdan Vladu"] && 
	[[dictionary objectForKey:@"CreatedWith"] isEqualToString:@"LevelHelper"];
	
	if(fileInCorrectFormat == false)
		NSLog(@"This file was not created with LevelHelper or file is damaged.");
	
    NSDictionary* scenePref = [dictionary objectForKey:@"ScenePreference"];
    safeFrame = LHPointFromString([scenePref objectForKey:@"SafeFrame"]);
    gameWorldRect = LHRectFromString([scenePref objectForKey:@"GameWorld"]);
	
    
    
	CGRect color = LHRectFromString([scenePref objectForKey:@"BackgroundColor"]);
	glClearColor(color.origin.x, color.origin.y, color.size.width, 1);
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    bool usesCustomSize = false;
    if(4 == [[scenePref objectForKey:@"ScreenSize"] intValue])
        usesCustomSize = true;
    
    [[LHSettings sharedInstance] setConvertRatio:CGPointMake(winSize.width/safeFrame.x, 
                                                             winSize.height/safeFrame.y)
                                  usesCustomSize:usesCustomSize];
    
    float safeFrameDiagonal = sqrtf(safeFrame.x* safeFrame.x + safeFrame.y* safeFrame.y);
    float winDiagonal = sqrtf(winSize.width* winSize.width + winSize.height*winSize.height);
    float PTM_conversion = winDiagonal/safeFrameDiagonal;
    
    [LevelHelperLoader setMeterRatio:[[LHSettings sharedInstance] lhPtmRatio]*PTM_conversion];
    
	////////////////////////LOAD WORLD BOUNDARIES//////////////////////////////////////////////
	if(nil != [dictionary objectForKey:@"WBInfo"])
	{
		wb = [dictionary objectForKey:@"WBInfo"];
	}
	
	////////////////////////LOAD SPRITES////////////////////////////////////////////////////
    lhSprites = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"SPRITES_INFO"]];
	
    //load batch nodes only if asked
	///////////////////////////LOAD BATCH IMAGES////////////////////////////////////////////
    NSArray* batchInfo = [dictionary objectForKey:@"LoadedImages"];
    for(NSDictionary* imageInfo in batchInfo)
    {
        NSString* image = [imageInfo objectForKey:@"Image"];	    
        [lhBatchInfo setObject:[NSDictionary dictionaryWithDictionary:imageInfo] forKey:image];
        
        if( [[LHSettings sharedInstance] preloadBatchNodes])
        {
            [self loadBatchNodeWithImage:image];
        }
    }
	
	///////////////////////LOAD JOINTS//////////////////////////////////////////////////////////
	lhJoints = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"JOINTS_INFO"]];	
	
    //////////////////////LOAD PARALLAX/////////////////////////////////////////
    lhParallax = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"PARALLAX_INFO"]];
    
    ////////////////////LOAD BEZIER/////////////////////////////////////////////
    lhBeziers = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"BEZIER_INFO"]];
    
    ////////////////////LOAD ANIMS//////////////////////////////////////////////
    lhAnims = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"ANIMS_INFO"]];
    
    gravity = LHPointFromString([dictionary objectForKey:@"Gravity"]);
}
////////////////////////////////////////////////////////////////////////////////////
@end
