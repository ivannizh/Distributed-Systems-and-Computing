;
; AssemblerApplication2.asm
;
; Created: 12.04.2020 19:24:13
; Author : Ivan
;


.include "m168def.inc"

.equ Bitrate = 19200
.equ BAUD = 8000000 / (16 * Bitrate) - 1


.equ TIM_0_DELAY_MICROSEC = 31; MAX 31 micro sec
.equ TIM_2_DELAY_MICROSEC = 31; MAX 31 micro sec


.equ TIM_0_DELAY_FIRST = 0x00
.equ TIM_2_DELAY_FIRST = 0x80

.equ TIM_0_DELAY = TIM_0_DELAY_MICROSEC * 8
.equ TIM_2_DELAY = TIM_2_DELAY_MICROSEC * 8

.equ TIM_0_DELAY_REG = 0xff - TIM_0_DELAY
.equ TIM_2_DELAY_REG = 0xff - TIM_2_DELAY

.dseg
.cseg

.org 0x0000
jmp Reset
jmp EXT_INT0
jmp EXT_INT1
jmp PC_INT0
jmp PC_INT1
jmp PC_INT2
jmp WDT
jmp TIM2_COMPA
jmp TIM2_COMPB
jmp TIM2_OVF
jmp TIM1_CAPT
jmp TIM1_COMPA
jmp TIM1_COMPB
jmp TIM1_OVF
jmp TIM0_COMPA
jmp TIM0_COMPB
jmp TIM0_OVF
jmp SPI_STC
jmp USART_RXC
jmp USART_UDRE
jmp USART_TXC
jmp ADC_INT
jmp EE_RDY
jmp ANA_COMP
jmp TWI
jmp SPM_RDY

MSG_1:
.db 'P','I','N','G','\r','\n'

MSG_2:
.db 'p','o','n','g','\r','\n'

reset:
	ldi r16, high(ramend)
	out sph, r16
	ldi r16, low(ramend)
	out spl, r16

	ldi r16, high(BAUD)
	sts UBRR0H, r16
	ldi r16, low(BAUD)
	sts UBRR0L, r16

	ldi r16, 0b11011000 
	sts UCSR0B, r16 
	ldi r16, 0b00000110 
	sts UCSR0C, r16


	ldi r16, 0b00000101
	out TCCR0B, r16
	sts TCCR2B, r16

    ldi r16, 0b00000001
	sts TIMSK0, r16
	sts TIFR0, r16
	sts TIMSK2, r16
	sts TIFR2, r16

	ldi r16, TIM_0_DELAY_FIRST
	sts TCNT0, r16

	ldi r16, TIM_2_DELAY_FIRST 
	sts TCNT2, r16
	
	sei

start:
	rjmp start


SEND_MSG:
	lpm
	mov r17, r0
label:
	lds r18, UCSR0A
    sbrs r18, UDRE0
	rjmp label

	sts UDR0, r17

	ldi r20, 0
	ret

USART_TXC: // Прерывание по отсылке байта
	cli // Запрещаем прерывания
	push r16
	push r18
	push r17
	;sbis UCSRA,UDRE // Стандартная проверка из тех.дока, если UDRE = 1 пропускаем следующую строку 
	
	lds r18, UCSR0A
    sbrs r18,UDRE0
	rjmp USART_TXC // Либо вращаемся в цикле
	
	cpi r20, 1
	breq VixUT

	ldi r16, 1
	add ZL, r16
	ldi r16, 0
	adc zH, r16
	
	lpm                  
	
	mov r17, r0
	sts UDR0, r17

	cpi r17, '\n'
	brne VixUT
	ldi r20, 1

VixUT:
	pop r16
	pop r17
	pop r18
	sei
	reti

TIM0_OVF:
	cli
	push r16

	ldi ZH,High(MSG_1*2)
    ldi ZL,Low(MSG_1*2) 
	rcall send_msg

	ldi r16, TIM_0_DELAY_REG
	sts TCNT0, r16
	pop r16
	sei
	reti

TIM2_OVF:
	cli
	push r16
	ldi ZH,High(MSG_2*2)
    ldi ZL,Low(MSG_2*2) 
	rcall send_msg

	ldi r16, TIM_2_DELAY_REG
	sts TCNT2, r16
	pop r16
	sei
	reti


EXT_INT0:
EXT_INT1:
PC_INT0:
PC_INT1:
PC_INT2:
WDT:
TIM2_COMPA:
TIM2_COMPB:
TIM2_OVF_2:
TIM1_CAPT:
TIM1_COMPA:
TIM1_COMPB:
TIM1_OVF:
TIM0_COMPA:
TIM0_COMPB:
TIM0_OVF_2:
SPI_STC:
USART_RXC:
USART_UDRE:
ADC_INT:
EE_RDY:
ANA_COMP:
TWI:
SPM_RDY:
      reti