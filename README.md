# Ransomware.asm

## Description

`ransomware.asm` is a proof-of-concept, NASM-based ransomware program written in NASM `x86` Assembly language, demonstrating basic file encryption and decryption using an XOR cipher. This project is intended purely for educational purposes and is not intended to be used maliciously. The code performs encryption on a target file by applying an XOR-based encryption algorithm, followed by decryption using a correct key input.

Key features include:
- **File Encryption:** Encrypts a specified target file using XOR encryption, with progress messages shown to simulate the encryption process.
- **Decryption:** Decrypts the file when the correct decryption key is provided (`Leopard`), or it simulates file deletion if an incorrect key is entered.
- **Error Handling:** Handles file read, write, and input errors, providing appropriate messages for debugging.
- **Progress Feedback:** Displays a series of status messages for encryption and decryption, mimicking the behavior of ransomware alerts.

This project is designed to showcase basic encryption techniques and the potential security risks of ransomware. It demonstrates how attackers can hold files hostage and demand payment in exchange for a decryption key.

## Features

- **Encryption Simulation:** 
  - Shows progress of encryption in real-time.
  - Encrypts files using XOR encryption.
  
- **Decryption Simulation:**
  - Asks for a key to decrypt the file.
  - If the correct key (`Leopard`) is entered, the file is decrypted.
  - If an incorrect key is entered, the target file is deleted.

- **Error Handling:**
  - Handles errors such as failing to open, read, or write to files.
  - Displays appropriate error messages for better understanding.

## Files

- **`ransomware.asm`:** The core Assembly code that performs encryption, decryption, and file handling.
- **`compiler.sh`:** A shell script for compiling and linking the Assembly code. It generates an executable called `ransomware`.
- **`Target-Dir/TargetFile.txt`:** A dummy file used as the target for encryption and decryption.

## Setup

1. Clone the repository or download the project files.
2. Use the provided `compiler.sh` script to compile the assembly code into an executable.
   
   ```bash
   ./compiler.sh
   ```

3. After compilation, run the executable to simulate the ransomware attack:
   
   ```bash
   ./ransomware
   ```

4. Enter the decryption key (`Leopard`) when prompted to decrypt the file.

## Important Notes

- This project is for educational purposes only. It demonstrates basic ransomware functionality and file encryption/decryption techniques.
- Do not use this code on real systems or files. It is designed to showcase how encryption and decryption work in a simple scenario.

## License

This project is licensed under the MIT License. Feel free to modify, use, and distribute it for educational purposes.
