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

-(void)afterStep 
{
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
	if( (self=[super init])) 
    {
		
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
		
        lh = [[LevelHelperLoader alloc] initWithContentOfFile:@"level1"];
		        
        //creating the objects
        [lh addObjectsToWorld:world cocos2dLayer:self];
        
        if([lh hasPhysicBoundaries])
            [lh createPhysicBoundaries:world];
        
        if(![lh isGravityZero])
            [lh createGravity:world];
        
        [self retrieveRequiredObjects];
        
	}
	return self;
}

-(void)restartGame
{
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]];
}

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

-(void) retrieveRequiredObjects
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];

//    tire = [lh spriteWithUniqueName:@"tiremag"];
    ladaClean = [lh spriteWithUniqueName:@"Lada_clean"];
//    
//    smoke = [[CCParticleSmoke alloc] init];
//    [smoke setStartSize:15.0];
//    [smoke setEndSize:15.0];    
//    [self addChild:smoke z:tire.zOrder+1];
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
    
    
    //b2Vec2 ladaPos = [ladaClean body]->GetPosition();
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CGPoint screenCenter = CGPointMake(screenSize.width * 0.5f, 
                                       screenSize.height * 0.5f);
    
    CGPoint offsetToCenter = ccpSub(screenCenter, ladaClean.position);    
    float scale = (screenSize.height*3/4) / ladaClean.position.y;
    if (scale > 1) scale = 1;
    self.scale = scale;
    
    self.position = ccpMult(offsetToCenter, self.scale);
   // self.position = offsetToCenter;
    
    //smoke.position = tire.position;


}
-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event
{
	return YES;
}

-(void) ccTouchMoved:(UITouch*)touch withEvent:(UIEvent *)event
{
    [self restartGame];
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	
	[ladaClean body]->ApplyLinearImpulse(b2Vec2(20, 0),  
                                [ladaClean body]->GetPosition());
    
}

////////////////////////////////////////////////////////////////////////////////
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
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