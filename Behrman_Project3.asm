TITLE Programming Assignment #3    (Behrman_Project3.asm)

; Author: Alexandra Behrman
; Course / Project ID  CS271_400          Date: 2/9/17
; Description: Write and test a MASM program to perform the following tasks:
;	1. Display the program title and programmer’s name.
;	2. Get the user’s name, and greet the user.
;	3. Display instructions for the user.
;	4. Repeatedly prompt the user to enter a number. Validate the user input to be in [-100, -1] (inclusive).
;		Count and accumulate the valid user numbers until a non-negative number is entered. (The nonnegative number is discarded.)
;	5. Calculate the (rounded integer) average of the negative numbers.
;	6. Display:
;		i. the number of negative numbers entered (Note: if no negative numbers were entered, display a special message and skip to iv.)
;		ii. the sum of negative numbers entered
;		iii. the average, rounded to the nearest integer (e.g. -20.5 rounds to -20)
;		iv. a parting message (with the user’s name)

INCLUDE Irvine32.inc

.data

myName		BYTE	"Name: Alexandra Behrman", 0
myProgram	BYTE	"Title: Programming Assignment #3", 0
name_prompt	BYTE	"What's your name? ", 0
userName	BYTE	30 DUP(0)
hello		BYTE	"Hello, ", 0
goodbye		BYTE	"Thanks for playing! Goodbye ", 0
period		BYTE	". ", 0
prompt1		BYTE	"Please enter numbers in [-100, -1].", 0
prompt2		BYTE	"Enter a non-negative number when you are finished to see the results.", 0
prompt3		BYTE	"Enter a number: ", 0
range_err	BYTE	"That number is below -100.", 0
youEntered	BYTE	"You entered ", 0
numbers		BYTE	" numbers.", 0
sumIs		BYTE	"The sum of the numbers you entered is ", 0
averageIs	BYTE	"The rounded average is ", 0
ZeroCount	BYTE	"You chose to enter 0 numbers in [-100, -1].", 0
tempSum		BYTE	"Temp sum: ", 0

count		DWORD	0 ;number of negative integers entered
accumulator	DWORD	0 ;sum
average		DWORD	0 ;rounded average
remainder	DWORD	0 ;for rounding

EC_1		BYTE	"**EC: Changing the text color from white to lightCyan.", 0
EC_2		BYTE	"**EC: Numbering the lines of user input.", 0
ecCount		DWORD	1 ;for numbering user input lines

LOWERLIMIT = -100
UPPERLIMIT = -1

.code
main PROC

;introduction
	mov		edx, OFFSET myName
	call	WriteString
	call	CrLf
	mov		edx, OFFSET myProgram
	call	WriteString
	call	CrLf
	call	CrLf

;Extra Credit #1
	mov		edx, OFFSET EC_1
	call	WriteString
	mov		eax, lightCyan
	call	SetTextColor
	call	CrLf

;Extra Credit #2
	mov		edx, OFFSET EC_2
	call	WriteString
	call	CrLf
	call	CrLf

;getUserData
	mov		edx, OFFSET name_prompt
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, SIZEOF userName
	call	ReadString

	;Greet User
	mov		edx, OFFSET hello
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET period
	call	WriteString
	call	CrLf
	call	CrLf

;userInstructions
	mov		edx, OFFSET prompt1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt2
	call	WriteString
	call	CrLf
	call	CrLf
	mov		eax, ecCount
	call	WriteDec
	mov		edx, OFFSET period
	call	WriteString
	mov		edx, OFFSET prompt3
	call	WriteString
	call	ReadInt
	inc		ecCount

	;validation
	cmp		eax, LOWERLIMIT
	jl		RangeError
	cmp		eax, UPPERLIMIT
	jg		NonNegative
	
	;count and accumulate	
	add		eax, accumulator
	mov		accumulator, eax
	inc		count

;getNumbers

EnterNumbers:
	mov		eax, ecCount
	call	WriteDec
	mov		edx, OFFSET period
	call	WriteString
	mov		edx, OFFSET prompt3
	call	WriteString
	call	ReadInt
	inc		ecCount

	;validation
	cmp		eax, LOWERLIMIT
	jl		RangeError
	cmp		eax, UPPERLIMIT
	jg		NonNegative

	;count and accumulate
	add		eax, accumulator
	mov		accumulator, eax
	inc		count
	jmp		EnterNumbers
	
;displayResults

Results:

	;Display Count
	call	CrLf
	mov		edx, OFFSET youEntered
	call	WriteString
	mov		eax, count
	call	WriteDec
	mov		edx, OFFSET numbers
	call	WriteString
	call	CrLf
		
	;Display Sum
	mov		edx, OFFSET sumIs
	call	WriteString
	mov		eax, accumulator
	call	WriteInt
	mov		edx, OFFSET period
	call	WriteString
	call	CrLf

	;Calculate Average
	mov		edx, 0
	mov		eax, accumulator
	cdq
	mov		ebx, count
	idiv	ebx
	mov		average, eax
	neg		edx
	mov		remainder, edx

		;rounding check
		mov		eax, remainder
		mov		ebx, 2
		mul		ebx
		cmp		eax, count
		jb		WriteAverage

		dec		average
		jmp		WriteAverage

	;Write Average
WriteAverage:
	mov		edx, OFFSET averageIs
	call	WriteString
	mov		eax, average
	call	WriteInt
	mov		edx, OFFSET period
	call	WriteString
	call	CrLf

	jmp		ProgramEnd	

;Input is not in [-100, -1]	
RangeError:
	call	CrLf
	mov		edx, OFFSET range_err
	call	WriteString
	call	CrLf
	jmp		EnterNumbers

;Non-Negative Input: check if count = 0
NonNegative:
	mov		eax, count
	cmp		eax, 0
	jne		Results
	je		CountIsZero

;No negative numbers were entered
CountIsZero:
	mov		edx, OFFSET ZeroCount
	call	WriteString
	jmp		ProgramEnd

;farewell
ProgramEnd:
	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET period
	call	WriteString
	call	CrLf
	call	CrLf

	exit	; exit to operating system
main ENDP


END main