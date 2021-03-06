View.Set ("graphics:280;300,nobuttonbar")

Mouse.ButtonChoose ("multibutton")

var x, y, button, Gridx, Gridy : int
var font : int := Font.New ("system:16")
var stringNum : string
var lost : boolean := false

var column, row, numColour : int
var maxBomb : int := 0

%Initializing mineSweep array
var mineSweep : array - 1 .. 9, -1 .. 9 of int
for initC : 0 .. 8
    for initR : 0 .. 8
	mineSweep (initC, initR) := -1
    end for
end for
for outColumn : -1 .. 9
    mineSweep (outColumn, -1) := -10
    mineSweep (outColumn, 9) := -10
end for
for outRow : -1 .. 9
    mineSweep (-1, outRow) := -10
    mineSweep (9, outRow) := -10
end for

var buttonUnpressed : int := Pic.FileNew ('ButtonUnpressed.bmp')
var buttonPressed : int := Pic.FileNew ('ButtonPressed.bmp')
var buttonBomb : int := Pic.FileNew ('ButtonBomb.bmp')
var buttonFlag : int := Pic.FileNew ('ButtonFlagged.bmp')
var buttonQuestion : int := Pic.FileNew ('ButtonQuestion.bmp')
var buttonBomb2 : int := Pic.FileNew ('ButtonBomb2.bmp')

%procedure CheckOne (oneColumn, oneRow: int)
%if mineSweep (oneColumn, oneRow) not= 10 then
%    mineSweep (oneColumn, oneRow) := 0

%    for c : oneColumn - 1 .. oneColumn + 1
%        for r : oneRow - 1 .. oneRow + 1
	
%            column := c
%            row := r

%            if mineSweep (c, r) = 10 then
%                mineSweep (oneColumn, oneRow) := mineSweep (oneColumn, oneRow) + 1
%            end if

%        end for
%    end for
%    end if
%end CheckOne

procedure ClickLetGo

    loop

	Mouse.Where (x, y, button)
	exit when button = 0

    end loop

end ClickLetGo

procedure BombLocation

    loop

	column := Rand.Int (0, 8)
	row := Rand.Int (0, 8)

	if mineSweep (column, row) = -1 then

	    mineSweep (column, row) := 9
	    maxBomb := maxBomb + 1

	end if

	exit when maxBomb = 10

    end loop

end BombLocation

procedure NumberValues
    for a : 0 .. 8
	for b : 0 .. 8
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



procedure DrawGrid

    for a : 0 .. 8

	for b : 0 .. 8
	    Gridy := a * 30 + 5
	    Gridx := b * 30 + 5
	    Pic.Draw (buttonUnpressed, b * 30 + 5, a * 30 + 5, picMerge)
	    Draw.Box (Gridx, Gridy, Gridx + 30, Gridy + 30, white)
	end for

    end for

end DrawGrid

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

procedure Chain0 (column0, row0, depth : int)

    for c : column0 - 1 .. column0 + 1
	for r : row0 - 1 .. row0 + 1

	    column := c
	    row := r

	    if mineSweep (c, r) = 0 then

		Pic.Draw (buttonPressed, r * 30 + 5, c * 30 + 5, picMerge)

		mineSweep (column, row) := -1
		Chain0 (column, row, depth)

	    elsif mineSweep (c, r) > 0 then

		Pic.Draw (buttonPressed, r * 30 + 5, c * 30 + 5, picMerge)
		NumberBombs (column, row)

	    end if
	    var currentDepth := depth - 1

	    if depth > 1 then
		Chain0 (column, row, currentDepth)
	    end if
	end for
    end for

end Chain0

procedure CheckGrid
    for a : 0 .. 8

	for b : 0 .. 8
	    Gridy := a * 30 + 5
	    Gridx := b * 30 + 5

	    column := a
	    row := b

	    if ((button not= 0) & (x > Gridx & x < Gridx + 30) & (y > Gridy & y < Gridy + 30)) then

		if (button = 1) & mineSweep(column, row) < 10 then

		    if (mineSweep (column, row) = 0) then

			Chain0 (column, row, 1)

		    elsif (mineSweep (column, row) not= 9) then

			Pic.Draw (buttonPressed, b * 30 + 5, a * 30 + 5, picMerge)
			NumberBombs (column, row)

		    elsif (mineSweep (column, row) = 9) then
		    
			for aLost : 0..8
			    for bLost : 0..8
			    
				if mineSweep (aLost, bLost) = 9 then
			
				Pic.Draw(buttonBomb2, bLost * 30 + 5, aLost * 30 + 5, picMerge)
				lost := true
				
				end if
				Pic.Draw(buttonBomb, b * 30 + 5, a * 30 + 5, picMerge)
			    end for
			end for
			
		    end if
		    
		elsif (button = 1) & mineSweep(column, row) > 10 & mineSweep(column, row) < 20 then
		    mineSweep(column, row) := mineSweep (column, row) + 10
		    Pic.Draw(buttonQuestion, b * 30 + 5, a * 30 + 5, picMerge)
		    
		elsif (button = 1) & mineSweep(column, row) > 20 then
		
		    mineSweep(column, row) := mineSweep (column, row) - 10
		    Pic.Draw(buttonFlag, b * 30 + 5, a * 30 + 5, picMerge)
		    
		elsif (button = 100) & mineSweep(column, row) < 10 then
		
		    mineSweep(column, row) := mineSweep(column, row) + 10
		    Pic.Draw(buttonFlag, b * 30 + 5, a * 30 + 5, picMerge)
		    
		elsif (button = 100) & mineSweep(column, row) > 10 then
		    
		    mineSweep (column, row) := mineSweep (column, row) mod 10
		    Pic.Draw(buttonUnpressed, b * 30 + 5, a * 30 + 5, picMerge)

		end if

		ClickLetGo

	    end if

	end for
    end for
end CheckGrid

DrawGrid

loop
    Mouse.Where (x, y, button)

    if button = 1 then

	for a : 0 .. 8
	    for b : 0 .. 8

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
    CheckGrid

    exit when lost = true

end loop




