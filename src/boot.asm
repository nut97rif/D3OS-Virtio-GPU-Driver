%include "src/constants.asm"

[EXTERN ___BSS_START__]
[EXTERN ___BSS_END__]

[EXTERN ___KERNEL_DATA_START__]
[EXTERN ___KERNEL_DATA_END__]
[EXTERN start]

; %define TEXT_MODE

; Multiboot constants
MUTLIBOOT_EAX_MAGIC equ 0x36d76289
MULTIBOOT_HEADER_MAGIC equ 0xe85250d6
MULTIBOOT_HEADER_ARCHITECTURE equ 0
MULTIBOOT_HEADER_LENGTH equ (multiboot_header_end - multiboot_header)
MULTIBOOT_HEADER_CHECKSUM equ -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_ARCHITECTURE + MULTIBOOT_HEADER_LENGTH)

; Multiboot tag types
MULTIBOOT_TAG_TERMINATE equ 0
MULTIBOOT_TAG_INFORMATION_REQUEST equ 1
MULTIBOOT_TAG_ADDRESS equ 2
MULTIBOOT_TAG_ENTRY_ADDRESS equ 3
MULTIBOOT_TAG_FLAGS equ 4
MULTIBOOT_TAG_FRAMEBUFFER equ 5
MULTIBOOT_TAG_MODULE_ALIGNMENT equ 6
MULTIBOOT_TAG_EFI_BOOT_SERVICES equ 7
MULTIBOOT_TAG_EFI_I386_ENTRY_ADDRESS equ 8
MULTIBOOT_TAG_EFI_AMD64_ENTRY_ADDRESS equ 9
MULTIBOOT_TAG_RELOCATABLE_HEADER equ 10

; Multiboot request types
MULTIBOOT_REQUEST_BOOT_COMMAND_LINE equ 1
MULTIBOOT_REQUEST_BOOT_LOADER_NAME equ 2
MULTIBOOT_REQUEST_MODULE equ 3
MULTIBOOT_REQUEST_BASIC_MEMORY_INFORMATION equ 4
MULTIBOOT_REQUEST_BIOS_BOOT_DEVICE equ 5
MULTIBOOT_REQUEST_MEMORY_MAP equ 6
MULTIBOOT_REQUEST_VBE_INFO equ 7
MULTIBOOT_REQUEST_FRAMEBUFFER_INFO equ 8
MULTIBOOT_REQUEST_ELF_SYMBOLS equ 9
MULTIBOOT_REQUEST_APM_TABLE equ 10
MULTIBOOT_REQUEST_EFI_32_BIT_SYSTEM_TABLE_POINTER equ 11
MULTIBOOT_REQUEST_EFI_64_BIT_SYSTEM_TABLE_POINTER equ 12
MULTIBOOT_REQUEST_SMBIOS_TABLES equ 13
MULTIBOOT_REQUEST_ACPI_OLD_RSDP equ 14
MULTIBOOT_REQUEST_ACPI_NEW_RSDP equ 15
MULTIBOOT_REQUEST_NETWORKING_INFORMATION equ 16
MULTIBOOT_REQUEST_EFI_MEMORY_MAP equ 17
MULTIBOOT_REQUEST_EFI_BOOT_SERVICES_NOT_TERMINATED equ 18
MULTIBOOT_REQUEST_EFI_32_BIT_IMAGE_HANDLE_POINTER equ 19
MULTIBOOT_REQUEST_EFI_64_BIT_IMAGE_HANDLE_POINTER equ 20
MULTIBOOT_REQUEST_IMAGE_LOAD_BASE_PHYSICAL_ADDRESS equ 21

; Multiboot tag flags
MULTIBOOT_TAG_FLAG_OPTIONAL equ 0x01

; Multiboot console flags
MULTIBOOT_CONSOLE_FLAG_FORCE_TEXT_MODE equ 0x01
MULTIBOOT_CONSOLE_FLAG_SUPPORT_TEXT_MODE equ 0x02

; Multiboot framebuffer options
%ifdef TEXT_MODE
   MULTIBOOT_GRAPHICS_MODE    equ 1
   MULTIBOOT_GRAPHICS_WIDTH   equ 80
   MULTIBOOT_GRAPHICS_HEIGHT  equ 25
   MULTIBOOT_GRAPHICS_BPP     equ 0
%else
   MULTIBOOT_GRAPHICS_MODE   equ 0
   MULTIBOOT_GRAPHICS_WIDTH  equ 800
   MULTIBOOT_GRAPHICS_HEIGHT equ 600
   MULTIBOOT_GRAPHICS_BPP    equ 32
%endif

[SECTION .text]
[BITS 64]

multiboot_header:
    ; Header
    align 8
    dd MULTIBOOT_HEADER_MAGIC
    dd MULTIBOOT_HEADER_ARCHITECTURE
    dd MULTIBOOT_HEADER_LENGTH
    dd MULTIBOOT_HEADER_CHECKSUM

    ; Address tag
    align 8
    dw MULTIBOOT_TAG_ADDRESS
    dw MULTIBOOT_TAG_FLAG_OPTIONAL
    dd 24
    dd (multiboot_header)
    dd (___KERNEL_DATA_START__)
    dd (___KERNEL_DATA_END__)
    dd (___BSS_END__)

    ; EFI amd64 Entry address tag
    align 8
    dw MULTIBOOT_TAG_EFI_AMD64_ENTRY_ADDRESS
    dw MULTIBOOT_TAG_FLAG_OPTIONAL
    dd 12
    dd (start)

    ; EFI boot services tag
    align 8
    dw MULTIBOOT_TAG_EFI_BOOT_SERVICES
    dw MULTIBOOT_TAG_FLAG_OPTIONAL
    dd 8

    ; Information request tag (required)
    align 8
    dw MULTIBOOT_TAG_INFORMATION_REQUEST
    dw 0
    dd 36
    dd MULTIBOOT_REQUEST_BOOT_LOADER_NAME
    dd MULTIBOOT_REQUEST_BOOT_COMMAND_LINE
    dd MULTIBOOT_REQUEST_MODULE
    dd MULTIBOOT_REQUEST_MEMORY_MAP
    dd MULTIBOOT_REQUEST_FRAMEBUFFER_INFO
    dd MULTIBOOT_REQUEST_ACPI_OLD_RSDP
    dd MULTIBOOT_REQUEST_ACPI_NEW_RSDP

    ; Framebuffer tag
    align 8
    dw MULTIBOOT_TAG_FRAMEBUFFER
    dw 0
    dd 20
    dd MULTIBOOT_GRAPHICS_WIDTH
    dd MULTIBOOT_GRAPHICS_HEIGHT
    dd MULTIBOOT_GRAPHICS_BPP

    ; Module alignment tag
    align 8
    dw MULTIBOOT_TAG_MODULE_ALIGNMENT
    dw MULTIBOOT_TAG_FLAG_OPTIONAL
    dd 8

    ; Termination tag
    align 8
    dw MULTIBOOT_TAG_TERMINATE
    dw 0
    dd 8
multiboot_header_end: