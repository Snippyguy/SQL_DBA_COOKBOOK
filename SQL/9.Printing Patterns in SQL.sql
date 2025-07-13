/***************************************************************************************************************************************
Code Description	 : Printing Patterns in SQL														                                   *
Author Name		     : Sayan Dey					  																				   *
Company Name		 : Snippyguy																									   *
Website		         : www.snippyguy.com																							   *
License			     : MIT, CC0																										   *
Creation Date		 : 22/11/2024																									   *
Last Modified By 	 : 22/11/2024																									   *
Last Modification	 : Initial Creation  																							   *
Modification History : 	 																											   *
***************************************************************************************************************************************/

/***************************************************************************************************************************************
*                                                Copyright (C) 2024 Sayan Dey														   *
*                                                All rights reserved. 																   *
* 																																	   *
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files     *
* (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge,  *
* publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do   *
* so, subject to the following conditions:																							   *
*																																	   *
*																																	   *
* You may alter this code for your own * Commercial* & *non-commercial* purposes. 													   *
* You may republish altered code as long as you include this copyright and give due credit. 										   *
* 																																	   *
* 																																	   *
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.	   *
*																																	   *
*																																	   *
* THE SOFTWARE (CODE AND INFORMATION) IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED *
* TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 		   *
* COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING  *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.										   *
*																																	   *
* 																																	   *
***************************************************************************************************************************************/

-- 1)Right Half Pyramid:

-- Declare variables for user inputs
DECLARE @Character	NVARCHAR(1); -- Character to print (e.g., *, A, 1)
DECLARE @Lines		INT;		 -- Number of lines to print. You can think Line as Height of the Pyramid.
DECLARE @Row		INT = 1;	 -- Current row counter

-- Simulate user inputs
SET @Character = '*'; -- Replace with desired character (e.g., *, A, 1)
SET @Lines	   = 5;   -- Replace with desired number of lines or height

-- Validate inputs
IF @Lines <= 0
BEGIN
    PRINT 'Number of lines must be greater than 0.';
    RETURN;
END;

-- Generate the pattern
WHILE @Row <= @Lines
BEGIN
    -- Create and print the pattern for the current row
    PRINT REPLICATE(' ', @Lines - @Row) --Adds spaces to align the pattern to the right.
		+ REPLICATE(@Character, @Row);  --Generates the characters for the current row.
    SET @Row = @Row + 1;                --Increment the row counter.
END;

/*****OUTPUT************
    1|       *|       A*
   11|      **|      AA*
  111|     ***|     AAA*
 1111|    ****|    AAAA*
11111|   *****|   AAAAA*
***********************/

-- 2)Hollow Right Half Pyramid:

-- Declare variables for user inputs
DECLARE @Character NVARCHAR(1);   -- Character to print (e.g., *, A, 1)
DECLARE @Size INT;                -- Size of the pyramid (number of rows)
DECLARE @Row INT;                 -- Current row counter
DECLARE @Col INT;                 -- Current column counter
DECLARE @Line NVARCHAR(MAX);      -- Line variable for each row output

-- Simulate user inputs
SET @Character = '*';  -- Replace with desired character (e.g., *, A, 1)
SET @Size = 5;         -- Replace with the desired size of the pyramid

-- Validate inputs
IF @Size <= 0
BEGIN
    PRINT 'Size must be greater than 0.';
    RETURN;
END;

-- Generate the Hollow Right Half Pyramid
SET @Row = 1;  -- Start from the first row

WHILE @Row <= @Size
BEGIN
    SET @Line = '';  -- Initialize the line variable for the current row

    -- Add leading spaces
    SET @Col = 1;
    WHILE @Col <= (@Size - @Row)
    BEGIN
        SET @Line = @Line + ' ';  -- Add space
        SET @Col = @Col + 1;
    END;

    -- Add stars and hollow spaces
    SET @Col = 1;
    WHILE @Col <= @Row
    BEGIN
        -- Fill the boundary (first column or last column in each row)
        IF @Col = 1 OR @Col = @Row OR @Row = @Size
        BEGIN
            SET @Line = @Line + @Character;  -- Add character for boundary
        END
        ELSE
        BEGIN
            SET @Line = @Line + ' ';  -- Add space for hollow part
        END;
        SET @Col = @Col + 1;  -- Move to the next column
    END;

    PRINT @Line;  -- Print the complete line for the current row
    SET @Row = @Row + 1;  -- Move to the next row
END;

/*****OUTPUT************
    1|       *|       A*
   11|      **|      AA*
  1 1|     * *|     A A*
 1  1|    *  *|    A  A*
11111|   *****|   AAAAA*
***********************/

-- 3)Inverted Right Half Pyramid:

-- Declare variables for user inputs
DECLARE @Character	NVARCHAR(1); -- Character to print (e.g., *, A, 1)
DECLARE @Lines		INT;         -- Number of lines to print. You can think Line as Height of the Pyramid.
DECLARE @Row		INT;         -- Current row counter

-- Simulate user inputs
SET @Character	= '*';     -- Replace with desired character (e.g., *, A, 1)
SET @Lines		= 5;       -- Replace with desired number of lines or height
SET @Row		= @Lines;  -- Start from the maximum number of lines

-- Validate inputs
IF @Lines <= 0
BEGIN
    PRINT 'Number of lines must be greater than 0.';
    RETURN;
END;

-- Generate the pattern
WHILE @Row > 0
BEGIN
    -- Create spaces for alignment and the stars for the current row
    PRINT REPLICATE(' ', @Lines - @Row) --adds spaces for alignment to right
		+ REPLICATE(@Character, @Row);  --generates the characters for the current row.
    SET @Row = @Row - 1; -- Decrement the row counter
END;

/*****OUTPUT**********
11111|	*****|	AAAAA*
 1111|	 ****|	 AAAA*
  111|	  ***|	  AAA*
   11|	   **|	   AA*
    1|	    *|	    A*
*********************/

-- 4)Hollow Inverted Right Half Pyramid:

-- Declare variables for user inputs
DECLARE @Character NVARCHAR(1);   -- Character to print (e.g., *, A, 1)
DECLARE @Size INT;                -- Size of the pyramid (number of rows)
DECLARE @Row INT;                 -- Current row counter
DECLARE @Col INT;                 -- Current column counter
DECLARE @Line NVARCHAR(MAX);      -- Line variable for each row output

-- Simulate user inputs
SET @Character = '*';  -- Replace with desired character (e.g., *, A, 1)
SET @Size = 5;         -- Replace with the desired size of the pyramid

-- Validate inputs
IF @Size <= 0
BEGIN
    PRINT 'Size must be greater than 0.';
    RETURN;
END;

-- Generate the Hollow Inverted Right Half Pyramid
SET @Row = @Size;  -- Start from the widest row

WHILE @Row > 0
BEGIN
    SET @Line = '';  -- Initialize the line variable for the current row

    -- Add leading spaces
    SET @Col = 1;
    WHILE @Col <= (@Size - @Row)
    BEGIN
        SET @Line = @Line + ' ';  -- Add space
        SET @Col = @Col + 1;
    END;

    -- Add stars and hollow spaces
    SET @Col = 1;
    WHILE @Col <= @Row
    BEGIN
        -- Fill the boundary (first column or last column in each row)
        IF @Col = 1 OR @Col = @Row OR @Row = @Size
        BEGIN
            SET @Line = @Line + @Character;  -- Add character for boundary
        END
        ELSE
        BEGIN
            SET @Line = @Line + ' ';  -- Add space for hollow part
        END;
        SET @Col = @Col + 1;  -- Move to the next column
    END;

    PRINT @Line;  -- Print the complete line for the current row
    SET @Row = @Row - 1;  -- Move to the previous row
END;

/*****OUTPUT**********
11111|	*****|	AAAAA*
 1  1|	 *  *|	 A  A*
  1 1|	  * *|	  A A*
   11|	   **|	   AA*
    1|	    *|	    A*
*********************/

-- 5)Left Half Pyramid:

-- Declare variables for user inputs
DECLARE @Character	NVARCHAR(1); -- Character to print (e.g., *, A, 1)
DECLARE @Lines		INT;		 -- Number of lines to print. You can think Line as Height of the Pyramid.
DECLARE @Row		INT = 1;	 -- Current row counter

-- Simulate user inputs
SET @Character = 'A'; -- Replace with desired character (e.g., *, A, 1)
SET @Lines	   = 5;   -- Replace with desired number of lines or height

-- Validate inputs
IF @Lines <= 0
BEGIN
    PRINT 'Number of lines must be greater than 0.';
    RETURN;
END;

-- Generate the pattern
WHILE @Row <= @Lines
BEGIN
    -- Create and print the pattern for the current row
    PRINT REPLICATE(@Character, @Row);  --Generates the characters for the current row.
    SET @Row = @Row + 1;                --Increment the row counter.
END;

/*****OUTPUT************
1      |*      |A	   *
11     |**     |AA	   *
111    |***    |AAA    *
1111   |****   |AAAA   *
11111  |*****  |AAAAA  *
***********************/

-- 6)Hollow Left Half Pyramid:

-- Declare variables for user inputs
DECLARE @Character NVARCHAR(1);   -- Character to print (e.g., *, A, 1)
DECLARE @Size INT;                -- Size of the pyramid (number of rows)
DECLARE @Row INT;                 -- Current row counter
DECLARE @Col INT;                 -- Current column counter
DECLARE @Line NVARCHAR(MAX);      -- Line variable for each row output

-- Simulate user inputs
SET @Character = '*';  -- Replace with desired character (e.g., *, A, 1)
SET @Size = 5;         -- Replace with the desired size of the pyramid

-- Validate inputs
IF @Size <= 0
BEGIN
    PRINT 'Size must be greater than 0.';
    RETURN;
END;

-- Generate the Hollow Left Half Pyramid
SET @Row = 1;  -- Start from the first row

WHILE @Row <= @Size
BEGIN
    SET @Line = '';  -- Initialize the line variable for the current row

    SET @Col = 1;
    WHILE @Col <= @Row
    BEGIN
        -- Fill the boundary (first row, last row, or first/last column in each row)
        IF @Col = 1 OR @Col = @Row OR @Row = @Size
        BEGIN
            SET @Line = @Line + @Character;  -- Add character for boundary
        END
        ELSE
        BEGIN
            SET @Line = @Line + ' ';  -- Add space for hollow part
        END;
        SET @Col = @Col + 1;  -- Move to the next column
    END;

    PRINT @Line;  -- Print the complete line for the current row
    SET @Row = @Row + 1;  -- Move to the next row
END;

/*****OUTPUT************
1      |*      |A	   *
11     |**     |AA	   *
1 1    |* *    |A A    *
1  1   |*  *   |A  A   *
11111  |*****  |AAAAA  *
***********************/

-- 7)Inverted Left Half Pyramid:

-- Declare variables for user inputs
DECLARE @Character	NVARCHAR(1); -- Character to print (e.g., *, A, 1)
DECLARE @Lines		INT;         -- Number of lines to print. You can think Line as Height of the Pyramid.
DECLARE @Row		INT;         -- Current row counter

-- Simulate user inputs
SET @Character	= '*';     -- Replace with desired character (e.g., *, A, 1)
SET @Lines		= 5;       -- Replace with desired number of lines or height
SET @Row		= @Lines;  -- Start from the maximum number of lines

-- Validate inputs
IF @Lines <= 0
BEGIN
    PRINT 'Number of lines must be greater than 0.';
    RETURN;
END;

-- Generate the pattern
WHILE @Row > 0
BEGIN
    -- Create spaces for alignment and the stars for the current row
    PRINT REPLICATE(@Character, @Row);  --generates the characters for the current row.
    SET @Row = @Row - 1; -- Decrement the row counter
END;

/*******OUTPUT***********
11111	|*****	|AAAAA	*
1111	|****	|AAAA	*
111		|***	|AAA	*
11		|**		|AA		*
1		|*		|A		*
************************/

-- 8)Hollow Inverted Left Half Pyramid:

-- Declare variables for user inputs
DECLARE @Character NVARCHAR(1);   -- Character to print (e.g., *, A, 1)
DECLARE @Size INT;                -- Size of the pyramid (number of rows)
DECLARE @Row INT;                 -- Current row counter
DECLARE @Col INT;                 -- Current column counter
DECLARE @Line NVARCHAR(MAX);      -- Line variable for each row output

-- Simulate user inputs
SET @Character = '*';  -- Replace with desired character (e.g., *, A, 1)
SET @Size = 5;         -- Replace with the desired size of the pyramid

-- Validate inputs
IF @Size <= 0
BEGIN
    PRINT 'Size must be greater than 0.';
    RETURN;
END;

-- Generate the Hollow Inverted Left Half Pyramid
SET @Row = @Size;  -- Start from the widest row

WHILE @Row > 0
BEGIN
    SET @Line = '';  -- Initialize the line variable for the current row

    -- Add stars and hollow spaces
    SET @Col = 1;
    WHILE @Col <= @Row
    BEGIN
        -- Fill the boundary (first column or last column in each row)
        IF @Col = 1 OR @Col = @Row OR @Row = @Size
        BEGIN
            SET @Line = @Line + @Character;  -- Add character for boundary
        END
        ELSE
        BEGIN
            SET @Line = @Line + ' ';  -- Add space for hollow part
        END;
        SET @Col = @Col + 1;  -- Move to the next column
    END;

    PRINT @Line;  -- Print the complete line for the current row
    SET @Row = @Row - 1;  -- Move to the previous row
END;

/*******OUTPUT***********
11111	|*****	|AAAAA	*
1  1	|*  *	|A  A	*
1 1		|* *	|A A	*
11		|**		|AA		*
1		|*		|A		*
************************/

-- 9)Full Pyramid:

-- Declare variables for user inputs
DECLARE @Character	NVARCHAR(1); -- Character to print (e.g., *, A, 1)
DECLARE @Lines		INT;		 -- Number of lines to print. You can think Line as Height of the Pyramid.
DECLARE @Row		INT = 1;	 -- Current row counter

-- Simulate user inputs
SET @Character = '*'; -- Replace with desired character (e.g., *, A, 1)
SET @Lines	   = 5;   -- Replace with desired number of lines or height

-- Validate inputs
IF @Lines <= 0
BEGIN
    PRINT 'Number of lines must be greater than 0.';
    RETURN;
END;

-- Generate the pattern
WHILE @Row <= @Lines
BEGIN
    -- Create and print the pattern for the current row
    PRINT REPLICATE(' ', @Lines - @Row)    --Adds leading spaces to align the pattern to the center.
		+ REPLICATE('*', (2 * @Row) - 1);  --Generates the characters for the current row.

    /*Or you can use below syntax as well
	PRINT SPACE(@Lines - @Row)					  --Adds leading spaces to align the pattern to the center. 
		+ REPLICATE(@Character, (2 * @Row) - 1);  --Generates the characters for the current row.*/

    SET @Row = @Row + 1;                   --Increment the row counter.
END;

/***********OUTPUT************
    1    |    *    |    A	 *
   111   |   ***   |   AAA	 *
  11111  |  *****  |  AAAAA  *
 1111111 | ******* | AAAAAAA *
111111111|*********|AAAAAAAAA*
*****************************/

--10) Hollow Full Triangle in T-SQL:

-- Declare variables for user inputs
DECLARE @Character NVARCHAR(1);   -- Character to print (e.g., *, A, 1)
DECLARE @Size INT;                 -- Size of the triangle (number of rows)
DECLARE @Row INT;                  -- Current row counter
DECLARE @Col INT;                  -- Current column counter
DECLARE @Space INT;                -- Space before the character in each row

-- Simulate user inputs
SET @Character = '*';  -- Replace with desired character (e.g., *, A, 1)
SET @Size = 5;         -- Replace with desired size of the triangle

-- Validate inputs
IF @Size <= 0
BEGIN
    PRINT 'Size must be greater than 0.';
    RETURN;
END;

-- Generate the hollow triangle pattern
SET @Row = 1;  -- Start from the first row

WHILE @Row <= @Size
BEGIN
    SET @Col = 1; -- Start from the first column for each row
    SET @Space = @Size - @Row; -- Calculate spaces before the characters in each row
    DECLARE @Line NVARCHAR(MAX) = '';  -- Initialize the line variable

    -- Add spaces before the characters
    WHILE @Col <= @Space
    BEGIN
        SET @Line = @Line + ' ';  -- Add space
        SET @Col = @Col + 1;
    END;

    -- Add the boundary characters and hollow space in the middle
    SET @Col = 1; -- Reset column counter for the triangle boundary logic
    WHILE @Col <= (2 * @Row - 1)
    BEGIN
        IF @Col = 1 OR @Col = (2 * @Row - 1) OR @Row = @Size
        BEGIN
            SET @Line = @Line + @Character;  -- Add character to the boundary
        END
        ELSE
        BEGIN
            SET @Line = @Line + ' ';  -- Add space for the hollow part
        END
        SET @Col = @Col + 1;  -- Move to the next column
    END;

    PRINT @Line;  -- Print the complete line for the current row
    SET @Row = @Row + 1;  -- Move to the next row
END;

/*********OUTPUT**********
		    *
		   * *
		  *   *
		 *     *
		*********
*************************/

-- 11)Inverted Full Pyramid:

-- Declare variables for user inputs
DECLARE @Character	NVARCHAR(1); -- Character to print (e.g., *, A, 1)
DECLARE @Lines		INT;         -- Number of lines to print. You can think Line as Height of the Pyramid.
DECLARE @Row		INT;         -- Current row counter

-- Simulate user inputs
SET @Character	= '*';     -- Replace with desired character (e.g., *, A, 1)
SET @Lines		= 5;       -- Replace with desired number of lines or height
SET @Row		= @Lines;  -- Start from the maximum number of lines

-- Validate inputs
IF @Lines <= 0
BEGIN
    PRINT 'Number of lines must be greater than 0.';
    RETURN;
END;

-- Generate the pattern
WHILE @Row > 0
BEGIN
    -- Create spaces for alignment and the stars for the current row
    PRINT REPLICATE(' ', @Lines - @Row)           --adds spaces for alignment to Center
		+ REPLICATE(@Character, (2 * @Row) - 1);  --generates the characters for the current row.
    SET @Row = @Row - 1; -- Decrement the row counter
END;

/**********OUTPUT*************
111111111|*********|AAAAAAAAA*
 1111111 | ******* | AAAAAAA *
  11111	 |	*****  |  AAAAA	 *
   111	 |	 ***   |   AAA	 *
    1	 |	  *	   |    A	 *
*****************************/

--12) Hollow Inverted Full Triangle in T-SQL:

-- Declare variables for user inputs
DECLARE @Character NVARCHAR(1);   -- Character to print (e.g., *, A, 1)
DECLARE @Size INT;                 -- Size of the triangle (number of rows)
DECLARE @Row INT;                  -- Current row counter
DECLARE @Col INT;                  -- Current column counter

-- Simulate user inputs
SET @Character = '*';  -- Replace with desired character (e.g., *, A, 1)
SET @Size = 5;         -- Replace with desired size of the triangle

-- Validate inputs
IF @Size <= 0
BEGIN
    PRINT 'Size must be greater than 0.';
    RETURN;
END;

-- Generate the hollow inverted full triangle pattern
SET @Row = 0;  -- Start from the first row (row index starts from 0)

WHILE @Row < @Size
BEGIN
    DECLARE @Line NVARCHAR(MAX) = '';  -- Initialize the line variable
    SET @Col = 1;  -- Start from the first column for each row

    -- Add leading spaces to align the triangle
    WHILE @Col <= @Row
    BEGIN
        SET @Line = @Line + ' ';  -- Add space
        SET @Col = @Col + 1;
    END;

    -- Add stars and spaces for the hollow triangle
    SET @Col = 1;  -- Reset column counter for stars
    WHILE @Col <= (2 * (@Size - @Row) - 1)
    BEGIN
        -- Fill the boundary (first and last character of the row, or the top row)
        IF @Col = 1 OR @Col = (2 * (@Size - @Row) - 1) OR @Row = 0
        BEGIN
            SET @Line = @Line + @Character;  -- Add character to the boundary
        END
        ELSE
        BEGIN
            SET @Line = @Line + ' ';  -- Add space for the hollow part
        END
        SET @Col = @Col + 1;  -- Move to the next column
    END;

    PRINT @Line;  -- Print the complete line for the current row
    SET @Row = @Row + 1;  -- Move to the next row
END;

/*********OUTPUT**********
		*********
		 *     *
		  *   *
		   * *
		    *
*************************/

-- 13)Diamond Pattern in T-SQL:

-- Declare variables for user inputs
DECLARE @Character	NVARCHAR(1); -- Character to print (e.g., *, A, 1)
DECLARE @Lines		INT;         -- Number of lines for the upper half of the Diamond
DECLARE @Row		INT;         -- Current row counter

-- Simulate user inputs
SET @Character = '*'; -- Replace with desired character (e.g., *, A, 1)
SET @Lines     = 5;   -- Replace with desired number of lines for the upper half of the Diamond
SET @Row       = 1;   -- Start with the first row

-- Validate inputs
IF @Lines <= 0
BEGIN
    PRINT 'Number of lines must be greater than 0.';
    RETURN;
END;

-- Upper half of the Diamond
WHILE @Row <= @Lines
BEGIN
    PRINT SPACE(@Lines - @Row) + REPLICATE(@Character, (2 * @Row) - 1);
    SET @Row = @Row + 1; -- Move to the next row
END;

-- Lower half of the Diamond
SET @Row = @Lines - 1; -- Start from the row just before the last row

WHILE @Row > 0
BEGIN
    PRINT SPACE(@Lines - @Row) + REPLICATE(@Character, (2 * @Row) - 1);
    SET @Row = @Row - 1; -- Move to the next row
END;

/********OUTPUT***********
		    *
		   ***
		  *****
		 *******
		*********
		 *******
		  *****
		   ***
		    *
*************************/

-- 14) Hollow Diamond Pattern in T-SQL:

-- Declare variables for user inputs
DECLARE @Character NVARCHAR(1);   -- Character to print (e.g., *, A, 1)
DECLARE @Size INT;                -- Size of the diamond (half the height)
DECLARE @Row INT;                 -- Current row counter
DECLARE @Col INT;                 -- Current column counter
DECLARE @Line NVARCHAR(MAX);      -- Line variable for each row output

-- Simulate user inputs
SET @Character = '*';  -- Replace with desired character (e.g., *, A, 1)
SET @Size = 5;         -- Replace with the desired size of the diamond

-- Validate inputs
IF @Size <= 0
BEGIN
    PRINT 'Size must be greater than 0.';
    RETURN;
END;

-- Generate the top half of the hollow diamond
SET @Row = 1;  -- Start from the first row

WHILE @Row <= @Size
BEGIN
    SET @Line = '';  -- Initialize the line variable for the current row

    -- Add leading spaces
    SET @Col = 1;
    WHILE @Col <= (@Size - @Row)
    BEGIN
        SET @Line = @Line + ' ';  -- Add space
        SET @Col = @Col + 1;
    END;

    -- Add stars and hollow spaces
    SET @Col = 1;
    WHILE @Col <= (2 * @Row - 1)
    BEGIN
        -- Fill the boundary (first and last column in each row)
        IF @Col = 1 OR @Col = (2 * @Row - 1)
        BEGIN
            SET @Line = @Line + @Character;  -- Add star at the boundary
        END
        ELSE
        BEGIN
            SET @Line = @Line + ' ';  -- Add space for hollow part
        END;
        SET @Col = @Col + 1;
    END;

    PRINT @Line;  -- Print the complete line for the current row
    SET @Row = @Row + 1;  -- Move to the next row
END;

-- Generate the bottom half of the hollow diamond
SET @Row = @Size - 1;  -- Start from the second-to-last row

WHILE @Row > 0
BEGIN
    SET @Line = '';  -- Initialize the line variable for the current row

    -- Add leading spaces
    SET @Col = 1;
    WHILE @Col <= (@Size - @Row)
    BEGIN
        SET @Line = @Line + ' ';  -- Add space
        SET @Col = @Col + 1;
    END;

    -- Add stars and hollow spaces
    SET @Col = 1;
    WHILE @Col <= (2 * @Row - 1)
    BEGIN
        -- Fill the boundary (first and last column in each row)
        IF @Col = 1 OR @Col = (2 * @Row - 1)
        BEGIN
            SET @Line = @Line + @Character;  -- Add star at the boundary
        END
        ELSE
        BEGIN
            SET @Line = @Line + ' ';  -- Add space for hollow part
        END;
        SET @Col = @Col + 1;
    END;

    PRINT @Line;  -- Print the complete line for the current row
    SET @Row = @Row - 1;  -- Move to the previous row
END;

/********OUTPUT***********
		    *
		   * *
		  *   *
		 *     *
		*       *
		 *     *
		  *   *
		   * *
		    *
*************************/
-- 15) Square Pattern in T-SQL:

-- Declare variables for user inputs
DECLARE @Character NVARCHAR(1); -- Character to print (e.g., *, A, 1)
DECLARE @Size	   INT;         -- Size of the square (number of rows and columns)
DECLARE @Row	   INT;         -- Current row counter
DECLARE @Col	   INT;         -- Current column counter

-- Simulate user inputs
SET @Character = 'A'; -- Replace with desired character (e.g., *, A, 1)
SET @Size      = 5;   -- Replace with desired size of the square

-- Validate inputs
IF @Size <= 0
BEGIN
    PRINT 'Size must be greater than 0.';
    RETURN;
END;

-- Generate the square pattern
SET @Row = 1; -- Start from the first row

WHILE @Row <= @Size
BEGIN
    SET @Col = 1; -- Start from the first column for each row
    DECLARE @Line NVARCHAR(MAX) = ''; -- Initialize the line variable

    WHILE @Col <= @Size
    BEGIN
        SET @Line = @Line + @Character; -- Add character to the current line
        SET @Col = @Col + 1; -- Move to the next column
    END;

    PRINT @Line; -- Print the complete line for the current row
    SET @Row = @Row + 1; -- Move to the next row
END;

/*********OUTPUT**********
          *****
          *****
          *****
          *****
          *****
*************************/

-- 16) Hollow Square Pattern in T-SQL:

-- Declare variables for user inputs
DECLARE @Character	NVARCHAR(1); -- Character to print (e.g., *, A, 1)
DECLARE @Size		INT;         -- Size of the square (number of rows and columns)
DECLARE @Row		INT;         -- Current row counter
DECLARE @Col		INT;         -- Current column counter

-- Simulate user inputs
SET @Character = '*'; -- Replace with desired character (e.g., *, A, 1)
SET @Size      = 5;   -- Replace with desired size of the square

-- Validate inputs
IF @Size <= 0
BEGIN
    PRINT 'Size must be greater than 0.';
    RETURN;
END;

-- Generate the hollow square pattern
SET @Row = 1; -- Start from the first row

WHILE @Row <= @Size
BEGIN
    SET @Col = 1; -- Start from the first column for each row
    DECLARE @Line NVARCHAR(MAX) = ''; -- Initialize the line variable

    WHILE @Col <= @Size
    BEGIN
        -- Print the character at the boundary (first and last row, first and last column)
        IF @Row = 1 OR @Row = @Size OR @Col = 1 OR @Col = @Size
        BEGIN
            SET @Line = @Line + @Character; -- Add character to the current line
        END
        ELSE
        BEGIN
            SET @Line = @Line + ' '; -- Add space for hollow part
        END
        SET @Col = @Col + 1; -- Move to the next column
    END;

    PRINT @Line; -- Print the complete line for the current row
    SET @Row = @Row + 1; -- Move to the next row
END;

/*********OUTPUT**********
          *****
          *   *
          *   *
          *   *
          *****
*************************/

--17) Rhombus Pattern in T-SQL:

-- Declare variables for user inputs
DECLARE @Character NVARCHAR(1);   -- Character to print (e.g., *, A, 1)
DECLARE @Size INT;                 -- Size of the triangle (number of rows)
DECLARE @Row INT;                  -- Current row counter
DECLARE @Col INT;                  -- Current column counter

-- Simulate user inputs
SET @Character = '*';  -- Replace with desired character (e.g., *, A, 1)
SET @Size = 5;         -- Replace with desired size of the pattern

-- Validate inputs
IF @Size <= 0
BEGIN
    PRINT 'Size must be greater than 0.';
    RETURN;
END;

-- Generate the pattern
SET @Row = 0;  -- Start from the first row (row index starts from 0)

WHILE @Row < @Size
BEGIN
    DECLARE @Line NVARCHAR(MAX) = '';  -- Initialize the line variable

    -- Add leading spaces to align the stars
    SET @Col = 1;
    WHILE @Col <= @Row
    BEGIN
        SET @Line = @Line + ' ';  -- Add space
        SET @Col = @Col + 1;
    END;

    -- Add stars for the row
    SET @Col = 1;
    WHILE @Col <= @Size
    BEGIN
        SET @Line = @Line + @Character;  -- Add star
        SET @Col = @Col + 1;
    END;

    PRINT @Line;  -- Print the complete line for the current row
    SET @Row = @Row + 1;  -- Move to the next row
END;

/*********OUTPUT**********
		*****
		 *****
		  *****
		   *****
		    *****
*************************/

-- 18)Hollow Rhombus Pattern in T-SQL:

-- Declare variables for user inputs
DECLARE @Character NVARCHAR(1);   -- Character to print (e.g., *, A, 1)
DECLARE @Size INT;                 -- Size of the square (number of rows/columns)
DECLARE @Row INT;                  -- Current row counter
DECLARE @Col INT;                  -- Current column counter

-- Simulate user inputs
SET @Character = '*';  -- Replace with desired character (e.g., *, A, 1)
SET @Size = 5;         -- Replace with desired size of the square

-- Validate inputs
IF @Size <= 0
BEGIN
    PRINT 'Size must be greater than 0.';
    RETURN;
END;

-- Generate the pattern
SET @Row = 1;  -- Start from the first row

WHILE @Row <= @Size
BEGIN
    DECLARE @Line NVARCHAR(MAX) = '';  -- Initialize the line variable

    -- Add leading spaces to align the square
    SET @Col = 1;
    WHILE @Col < @Row
    BEGIN
        SET @Line = @Line + ' ';  -- Add space
        SET @Col = @Col + 1;
    END;

    -- Add stars and hollow spaces
    SET @Col = 1;  -- Reset column counter for stars
    WHILE @Col <= @Size
    BEGIN
        -- Fill the boundary (first and last row, or first and last column in each row)
        IF @Row = 1 OR @Row = @Size OR @Col = 1 OR @Col = @Size
        BEGIN
            SET @Line = @Line + @Character;  -- Add character to the boundary
        END
        ELSE
        BEGIN
            SET @Line = @Line + ' ';  -- Add space for the hollow part
        END;
        SET @Col = @Col + 1;  -- Move to the next column
    END;

    PRINT @Line;  -- Print the complete line for the current row
    SET @Row = @Row + 1;  -- Move to the next row
END;

/*********OUTPUT**********
		*****
		 *   *
		  *   *
		   *   *
		    *****
*************************/

-- 19)Hourglass Pattern in T-SQL:

-- Declare variables for user inputs
DECLARE @Character NVARCHAR(1);   -- Character to print (e.g., *, A, 1)
DECLARE @Size INT;                -- Size of the hourglass (number of rows for each half)
DECLARE @Row INT;                 -- Current row counter
DECLARE @Col INT;                 -- Current column counter
DECLARE @Line NVARCHAR(MAX);      -- Line variable for each row output

-- Simulate user inputs
SET @Character = '*';  -- Replace with desired character (e.g., *, A, 1)
SET @Size = 5;         -- Replace with the desired size of the hourglass

-- Validate inputs
IF @Size <= 0
BEGIN
    PRINT 'Size must be greater than 0.';
    RETURN;
END;

-- Top Half (Inverted Pyramid)
SET @Row = @Size;  -- Start from the widest row

WHILE @Row > 0
BEGIN
    SET @Line = '';  -- Initialize the line variable for the current row

    -- Add leading spaces
    SET @Col = 1;
    WHILE @Col <= (@Size - @Row)
    BEGIN
        SET @Line = @Line + ' ';  -- Add space
        SET @Col = @Col + 1;
    END;

    -- Add stars
    SET @Col = 1;
    WHILE @Col <= (2 * @Row - 1)
    BEGIN
        SET @Line = @Line + @Character;  -- Add character for each column
        SET @Col = @Col + 1;
    END;

    PRINT @Line;  -- Print the complete line for the current row
    SET @Row = @Row - 1;  -- Move to the previous row
END;

-- Bottom Half (Normal Pyramid)
SET @Row = 1;  -- Start from the smallest row

WHILE @Row <= @Size
BEGIN
    SET @Line = '';  -- Initialize the line variable for the current row

    -- Add leading spaces
    SET @Col = 1;
    WHILE @Col <= (@Size - @Row)
    BEGIN
        SET @Line = @Line + ' ';  -- Add space
        SET @Col = @Col + 1;
    END;

    -- Add stars
    SET @Col = 1;
    WHILE @Col <= (2 * @Row - 1)
    BEGIN
        SET @Line = @Line + @Character;  -- Add character for each column
        SET @Col = @Col + 1;
    END;

    PRINT @Line;  -- Print the complete line for the current row
    SET @Row = @Row + 1;  -- Move to the next row
END;

/*********OUTPUT**********
		*********		 *
		 *******		 *
		  *****			 *
		   ***			 *
		    *			 *
		    *			 *
		   ***			 *
		  *****			 *
		 *******		 *
		*********		 *	
*************************/

-- 20)Hollow Hourglass Pattern in T-SQL:

-- Declare variables for user inputs
DECLARE @Character NVARCHAR(1);   -- Character to print (e.g., *, A, 1)
DECLARE @Size INT;                -- Size of the hourglass (number of rows for each half)
DECLARE @Row INT;                 -- Current row counter
DECLARE @Col INT;                 -- Current column counter
DECLARE @Line NVARCHAR(MAX);      -- Line variable for each row output

-- Simulate user inputs
SET @Character = '*';  -- Replace with desired character (e.g., *, A, 1)
SET @Size = 5;         -- Replace with the desired size of the hourglass

-- Validate inputs
IF @Size <= 0
BEGIN
    PRINT 'Size must be greater than 0.';
    RETURN;
END;

-- Top Half (Inverted Pyramid)
SET @Row = @Size;  -- Start from the widest row

WHILE @Row > 0
BEGIN
    SET @Line = '';  -- Initialize the line variable for the current row

    -- Add leading spaces
    SET @Col = 1;
    WHILE @Col <= (@Size - @Row)
    BEGIN
        SET @Line = @Line + ' ';  -- Add space
        SET @Col = @Col + 1;
    END;

    -- Add stars
    SET @Col = 1;
    WHILE @Col <= (2 * @Row - 1)
    BEGIN
        -- Fill the boundary
        IF @Col = 1 OR @Col = (2 * @Row - 1) OR @Row = @Size
        BEGIN
            SET @Line = @Line + @Character;  -- Add character for boundary
        END
        ELSE
        BEGIN
            SET @Line = @Line + ' ';  -- Add space for hollow part
        END;
        SET @Col = @Col + 1;
    END;

    PRINT @Line;  -- Print the complete line for the current row
    SET @Row = @Row - 1;  -- Move to the previous row
END;

-- Bottom Half (Normal Pyramid)
SET @Row = 1;  -- Start from the smallest row

WHILE @Row <= @Size
BEGIN
    SET @Line = '';  -- Initialize the line variable for the current row

    -- Add leading spaces
    SET @Col = 1;
    WHILE @Col <= (@Size - @Row)
    BEGIN
        SET @Line = @Line + ' ';  -- Add space
        SET @Col = @Col + 1;
    END;

    -- Add stars
    SET @Col = 1;
    WHILE @Col <= (2 * @Row - 1)
    BEGIN
        -- Fill the boundary
        IF @Col = 1 OR @Col = (2 * @Row - 1) OR @Row = @Size
        BEGIN
            SET @Line = @Line + @Character;  -- Add character for boundary
        END
        ELSE
        BEGIN
            SET @Line = @Line + ' ';  -- Add space for hollow part
        END;
        SET @Col = @Col + 1;
    END;

    PRINT @Line;  -- Print the complete line for the current row
    SET @Row = @Row + 1;  -- Move to the next row
END;

/*********OUTPUT**********
		*********		 *
		 *     *		 *
		  *   *			 *
		   * *			 *
		    *			 *
		    *			 *
		   * *			 *
		  *   *			 *
		 *     *		 *
		*********		 *		
*************************/

-- 21)Floyd's Triangle Pattern in T-SQL:

-- Declare variables for user inputs
DECLARE @Rows INT;                -- Number of rows for the Floyd's triangle
DECLARE @CurrentNumber INT = 1;   -- Starting number of the triangle
DECLARE @Row INT;                 -- Current row counter
DECLARE @Col INT;                 -- Current column counter
DECLARE @Line NVARCHAR(MAX);      -- Line variable for each row output

-- Simulate user input
SET @Rows = 5;  -- Replace with the desired number of rows

-- Validate input
IF @Rows <= 0
BEGIN
    PRINT 'Number of rows must be greater than 0.';
    RETURN;
END;

-- Generate Floyd's Triangle
SET @Row = 1;  -- Start from the first row

WHILE @Row <= @Rows
BEGIN
    SET @Line = '';  -- Initialize the line variable for the current row

    -- Add numbers for the current row
    SET @Col = 1;
    WHILE @Col <= @Row
    BEGIN
        SET @Line = @Line + CAST(@CurrentNumber AS NVARCHAR) + ' ';  -- Append the current number
        SET @CurrentNumber = @CurrentNumber + 1;  -- Increment the number
        SET @Col = @Col + 1;  -- Move to the next column
    END;

    PRINT @Line;  -- Print the complete line for the current row
    SET @Row = @Row + 1;  -- Move to the next row
END;

/*********OUTPUT**********
1 						 *
2 3 					 *
4 5 6 					 *
7 8 9 10 				 *
11 12 13 14 15			 *
*************************/

-- Declare variables for the number of rows
DECLARE @Rows INT = 5;  -- Set the number of rows you want to print
DECLARE @Row INT;       -- Current row
DECLARE @Col INT;       -- Current column

-- Initialize the row counter
SET @Row = 1;

-- Loop through each row
WHILE @Row <= @Rows
BEGIN
    -- Initialize an empty string to store the line for the current row
    DECLARE @Line NVARCHAR(MAX) = '';
    
    -- Loop through each column for the current row
    SET @Col = 1;
    WHILE @Col <= @Row
    BEGIN
        -- Append the current column number to the line
        SET @Line = @Line + CAST(@Col AS NVARCHAR(10));
        
        -- Move to the next column
        SET @Col = @Col + 1;
    END;
    
    -- Print the line for the current row
    PRINT @Line;
    
    -- Move to the next row
    SET @Row = @Row + 1;
END;

/*********OUTPUT**********
1						 *
12						 *
123						 *
1234					 *
12345					 *
*************************/