/*
 * File: game.js
 * Author: Steven Hart (steven.hart282@gmail.com)
 * Date: 7/8/2014
 * Description:
 * 		Driver file for Planet Jumper game.  A response to the Lumos Labs Mobile Game Take Home Challenge
 * 	This file is designed to be easily readable, configurable, and extendable by a designer with limited
 * 	coding ability.  //**Comments on the left hand side will explain how to best adapt and extend the
 * 	functionality of the game.  Virtually ALL game alterations and extensions can be made within the 
 * *1*-*6* sections.  Enjoy!
 * 
 * CREDITS:  This project (sprite.js & sound.js) makes us of example code provided on the w3schools.com site
 * for audio and sprite rendering. 
 */

//**DEBUG TOOLS - Leave these alone and commented out
      	/*var appendError = function(str){
      		throw new Error("DEBUG: "+str);
		}
		function log(str){
   			setTimeout(function(){"appendError('"+str+"')", 1);}
		}
		*/
      //--------------------------------------ESTABLISH CANVAS
//*1* ALTER THE DIMENSIONS OF THE GAME CANVAS
        var CANVAS_WIDTH = 800;
        var CANVAS_HEIGHT = 600;
//*2* ALTER THE FPS ("game speed") - lower FPS will result in slower gameplay
        var FPS = 30;
       	var canvasElement = $("<canvas width='" + CANVAS_WIDTH + "' height='" + CANVAS_HEIGHT + "'></canvas");
        var canvas = canvasElement.get(0).getContext("2d");
       	canvasElement.appendTo('body');
       	setInterval(function() {
          update();
          draw();      
        }, 1000/FPS);
        
      //--------------------------------------ESTABLISH GAME VARIABLES & LEVEL SETUP
//*3* ALTER THE GRAVITY OF THE GAME PHYSICS - higher gravity will draw the player back to the planet faster
      var GRAVITY = 1;
//*4* ALTER THE JUMP STRENGTH OF THE PLAYER - higher jump strength will increase the force he jumps with      
      var JUMP_STRENGTH = 15;
//*5* ALTER THE MOVE SPEED TO CHANGE HOW FAST THE PLAYER MOVES WHEN PRESSING ARROW LEFT OR RIGHT
	  var MOVE_SPEED = 5;
      var CURRENT_LEVEL = 0;
      var SPIKE_SIZE = 42;
      var PORTAL_WIDTH = 30;
      var PORTAL_HEIGHT = 42;
      var TO_RADIANS = (Math.PI/180);
      var levelList;
      var planetList;
      var spikeList;
      var start;
      var end;
      var player;
      var victory;
      var message = false;
      
/*6* LEVEL LAYOUTS - This is where you input how the level will be layed out     
 *
 * 	Each level is made up of PLANETS, SPIKES, a START PORTAL, and an END PORTAL
 * 	(the player will automatically spawn at the START PORTAL)
 * 
 * 	-planets: require an x and y coordinate, radius, and optional speed of rotation (+) clockwise (-) counterclockwise)
 *  -spikeList: spikes are Items with the Sprite("spike") attribute. Items require a planetNum (number corresponding to the
 * 		'planets:' EX: planetNum: 0 will be on the first planet of 'planets:') and a position (in degrees where it will be located on the 
 * 		circular planet EX: position: 0 will be on the right side of the planet and 90 will be on the bottom of the planet))
 * 	-start: and Item with the location of the START PORTAL
 * 	-end: an Item with the location of the END PORTAL 
 * 
 * NOTES: You may include as many levels as you want - each end portal will take the player to the next level and then back
 * to the beginning after the final level.  To add a level - copy and paste from "Level({" to its corresponding "})," below.
 * Include the comma unless it is the last level in which case omit it
 * 
 */
      levelList = [
        //Level1 layout..
      	Level({
      		planets: [
				Planet({x: 120, y: 218, radius: 75}),
				Planet({x: 350, y: 170, radius: 50}),
				Planet({x: 500, y: 427, radius: 100, speed: .5}),
				Planet({x: 630, y: 160, radius: 100})
			],
			spikeList: [
				Item({planetNum: 2, position: -80, sprite: Sprite("spike"), width: SPIKE_SIZE, height: SPIKE_SIZE}),
				Item({planetNum: 2, position: -170, sprite: Sprite("spike"), width: SPIKE_SIZE, height: SPIKE_SIZE}),
				Item({planetNum: 2, position: 120, sprite: Sprite("spike"), width: SPIKE_SIZE, height: SPIKE_SIZE})
			],
			start: Item({planetNum: 0, position: 120, sprite: Sprite("portal"), width: PORTAL_WIDTH, height: PORTAL_HEIGHT}),
			end: Item({planetNum: 3, position: -20, sprite: Sprite("portal"), width: PORTAL_WIDTH, height: PORTAL_HEIGHT}),
			
		 }),
		 //Level2 layout..
		 Level({
      		planets: [
				Planet({x: 170, y: 400, radius: 100, speed: -.1}),
				Planet({x: 600, y: 200, radius: 150, speed: 0})
			],
			spikeList: [
				Item({planetNum: 1, position: -80, sprite: Sprite("spike"), width: 42, height: 42}),
				Item({planetNum: 1, position: -170, sprite: Sprite("spike"), width: 42, height: 42}),
				Item({planetNum: 1, position: 120, sprite: Sprite("spike"), width: 42, height: 42})
			],
			start: Item({planetNum: 0, position: 120, sprite: Sprite("portal"), width: 30, height: 42}),
			end: Item({planetNum: 1, position: -20, sprite: Sprite("portal"), width: 30, height: 42}),
			
		 }),
		 //Level3 layout..
		 Level({
      		planets: [
				Planet({x: 120, y: 218, radius: 75, speed: 0}),
				Planet({x: 400, y: 327, radius: 50, speed: .5}),
				Planet({x: 600, y: 230, radius: 100, speed: -.1})
			],
			spikeList: [
				Item({planetNum: 0, position: -80, sprite: Sprite("spike"), width: 42, height: 42}),
				Item({planetNum: 1, position: -20, sprite: Sprite("spike"), width: 42, height: 42}),
				Item({planetNum: 2, position: 90, sprite: Sprite("spike"), width: 42, height: 42})
			],
			start: Item({planetNum: 0, position: 120, sprite: Sprite("portal"), width: 30, height: 42}),
			end: Item({planetNum: 2, position: -60, sprite: Sprite("portal"), width: 30, height: 42}),
			
		 })
	   ];
	   
	   //initiates level setup
	   levelSetup();
	   
	    //--------------------------------------LEVEL DEFINITION
        function Level(I) {
			I.planetList;
			I.spikeList;
			I.start;
			I.end;
			I.player;
			return I;
        }
        
        //--------------------------------------PLANET DEFINITION
        function Planet(I) {
          I.active = true;
          I.speed = I.speed || 0;
          I.radius = I.radius;
          I.x = I.x;
          I.y = I.y;
          I.rotation = 0;
          I.sprite = Sprite("planet");
          I.draw = function() {
          	canvas.translate(I.x, I.y);
			canvas.rotate(I.rotation * TO_RADIANS);
          	I.sprite.draw(canvas, -I.radius, -I.radius, I.radius*2, I.radius*2);
			canvas.rotate(-I.rotation * TO_RADIANS);
			canvas.translate(-I.x, -I.y);
          };
          I.update = function() {
          	I.rotation = I.rotation + I.speed;
          	if(I.rotation >= 360)
          	{
          		I.rotation = I.rotation / 360;
          	}
          };
          return I;
        }

        //--------------------------------------PLANET ITEM DEFINITION (Start Portal, End Portal, Spikes)
        function Item(I) {
          I.active = true;
          I.sprite = I.sprite;
          I.width = I.width;
          I.height = I.height;
          I.position = (I.position || 0); 
          I.draw = function() {
			canvas.translate(I.x, I.y);
			canvas.rotate((I.planet.rotation + I.position + 90) * TO_RADIANS);
          	I.sprite.draw(canvas, -I.width/2, -I.height/2, I.width, I.height);
			canvas.rotate(-(I.planet.rotation + I.position + 90) * TO_RADIANS);
			canvas.translate(-I.x, -I.y);        
		  };
          I.update = function(){
          	//movement updates
          	var radians = I.planet.speed * TO_RADIANS;
          	var circleX = (I.x - I.planet.x) * Math.cos(radians) - (I.y - I.planet.y) * Math.sin(radians);
          	var circleY = (I.x - I.planet.x) * Math.sin(radians) + (I.y - I.planet.y) * Math.cos(radians);
          	I.x = circleX + I.planet.x;
          	I.y = circleY + I.planet.y;
          	         	
          }
          return I;
        }
        
        //--------------------------------------PLAYER DEFINITION
        function Player(I) {
          I.active = true;
          I.sprite = Sprite("guy");
          I.width = 35;
          I.height = 45;
          I.planet = I.planet;
          I.position = (I.position || 0);
          I.rotation = 0;
          I.movement = 0;  
          I.jumpCheck = false;
          I.swapCheck = false; 
          I.x = I.planet.x + I.planet.radius * Math.cos(I.position * TO_RADIANS); //transform to radians
          I.y = I.height/2 + I.planet.y + I.planet.radius * Math.sin(I.position * TO_RADIANS); //transform to radians
          I.velocity = 0;
          I.draw = function() {
			canvas.translate(I.x, I.y);
			canvas.rotate(I.rotation);  
          	I.sprite.draw(canvas, -I.width/2,-I.height/2, I.width, I.height);
			canvas.rotate(-I.rotation);
			canvas.translate(-I.x, -I.y);        
		  };
          I.update = function(){
          	
          	//update player sprite rotation based on direction to current planet core
          	I.rotation = Math.acos((I.x - I.planet.x)/findDistance(I, I.planet));
          	//flip rotation if acos is negative
          	if(I.y < I.planet.y) {
          		I.rotation *= -1;
          	}
          	//rotate sprite 90 degrees since original image is vertical and 0 degrees is horizontal
          	I.rotation += (90 * TO_RADIANS);
          	
          	//movement updates
          	var radians = (I.planet.speed + I.movement) * TO_RADIANS; //transform to radians
          	var circleX = (I.x - I.planet.x) * Math.cos(radians) - (I.y - I.planet.y) * Math.sin(radians);
          	var circleY = (I.x - I.planet.x) * Math.sin(radians) + (I.y - I.planet.y) * Math.cos(radians);
          	I.x = circleX + I.planet.x;
          	I.y = circleY + I.planet.y;
          	I.movement = 0;
          	
          	//jump update
          	if(I.jumpCheck){
          		I.velocity -= GRAVITY;
          		//normalize jump velocity direction
          		var len = findDistance(I, I.planet);
          		var normX = (I.x-I.planet.x) / len;
          		var normY = (I.y-I.planet.y) / len;
          		//apply velocity magnitude
          		normX = normX * I.velocity;
          		normY = normY * I.velocity;
          		//transform current coordinates by jump vector
          		I.x += normX;
          		I.y += normY;
          		
          	}      
          	//stop the player when back on the surface    	
          	if(collides(I, I.planet, I.planet.radius + I.height/2)){
          		I.jumpCheck = false;
          		I.swapCheck = false;
          		I.velocity = I.velocity * -1;
          	}
          	
          	//planet switch check
          	planetList.forEach(function(planet) {
          		//calculate distance to new planet surface
            	var distance = findDistance(planet, I) - planet.radius;
            	//calculate distance to current planet surface
            	var currentDist = findDistance(I.planet, I) - I.planet.radius;
            	//jump to new planet if closer and haven't swapped planets yet this jump
            	if(planet != I.planet && distance <= currentDist && I.swapCheck == false){
            		I.planet = planet;	
            		I.swapCheck = true;
            		I.velocity = 0;
            	}
            });
          	
          	//reset to start if spike collision
          	spikeList.forEach(function(spike) {
				if(collides(I, spike, 30)){
					Sound.play("hurt");
					player = Player({planet: start.planet, position: start.position});
				}
			});
			
			//victory check
			if(collides(I, end, 30) && !victory){
				victory = true;
				Sound.play("victory");
				
			}
          	
          }
          return I;
        }
        
        //--------------------------------------DRIVER LOOP
		//sets up the level within the canvas
		function levelSetup(){
			//planets
        	planetList = levelList[CURRENT_LEVEL].planets;
        	//spikes
			spikeList = levelList[CURRENT_LEVEL].spikeList;
        	spikeList.forEach(function(spike) {
            	spike.planet = planetList[spike.planetNum];
				spike.x = spike.planet.x + spike.planet.radius * Math.cos(spike.position * TO_RADIANS); //transform to radians
 				spike.y = spike.planet.y + spike.planet.radius * Math.sin(spike.position * TO_RADIANS); //transform to radians
            });
        	//start
        	start = levelList[CURRENT_LEVEL].start;
        	start.planet = planetList[start.planetNum];
        	start.x = start.planet.x + start.planet.radius * Math.cos(start.position * TO_RADIANS); //transform to radians
 			start.y = start.planet.y + start.planet.radius * Math.sin(start.position * TO_RADIANS); //transform to radians
        	//end
        	end = levelList[CURRENT_LEVEL].end;
        	end.planet = planetList[end.planetNum];
        	end.x = end.planet.x + end.planet.radius * Math.cos(end.position * TO_RADIANS); //transform to radians
 			end.y = end.planet.y + end.planet.radius * Math.sin(end.position * TO_RADIANS); //transform to radians
        	//player
        	player = Player({planet: start.planet, position: start.position});        	
        	//turn off victory condition
        	victory = false;
        	
        }
		
		//updates the game each pass
		function update() {
			//update game objects
       		planetList.forEach(function(planet) {
            	planet.update();
            });
            spikeList.forEach(function(spike) {
            	spike.update();
            });
            start.update();
            end.update();
            player.update();
            
            //update player input
            if(keydown.space && !player.jumpCheck) {
            	player.velocity = JUMP_STRENGTH;
            	player.jumpCheck = true;
            	Sound.play("jump");
          	}
           	if(keydown.left && !keydown.right) {
           		player.position -= MOVE_SPEED;
           		player.movement = -MOVE_SPEED;
          	}
          	if(keydown.right && !keydown.left) {
            	player.position += MOVE_SPEED;
            	player.movement = MOVE_SPEED;
          	}
          	
          	if(victory){
          		if(CURRENT_LEVEL < levelList.length-1)
				{
					CURRENT_LEVEL++;
					levelSetup();
					message = true;
					setTimeout(function(){
						message = false;
					},2000);
				} 
				else{
					message = true;
					setTimeout(function(){
						message = false;
					}, 2000);
					CURRENT_LEVEL = 0; 
					levelSetup();
				}
				
          	}
        }

		//redraws the canvas each game pass
		function draw() {
			//CLEAR OLD DRAWING
          	canvas.clearRect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
          
          	start.draw();
          	end.draw();
          	player.draw();
          	spikeList.forEach(function(spike) {
				spike.draw();
          	});
          
          	planetList.forEach(function(planet) {
				planet.draw();
          	});
          
			if(message){
				canvas.font="70px Verdana";
				// Create gradient
				var gradient=canvas.createLinearGradient(0,0,CANVAS_WIDTH,0);
				gradient.addColorStop("0","orange");
				gradient.addColorStop("0.5","yellow");
				gradient.addColorStop("1.0","red");
				// Fill with gradient
				canvas.fillStyle=gradient;
				canvas.fillText("Great Job!",200,200);
			}
          
        }
        
        //a function to determine if 2 objects are touching
        function collides(a, b, distance) {
        	//calculate distance between objects
          	var d = findDistance(a, b);
          	//determine if distance < area of larger
          	return d < Math.min(distance);
        }
        
        //determines the distance between 2 objects with x and y coordinates
        function findDistance (a, b){
        	return Math.sqrt(Math.pow((a.x-b.x),2) + Math.pow((a.y-b.y),2));
        }
