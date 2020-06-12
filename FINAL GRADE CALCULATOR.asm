.ORIG x3000
BASE		.FILL		x4000
SIZE		.FILL		xA
HEXN48		.FILL		xFFD0	
PROMPT	.STRINGZ	"Please enter the 5 test scores one digit at a time: "

 LEA R0, PROMPT  		;Load PROMPT into R0
 PUTS				;Display on console
 LD R5, BASE 			;Load x4000 into R5 as base of array
 LD R4, SIZE  			;Load SIZE into R4 as array counter

LOOP
 IN
 ADD R1, R0, #0 		;Copy first user-inputted score into R1
 LEA R7, HEXN48  		;Load HEXN48, offset for ascii conversion, into R7
 ADD R1, R1, R7  		;Subtract R1 and HEXN48, R1 contains converted value
 STR R1, R5, #0  		;store R1 into R5
 ADD R5, R5, #1  		;then R5 moves up in array
 ADD R4, R4, #-1		;counts down from 10
 BRp LOOP
	
	AND R0, R0, #0		;Clear R0
	AND R1, R1, #0		;Clear R1
	AND R2, R2, #0		;Clear R2
	AND R3, R3, #0		;Clear R3
	AND R4, R4, #0		;Clear R4
	AND R6, R6, #0		;Clear R6
AND R7, R7, #0		;Clear R7

ADD R0, R5, #-9		;Copy address of array into R5
LDR R1, R0, #2		;Load second digit of first score into R1
ADD R2, R1, #0		;Copy R1 into R2
LDR R1, R0, #3		;Load first digit of second score into R1
ADD R3, R1, #0		;Copy R1 into R3
LDR R1, R0, #4		;Load second digit of second score into R1
ADD R4, R1, #0		;Copy R1 into R4
LDR R1, R0, #1		;Load first digit of first score into R1

AND R0, R0, #0		;Clear R0
ADD R0, R3, #0		;Copy R3 into R0, first digit of second score
NOT R0 R0			;1’S COMP OF R3
	ADD R0, R0, #1		;2’S COMP OF R3, NOW -R3
	ADD R0, R1, R0		;Add R1 with -R3
	BRp SUM1			;If sum is positive, branch to SUM1
	BRz EQ1			;If zero, branch to EQ1
	ADD R6, R3, #0		;R3 copied into R6 because it is current MAX, first digit
	ADD R7, R4, #0		;Second digit with current MAX
	ADD R3, R1, #0		;Copy R1 into R3, current min
	ADD R4, R2, #0		;Copy R2 into R4, second digit of current min

SUM1	ADD R6, R1, #0		;R1 copied into R6 because it is current MAX
	ADD R7, R2, #0		;Second digit with current MAX, in R7

EQ1	AND R0, R0, #0		;Clear R0
	ADD R0, R4, #0		;Copy R4 into R0
	NOT R0, R0			;1’S COMP OF R4
	ADD R0, R0, #1		;2’S COMP OF R4
	ADD R0, R2, R0		;Add second digits together, R2 and -R4
	BRzp SUM2			;If positive or zero, branch to SUM2
	ADD R6, R3, #0		;R3 copied into R6 because it is current MAX, first digit
	ADD R7, R4, #0		;Second digit with current MAX
	AND R3, R3, #0		;Clear R3
	AND R4, R4, #0		;Clear R4
	ADD R3, R1, #0		;Copy R1 into R3, current MIN
	ADD R4, R2, #0		;Copy R2 into R4, second digit of current MIN

SUM2	ADD R6, R1, #0		;R1 copied into R6 because it is current MAX
	ADD R7, R2, #0		;Second digit with current MAX
					;R3 is current MIN, unchanged
					;R4 is second digit of current MIN, unchanged

	AND R0, R0, #0		;Clear R0
	AND R1, R1, #0		;Clear R1
	AND R2, R2, #0		;Clear R2
	ADD R0, R5, #-9		;Copy R5 into R0 to access array
	LDR R1, R0, #6		;Load second digit of third score into R1
	ADD R2, R1, #0		;Copy R1 into R2
	LDR R1, R0, #5		;Load first digit of third score into R1

	AND R0, R0, #0		;Clear R0
	ADD R0, R1, #0		;Copy R1 into R0
	NOT R0, R0			;1’S comp of R0
	ADD R0, R0, #1		;2’S COMP OF R0, contains -R1
	ADD R0, R6, R0		;Add R6,current MAX, and -R1 and put into R0
	BRn SUM3			;Branch to SUM3 if sum is negative
	BRz EQ2			;Branch to EQ2 if sum is zero
	
SUM3	ADD R6, R1, #0		;Third score is new MAX (first digit)
	ADD R7, R2, #0		;second digit of third score	
	
EQ2	ADD R0, R0, #0		;Clear R0
ADD R0, R2, #0		;Copy R2 into R0, second digit of third score
	NOT R0, R0			;1’s comp of R0 = R2
	ADD R0, R0, #1		;2’s comp of R0 = R2, now -R2
	ADD R0, R7, R0		;Add second digit of MAX and third score
	BRnz SUM4			;Branch to SUM4 if sum is negative or zero

SUM4	ADD R6, R1, #0		;R1 is new MAX
	ADD R7, R2, #0		;R2 is second digit of new MAX
	
	AND R0, R0, #0		;Clear R0
	ADD R0, R1, #0		;Copy R1 into R0
	NOT R0, R0			;1’s comp of R1
	ADD R0, R0, #1		;2’s comp of R1, now -R1
	ADD R0, R3, R0		;Add current MIN and 3rd score first digit
	BRp SUM5			;If positive, branch to SUM5
	BRz EQ3			;If zero, branch to EQ3

SUM5	ADD R3, R1, #0		;R1, third score, is new MIN
	ADD R4, R2, #0		;second digit of new MIN

EQ3	ADD R0, R0, #0		;Clear R0
ADD R0, R2, #0		;Copy R0 into R2
	NOT R0, R0			;1’s Comp of R0 = R2
	ADD R0, R0, #1		;2’s comp of R0, now -R2
	ADD R0, R4, R0		;Add second digits of current MIN and third score
	BRzp SUM6			;Branch to SUM6 if sum is zero or positive
	
SUM6	ADD R3, R1, #0		;R1, third score, is new MIN
	ADD R4, R2, #0		;second digit of third score, new MIN
	
	AND R0, R0, #0		;Clear R0
	AND R1, R1, #0		;Clear R1
	AND R2, R2, #0		;Clear R2
	ADD R0, R5, #-9		;copy address of array to access into R0
	LDR R1, R0, #8		;Load second digit of fourth score into R1
	ADD R2, R1, #0		;Copy R1 into R2
	LDR R1, R0, #7		;Load first digit of fourth score into R1

	AND R0, R0, #0		;Clear R0
	ADD R0, R1, #0		;copy R1 to R0, fourth score first digit
	NOT R0, R0			;1’s comp of R0 = R1
	ADD R0, R0, #1		;2’s comp of R0, now -R1
	ADD R0, R6, R0		;subtract -R1 from current MAX
	BRn SUM7			;if negative, branch to SUM7
	BRz EQ4			;if zero, branch to EQ4

SUM7	ADD R6, R1, #0		;R1 is new MAX
	ADD R7, R2, #0		;R2 is new MAX 2nd digit

EQ4	AND R0, R0, #0		;Clear R0
ADD R0, R2, #0		;Copy R2 into R0
	NOT R0, R0			;1’s comp of R2
	ADD R0, R0, #1		;2’s comp of R2
	ADD R0, R7, R0		;Add with 2nd digit of current MAX
	BRnz SUM8			;branch if negative or zero to SUM8

SUM8	ADD R6, R1, #0		;R1 is new MAX
	ADD R7, R2, #0		;R2 is new MAX 2nd digit
	
	AND R0, R0, #0		;Clear R0
	ADD R0, R1, #0		;copy R1 into R0
	NOT R0, R0			;1’s comp of R1
	ADD R0, R0, #1		;2’s comp of R2
	ADD R0, R3, R0		;Add with current MIN
	BRp SUM9			;if positive, branch to SUM9
	BRz EQ5			;if zero, branch to EQ5

SUM9	ADD R3, R1, #0		;R1 is new MIN
	ADD R4, R2, #0		;R2 is new min 2nd digit

EQ5	AND R0, R0, #0		;Clear R0
ADD R0, R2 #0		;Copy R2 into R0
	NOT R0, R0			;1’s comp of R2
	ADD R0, R0, #1		;2’s comp of R2
	ADD R0, R4, R0		;add with current MIN 2nd digit
	BRzp SUM10			;if zero or positive, branch to SUM10

SUM10 ADD R3, R1, #0		;R1 is new MIN, first digit
	ADD R4, R2, #0		;R2 is new MIN 2nd digit
	
	AND R0, R0, #0		;Clear R0
	AND R1, R1, #0		;Clear R1
	AND R2, R2, #0		;Clear R2
	ADD R0, R5, #-9		;Copy  address of array to R0
	LDR R1, R0, #10		;Load second digit of fifth score to R1
	ADD R2, R1, #0		;Copy R1 into R2
	LDR R1, R0, #9		;Load first digit of fifth score into R1
	
	AND R0, R0, #0		;Clear R0
	ADD R0, R1, #0		;Copy R1 to R0
	NOT R0, R0			;1’s comp of R1
	ADD R0, R0, #1		;2’s comp of R1
	ADD R0, R6, R0		;Add with current MAX
	BRn SUM11			;if negative, branch to SUM11
	BRz EQ6			;If zero, branch to EQ6

SUM11	 ADD R6, R1, #0		;R1 is new MAX first digit
	ADD R7, R2, #0		;R2 is new MAX 2nd digit

EQ6	AND R0, R0, #0		;Clear R0
ADD R0, R2, #0		;copy R2 into R0
	NOT R0, R0			;1’s comp of R2
	ADD R0, R0, #1		;2’s comp of R2
	ADD R0, R7, R0		;Add with current MAX
	BRnz SUM12			;if negative or zero, branch to SUM12

SUM12 ADD R6, R1, #0		;R1 is new MAX
	ADD R7, R2, #0		;R2 is new MAX

	AND R0, R0, #0		;Clear R0
	ADD R0, R1, #0		;copy R1 to R0
	NOT R0, R0			;1’s comp of R1
	ADD R0, R0, #1		;2’s comp of R1
	ADD R0, R3, R0		;add with current MIN
	BRp SUM13			;If positive, branch to SUM13
	BRz EQ7			;branch to EQ7 if zero

SUM13 ADD R3, R1, #0		;R1 is new MIN
	ADD R4, R2, #0		;R2 is new MIN

EQ7	AND R0, R0, #0		;Clear R0
ADD R0, R2, #0		;copy R2 into R0
	NOT R0, R0			;1’s comp of R2
	ADD R0, R0, #1		;2’s comp of R2
	ADD R0, R4, R0		;Add with current MIN
	BRzp SUM14			;if zero or positive, branch to SUM14

SUM14 ADD R3, R1, #0		;R1 is new MIN
	ADD R4, R2, #0		;R2 is new MIN

	ST R3, MINFD		;Store first digit of MIN to MINFD
	ST R4, MINSD		;Store second digit of MIN to MINSD
	ST R6, MAXFD		;Store first digit of MAX to MAXFD
	ST R7, MAXSD		;Store second digit of MIN to MINFD

ADD R0, R5, #-9	;copy address of array to R0
LDR R1, R0, #2	;load 2nd digit of first score into R1
ADD R2, R1, #0	;Copy R1 into R2

LDR R1, R0, #4	;Load 2nd digit of second score into R1
ADD R2, R2, R1	;Add R2 with 2nd digit of second score, R1

LDR R1, R0, #6	;Load 2nd digit of third score into R1
ADD R2, R2, R1	;Add to running sum, R2

LDR R1, R0, #8	;Load 2nd digit of 4th score into R1
ADD R2, R2, R1	;Add to running sum, R2

LDR R1, R0, #10	;Load 2nd digit of 5th score into R1
ADD R2, R2, R1	;Add to running sum, R2

LDR R1, R0, #1	;Load first digit of first score into R1
AND R4, R4, #0	;Clear R4
JSR MULT		;Multiply digit by 10, stores in R4

AND R6, R6, #0	;Clear R6
ADD R6, R4, #0	;Copy R4 into R6

LDR R1, R0, #3	;Load first digit of 2nd score into R1
JSR MULT		;multiply digit by 10, stores in R4

ADD R6, R6, R4	;Add to running sum R6
LDR R1, R0, #5	;Load first digit of 3rd score into R1
JSR MULT		;Multiply by 10, stores in R4

ADD R6, R6, R4	;Add to running sum R6
LDR R1, R0, #7	;Load first digit of 4th score into R1
JSR MULT		;Multiply by 10, stores in R4

ADD R6, R6, R4	;Add to running sum R6
LDR R1, R0, #9	;Load first digit of 5th score into R1
JSR MULT		;Multiply by 10, stores in R4

ADD R6, R6, R4	;Add to running sum R6, R6 contains sum of first digits

ADD R2, R2, R6	;Add 2nd digit total with first digit total
				;which creates the total sum into R2
ST R2, SUM		;stores R2 into sum

AND R3, R3, #0	;clears R3
ADD R3, R2, #0	;copies sum, R2, into R3
AND R4, R4, #0	;clears R4

JSR DIV 		;JSR DIV to divide by 5

MULT 					;MULT subroutine
	AND R3, R3, #0		;clear R3
	ADD R3, R3, #10		;set counter R3 to 10
	MULTLOOP			;loop
		ADD R4, R4, R1	;add R4, running sum, and R1 to R4
		ADD R3, R3, #-1	;decrement counter
		BRp MULTLOOP	;back to loop if positive
		BRz QUIT1		;if zero, quit
QUIT1	RET				;return

DIV					;DIV subroutine	
	AND R4, R4, #0			;Clear R4
	DIVLOOP				;loop
		ADD R4, R4, #1		;R4 holds 1
		ADD R3, R3, #-5		;subtract 5 from R3
		BRp DIVLOOP		;back to loop if positive
		BRz QUIT2		;if zero, quit
QUIT2	RET				;return

STI R4, AVG			;store average R4 to AVG

JSR MATCHSCORE

MATCHSCORE
	LD R5, SIXTY
	ADD R4, R4, R5		;subtract 60 to test for Fail
	BRn LOOP2 
	LD R6, MINUSTEN
	ADD R4, R4, R6	;subtract 10 to test for next letter grade
	BRn LOOP2
ADD R4, R4, R6	;subtract 10 to test for next letter grade
	BRn LOOP2
ADD R4, R4, R6	;subtract 10 to test for next letter grade
	BRn LOOP2
ADD R4, R4, R6	;subtract 10 to test for next letter grade
	BRn LOOP2
LEA R0, LETTERGRADE
	ADD R3, R3, x0	;set up zero branching to initialize the loop to begin at 0.
LOOP2
	BRn DISPLAY
	ADD R0, R0, xF		;R0 = 15 characters including null terminated
ADD R3, R3, #-1		
BR LOOP2
DISPLAY
	PUTS
	LEA R0, LF
	PUTS
	RET

LEA R0, MAXIMUM			;Print MAXIMUM msg
PUTS
AND R0, R0, #0
LEA R0, MAXFD			;Prints first digit of MAX
LEA R1, HEX48
ADD R0, R0, R1			;Conversion
PUTS
LEA R0, MAXSD			;Prints second digit of MAX
ADD R0, R0, R1			;Conversion
PUTS

LEA R0, MINIMUM			;Prints MINIMUM msg
PUTS
LEA R0, MINFD			;Prints MIN first digit
ADD R0, R0, R1			;Conversion
PUTS
LEA R0, MINSD			;Prints MIN second digit
ADD R0, R0, R1			;Conversion
PUTS

LEA R0, AVERAGE			;Prints AVERAGE msg
PUTS
LEA R0, AVG			;Prints avg
ADD R0, R0, R1			;Conversion
PUTS

HALT 

;Data Section

AVERAGE	.STRINGZ	"The Average Score is: "
MAXIMUM	.STRINGZ	"The Max Score is: "
MINIMUM	.STRINGZ	"The Min Score is: "
MINFD		.FILL		x3100
MINSD		.FILL		x3101
MAXFD		.FILL		x3102
MAXSD		.FILL		x3103
SUM		.FILL		x3104
AVG		.FILL		x3105
HEX48		.FILL		x0030		
LETTERGRADE		.STRINGZ	"Letter Grade: F"
			.STRINGZ	"Letter Grade: D"
			.STRINGZ	"Letter Grade: C"
			.STRINGZ	"Letter Grade: B"
			.STRINGZ	"Letter Grade: A"
SIXTY			.FILL		xFFA0
MINUSTEN		.FILL		xFFF6

LF	.FILL	x000F

 .END
