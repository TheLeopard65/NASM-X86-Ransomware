nasm -f elf32 -o .32.o ransomware.asm
ld -m elf_i386 -s -o ransomware .32.o
chmod +x ./ransomware
