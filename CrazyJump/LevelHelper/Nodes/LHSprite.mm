//  This file was generated by LevelHelper
//  http://www.levelhelper.org
//
//  LevelHelperLoader.mm
//  Created by Bogdan Vladu
//  Copyright 2011 Bogdan Vladu. All rights reserved.
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
//
////////////////////////////////////////////////////////////////////////////////
#import "LHSprite.h"
#import "LHSettings.h"
#import "LHPathNode.h"
#import "LHParallaxNode.h"
#import "LHAnimationNode.h"
#import "LevelHelperLoader.h"
#import "LHTouchMgr.h"

#import "LHJoint.h"
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface LevelHelperLoader (LH_LOADER_SPRITE_EXT) 
-(LHAnimationNode*)animationNodeWithUniqueName:(NSString*)animName;
@end
@implementation LevelHelperLoader (LH_LOADER_SPRITE_EXT)
-(LHAnimationNode*)animationNodeWithUniqueName:(NSString*)animName{
   return [animationsInLevel objectForKey:animName];
}
@end


@interface LHJoint (LH_JOINT_SPRITE_EXT) 
-(void)setShouldDistroyJointOnDealloc:(bool)val;
@end
@implementation LHJoint (LH_JOINT_SPRITE_EXT)
-(void)setShouldDistroyJointOnDealloc:(bool)val{
    shouldDistroyJointOnDealloc = val;
}
@end


@interface LHSprite (Private)

@end
////////////////////////////////////////////////////////////////////////////////
@implementation LHSprite
@synthesize realScale;
@synthesize swallowTouches;
////////////////////////////////////////////////////////////////////////////////
//-(oneway void) release{
//    
//    NSLog(@"LH Sprite RELEASE %@", uniqueName);
//    
//    [super release];
//}
-(void) dealloc{		
    
    //NSLog(@"LH Sprite Dealloc %@", uniqueName);
    [self removeBodyFromWorld];
    
#ifndef LH_ARC_ENABLED
    if(touchBeginObserver)
        [touchBeginObserver release];
    if(touchMovedObserver)
        [touchMovedObserver release];
    if(touchEndedObserver)
        [touchEndedObserver release];
#endif
    touchBeginObserver = nil;
    touchMovedObserver = nil;
    touchEndedObserver = nil;
    
    if(NULL != parallaxFollowingThisSprite)
        [parallaxFollowingThisSprite followSprite:NULL 
                                changePositionOnX:false 
                                changePositionOnY:false];

    if(NULL != spriteIsInParallax){
        [spriteIsInParallax removeChild:self];
        spriteIsInParallax = nil;
    }
    
    if(nil != pathNode){
        [pathNode removeFromParentAndCleanup:YES];
        pathNode = nil;
    }
        
    [self stopAllActions];


    parentLoader = nil;
    
#ifndef LH_ARC_ENABLED
    [uniqueName release];
    [customUserValues release];
	[super dealloc];
#endif
}
////////////////////////////////////////////////////////////////////////////////
-(void) generalLHSpriteInit{
        
    if(nil != uniqueName)
        return; //compatibility with cocos2d 2.0
    
    body = NULL;
    uniqueName = [[NSMutableString alloc] init];
    customUserValues = [[NSMutableDictionary alloc] init];
    
    currentFrame = 0;
    pathNode = nil;
    spriteIsInParallax = nil;
    
    touchBeginObserver = nil;
    touchMovedObserver = nil;
    touchEndedObserver = nil;
    
    tagTouchBeginObserver = nil;
    tagTouchMovedObserver = nil;
    tagTouchEndedObserver = nil;
}
-(id) initSprite{ //bad CCSprite designe - causes recursion
    self = [super init];
    if (self != nil)
    {
        [self generalLHSpriteInit];
    }
    return self;
}
-(void) postInitialization{
    
}
////////////////////////////////////////////////////////////////////////////////
+(id) spriteWithTexture:(CCTexture2D*)texture{
#ifndef LH_ARC_ENABLED
    return [[[self alloc] initWithTexture:texture] autorelease];
#else
    return [[self alloc] initWithTexture:texture];
#endif
}
+(id) spriteWithTexture:(CCTexture2D*)texture rect:(CGRect)rect{
    #ifndef LH_ARC_ENABLED
    return [[[self alloc] initWithTexture:texture rect:rect] autorelease];
    #else
    return [[self alloc] initWithTexture:texture rect:rect];
    #endif
}
+(id) spriteWithSpriteFrame:(CCSpriteFrame*)spriteFrame{
    #ifndef LH_ARC_ENABLED
    return [[[self alloc] initWithSpriteFrame:spriteFrame] autorelease];
#else
    return [[self alloc] initWithSpriteFrame:spriteFrame];
#endif
}
+(id) spriteWithSpriteFrameName:(NSString*)spriteFrameName{
    #ifndef LH_ARC_ENABLED
    return [[[self alloc] initWithSpriteFrameName:spriteFrameName] autorelease];
#else
    return [[self alloc] initWithSpriteFrameName:spriteFrameName];
#endif
}
+(id) spriteWithFile:(NSString*)filename{
    #ifndef LH_ARC_ENABLED
    return [[[self alloc] initWithFile:filename] autorelease];
#else
    return [[self alloc] initWithFile:filename];
#endif
}
+(id) spriteWithFile:(NSString*)filename rect:(CGRect)rect{
    #ifndef LH_ARC_ENABLED
    return [[[self alloc] initWithFile:filename rect:rect] autorelease];
#else
    return [[self alloc] initWithFile:filename rect:rect];
#endif
}
+(id) spriteWithCGImage: (CGImageRef)image key:(NSString*)key{
    #ifndef LH_ARC_ENABLED
    return [[[self alloc] initWithCGImage:image key:key] autorelease];
#else
    return [[self alloc] initWithCGImage:image key:key];
#endif
}
+(id) spriteWithBatchNode:(CCSpriteBatchNode*)batchNode rect:(CGRect)rect{
    #ifndef LH_ARC_ENABLED
    return [[[self alloc] initWithBatchNode:batchNode rect:rect] autorelease];
#else
    return [[self alloc] initWithBatchNode:batchNode rect:rect];
#endif
}
////////////////////////////////////////////////////////////////////////////////
-(id) initWithFile:(NSString*)filename rect:(CGRect)rect{
    self = [super initWithFile:filename rect:rect];
    if (self != nil)
    {
        [self generalLHSpriteInit];
    }
    return self;
}
//------------------------------------------------------------------------------
-(id) initWithBatchNode:(CCSpriteBatchNode*)batchNode rect:(CGRect)rect{
    self = [super initWithBatchNode:batchNode rect:rect];
    if (self != nil)
    {
        [self generalLHSpriteInit];
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////
-(void)removeSelf{
    if(parentLoader)
        [parentLoader removeSprite:self];
}
//------------------------------------------------------------------------------
-(void)removeFromParentAndCleanup:(BOOL)cleanup{
    
    NSLog(@"LevelHelper ERROR: Please dont use removeFromParentAndCleanup on a LHSprite. Use [loader removeSprite:sprite]; or [sprite removeSelf];");
    [super removeFromParentAndCleanup:cleanup];
}
////////////////////////////////////////////////////////////////////////////////
-(void) setUniqueName:(NSString*)name{
    NSAssert(name!=nil, @"UniqueName must not be nil");
    [uniqueName setString:name];
}
//------------------------------------------------------------------------------
-(NSString*)uniqueName{
    return uniqueName;   
}
//------------------------------------------------------------------------------
-(void) setBody:(b2Body*)bd{
    NSAssert(bd!=nil, @"b2Body must not be nil");
    
    body = bd;
}
//------------------------------------------------------------------------------
-(b2Body*)body{
    return body;
}
//------------------------------------------------------------------------------
-(bool) removeBodyFromWorld{
    if(NULL != body){
		b2World* _world = body->GetWorld();
		if(0 != _world){
                       
            NSMutableArray* list = (NSMutableArray*)[self jointList];
            if(list && parentLoader){
                for(LHJoint* jt in list){
                    [jt setShouldDistroyJointOnDealloc:false];
                    [parentLoader removeJoint:jt];
                }
                [list removeAllObjects];
            }
			_world->DestroyBody(body);
			body = NULL;
            
            return true;
		}
	}
    return false;
}
//------------------------------------------------------------------------------
-(void) setCustomValue:(id)value withKey:(NSString*)key{
    
    NSAssert(value!=nil, @"Custom value object must not be nil");    
    NSAssert(key!=nil, @"Custom value key must not be nil");    
    
    [customUserValues setObject:value forKey:key];
}
//------------------------------------------------------------------------------
-(id) customValueWithKey:(NSString*)key{
    NSAssert(key!=nil, @"Custom value key must not be nil");    
    return [customUserValues objectForKey:key];
}
////////////////////////////////////////////////////////////////////////////////
-(void) transformPosition:(CGPoint)pos{
    [super setPosition:pos];
    if(0 != body){
        b2Vec2 boxPosition = [LevelHelperLoader pointsToMeters:pos];
        float angle = CC_DEGREES_TO_RADIANS(-1*super.rotation);
        body->SetTransform(boxPosition, angle);
    }
}
//------------------------------------------------------------------------------
-(CGPoint)position{
    return super.position;
}
//------------------------------------------------------------------------------
-(void)transformRotation:(float)rot{
    
    [super setRotation:rot];
    if(0 != body){
        b2Vec2 boxPosition = [LevelHelperLoader pointsToMeters:super.position];
        float angle = CC_DEGREES_TO_RADIANS(-1*rot);
        body->SetTransform(boxPosition, angle);
    }
}
//------------------------------------------------------------------------------
-(float)rotation{
    return super.rotation;
}
////////////////////////////////////////////////////////////////////////////////
-(void) startAnimationNamed:(NSString*)animName 
             endObserverObj:(id)obj  
             endObserverSel:(SEL)sel  
  shouldObserverLoopForever:(bool)observeLooping{

    [self startAnimationNamed:animName
                    startingFromFrame:0
                       endObserverObj:obj
                       endObserverSel:sel
    shouldObserverLoopForever:observeLooping];
}
//------------------------------------------------------------------------------
-(void) startAnimationNamed:(NSString*)animName 
          startingFromFrame:(int)startFrame
             endObserverObj:(id)obj
             endObserverSel:(SEL)sel
  shouldObserverLoopForever:(bool)observeLooping{

    if(parentLoader == nil)
        return;

    LHAnimationNode* animNode = [parentLoader animationNodeWithUniqueName:animName];
    if(nil != animNode)
    {
        LHBatch* batch = [parentLoader batchNodeForFile:[animNode imageName]];
        if(batch)
        {
            [animNode setBatchNode:[batch spriteBatchNode]];
            [animNode computeFrames];
            
            [animNode runAnimationOnSprite:self 
                         startingFromFrame:startFrame
                           withNotifierObj:obj 
                               notifierSel:sel 
                               notifOnLoop:observeLooping];
        }
    }
}
//------------------------------------------------------------------------------
-(void) startAnimationNamed:(NSString*)animName 
          startingFromFrame:(int)startFrame{
    
    [self startAnimationNamed:animName
            startingFromFrame:startFrame
               endObserverObj:nil
               endObserverSel:nil
    shouldObserverLoopForever:false];
}
//------------------------------------------------------------------------------
-(void) startAnimationNamed:(NSString*)animName{

    [self startAnimationNamed:animName
            startingFromFrame:0
               endObserverObj:nil
               endObserverSel:nil
    shouldObserverLoopForever:false];
}
//------------------------------------------------------------------------------
-(void) prepareAnimationNamed:(NSString*)animName{

    if(parentLoader == nil)
        return;

    LHAnimationNode* animNode = [parentLoader animationNodeWithUniqueName:animName];
    if(animNode == nil)
        return;
    
    LHBatch* batch = [parentLoader batchNodeForFile:[animNode imageName]];
    
    if(batch){
        [animNode setBatchNode:[batch spriteBatchNode]];
        [animNode computeFrames];
        [self setAnimation:animNode];
    }
}
//------------------------------------------------------------------------------
-(void) stopAnimation{
    [self stopActionByTag:LH_ANIM_ACTION_TAG];
    [self setAnimation:nil];
}
//------------------------------------------------------------------------------
-(void) setAnimation:(LHAnimationNode*)anim{
    animation = anim;
    if(nil != anim){
        [anim setAnimationTexturePropertiesOnSprite:self];
        [self setFrame:0];
    }
}
//------------------------------------------------------------------------------
-(LHAnimationNode*)animation{
    return animation;
}
//------------------------------------------------------------------------------
-(NSString*) animationName{
    if(nil != animation)
        return [animation uniqueName];
    return @"";
}
//------------------------------------------------------------------------------
-(int) numberOfFrames{
    if(nil != animation)
        return [animation numberOfFrames];    
    return -1;
}
//------------------------------------------------------------------------------
-(void) setFrame:(int)frmNo{    
    if(animation == nil)
        return;
    [animation setFrame:frmNo onSprite:self];
    currentFrame = frmNo;
}
//------------------------------------------------------------------------------
-(int) currentFrame{
    if(nil != animation){
        NSArray* frames = [animation frames];
        if(nil != frames){
            for(int i = 0; i < (int)[frames count]; ++i){
                CCSpriteFrame* frame = [frames objectAtIndex:i];
                
                if(CGRectEqualToRect([frame rect], [self textureRect])){
                    return i;
                }
            }
        }
    }
    return 0;
}
//------------------------------------------------------------------------------
-(void) nextFrame{
    int curFrame = [self currentFrame];
    curFrame +=1;
        
    if(curFrame >= 0 && curFrame < [self numberOfFrames]){
        [self setFrame:curFrame];
    }    
}
//------------------------------------------------------------------------------
-(void) prevFrame{

    int curFrame = [self currentFrame];
    curFrame -=1;
        
    if(curFrame >= 0 && curFrame < (int)[self numberOfFrames]){
        [self setFrame:curFrame];
    }        
}
//------------------------------------------------------------------------------
-(void) nextFrameAndRepeat{
    
    int curFrame = [self currentFrame];
    curFrame +=1;
    
    if(curFrame >= [self numberOfFrames]){
        curFrame = 0;
    }
    
    if(curFrame >= 0 && curFrame < [self numberOfFrames]){
        [self setFrame:curFrame];
    }    
}
//------------------------------------------------------------------------------
-(void) prevFrameAndRepeat{
 
    int curFrame = [self currentFrame];
    curFrame -=1;
    
    if(curFrame < 0){
        curFrame = [self numberOfFrames] - 1;        
    }
    
    if(curFrame >= 0 && curFrame < (int)[self numberOfFrames]){
        [self setFrame:curFrame];
    }        
}
//------------------------------------------------------------------------------
-(bool) isAtLastFrame{
    return ([self numberOfFrames]-1 == [self currentFrame]);
}
////////////////////////////////////////////////////////////////////////////////
-(NSArray*) jointList{

#ifndef LH_ARC_ENABLED
    NSMutableArray* array = [[[NSMutableArray alloc] init] autorelease];
#else
    NSMutableArray* array = [[NSMutableArray alloc] init];
#endif

    if(body != NULL){
        b2JointEdge* jtList = body->GetJointList();
        while (jtList) {
            LHJoint* lhJt = [LHJoint jointFromBox2dJoint:jtList->joint];
            if(lhJt != NULL)
                [array addObject:lhJt];
            jtList = jtList->next;
        }
    }
    return array;
}
//------------------------------------------------------------------------------
-(LHJoint*) jointWithUniqueName:(NSString*)name{
    if(name == nil)
        return nil;
    
    if(body != NULL){
        b2JointEdge* jtList = body->GetJointList();
        while (jtList) {
            LHJoint* lhJt = [LHJoint jointFromBox2dJoint:jtList->joint];
            if(lhJt != NULL){
                if([[lhJt uniqueName] isEqualToString:name])
                    return lhJt;
            }
            jtList = jtList->next;
        }
    }
    return nil;
}
//------------------------------------------------------------------------------
-(bool) removeAllAttachedJoints{
    NSMutableArray* list = (NSMutableArray*)[self jointList];
    if(list && parentLoader){
        for(LHJoint* jt in list){
            if([jt joint]->GetBodyA()->GetContactList() || 
               [jt joint]->GetBodyB()->GetContactList())
                [parentLoader markJointForRemoval:jt];
            else                                             
                [parentLoader removeJoint:jt];
        }
        [list removeAllObjects];
        return true;
    }
    return false;
}
//------------------------------------------------------------------------------
-(bool) removeJoint:(LHJoint*)joint{
    NSMutableArray* list = (NSMutableArray*)[self jointList];
    if(list && parentLoader){
        for(LHJoint* jt in list){
            if(jt == joint){
                if([jt joint]->GetBodyA()->GetContactList() || 
                   [jt joint]->GetBodyB()->GetContactList())
                    [parentLoader markJointForRemoval:jt];
                else                                             
                    [parentLoader removeJoint:jt];
                return true;
            }
        }
    }    
    
    NSLog(@"WARNING: Trying to remove joint %@ from the sprite %@ but the joint does not belong to that sprite. Removal of joint was not performed.", [joint uniqueName], uniqueName);
    return false;
}
////////////////////////////////////////////////////////////////////////////////
-(void) moveOnPathWithUniqueName:(NSString*)pathName 
                           speed:(float)pathSpeed 
                 startAtEndPoint:(bool)startAtEndPoint
                        isCyclic:(bool)isCyclic
               restartAtOtherEnd:(bool)restartOtherEnd
                 axisOrientation:(int)axis
                           flipX:(bool)flipx
                           flipY:(bool)flipy
                   deltaMovement:(bool)dMove
                  endObserverObj:(id)obj 
                  endObserverSel:(SEL)sel
{
    
    if(pathName == nil)
        return;

    if(parentLoader == nil)
        return;

	//already moving on a path so lets cancel that path movement
    [self cancelPathMovement];
    
	LHBezierNode* node = [parentLoader bezierNodeWithUniqueName:pathName];
	
	if(nil != node)
	{
		LHPathNode* pNode = [node addSpriteOnPath:self
                                            speed:pathSpeed
                                  startAtEndPoint:startAtEndPoint
                                         isCyclic:isCyclic 
                                restartAtOtherEnd:restartOtherEnd
                                  axisOrientation:axis
                                            flipX:flipx
                                            flipY:flipy
                                    deltaMovement:dMove];
        
        if(nil != pNode){
            [pNode setPathNotifierObject:obj];
            [pNode setPathNotifierSelector:sel];
        }
        pathNode = pNode;
	}
}
//------------------------------------------------------------------------------
-(void) cancelPathMovement{
    if(nil != pathNode){
        [pathNode removeFromParentAndCleanup:YES];
        pathNode = nil;
    }
}
//------------------------------------------------------------------------------
-(void) pausePathMovement:(bool)pauseStatus
{
    if(nil != pathNode){
        [pathNode setPaused:pauseStatus];
    }
}
//------------------------------------------------------------------------------
-(void) setPathSpeed:(float)value{
    if(pathNode != nil){
        [pathNode setSpeed:value];
    }
}
//------------------------------------------------------------------------------
-(float) pathSpeed{
    if(pathNode != nil){
        return [pathNode speed];
    }
    return 0;
}
//------------------------------------------------------------------------------
-(void) setPathNode:(LHPathNode*)node{
    //NSAssert(node!=nil, @"LHPathNode must not be nil");    
    pathNode = node;
}
//------------------------------------------------------------------------------
-(LHPathNode*)pathNode{
    return pathNode;
}
////////////////////////////////////////////////////////////////////////////////
-(bool)isTouchedAtPoint:(CGPoint)point{
    
    if(body == NULL)
    {
        float x = point.x;
        float y = point.y;
     
        float ax = quad_.tl.vertices.x;
        float ay = quad_.tl.vertices.y;
        
        float bx = quad_.tr.vertices.x;
        float by = quad_.tr.vertices.y;
        
        float dx = quad_.bl.vertices.x;
        float dy = quad_.bl.vertices.y;
        
        float bax=bx-ax;
        float bay=by-ay;
        float dax=dx-ax;
        float day=dy-ay;
        
        if ((x-ax)*bax+(y-ay)*bay<0.0) return false;
        if ((x-bx)*bax+(y-by)*bay>0.0) return false;
        if ((x-ax)*dax+(y-ay)*day<0.0) return false;
        if ((x-dx)*dax+(y-dy)*day>0.0) return false;
        
        return true;

    }
    else{
        b2Fixture* stFix = body->GetFixtureList();
        while(stFix != 0){
            if(stFix->TestPoint(b2Vec2(point.x/[[LHSettings sharedInstance] lhPtmRatio], 
                                       point.y/[[LHSettings sharedInstance] lhPtmRatio]))){
                return true;
            }
            stFix = stFix->GetNext();
        }
    }
    return false;    
}
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
-(void)registerTouchBeginObserver:(id)observer selector:(SEL)selector{
    if(nil == touchBeginObserver)
        touchBeginObserver = [LHObserverPair observerPair];
    
    touchBeginObserver.object = observer;
    touchBeginObserver.selector = selector;
#ifndef LH_ARC_ENABLED
    [touchBeginObserver retain];
#endif
}
//------------------------------------------------------------------------------
-(void)registerTouchMovedObserver:(id)observer selector:(SEL)selector{
    if(nil == touchMovedObserver)
        touchMovedObserver = [LHObserverPair observerPair];
    
    touchMovedObserver.object = observer;
    touchMovedObserver.selector = selector;
#ifndef LH_ARC_ENABLED
    [touchMovedObserver retain];
#endif
}
//------------------------------------------------------------------------------
-(void)registerTouchEndedObserver:(id)observer selector:(SEL)selector{
    if(nil == touchEndedObserver)
        touchEndedObserver = [LHObserverPair observerPair];
    
    touchEndedObserver.object = observer;
    touchEndedObserver.selector = selector;    
#ifndef LH_ARC_ENABLED
    [touchEndedObserver retain];
#endif
}
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
//for left mouse events use the touch observers from above 
-(void)registerRightMouseDownObserver:(id)observer selector:(SEL)selector{
    if(nil == rightMouseDownObserver)
        rightMouseDownObserver = [LHObserverPair observerPair];
    
    rightMouseDownObserver.object = observer;
    rightMouseDownObserver.selector = selector;
#ifndef LH_ARC_ENABLED
    [rightMouseDownObserver retain];
#endif
}
//------------------------------------------------------------------------------
-(void)registerRightMouseDraggedObserver:(id)observer selector:(SEL)selector{
    if(nil == rightMouseDraggedObserver)
        rightMouseDraggedObserver = [LHObserverPair observerPair];
    
    rightMouseDraggedObserver.object = observer;
    rightMouseDraggedObserver.selector = selector;
#ifndef LH_ARC_ENABLED
    [rightMouseDraggedObserver retain];
#endif
}
//------------------------------------------------------------------------------
-(void)registerRightMouseUpObserver:(id)observer selector:(SEL)selector{
    if(nil == rightMouseUpObserver)
        rightMouseUpObserver = [LHObserverPair observerPair];
    
    rightMouseUpObserver.object = observer;
    rightMouseUpObserver.selector = selector;
#ifndef LH_ARC_ENABLED
    [rightMouseUpObserver retain];
#endif    
}
#endif

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
-(CGPoint)convertedPoint:(CGPoint)touchPoint{
    touchPoint=  [[CCDirector sharedDirector] convertToGL:touchPoint];    
    
    CCNode* prevParent = nil;
    CCNode* layerParent = self.parent;
    
    while(layerParent){
        if(layerParent.parent){
            prevParent = layerParent;
            layerParent = layerParent.parent;
        }
        else{
            layerParent = prevParent;
            break;
        }
    }
    
    if(layerParent){
        touchPoint.x -= layerParent.position.x;
        touchPoint.y -= layerParent.position.y;
    }
    return touchPoint;
}
//------------------------------------------------------------------------------
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
   
    CGPoint touchPoint = [touch locationInView:[touch view]];
    touchPoint = [self convertedPoint:touchPoint];
    
    if([self isTouchedAtPoint:touchPoint])
    {
        LHTouchInfo* info = [LHTouchInfo touchInfo];
        info.relativePoint = CGPointMake(touchPoint.x - self.position.x,
                                         touchPoint.y - self.position.y);
        info.glPoint = touchPoint;
        info.event = event;
        info.touch = touch;
        info.sprite = self;
        info.delta = CGPointZero;

        [LHObserverPair performObserverPair:touchBeginObserver object:info];
        [LHObserverPair performObserverPair:tagTouchBeginObserver object:info]; 
        return true;
    }
    return false;
}
//------------------------------------------------------------------------------
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{  
    
    CGPoint touchPoint = [touch locationInView:[touch view]];
    touchPoint = [self convertedPoint:touchPoint];
        
    CGPoint prevLocation = [touch previousLocationInView:[touch view]];
    prevLocation = [self convertedPoint:prevLocation];

    LHTouchInfo* info = [LHTouchInfo touchInfo];
    info.relativePoint = CGPointMake(touchPoint.x - self.position.x,
                                     touchPoint.y - self.position.y);
    info.glPoint = touchPoint;
    info.event = event;
    info.touch = touch;
    info.sprite = self;
    info.delta = CGPointMake(touchPoint.x - prevLocation.x,
                             touchPoint.y - prevLocation.y);

    [LHObserverPair performObserverPair:touchMovedObserver object:info];
    [LHObserverPair performObserverPair:tagTouchMovedObserver object:info]; 
}
//------------------------------------------------------------------------------
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{

    CGPoint touchPoint = [touch locationInView:[touch view]];
    touchPoint= [self convertedPoint:touchPoint];

    CGPoint prevLocation = [touch previousLocationInView:[touch view]];
    prevLocation = [self convertedPoint:prevLocation];

    LHTouchInfo* info = [LHTouchInfo touchInfo];
    info.relativePoint = CGPointMake(touchPoint.x - self.position.x,
                                     touchPoint.y - self.position.y);
    info.glPoint = touchPoint;
    info.event = event;
    info.touch = touch;
    info.sprite = self;
    info.delta = CGPointMake(touchPoint.x - prevLocation.x,
                             touchPoint.y - prevLocation.y);

    [LHObserverPair performObserverPair:touchEndedObserver object:info];
    [LHObserverPair performObserverPair:tagTouchEndedObserver object:info]; 
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
}
//------------------------------------------------------------------------------
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
//------------------------------------------------------------------------------
-(CGPoint)convertedEvent:(NSEvent*)event{
    CGPoint touchPoint = [(CCDirectorMac*)[CCDirector sharedDirector] convertEventToGL:event];
    
    CCNode* prevParent = nil;
    CCNode* layerParent = self.parent;
    
    while(layerParent){
        if(layerParent.parent){
            prevParent = layerParent;
            layerParent = layerParent.parent;
        }
        else{
            layerParent = prevParent;
            break;
        }
    }
    
    if(layerParent){
        touchPoint.x -= layerParent.position.x;
        touchPoint.y -= layerParent.position.y;
    }
    return touchPoint;
}
//------------------------------------------------------------------------------
-(BOOL) ccMouseDown:(NSEvent*)event{   
    
    CGPoint touchPoint = [self convertedEvent:event];
        
    if([self isTouchedAtPoint:touchPoint])
    {
        mouseDownStarted = true;
        LHTouchInfo* info = [LHTouchInfo touchInfo];
        info.relativePoint = CGPointMake(touchPoint.x - self.position.x,
                                         touchPoint.y - self.position.y);
        info.glPoint = touchPoint;
        info.event = event;
        info.touch = nil;
        info.sprite = self;
        info.delta = CGPointZero;
        
        [LHObserverPair performObserverPair:touchBeginObserver object:info];
        [LHObserverPair performObserverPair:tagTouchBeginObserver object:info]; 

        return swallowTouches;
    }
    return NO;
}
//------------------------------------------------------------------------------
-(BOOL) ccMouseDragged:(NSEvent*)event{
    
    if(!mouseDownStarted)
        return NO;

    CGPoint touchPoint = [self convertedEvent:event];
            
    LHTouchInfo* info = [LHTouchInfo touchInfo];
    info.relativePoint = CGPointMake(touchPoint.x - self.position.x,
                                     touchPoint.y - self.position.y);
    info.glPoint = touchPoint;
    info.event = event;
    info.touch = nil;
    info.sprite = self;
    info.delta = CGPointMake([event deltaX], [event deltaY]);
    
    [LHObserverPair performObserverPair:touchMovedObserver object:info];
    [LHObserverPair performObserverPair:tagTouchMovedObserver object:info]; 

    return swallowTouches;//avoid propagation
}
//------------------------------------------------------------------------------
-(BOOL) ccMouseUp:(NSEvent*)event{
    
    if(!mouseDownStarted)
        return NO;

    CGPoint touchPoint = [self convertedEvent:event];
        
    mouseDownStarted = false;
    LHTouchInfo* info = [LHTouchInfo touchInfo];
    info.relativePoint = CGPointMake(touchPoint.x - self.position.x,
                                     touchPoint.y - self.position.y);
    info.glPoint = touchPoint;
    info.event = event;
    info.touch = nil;
    info.sprite = self;
    info.delta = CGPointMake([event deltaX], [event deltaY]);
    
    [LHObserverPair performObserverPair:touchEndedObserver object:info];
    [LHObserverPair performObserverPair:tagTouchEndedObserver object:info]; 

    return swallowTouches;//avoid propagation
}
//------------------------------------------------------------------------------
-(BOOL) ccRightMouseDown:(NSEvent*)event{
    
    CGPoint touchPoint = [self convertedEvent:event];
    
    if([self isTouchedAtPoint:touchPoint])
    {
        r_mouseDownStarted = true;
        LHTouchInfo* info = [LHTouchInfo touchInfo];
        info.relativePoint = CGPointMake(touchPoint.x - self.position.x,
                                         touchPoint.y - self.position.y);
        info.glPoint = touchPoint;
        info.event = event;
        info.touch = nil;
        info.sprite = self;
        info.delta = CGPointZero;
        
        [LHObserverPair performObserverPair:rightMouseDownObserver object:info];
        [LHObserverPair performObserverPair:tagRightMouseDownObserver object:info]; 
        
        return swallowTouches;
    }
    return NO;
}
//------------------------------------------------------------------------------
-(BOOL) ccRightMouseDragged:(NSEvent*)event{
    
    if(!r_mouseDownStarted)
        return NO;

    CGPoint touchPoint = [self convertedEvent:event];
        
    LHTouchInfo* info = [LHTouchInfo touchInfo];
    info.relativePoint = CGPointMake(touchPoint.x - self.position.x,
                                     touchPoint.y - self.position.y);
    info.glPoint = touchPoint;
    info.event = event;
    info.touch = nil;
    info.sprite = self;
    info.delta = CGPointMake([event deltaX], [event deltaY]);
    
    [LHObserverPair performObserverPair:rightMouseDraggedObserver object:info];
    [LHObserverPair performObserverPair:tagRightMouseDraggedObserver object:info]; 
    
    return swallowTouches;//avoid propagation
}
//------------------------------------------------------------------------------
-(BOOL) ccRightMouseUp:(NSEvent*)event{
    
    if(!r_mouseDownStarted)
        return NO;

    CGPoint touchPoint = [self convertedEvent:event];
        
    r_mouseDownStarted = false;
    LHTouchInfo* info = [LHTouchInfo touchInfo];
    info.relativePoint = CGPointMake(touchPoint.x - self.position.x,
                                     touchPoint.y - self.position.y);
    info.glPoint = touchPoint;
    info.event = event;
    info.touch = nil;
    info.sprite = self;
    info.delta = CGPointMake([event deltaX], [event deltaY]);
    
    [LHObserverPair performObserverPair:rightMouseUpObserver object:info];
    [LHObserverPair performObserverPair:tagRightMouseUpObserver object:info]; 
    
    return swallowTouches;//avoid propagation
}

#endif

////////////////////////////////////////////////////////////////////////////////
+(NSString*) uniqueNameForBody:(b2Body*)body{
    
#ifndef LH_ARC_ENABLED
    id spr = (id)body->GetUserData();
#else
    id spr = (__bridge id)body->GetUserData();
#endif
    
    if([LHSprite isLHSprite:spr])
        return [spr uniqueName];
    
    if([LHBezierNode isLHBezierNode:spr])
        return [spr uniqueName];
    
    return nil;
}
//------------------------------------------------------------------------------
+(LHSprite*) spriteForBody:(b2Body*)body
{
    if(0 == body)
        return nil;
#ifndef LH_ARC_ENABLED 
    id spr = (id)body->GetUserData();
#else
    id spr = (__bridge id)body->GetUserData();
#endif
    
    if([LHSprite isLHSprite:spr])
        return spr;
    
    return nil;    
}
//------------------------------------------------------------------------------
+(int) tagForBody:(b2Body*)body{
    if(0 != body){
        #ifndef LH_ARC_ENABLED 
        CCNode* spr = (CCNode*)body->GetUserData();
        #else
        CCNode* spr = (__bridge CCNode*)body->GetUserData();
        #endif
        if(nil != spr){
            return [spr tag];
        }
    }
    return -1;
}
//------------------------------------------------------------------------------
+(bool) isLHSprite:(id)object{
    if([object isKindOfClass:[LHSprite class]]){
        return true;
    }
    return false;
}
////////////////////////////////////////////////////////////////////////////////
- (NSComparisonResult)sortAscending:(LHSprite *)other{

    if(nil == other)
        return NSOrderedSame;
    
    return [uniqueName compare:[other uniqueName]];
}
//------------------------------------------------------------------------------
- (NSComparisonResult)sortDescending:(LHSprite *)other
{		
    if(nil == other)
        return NSOrderedSame;

    NSComparisonResult result = [uniqueName compare:[other uniqueName]];
    
    if(result == NSOrderedDescending)
        return NSOrderedAscending;
    else if(result == NSOrderedAscending)
        return NSOrderedDescending;
    
    return NSOrderedSame;           
}

@end
