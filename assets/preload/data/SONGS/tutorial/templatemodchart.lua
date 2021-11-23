function onCreate() --When the script started

end

function onDestroy() --When the script ended

end

function endSong() --Right when the song ends
	return Function_Continue;
end

function startSong() --Right when the song starts
	
end

function startCountdown() --Right when the countdown starts
	return Function_Continue;
end

function resume() --Right when you resume the game
	
end

function pause() --Right when you pause the game
	return Function_Continue;
end

function gameOver() --Right when you die
	return Function_Continue;
end

function update(elapsed) --Every frame before everything has been updated

end

function updateEnd(elapsed) --Every frame after everything has been updated
	
end

function stepHit() --16 times a section
	
end

function beatHit() --4 times a section
	
end

function noteHit(noteData, noteType) --Right when you hit a note

end

function noteMiss(noteData, noteType, tooLate) --Right when you miss a note

end