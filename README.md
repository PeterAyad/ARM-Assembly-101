# ARM Assembly

<img alt="arm" src="img/arm.png" width="700">

- [ARM Assembly](#arm-assembly)
  - [Introduction](#introduction)
  - [Disclaimer](#disclaimer)
  - [Prerequisites](#prerequisites)
  - [Code Structure](#code-structure)
    - [Data Types in ARM Assembly](#data-types-in-arm-assembly)
    - [Important Notations](#important-notations)
    - [ARM Instructions](#arm-instructions)
    - [Differences Between ARM and x86 Assembly](#differences-between-arm-and-x86-assembly)
    - [Addressing Modes](#addressing-modes)
    - [General Code Structure](#general-code-structure)
    - [Bit Operations and Bitmasking in ARM Assembly](#bit-operations-and-bitmasking-in-arm-assembly)
      - [Understanding Bit Operations](#understanding-bit-operations)
      - [Bitmasking](#bitmasking)
        - [Bitmask](#bitmask)
        - [1. ORR (Logical OR) - Setting a Bit](#1-orr-logical-or---setting-a-bit)
        - [2. BIC (Bit Clear) - Clearing a Bit](#2-bic-bit-clear---clearing-a-bit)
        - [3. BFI (Bit Field Insert) - Inserting a Bit Field (ARMv7 and Later)](#3-bfi-bit-field-insert---inserting-a-bit-field-armv7-and-later)
        - [4. BFC (Bit Field Clear) - Clearing a Bit Field (ARMv7 and Later)](#4-bfc-bit-field-clear---clearing-a-bit-field-armv7-and-later)
        - [5. TST (Test Bit) - Checking if a Bit is Set](#5-tst-test-bit---checking-if-a-bit-is-set)
        - [6. LSR (Logical Shift Right) - Reading a Specific Bit](#6-lsr-logical-shift-right---reading-a-specific-bit)
      - [Summary of Bit Operations](#summary-of-bit-operations)
  - [Hardware Refresher](#hardware-refresher)
    - [Hardware Introduction](#hardware-introduction)
    - [Microcontrollers](#microcontrollers)
      - [STM32F407VG (EasyMX) Port Registers](#stm32f407vg-easymx-port-registers)
        - [STM32F407VG: Mode Register](#stm32f407vg-mode-register)
        - [STM32F407VG: Output Type Register](#stm32f407vg-output-type-register)
        - [STM32F407VG: Output Speed Register](#stm32f407vg-output-speed-register)
        - [STM32F407VG: Pull-up / Pull-down Register](#stm32f407vg-pull-up--pull-down-register)
        - [STM32F407VG Data Registers: Output Register and Input Register](#stm32f407vg-data-registers-output-register-and-input-register)
      - [STM32F103C6 (Blue Pill) Port Registers](#stm32f103c6-blue-pill-port-registers)
        - [STM32F103C6: Configuration Register Low and Configuration Register High](#stm32f103c6-configuration-register-low-and-configuration-register-high)
        - [STM32F103C6 Data Registers: Output Register and Input Register](#stm32f103c6-data-registers-output-register-and-input-register)
    - [Initialization](#initialization)
    - [GPIO Registers in STM32F407VG](#gpio-registers-in-stm32f407vg)
    - [GPIO Registers in STM32F103C6](#gpio-registers-in-stm32f103c6)
    - [Clock](#clock)
      - [Example](#example)
    - [TFT LCDs](#tft-lcds)
    - [Interfacing Between STM32 and TFT Display](#interfacing-between-stm32-and-tft-display)
    - [8080 Parallel Interface](#8080-parallel-interface)
      - [Pin Configuration](#pin-configuration)
      - [Write Cycle](#write-cycle)
      - [Read Cycle](#read-cycle)
    - [Display Initialization](#display-initialization)
    - [Drawing](#drawing)
      - [Steps to Draw on the TFT Screen](#steps-to-draw-on-the-tft-screen)
  - [Preparing Simulation Environment](#preparing-simulation-environment)
    - [Proteus Installation](#proteus-installation)
      - [Using Proteus](#using-proteus)
    - [Keil Installation](#keil-installation)
      - [Project Creation](#project-creation)
  - [Preparing Hardware Environment](#preparing-hardware-environment)
    - [EasyMX Driver Installation](#easymx-driver-installation)
    - [Flashing](#flashing)
  - [Examples](#examples)
    - [Simulation](#simulation)
      - [Blinking LEDs](#blinking-leds)
      - [LED on Button Press](#led-on-button-press)
      - [Filling the TFT Display with Color](#filling-the-tft-display-with-color)
      - [Drawing Image on the TFT Display](#drawing-image-on-the-tft-display)
    - [Hardware](#hardware)
      - [LED Blink](#led-blink)
      - [Button-Triggered LED](#button-triggered-led)
      - [Fill Screen With Single Color](#fill-screen-with-single-color)
      - [Draw Image On Screen](#draw-image-on-screen)

## Introduction

In this guide, I aim to explain how to write, compile, and test ARM Assembly code. I am writing code using **Keil MDK** (of course, you can use `STM32CubeIDE` or any other IDE). I am testing the code using simulation first (with `Proteus`), then on hardware (using `EasyMX Pro v7 for STM`).  

I am writing for both the `BluePill STM32F103C6` and the `EasyMX STM32F407VG` interchangeably, as they are quite similar. I chose the `BluePill STM32F103C6` because it is the most popular `STM32` microcontroller and the `EasyMX STM32F407VG` because I have it.  

## Disclaimer

Proteus is a commercial software that requires a valid license for use. It is not free and must be purchased from the official vendors. I do not support or encourage software piracy or any unethical methods to acquire or use Proteus illegally. Please ensure you are using a legitimate copy of the software in compliance with its licensing terms.  

Using Proteus is **not mandatory**; it is just an option for simulation. If you are unable to purchase Proteus, you can consider buying an **STM32 Blue Pill** development board, which is an affordable alternative for testing and running STM32 projects on real hardware.

## Prerequisites  

I assume you have prior experience with **x86 Assembly programming**. You may need the following datasheets:

- [STM32F407](https://www.st.com/resource/en/reference_manual/dm00031020-stm32f405-415-stm32f407-417-stm32f427-437-and-stm32f429-439-advanced-arm-based-32-bit-mcus-stmicroelectronics.pdf)
- [STM32F103](https://www.st.com/resource/en/reference_manual/rm0008-stm32f101xx-stm32f102xx-stm32f103xx-stm32f105xx-and-stm32f107xx-advanced-armbased-32bit-mcus-stmicroelectronics.pdf)
- [ILI9341](https://download.mikroe.com/documents/smart-displays/easytft/ILI9341-ILITEK.pdf)

and the ARM Cortex M3 Instructions List:

- [ARM Instructions](https://os.mbed.com/media/uploads/4180_1/cortexm3_instructions.htm)

## Code Structure

### Data Types in ARM Assembly

| Directive | Size | Writable?       | Description                                                       |
| --------- | ---- | --------------- | ----------------------------------------------------------------- |
| `EQU`     | N/A  | No              | Defines a **constant value**                                      |
| `DCB`     | 1B   | Depends on Area | **Define a Byte**                                                 |
| `DCW`     | 2B   | Depends on Area | **Define a Word**                                                 |
| `DCD`     | 4B   | Depends on Area | **Define a Doubleword**                                           |
| `DCQ`     | 8B   | Depends on Area | **Define a Quadword**                                             |
| `SPACE`   | N    | Depends on Area | Reserves **N bytes** of memory without initialization.            |
| `FILL`    | N    | Depends on Area | Reserves **N bytes** and initializes them with a specified value. |

### Important Notations

1. Parentheses (`()`)

   - Used for syntax readability. Neglected by the compiler.

2. Immediate Values (`#`)  

   - `#` is used for immediate values and constants in instructions like `MOV`, `ADD`, etc.  
   - Example:  

     ```assembly
     MOV R0, #2        ; Move the immediate value 2 into R0
     MOV R0, #(1 << 4) ; Move 16 (1 shifted left by 4) into R0

     myConstant EQU 4
     MOV R0, #myConstant
     ```

3. Variables with `LDR` (`=`)  

   - `LDR` with `=` allows loading (large immediate values - constant values - address of a variable).  
   - Example:  

     ```assembly
     LDR R0, =0xFFFFFF      ; Load the large immediate value 0xFFFFFF into R0
     LDR R0, =0xFFF + 0x5   ; Load 0x1004 into R0

     myConstant EQU 4
     LDR R0, =myConstant    ; Loads 4 into R0
     
     myVariable DCB 5
     LDR R0, =myVariable    ; Loads address of myVariable into R0 (needs another load to get 5)
     ```
  
4. Dereferencing with `[...]`  

   - Used for accessing memory via registers.  
   - Example:  

     ```assembly
     STR R0, [R1]      ; Store R0 at the address in R1
     LDR R0, [R1, #4]  ; Load R0 from memory at R1+4
     ```

5. Auto-Update (`!` and Post-Increment/Decrement)  

   - `!` updates the base register immediately.  
   - Example:  

     ```assembly
     LDR R0, [R1, #4]!  ; Load R0 from R1+4, then update R1 to R1+4
     STR R0, [R1], #4   ; Store R0 at R1, then increment R1 by 4
     ```

6. Comments (`;` or `@`)  

   - `;` for comments (or `@` in unified syntax).  
   - Example:  

     ```assembly
     MOV R0, #5  ; This is a comment
     MOV R1, #10 @ Another comment in unified syntax
     ```

### ARM Instructions

`<imm/cnst>` = immediate values or constants

`<var>` = variable

| **Operation**                  | **ARM Assembly**          | **x86 Assembly**     | **Description**                               |
| ------------------------------ | ------------------------- | -------------------- | --------------------------------------------- |
| **Move Data**                  | `MOV R0, R1`              | `MOV AX, BX`         | Move data between registers                   |
| **Load Immediate or Constant** | `MOV R0, #<imm/cnst>`     | `MOV AX, <imm/cnst>` | Load an immediate or a Constant               |
| **Load Immediate or Constant** | `LDR R0, =<imm/cnst>`     | `MOV AX, <imm/cnst>` | Load an immediate or a Constant to register   |
| **Load Address of Variable**   | `LDR R0, =<var>`          | `LEA AX, <var>`      | Load address of a variable to register        |
| **Load from Memory**           | `LDR R0, [R1]`            | `MOV AX, [BX]`       | Load a word from memory                       |
| **Store to Memory**            | `STR R0, [R1]`            | `MOV [BX], AX`       | Store a word to memory                        |
| **Addition**                   | `ADD R0, R1, R2`          | `ADD AX, BX`         | Add two registers                             |
| **Addition**                   | `ADD R0, R1, #<imm/cnst>` | `ADD AX, <imm/cnst>` | Add using Immediate or Constant               |
| **Subtraction**                | `SUB R0, R1, R2`          | `SUB AX, BX`         | Subtract two registers                        |
| **Subtraction**                | `SUB R0, R1, #<imm/cnst>` | `SUB AX, <imm/cnst>` | Subtract using Immediate or Constant          |
| **Multiplication**             | `MUL R0, R1, R2`          | `MUL BX`             | Multiply (ARM: 3-operand, x86: implicit `AX`) |
| **Bitwise AND**                | `AND R0, R1, R2`          | `AND AX, BX`         | Logical AND                                   |
| **Bitwise AND**                | `AND R0, R1, #<imm/cnst>` | `AND AX, <imm/cnst>` | Logical AND                                   |
| **Bitwise OR**                 | `ORR R0, R1, R2`          | `OR AX, BX`          | Logical OR                                    |
| **Bitwise OR**                 | `ORR R0, R1, #<imm/cnst>` | `OR AX, <imm/cnst>`  | Logical OR                                    |
| **Bitwise XOR**                | `EOR R0, R1, R2`          | `XOR AX, BX`         | Logical XOR                                   |
| **Bitwise XOR**                | `EOR R0, R1, #<imm/cnst>` | `XOR AX, <imm/cnst>` | Logical XOR                                   |
| **Bit clear**                  | `BIC R0, R1, #<imm/cnst>` | -                    | Clear bits in Op1 in 1s locations in Op2      |
| **Shift Left**                 | `LSL R0, R1, R2`          | `SHL AX, BX`         | Logical shift left                            |
| **Shift Left**                 | `LSL R0, R1, #<imm/cnst>` | `SHL AX, <imm/cnst>` | Logical shift left                            |
| **Shift Right**                | `LSR R0, R1, R2`          | `SHR AX, BX`         | Logical shift right                           |
| **Shift Right**                | `LSR R0, R1, #<imm/cnst>` | `SHR AX, <imm/cnst>` | Logical shift right                           |
| **Branch (Jump)**              | `B label`                 | `JMP label`          | Unconditional jump                            |
| **Branch if Zero**             | `BEQ label`               | `JE label`           | Jump if equal (zero flag set)                 |
| **Binary Test**                | `TST R0, R1`              | `TEST AX, BX`        | Compare two registers (with AND)              |
| **Compare**                    | `CMP R0, R1`              | `CMP AX, BX`         | Compare two registers (with subtraction)      |
| **Function Call**              | `BL function`             | `CALL function`      | Call a function                               |
| **Function Return**            | `BX LR`                   | `RET`                | Return from function                          |
| **Push to Stack**              | `PUSH {R0}`               | `PUSH AX`            | Push register to stack                        |
| **Push All to Stack**          | `PUSH {R0-R12, LR}`       | `PUSHA`              | Push all registers to stack                   |
| **Pop from Stack**             | `POP {R0}`                | `POP AX`             | Pop register from stack                       |
| **Pop All from Stack**         | `POP {R0-R12, LR}`        | `POPA`               | Pop all registers from stack                  |
| **No Operation**               | `NOP`                     | `NOP`                | No operation                                  |

### Differences Between ARM and x86 Assembly  

1. **Register Naming**  
   - ARM does **not** have named registers like x86 (`EAX`, `EBX`, etc.). Instead, it uses numbered registers: `R0` → `R15`.  

2. **Operand Order**  
   - In x86, the **first operand is the destination**.  
   - In ARM, the **destination must be explicitly written**, as instructions use three operands:  

     ```assembly
     {Instruction} {destination} {op1} {op2}
     ```

3. **Memory Access**  
   - ARM does **not** support direct `MOV` between registers and memory.  
   - Instead, it uses **Load (`LDR`)** and **Store (`STR`)** instructions.  

4. **Data, Code, and Stack Sections**  
   - In x86 Assembly, sections are declared as `.data .code .stack`.  
   - In ARM, they are defined using the `AREA` directive:  

     ```assembly
     AREA <Area Name>, [CODE/DATA], [READONLY/READWRITE]
     ```

     - ARM assembly can have multiple **code areas** but always starts from `main`.  
     - Some assemblers allow writing **data inside code sections**.  
     - `READONLY` areas are stored in flash memory (non-writable at runtime).  
     - `READWRITE` areas are stored in RAM.  

5. **Return Address in ARM**  
   - In ARM, the **return address** is stored in the `Link Register (LR)`, also called **Link**.  
   - Unlike x86, `LR` is **not** the instruction pointer. Instead:  
     - `PC (Program Counter)` is the **actual instruction pointer**.  
     - `LR (Link Register)` stores the return address when a function is called.  

6. **Function Calls and Returns**  
   - x86 has `CALL` and `RET` instructions.  
   - ARM **does not** have `CALL` and `RET`. Instead, it uses:  
     - `BL` (Branch and Link) for function calls.  
     - `BX LR` (Branch Exchange) for returning.  

     ```assembly
     BL my_function   ; Calls my_function, storing return address in LR
     BX LR            ; Returns to the caller
     ```

7. **Procedures and Functions in ARM**  
   - In ARM Assembly:  
     - **Procedures** perform actions but may not return a value.  
     - **Functions** return a value.  
     - **All functions are procedures, but not all procedures are functions.**  

     **Example: Procedure (No return value)**  

     ```assembly
     procedure_example:
         PUSH {R4, LR}   ; Save R4 and LR
         MOV R0, #5      ; Example operation
         MOV R1, #10     ; Another operation
         POP {R4, LR}    ; Restore R4 and LR
         BX LR           ; Return to caller
     ```

     **Example: Function (Returns a value)**  

     ```assembly
     function_example:
         PUSH {R4, LR}   ; Save R4 and LR
         MOV R4, #20
         ADD R0, R0, R4  ; Modify R0
         MOV R0, #10     ; Return value
         POP {R4, LR}    ; Restore R4 and LR
         BX LR           ; Return to caller
     ```

8. **Case Sensitivity and Indentation**  
   - ARM Assembly **is case-sensitive**.  
   - Unlike x86, **labels in ARM do not use colons (`:`)** but **must start at the beginning of a line**.  

9. **Using External Functions in ARM**  
   - To use functions from another file:  

     ```assembly
     EXPORT <function_name>  ; Export function for external use
     INCLUDE <filename>      ; Include another assembly file
     ```

10. **Program Termination**  
    - `END MAIN` in x86 Assembly is simply written as `END` in ARM.  

11. **Unified Syntax**  
    - ARM supports an alternative syntax called `.syntax unified`, which is different from traditional ARM assembly.  

### Addressing Modes

| Addressing Mode                  | Example                                                                               |
| -------------------------------- | ------------------------------------------------------------------------------------- |
| **Immediate Addressing**         | `MOV r0, #10` (Load immediate value `10` into `r0`).                                  |
| **Register Addressing**          | `MOV r1, r2` (Copy value of `r2` into `r1`).                                          |
| **Register Indirect Addressing** | `LDR r0, [r1]` (Load value from memory at address in `r1` into `r0`).                 |
| **Pre-Indexed Addressing**       | `LDR r0, [r1, #4]` (Load value from `r1 + 4` into `r0`).                              |
| **Post-Indexed Addressing**      | `LDR r0, [r1], #4` (Load value from `r1`, then increment `r1` by 4).                  |
| **Scaled Register Addressing**   | `LDR r0, [r1, r2, LSL #2]` (Load from `r1 + (r2 × 4)`).                               |
| **PC-Relative Addressing**       | `LDR r0, =variable` (Assembler generates `LDR r0, [PC, #offset]`).                    |
| **Stack Addressing (Push/Pop)**  | `PUSH {r0, r1}` (Store `r0` and `r1` on stack), `POP {r0}` (Restore `r0` from stack). |

### General Code Structure

ARM's startup code (provided by STMicroelectronics) calls the `__main` function, which should contain all your code.

```assembly
    EXPORT __main

    AREA MYDATA, DATA, READWRITE  ; Read-Write data section (written to RAM)

    ; Data

    AREA MYCODE, CODE, READONLY ; Read-only data section (written to flash or ROM)
        
__main FUNCTION

    ; Code
    
    ENDFUNC
    
    END
```

### Bit Operations and Bitmasking in ARM Assembly

<img alt="bitMasking" src="img/bitMasking.png" width="300">

#### Understanding Bit Operations

Bit operations allow us to manipulate individual bits in registers, which is essential in embedded programming when dealing with hardware registers, flags, and memory-mapped I/O.

Each bit in a register can represent an **ON (1)** or **OFF (0)** state. We use bitwise operations to modify specific bits without affecting others.

#### Bitmasking

Bitmasking is a technique where we use a binary pattern (mask) to **set**, **clear**, or **test** specific bits in a value while leaving others unchanged.

For example:

- **Setting a bit** → Force a bit to 1.
- **Clearing a bit** → Force a bit to 0.
- **Testing a bit** → Test if a specific bit is set or cleared.

##### Bitmask

A **bitmask** is a constant used to modify specific bits in a register.

```assembly
; define bitmask as 1 shifted to the required bit location
TFT_WR          EQU     (1 << 3)     ; equivalent to 0x08
; use bitmask
ORR R2, R2, #TFT_WR                 ; sets bit 3 in R2
```

ARM provides several instructions for bit manipulation:

##### 1. ORR (Logical OR) - Setting a Bit

The `ORR` (Logical OR) instruction is used to **set** (turn ON) specific bits while keeping others unchanged.

**Syntax:**

```assembly
ORR Rd, Rn, #bit_mask
```

- `Rd` → Destination register.
- `Rn` → Source register.
- `bit_mask` → Bit pattern to set.

Example: Set bit 3 in R0

```assembly
MOV R0, #0x00       ; R0 = 0b00000000
ORR R0, R0, #(1 << 3)  ; R0 = 0b00001000 (bit 3 set)
```

##### 2. BIC (Bit Clear) - Clearing a Bit

The `BIC` (Bit Clear) instruction is used to **clear** (turn OFF) specific bits.

**Syntax:**

```assembly
BIC Rd, Rn, #bit_mask
```

- `bit_mask` → Defines which bits to clear (set to 0).

Example: Clear bit 3 in R0

```assembly
MOV R0, #0xFF       ; R0 = 0b11111111
BIC R0, R0, #(1 << 3)  ; R0 = 0b11110111 (bit 3 cleared)
```

##### 3. BFI (Bit Field Insert) - Inserting a Bit Field (ARMv7 and Later)

The `BFI` (Bit Field Insert) instruction allows inserting a value into specific bit positions.

**Note:** This instruction is available only in ARMv7 (Cortex-M3 and later). If targeting older cores (e.g., Cortex-M0), use `BIC` and `ORR` instead.

**Syntax:**

```assembly
BFI Rd, Rn, #lsb, #width
```

- `Rd` → Destination register.
- `Rn` → Source value.
- `lsb` → Least Significant Bit position to insert the value.
- `width` → Number of bits to insert.

Example: Insert 3-bit value (0b101) at bit position 4

```assembly
MOV R0, #0x00       ; R0 = 0b00000000
MOV R1, #0x05       ; R1 = 0b00000101 (value 5)
BFI R0, R1, #4, #3  ; R0 = 0b00010100 (insert at bit 4)
```

##### 4. BFC (Bit Field Clear) - Clearing a Bit Field (ARMv7 and Later)

The `BFC` (Bit Field Clear) instruction clears a **range of bits**.

**Note:** This instruction is available only in ARMv7 (Cortex-M3 and later). If targeting older cores, use `BIC` instead.

**Syntax:**

```assembly
BFC Rd, #lsb, #width
```

- `lsb` → Least Significant Bit position to clear.
- `width` → Number of bits to clear.

Example: Clear 3 bits starting from bit 4

```assembly
MOV R0, #0xFF       ; R0 = 0b11111111
BFC R0, #4, #3      ; R0 = 0b11100011 (cleared bits 4-6)
```

##### 5. TST (Test Bit) - Checking if a Bit is Set

The `TST` (Test) instruction is used to check if a specific bit is set.

**Syntax:**

```assembly
TST Rn, #bit_mask
```

- `Rn` → Register to test.
- `bit_mask` → Bit pattern to test.

Example: Check if bit 3 is set in R0

```assembly
AND R0, #(1 << 3)   ; Clear all bit but bit 3
TST R0, #(1 << 3)   ; Check if bit 3 is set
BEQ bit_not_set     ; If zero flag is set, bit 3 is not set
B bit_set           ; Otherwise, bit 3 is set
```

##### 6. LSR (Logical Shift Right) - Reading a Specific Bit

The `LSR` (Logical Shift Right) instruction can be used to extract a specific bit by shifting it to the least significant position.

**Syntax:**

```assembly
LSR Rd, Rn, #shift_amount
```

- `Rd` → Destination register.
- `Rn` → Source register.
- `shift_amount` → Number of bits to shift right.

Example: Read bit 3 of R0 and store it in R1 (0 or 1)

```assembly
LSR R1, R0, #3  ; Shift bit 3 to position 0
AND R1, R1, #1  ; Clear other bits, keeping only bit 3
```

#### Summary of Bit Operations

| Instruction | Purpose                                  | Example                                             |
| ----------- | ---------------------------------------- | --------------------------------------------------- |
| `ORR`       | Set a bit                                | `ORR R0, R0, #(1 << 3)` (Set bit 3)                 |
| `BIC`       | Clear a bit                              | `BIC R0, R0, #(1 << 3)` (Clear bit 3)               |
| `BFI`       | Insert a value into a bit field (ARMv7+) | `BFI R0, R1, #4, #3` (Insert 3-bit value at bit 4)  |
| `BFC`       | Clear a range of bits (ARMv7+)           | `BFC R0, #4, #3` (Clear 3 bits starting from bit 4) |
| `TST`       | Test if a bit is set                     | `TST R0, #(1 << 3)` (Check bit 3)                   |
| `LSR`       | Extract a specific bit                   | `LSR R1, R0, #3` (Extract bit 3)                    |

## Hardware Refresher

### Hardware Introduction  

Most microcontrollers, such as `STM32`, `ESP`, and `AVR (Arduino)`, operate with similar concepts. Here, we will review some of these concepts to help you understand how our code will work.  

### Microcontrollers  

<img alt="microcontrollers" src="img/microcontrollers.png" width="700">

Most microcontroller boards have external pins to connect them to other devices. To use these pins, we must:  

1. Configure which pins are used as outputs and which as inputs.  
2. Configure whether input pins have pull-up or pull-down resistors.  
3. Write to output pins.  
4. Read from input pins.  
5. Apply any other needed configurations.  

All these configurations are stored in registers. Every group of pins is called a **Port**, and each port has a set of registers for configuring its pins.  

For example, the `STM32F407VG` has **five ports** while `STM32F103C6` has **two ports**. Each port has **control registers** and **data registers**.  

#### STM32F407VG (EasyMX) Port Registers

**Control Registers:**  

- `GPIOx_MODER` – Selects the I/O direction.  
- `GPIOx_OTYPER` – Selects the output type (push-pull or open-drain).  
- `GPIOx_OSPEEDR` – Selects the pin speed.  
- `GPIOx_PUPDR` – Selects the pull-up/pull-down configuration.  

**Data Registers:**  

- `GPIOx_IDR` – Stores input data (read-only).  
- `GPIOx_ODR` – Stores output data (read/write).  

##### STM32F407VG: Mode Register  

<img alt="GPIO_MODER" src="img/GPIO_MODER.png" width="700">

Each port pin is associated with **two bits** in the mode register:  

- `00` – Input mode  
- `01` – Output mode  
- `10` – Alternate function mode  
- `11` – Analog mode

##### STM32F407VG: Output Type Register  

<img alt="GPIOx_OTYPER" src="img/GPIOx_OTYPER.png" width="700">

This register configures output pins as either **push-pull** or **open-drain**:  

- `0` – Push-pull  
- `1` – Open-drain  

##### STM32F407VG: Output Speed Register  

<img alt="GPIOx_OSPEEDR" src="img/GPIOx_OSPEEDR.png" width="700">

This register determines the maximum switching speed of the port pins:  

- `00` – Low speed (2 MHz to 8 MHz)  
- `01` – Medium speed (12.5 MHz to 50 MHz)  
- `10` – High speed (25 MHz to 100 MHz)  
- `11` – Very high speed (50 MHz to 180 MHz)  

##### STM32F407VG: Pull-up / Pull-down Register  

<img alt="GPIO_PUPDR" src="img/GPIO_PUPDR.png" width="700">

This register configures the internal pull-up or pull-down resistors for each pin:  

- `00` – No pull-up / pull-down  
- `01` – Pull-up  
- `10` – Pull-down  
- `11` – Reserved  

##### STM32F407VG Data Registers: Output Register and Input Register  

<img alt="GPIO_IDR" src="img/GPIO_IDR.png" width="700">
<img alt="GPIO_ODR" src="img/GPIO_ODR.png" width="700">

These registers store the state of the GPIO pins, where:  

- `1` – ON (High)  
- `0` – OFF (Low)  

#### STM32F103C6 (Blue Pill) Port Registers

**Control Registers:**  

- `GPIOx_CRL` – Selects the I/O direction.  
- `GPIOx_CRH` – Selects the output type (push-pull or open-drain).  

**Data Registers:**  

- `GPIOx_IDR` – Stores input data (read-only).  
- `GPIOx_ODR` – Stores output data (read/write).  

##### STM32F103C6: Configuration Register Low and Configuration Register High

`GPIOx_CRL` controls the configuration of pins **0 to 7** of the corresponding GPIO port.

<img alt="blue_pill_GPIOx_CRL" src="img/blue_pill_GPIOx_CRL.png" width="700">

`GPIOx_CRH` controls the configuration of pins **8 to 15** of the corresponding GPIO port.  

<img alt="blue_bill_GPIOx_CRH" src="img/blue_bill_GPIOx_CRH.png" width="700">

Each pin is associated with **four bits** in these register:  

- Lower two bits **MODE[1:0]** defines the operating mode (and speed) of the pin:  
  - `00` – Input mode  
  - `01` – Output mode (Max speed 10 MHz)  
  - `10` – Output mode (Max speed 2 MHz)  
  - `11` – Output mode (Max speed 50 MHz)  

- Higher two bits **CNF[1:0]** configures the function of the pin based on the mode:  
  - **Input mode (`MODE = 00`)**:  
    - `00` – Analog input  
    - `01` – Floating input  
    - `10` – Input with pull-up/pull-down resistors (`GPIOx_ODR` is used in this case: `0` for pull-down, `1` for pull-up)
    - `11` – Reserved  
  - **Output mode (`MODE ≠ 00`)**:  
    - `00` – General-purpose push-pull  
    - `01` – General-purpose open-drain  
    - `10` – Alternate function push-pull  
    - `11` – Alternate function open-drain  

##### STM32F103C6 Data Registers: Output Register and Input Register  

<img alt="blue_pill_GPIOx_IDR" src="img/blue_pill_GPIOx_IDR.png" width="700">
<img alt="blue_pill_GPIOx_ODR" src="img/blue_pill_GPIOx_ODR.png" width="700">

These registers store the state of the GPIO pins, where:  

- `1` – ON (High)  
- `0` – OFF (Low)  

### Initialization

All registers are memory-mapped (accessed using `LDR` and `STR`).

Note: In ARM Assembly, we can easily add base to offset to get register address using `+` sign:

```Assembly
; Define register base addresses
GPIOA_BASE      EQU     0x40010800

; Define register offsets
GPIO_ODR        EQU     0x0C

; Code
LDR R1, =GPIOA_BASE + GPIO_ODR
```

Instead of

```assembly
; define base and offset
GPIOB_BASE      EQU     0x40010C00
GPIO_ODR        EQU     0x0C
; read register
LDR R1, =GPIOB_BASE
ADD R1, R1, #GPIO_ODR
```

### GPIO Registers in STM32F407VG  

```Assembly
; Define register base addresses
RCC_BASE        EQU     0x40023800
GPIOA_BASE      EQU     0x40020000
GPIOB_BASE      EQU     0x40020400
GPIOC_BASE      EQU     0x40020800
GPIOD_BASE      EQU     0x40020C00
GPIOE_BASE      EQU     0x40021000

; Define register offsets
RCC_AHB1ENR     EQU     0x30
GPIO_MODER      EQU     0x00
GPIO_OTYPER     EQU     0x04
GPIO_OSPEEDR    EQU     0x08
GPIO_PUPDR      EQU     0x0C
GPIO_IDR        EQU     0x10
GPIO_ODR        EQU     0x14
```

### GPIO Registers in STM32F103C6  

```Assembly
; Define register base addresses
RCC_BASE        EQU     0x40021000
GPIOA_BASE      EQU     0x40010800
GPIOB_BASE      EQU     0x40010C00

; Define register offsets
RCC_APB2ENR     EQU     0x18
GPIO_CRL        EQU     0x00
GPIO_CRH        EQU     0x04
GPIO_IDR        EQU     0x08
GPIO_ODR        EQU     0x0C
```

### Clock

To use any register, we must first enable the clock for the needed port. For `STM32F407VG` we need to enable corresponding port clock on register `RCC_AHB1ENR`:

<img alt="GPIO_Clock" src="img/GPIO_Clock.png" width="700">

while for `STM32F103C6` we need to enable corresponding port clock on register `RCC_APB2ENR`:

<img alt="blue_pill_GPIO_clock" src="img/blue_pill_GPIO_clock.png" width="700">

#### Example

```assembly
LDR    R1,  =RCC_BASE + RCC_AHB1ENR    ; Load address of clock register
LDR    R0,  [R1]                       ; Load value from clock register
ORR    R0,  R0,  #(1 << 3)                 
STR    R0,  [R1]                       ; Store updated value back to register
```

### TFT LCDs  

TFT LCDs are graphical displays capable of rendering colored frames pixel by pixel. In our examples, we will use the `ILI9341` TFT display because:  

- It supports multiple interface modes.  
- It is available in Proteus' default library.  
- It is widely available in the market.  
- It is included in the `EasyMX` kit.  

<img alt="ili9341" src="img/ili9341.png" width="400">

ILI9341 connections on EasyMX board:

```text
+--------- TFT ---------+
|      D0   ←  PE0      |
|      D1   ←  PE1      |
|      D2   ←  PE2      |
|      D3   ←  PE3      |
|      D4   ←  PE4      |
|      D5   ←  PE5      |
|      D6   ←  PE6      |
|      D7   ←  PE7      |
|-----------------------|
|      RST  ←  PE8      |
|      BCK  ←  PE9      |
|      RD   ←  PE10     |
|      WR   ←  PE11     |
|      RS   ←  PE12     |
|      CS   ←  PE15     |
+-----------------------+
     TFT with EasyMX
```

### Interfacing Between STM32 and TFT Display  

The way devices communicate with each other through pins (or wires) is called **interfacing**. Different displays support different **interface modes**.  

Most displays support `SPI` (**Serial Peripheral Interface**), which is widely used in electronics. However, since we are writing **ARM Assembly**, implementing `SPI` without libraries can be complex.  

Instead, we will use the **8080 Parallel Interface**, which is also supported by the `ILI9341` display. Although the `ILI9341` also supports `SPI`, we will not use it in this guide.  

### 8080 Parallel Interface

#### Pin Configuration

The 8080 protocol uses:  

- **8 data pins**: `D0 - D7`  
- **1 read pin**: `RD`  
- **1 write pin**: `WR`  
- **1 chip select pin**: `CS`  
- **1 reset pin**: `RST`  
- **1 data/control selection pin**: `RS` (also called `D/C`)  

> **Note:** `IM2/IM1/IM0` pins are used to set the interface mode in chips that support multiple interfaces.  

#### Write Cycle

- Data is read on the **rising edge** of the write signal (`WR`).  
- Commands are sent when `D/C` is **low**, and data is sent when `D/C` is **high**.  
- The write cycle works as follows:  

  1. Set `CS` **low**.  
  2. If sending a **command**, set `D/C` **low**.  
  3. Write data on `D0-D7`.  
  4. Set `WR` **low**.  
  5. If needed, add a **delay**.  
  6. Set `WR` **high**.  
  7. If needed, add a **delay**.  
  8. If a **command was sent**, set `D/C` **high**.  
  9. Set `CS` **high**.  

<img alt="parallelWriteCycle" src="img/parallelWriteCycle.png" width="700">  

#### Read Cycle

The read cycle is similar to the write cycle.  

<img alt="readCycle" src="img/readCycle.png" width="700">  

### Display Initialization

To initialize the display:  

1. Reset the display by setting the reset pin `RST` **low**.  
2. Hold (delay).  
3. Set the reset pin **high**.  
4. Write the **soft reset command** `0x01` (following the write cycle).  
5. Hold (delay).  
6. Write the **display off command** `0x28` (following the write cycle).  
7. Set the **pixel format** to **16-bit** by writing command `0x3A`, then writing data `0x55`.  
8. Send the **sleep out command** `0x11`.  
9. Hold (delay).  
10. Send the **display on command** `0x29`.  

### Drawing

In **16-bit pixel mode**, each pixel is represented by **16 bits (R:5-bit, G:6-bit, B:5-bit)**, allowing **65,536 colors**. Each pixel's data is sent in **two 8-bit transfers**.  

#### Steps to Draw on the TFT Screen

1. **Set the drawing window** from `(x1, y1)` to `(x2, y2)`:  
   - Write the **set X range command** `0x2A` (column address).  
   - Send the **start X coordinate** (write data **twice**, higher byte then lower byte).  
   - Send the **end X coordinate** (write data **twice**, higher byte then lower byte).  
   - Write the **set Y range command** `0x2B` (row/page address).  
   - Send the **start Y coordinate** (write data **twice**, higher byte then lower byte).  
   - Send the **end Y coordinate** (write data **twice**, higher byte then lower byte).  

2. **Send the pixel colors for the window**:  
   - Write the **memory write command** `0x2C` (indicates pixel data transmission).  
   - Loop through all pixels and send their color data (**write two times per pixel**, higher byte then lower byte).  

> **Note:** To set the color for a **single pixel**, set the window size to cover only that pixel’s dimensions.  

## Preparing Simulation Environment

### Proteus Installation  

<img alt="proteus" src="img/proteus.jpg" width="700">

For simulation, we use `Proteus V8.16`. No extra libraries are needed, as it already includes `STM32` parts, buttons, LEDs, and TFT LCDs.  

Install `Proteus` as usual, ensure it is working properly, and verify that it contains the required components.  

#### Using Proteus

1. Create New Project with `Default Schematic` template but with PCB Layout or Firmware
2. Add `Power` and `Ground` from `Terminals` list on the side bar
   1. Set `Power` value by double click and writing label as `+3.3v` for 3.3 volts
3. Open parts library (press `p` or open `Library` > `Pick Parts`) and search for any needed parts
4. Connect parts by extending wires using mouse dragging
5. If your simulation contains Micro-controllers
   1. Double click the Micro-controllers
   2. Check that `Crystal Frequency` is set. For example: `16MHz` or `16M`
   3. Choose code file as the HEX file generated from the compiler
6. Run the simulation

<img alt="stmProteus" src="img/stmProteus.png" width="700">

### Keil Installation  

<img alt="KeilMDK" src="img/KeilMDK.png" width="700">

Keil can simulate and flash code to STM chips (if a hardware programmer is available). It also provides startup code (bootstrap) for STM32 chips and supports different compilers for C++, C, and Assembly.  

1. Download **Keil uVision** (also called **MDK-ARM**) from the [official website](https://www.keil.com/demo/eval/arm.htm).  
2. **For BluePill**: Download and install the `STM32F103C6` package from the **Packs Installer** in Keil. Only the **DFP pack** is needed.  
3. **For EasyMX**: Download and install the `STM32F407VG` package (v2.17.1) from [this link](https://www.keil.com/pack/Keil.STM32F4xx_DFP.2.17.1.pack).  

#### Project Creation  

1. Open **Keil uVision**.  
2. Create a new project (**Project** > **Create New uVision Project**).  
3. In the **Packs** section, select `STM32F407VG` or `STM32F103C6` as the target.  
4. In the **Runtime Environment**, select:  
    - **CMSIS > Core**  
    - **Device > Startup**  
5. **For Hardware:** Click on **Options for Target** > **Debugger** > select **ST-Link Debugger**.  
6. **For Simulation:** Click on **Options for Target** > **Output** > check **"Create HEX File"**.  
7. Start coding, compiling, and building.  

**Note:** Code can be simulated at the register level by debugging in Keil.  

## Preparing Hardware Environment

### EasyMX Driver Installation

1. Install the STM driver (`ST-Link`), a general driver for any STM debugger, using [Mikro Website](https://www.mikroe.com/easymx-pro-stm32#idTabFSCHT1310) or [ARM Website](https://os.mbed.com/teams/ST/wiki/ST-Link-Driver).
2. Install `MikroProg Suite` for flashing code.
3. Connect the board and check the connection using `MikroProg Suite`.

**Note:** The board has multiple USB ports. Connect to the one closest to the debugger (MikroProg port).

### Flashing

To flash the code onto the target:

1. Ensure the target is connected via `MikroProg Suite`.
2. Flash the code using Keil uVision.

**Note:** After flashing, if the code does not start, reset the board.

## Examples

### Simulation

#### Blinking LEDs

<img alt="blinkingLEDsProteus" src="examples for Proteus/Blinking LEDs/blinkingLEDsProteus.png" width="700">

You can see the code [Here](./examples%20for%20Proteus/Blinking%20LEDs/LED_bluePill.s).

#### LED on Button Press

<img alt="LEDWithButton" src="./examples for Proteus/Button With LED/LEDWithButton.png" width="700">

You can see the code [Here](./examples%20for%20Proteus/Button%20With%20LED/Button11WithLED15.s).

#### Filling the TFT Display with Color

<img alt="fillScreenExample" src="examples for Proteus/Fill Screen/fillScreenExample.png" width="700">

You can see the code [Here](./examples%20for%20Proteus/Fill%20Screen/main.s). This code is explained in the [Interfacing Between STM32 and TFT Display](#interfacing-between-stm32-and-tft-display) part.

#### Drawing Image on the TFT Display

<img alt="drawingImage" src="examples for Proteus/Drawing Image/drawingImage.png" width="700">

You can see the code [Here](./examples%20for%20Proteus/Drawing%20Image/main.s). This image data is generated using the python script [here](./image%20generation/imgToData.py).

### Hardware

#### LED Blink

You can see the code [Here](./examples/LEDs_PD0_PD3.s)

1. Enable GPIOD clock
2. Configure pins PD0-PD3 as output mode
3. loop
    1. Turn on LEDs using Output port
    2. Delay
    3. Turn off LEDs using Output port
    4. Delay

#### Button-Triggered LED

You can see the code [Here](./examples/Button_PD11_With_LEDs_PD0_PD3.s)

1. Enable GPIOD clock
2. Configure pins PD0-PD3 as output mode
3. Configure pin PD11 as input mode
4. Enable pulldown resistor on pin PD11 (Button)
5. Loop
   1. Read Button from Input Port
   2. Turn On LEDs using output port
   3. Turn Off LEDs using output port

#### Fill Screen With Single Color

You can see the code [Here](./examples/Fill_LCD.s)

#### Draw Image On Screen

You can see the code [Here](./examples/Draw%20Image)
