# NASM x86 Ransomware (3rd Semester -- COAL Project)

## Description

`ransomware.asm` is a proof-of-concept ransomware simulation written in **NASM x86 Assembly language**. It showcases a simple encryption and decryption mechanism using an **XOR cipher**, intended solely for educational and research purposes. This project highlights the mechanics of ransomware attacks, where files are encrypted and can be decrypted only if the correct key is provided.

The ransomware simulates the process of holding a file hostage by:
- **Encrypting a target file** using an XOR encryption algorithm.
- **Simulating file deletion** when an incorrect decryption key is entered.
- **Simulating a ransomware notification** that mimics the behavior of real-world ransomware attacks.

The project demonstrates the potential threats of ransomware, the importance of encryption security, and the need for protective measures to safeguard personal files.

> **Disclaimer:** This project is purely educational. The intention is not to promote malicious use but to highlight cybersecurity concepts. **Do not run this program on important files or systems**.

## Features

### 1. **File Encryption**
   - Encrypts a specified file (`TargetFile.txt`) located in the `Target-Dir` directory.
   - Simulates encryption progress with messages (e.g., 20%, 40%, 60%, etc.).
   - Uses a **simple XOR cipher** to encrypt file content.
   
### 2. **File Decryption**
   - Prompts the user to input a decryption key.
   - If the correct key (`Leopard`) is entered, it decrypts the file and displays a success message.
   - If the incorrect key is entered, it simulates the deletion of the target file and shows an error message.

### 3. **Progress Feedback**
   - Displays simulated progress bars and messages during encryption and decryption to mimic the behavior of ransomware alerts.

### 4. **Error Handling**
   - Provides appropriate error handling for common issues, such as failing to open, read, or write to the target file.
   - Displays error messages for debugging.

## Files

- **`ransomware.asm`:** The main Assembly source code responsible for encryption, decryption, and file handling.
- **`compiler.sh`:** A shell script used to compile and link the Assembly code into a runnable executable (`ransomware`).
- **`Target-Dir/TargetFile.txt`:** A dummy file used for encryption and decryption during testing. This file is the target of the ransomware attack.
- **`requirements`:** A file listing the required dependencies and setup instructions (if applicable).

## Setup

### Prerequisites
Ensure you have the following tools installed on your system:
- **NASM** (Netwide Assembler): For assembling the Assembly code.
- **LD** (GNU linker): For linking the object file to create the executable.
- A **Linux-based system** (or compatible environment like Kali Linux) for running the provided scripts and code.

### Steps to Compile and Run

1. **Clone the repository** or download the project files:

   ```bash
   git clone https://github.com/TheLeopard65/NASM-X86-Ransomware.git
   cd NASM-X86-Ransomware
   ```

2. **Make the shell script executable** (if not already):

   ```bash
   chmod +x compiler.sh
   ```

3. **Compile the assembly code** using the provided `compiler.sh` script:

   ```bash
   ./compiler.sh
   ```

   This will generate the executable `ransomware`.

4. **Run the ransomware** simulation:

   ```bash
   ./ransomware
   ```

5. **Decryption**:
   - After the encryption process, you will be prompted for a decryption key.
   - Enter `Leopard` as correct Password to decrypt the file. (`Leopard` is just the password not the Decryption key)
   - If you enter an incorrect key, the file will be "deleted" (simulated).

### Example:

- Running the ransomware simulation will encrypt the dummy `TargetFile.txt`, and you will see progress updates on the screen.
- After encryption, the program will ask for a decryption key. Enter `Leopard` to decrypt and retrieve the original file.
- If an incorrect key is provided, the file will be deleted (simulated).

## Important Notes

- **Educational Purposes Only:** This project is designed to demonstrate basic ransomware functionality and file encryption/decryption techniques. It should never be used on actual systems or real files.
- **File Deletion Warning:** The program simulates file deletion in case of an incorrect key input. Ensure you're testing on non-essential files, and never run the code on valuable data.
- **Do Not Use on Critical Systems:** This project is intended for research, learning, and testing purposes only. **It is not safe to run this code on important files or systems**.

## License

This project is licensed under the **MIT License**. You are free to modify, distribute, and use this project for educational purposes.
