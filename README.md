# ARM Assemlby

- [ARM Assemlby](#arm-assemlby)
  - [EasyMX Driver Installation](#easymx-driver-installation)
  - [Keil Installation](#keil-installation)
  - [Project Creation](#project-creation)
  - [Code Structure](#code-structure)
    - [ARM Assembly in general](#arm-assembly-in-general)
    - [STM Operation](#stm-operation)
    - [General Code Structure](#general-code-structure)
    - [Initialization](#initialization)
      - [Ports](#ports)
        - [Mode Register](#mode-register)
        - [Output Type Register](#output-type-register)
        - [Output Speed Register](#output-speed-register)
        - [Pull-up / Pull-down Register](#pull-up--pull-down-register)
        - [Output Register](#output-register)
      - [Clock](#clock)
      - [Example](#example)
  - [Simulation](#simulation)
  - [Flashing](#flashing)

## EasyMX Driver Installation

1. Install STM driver (general driver for any STM debugger) `ST-Link` using [Mikro Website](https://www.mikroe.com/easymx-pro-stm32#idTabFSCHT1310) or [ARM Website](https://os.mbed.com/teams/ST/wiki/ST-Link-Driver)
2. Install `MikroProg Suite` for flashing code
3. Connect the board and check concection using `MikroProg Suite`

Note: The board has many USB ports connect the one close to the debugger (MikroProg port)

## Keil Installation

Keil can simulate and flash code on STM chips (if programmer available). It also supports startup code for STM32 chips (bootstrap), and different compilers for CPP, C, and Assembly.

1. Download Keil uVision also called MDK-ARM from [Official Website](https://www.keil.com/demo/eval/arm.htm)
2. Using `Install Packs` utility in Keil, install STM32F407VG Package from local Zip file (to ensure version compatibility and startup code availability)

## Project Creation

1. Open Keil uVision
2. Create New Project (Project > Create New uVision Project)
3. In the Packs, Select STM32F407VG as target
4. In the runtime environment select:

    - CMSIS > Core
    - Device > Startup

5. Click on options for target > Debugger > select "ST-Link Debugger"
6. Time to code, compile, build, and flash

Note: after flashing if code doesn't start, reset the board

## Code Structure

### ARM Assembly in general

1. X86 `Procedures` are Called `Functions` as well in ARM
2. `.data .code .stack` in x86 Assembly are `AREA ..., CODE, READONLY / READWRITE` in ARM
3. `END MAIN` in x86 Assembly is `END` in ARM
4. To use functions from another file in ARM Assembly use `EXPORT <function name>`

### STM Operation

Remember Arduino where we used to write two functions in any program `init()` and `loop()`, one to initialize the chip and set ports directions, the other to loop infinitely: here the startup code (made by STMicroelectronics) calls two functions `SystemInit` and `__main` which work the same way

### General Code Structure

The general code structure is as follows

```asm

    ; Data

    ; Procedure Exportation
    EXPORT SystemInit
    EXPORT __main


    ; Code Segment declaration
    AREA MYCODE, CODE, READONLY
        

SystemInit FUNCTION

    ; initialization code
    
    ENDFUNC
    


__main FUNCTION
    

    ; main Code

    ENDFUNC
    
    END
```

### Initialization

All registers are memory-mapped (accessed using `LDR` and `STR`)

#### Ports

Each pin is represented by a bit in a port. Ports have `control registers` and `data registers`

`Control Registers` are 32-bit registers as:

- `GPIOx_MODER` : select the I/O direction
- `GPIOx_OTYPER` : select the output type (push-pull or open-drain)
- `GPIOx_OSPEEDR` : select pin speed
- `GPIOx_PUPDR` : select the pull-up/pull-down whatever the I/O direction

`Data Registers` are 16-bit registers as:

- `GPIOx_IDR` : stores the input data, it is read only
- `GPIOx_ODR` : stores the data to be output, it is read/write accessible

Each register has same offset regardless of the segment in which it exists

`Control Registers`

- `GPIOx_MODER` : 0x00
- `GPIOx_OTYPER` : 0x04
- `GPIOx_OSPEEDR` : 0x08
- `GPIOx_PUPDR` : 0x0c

`Data Registers` :

- `GPIOx_IDR` : 0x10
- `GPIOx_ODR` : 0x14

According to datasheet of STM32F4XX

<img alt="registerMapping" src="img/registerMapping.png" width="700">

All GPIO ports are connected to `AHB1` Bus but each having its segment

For example

```asm
GPIOD_MODER   EQU  0x40020C00
GPIOD_OTYPER  EQU  0x40020C04
GPIOD_OSPEEDR EQU  0x40020C08
GPIOD_PUPDR   EQU  0x40020C0C
GPIOD_ODR     EQU  0x40020C14
```

##### Mode Register

<img alt="modeRegister" src="img/modeRegister.png" width="700">

Each port pin associates with two bits in the mode register. With these two mode bits, we can configure the corresponding port pin in one of the four possible modes as listed below.

- Input mode (00)
- Output mode (01)
- Analog mode (10)
- Alternate function (11)

##### Output Type Register

<img alt="outputType" src="img/outputType.png" width="700">

The output type register allows individual port pins output output configuration as either push-pull or open-drain type. Setting a bit configures open drain mode while clearing it configures the corresponding pin in open drain mode.

##### Output Speed Register

<img alt="outputSpeedRegister" src="img/outputSpeedRegister.png" width="700">

The output speed register allows us to configure the maximum output switching speed for the port pins. The actual maximum speed depends on other factors such as supply voltage, load capacitance etc. As per STM32F407 datasheet, the maximum speed in slow speed is between 2MHz to 8MHz. We configure the speed to slow mode because out blinking frequency (2 Hz) is much lesser than this.

Setting the bits to ‘00b’ configures the corresponding port pins for slow speed.

##### Pull-up / Pull-down Register

<img alt="pullUpPullDownRegister" src="img/pullUpPullDownRegister.png" width="700">

STM32F407 provides configurable internal pull-up / pull-down resistors for each pin. This register allows to enable or disable these internal resistors

##### Output Register

A simple register with 1 for on and 0 for off.

#### Clock

To use ports or pins on STM32 chip we must first enable clock for such port

To enable clock on ports on `AHB1` Bus use register `RCC_AHB1ENR   EQU  0x40023830`

>This register is part of the RCC registers (Reset and Clock control). The offset of this register is 0x30 as described in section 7.3.10 of reference manual. The memory map shows the RCC boundary address range as 0x4002 3800 to 0x4002 3BFF.  Therefore the address of RCC_AHB1ENR register is 0x4002 3830.

<img alt="clock1" src="img/clock1.png" width="300">
<img alt="clock2" src="img/clock2.png" width="300">

<img alt="clock3" src="img/clock3.png" width="700">

#### Example

```asm
LDR    R1,  =RCC_AHB1ENR    ; load address if clock register
LDR    R0,  [R1]            ; load value in address if clock register
ORR.W  R0,  #0x08           ; ORR.W = logical OR for words
STR    R0,  [R1]            ; store the value to register again
```

## Simulation

To simulate code debug it on keil

## Flashing

To Flash code on target:

1. Make sure target is connected using MikroProg Suite
2. Flash from Keil uVision
