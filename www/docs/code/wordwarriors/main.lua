--Word Warriors - an adventure typing game
--------------AUTHORED BY Steven Hart

--Permission is hereby granted, free of charge, to any person
--obtaining a copy of this software and associated documentation
--files (the "Software"), to deal in the Software without
--restriction, including without limitation the rights to use,
--copy, modify, merge, publish, distribute, sublicense, and/or sell
--copies of the Software, and to permit persons to whom the
--Software is furnished to do so, subject to the following
--conditions:

--THE NOTICE OF AUTHORSHIP AND THIS PERMISSION NOTICE SHALL BE 
--PRESENT IN ALL COPIES OR SUBSTANTIAL PORTIONS OF THE SOFTWARE.

--THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
--EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
--OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
--NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
--HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
--WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
--FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
--OTHER DEALINGS IN THE SOFTWARE.


--NOTE:  This file has been modified from its original modulated form into a single
--file for readability.

--FILE SETUP
require("AnAL");
arc_path = 'arc/'
require(arc_path .. 'arc')
_navi = require(arc_path .. 'navi')
----------------------------------
--function: load
--:: initialization of program and loading exterior files
----------------------------------
function love.load()
	--LOAD WINDOW
	lg = love.graphics;
	la = love.audio;
	lg.setMode(600,600,false);  --set to TRUE for FULL SCREEN
	lg.setCaption("Word Warriors");
	lg.setIcon(lg.newImage("img/knight_cover.png"));
	--LOAD FONT
	font = lg.newImageFont("newFont.png", " abcdefghijklmnopqrstuvwxyz");
	--LOAD SOUNDS
	sound_explode = la.newSource("SOUND/explode.ogg", "stream");
	sound_heal = la.newSource("SOUND/heal.ogg", "stream");
	sound_hit = la.newSource("SOUND/hit.ogg", "stream");
	sound_keypress = la.newSource("SOUND/keypress.ogg", "stream");
	sound_lazer = la.newSource("SOUND/lazer.ogg", "stream");
	sound_lowpower = la.newSource("SOUND/lowpower.ogg", "stream");
	sound_mistake = la.newSource("SOUND/mistake.ogg", "stream");
	sound_next = la.newSource("SOUND/next.ogg", "stream");
	sound_select = la.newSource("SOUND/select.ogg", "stream");
	sound_shield = la.newSource("SOUND/shield.ogg", "stream");
	sound_victory = la.newSource("SOUND/victory.ogg", "stream");
	sound_defeat = la.newSource("SOUND/defeat.ogg", "stream");
	music_background = la.newSource("SOUND/music_background_slow.ogg", "static");
	--LOAD STATIC IMAGES
	txt_play = lg.newImage('MENU/txt_play.png');
	txt_playOP = lg.newImage('MENU/txt_playOP.png');
	txt_menu = lg.newImage('MENU/txt_mainmenu.png');
	txt_menuOP = lg.newImage('MENU/txt_mainmenuOP.png');
	txt_story = lg.newImage('MENU/txt_story.png');
	txt_storyOP = lg.newImage('MENU/txt_storyOP.png');
	txt_next = lg.newImage('MENU/txt_next.png');
	txt_nextOP = lg.newImage('MENU/txt_nextOP.png');
	txt_instructions = lg.newImage('MENU/txt_instructions.png');
	txt_instructionsOP = lg.newImage('MENU/txt_instructionsOP.png');
	info_witch = lg.newImage('MENU/Witch_info.png');
	info_knight = lg.newImage('MENU/Knight_info.png');
	info_priest = lg.newImage('MENU/Priest_info.png');
	priest_small = lg.newImage('IMAGES/priest_small.png');
	knight_small = lg.newImage('IMAGES/knight_small.png');
	witch_small = lg.newImage('IMAGES/witch_small.png');
	face_help = lg.newImage('IMAGES/face_help.png');
	face_lord = lg.newImage('IMAGES/face_lord.png');
	face_boss1 = lg.newImage('IMAGES/face_boss1.png');
	overlay = lg.newImage('IMAGES/overlay.png');
	scene = lg.newImage('IMAGES/scene.png');
	border = lg.newImage('IMAGES/border.png');
	victory = lg.newImage('IMAGES/victory.png');
	defeat = lg.newImage('IMAGES/defeat.png');
	background = lg.newImage("img/background.png");
	--LOAD ANIMATION IMAGES
	priest_stand = lg.newImage("ANIMATIONS/priest_spritesheet.png");
	priest_death = lg.newImage("ANIMATIONS/priest_death.png");
	knight_stand = lg.newImage("ANIMATIONS/knight_spritesheet.png");
	knight_death = lg.newImage("ANIMATIONS/knight_death.png");
	witch_stand = lg.newImage("ANIMATIONS/witch_spritesheet.png");
	witch_death = lg.newImage("ANIMATIONS/witch_death.png");
	priest_stand_large = lg.newImage("ANIMATIONS/priest_spritesheet_large.png");
	knight_stand_large = lg.newImage("ANIMATIONS/knight_spritesheet_large.png");
	witch_stand_large = lg.newImage("ANIMATIONS/witch_spritesheet_large.png");
	lord_stand = lg.newImage("ANIMATIONS/lord_standing.png");
	fade = lg.newImage("ANIMATIONS/fade.png");
	flag_waving = lg.newImage('ANIMATIONS/flag_waving.png');
	small_flag = lg.newImage('ANIMATIONS/smallFlag.png');
	medium_flag = lg.newImage('ANIMATIONS/mediumFlag.png');
	energyBall = lg.newImage('ANIMATIONS/energyBall-flat.png');
	heal = lg.newImage("ANIMATIONS/heal.png");
	shield = lg.newImage("ANIMATIONS/shield_spell.png");
	blast = lg.newImage("ANIMATIONS/blast_spell.png");
	explosion = lg.newImage("ANIMATIONS/explosion.png");
	--LOAD ANIMATIONS
	anim_witch_large = newAnimation(witch_stand_large, 200, 320, 0.2, 0);
	anim_knight_large = newAnimation(knight_stand_large, 240, 320, 0.3, 0);
	anim_priest_large = newAnimation(priest_stand_large, 180, 320, 0.2, 0);
	anim_witch = newAnimation(witch_stand, 50, 80, 0.2, 0);
	anim_knight = newAnimation(knight_stand, 60, 80, 0.2, 0);
	anim_priest = newAnimation(priest_stand, 45, 80, 0.2, 0);
	anim_priest_death = newAnimation(priest_death, 45, 80, 0.1, 0);
	anim_priest_death:setMode('once');
	anim_knight_death = newAnimation(knight_death, 50, 62, 0.1, 0);
	anim_knight_death:setMode('once');
	anim_witch_death = newAnimation(witch_death, 50, 58, 0.1, 0);
	anim_witch_death:setMode('once');
	anim_lord = newAnimation(lord_stand, 184, 372, 0.2, 0);
	anim_fade = newAnimation(fade, 600, 600, 0.4, 0);
	anim_fade:setMode('once');
	anim_flag = newAnimation(flag_waving, 315, 400, 0.1, 0);
	anim_smallFlag = newAnimation(small_flag, 63, 80, 0.1, 0);
	anim_mediumFlag = newAnimation(medium_flag, 117, 150, 0.1, 0);
	anim_energyBall = newAnimation(energyBall, 128, 129, 0.1, 0);
	anim_heal = newAnimation(heal, 192, 192, 0.1, 0);
	anim_shield = newAnimation(shield, 144, 238, 0.1, 0);
	anim_blast = newAnimation(blast, 493, 472, 0.1, 0);
	anim_explosion = newAnimation(explosion, 64, 64, .1, 0);
	anim_explosion:setMode("once");
    initializeVariables();
end
----------------------------------
--function: keypressed
--:: handle user input to the keyboard
----------------------------------
function love.keypressed(key, unicode)
	--GET LETTER ENTERED
	arc.set_key(key)
	if(gamestate == 'game') then
	-----------POWER MANAGER------------
		flagMistake = true;	--the input is incorrect
		--Navi sounds
		if(key == "tab") then la.play(sound_next); flagMistake = false; end
		--Priest Power
		if(key ==  "left") then
			if (life_priest > 0) and (power >= 200) and (round >= 2) then
				power = power - 200;
				if(life_knight > 0) then life_knight = life_knight + 15; end
				if(life_priest > 0) then life_priest = life_priest + 15; end
				if(life_witch > 0) then life_witch = life_witch + 15; end
				la.play(sound_heal);
				heal = true;
			else
				la.play(sound_lowpower);	
			end		
			flagMistake = false;
		--Knight Power
		elseif (key == "up") then
			if (life_knight > 0) and (power >= 50) and (round >= 2) then
				power = power - 50;
				shield = true;
				la.play(sound_shield);
			else
				la.play(sound_lowpower);	
			end	
			flagMistake = false;
		--Witch Power
		elseif (key == "right") then
			if (life_witch > 0) and (power >= 150) and (round >= 2) then
				power = power - 150;
				blast = true;
				la.play(sound_lazer);
				--wipe closest 3 words
				for i = 1, 3, 1 do
					--add explosion for this word at its location
					if(activeWords[i] ~= nil) then
						explode(activeWords[i].x, activeWords[i].y);
					end		
				end
				for i = 1, 3, 1 do
					--if current word is close >> wipe current word
					if(activeWords[1] ~= nil and currentWord == activeWords[1].text) then
						currentWord = nil;
						userWord = nil;
						currentIndex = nil;
					end
					--remove word
					table.remove(activeWords, 1);	
				end
			else
				la.play(sound_lowpower);	
			end	
			flagMistake = false;
		elseif (key == "down") then
			flagMistake = false;
		else 
			letter = string.char(unicode);
		end
	-----------TYPING MANAGER-----------
	if(currentWord == nil) then
		--go through all active words
		for i=1, table.getn(activeWords), 1 do
			--check if the word's next letter matches input
			if(activeWords[i].text ~= nil) then
				if(activeWords[i].text[1] == letter) then
					activeIndex = i;
					currentWord = activeWords[i].text;
					location.x = activeWords[i].x;
					location.y = activeWords[i].y;
					userWord = {currentWord[1]};
					table.remove(currentWord, 1);
					currentIndex = letter;
					flagMistake = false;  -- input not incorrect
					la.play(sound_keypress);
					
				end
			end
		end
	--if there is a word being worked on
	else
		--if the input matches next letter - move it to typed letters
		if(letter == currentWord[1]) then
			flagMistake = false;
			table.insert(userWord, letter);
			table.remove(currentWord, 1);
			la.play(sound_keypress);
		else
			power = power - 4.5;
		end
		--if that completes the word -> nullify words
		if(table.getn(currentWord) == 0) then
			--put an explosion at the current word's position
			explode(location.x, location.y);
			--update power and score
			power = (power + (table.getn(userWord)/2) * 4.5) + (combos/2);
			score = math.ceil(score + (table.getn(userWord)/2) * (combos + 1));
			currentWord = nil;
			userWord = nil;
			--if no mistakes in this word, add it to the combo
			if(perfect) then 
				combos = combos + 1; 
				if(combos > bestCombo) then 
					bestCombo = combos;
				end
			end
			perfect = true;
			--remove the word in active words that starts with that same letter
			for i,v in ipairs(activeWords) do
				--var = v.text[1];
      	  		if(v.text~= nil and v.text[1] == currentIndex) then
      	  			table.remove(activeWords,i);
					currentIndex = nil;
				end
      		end
      
		end
		
	end
	end
	--check if the input was a mistake
	if(flagMistake and alphaNum(letter)) then 
		mistakes = mistakes + 1 
		combos = 0;
		score = math.ceil(score - 4);
		perfect = false;
		la.play(sound_mistake);
	end
end
----------------------------------
--function: update
--:: recurrent update function checked each step of game-time
--:: specifically used to update animations, sounds, and 
----------------------------------
function love.update(dt)
	---UPDATE ANIMATIONS
	arc.check_keys(dt)
	anim_priest:update(dt);
	anim_witch:update(dt);
	anim_knight:update(dt);
	if(life_priest < 1) then anim_priest_death:update(dt); end
	if(life_knight < 1) then anim_knight_death:update(dt); end
	if(life_witch < 1) then anim_witch_death:update(dt); end
	anim_priest_large:update(dt);
	anim_witch_large:update(dt);
	anim_knight_large:update(dt);
	anim_lord:update(dt);
	anim_fade:update(dt);
	anim_flag:update(dt);
	anim_smallFlag:update(dt);
	anim_mediumFlag:update(dt);
	anim_energyBall:update(dt);
	anim_heal:update(dt);
	anim_shield:update(dt);
	anim_blast:update(dt);
	anim_explosion:update(dt);
	
	la.play(music_background);
	if(gamestate == 'game') then
		------------STATS MANAGER-------------
		--dont let stats go below 0
		if(power < 0) then power = 0; end
		if(life_priest < 0) then life_priest = 0; end
		if(life_knight < 0) then life_knight = 0; end
		if(life_witch < 0) then life_witch = 0; end
		--dont let stats go above 100
		if(power > 300) then power = 300; end
		if(life_priest > 100) then life_priest =  100; end
		if(life_knight > 100) then life_knight = 100; end
		if(life_witch > 100) then life_witch = 100; end
		--check for defeat
		if(life_priest + life_knight + life_witch == 0) then gamestate = "defeat"; end
		
		-----------POWER MANAGER--------------
		--if you activated heal >> set endtime for animation
		if(heal == true) then
			heal_end = love.timer.getTime() + 1;
			anim_heal:reset();
			heal = false;		
		end
		
		if(shield == true) then
			shield_end = love.timer.getTime() + 2;
			anim_shield:reset();
			shield = false;
		end	
		
		if(blast == true) then
			blast_end = love.timer.getTime() + .9;
			anim_blast:reset();
			blast = false;
		end		
		------------PROJECTILE MANAGER-----------
		--adjust position of falling words
		for i=1, table.getn(activeWords), 1 do
			if(activeWords[i] ~= nil) then
				activeWords[i].x = activeWords[i].x - 1;
				activeWords[i].y = activeWords[i].y - activeWords[i].drop;
				
			end
		end
		--update location of activeWord
		if(activeWords[activeIndex] ~= null) then
			location.x = activeWords[activeIndex].x;
			location.y = activeWords[activeIndex].y
		end
		
		------------EXPLOSION MANAGER--------------
		--iterate through explosions
		removing = {};
		for i=1, table.getn(explosions), 1 do
			--add completed explosions to the "to be removed" list
			if(explosions[i].anim:getCurrentFrame() == explosions[i].anim:getSize()) then
				table.insert(removing, i);
			end
			--update explosions in progress
			explosions[i].anim:update(dt);
		end
		--remove completed explosions
		for i=1, table.getn(removing), 1 do
			table.remove(explosions, removing[i]);
		end
		-----------COLLISION MANAGER---------------
	--if the word is too low
		if(activeWords[1] ~= nil and activeWords[1].x <= 40) then
		--character loses life
			if (shield_end < love.timer.getTime()) then
				la.play(sound_hit);
				if(activeWords[1].target == 410) then
					life_priest = life_priest - 10;
				end
				if(activeWords[1].target == 460) then
					life_knight = life_knight - 10;
				end
				if(activeWords[1].target == 530) then
					life_witch = life_witch - 10;
				end
			end
		--check if the passed word is the same word you've been working on
			if(currentIndex ~= nil and userWord ~= nil) then
				if(userWord[1] == currentIndex) then
				--wipe current word stats
					currentWord = nil;
					userWord = nil;
					currentIndex = nil;
				end
			end
			table.remove(activeWords, 1);
		end
	--if the word is completed
		for i=1, table.getn(activeWords), 1 do
				if(activeWords[i].text ~= nil and next(activeWords[i].text) == nil) then
					table.remove(activeWords, i);
					
					break;
				end
		end	
	------------ROUND MANAGER-------------
		--if messages are complete
		if(messagesDone(round)) then
			--you're playing in the round
			if(inRound) then
				--check for round completion
				if(love.timer.getTime() - roundTime > 2 and table.getn(activeWords)==0 and wordsComplete()) then
					round = round + 1;
					score = math.ceil(score + (round * 10));
					inRound = false;
				end
			--or the level needs to start
			else
				levelWords = wordList[round];
				roundTime = love.timer.getTime();
				inRound = true;
			end
		end
		-----------ADD WORDS TO ROUND---------
		--check for endgame
		if(messagesDone(5)) then 
			gamestate = 'victory';
		else
			addActives();
		end	
		
	end
	
end
----------------------------------
--function: draw
--:: controls the game images and visual text
----------------------------------
function love.draw()
	local x, y = love.mouse.getPosition();
	-------------DRAW SPLASH SCREEN---------------
	if(gamestate == 'splash') then
		
		lg.draw(scene, 0, 0);
		lg.draw(txt_play, 250, 390);
		
		if(x > 250 and x < 450 and y > 400 and y < 435) then
			lg.draw(txt_playOP, 250, 390);
		end
		anim_flag:draw(160, 50);
		lg.print("created by Steven Hart", 220, 560);
	-------------DRAW INFO SCREEN---------------	
	elseif(gamestate == 'intro') then
		lg.draw(background, 0, 0);
		anim_lord:draw(51,68);	
		_navi.play_list(m,250,80)
		if m[#m]:is_over() then gamestate='game'; roundTime=love.timer.getTime(); end
    	lg.setColor(255,255,255);
    -------------DRAW KNIGHT SCREEN---------------
    elseif(gamestate == 'info_knight') then
    	lg.draw(info_knight, 0, 0);
    	anim_knight_large:draw(60,50);
    	lg.draw(txt_next, 435, 535);
    	if(x > 300 and y > 530 and y < 590) then lg.draw(txt_nextOP, 435, 535); end
    -------------DRAW WITCH SCREEN---------------
    elseif(gamestate == 'info_witch') then
    	lg.draw(info_witch, 0, 0);
    	anim_witch_large:draw(50,30);
    	lg.draw(txt_next, 435, 535);
    	if(x > 300 and y > 530 and y < 590) then lg.draw(txt_nextOP, 435, 535); end
    -------------DRAW PRIEST SCREEN---------------
    elseif(gamestate == 'info_priest') then
    	lg.draw(info_priest, 0, 0);
    	anim_priest_large:draw(50,80);
    	lg.draw(txt_next, 435, 535);
    	if(x > 300 and y > 530 and y < 590) then lg.draw(txt_nextOP, 435, 535); end
	elseif (gamestate == 'game') then
		
		-------------DRAW BACKGROUND---------------
		lg.draw(scene, 0, 0);
		lg.draw(overlay, 0, -3);
		
		-------------DRAW DEBUG INFO---------------
		lg.print(round, 345, 50);
		lg.print(score, 430, 50);
		lg.print(combos, 530, 50);
		--SOUND--
		x, y, z = love.audio.getPosition(music_background);
	   -------------DRAW CHARACTERS---------------
		if(life_priest < 1) then 
			anim_priest_death:draw(65, 396);
		else
			anim_priest:draw(65,396);
		end
		if(life_knight < 1) then
			anim_knight_death:draw(50, 430); 
		else
			anim_knight:draw(50,430);
		end
		if(life_witch < 1) then
			anim_witch_death:draw(40, 500); 
		else
			anim_witch:draw(26,487);
		end
		-------------DRAW HEAL ANIMATION---------------
		if (heal_end > love.timer.getTime()) then
			if(life_priest > 0) then anim_heal:draw(0,300); end
			if(life_knight > 0) then anim_heal:draw(-20,345); end
			if(life_witch > 0) then anim_heal:draw(-45,410); end
		end
		-------------DRAW SHIELD ANIMATION---------------
		if (shield_end > love.timer.getTime()) then
			anim_shield:draw(25,380);
		end
		-------------DRAW EXPLOSIONS---------------
		for i=1, table.getn(explosions), 1 do
			explosions[i].anim:draw(explosions[i].x, explosions[i].y);
		end
		-------------DRAW LAZER ANIMATION------------
		if (blast_end > love.timer.getTime()) then
			anim_blast:draw(85,130);
		end
		-------------DRAW STAT BARS---------------
		lg.setColor(170, 110, 190);
		lg.rectangle('fill', 110, 80, life_witch, 10);
		lg.setColor(0, 0, 0);
		lg.rectangle('line', 110, 80, 101, 10);
		lg.setColor(135, 176, 197);
		lg.rectangle('fill', 110, 58, life_knight, 10);
		lg.setColor(0, 0, 0);
		lg.rectangle('line', 110, 58, 101, 10);
		lg.setColor(0, 100, 10);
		lg.rectangle('fill', 110, 35, life_priest, 10);
		lg.setColor(0, 0, 0);
		lg.rectangle('line', 110, 35, 101, 10);
		 	--power bar
		lg.setColor(200, 100, 10);
		lg.rectangle('fill', 200, 94, power, 20);
		lg.setColor(255, 255, 255);
		lg.rectangle('line', 200, 94, 301, 20);
		-------------DRAW WORDS---------------
		for i=1, table.getn(activeWords), 1 do
			if(activeWords[i].text ~= nil) then
				anim_energyBall:draw(activeWords[i].x - 15, activeWords[i].y - 62);
				lg.printf(arrayToString(activeWords[i].text), activeWords[i].x, activeWords[i].y, 100, 'center');
			end
		end	
		
		-------------DRAW MESSAGES---------------
		if(messagesDone(round) == false) then
			_navi.play_list(messageList[round],0,0)
		-------------DRAW ROUND SCREENS---------------
		elseif (roundNum(love.timer.getTime()-roundTime, 0) < 3) then
			lg.print("Round: ", 280, 300);
			lg.print(round, 330, 300);
		end
		anim_fade:draw(0,0);
		lg.setColor(255,255,255);
	else
		lg.draw(scene, 0, 0);
		lg.draw(txt_menu, 230, 235);
		if(x > 220 and x < 380 and y > 225 and y < 270) then
			lg.draw(txt_menuOP, 230, 235);
		end
		if(gamestate == 'victory') then
			lg.draw(victory, 0, 0);
			if(finalSound) then la.play(sound_victory); finalSound = false; end
		elseif(gamestate == 'defeat') then
			lg.draw(defeat, 0, 0);
			if(finalSound) then la.play(sound_defeat); finalSound = false; end
		end		
		lg.print(score, 225, 535);
		lg.print(bestCombo, 380, 535);
	end
	
	lg.draw(border, 0, 0);
	arc.clear_key()
	
end
----------------------------------
--function: write
--:: overload of printing function
----------------------------------
function write(word, x, y)
    lg.printf(word, x, y, 100, "center");
end
----------------------------------
--function: printArray
--:: prints full array of words
----------------------------------
function printArray(word, x, y, position)
      for i,v in ipairs(word) do
        lg.printf(v, x+i*7, y, 50, position);
      end
end
----------------------------------
--function: arrayToString
--:: concatenate and cast new String
----------------------------------
function arrayToString(word)
	finish = "";
	for i,v in ipairs(word) do
        finish = finish..v
    end
    return finish;
end
----------------------------------
--function: addWord
--:: create new metadata and add word to indicated list
----------------------------------
function addWord(wordlist, index)
	goal = findTarget();
	word = {
		text = wordlist[index].text,
		x = 600, 
		-- random starting height
		y = math.random(100, 500),     
		target = goal,
		drop = nil};
	word.drop = -1*((goal-word.y)/570);
	table.insert(activeWords, word);
end
----------------------------------
--function: findTarget
--:: assigns target to projectile based on which characters are still alive
----------------------------------
function findTarget()
	goal = math.random(1,3);
	if(goal == 1) then
		if(life_priest > 0) then return 410;  -- target priest
		else --target next highest life member
			if(life_knight > life_witch) then return 460;
			else return 530;
			end
		end
	end
	if(goal == 2) then
		if(life_knight > 0) then return 460;  -- target knight
		else --target next highest life member
			if(life_priest > life_witch) then return 410;
			else return 530;
			end
		end
	end
	if(goal == 3) then
		if(life_witch > 0) then return 530;  -- target witch
		else --target next highest life member
			if(life_knight > life_priest) then return 460;
			else return 410;
			end
		end
	end
end
function roundNum(number, decimal)
	local multiplier = 10^(decimal or 0)
	return math.floor(number * multiplier + 0.5) / multiplier
end
----------------------------------
--function: mousepressed
--:: controls user input from mouse
----------------------------------
function love.mousepressed(x,y,k)

	if(gamestate == 'splash') then
		if(x > 250 and x < 450 and y > 400 and y < 435) then
			gamestate = 'game';
			finalSound = true;
			roundTime = love.timer.getTime();
		end
	elseif(gamestate == 'info_priest') then
		if(x > 300 and y > 530 and y < 590) then
			gamestate = 'info_knight';
		end
	elseif(gamestate == 'info_knight') then
		if(x > 300 and y > 530 and y < 590) then
			gamestate = 'info_witch';
		end
	elseif(gamestate == 'info_witch') then
		if(x > 300 and y > 530 and y < 590) then
			gamestate = 'splash';
		end
	else
		if(x > 220 and x < 380 and y > 225 and y < 270) then
			initializeVariables();
			gamestate = 'splash';
		end
	end
end
----------------------------------
--function: loadConversations
--:: stores dialogue for game characters
----------------------------------
function loadConversations()
	--Introduction
	mIntro = {};
	mIntro[1] = _navi:new("Help me Warriors!  The castle is under attack! |n|c{gray}Press |c{mgreen} "..arc.btn.ent.."|c{gray}to continue.",
        {name="Lord Palumbus:", face = face_lord, x=70, y = 170, hbox = 500, wbox=300});
    mIntro[2] = _navi:new("|c{white}The Warlock is after my head!  Protect me and my riches are yours! |n|c{gray}Press |c{mgreen} "..arc.btn.ent.."|c{gray}to continue.",
     	{name="Lord Palumbus:", face = face_lord, x=60, y = 170, hbox = 800, wbox=300});
	mIntro[3] = _navi:new("|c{mgreen}Type the words to destroy them. |n|c{gray}Press |c{mgreen} "..arc.btn.ent.."|c{gray}to continue.",
     	{face = face_help,  x=70, y = 170, h = 500, wbox=300});
    table.insert(messageList, mIntro);
    --Powers/Focus Explanation
    mPowers = {};
    mPowers[1] = _navi:new("Your powers will to help you in battle: |n|c{gray}Press |c{mgreen} "..arc.btn.ent.."|c{gray}to continue." ,
    	   {name="Lord Palumbus:", face = face_lord, x=70, y = 170, hbox = 500, wbox=300});
    mPowers[2] = _navi:new("The orange bar above shows you how much power you have. Type accurately to gain power! ",
    	   {name="Lord Palumbus:", face = face_lord, x=70, y = 170, h = 500, wbox=300});
    mPowers[3] = _navi:new("|c{mgreen} LEFT ARROW |c{white}|n Heal your team - COSTS 200",
    	   {name="Priest:", face = priest_small, x=70, y = 170, h = 500, wbox=400});
    mPowers[4] = _navi:new("|c{mgreen} UP ARROW |c{white}|n Limited invincibility - COSTS 50",
    	   {name="Knight:", face = knight_small, x=70, y = 170, h = 500, wbox=400});
	mPowers[5] = _navi:new("|c{mgreen} RIGHT ARROW |c{white}|n Blast incoming dangers - COSTS 150",
    	   {name="Witch:", face = witch_small, x=70, y = 170, h = 500, wbox=400});
    mPowers[6] = _navi:new("Only living team members can use their abilities - SO KEEP THEM ALIVE!",
    	   {name="Lord Palumbus:", face = face_lord, x=70, y = 170, h = 500, wbox=400});
	table.insert(messageList, mPowers); 
	mBoss1 = {};
	mBoss1[1] = _navi:new("Friends of the King are you? |n|c{gray}Press |c{mgreen} "..arc.btn.ent.."|c{gray}to continue.",
    	{name="Grall the Wizard:", face=face_boss1, x=275, y = 435, wbox=300});
    mBoss1[2] = _navi:new("You won't survive much longer! |n|c{gray}Press |c{mgreen} "..arc.btn.ent.."|c{gray}to continue.",
    	{name="Grall the Wizard:", face=face_boss1, x=275, y = 435, wbox=300});
    table.insert(messageList,mBoss1);
	mBoss2 = {};
	mBoss2[1] = _navi:new("Pretty impressive - but not good enough. |n|c{gray}Press |c{mgreen} "..arc.btn.ent.."|c{gray}to continue.",
    	{name="Grall the Wizard:", face=face_boss1, x=275, y = 435, wbox=300});
    mBoss2[2] = _navi:new("Let's see if you can handle this! |n|c{gray}Press |c{mgreen} "..arc.btn.ent.."|c{gray}to continue.",
    	{name="Grall the Wizard:", face=face_boss1, x=275, y = 435, wbox=300});
    table.insert(messageList,mBoss2);
    mVictory = {};
	mVictory[1] = _navi:new("Blast! I underestimated you Word Warriors. |n|c{gray}Press |c{mgreen} "..arc.btn.ent.."|c{gray}to continue.",
    	{name="Grall the Wizard:", face=face_boss1, x=275, y = 435, wbox=300});
    mVictory[2] = _navi:new("You may have won this time, but I'll be back to finish you off! |n|c{gray}Press |c{mgreen} "..arc.btn.ent.."|c{gray}to continue.",
    	{name="Grall the Wizard:", face=face_boss1, x=275, y = 435, wbox=300});
    table.insert(messageList,mVictory);
end
----------------------------------
--function: messagesDone
--:: returns true if the messages have been completed for the indicated round
----------------------------------
function messagesDone(round)
	for i=1, table.getn(messageList[round]), 1 do
			if(messageList[round][i]:is_over() == false) then
				return false;
			end
	end	
	return true;
end
----------------------------------
--function: wordsComplete
--:: returns true if all words for current round have been completed
----------------------------------
function wordsComplete()
	for i=1, table.getn(levelWords), 1 do
			if(levelWords[i].time ~= -1) then
				return false;
			end
	end	
	return true;
end
----------------------------------
--function: addActives
--:: adds current list of words to active list
----------------------------------
function addActives()
	for i=1, table.getn(levelWords), 1 do
		if(levelWords[i].time < (roundNum(love.timer.getTime()-roundTime, 0)) 
		and levelWords[i].time ~= -1) then 
					addWord(levelWords, i); 
					levelWords[i].time = -1;
		end
	end
end
----------------------------------
--function: initializeVariables
--:: initializes variables for new game, called upon game beginning and reset
----------------------------------
function initializeVariables()
	--LOAD CONVERSATIONS (Navi)
    messageList = {};
	loadConversations();
	--LOAD WORDS
   wordList = {
    { --round 0
		{
			text = {'s','t','a','r','t'},
			time = 1
		},
		{
			text = {'n','o','w'},
			time = 2
		},
		{
			text = {'t','y','p','i','n','g'},
			time = 3
		}
    },
    { --ROUND 1
    	{
    		text = {'f','i','r','s','t'},
    		time = 1
    	},
    	{
    		text = {'g','i','r','l'},
    		time = 3
    	},
    	{
    		text = {'w','i','g','g','l','e'},
    		time = 3
    	},
    	{
    		text = {'d','a','i','s','y'},
    		time = 5
    	},
    	{
    		text = {'j','u','m','p'},
    		time = 7
    	},
    	{
    		text = {'s','e','c','o','n','d'},
    		time = 7
    	},
    	{
    		text = {'c','a','s','i','n','g'},
    		time = 8
    	},
    	{
    		text = {'b','a','s','k','e','t'},
    		time = 9
    	},
    	{
    		text = {'t','o','w','e','l'},
    		time = 10
    	},
    	{
    		text = {'r','o','a','s','t','e','d'},
    		time = 14
    	},
    	{
    		text = {'p','o','w','e','r'},
    		time = 15
    	},
    	{
    		text = {'i','n','j','e','c','t','i','o','n'},
    		time = 15
    	},
    	----------
    	{
    		text = {'m','u','s','e','u','m'},
    		time = 20
    	},
    	{
    		text = {'g','i','f','t'},
    		time = 20
    	},
		{
    		text = {'f','o','u','r','t','h'},	
    		time = 21
    	},
    	{
    		text = {'d','r','e','a','d','f','u','l'},
    		time = 22
    	},
    	{
    		text = {'z','e','n','i','t','h'},
    		time = 23
    	},
    	{
    		text = {'v','e','n','d','o','r'},	
    		time = 25
    	},
    	{
    		text = {'k','i','l','l','e','r'},	
    		time = 26
    	},
    	{
    		text = {'p','l','u','m','a','g','e'},	
    		time = 27
    	},
    	{
    		text = {'a','b','o','r','t'},	
    		time = 30
    	},
    	----------
    	{
    		text = {'h','a','t','e'},	
    		time = 35
    	},
    	{
    		text = {'w','h','i','t','e','f','i','s','h'},	
    		time = 36
    	},
    	{
    		text = {'f','i','n','a','n','c','i','e','r'},	
    		time = 36
    	},
    	{
    		text = {'e','u','r','e','k','a'},	
    		time = 37
    	},
    	{
    		text = {'u','n','w','a','n','t','e','d'},	
    		time = 39
    	},
    	{
    		text = {'i','m','p','a','s','s'},	
    		time = 41
    	},
    	{
    		text = {'b','u','l','l','e','t','i','n'},	
    		time = 42
    	},
    	{
    		text = {'d','i','l','u','t','e'},	
    		time = 42
    	},
    	{
    		text = {'t','e','r','m','i','n','o','l','o','g','y'},	
    		time = 43
    	},
    	{
    		text = {'q','u','i','c','k','e','n'},	
    		time = 45
    	},
    	{
    		text = {'s','p','o','i','l','e','r'},	
    		time = 46
    	},
    	{
    		text = {'l','i','m','b','o'},	
    		time = 48
    	}
	},
	{
		{
    		text = {'F','i','f','t','h'},
    		time = 1
    	},
    	{
    		text = {'W','i','n','d','o','w'},	
    		time = 2
    	},
    	{
    		text = {'T','y','p','e','w','r','i','t','e','r'},	
    		time = 4
    	},
    	{
    		text = {'B','l','a','s','t','e','r'},	
    		time = 6
    	},
    	{
    		text = {'R','i','g','i','d'},
    		time = 7
    	},
    	{
    		text = {'A','p','p','l','a','u','s','e'},
    		time = 8
    	},
    	{
    		text = {'H','e','l','p','f','u','l'},
    		time = 10
    	},
    	{
    		text = {'C','u','r','v','e'},
    		time = 15
    	},
    	{
    		text = {'D','e','m','i','n','i','s','h'},
    		time = 15
    	},
    	----------------
    	{
    		text = {'E','l','e','p','h','a','n','t'},
    		time = 20
    	},
    	{
    		text = {'F','u','r','l','o','u','g','h'},
    		time = 21
    	},
    	{
    		text = {'G','a','r','g','a','n','t','u','a','n'},
    		time = 24
    	},
    	{
    		text = {'H','e','l','p'},
    		time = 26
    	},
    	{
    		text = {'P','e','r','f','e','c','t'},
    		time = 27
    	},
    	{
    		text = {'J','u','s','t','i','f','y'},
    		time = 27
    	},
    	{
    		text = {'K','i','n','g','d','o','m'},
    		time = 29
    	},
    	{
    		text = {'L','i','m','p'},
    		time = 30
    	},
    	---------
    	{
    		text = {'M','i','m','i','c'},
    		time = 35
    	},
    	{
    		text = {'O','p','t','i','o','n','a','l'},
    		time = 35
    	},
    	{
    		text = {'Q','u','e','e','n'},
    		time = 36
    	},
    	{
    		text = {'R','e','p','o','r','t'},
    		time = 39
    	},
    	{
    		text = {'S','t','r','e','t','c','h'},
    		time = 39
    	},
    	{
    		text = {'T','i','n'},
    		time = 41
    	},
    	{
    		text = {'V','e','n','t'},
    		time = 43
    	},
    	{
    		text = {'W','i','d','o','w'},
    		time = 44
    	},
    	{
    		text = {'E','r','u','p','t'},
    		time = 46
    	},
    	{
    		text = {'N','e','u','r','o','n'},
    		time = 48
    	}
    },
    {	----ROUND 3
		{
    		text = {'q','S','d','n'},	
    		time = 1
    	},
    	{
    		text = {'w','n','n','l','d'},	
    		time = 5
    	},
    	{
    		text = {'e','N','k','d','l'},	
    		time = 8
    	},
    	{
    		text = {'R','n','d','l','s'},	
    		time = 10
    	},
    	{
    		text = {'t','S','N','Z','x'},
    		time = 11
    	},
    	{
    		text = {'y','N','S','P','Q'},	
    		time = 13
    	},
    	-----
    	{
    		text = {'U','n','d','s','l'},	
    		time = 18
    	},
    	{
    		text = {'i','q','n','a','l','s'},	
    		time = 18
    	},
    	{
    		text = {'p','p','m','z','n','d'},	
    		time = 19
    	},
    	{
    		text = {'n','z','m','S','o'},	
    		time = 22
    	},
    	{
    		text = {'a','n','d','m','s','o'},	
    		time = 25
    	},
    	{
    		text = {'s','n','z','o','u','d'},	
    		time = 27
    	},
    	{
    		text = {'d','z','m','v','n'},	
    		time = 27
    	},
    	{
    		text = {'b','i','z','x','n','s'},	
    		time = 28
    	},
    	{
    		text = {'h','W','k','d','n'},	
    		time = 29
    	},
    	----------
    	{
    		text = {'L','m','j','s'},	
    		time = 34
    	},
    	{
    		text = {'z','n','a','j','d','y'},	
    		time = 37
    	},
    	{
    		text = {'o','q','i','d','u'},	
    		time = 38
    	},
    	{
    		text = {'j','m','z','a','j'},	
    		time = 39
    	},
    	{
    		text = {'m','P','k','d','a','A'},	
    		time = 41
    	},
    	{
    		text = {'v','Y','d','n','s','k'},	
    		time = 43
    	},
    	{
    		text = {'Q','M','N'},	
    		time = 46
    	},
    	{
    		text = {'r','s','L','d','x'},	
    		time = 48
    	},
    	{
    		text = {'k','P','o','d','m'},	
    		time = 50
    	},
    	{
    		text = {'c','q','D','n'},	
    		time = 52
    	},
    	{
    		text = {'f','d','i','o','s','l'},	
    		time = 54
    	}
    }
	};
	--INITIALIZE WORD VARIABLES
	levelWords = {};    --list of words for this level
    activeWords = {}; 	--list of active words onscreen
    currentWord = nil;	--the word being typed
    location = {
    	x = nil;
    	y = nil;
    }
    currentIndex = nil; --the next letter the user needs to typed
    activeIndex = nil; --the index of the current word in activeWord (to keep tabs on the current word's position)
    userWord = nil; 	--the letters of the current word the user has already typed (ex: 'r''a''i'- for 'rainbow') 
    explosions = {};	--list of explosions on screen
    allUsed = true;
    ---INITIALIZE CHARACTER VARIABLES
    power = 300;			--squad power level
    life_knight = 100;
    life_witch = 100; 
    life_priest = 100;
    animationOver = false;
    heal = false;
    heal_end = love.timer.getTime();
    shield = false;
    shield_end = love.timer.getTime();
	blast = false;
    blast_end = love.timer.getTime();
    ---INITIALIZE GAME VARIABLES
    gamestate = 'splash';
	mistakes = 0;		--# mistakes made (this round)
    combos = 0;			--# correct words in a row (this round)
    bestCombo = 0;
    perfect = true;
    completed = 0;
    score = 0;
    round = 1;			--what round user is on
    roundReady = 1;
    roundTime = 0;
    finalSound = true;
end
----------------------------------
--function: explode
--:: creates an explosion animation at target location
----------------------------------
function explode(inX, inY) -- adds a location for an explosion
	splode = explosion;
	la.play(sound_explode);
	exp = {
		x = inX;
		y = inY;
		anim = newAnimation(explosion, 64, 64, .1, 0);
	}
	table.insert(explosions, exp);
end
----------------------------------
--function: alphaNum
--:: identifies acceptable keyboard inputs
----------------------------------
function alphaNum(key)
	if (key == '1' or key == '2' or key == '3' or key == '4' or key == '5' or key == '6' or key == '7' or key == '8' or key == '9' or key == '0' or key == '-' or key == '=') then
		return true;
	elseif (key == 'q' or key == 'w' or key == 'e' or key == 'r' or key == 't' or key == 'y' or key == 'u' or key == 'i' or key == 'o' or key == 'p' or key == '[' or key == ']') then
		return true;
	elseif (key == 'a' or key == 's' or key == 'd' or key == 'f' or key == 'g' or key == 'h' or key == 'j' or key == 'k' or key == 'l' or key == ';' or key == '\'') then
		return true;
	elseif (key == 'z' or key == 'x' or key == 'c' or key == 'v' or key == 'b' or key == 'n' or key == 'm' or key == ',' or key == '.' or key == '/') then
		return true;
	elseif (key == '!' or key == '@' or key == '#' or key == '$' or key == '%' or key == '^' or key == '&' or key == '*' or key == '(' or key == ')' or key == '_' or key == '+') then
		return true;
	elseif (key == 'R' or key == 'T' or key == 'Y' or key == 'U' or key == 'I' or key == 'O' or key == 'P' or key == '{' or key == '}') then
		return true;
	elseif (key == 'A' or key == 'S' or key == 'D' or key == 'F' or key == 'G' or key == 'H' or key == 'J' or key == 'K' or key == 'L' or key == ':' or key == '\"') then
		return true;
	elseif (key == 'Z' or key == 'X' or key == 'C' or key == 'V' or key == 'B' or key == 'N' or key == 'M' or key == '<' or key == '>' or key == '?') then
		return true;
	end
	return false;

end