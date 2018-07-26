import GUI

View.Set ("graphics:520;550,nobuttonbar,offscreenonly")

Mouse.ButtonChoose ("multibutton")

var x, y, button, Gridx, Gridy : int
var font : int := Font.New ("system:16")
var fontScore : int := Font.New ("system:32")
var fontEnd : int := Font.New ("system:40")

var stringNum : string
var lost, win : boolean := false
var clickedBox : int := 0
var score : int := 40

var column, row, numColour : int
var maxBomb : int := 0

%Initializing mineSweep array
var mineSweep : flexible array - 1 .. 17, -1 .. 17 of int

for outColumn : -1 .. upper (mineSweep)
    mineSweep (outColumn, -1) := -10
    mineSweep (outColumn, upper (mineSweep)) := -10
end for
for outRow : -1 .. upper (mineSweep)
    mineSweep (-1, outRow) := -10
    mineSweep (upper (mineSweep), outRow) := -10
end for

var buttonUnpressed : int := Pic.FileNew ('ButtonUnpressed.bmp')
var buttonPressed : int := Pic.FileNew ('ButtonPressed.bmp')
var buttonBomb : int := Pic.FileNew ('ButtonBomb.bmp')
var buttonFlag : int := Pic.FileNew ('ButtonFlagged.bmp')
var buttonQuestion : int := Pic.FileNew ('ButtonQuestion.bmp')
var buttonBomb2 : int := Pic.FileNew ('ButtonBomb2.bmp')

%Wait for them to let go of mouse button
procedure ClickLetGo

    loop

	Mouse.Where (x, y, button)
	exit when button = 0

    end loop

end ClickLetGo

%Place bombs at beggining
procedure BombLocation

    loop

	column := Rand.Int (0, upper (mineSweep) - 1)
	row := Rand.Int (0, upper (mineSweep) - 1)

	if mineSweep (column, row) = -1 then

	    mineSweep (column, row) := 9
	    maxBomb := maxBomb + 1

	end if

	exit when maxBomb = 40

    end loop

end BombLocation

%Number buttons based on nearby bombs
procedure NumberValues
    for a : 0 .. upper (mineSweep) - 1
	for b : 0 .. upper (mineSweep) - 1
	    if (mineSweep (a, b)) not= 9 then
		mineSweep (a, b) := 0
		for c : (a - 1) .. (a + 1)
		    for r : (b - 1) .. (b + 1)
			if mineSweep (c, r) = 9 then
			    mineSweep (a, b) := mineSweep (a, b) + 1
			end if
		    end for
		end for
	    end if
	end for
    end for
end NumberValues

%Draws all buttons for beggining
procedure DrawGrid

    for a : 0 .. upper (mineSweep) - 1

	for b : 0 .. upper (mineSweep) - 1
	    Gridy := a * 30 + 5
	    Gridx := b * 30 + 5
	    Pic.Draw (buttonUnpressed, b * 30 + 5, a * 30 + 5, picCopy)
	end for

    end for

end DrawGrid

%Display number on button
procedure NumberBombs (var numberC, numberR : int)
    if mineSweep (numberC, numberR) > 0 then

	stringNum := intstr (mineSweep (numberC, numberR))

	if mineSweep (numberC, numberR) = 1 then
	    numColour := 9
	elsif mineSweep (numberC, numberR) = 2 then
	    numColour := 10
	elsif mineSweep (numberC, numberR) = 3 then
	    numColour := 12
	elsif mineSweep (numberC, numberR) = 4 then
	    numColour := 1
	elsif mineSweep (numberC, numberR) = 5 then
	    numColour := 114
	elsif mineSweep (numberC, numberR) = 6 then
	    numColour := 5
	elsif mineSweep (numberC, numberR) = 7 then
	    numColour := 13
	elsif mineSweep (numberC, numberR) = 8 then
	    numColour := 41
	end if
	Font.Draw (stringNum, numberR * 30 + 15, numberC * 30 + 15, font, numColour)

    end if
end NumberBombs

%Clicks all nearby 0s if you click a 0
procedure Chain0 (column0, row0, depth : int)

    for c : column0 - 1 .. column0 + 1
	for r : row0 - 1 .. row0 + 1

	    column := c
	    row := r

	    if mineSweep (c, r) = 0 then

		Pic.Draw (buttonPressed, r * 30 + 5, c * 30 + 5, picCopy)

		mineSweep (column, row) := -1
		Chain0 (column, row, depth)

	    elsif mineSweep (c, r) > 0 then

		Pic.Draw (buttonPressed, r * 30 + 5, c * 30 + 5, picCopy)
		NumberBombs (column, row)
		mineSweep (c, r) := -1

	    end if
	    var currentDepth := depth - 1

	    if depth > 1 then
		Chain0 (column, row, currentDepth)
	    end if
	end for
    end for

end Chain0

%Checks to see where you click and how to respond
procedure CheckGrid
    for a : 0 .. upper (mineSweep) - 1

	for b : 0 .. upper (mineSweep) - 1
	    Gridy := a * 30 + 5
	    Gridx := b * 30 + 5

	    column := a
	    row := b

	    if ((button not= 0) & (x > Gridx & x < Gridx + 30) & (y > Gridy & y < Gridy + 30)) then

		if (button = 1) & mineSweep (column, row) < 10 & mineSweep (column, row) >= 0 then

		    if (mineSweep (column, row) = 0) then

			Chain0 (column, row, 1)

		    elsif (mineSweep (column, row) not= 9) then

			Pic.Draw (buttonPressed, b * 30 + 5, a * 30 + 5, picCopy)
			NumberBombs (column, row)
			mineSweep (column, row) := -1

		    elsif (mineSweep (column, row) = 9) then

			for aLost : 0 .. upper (mineSweep) - 1
			    for bLost : 0 .. upper (mineSweep) - 1

				if mineSweep (aLost, bLost) = 9 then

				    Pic.Draw (buttonBomb2, bLost * 30 + 5, aLost * 30 + 5, picCopy)
				    lost := true

				end if
				Pic.Draw (buttonBomb, b * 30 + 5, a * 30 + 5, picCopy)
			    end for
			end for

		    end if

		elsif (button = 1) & mineSweep (column, row) > 10 & mineSweep (column, row) < 20 then

		    mineSweep (column, row) := mineSweep (column, row) + 10
		    Pic.Draw (buttonQuestion, b * 30 + 5, a * 30 + 5, picCopy)

		elsif (button = 1) & mineSweep (column, row) > 20 then

		    mineSweep (column, row) := mineSweep (column, row) - 10
		    Pic.Draw (buttonFlag, b * 30 + 5, a * 30 + 5, picCopy)

		elsif (button = 100) & mineSweep (column, row) < 10 & mineSweep (column, row) not= -1 then

		    mineSweep (column, row) := mineSweep (column, row) + 10
		    Pic.Draw (buttonFlag, b * 30 + 5, a * 30 + 5, picCopy)
		    score := score - 1

		elsif (button = 100) & mineSweep (column, row) > 10 then

		    mineSweep (column, row) := mineSweep (column, row) mod 10
		    Pic.Draw (buttonUnpressed, b * 30 + 5, a * 30 + 5, picCopy)
		    score := score + 1

		end if

		ClickLetGo

	    end if

	end for
    end for
end CheckGrid

%Finds out if you won the game
procedure CheckWin

    for a : 0 .. upper (mineSweep) - 1
	for b : 0 .. upper (mineSweep) - 1

	    if mineSweep (a, b) = -1 then
		clickedBox := clickedBox + 1
	    end if

	end for
    end for

    if clickedBox = 216 then
	win := true
    end if

    clickedBox := 0
end CheckWin

%Beggining program (makes first click always a 0) and main loop
procedure MineSweeper
    % Initialize grid
    for a : 0 .. upper (mineSweep) - 1
	for b : 0 .. upper (mineSweep) - 1
	    mineSweep (a, b) := -1
	end for
    end for

    cls
    %Initialize values
    DrawGrid
    GUI.Refresh
    win := false
    lost := false
    maxBomb := 0
    score := 40

    View.Update
    % Make where you click always be 0
    loop
	Mouse.Where (x, y, button)

	if button = 1 then

	    for a : 0 .. upper (mineSweep) - 1
		for b : 0 .. upper (mineSweep) - 1

		    Gridy := a * 30 + 5
		    Gridx := b * 30 + 5



		    if (x > Gridx & x < Gridx + 30) & (y > Gridy & y < Gridy + 30) then

			for c : a - 1 .. a + 1
			    for r : b - 1 .. b + 1

				column := c
				row := r

				mineSweep (column, row) := 0

			    end for
			end for

		    end if

		end for
	    end for

	    BombLocation
	    NumberValues

	    CheckGrid

	    ClickLetGo

	    exit

	end if
    end loop

    loop

	Mouse.Where (x, y, button)
	if win = false & lost = false then
	    CheckGrid
	    CheckWin
	end if

	if win = true then
	    Font.Draw ("You Win!", maxx div 2 - 125, maxy div 2, fontEnd, black)
	elsif lost = true then
	    Font.Draw ("You Lose!", maxx div 2 - 125, maxy div 2, fontEnd, black)
	end if

	Draw.FillBox (30, 520, 100, 560, white)
	Font.Draw (intstr (score), 30, 520, fontScore, 12)

	View.Update
	var restartButton : int := GUI.CreateButtonFull (230, maxy - 25, 5, "Restart", MineSweeper, 5, "r", true)

	exit when GUI.ProcessEvent

    end loop

end MineSweeper
delay (1000)

MineSweeper

