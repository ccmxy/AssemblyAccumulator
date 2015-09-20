TITLE TheIntegerAverager   (Program3ExtraCredit.asm)

; Name: Colleen Minor     
;Email: minorc@onid.oregonstate.edu
; CS271-400 / Assignment 3							Date: 2/08/2015
; Description: Program counts and accumulates user's numebers until a negative number is entered, 
;then displays the sum and rounded and floating-point average of the non-negative numbers.
;If the average is not a round number than the program tells the user a number they could add to make the average round.

INCLUDE Irvine32.inc
INCLUDE Macros.inc

.data
 upperLimit equ 100						;maximum number user can choose
 userName BYTE 50 DUP(?)				;string to be entered by user
 sum SDWORD 0							;holds the sum. 
 lineNumber SDWORD 1					;holds the line number, and doubles as denominator (for averaging arithmatic) 
 roundDown SDWORD ?						;holds quotient that has not been incremented (rounded down average)
 roundUp SDWORD ?						;holds incremented quotient (rounded up average)
 remainder SDWORD ?			
 thousand SDWORD 1000
 numberToEven SDWORD ?
 two SDWORD 2

.code
main PROC
;introduction

              mWrite "Welcome to the Integer Averager by Colleen Minor."
              call Crlf
              mWrite "What is your name? "
              mReadString userName
              call Crlf

;userInstructions
              mWrite "Hello "
              mWriteString userName
              mWrite "."
              call Crlf
              mWrite "Please enter numbers less than or equal to 100."
              call Crlf
              mWrite "Enter a negative number when you are ready to see the results."
              call Crlf

;getUserData							;Repeat the "getUserData" loop until a negative number is entered. Check for range error each time.
              getUserData:
                     call Crlf
                     mov eax, lineNumber
                     call writeDec
                     mWrite ". Please enter a number: "
                     call readInt
                     cmp eax, upperLimit
                     jg errorLoop       ;if the user's choice exceed the upper limit, jump to the error loop
                     cmp eax, 0
                     jl negaLoop
                     add sum, eax
                     INC lineNumber
                     jmp getUserData           
              errorLoop:
                     call Crlf
                     mWrite "Sorry, the number you enter must be less than or equal to 100. Try again."
                     call Crlf
                     jmp getUserData
              negaLoop:					;decreases the lineNumber to get it ready to become the denominator
                     call Crlf
                     call Crlf
                     dec lineNumber
;displayRoundedAverage					;Check whether a number should be rounded up or down by checking if (2 * remainder) < denominator (lineNumber) and display rounded average. 
			
                     call Crlf
                     mWrite "You entered "
                     mov eax, lineNumber
                     call writeDec
                     mWrite " numbers."
                     call Crlf
                     mWrite "The sum of your numbers is "
                     mov eax, sum
	                 call writeDec
                     mWrite "."
                     call Crlf
                     mWrite "The rounded average is "
                     mov eax, sum
					 mul lineNumber		;For some reason I have to multiply eax by something before dividing it, or else the program breaks where it tries to divide...
					 mov eax, sum
                     div lineNumber
					 mov roundDown, eax
					 mov remainder, edx
					 mov eax, remainder
					 mul two
					 cmp eax, lineNumber
					 jl roundedDown		;roundedDown jump (triggerd by lineNumber being less than twice the remainder)
					 mov eax, roundDown
					 mov roundUp, eax
					 INC roundUp
					 mov eax, roundUp
					 call writeDec
					 mWrite "."
					 call Crlf
					 jmp floatingPoint
				roundedDown:
					 mov eax, roundDown
                     call writeDec
					 mWrite "."
					 call Crlf
;displayFloatingPoint					;Display the floating point and, if the remainder is 0, jumps to the exit loop (skipping "couldHaveBeen").
				floatingPoint:			
					mWrite "The floating-point average is "
					mov eax, roundDown
					call writeDec
					mWrite "."
					mov eax, remainder
					mul thousand
					div lineNumber
					call writeDec
					mWrite "."
					call Crlf
					mov eax, remainder
					cmp eax, 0
					je exit_loop

;displayCouldHaveBeen					;Calculate what number could have been added to have a quotient with no remainder by multiplying the rounded up number by (total numbers + 1), then subtracting the sum from that.
			couldHaveBeen:				
				mWrite "The average could be an even "
				mov eax, roundDown
				INC eax
				mov roundUp, eax
				call writeDec
				mWrite " by adding "
				INC lineNumber
				mul lineNumber
				sub eax, sum
				mov numberToEven, eax
				call writeDec
				mWrite " to your numbers list. ( "
				mov eax, sum
				call writeDec
				mWrite " + "
				mov eax, numberToEven
				call writeDec
				mWrite " ) / "
				mov eax, lineNumber
				call writeDec
				mWrite " (numbers) = "
				mov eax, roundUp
				call writeDec
				mWrite "."
;Exit									;Say goodbye to use and end program.
              exit_loop:
                     call Crlf
                     mWrite "Thank you for using Integer Averager! It was great to meet you, "
                     mWriteString userName
                     mWrite "."
                     call Crlf
              exit  
main ENDP
END main
