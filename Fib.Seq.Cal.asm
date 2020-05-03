TITLE Project #2     (Program#2.asm)

;-------------------------------------------------------------------------------------------------------------------;
; Author:Brandon Schultz                                                                                            ;
; First Modified: 4-5-20                             Last Modified: 4-18-20                                         ;
; OSU email address:                                 schulbra@oregonstate.edu                                       ;
; Course number/section:                             CS 271 400 Spring 2020                                         ;
; Project number: Two                                  Due Date: 4-19-20                                            ;
;  A Fibonacci Sequence is a series of numbers where the next number in sequence is found by adding together the    ; 
; sequences two previous terms.                                                                                     ;
;  This program takes as input a username and value (n) limited to some value between 1-46 for use in a Fibonacci   ;
; Sequence Calculator. Calculator will return all fibonnaci values up to and including defined "n" value.           ;
;  Contains input validation for n before displaying five fibonnaci values /line, each seperated by five blank      ; 
; space characters.                                                                                                 ;
;-------------------------------------------------------------------------------------------------------------------;

INCLUDE Irvine32.inc

.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

.data
displayboardTOP					BYTE  "|------------------------------------------------------------------------------------| ", 0
programmerName					BYTE  "| Brandon Schultz                                                                    | ", 0
programTitle					BYTE  "| CS_271 - Fibonacci Sequence Calculator                                             | ", 0
ec_prompt						BYTE  "| ** EC #2 was attempted via incredibly witty farewell prompt.                       | ", 0
fib_Prompt						BYTE  "| A Fibonacci Sequence is a series of numbers where the next number in sequence is   | ", 0
fib_PromptA						BYTE  "| found by adding together the sequence's two previous terms.                        | ", 0
fib_Prompt1						BYTE  "| This program takes as input a username and value (n) limited to some value between | ", 0 
fib_Prompt1A					BYTE  "| 1-46 for use in a Fibonacci Calculator.                                            | ", 0
getUserName						BYTE   "Enter a username below: ", 0
userGreet						BYTE   "Hello, ", 0
getUserFibValueLimit			BYTE   "Enter the number of Fibonacci terms to be displayed: ", 0
getUserFibValueLimit2			BYTE   "Number entered:  ", 0
upperLimitUserInputValidation	BYTE   "Enter a value < 46. ", 0
lowerLimitUserInputValidation	BYTE   "Enter a value > 1. ", 0
goodbyePrompt					BYTE   "Sequence ya later, ", 0			; see you later
blankSpace						BYTE   "     ", 0					    ; seperates displayed number by five spaces/num.

; String establishing username input by user.
userNameInput				  BYTE	 35 DUP(0)

; Number representing value input by user (n).
UserNumberInput				  DWORD	 ?

; Constants establishing min/max value of user defined "n" value.
UPPERLIMIT					  DWORD	 46
LOWERLIMIT					  DWORD  1
TOTAL						  DWORD  0

.code
main PROC

; Intro:

	  ; Displays Boarder for top/bottom of assignment info template.
		mov			edx, OFFSET	displayboardTOP
		call		WriteString
		call		Crlf

	  ; Displays program title.
		 mov		edx, OFFSET programTitle
		 call		WriteString
		 call		CrLf

	  ; Displays programmer name.
		 mov		edx, OFFSET programmerName
		 call		WriteString
		 call		CrLf

	  ; EC Prompt.
		 mov		edx, OFFSET ec_prompt
		 call		WriteString
		 call		CrLf

	  ; Fib intro prompts. 78 - 93
		 mov		edx, OFFSET fib_Prompt
		 call		WriteString
		 call		CrLf

		 mov		edx, OFFSET fib_PromptA
		 call		WriteString
		 call		CrLf

		 mov		edx, OFFSET fib_Prompt1
		 call		WriteString
		 call		CrLf

		 mov		edx, OFFSET fib_Prompt1A
		 call		WriteString
		 call		CrLf

     ; Displays Boarder for top/bottom of assignment info template.
		 mov		edx, OFFSET	displayboardTOP
		 call		WriteString
		 call		Crlf
		 call		Crlf

; Greets user:

	  ; Prompts user to enter as input some username.
		 mov		edx, OFFSET getUserName
		 call		WriteString
		 mov		edx, OFFSET userNameInput
		 mov		ecx, 34
		 call	    ReadString

      ; Greets the user by entered username.
		 mov		edx, OFFSET userGreet
		 call 	    WriteString
		 mov		edx, OFFSET userNameInput
		 call	    Writestring
		 call	    CrLf

; Instructions for program:

	  ; Prompt explaining programs input limitations.
		 usersFibInputVal:
		  mov	    edx, OFFSET getUserFibValueLimit
		  call		WriteString
		  call		CrLf
		  jmp		getUserFibInput

; Obtains then validates user input for fib calculator. Additional info below:

	 ; Takes in value entered by user.
	   getUserFibInput:
		 mov		edx, OFFSET getUserFibValueLimit2
		 call		WriteString
		 call		ReadInt
		 mov		UserNumberInput, eax
		 call		CrLf

	 ; Methods for calculating fibonacci sequence if user input is between 1-46.
	 ; By setting ebx equal to 46, anything entered as input (eax) < ebx is 
	 ; considered within range. Values outside of 1-46 range causes user to be
	 ; redirected to fib value input prompt. Values within range direct user to
	 ; UPPERLIMITPASS, where input is checked to be >= 1.
		 mov		ebx, UPPERLIMIT
		 cmp		ebx, eax						
		 jge		UPPERLIMITPASS
		 mov		edx, OFFSET upperLimitUserInputValidation
		 call		WriteString
		 call		CrLf
		 jmp		getUserFibInput

	 ; ebx is set to one, value is already within upperlimit range so long as input
	 ; is greater than one the program will calculate fib sequence. Otherwise the user
	 ; is redirected to fib value input prompt.
		UPPERLIMITPASS:								
		   mov		ebx, LOWERLIMIT
		   cmp		ebx, eax
		   jle		LOWERLIMITPASS
		   mov		edx, OFFSET upperLimitUserInputValidation
		   call	    WriteString
		   jmp		getUserFibInput

	 ; If user input for fib number is between 1-46, run program loop # of times
	 ; as required based on "getUserFibInput" value. Display outcome of loop, limiting
	 ; output to four elements/line.
	    LOWERLIMITPASS:
		   mov		eax, 0
		   mov		ebx, lowerLimit
		   mov		ecx, UserNumberInput
		   mov		esi, 5

; Post-input validation and methods used to display fibs once calculated:

	 ; Fib sequence calculations.
		 calcFibonacciSeq:
		  mov		total, eax
		  add		eax, ebx
		  call	    WriteDec
		  mov		ebx, total
		  dec		esi
		  jnz		fibOutputBlankSpace
		  cmp		ecx, 1
		  je		endFibSequenceCalculator

	 ; Used to maintain four elements/line, repeats until fib sequence ends.
		endLineFibOutput:
		 call	    CrLf
		 mov		esi, 5
	     cmp		ecx, 1
	     je		    endFibSequenceCalculator
	     loop	    calcFibonacciSeq

	 ; Used to maintain five spaces between four elements/line, repeats until fib sequence ends.
	   fibOutputBlankSpace:
	    cmp			ecx, 1
	    je			endLineFibOutput
	    mov			edx, OFFSET blankSpace
	    call	    WriteString
	    loop	    calcFibonacciSeq

	 endFibSequenceCalculator:	
		call	    CrLf
		call	    CrLf

; End Program, exit to operating system after saying goodbye.

		mov			edx, OFFSET goodbyePrompt
		call		WriteString
		mov			edx, OFFSET userNameInput
		call		WriteString
		call		CrLf
		exit

main ENDP

END main