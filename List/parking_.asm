
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32A
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2143
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _capa=R5
	.DEF __res=R4
	.DEF _n_vurud=R6
	.DEF _n_khuruj=R8
	.DEF _minute=R11
	.DEF _hour=R10
	.DEF _second=R13
	.DEF _day=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x3:
	.DB  0x3
_0x4:
	.DB  0x72,0x5
_0xC7:
	.DB  0x0,0x64,0x0,0x0,0x0,0x0,0x17,0x3A
	.DB  0x1,0x32
_0x0:
	.DB  0x4D,0x65,0x6C,0x65,0x63,0x2E,0x69,0x72
	.DB  0x0,0x50,0x61,0x72,0x6B,0x69,0x6E,0x67
	.DB  0x20,0x41,0x42,0x43,0x20,0x0,0x73,0x61
	.DB  0x76,0x69,0x6E,0x67,0x20,0x64,0x61,0x74
	.DB  0x61,0x0,0x5A,0x3D,0x25,0x64,0x20,0x25
	.DB  0x64,0x2F,0x25,0x64,0x2F,0x25,0x64,0x0
	.DB  0x25,0x64,0x3A,0x25,0x64,0x3A,0x25,0x64
	.DB  0x20,0x20,0x52,0x3D,0x25,0x64,0x20,0x0
	.DB  0x20,0x46,0x75,0x6C,0x6C,0x0,0x20,0x45
	.DB  0x6D,0x70,0x0,0x54,0x69,0x6D,0x65,0x20
	.DB  0x53,0x65,0x74,0x74,0x69,0x6E,0x67,0x20
	.DB  0x3E,0x3E,0x0,0x49,0x4E,0x26,0x4F,0x55
	.DB  0x54,0x20,0x53,0x65,0x61,0x72,0x63,0x68
	.DB  0x20,0x3E,0x3E,0x0,0x52,0x65,0x73,0x65
	.DB  0x72,0x76,0x65,0x5F,0x50,0x61,0x72,0x6B
	.DB  0x20,0x3E,0x3E,0x0,0x53,0x65,0x74,0x20
	.DB  0x64,0x61,0x74,0x61,0x20,0x3E,0x3E,0x0
	.DB  0x53,0x65,0x74,0x20,0x6D,0x69,0x6E,0x3D
	.DB  0x25,0x64,0x20,0x20,0x3E,0x0,0x53,0x65
	.DB  0x74,0x20,0x68,0x6F,0x75,0x72,0x3D,0x25
	.DB  0x64,0x20,0x20,0x3E,0x0,0x25,0x64,0x2F
	.DB  0x25,0x64,0x2F,0x25,0x64,0x20,0x0,0x69
	.DB  0x6E,0x3D,0x25,0x64,0x20,0x6F,0x75,0x74
	.DB  0x3D,0x25,0x64,0x0,0x52,0x65,0x73,0x65
	.DB  0x72,0x76,0x65,0x64,0x3D,0x25,0x64,0x0
	.DB  0x53,0x65,0x74,0x20,0x6D,0x6F,0x6E,0x74
	.DB  0x68,0x3D,0x25,0x64,0x20,0x20,0x3E,0x0
	.DB  0x53,0x65,0x74,0x20,0x64,0x61,0x79,0x3D
	.DB  0x25,0x64,0x20,0x20,0x3E,0x0,0x53,0x65
	.DB  0x74,0x20,0x79,0x65,0x61,0x72,0x3D,0x25
	.DB  0x64,0x20,0x20,0x3E,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  _month
	.DW  _0x3*2

	.DW  0x02
	.DW  _year
	.DW  _0x4*2

	.DW  0x0A
	.DW  0x04
	.DW  _0xC7*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include <alcd.h>
;#define xtal 8000000
;
;char setting(void);
;char in_out_search(void);
;char time_set(void);
;char reserve_park(void);
;char set_data(void);
;signed char capa=100;
;signed char _res=0;
;unsigned int n_vurud,n_khuruj;  // maximum  65535  mashin dar ruz
;eeprom unsigned int  vurud_stat[31],khuruj_stat[31];
;eeprom unsigned char i;
;bit _full=0,_emp=0;
;signed char minute=58,hour=23,second=50,day=1,month=3;

	.DSEG
;signed int year=1394;
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 0015     {

	.CSEG
_timer2_ovf_isr:
	ST   -Y,R0
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0016 
; 0000 0017       if(second==59){
	LDI  R30,LOW(59)
	CP   R30,R13
	BRNE _0x5
; 0000 0018       second=0;
	CLR  R13
; 0000 0019       if(minute==59){
	CP   R30,R11
	BRNE _0x6
; 0000 001A       minute=0;
	CLR  R11
; 0000 001B       if(hour==23){
	LDI  R30,LOW(23)
	CP   R30,R10
	BRNE _0x7
; 0000 001C       hour=0;
	CLR  R10
; 0000 001D       day++;
	INC  R12
; 0000 001E       }
; 0000 001F       else
	RJMP _0x8
_0x7:
; 0000 0020       hour++;
	INC  R10
; 0000 0021       }
_0x8:
; 0000 0022       else
	RJMP _0x9
_0x6:
; 0000 0023       minute++;
	INC  R11
; 0000 0024       }
_0x9:
; 0000 0025       else
	RJMP _0xA
_0x5:
; 0000 0026       second++;
	INC  R13
; 0000 0027 
; 0000 0028       if((day>30) & (month>6)){
_0xA:
	MOV  R26,R12
	LDI  R30,LOW(30)
	CALL SUBOPT_0x0
	CALL __GTB12
	AND  R30,R0
	BREQ _0xB
; 0000 0029       day=1;
	CALL SUBOPT_0x1
; 0000 002A       month++;
; 0000 002B       }
; 0000 002C 
; 0000 002D       if((day>31) & (month<=6)){
_0xB:
	MOV  R26,R12
	LDI  R30,LOW(31)
	CALL SUBOPT_0x0
	CALL __LEB12
	AND  R30,R0
	BREQ _0xC
; 0000 002E       day=1;
	CALL SUBOPT_0x1
; 0000 002F       month++;
; 0000 0030       }
; 0000 0031 
; 0000 0032       if((day>29) & (month==12)){
_0xC:
	MOV  R26,R12
	LDI  R30,LOW(29)
	CALL __GTB12
	MOV  R0,R30
	LDS  R26,_month
	LDI  R30,LOW(12)
	CALL __EQB12
	AND  R30,R0
	BREQ _0xD
; 0000 0033       day=1;
	CALL SUBOPT_0x1
; 0000 0034       month++;
; 0000 0035       }
; 0000 0036 
; 0000 0037       if(month>12){
_0xD:
	LDS  R26,_month
	CPI  R26,LOW(0xD)
	BRLT _0xE
; 0000 0038       month=1;
	LDI  R30,LOW(1)
	STS  _month,R30
; 0000 0039       year++;
	CALL SUBOPT_0x2
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 003A       }
; 0000 003B 
; 0000 003C 
; 0000 003D 
; 0000 003E      }
_0xE:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R0,Y+
	RETI
;
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0041 {
_ext_int0_isr:
	CALL SUBOPT_0x3
; 0000 0042 capa++;
	INC  R5
; 0000 0043 n_khuruj++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0044 
; 0000 0045    if((capa+_res)>=100){
	CALL SUBOPT_0x4
	BRLT _0xF
; 0000 0046    capa=100-_res;
	LDI  R30,LOW(100)
	SUB  R30,R4
	MOV  R5,R30
; 0000 0047    _emp=1;
	SET
	RJMP _0xC2
; 0000 0048    }
; 0000 0049    else{
_0xF:
; 0000 004A    _emp=0;
	CLT
_0xC2:
	BLD  R2,1
; 0000 004B    }
; 0000 004C 
; 0000 004D 
; 0000 004E      if((capa)<=0){
	LDI  R30,LOW(0)
	CP   R30,R5
	BRLT _0x11
; 0000 004F     capa=0;
	CLR  R5
; 0000 0050     _full=1;
	SET
	RJMP _0xC3
; 0000 0051     }
; 0000 0052     else{
_0x11:
; 0000 0053     _full=0;
	CLT
_0xC3:
	BLD  R2,0
; 0000 0054 
; 0000 0055     }
; 0000 0056 
; 0000 0057 }
	RJMP _0xC6
;
;
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 005B {
_ext_int1_isr:
	CALL SUBOPT_0x3
; 0000 005C capa--;
	DEC  R5
; 0000 005D n_vurud++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 005E     if((capa)<=0){
	LDI  R30,LOW(0)
	CP   R30,R5
	BRLT _0x13
; 0000 005F     capa=0;
	CLR  R5
; 0000 0060     _full=1;
	SET
	RJMP _0xC4
; 0000 0061     }
; 0000 0062     else{
_0x13:
; 0000 0063     _full=0;
	CLT
_0xC4:
	BLD  R2,0
; 0000 0064     }
; 0000 0065 
; 0000 0066    if((capa+_res)>=100){
	CALL SUBOPT_0x4
	BRLT _0x15
; 0000 0067    capa=100-_res;
	LDI  R30,LOW(100)
	SUB  R30,R4
	MOV  R5,R30
; 0000 0068    _emp=1;
	SET
	RJMP _0xC5
; 0000 0069    }
; 0000 006A    else{
_0x15:
; 0000 006B    _emp=0;
	CLT
_0xC5:
	BLD  R2,1
; 0000 006C    }
; 0000 006D 
; 0000 006E 
; 0000 006F }
_0xC6:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;void main(void){
; 0000 0071 void main(void){
_main:
; 0000 0072 
; 0000 0073 char buff[17],buff2[17];
; 0000 0074 
; 0000 0075 
; 0000 0076 
; 0000 0077 //GICR|=0xC0;
; 0000 0078 //MCUCR=0x0A;
; 0000 0079 //MCUCSR=0x00;
; 0000 007A //GIFR=0xC0;
; 0000 007B 
; 0000 007C GICR|=0xC0;
	SBIW R28,34
;	buff -> Y+17
;	buff2 -> Y+0
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 007D MCUCR=0x0B;
	LDI  R30,LOW(11)
	OUT  0x35,R30
; 0000 007E MCUCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 007F GIFR=0xC0;
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 0080 
; 0000 0081 
; 0000 0082 
; 0000 0083 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0084 lcd_clear();
	CALL _lcd_clear
; 0000 0085 lcd_putsf("Melec.ir");
	__POINTW2FN _0x0,0
	CALL _lcd_putsf
; 0000 0086 lcd_gotoxy(0,1);
	CALL SUBOPT_0x5
; 0000 0087 lcd_putsf("Parking ABC ");
	__POINTW2FN _0x0,9
	CALL _lcd_putsf
; 0000 0088 delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0000 0089 
; 0000 008A 
; 0000 008B 
; 0000 008C 
; 0000 008D 
; 0000 008E 
; 0000 008F   ASSR=0x08;//timer2
	LDI  R30,LOW(8)
	OUT  0x22,R30
; 0000 0090   TCCR2=0x05;
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0000 0091   TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0092   OCR2=0x00;
	OUT  0x23,R30
; 0000 0093   TIMSK=0x40;
	LDI  R30,LOW(64)
	OUT  0x39,R30
; 0000 0094 
; 0000 0095   PORTA=(1<<DDD0)|(1<<DDD1)|(1<<DDD2)|(1<<DDD3)|(1<<DDD4);
	LDI  R30,LOW(31)
	OUT  0x1B,R30
; 0000 0096 
; 0000 0097 
; 0000 0098  day=i;   // i in epprom
	CALL SUBOPT_0x6
	MOV  R12,R30
; 0000 0099 
; 0000 009A #asm("sei")
	sei
; 0000 009B   capa=capa-_res;
	SUB  R5,R4
; 0000 009C 
; 0000 009D     while(1){
_0x17:
; 0000 009E 
; 0000 009F            if(PINA.2==0){
	SBIC 0x19,2
	RJMP _0x1A
; 0000 00A0            while(PINA.2==0);
_0x1B:
	SBIS 0x19,2
	RJMP _0x1B
; 0000 00A1            setting();
	RCALL _setting
; 0000 00A2            }
; 0000 00A3 
; 0000 00A4 
; 0000 00A5              if(hour==0 & minute==0 & second==0){  //  data will save   in 0:0:00
_0x1A:
	CALL SUBOPT_0x7
	BREQ _0x1E
; 0000 00A6              vurud_stat[i]=n_vurud;
	CALL SUBOPT_0x6
	CALL SUBOPT_0x8
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R6
	CALL __EEPROMWRW
; 0000 00A7              khuruj_stat[i]=n_khuruj;
	CALL SUBOPT_0x6
	CALL SUBOPT_0x9
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R8
	CALL __EEPROMWRW
; 0000 00A8              i++;
	CALL SUBOPT_0x6
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 00A9 
; 0000 00AA                   if(i>30)   // 30 31 29 yek mah
	CALL SUBOPT_0x6
	CPI  R30,LOW(0x1F)
	BRLO _0x1F
; 0000 00AB                   i=0;
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 00AC 
; 0000 00AD                 while(hour==0 & minute==0 & second==0){
_0x1F:
_0x20:
	CALL SUBOPT_0x7
	BREQ _0x22
; 0000 00AE                 lcd_clear();
	CALL _lcd_clear
; 0000 00AF                 lcd_putsf("saving data");
	__POINTW2FN _0x0,22
	CALL _lcd_putsf
; 0000 00B0                 }
	RJMP _0x20
_0x22:
; 0000 00B1              }
; 0000 00B2 
; 0000 00B3 
; 0000 00B4 
; 0000 00B5              sprintf(buff,"Z=%d %d/%d/%d",capa,year,month,day);
_0x1E:
	MOVW R30,R28
	ADIW R30,17
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,34
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R5
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	LDS  R30,_month
	CALL SUBOPT_0xA
	MOV  R30,R12
	CALL SUBOPT_0xA
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 00B6              sprintf(buff2,"%d:%d:%d  R=%d ",hour,minute,second,_res);
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,48
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R10
	CALL SUBOPT_0xA
	MOV  R30,R11
	CALL SUBOPT_0xA
	MOV  R30,R13
	CALL SUBOPT_0xA
	MOV  R30,R4
	CALL SUBOPT_0xA
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 00B7 
; 0000 00B8             lcd_clear();
	CALL _lcd_clear
; 0000 00B9 
; 0000 00BA             lcd_puts(buff);
	MOVW R26,R28
	ADIW R26,17
	CALL _lcd_puts
; 0000 00BB 
; 0000 00BC             if(_full==1){
	SBRS R2,0
	RJMP _0x23
; 0000 00BD 
; 0000 00BE             lcd_putsf(" Full");
	__POINTW2FN _0x0,64
	CALL _lcd_putsf
; 0000 00BF              }
; 0000 00C0 
; 0000 00C1             if(_emp==1){
_0x23:
	SBRS R2,1
	RJMP _0x24
; 0000 00C2 
; 0000 00C3             lcd_putsf(" Emp");
	__POINTW2FN _0x0,70
	CALL _lcd_putsf
; 0000 00C4             }
; 0000 00C5 
; 0000 00C6             lcd_gotoxy(0,1);
_0x24:
	CALL SUBOPT_0x5
; 0000 00C7             lcd_puts(buff2);
	CALL SUBOPT_0xD
; 0000 00C8             delay_ms(25);
	CALL SUBOPT_0xE
; 0000 00C9   }
	RJMP _0x17
; 0000 00CA }
_0x25:
	RJMP _0x25
;
;/// Functions 4 setting and...
;
;char setting(void){
; 0000 00CE char setting(void){
_setting:
; 0000 00CF char _chose=0;
; 0000 00D0         while(1){
	ST   -Y,R17
;	_chose -> R17
	LDI  R17,0
_0x26:
; 0000 00D1             if(_chose==0){
	CPI  R17,0
	BRNE _0x29
; 0000 00D2             lcd_clear();
	CALL _lcd_clear
; 0000 00D3             lcd_putsf("Time Setting >>");
	__POINTW2FN _0x0,75
	CALL _lcd_putsf
; 0000 00D4             }
; 0000 00D5 
; 0000 00D6             if(_chose==1){
_0x29:
	CPI  R17,1
	BRNE _0x2A
; 0000 00D7             lcd_clear();
	CALL _lcd_clear
; 0000 00D8             lcd_putsf("IN&OUT Search >>");
	__POINTW2FN _0x0,91
	CALL _lcd_putsf
; 0000 00D9             }
; 0000 00DA 
; 0000 00DB             if(_chose==2){
_0x2A:
	CPI  R17,2
	BRNE _0x2B
; 0000 00DC             lcd_clear();
	CALL _lcd_clear
; 0000 00DD             lcd_putsf("Reserve_Park >>");
	__POINTW2FN _0x0,108
	CALL _lcd_putsf
; 0000 00DE             }
; 0000 00DF 
; 0000 00E0             if(_chose==3){
_0x2B:
	CPI  R17,3
	BRNE _0x2C
; 0000 00E1             lcd_clear();
	CALL _lcd_clear
; 0000 00E2             lcd_putsf("Set data >>");
	__POINTW2FN _0x0,124
	CALL _lcd_putsf
; 0000 00E3             }
; 0000 00E4 
; 0000 00E5 
; 0000 00E6              if(PINA.3==0){ //NEXT
_0x2C:
	SBIC 0x19,3
	RJMP _0x2D
; 0000 00E7              while(PINA.3==0);
_0x2E:
	SBIS 0x19,3
	RJMP _0x2E
; 0000 00E8              _chose++;
	SUBI R17,-1
; 0000 00E9                  if(_chose>=4)
	CPI  R17,4
	BRLO _0x31
; 0000 00EA                  _chose=0;
	LDI  R17,LOW(0)
; 0000 00EB                 }
_0x31:
; 0000 00EC 
; 0000 00ED 
; 0000 00EE               if(PINA.4==0){ //Back
_0x2D:
	SBIC 0x19,4
	RJMP _0x32
; 0000 00EF               while(PINA.4==0);
_0x33:
	SBIS 0x19,4
	RJMP _0x33
; 0000 00F0               return 0;
	LDI  R30,LOW(0)
	RJMP _0x2080008
; 0000 00F1               }
; 0000 00F2 
; 0000 00F3            if(PINA.2==0 & _chose==0 ){  //chose time_setting
_0x32:
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	BREQ _0x36
; 0000 00F4            while(PINA.2==0);
_0x37:
	SBIS 0x19,2
	RJMP _0x37
; 0000 00F5            time_set();
	RCALL _time_set
; 0000 00F6            }
; 0000 00F7 
; 0000 00F8            if(PINA.2==0 & _chose==1 ){  //chose in_out_search
_0x36:
	CALL SUBOPT_0xF
	CALL SUBOPT_0x11
	BREQ _0x3A
; 0000 00F9            while(PINA.2==0);
_0x3B:
	SBIS 0x19,2
	RJMP _0x3B
; 0000 00FA            in_out_search();
	RCALL _in_out_search
; 0000 00FB            }
; 0000 00FC 
; 0000 00FD            if(PINA.2==0 & _chose==2 ){  //chose reserve
_0x3A:
	CALL SUBOPT_0xF
	CALL SUBOPT_0x12
	BREQ _0x3E
; 0000 00FE            while(PINA.2==0);
_0x3F:
	SBIS 0x19,2
	RJMP _0x3F
; 0000 00FF            reserve_park();
	RCALL _reserve_park
; 0000 0100            }
; 0000 0101 
; 0000 0102            if(PINA.2==0 & _chose==3 ){  //chose set data
_0x3E:
	CALL SUBOPT_0xF
	LDI  R30,LOW(3)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x42
; 0000 0103            while(PINA.2==0);
_0x43:
	SBIS 0x19,2
	RJMP _0x43
; 0000 0104            set_data();
	RCALL _set_data
; 0000 0105            }
; 0000 0106 
; 0000 0107 
; 0000 0108 
; 0000 0109        delay_ms(25);
_0x42:
	CALL SUBOPT_0xE
; 0000 010A        }
	RJMP _0x26
; 0000 010B }
_0x2080008:
	LD   R17,Y+
	RET
;
;///Time setting
;
;char time_set(void){
; 0000 010F char time_set(void){
_time_set:
	PUSH R15
; 0000 0110 bit _chose=0;
; 0000 0111 char buff[17];
; 0000 0112  while(1){
	SBIW R28,17
;	_chose -> R15.0
;	buff -> Y+0
	CLR  R15
_0x46:
; 0000 0113 
; 0000 0114         if(_chose==0){
	SBRC R15,0
	RJMP _0x49
; 0000 0115         sprintf(buff,"Set min=%d  >",minute);
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,136
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R11
	CALL SUBOPT_0xA
	CALL SUBOPT_0x13
; 0000 0116         lcd_clear();
; 0000 0117         lcd_puts(buff);
; 0000 0118 
; 0000 0119         }
; 0000 011A 
; 0000 011B          if(_chose==1){
_0x49:
	SBRS R15,0
	RJMP _0x4A
; 0000 011C         sprintf(buff,"Set hour=%d  >",hour);
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,150
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R10
	CALL SUBOPT_0xA
	CALL SUBOPT_0x13
; 0000 011D         lcd_clear();
; 0000 011E         lcd_puts(buff);
; 0000 011F 
; 0000 0120         }
; 0000 0121 
; 0000 0122          if(PINA.1==0 & _chose==0){ //UP     min
_0x4A:
	CALL SUBOPT_0x14
	CALL SUBOPT_0x10
	BREQ _0x4B
; 0000 0123          while(PINA.1==0);
_0x4C:
	SBIS 0x19,1
	RJMP _0x4C
; 0000 0124          minute++;
	INC  R11
; 0000 0125          if(minute>59)
	LDI  R30,LOW(59)
	CP   R30,R11
	BRGE _0x4F
; 0000 0126          minute=0;
	CLR  R11
; 0000 0127          }
_0x4F:
; 0000 0128 
; 0000 0129          if(PINA.0==0& _chose==0){ //DOWN    min
_0x4B:
	CALL SUBOPT_0x15
	CALL SUBOPT_0x10
	BREQ _0x50
; 0000 012A          while(PINA.0==0);
_0x51:
	SBIS 0x19,0
	RJMP _0x51
; 0000 012B          minute--;
	DEC  R11
; 0000 012C          if(minute<0)
	LDI  R30,LOW(0)
	CP   R11,R30
	BRGE _0x54
; 0000 012D          minute=59;
	LDI  R30,LOW(59)
	MOV  R11,R30
; 0000 012E          }
_0x54:
; 0000 012F 
; 0000 0130          if(PINA.1==0 & _chose==1){ //UP    hour
_0x50:
	CALL SUBOPT_0x14
	CALL SUBOPT_0x11
	BREQ _0x55
; 0000 0131          while(PINA.1==0);
_0x56:
	SBIS 0x19,1
	RJMP _0x56
; 0000 0132          hour++;
	INC  R10
; 0000 0133          if(hour>23)
	LDI  R30,LOW(23)
	CP   R30,R10
	BRGE _0x59
; 0000 0134          hour=0;
	CLR  R10
; 0000 0135          }
_0x59:
; 0000 0136 
; 0000 0137          if(PINA.0==0& _chose==1){ //DOWN    hour
_0x55:
	CALL SUBOPT_0x15
	CALL SUBOPT_0x11
	BREQ _0x5A
; 0000 0138          while(PINA.0==0);
_0x5B:
	SBIS 0x19,0
	RJMP _0x5B
; 0000 0139          hour--;
	DEC  R10
; 0000 013A          if(hour<0)
	LDI  R30,LOW(0)
	CP   R10,R30
	BRGE _0x5E
; 0000 013B          hour=23;
	LDI  R30,LOW(23)
	MOV  R10,R30
; 0000 013C          }
_0x5E:
; 0000 013D 
; 0000 013E 
; 0000 013F 
; 0000 0140 
; 0000 0141 
; 0000 0142         if(PINA.3==0){ //NEXT
_0x5A:
	SBIC 0x19,3
	RJMP _0x5F
; 0000 0143              while(PINA.3==0);
_0x60:
	SBIS 0x19,3
	RJMP _0x60
; 0000 0144            _chose=!_chose;
	LDI  R30,LOW(1)
	EOR  R15,R30
; 0000 0145              }
; 0000 0146 
; 0000 0147 
; 0000 0148 
; 0000 0149 
; 0000 014A         if(PINA.4==0){ //Back
_0x5F:
	SBIC 0x19,4
	RJMP _0x63
; 0000 014B          while(PINA.4==0);
_0x64:
	SBIS 0x19,4
	RJMP _0x64
; 0000 014C          return 0;
	LDI  R30,LOW(0)
	RJMP _0x2080007
; 0000 014D          }
; 0000 014E 
; 0000 014F          delay_ms(25);
_0x63:
	CALL SUBOPT_0xE
; 0000 0150  }
	RJMP _0x46
; 0000 0151 }
_0x2080007:
	ADIW R28,17
	POP  R15
	RET
;
;///IN&OUT Search
; char in_out_search(void){
; 0000 0154 char in_out_search(void){
_in_out_search:
	PUSH R15
; 0000 0155   char t_month=month,buff[17],buff2[17];
; 0000 0156   char i_temp=i;
; 0000 0157   bit bit_m=0;
; 0000 0158     while(1){
	SBIW R28,34
	ST   -Y,R17
	ST   -Y,R16
;	t_month -> R17
;	buff -> Y+19
;	buff2 -> Y+2
;	i_temp -> R16
;	bit_m -> R15.0
	CLR  R15
	LDS  R17,_month
	CALL SUBOPT_0x6
	MOV  R16,R30
_0x67:
; 0000 0159 
; 0000 015A 
; 0000 015B 
; 0000 015C 
; 0000 015D 
; 0000 015E         if(PINA.1==0){ //UP
	SBIC 0x19,1
	RJMP _0x6A
; 0000 015F          while(PINA.1==0);
_0x6B:
	SBIS 0x19,1
	RJMP _0x6B
; 0000 0160          i_temp++;
	SUBI R16,-1
; 0000 0161 
; 0000 0162            if(i_temp>i & bit_m==0){
	CALL SUBOPT_0x6
	MOV  R26,R16
	CALL __GTB12U
	CALL SUBOPT_0x16
	BREQ _0x6E
; 0000 0163             i_temp=i;
	CALL SUBOPT_0x6
	MOV  R16,R30
; 0000 0164             t_month--;
	SUBI R17,1
; 0000 0165             bit_m=1;
	SET
	BLD  R15,0
; 0000 0166 
; 0000 0167            }
; 0000 0168 
; 0000 0169 
; 0000 016A             if(t_month<=6 & i_temp>31 & bit_m==1){
_0x6E:
	MOV  R26,R17
	LDI  R30,LOW(6)
	CALL __LEB12U
	MOV  R0,R30
	MOV  R26,R16
	LDI  R30,LOW(31)
	CALL SUBOPT_0x17
	BREQ _0x6F
; 0000 016B             i_temp=1;
	CALL SUBOPT_0x18
; 0000 016C             t_month++;
; 0000 016D             bit_m=0;
; 0000 016E             }
; 0000 016F 
; 0000 0170              if(t_month>6 & i_temp>30 & bit_m==1){
_0x6F:
	MOV  R26,R17
	LDI  R30,LOW(6)
	CALL __GTB12U
	MOV  R0,R30
	MOV  R26,R16
	LDI  R30,LOW(30)
	CALL SUBOPT_0x17
	BREQ _0x70
; 0000 0171             i_temp=1;
	CALL SUBOPT_0x18
; 0000 0172             t_month++;
; 0000 0173             bit_m=0;
; 0000 0174             }
; 0000 0175 
; 0000 0176              if(t_month==12 & i_temp>29 & bit_m==1){
_0x70:
	MOV  R26,R17
	LDI  R30,LOW(12)
	CALL __EQB12
	MOV  R0,R30
	MOV  R26,R16
	LDI  R30,LOW(29)
	CALL SUBOPT_0x17
	BREQ _0x71
; 0000 0177             i_temp=1;
	CALL SUBOPT_0x18
; 0000 0178             t_month++;
; 0000 0179             bit_m=0;
; 0000 017A             }
; 0000 017B 
; 0000 017C            if(t_month==0)
_0x71:
	CPI  R17,0
	BRNE _0x72
; 0000 017D            t_month=12;
	LDI  R17,LOW(12)
; 0000 017E 
; 0000 017F            if(t_month>12)
_0x72:
	CPI  R17,13
	BRLO _0x73
; 0000 0180            t_month=1;
	LDI  R17,LOW(1)
; 0000 0181 
; 0000 0182 
; 0000 0183          }
_0x73:
; 0000 0184 
; 0000 0185 
; 0000 0186 
; 0000 0187 
; 0000 0188 
; 0000 0189 
; 0000 018A          if(PINA.0==0){ //DOWN
_0x6A:
	SBIC 0x19,0
	RJMP _0x74
; 0000 018B          while(PINA.0==0);
_0x75:
	SBIS 0x19,0
	RJMP _0x75
; 0000 018C          i_temp--;
	SUBI R16,1
; 0000 018D 
; 0000 018E 
; 0000 018F             if(i_temp==0 & bit_m==0){
	MOV  R26,R16
	LDI  R30,LOW(0)
	CALL __EQB12
	CALL SUBOPT_0x16
	BREQ _0x78
; 0000 0190 
; 0000 0191 
; 0000 0192                 t_month--;
	SUBI R17,1
; 0000 0193 
; 0000 0194                 if(t_month==0)
	CPI  R17,0
	BRNE _0x79
; 0000 0195                 t_month=12;
	LDI  R17,LOW(12)
; 0000 0196 
; 0000 0197                  if(t_month>12)
_0x79:
	CPI  R17,13
	BRLO _0x7A
; 0000 0198                  t_month=1;
	LDI  R17,LOW(1)
; 0000 0199 
; 0000 019A                 if(t_month<=6)
_0x7A:
	CPI  R17,7
	BRSH _0x7B
; 0000 019B                 i_temp=31;
	LDI  R16,LOW(31)
; 0000 019C 
; 0000 019D                 if(t_month>6)
_0x7B:
	CPI  R17,7
	BRLO _0x7C
; 0000 019E                 i_temp=30;
	LDI  R16,LOW(30)
; 0000 019F 
; 0000 01A0                 if(t_month==12)
_0x7C:
	CPI  R17,12
	BRNE _0x7D
; 0000 01A1                 i_temp=29;
	LDI  R16,LOW(29)
; 0000 01A2 
; 0000 01A3 
; 0000 01A4 
; 0000 01A5             bit_m=1;
_0x7D:
	SET
	BLD  R15,0
; 0000 01A6             }
; 0000 01A7 
; 0000 01A8             if(i_temp<i & bit_m==1 ){
_0x78:
	CALL SUBOPT_0x6
	MOV  R26,R16
	CALL __LTB12U
	MOV  R0,R30
	LDI  R26,0
	SBRC R15,0
	LDI  R26,1
	CALL SUBOPT_0x11
	BREQ _0x7E
; 0000 01A9             i_temp=i;
	CALL SUBOPT_0x6
	MOV  R16,R30
; 0000 01AA             t_month++;
	SUBI R17,-1
; 0000 01AB             bit_m=0;
	CLT
	BLD  R15,0
; 0000 01AC             }
; 0000 01AD 
; 0000 01AE            if(t_month==0)
_0x7E:
	CPI  R17,0
	BRNE _0x7F
; 0000 01AF            t_month=12;
	LDI  R17,LOW(12)
; 0000 01B0 
; 0000 01B1             if(t_month>12)
_0x7F:
	CPI  R17,13
	BRLO _0x80
; 0000 01B2            t_month=1;
	LDI  R17,LOW(1)
; 0000 01B3 
; 0000 01B4          }
_0x80:
; 0000 01B5 
; 0000 01B6 
; 0000 01B7 
; 0000 01B8 
; 0000 01B9 
; 0000 01BA 
; 0000 01BB          sprintf(buff,"%d/%d/%d ",year,t_month,i_temp);
_0x74:
	MOVW R30,R28
	ADIW R30,19
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,165
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xB
	MOV  R30,R17
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 01BC          sprintf(buff2,"in=%d out=%d",vurud_stat[i_temp],khuruj_stat[i_temp]);
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,175
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	CALL SUBOPT_0x8
	CALL SUBOPT_0x19
	MOV  R30,R16
	CALL SUBOPT_0x9
	CALL SUBOPT_0x19
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 01BD 
; 0000 01BE          lcd_clear();
	CALL _lcd_clear
; 0000 01BF          lcd_puts(buff);
	MOVW R26,R28
	ADIW R26,19
	CALL _lcd_puts
; 0000 01C0          lcd_gotoxy(0,1);
	CALL SUBOPT_0x5
; 0000 01C1          lcd_puts(buff2);
	MOVW R26,R28
	ADIW R26,2
	CALL _lcd_puts
; 0000 01C2 
; 0000 01C3 
; 0000 01C4 
; 0000 01C5          if(PINA.4==0){ //Back
	SBIC 0x19,4
	RJMP _0x81
; 0000 01C6          while(PINA.4==0);
_0x82:
	SBIS 0x19,4
	RJMP _0x82
; 0000 01C7          return 0;
	LDI  R30,LOW(0)
	RJMP _0x2080006
; 0000 01C8          }
; 0000 01C9      delay_ms(25);
_0x81:
	CALL SUBOPT_0xE
; 0000 01CA      }
	RJMP _0x67
; 0000 01CB }
_0x2080006:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,36
	POP  R15
	RET
;
;//reserve_park
;
;char reserve_park(void){
; 0000 01CF char reserve_park(void){
_reserve_park:
; 0000 01D0    char buff[17];
; 0000 01D1 
; 0000 01D2  while(1){
	SBIW R28,17
;	buff -> Y+0
_0x85:
; 0000 01D3    sprintf(buff,"Reserved=%d",_res);
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,188
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R4
	CALL SUBOPT_0xA
	CALL SUBOPT_0x13
; 0000 01D4    lcd_clear();
; 0000 01D5    lcd_puts(buff);
; 0000 01D6 
; 0000 01D7          if(PINA.1==0){ //UP
	SBIC 0x19,1
	RJMP _0x88
; 0000 01D8          while(PINA.1==0);
_0x89:
	SBIS 0x19,1
	RJMP _0x89
; 0000 01D9          _res++;
	INC  R4
; 0000 01DA          }
; 0000 01DB 
; 0000 01DC           if(_res>=100){
_0x88:
	LDI  R30,LOW(100)
	CP   R4,R30
	BRLT _0x8C
; 0000 01DD          _res=99;
	LDI  R30,LOW(99)
	MOV  R4,R30
; 0000 01DE          }
; 0000 01DF 
; 0000 01E0          if(PINA.0==0){ //DOWN
_0x8C:
	SBIC 0x19,0
	RJMP _0x8D
; 0000 01E1          while(PINA.0==0);
_0x8E:
	SBIS 0x19,0
	RJMP _0x8E
; 0000 01E2          _res--;
	DEC  R4
; 0000 01E3 
; 0000 01E4          }
; 0000 01E5 
; 0000 01E6          if(_res<=0){
_0x8D:
	LDI  R30,LOW(0)
	CP   R30,R4
	BRLT _0x91
; 0000 01E7          _res=0;
	CLR  R4
; 0000 01E8          }
; 0000 01E9 
; 0000 01EA 
; 0000 01EB      if(PINA.4==0){ //Back
_0x91:
	SBIC 0x19,4
	RJMP _0x92
; 0000 01EC      while(PINA.4==0);
_0x93:
	SBIS 0x19,4
	RJMP _0x93
; 0000 01ED      return 0;
	LDI  R30,LOW(0)
	RJMP _0x2080005
; 0000 01EE      }
; 0000 01EF      delay_ms(25);
_0x92:
	CALL SUBOPT_0xE
; 0000 01F0  }
	RJMP _0x85
; 0000 01F1 
; 0000 01F2 
; 0000 01F3 }
_0x2080005:
	ADIW R28,17
	RET
;
;//// data setting
;
;char set_data(void){
; 0000 01F7 char set_data(void){
_set_data:
; 0000 01F8 char _chose=0;
; 0000 01F9 char buff[17];
; 0000 01FA  while(1){
	SBIW R28,17
	ST   -Y,R17
;	_chose -> R17
;	buff -> Y+1
	LDI  R17,0
_0x96:
; 0000 01FB 
; 0000 01FC         if(_chose==1){
	CPI  R17,1
	BRNE _0x99
; 0000 01FD         sprintf(buff,"Set month=%d  >",month);
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,200
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_month
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1B
; 0000 01FE         lcd_clear();
; 0000 01FF         lcd_puts(buff);
; 0000 0200         }
; 0000 0201 
; 0000 0202          if(_chose==0){
_0x99:
	CPI  R17,0
	BRNE _0x9A
; 0000 0203         sprintf(buff,"Set day=%d  >",day);
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,216
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R12
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1B
; 0000 0204         lcd_clear();
; 0000 0205         lcd_puts(buff);
; 0000 0206         }
; 0000 0207 
; 0000 0208 
; 0000 0209         if(_chose==2){
_0x9A:
	CPI  R17,2
	BRNE _0x9B
; 0000 020A         sprintf(buff,"Set year=%d  >",year);
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,230
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xB
	CALL SUBOPT_0x1B
; 0000 020B         lcd_clear();
; 0000 020C         lcd_puts(buff);
; 0000 020D         }
; 0000 020E 
; 0000 020F 
; 0000 0210          if(PINA.1==0 & _chose==1){ //UP     month
_0x9B:
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x11
	BREQ _0x9C
; 0000 0211          while(PINA.1==0);
_0x9D:
	SBIS 0x19,1
	RJMP _0x9D
; 0000 0212          month++;
	LDS  R30,_month
	SUBI R30,-LOW(1)
	STS  _month,R30
; 0000 0213          if(month>12)
	LDS  R26,_month
	CPI  R26,LOW(0xD)
	BRLT _0xA0
; 0000 0214          month=1;
	LDI  R30,LOW(1)
	STS  _month,R30
; 0000 0215          }
_0xA0:
; 0000 0216 
; 0000 0217          if(PINA.0==0& _chose==1){ //DOWN    month
_0x9C:
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x11
	BREQ _0xA1
; 0000 0218          while(PINA.0==0);
_0xA2:
	SBIS 0x19,0
	RJMP _0xA2
; 0000 0219          month--;
	LDS  R30,_month
	SUBI R30,LOW(1)
	STS  _month,R30
; 0000 021A          if(month<1)
	LDS  R26,_month
	CPI  R26,LOW(0x1)
	BRGE _0xA5
; 0000 021B          month=12;
	LDI  R30,LOW(12)
	STS  _month,R30
; 0000 021C          }
_0xA5:
; 0000 021D 
; 0000 021E          if(PINA.1==0 & _chose==0){ //UP    day
_0xA1:
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x10
	BREQ _0xA6
; 0000 021F          while(PINA.1==0);
_0xA7:
	SBIS 0x19,1
	RJMP _0xA7
; 0000 0220          day++;
	INC  R12
; 0000 0221          i=day;
	MOV  R30,R12
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	CALL __EEPROMWRB
; 0000 0222          if(day>31)
	LDI  R30,LOW(31)
	CP   R30,R12
	BRGE _0xAA
; 0000 0223          day=1;
	LDI  R30,LOW(1)
	MOV  R12,R30
; 0000 0224          }
_0xAA:
; 0000 0225 
; 0000 0226          if(PINA.0==0& _chose==0){ //DOWN    day
_0xA6:
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x10
	BREQ _0xAB
; 0000 0227          while(PINA.0==0);
_0xAC:
	SBIS 0x19,0
	RJMP _0xAC
; 0000 0228          day--;
	DEC  R12
; 0000 0229          i=day;
	MOV  R30,R12
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	CALL __EEPROMWRB
; 0000 022A          if(day<1)
	LDI  R30,LOW(1)
	CP   R12,R30
	BRGE _0xAF
; 0000 022B          day=31;
	LDI  R30,LOW(31)
	MOV  R12,R30
; 0000 022C          }
_0xAF:
; 0000 022D 
; 0000 022E          if(PINA.0==0& _chose==2){ //DOWN    year
_0xAB:
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x12
	BREQ _0xB0
; 0000 022F          while(PINA.0==0);
_0xB1:
	SBIS 0x19,0
	RJMP _0xB1
; 0000 0230          year--;
	CALL SUBOPT_0x2
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0231          if(year<1)
	LDS  R26,_year
	LDS  R27,_year+1
	SBIW R26,1
	BRGE _0xB4
; 0000 0232          year=1300;
	LDI  R30,LOW(1300)
	LDI  R31,HIGH(1300)
	STS  _year,R30
	STS  _year+1,R31
; 0000 0233          }
_0xB4:
; 0000 0234 
; 0000 0235          if(PINA.1==0 & _chose==2){ //UP    year
_0xB0:
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x12
	BREQ _0xB5
; 0000 0236          while(PINA.1==0);
_0xB6:
	SBIS 0x19,1
	RJMP _0xB6
; 0000 0237          year++;
	CALL SUBOPT_0x2
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0238          //if(year>1404)
; 0000 0239          //year=0;
; 0000 023A          }
; 0000 023B 
; 0000 023C 
; 0000 023D 
; 0000 023E 
; 0000 023F 
; 0000 0240 
; 0000 0241        if(PINA.3==0){ //NEXT
_0xB5:
	SBIC 0x19,3
	RJMP _0xB9
; 0000 0242              while(PINA.3==0);
_0xBA:
	SBIS 0x19,3
	RJMP _0xBA
; 0000 0243              _chose++;
	SUBI R17,-1
; 0000 0244                  if(_chose>=3)
	CPI  R17,3
	BRLO _0xBD
; 0000 0245                  _chose=0;
	LDI  R17,LOW(0)
; 0000 0246                 }
_0xBD:
; 0000 0247 
; 0000 0248 
; 0000 0249 
; 0000 024A 
; 0000 024B         if(PINA.4==0){ //Back
_0xB9:
	SBIC 0x19,4
	RJMP _0xBE
; 0000 024C          while(PINA.4==0);
_0xBF:
	SBIS 0x19,4
	RJMP _0xBF
; 0000 024D          return 0;
	LDI  R30,LOW(0)
	RJMP _0x2080004
; 0000 024E          }
; 0000 024F 
; 0000 0250          delay_ms(25);
_0xBE:
	CALL SUBOPT_0xE
; 0000 0251  }
	RJMP _0x96
; 0000 0252 }
_0x2080004:
	LDD  R17,Y+0
	ADIW R28,18
	RET
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__print_G100:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x1E
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x1E
	RJMP _0x20000C9
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x1F
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x20
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x21
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x21
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x22
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x22
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x1E
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x1E
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x20
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x1E
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x20
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x23
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080003
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x23
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080003:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x18,3
	RJMP _0x2020005
_0x2020004:
	CBI  0x18,3
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x18,4
	RJMP _0x2020007
_0x2020006:
	CBI  0x18,4
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x18,5
	RJMP _0x2020009
_0x2020008:
	CBI  0x18,5
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x18,6
	RJMP _0x202000B
_0x202000A:
	CBI  0x18,6
_0x202000B:
	__DELAY_USB 5
	SBI  0x18,2
	__DELAY_USB 13
	CBI  0x18,2
	__DELAY_USB 13
	RJMP _0x2080001
__lcd_write_data:
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 133
	RJMP _0x2080001
_lcd_gotoxy:
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R26,LOW(2)
	CALL SUBOPT_0x24
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x24
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020010
_0x2020011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020013
	RJMP _0x2080001
_0x2020013:
_0x2020010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x2080001
_lcd_puts:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020014
_0x2020016:
	RJMP _0x2080002
_lcd_putsf:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020019
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020017
_0x2020019:
_0x2080002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	ST   -Y,R26
	SBI  0x17,3
	SBI  0x17,4
	SBI  0x17,5
	SBI  0x17,6
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x25
	CALL SUBOPT_0x25
	CALL SUBOPT_0x25
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG
_strlen:
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.ESEG
_vurud_stat:
	.BYTE 0x3E
_khuruj_stat:
	.BYTE 0x3E
_i:
	.BYTE 0x1

	.DSEG
_month:
	.BYTE 0x1
_year:
	.BYTE 0x2
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	CALL __GTB12
	MOV  R0,R30
	LDS  R26,_month
	LDI  R30,LOW(6)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(1)
	MOV  R12,R30
	LDS  R30,_month
	SUBI R30,-LOW(1)
	STS  _month,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_year)
	LDI  R27,HIGH(_year)
	LD   R30,X+
	LD   R31,X+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x4:
	MOV  R26,R5
	LDI  R27,0
	SBRC R26,7
	SER  R27
	MOV  R30,R4
	LDI  R31,0
	SBRC R30,7
	SER  R31
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x7:
	MOV  R26,R10
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	MOV  R26,R11
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R0,R30
	MOV  R26,R13
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(_vurud_stat)
	LDI  R27,HIGH(_vurud_stat)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(_khuruj_stat)
	LDI  R27,HIGH(_khuruj_stat)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0xA:
	CALL __CBD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB:
	LDS  R30,_year
	LDS  R31,_year+1
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	MOVW R26,R28
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(25)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xF:
	LDI  R26,0
	SBIC 0x19,2
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	MOV  R26,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(2)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	CALL _lcd_clear
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	LDI  R26,0
	SBIC 0x19,1
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	LDI  R26,0
	SBRC R15,0
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	LDI  R26,0
	SBIC 0x19,0
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	LDI  R26,0
	SBRC R15,0
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	MOV  R0,R30
	LDI  R26,0
	SBRC R15,0
	LDI  R26,1
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x17:
	CALL __GTB12U
	AND  R0,R30
	LDI  R26,0
	SBRC R15,0
	LDI  R26,1
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDI  R16,LOW(1)
	SUBI R17,-1
	CLT
	BLD  R15,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1B:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	CALL _lcd_clear
	MOVW R26,R28
	ADIW R26,1
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1C:
	LDI  R26,0
	SBIC 0x19,1
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	MOV  R26,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1D:
	LDI  R26,0
	SBIC 0x19,0
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	MOV  R26,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1E:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1F:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x21:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x25:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G101
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__LEB12:
	CP   R30,R26
	LDI  R30,1
	BRGE __LEB12T
	CLR  R30
__LEB12T:
	RET

__GTB12:
	CP   R30,R26
	LDI  R30,1
	BRLT __GTB12T
	CLR  R30
__GTB12T:
	RET

__LEB12U:
	CP   R30,R26
	LDI  R30,1
	BRSH __LEB12U1
	CLR  R30
__LEB12U1:
	RET

__LTB12U:
	CP   R26,R30
	LDI  R30,1
	BRLO __LTB12U1
	CLR  R30
__LTB12U1:
	RET

__GTB12U:
	CP   R30,R26
	LDI  R30,1
	BRLO __GTB12U1
	CLR  R30
__GTB12U1:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
