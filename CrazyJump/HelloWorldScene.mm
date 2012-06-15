//
//  HelloWorldScene.mm
//  presentation
//
//  Created by Bogdan Vladu on 15.03.2011.
//
// Import the interfaces
#import "HelloWorldScene.h"
const float32 FIXED_TIMESTEP = 1.0f / 60.0f;
const float32 MINIMUM_TIMESTEP = 1.0f / 600.0f;  
const int32 VELOCITY_ITERATIONS = 8;
const int32 POSITION_ITERATIONS = 8;
const int32 MAXIMUM_NUMBER_OF_STEPS = 25;

// HelloWorld implementation
@implementation HelloWorldScene

-(void)afterStep {
	// process collisions and result from callbacks called by the step
}
////////////////////////////////////////////////////////////////////////////////
-(void)step:(ccTime)dt {
	float32 frameTime = dt;
	int stepsPerformed = 0;
	while ( (frameTime > 0.0) && (stepsPerformed < MAXIMUM_NUMBER_OF_STEPS) ){
		float32 deltaTime = std::min( frameTime, FIXED_TIMESTEP );
		frameTime -= deltaTime;
		if (frameTime < MINIMUM_TIMESTEP) {
			deltaTime += frameTime;
			frameTime = 0.0f;
		}
		world->Step(deltaTime,VELOCITY_ITERATIONS,POSITION_ITERATIONS);
		stepsPerformed++;
		[self afterStep]; // process collisions and result from callbacks called by the step
	}
	world->ClearForces ();
}
////////////////////////////////////////////////////////////////////////////////
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldScene *layer = [HelloWorldScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
////////////////////////////////////////////////////////////////////////////////
// initialize your instance here
-(id) init
{
	if( (self=[super init])) {
		
		// enable touches
		self.isTouchEnabled = YES;
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
		
		[[[CCDirector sharedDirector] openGLView] setMultipleTouchEnabled:YES];
        
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, -5.0f);
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity);
		
		world->SetContinuousPhysics(true);
		
		// Debug Draw functions
		m_debugDraw = new GLESDebugDraw();
		world->SetDebugDraw(m_debugDraw);
		
		uint32 flags = 0;
		flags += b2Draw::e_shapeBit;
		flags += b2Draw::e_jointBit;
		m_debugDraw->SetFlags(flags);		
				
		[self schedule: @selector(tick:) interval:1.0f/60.0f];
		
        //TUTORIAL - loading one of the levels - test each level to see how it works
        lh = [[LevelHelperLoader alloc] initWithContentOfFile:@"bezierTile"];
		//lh = [[LevelHelperLoader alloc] initWithContentOfFile:@"bezierPath"];
		//lh = [[LevelHelperLoader alloc] initWithContentOfFile:@"bridgeExample"];
		//lh = [[LevelHelperLoader alloc] initWithContentOfFile:@"carJointExample"];
		//lh = [[LevelHelperLoader alloc] initWithContentOfFile:@"frictionJointExample"];
		//lh = [[LevelHelperLoader alloc] initWithContentOfFile:@"gearExample"];
		//lh = [[LevelHelperLoader alloc] initWithContentOfFile:@"ropeExample"];
		

        //notification have to be added before creating the objects
        //if you dont want notifications - it is better to remove this lines
        [lh registerNotifierOnAllPathEndPoints:self selector:@selector(spriteMoveOnPathEnded:pathUniqueName:)];
        [lh registerNotifierOnAllAnimationEnds:self selector:@selector(spriteAnimHasEnded:animationName:)];
        [lh enableNotifOnLoopForeverAnimations];
        
        
        //creating the objects
        [lh addObjectsToWorld:world cocos2dLayer:self];
        
        if([lh hasPhysicBoundaries])
            [lh createPhysicBoundaries:world];
        
        if(![lh isGravityZero])
            [lh createGravity:world];
        
	}
	return self;
}
////////////////////////////////////////////////////////////////////////////////
-(void)spriteMoveOnPathEnded:(LHSprite*)spr pathUniqueName:(NSString*)pathName
{
    NSLog(@"Sprite \"%@\" movement on path \"%@\" has just ended.", [spr uniqueName], pathName);    
}
////////////////////////////////////////////////////////////////////////////////
-(void) spriteAnimHasEnded:(LHSprite*)spr animationName:(NSString*)animName
{
    NSLog(@"Animation with name %@ has ended on sprite %@", animName, [spr uniqueName]);
}
////////////////////////////////////////////////////////////////////////////////
-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

}
////////////////////////////////////////////////////////////////////////////////
//FIX TIME STEPT------------>>>>>>>>>>>>>>>>>>
-(void) tick: (ccTime) dt
{
	[self step:dt];
    
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) 
        {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
            
            if(myActor != 0)
            {
                //THIS IS VERY IMPORTANT - GETTING THE POSITION FROM BOX2D TO COCOS2D
                myActor.position = [LevelHelperLoader metersToPoints:b->GetPosition()];
                myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());		
            }
            
        }	
	}	
}
//FIX TIME STEPT<<<<<<<<<<<<<<<----------------------
////////////////////////////////////////////////////////////////////////////////
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	for( UITouch *touch in touches ) {
		
        CGPoint location = [touch locationInView: [touch view]];
        location = [[CCDirector sharedDirector] convertToGL: location];        
        
        if(nil != lh)
        {
            b2Body* body = [lh bodyWithTag:DEFAULT_TAG touchedAtPoint:CGPointMake(location.x, location.y)];
            if(0 != body)
            {
                //make sure you have physic boundaries in the level or this method will fail
                mouseJoint = [lh mouseJointForBodyA:[lh bottomPhysicBoundary]
                                              bodyB:body 
                                         touchPoint:location];
            }
        }
    }
}
////////////////////////////////////////////////////////////////////////////////
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for( UITouch *touch in touches ) {
		
        CGPoint location = [touch locationInView: [touch view]];
        location = [[CCDirector sharedDirector] convertToGL: location];        
        
        if(nil != mouseJoint)
        {
            if(nil != lh)
            {
                [lh setTarget:location onMouseJoint:mouseJoint];
            }
        }    
    }
}
////////////////////////////////////////////////////////////////////////////////
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(mouseJoint != 0){    
		world->DestroyJoint(mouseJoint);
		mouseJoint = NULL;
	}
    
	for( UITouch *touch in touches ) {

		CGPoint location = [touch locationInView: [touch view]];
		location = [[CCDirector sharedDirector] convertToGL: location];
		
	}
}
////////////////////////////////////////////////////////////////////////////////
- (void)accelerometer:(UIAccelerometer*)accelerometer 
        didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	// accelerometer values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 10
//	b2Vec2 gravity( -accelY * 10, accelX * 10);
	
//	world->SetGravity( gravity );
}
////////////////////////////////////////////////////////////////////////////////
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    if(mouseJoint != 0){    
		world->DestroyJoint(mouseJoint);
		mouseJoint = NULL;
	}
    
    if(nil != lh)
        [lh release];

	delete world;
	world = NULL;
	
  	delete m_debugDraw;

	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
////////////////////////////////////////////////////////////////////////////////