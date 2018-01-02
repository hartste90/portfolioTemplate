/*
 * File: game.js
 * Author: Steven Hart (steven.hart282@gmail.com)
 * Color Collider Game driver
 */

//DEBUG TOOLS - Leave these alone and commented out
      	var appendError = function(str){
   			// throw new Error("DEBUG: "+str)
		}

		function log(str){
		   setTimeout("appendError('"+str+"')", 1)
		}
      //--------------------------------------ESTABLISH CANVAS
//*1* ALTER THE DIMENSIONS OF THE GAME CANVAS
        var CANVAS_WIDTH = 465;
        var CANVAS_HEIGHT = 350;
//*2* ALTER THE FPS ("game speed") - lower FPS will result in slower gameplay
        var FPS = 30;
        var canvasElement = document.getElementById("game_colorCollider");
		//var ctx = c.getContext("2d");
        var canvas = canvasElement.getContext("2d");
       	
       	//set up mouse autoupdate
       	var mouse = ({x: (CANVAS_WIDTH/2), y: (CANVAS_HEIGHT/2)});
       	var gamestate = "splash";
       	log(gamestate);
       	canvasElement.addEventListener('mousemove', function(evt) {
        	mouse = getMouse(canvas, evt);
      	}, false);
      	//set up click handler
      	canvasElement.addEventListener('click', function(evt) {
      		if(gamestate == "splash"){
      			gamestate = "game";
      		}
      		else{
      			if(player.colorIndex == colorList.length-1){
	        		player.colorIndex = 0;
	        	}
	        	else{
	        		player.colorIndex++;
	        	}
	        	player.color = colorList[player.colorIndex];
	        }
      	}, false);
      
		var message;      
		
		
		var colorList = ["blue","green","red","yellow"]
		var colorIndex = Math.floor(Math.random()*colorList.length);
       	var player = Player({radius: 10, x: mouse.x, y: mouse.y, color: colorList[colorIndex], colorIndex: colorIndex});
        var debrisList = [];
		var time = new Date() / 1000;
    	var refreshId = setInterval(function() {
          update();
          draw();
        }, 1000/FPS);
    
        
        //--------------------------------------PLAYER DEFINITION
        function Player(I) {
		  I.color = I.color;
		  I.colorIndex = I.colorIndex;
          I.radius = I.radius;
          I.x = I.x;
          I.y = I.y;
          I.draw = function() {
          	canvas.beginPath();
		    canvas.arc(I.x, I.y, I.radius, 0, 2 * Math.PI, false);
		    canvas.fillStyle = I.color;
		    canvas.fill();
		    canvas.lineWidth = 1;
		    canvas.strokeStyle = '#ffffff';
		    canvas.stroke();
          };
          I.update = function() {
			I.x = mouse.x;
			I.y = mouse.y;
		  }
		  
		  return I;
        }
        
        //--------------------------------------DEBRIS DEFINITION
        function Debris(I) {
          I.color = I.color;
          I.radius = I.radius;
          I.speedX = I.speedX;
          I.speedY = I.speedY;
          I.x = I.x;
          I.y = I.y;
          I.draw = function() {
          	canvas.beginPath();
		    canvas.arc(I.x, I.y, I.radius, 0, 2 * Math.PI, false);
		    canvas.fillStyle = I.color;
		    canvas.fill();
		    canvas.lineWidth = 5;
		    canvas.strokeStyle = '#003300';
		    canvas.stroke();
          };
          I.update = function() {
          	I.x += I.speedX;
          	I.y += I.speedY;
		  }
		  
		  return I;
        }

		
      function writeMessage(canvas, message) {
        var context = canvas.getContext("2d");
        context.clearRect(0, 0, canvas.width, canvas.height);
        context.font = '18pt Calibri';
        context.fillStyle = 'black';
        context.fillText(message, 10, 25);
      }
      function getMouse(canvas, evt) {
        var rect = canvasElement.getBoundingClientRect();
        return {
          x: evt.clientX - rect.left,
          y: evt.clientY - rect.top
        };
      }
      
      
		function update() {
			
			if(gamestate != "splash")
			{
				//update debris
	       		for (var i = 0; i < debrisList.length; i++) { 
	               	debrisList[i].update();
	            	//destroy debris out of bounds
	            	if(debrisList[i].x - CANVAS_WIDTH > 300 || debrisList[i].y - CANVAS_HEIGHT > 300){
		          		debrisList.splice(i,1);
		          	}
	            	//check for collision
	            	if(collides(debrisList[i], player, (debrisList[i].radius + player.radius)) && debrisList[i].color != player.color){
	            		message = true;
	            		clearInterval(refreshId);
	            		debrisList = [];
	            		
	            		function foobar_cont(){
	            			message = false;
	            			time = (new Date()/1000);
						    refreshId = setInterval(function() {
					          update();
					          draw();
					        }, 1000/FPS);
						};
						sleep(3000, foobar_cont);
	            	}
	            }
	            player.update();
	            //add possible debris
	            if(Math.random() <= .25){
	            	addDebris();
	            }
	        }
        }

		//redraws the canvas each game pass
		function draw() {
			//CLEAR OLD DRAWING
	        canvas.clearRect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
	        if(gamestate != "splash")
			{
				
	            //draw game items
	          	debrisList.forEach(function(debris) {
					debris.draw();
	          	});
	          	player.draw();
	            //show any messages
				if(message){
					canvas.font="30px Verdana";
					// Create gradient
					var gradient=canvas.createLinearGradient(0,0,CANVAS_WIDTH,0);
					gradient.addColorStop("0","orange");
					gradient.addColorStop("0.5","yellow");
					gradient.addColorStop("1.0","red");
					// Fill with gradient
					canvas.fillStyle=gradient;
					canvas.fillText("Lasted: " + ((new Date()/1000) - time).toFixed(2),CANVAS_WIDTH/2-100, CANVAS_HEIGHT/2-15);
				}
			}
			else{
				//if game inactive, draw splash screen
				canvas.beginPath();
			    canvas.arc(CANVAS_WIDTH/2, CANVAS_HEIGHT/2, CANVAS_HEIGHT/2-20, 0, 2 * Math.PI, false);
			    canvas.fillStyle = '#333333';
			    canvas.fill();
			    canvas.lineWidth = 5;
			    canvas.strokeStyle = '#003300';
			    canvas.stroke();
				canvas.font="50px Verdana";
				canvas.fillStyle = '#e9e9e9';
				canvas.fillText("Color Collider", CANVAS_WIDTH/2-170, CANVAS_HEIGHT/2+10);
				canvas.font="30px Verdana";
				canvas.fillText("[ Click to Play ]", CANVAS_WIDTH/2-115, CANVAS_HEIGHT/2+80);
			}
        }
        
        function addDebris(){
        	var rad = Math.min(CANVAS_WIDTH, CANVAS_HEIGHT)/5 * Math.random();
        	var d = Debris({radius: rad, x: getRandomInt(-200, -100), y: getRandomInt(-100, 100), speedX: getRandomInt(0,10), speedY: getRandomInt(0,10), color: colorList[Math.floor(Math.random()*colorList.length)]});
        	debrisList.push(d);
        }
		
		function getRandomInt(min, max) {
		    return Math.floor(Math.random() * (max - min + 1)) + min;
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
        
		function sleep(millis, callback) {
		    setTimeout(function()
		            { callback(); }
		    , millis);
		}