
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	b0010113          	add	sp,sp,-1280 # 80008b00 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	add	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	add	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	add	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	sllw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	sll	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	sll	a3,a3,0x3
    80000050:	00009717          	auipc	a4,0x9
    80000054:	97070713          	add	a4,a4,-1680 # 800089c0 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	d6e78793          	add	a5,a5,-658 # 80005dd0 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	or	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	or	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	add	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	add	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc9cf>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	dc678793          	add	a5,a5,-570 # 80000e72 <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srl	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	add	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	add	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	fc26                	sd	s1,56(sp)
    80000108:	f84a                	sd	s2,48(sp)
    8000010a:	f44e                	sd	s3,40(sp)
    8000010c:	f052                	sd	s4,32(sp)
    8000010e:	ec56                	sd	s5,24(sp)
    80000110:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000112:	04c05763          	blez	a2,80000160 <consolewrite+0x60>
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	add	a0,s0,-65
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	382080e7          	jalr	898(ra) # 800024ac <either_copyin>
    80000132:	01550d63          	beq	a0,s5,8000014c <consolewrite+0x4c>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	780080e7          	jalr	1920(ra) # 800008ba <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addw	s2,s2,1
    80000144:	0485                	add	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	add	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4c>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	711d                	add	sp,sp,-96
    80000166:	ec86                	sd	ra,88(sp)
    80000168:	e8a2                	sd	s0,80(sp)
    8000016a:	e4a6                	sd	s1,72(sp)
    8000016c:	e0ca                	sd	s2,64(sp)
    8000016e:	fc4e                	sd	s3,56(sp)
    80000170:	f852                	sd	s4,48(sp)
    80000172:	f456                	sd	s5,40(sp)
    80000174:	f05a                	sd	s6,32(sp)
    80000176:	ec5e                	sd	s7,24(sp)
    80000178:	1080                	add	s0,sp,96
    8000017a:	8aaa                	mv	s5,a0
    8000017c:	8a2e                	mv	s4,a1
    8000017e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000180:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000184:	00011517          	auipc	a0,0x11
    80000188:	97c50513          	add	a0,a0,-1668 # 80010b00 <cons>
    8000018c:	00001097          	auipc	ra,0x1
    80000190:	a46080e7          	jalr	-1466(ra) # 80000bd2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000194:	00011497          	auipc	s1,0x11
    80000198:	96c48493          	add	s1,s1,-1684 # 80010b00 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000019c:	00011917          	auipc	s2,0x11
    800001a0:	9fc90913          	add	s2,s2,-1540 # 80010b98 <cons+0x98>
  while(n > 0){
    800001a4:	09305263          	blez	s3,80000228 <consoleread+0xc4>
    while(cons.r == cons.w){
    800001a8:	0984a783          	lw	a5,152(s1)
    800001ac:	09c4a703          	lw	a4,156(s1)
    800001b0:	02f71763          	bne	a4,a5,800001de <consoleread+0x7a>
      if(killed(myproc())){
    800001b4:	00001097          	auipc	ra,0x1
    800001b8:	7f2080e7          	jalr	2034(ra) # 800019a6 <myproc>
    800001bc:	00002097          	auipc	ra,0x2
    800001c0:	13a080e7          	jalr	314(ra) # 800022f6 <killed>
    800001c4:	ed2d                	bnez	a0,8000023e <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    800001c6:	85a6                	mv	a1,s1
    800001c8:	854a                	mv	a0,s2
    800001ca:	00002097          	auipc	ra,0x2
    800001ce:	e84080e7          	jalr	-380(ra) # 8000204e <sleep>
    while(cons.r == cons.w){
    800001d2:	0984a783          	lw	a5,152(s1)
    800001d6:	09c4a703          	lw	a4,156(s1)
    800001da:	fcf70de3          	beq	a4,a5,800001b4 <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	00011717          	auipc	a4,0x11
    800001e2:	92270713          	add	a4,a4,-1758 # 80010b00 <cons>
    800001e6:	0017869b          	addw	a3,a5,1
    800001ea:	08d72c23          	sw	a3,152(a4)
    800001ee:	07f7f693          	and	a3,a5,127
    800001f2:	9736                	add	a4,a4,a3
    800001f4:	01874703          	lbu	a4,24(a4)
    800001f8:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001fc:	4691                	li	a3,4
    800001fe:	06db8463          	beq	s7,a3,80000266 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000202:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000206:	4685                	li	a3,1
    80000208:	faf40613          	add	a2,s0,-81
    8000020c:	85d2                	mv	a1,s4
    8000020e:	8556                	mv	a0,s5
    80000210:	00002097          	auipc	ra,0x2
    80000214:	246080e7          	jalr	582(ra) # 80002456 <either_copyout>
    80000218:	57fd                	li	a5,-1
    8000021a:	00f50763          	beq	a0,a5,80000228 <consoleread+0xc4>
      break;

    dst++;
    8000021e:	0a05                	add	s4,s4,1
    --n;
    80000220:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    80000222:	47a9                	li	a5,10
    80000224:	f8fb90e3          	bne	s7,a5,800001a4 <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000228:	00011517          	auipc	a0,0x11
    8000022c:	8d850513          	add	a0,a0,-1832 # 80010b00 <cons>
    80000230:	00001097          	auipc	ra,0x1
    80000234:	a56080e7          	jalr	-1450(ra) # 80000c86 <release>

  return target - n;
    80000238:	413b053b          	subw	a0,s6,s3
    8000023c:	a811                	j	80000250 <consoleread+0xec>
        release(&cons.lock);
    8000023e:	00011517          	auipc	a0,0x11
    80000242:	8c250513          	add	a0,a0,-1854 # 80010b00 <cons>
    80000246:	00001097          	auipc	ra,0x1
    8000024a:	a40080e7          	jalr	-1472(ra) # 80000c86 <release>
        return -1;
    8000024e:	557d                	li	a0,-1
}
    80000250:	60e6                	ld	ra,88(sp)
    80000252:	6446                	ld	s0,80(sp)
    80000254:	64a6                	ld	s1,72(sp)
    80000256:	6906                	ld	s2,64(sp)
    80000258:	79e2                	ld	s3,56(sp)
    8000025a:	7a42                	ld	s4,48(sp)
    8000025c:	7aa2                	ld	s5,40(sp)
    8000025e:	7b02                	ld	s6,32(sp)
    80000260:	6be2                	ld	s7,24(sp)
    80000262:	6125                	add	sp,sp,96
    80000264:	8082                	ret
      if(n < target){
    80000266:	0009871b          	sext.w	a4,s3
    8000026a:	fb677fe3          	bgeu	a4,s6,80000228 <consoleread+0xc4>
        cons.r--;
    8000026e:	00011717          	auipc	a4,0x11
    80000272:	92f72523          	sw	a5,-1750(a4) # 80010b98 <cons+0x98>
    80000276:	bf4d                	j	80000228 <consoleread+0xc4>

0000000080000278 <consputc>:
{
    80000278:	1141                	add	sp,sp,-16
    8000027a:	e406                	sd	ra,8(sp)
    8000027c:	e022                	sd	s0,0(sp)
    8000027e:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    80000280:	10000793          	li	a5,256
    80000284:	00f50a63          	beq	a0,a5,80000298 <consputc+0x20>
    uartputc_sync(c);
    80000288:	00000097          	auipc	ra,0x0
    8000028c:	560080e7          	jalr	1376(ra) # 800007e8 <uartputc_sync>
}
    80000290:	60a2                	ld	ra,8(sp)
    80000292:	6402                	ld	s0,0(sp)
    80000294:	0141                	add	sp,sp,16
    80000296:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000298:	4521                	li	a0,8
    8000029a:	00000097          	auipc	ra,0x0
    8000029e:	54e080e7          	jalr	1358(ra) # 800007e8 <uartputc_sync>
    800002a2:	02000513          	li	a0,32
    800002a6:	00000097          	auipc	ra,0x0
    800002aa:	542080e7          	jalr	1346(ra) # 800007e8 <uartputc_sync>
    800002ae:	4521                	li	a0,8
    800002b0:	00000097          	auipc	ra,0x0
    800002b4:	538080e7          	jalr	1336(ra) # 800007e8 <uartputc_sync>
    800002b8:	bfe1                	j	80000290 <consputc+0x18>

00000000800002ba <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002ba:	1101                	add	sp,sp,-32
    800002bc:	ec06                	sd	ra,24(sp)
    800002be:	e822                	sd	s0,16(sp)
    800002c0:	e426                	sd	s1,8(sp)
    800002c2:	e04a                	sd	s2,0(sp)
    800002c4:	1000                	add	s0,sp,32
    800002c6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002c8:	00011517          	auipc	a0,0x11
    800002cc:	83850513          	add	a0,a0,-1992 # 80010b00 <cons>
    800002d0:	00001097          	auipc	ra,0x1
    800002d4:	902080e7          	jalr	-1790(ra) # 80000bd2 <acquire>

  switch(c){
    800002d8:	47d5                	li	a5,21
    800002da:	0af48663          	beq	s1,a5,80000386 <consoleintr+0xcc>
    800002de:	0297ca63          	blt	a5,s1,80000312 <consoleintr+0x58>
    800002e2:	47a1                	li	a5,8
    800002e4:	0ef48763          	beq	s1,a5,800003d2 <consoleintr+0x118>
    800002e8:	47c1                	li	a5,16
    800002ea:	10f49a63          	bne	s1,a5,800003fe <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002ee:	00002097          	auipc	ra,0x2
    800002f2:	214080e7          	jalr	532(ra) # 80002502 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002f6:	00011517          	auipc	a0,0x11
    800002fa:	80a50513          	add	a0,a0,-2038 # 80010b00 <cons>
    800002fe:	00001097          	auipc	ra,0x1
    80000302:	988080e7          	jalr	-1656(ra) # 80000c86 <release>
}
    80000306:	60e2                	ld	ra,24(sp)
    80000308:	6442                	ld	s0,16(sp)
    8000030a:	64a2                	ld	s1,8(sp)
    8000030c:	6902                	ld	s2,0(sp)
    8000030e:	6105                	add	sp,sp,32
    80000310:	8082                	ret
  switch(c){
    80000312:	07f00793          	li	a5,127
    80000316:	0af48e63          	beq	s1,a5,800003d2 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000031a:	00010717          	auipc	a4,0x10
    8000031e:	7e670713          	add	a4,a4,2022 # 80010b00 <cons>
    80000322:	0a072783          	lw	a5,160(a4)
    80000326:	09872703          	lw	a4,152(a4)
    8000032a:	9f99                	subw	a5,a5,a4
    8000032c:	07f00713          	li	a4,127
    80000330:	fcf763e3          	bltu	a4,a5,800002f6 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000334:	47b5                	li	a5,13
    80000336:	0cf48763          	beq	s1,a5,80000404 <consoleintr+0x14a>
      consputc(c);
    8000033a:	8526                	mv	a0,s1
    8000033c:	00000097          	auipc	ra,0x0
    80000340:	f3c080e7          	jalr	-196(ra) # 80000278 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000344:	00010797          	auipc	a5,0x10
    80000348:	7bc78793          	add	a5,a5,1980 # 80010b00 <cons>
    8000034c:	0a07a683          	lw	a3,160(a5)
    80000350:	0016871b          	addw	a4,a3,1
    80000354:	0007061b          	sext.w	a2,a4
    80000358:	0ae7a023          	sw	a4,160(a5)
    8000035c:	07f6f693          	and	a3,a3,127
    80000360:	97b6                	add	a5,a5,a3
    80000362:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000366:	47a9                	li	a5,10
    80000368:	0cf48563          	beq	s1,a5,80000432 <consoleintr+0x178>
    8000036c:	4791                	li	a5,4
    8000036e:	0cf48263          	beq	s1,a5,80000432 <consoleintr+0x178>
    80000372:	00011797          	auipc	a5,0x11
    80000376:	8267a783          	lw	a5,-2010(a5) # 80010b98 <cons+0x98>
    8000037a:	9f1d                	subw	a4,a4,a5
    8000037c:	08000793          	li	a5,128
    80000380:	f6f71be3          	bne	a4,a5,800002f6 <consoleintr+0x3c>
    80000384:	a07d                	j	80000432 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000386:	00010717          	auipc	a4,0x10
    8000038a:	77a70713          	add	a4,a4,1914 # 80010b00 <cons>
    8000038e:	0a072783          	lw	a5,160(a4)
    80000392:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000396:	00010497          	auipc	s1,0x10
    8000039a:	76a48493          	add	s1,s1,1898 # 80010b00 <cons>
    while(cons.e != cons.w &&
    8000039e:	4929                	li	s2,10
    800003a0:	f4f70be3          	beq	a4,a5,800002f6 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a4:	37fd                	addw	a5,a5,-1
    800003a6:	07f7f713          	and	a4,a5,127
    800003aa:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003ac:	01874703          	lbu	a4,24(a4)
    800003b0:	f52703e3          	beq	a4,s2,800002f6 <consoleintr+0x3c>
      cons.e--;
    800003b4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003b8:	10000513          	li	a0,256
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	ebc080e7          	jalr	-324(ra) # 80000278 <consputc>
    while(cons.e != cons.w &&
    800003c4:	0a04a783          	lw	a5,160(s1)
    800003c8:	09c4a703          	lw	a4,156(s1)
    800003cc:	fcf71ce3          	bne	a4,a5,800003a4 <consoleintr+0xea>
    800003d0:	b71d                	j	800002f6 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d2:	00010717          	auipc	a4,0x10
    800003d6:	72e70713          	add	a4,a4,1838 # 80010b00 <cons>
    800003da:	0a072783          	lw	a5,160(a4)
    800003de:	09c72703          	lw	a4,156(a4)
    800003e2:	f0f70ae3          	beq	a4,a5,800002f6 <consoleintr+0x3c>
      cons.e--;
    800003e6:	37fd                	addw	a5,a5,-1
    800003e8:	00010717          	auipc	a4,0x10
    800003ec:	7af72c23          	sw	a5,1976(a4) # 80010ba0 <cons+0xa0>
      consputc(BACKSPACE);
    800003f0:	10000513          	li	a0,256
    800003f4:	00000097          	auipc	ra,0x0
    800003f8:	e84080e7          	jalr	-380(ra) # 80000278 <consputc>
    800003fc:	bded                	j	800002f6 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003fe:	ee048ce3          	beqz	s1,800002f6 <consoleintr+0x3c>
    80000402:	bf21                	j	8000031a <consoleintr+0x60>
      consputc(c);
    80000404:	4529                	li	a0,10
    80000406:	00000097          	auipc	ra,0x0
    8000040a:	e72080e7          	jalr	-398(ra) # 80000278 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000040e:	00010797          	auipc	a5,0x10
    80000412:	6f278793          	add	a5,a5,1778 # 80010b00 <cons>
    80000416:	0a07a703          	lw	a4,160(a5)
    8000041a:	0017069b          	addw	a3,a4,1
    8000041e:	0006861b          	sext.w	a2,a3
    80000422:	0ad7a023          	sw	a3,160(a5)
    80000426:	07f77713          	and	a4,a4,127
    8000042a:	97ba                	add	a5,a5,a4
    8000042c:	4729                	li	a4,10
    8000042e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000432:	00010797          	auipc	a5,0x10
    80000436:	76c7a523          	sw	a2,1898(a5) # 80010b9c <cons+0x9c>
        wakeup(&cons.r);
    8000043a:	00010517          	auipc	a0,0x10
    8000043e:	75e50513          	add	a0,a0,1886 # 80010b98 <cons+0x98>
    80000442:	00002097          	auipc	ra,0x2
    80000446:	c70080e7          	jalr	-912(ra) # 800020b2 <wakeup>
    8000044a:	b575                	j	800002f6 <consoleintr+0x3c>

000000008000044c <consoleinit>:

void
consoleinit(void)
{
    8000044c:	1141                	add	sp,sp,-16
    8000044e:	e406                	sd	ra,8(sp)
    80000450:	e022                	sd	s0,0(sp)
    80000452:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80000454:	00008597          	auipc	a1,0x8
    80000458:	bbc58593          	add	a1,a1,-1092 # 80008010 <etext+0x10>
    8000045c:	00010517          	auipc	a0,0x10
    80000460:	6a450513          	add	a0,a0,1700 # 80010b00 <cons>
    80000464:	00000097          	auipc	ra,0x0
    80000468:	6de080e7          	jalr	1758(ra) # 80000b42 <initlock>

  uartinit();
    8000046c:	00000097          	auipc	ra,0x0
    80000470:	32c080e7          	jalr	812(ra) # 80000798 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000474:	00021797          	auipc	a5,0x21
    80000478:	82478793          	add	a5,a5,-2012 # 80020c98 <devsw>
    8000047c:	00000717          	auipc	a4,0x0
    80000480:	ce870713          	add	a4,a4,-792 # 80000164 <consoleread>
    80000484:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000486:	00000717          	auipc	a4,0x0
    8000048a:	c7a70713          	add	a4,a4,-902 # 80000100 <consolewrite>
    8000048e:	ef98                	sd	a4,24(a5)
}
    80000490:	60a2                	ld	ra,8(sp)
    80000492:	6402                	ld	s0,0(sp)
    80000494:	0141                	add	sp,sp,16
    80000496:	8082                	ret

0000000080000498 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80000498:	7179                	add	sp,sp,-48
    8000049a:	f406                	sd	ra,40(sp)
    8000049c:	f022                	sd	s0,32(sp)
    8000049e:	ec26                	sd	s1,24(sp)
    800004a0:	e84a                	sd	s2,16(sp)
    800004a2:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a4:	c219                	beqz	a2,800004aa <printint+0x12>
    800004a6:	08054763          	bltz	a0,80000534 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004aa:	2501                	sext.w	a0,a0
    800004ac:	4881                	li	a7,0
    800004ae:	fd040693          	add	a3,s0,-48

  i = 0;
    800004b2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004b4:	2581                	sext.w	a1,a1
    800004b6:	00008617          	auipc	a2,0x8
    800004ba:	b8a60613          	add	a2,a2,-1142 # 80008040 <digits>
    800004be:	883a                	mv	a6,a4
    800004c0:	2705                	addw	a4,a4,1
    800004c2:	02b577bb          	remuw	a5,a0,a1
    800004c6:	1782                	sll	a5,a5,0x20
    800004c8:	9381                	srl	a5,a5,0x20
    800004ca:	97b2                	add	a5,a5,a2
    800004cc:	0007c783          	lbu	a5,0(a5)
    800004d0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004d4:	0005079b          	sext.w	a5,a0
    800004d8:	02b5553b          	divuw	a0,a0,a1
    800004dc:	0685                	add	a3,a3,1
    800004de:	feb7f0e3          	bgeu	a5,a1,800004be <printint+0x26>

  if(sign)
    800004e2:	00088c63          	beqz	a7,800004fa <printint+0x62>
    buf[i++] = '-';
    800004e6:	fe070793          	add	a5,a4,-32
    800004ea:	00878733          	add	a4,a5,s0
    800004ee:	02d00793          	li	a5,45
    800004f2:	fef70823          	sb	a5,-16(a4)
    800004f6:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    800004fa:	02e05763          	blez	a4,80000528 <printint+0x90>
    800004fe:	fd040793          	add	a5,s0,-48
    80000502:	00e784b3          	add	s1,a5,a4
    80000506:	fff78913          	add	s2,a5,-1
    8000050a:	993a                	add	s2,s2,a4
    8000050c:	377d                	addw	a4,a4,-1
    8000050e:	1702                	sll	a4,a4,0x20
    80000510:	9301                	srl	a4,a4,0x20
    80000512:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000516:	fff4c503          	lbu	a0,-1(s1)
    8000051a:	00000097          	auipc	ra,0x0
    8000051e:	d5e080e7          	jalr	-674(ra) # 80000278 <consputc>
  while(--i >= 0)
    80000522:	14fd                	add	s1,s1,-1
    80000524:	ff2499e3          	bne	s1,s2,80000516 <printint+0x7e>
}
    80000528:	70a2                	ld	ra,40(sp)
    8000052a:	7402                	ld	s0,32(sp)
    8000052c:	64e2                	ld	s1,24(sp)
    8000052e:	6942                	ld	s2,16(sp)
    80000530:	6145                	add	sp,sp,48
    80000532:	8082                	ret
    x = -xx;
    80000534:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000538:	4885                	li	a7,1
    x = -xx;
    8000053a:	bf95                	j	800004ae <printint+0x16>

000000008000053c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000053c:	1101                	add	sp,sp,-32
    8000053e:	ec06                	sd	ra,24(sp)
    80000540:	e822                	sd	s0,16(sp)
    80000542:	e426                	sd	s1,8(sp)
    80000544:	1000                	add	s0,sp,32
    80000546:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000548:	00010797          	auipc	a5,0x10
    8000054c:	6607ac23          	sw	zero,1656(a5) # 80010bc0 <pr+0x18>
  printf("panic: ");
    80000550:	00008517          	auipc	a0,0x8
    80000554:	ac850513          	add	a0,a0,-1336 # 80008018 <etext+0x18>
    80000558:	00000097          	auipc	ra,0x0
    8000055c:	02e080e7          	jalr	46(ra) # 80000586 <printf>
  printf(s);
    80000560:	8526                	mv	a0,s1
    80000562:	00000097          	auipc	ra,0x0
    80000566:	024080e7          	jalr	36(ra) # 80000586 <printf>
  printf("\n");
    8000056a:	00008517          	auipc	a0,0x8
    8000056e:	b6e50513          	add	a0,a0,-1170 # 800080d8 <digits+0x98>
    80000572:	00000097          	auipc	ra,0x0
    80000576:	014080e7          	jalr	20(ra) # 80000586 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057a:	4785                	li	a5,1
    8000057c:	00008717          	auipc	a4,0x8
    80000580:	40f72223          	sw	a5,1028(a4) # 80008980 <panicked>
  for(;;)
    80000584:	a001                	j	80000584 <panic+0x48>

0000000080000586 <printf>:
{
    80000586:	7131                	add	sp,sp,-192
    80000588:	fc86                	sd	ra,120(sp)
    8000058a:	f8a2                	sd	s0,112(sp)
    8000058c:	f4a6                	sd	s1,104(sp)
    8000058e:	f0ca                	sd	s2,96(sp)
    80000590:	ecce                	sd	s3,88(sp)
    80000592:	e8d2                	sd	s4,80(sp)
    80000594:	e4d6                	sd	s5,72(sp)
    80000596:	e0da                	sd	s6,64(sp)
    80000598:	fc5e                	sd	s7,56(sp)
    8000059a:	f862                	sd	s8,48(sp)
    8000059c:	f466                	sd	s9,40(sp)
    8000059e:	f06a                	sd	s10,32(sp)
    800005a0:	ec6e                	sd	s11,24(sp)
    800005a2:	0100                	add	s0,sp,128
    800005a4:	8a2a                	mv	s4,a0
    800005a6:	e40c                	sd	a1,8(s0)
    800005a8:	e810                	sd	a2,16(s0)
    800005aa:	ec14                	sd	a3,24(s0)
    800005ac:	f018                	sd	a4,32(s0)
    800005ae:	f41c                	sd	a5,40(s0)
    800005b0:	03043823          	sd	a6,48(s0)
    800005b4:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005b8:	00010d97          	auipc	s11,0x10
    800005bc:	608dad83          	lw	s11,1544(s11) # 80010bc0 <pr+0x18>
  if(locking)
    800005c0:	020d9b63          	bnez	s11,800005f6 <printf+0x70>
  if (fmt == 0)
    800005c4:	040a0263          	beqz	s4,80000608 <printf+0x82>
  va_start(ap, fmt);
    800005c8:	00840793          	add	a5,s0,8
    800005cc:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d0:	000a4503          	lbu	a0,0(s4)
    800005d4:	14050f63          	beqz	a0,80000732 <printf+0x1ac>
    800005d8:	4981                	li	s3,0
    if(c != '%'){
    800005da:	02500a93          	li	s5,37
    switch(c){
    800005de:	07000b93          	li	s7,112
  consputc('x');
    800005e2:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e4:	00008b17          	auipc	s6,0x8
    800005e8:	a5cb0b13          	add	s6,s6,-1444 # 80008040 <digits>
    switch(c){
    800005ec:	07300c93          	li	s9,115
    800005f0:	06400c13          	li	s8,100
    800005f4:	a82d                	j	8000062e <printf+0xa8>
    acquire(&pr.lock);
    800005f6:	00010517          	auipc	a0,0x10
    800005fa:	5b250513          	add	a0,a0,1458 # 80010ba8 <pr>
    800005fe:	00000097          	auipc	ra,0x0
    80000602:	5d4080e7          	jalr	1492(ra) # 80000bd2 <acquire>
    80000606:	bf7d                	j	800005c4 <printf+0x3e>
    panic("null fmt");
    80000608:	00008517          	auipc	a0,0x8
    8000060c:	a2050513          	add	a0,a0,-1504 # 80008028 <etext+0x28>
    80000610:	00000097          	auipc	ra,0x0
    80000614:	f2c080e7          	jalr	-212(ra) # 8000053c <panic>
      consputc(c);
    80000618:	00000097          	auipc	ra,0x0
    8000061c:	c60080e7          	jalr	-928(ra) # 80000278 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000620:	2985                	addw	s3,s3,1
    80000622:	013a07b3          	add	a5,s4,s3
    80000626:	0007c503          	lbu	a0,0(a5)
    8000062a:	10050463          	beqz	a0,80000732 <printf+0x1ac>
    if(c != '%'){
    8000062e:	ff5515e3          	bne	a0,s5,80000618 <printf+0x92>
    c = fmt[++i] & 0xff;
    80000632:	2985                	addw	s3,s3,1
    80000634:	013a07b3          	add	a5,s4,s3
    80000638:	0007c783          	lbu	a5,0(a5)
    8000063c:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000640:	cbed                	beqz	a5,80000732 <printf+0x1ac>
    switch(c){
    80000642:	05778a63          	beq	a5,s7,80000696 <printf+0x110>
    80000646:	02fbf663          	bgeu	s7,a5,80000672 <printf+0xec>
    8000064a:	09978863          	beq	a5,s9,800006da <printf+0x154>
    8000064e:	07800713          	li	a4,120
    80000652:	0ce79563          	bne	a5,a4,8000071c <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000656:	f8843783          	ld	a5,-120(s0)
    8000065a:	00878713          	add	a4,a5,8
    8000065e:	f8e43423          	sd	a4,-120(s0)
    80000662:	4605                	li	a2,1
    80000664:	85ea                	mv	a1,s10
    80000666:	4388                	lw	a0,0(a5)
    80000668:	00000097          	auipc	ra,0x0
    8000066c:	e30080e7          	jalr	-464(ra) # 80000498 <printint>
      break;
    80000670:	bf45                	j	80000620 <printf+0x9a>
    switch(c){
    80000672:	09578f63          	beq	a5,s5,80000710 <printf+0x18a>
    80000676:	0b879363          	bne	a5,s8,8000071c <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000067a:	f8843783          	ld	a5,-120(s0)
    8000067e:	00878713          	add	a4,a5,8
    80000682:	f8e43423          	sd	a4,-120(s0)
    80000686:	4605                	li	a2,1
    80000688:	45a9                	li	a1,10
    8000068a:	4388                	lw	a0,0(a5)
    8000068c:	00000097          	auipc	ra,0x0
    80000690:	e0c080e7          	jalr	-500(ra) # 80000498 <printint>
      break;
    80000694:	b771                	j	80000620 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000696:	f8843783          	ld	a5,-120(s0)
    8000069a:	00878713          	add	a4,a5,8
    8000069e:	f8e43423          	sd	a4,-120(s0)
    800006a2:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006a6:	03000513          	li	a0,48
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	bce080e7          	jalr	-1074(ra) # 80000278 <consputc>
  consputc('x');
    800006b2:	07800513          	li	a0,120
    800006b6:	00000097          	auipc	ra,0x0
    800006ba:	bc2080e7          	jalr	-1086(ra) # 80000278 <consputc>
    800006be:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c0:	03c95793          	srl	a5,s2,0x3c
    800006c4:	97da                	add	a5,a5,s6
    800006c6:	0007c503          	lbu	a0,0(a5)
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	bae080e7          	jalr	-1106(ra) # 80000278 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d2:	0912                	sll	s2,s2,0x4
    800006d4:	34fd                	addw	s1,s1,-1
    800006d6:	f4ed                	bnez	s1,800006c0 <printf+0x13a>
    800006d8:	b7a1                	j	80000620 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006da:	f8843783          	ld	a5,-120(s0)
    800006de:	00878713          	add	a4,a5,8
    800006e2:	f8e43423          	sd	a4,-120(s0)
    800006e6:	6384                	ld	s1,0(a5)
    800006e8:	cc89                	beqz	s1,80000702 <printf+0x17c>
      for(; *s; s++)
    800006ea:	0004c503          	lbu	a0,0(s1)
    800006ee:	d90d                	beqz	a0,80000620 <printf+0x9a>
        consputc(*s);
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	b88080e7          	jalr	-1144(ra) # 80000278 <consputc>
      for(; *s; s++)
    800006f8:	0485                	add	s1,s1,1
    800006fa:	0004c503          	lbu	a0,0(s1)
    800006fe:	f96d                	bnez	a0,800006f0 <printf+0x16a>
    80000700:	b705                	j	80000620 <printf+0x9a>
        s = "(null)";
    80000702:	00008497          	auipc	s1,0x8
    80000706:	91e48493          	add	s1,s1,-1762 # 80008020 <etext+0x20>
      for(; *s; s++)
    8000070a:	02800513          	li	a0,40
    8000070e:	b7cd                	j	800006f0 <printf+0x16a>
      consputc('%');
    80000710:	8556                	mv	a0,s5
    80000712:	00000097          	auipc	ra,0x0
    80000716:	b66080e7          	jalr	-1178(ra) # 80000278 <consputc>
      break;
    8000071a:	b719                	j	80000620 <printf+0x9a>
      consputc('%');
    8000071c:	8556                	mv	a0,s5
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	b5a080e7          	jalr	-1190(ra) # 80000278 <consputc>
      consputc(c);
    80000726:	8526                	mv	a0,s1
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	b50080e7          	jalr	-1200(ra) # 80000278 <consputc>
      break;
    80000730:	bdc5                	j	80000620 <printf+0x9a>
  if(locking)
    80000732:	020d9163          	bnez	s11,80000754 <printf+0x1ce>
}
    80000736:	70e6                	ld	ra,120(sp)
    80000738:	7446                	ld	s0,112(sp)
    8000073a:	74a6                	ld	s1,104(sp)
    8000073c:	7906                	ld	s2,96(sp)
    8000073e:	69e6                	ld	s3,88(sp)
    80000740:	6a46                	ld	s4,80(sp)
    80000742:	6aa6                	ld	s5,72(sp)
    80000744:	6b06                	ld	s6,64(sp)
    80000746:	7be2                	ld	s7,56(sp)
    80000748:	7c42                	ld	s8,48(sp)
    8000074a:	7ca2                	ld	s9,40(sp)
    8000074c:	7d02                	ld	s10,32(sp)
    8000074e:	6de2                	ld	s11,24(sp)
    80000750:	6129                	add	sp,sp,192
    80000752:	8082                	ret
    release(&pr.lock);
    80000754:	00010517          	auipc	a0,0x10
    80000758:	45450513          	add	a0,a0,1108 # 80010ba8 <pr>
    8000075c:	00000097          	auipc	ra,0x0
    80000760:	52a080e7          	jalr	1322(ra) # 80000c86 <release>
}
    80000764:	bfc9                	j	80000736 <printf+0x1b0>

0000000080000766 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000766:	1101                	add	sp,sp,-32
    80000768:	ec06                	sd	ra,24(sp)
    8000076a:	e822                	sd	s0,16(sp)
    8000076c:	e426                	sd	s1,8(sp)
    8000076e:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    80000770:	00010497          	auipc	s1,0x10
    80000774:	43848493          	add	s1,s1,1080 # 80010ba8 <pr>
    80000778:	00008597          	auipc	a1,0x8
    8000077c:	8c058593          	add	a1,a1,-1856 # 80008038 <etext+0x38>
    80000780:	8526                	mv	a0,s1
    80000782:	00000097          	auipc	ra,0x0
    80000786:	3c0080e7          	jalr	960(ra) # 80000b42 <initlock>
  pr.locking = 1;
    8000078a:	4785                	li	a5,1
    8000078c:	cc9c                	sw	a5,24(s1)
}
    8000078e:	60e2                	ld	ra,24(sp)
    80000790:	6442                	ld	s0,16(sp)
    80000792:	64a2                	ld	s1,8(sp)
    80000794:	6105                	add	sp,sp,32
    80000796:	8082                	ret

0000000080000798 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000798:	1141                	add	sp,sp,-16
    8000079a:	e406                	sd	ra,8(sp)
    8000079c:	e022                	sd	s0,0(sp)
    8000079e:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a0:	100007b7          	lui	a5,0x10000
    800007a4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007a8:	f8000713          	li	a4,-128
    800007ac:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b0:	470d                	li	a4,3
    800007b2:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007b6:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007ba:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007be:	469d                	li	a3,7
    800007c0:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c4:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007c8:	00008597          	auipc	a1,0x8
    800007cc:	89058593          	add	a1,a1,-1904 # 80008058 <digits+0x18>
    800007d0:	00010517          	auipc	a0,0x10
    800007d4:	3f850513          	add	a0,a0,1016 # 80010bc8 <uart_tx_lock>
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	36a080e7          	jalr	874(ra) # 80000b42 <initlock>
}
    800007e0:	60a2                	ld	ra,8(sp)
    800007e2:	6402                	ld	s0,0(sp)
    800007e4:	0141                	add	sp,sp,16
    800007e6:	8082                	ret

00000000800007e8 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007e8:	1101                	add	sp,sp,-32
    800007ea:	ec06                	sd	ra,24(sp)
    800007ec:	e822                	sd	s0,16(sp)
    800007ee:	e426                	sd	s1,8(sp)
    800007f0:	1000                	add	s0,sp,32
    800007f2:	84aa                	mv	s1,a0
  push_off();
    800007f4:	00000097          	auipc	ra,0x0
    800007f8:	392080e7          	jalr	914(ra) # 80000b86 <push_off>

  if(panicked){
    800007fc:	00008797          	auipc	a5,0x8
    80000800:	1847a783          	lw	a5,388(a5) # 80008980 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000804:	10000737          	lui	a4,0x10000
  if(panicked){
    80000808:	c391                	beqz	a5,8000080c <uartputc_sync+0x24>
    for(;;)
    8000080a:	a001                	j	8000080a <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000810:	0207f793          	and	a5,a5,32
    80000814:	dfe5                	beqz	a5,8000080c <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000816:	0ff4f513          	zext.b	a0,s1
    8000081a:	100007b7          	lui	a5,0x10000
    8000081e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000822:	00000097          	auipc	ra,0x0
    80000826:	404080e7          	jalr	1028(ra) # 80000c26 <pop_off>
}
    8000082a:	60e2                	ld	ra,24(sp)
    8000082c:	6442                	ld	s0,16(sp)
    8000082e:	64a2                	ld	s1,8(sp)
    80000830:	6105                	add	sp,sp,32
    80000832:	8082                	ret

0000000080000834 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000834:	00008797          	auipc	a5,0x8
    80000838:	1547b783          	ld	a5,340(a5) # 80008988 <uart_tx_r>
    8000083c:	00008717          	auipc	a4,0x8
    80000840:	15473703          	ld	a4,340(a4) # 80008990 <uart_tx_w>
    80000844:	06f70a63          	beq	a4,a5,800008b8 <uartstart+0x84>
{
    80000848:	7139                	add	sp,sp,-64
    8000084a:	fc06                	sd	ra,56(sp)
    8000084c:	f822                	sd	s0,48(sp)
    8000084e:	f426                	sd	s1,40(sp)
    80000850:	f04a                	sd	s2,32(sp)
    80000852:	ec4e                	sd	s3,24(sp)
    80000854:	e852                	sd	s4,16(sp)
    80000856:	e456                	sd	s5,8(sp)
    80000858:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000085a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000085e:	00010a17          	auipc	s4,0x10
    80000862:	36aa0a13          	add	s4,s4,874 # 80010bc8 <uart_tx_lock>
    uart_tx_r += 1;
    80000866:	00008497          	auipc	s1,0x8
    8000086a:	12248493          	add	s1,s1,290 # 80008988 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000086e:	00008997          	auipc	s3,0x8
    80000872:	12298993          	add	s3,s3,290 # 80008990 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000876:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087a:	02077713          	and	a4,a4,32
    8000087e:	c705                	beqz	a4,800008a6 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000880:	01f7f713          	and	a4,a5,31
    80000884:	9752                	add	a4,a4,s4
    80000886:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000088a:	0785                	add	a5,a5,1
    8000088c:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000088e:	8526                	mv	a0,s1
    80000890:	00002097          	auipc	ra,0x2
    80000894:	822080e7          	jalr	-2014(ra) # 800020b2 <wakeup>
    
    WriteReg(THR, c);
    80000898:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000089c:	609c                	ld	a5,0(s1)
    8000089e:	0009b703          	ld	a4,0(s3)
    800008a2:	fcf71ae3          	bne	a4,a5,80000876 <uartstart+0x42>
  }
}
    800008a6:	70e2                	ld	ra,56(sp)
    800008a8:	7442                	ld	s0,48(sp)
    800008aa:	74a2                	ld	s1,40(sp)
    800008ac:	7902                	ld	s2,32(sp)
    800008ae:	69e2                	ld	s3,24(sp)
    800008b0:	6a42                	ld	s4,16(sp)
    800008b2:	6aa2                	ld	s5,8(sp)
    800008b4:	6121                	add	sp,sp,64
    800008b6:	8082                	ret
    800008b8:	8082                	ret

00000000800008ba <uartputc>:
{
    800008ba:	7179                	add	sp,sp,-48
    800008bc:	f406                	sd	ra,40(sp)
    800008be:	f022                	sd	s0,32(sp)
    800008c0:	ec26                	sd	s1,24(sp)
    800008c2:	e84a                	sd	s2,16(sp)
    800008c4:	e44e                	sd	s3,8(sp)
    800008c6:	e052                	sd	s4,0(sp)
    800008c8:	1800                	add	s0,sp,48
    800008ca:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008cc:	00010517          	auipc	a0,0x10
    800008d0:	2fc50513          	add	a0,a0,764 # 80010bc8 <uart_tx_lock>
    800008d4:	00000097          	auipc	ra,0x0
    800008d8:	2fe080e7          	jalr	766(ra) # 80000bd2 <acquire>
  if(panicked){
    800008dc:	00008797          	auipc	a5,0x8
    800008e0:	0a47a783          	lw	a5,164(a5) # 80008980 <panicked>
    800008e4:	e7c9                	bnez	a5,8000096e <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008e6:	00008717          	auipc	a4,0x8
    800008ea:	0aa73703          	ld	a4,170(a4) # 80008990 <uart_tx_w>
    800008ee:	00008797          	auipc	a5,0x8
    800008f2:	09a7b783          	ld	a5,154(a5) # 80008988 <uart_tx_r>
    800008f6:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fa:	00010997          	auipc	s3,0x10
    800008fe:	2ce98993          	add	s3,s3,718 # 80010bc8 <uart_tx_lock>
    80000902:	00008497          	auipc	s1,0x8
    80000906:	08648493          	add	s1,s1,134 # 80008988 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090a:	00008917          	auipc	s2,0x8
    8000090e:	08690913          	add	s2,s2,134 # 80008990 <uart_tx_w>
    80000912:	00e79f63          	bne	a5,a4,80000930 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000916:	85ce                	mv	a1,s3
    80000918:	8526                	mv	a0,s1
    8000091a:	00001097          	auipc	ra,0x1
    8000091e:	734080e7          	jalr	1844(ra) # 8000204e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000922:	00093703          	ld	a4,0(s2)
    80000926:	609c                	ld	a5,0(s1)
    80000928:	02078793          	add	a5,a5,32
    8000092c:	fee785e3          	beq	a5,a4,80000916 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000930:	00010497          	auipc	s1,0x10
    80000934:	29848493          	add	s1,s1,664 # 80010bc8 <uart_tx_lock>
    80000938:	01f77793          	and	a5,a4,31
    8000093c:	97a6                	add	a5,a5,s1
    8000093e:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000942:	0705                	add	a4,a4,1
    80000944:	00008797          	auipc	a5,0x8
    80000948:	04e7b623          	sd	a4,76(a5) # 80008990 <uart_tx_w>
  uartstart();
    8000094c:	00000097          	auipc	ra,0x0
    80000950:	ee8080e7          	jalr	-280(ra) # 80000834 <uartstart>
  release(&uart_tx_lock);
    80000954:	8526                	mv	a0,s1
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	330080e7          	jalr	816(ra) # 80000c86 <release>
}
    8000095e:	70a2                	ld	ra,40(sp)
    80000960:	7402                	ld	s0,32(sp)
    80000962:	64e2                	ld	s1,24(sp)
    80000964:	6942                	ld	s2,16(sp)
    80000966:	69a2                	ld	s3,8(sp)
    80000968:	6a02                	ld	s4,0(sp)
    8000096a:	6145                	add	sp,sp,48
    8000096c:	8082                	ret
    for(;;)
    8000096e:	a001                	j	8000096e <uartputc+0xb4>

0000000080000970 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000970:	1141                	add	sp,sp,-16
    80000972:	e422                	sd	s0,8(sp)
    80000974:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000976:	100007b7          	lui	a5,0x10000
    8000097a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000097e:	8b85                	and	a5,a5,1
    80000980:	cb81                	beqz	a5,80000990 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80000982:	100007b7          	lui	a5,0x10000
    80000986:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000098a:	6422                	ld	s0,8(sp)
    8000098c:	0141                	add	sp,sp,16
    8000098e:	8082                	ret
    return -1;
    80000990:	557d                	li	a0,-1
    80000992:	bfe5                	j	8000098a <uartgetc+0x1a>

0000000080000994 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000994:	1101                	add	sp,sp,-32
    80000996:	ec06                	sd	ra,24(sp)
    80000998:	e822                	sd	s0,16(sp)
    8000099a:	e426                	sd	s1,8(sp)
    8000099c:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000099e:	54fd                	li	s1,-1
    800009a0:	a029                	j	800009aa <uartintr+0x16>
      break;
    consoleintr(c);
    800009a2:	00000097          	auipc	ra,0x0
    800009a6:	918080e7          	jalr	-1768(ra) # 800002ba <consoleintr>
    int c = uartgetc();
    800009aa:	00000097          	auipc	ra,0x0
    800009ae:	fc6080e7          	jalr	-58(ra) # 80000970 <uartgetc>
    if(c == -1)
    800009b2:	fe9518e3          	bne	a0,s1,800009a2 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009b6:	00010497          	auipc	s1,0x10
    800009ba:	21248493          	add	s1,s1,530 # 80010bc8 <uart_tx_lock>
    800009be:	8526                	mv	a0,s1
    800009c0:	00000097          	auipc	ra,0x0
    800009c4:	212080e7          	jalr	530(ra) # 80000bd2 <acquire>
  uartstart();
    800009c8:	00000097          	auipc	ra,0x0
    800009cc:	e6c080e7          	jalr	-404(ra) # 80000834 <uartstart>
  release(&uart_tx_lock);
    800009d0:	8526                	mv	a0,s1
    800009d2:	00000097          	auipc	ra,0x0
    800009d6:	2b4080e7          	jalr	692(ra) # 80000c86 <release>
}
    800009da:	60e2                	ld	ra,24(sp)
    800009dc:	6442                	ld	s0,16(sp)
    800009de:	64a2                	ld	s1,8(sp)
    800009e0:	6105                	add	sp,sp,32
    800009e2:	8082                	ret

00000000800009e4 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009e4:	1101                	add	sp,sp,-32
    800009e6:	ec06                	sd	ra,24(sp)
    800009e8:	e822                	sd	s0,16(sp)
    800009ea:	e426                	sd	s1,8(sp)
    800009ec:	e04a                	sd	s2,0(sp)
    800009ee:	1000                	add	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009f0:	03451793          	sll	a5,a0,0x34
    800009f4:	ebb9                	bnez	a5,80000a4a <kfree+0x66>
    800009f6:	84aa                	mv	s1,a0
    800009f8:	00021797          	auipc	a5,0x21
    800009fc:	43878793          	add	a5,a5,1080 # 80021e30 <end>
    80000a00:	04f56563          	bltu	a0,a5,80000a4a <kfree+0x66>
    80000a04:	47c5                	li	a5,17
    80000a06:	07ee                	sll	a5,a5,0x1b
    80000a08:	04f57163          	bgeu	a0,a5,80000a4a <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a0c:	6605                	lui	a2,0x1
    80000a0e:	4585                	li	a1,1
    80000a10:	00000097          	auipc	ra,0x0
    80000a14:	2be080e7          	jalr	702(ra) # 80000cce <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a18:	00010917          	auipc	s2,0x10
    80000a1c:	1e890913          	add	s2,s2,488 # 80010c00 <kmem>
    80000a20:	854a                	mv	a0,s2
    80000a22:	00000097          	auipc	ra,0x0
    80000a26:	1b0080e7          	jalr	432(ra) # 80000bd2 <acquire>
  r->next = kmem.freelist;
    80000a2a:	01893783          	ld	a5,24(s2)
    80000a2e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a30:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a34:	854a                	mv	a0,s2
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	250080e7          	jalr	592(ra) # 80000c86 <release>
}
    80000a3e:	60e2                	ld	ra,24(sp)
    80000a40:	6442                	ld	s0,16(sp)
    80000a42:	64a2                	ld	s1,8(sp)
    80000a44:	6902                	ld	s2,0(sp)
    80000a46:	6105                	add	sp,sp,32
    80000a48:	8082                	ret
    panic("kfree");
    80000a4a:	00007517          	auipc	a0,0x7
    80000a4e:	61650513          	add	a0,a0,1558 # 80008060 <digits+0x20>
    80000a52:	00000097          	auipc	ra,0x0
    80000a56:	aea080e7          	jalr	-1302(ra) # 8000053c <panic>

0000000080000a5a <freerange>:
{
    80000a5a:	7179                	add	sp,sp,-48
    80000a5c:	f406                	sd	ra,40(sp)
    80000a5e:	f022                	sd	s0,32(sp)
    80000a60:	ec26                	sd	s1,24(sp)
    80000a62:	e84a                	sd	s2,16(sp)
    80000a64:	e44e                	sd	s3,8(sp)
    80000a66:	e052                	sd	s4,0(sp)
    80000a68:	1800                	add	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a6a:	6785                	lui	a5,0x1
    80000a6c:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a70:	00e504b3          	add	s1,a0,a4
    80000a74:	777d                	lui	a4,0xfffff
    80000a76:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a78:	94be                	add	s1,s1,a5
    80000a7a:	0095ee63          	bltu	a1,s1,80000a96 <freerange+0x3c>
    80000a7e:	892e                	mv	s2,a1
    kfree(p);
    80000a80:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a82:	6985                	lui	s3,0x1
    kfree(p);
    80000a84:	01448533          	add	a0,s1,s4
    80000a88:	00000097          	auipc	ra,0x0
    80000a8c:	f5c080e7          	jalr	-164(ra) # 800009e4 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a90:	94ce                	add	s1,s1,s3
    80000a92:	fe9979e3          	bgeu	s2,s1,80000a84 <freerange+0x2a>
}
    80000a96:	70a2                	ld	ra,40(sp)
    80000a98:	7402                	ld	s0,32(sp)
    80000a9a:	64e2                	ld	s1,24(sp)
    80000a9c:	6942                	ld	s2,16(sp)
    80000a9e:	69a2                	ld	s3,8(sp)
    80000aa0:	6a02                	ld	s4,0(sp)
    80000aa2:	6145                	add	sp,sp,48
    80000aa4:	8082                	ret

0000000080000aa6 <kinit>:
{
    80000aa6:	1141                	add	sp,sp,-16
    80000aa8:	e406                	sd	ra,8(sp)
    80000aaa:	e022                	sd	s0,0(sp)
    80000aac:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000aae:	00007597          	auipc	a1,0x7
    80000ab2:	5ba58593          	add	a1,a1,1466 # 80008068 <digits+0x28>
    80000ab6:	00010517          	auipc	a0,0x10
    80000aba:	14a50513          	add	a0,a0,330 # 80010c00 <kmem>
    80000abe:	00000097          	auipc	ra,0x0
    80000ac2:	084080e7          	jalr	132(ra) # 80000b42 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ac6:	45c5                	li	a1,17
    80000ac8:	05ee                	sll	a1,a1,0x1b
    80000aca:	00021517          	auipc	a0,0x21
    80000ace:	36650513          	add	a0,a0,870 # 80021e30 <end>
    80000ad2:	00000097          	auipc	ra,0x0
    80000ad6:	f88080e7          	jalr	-120(ra) # 80000a5a <freerange>
}
    80000ada:	60a2                	ld	ra,8(sp)
    80000adc:	6402                	ld	s0,0(sp)
    80000ade:	0141                	add	sp,sp,16
    80000ae0:	8082                	ret

0000000080000ae2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ae2:	1101                	add	sp,sp,-32
    80000ae4:	ec06                	sd	ra,24(sp)
    80000ae6:	e822                	sd	s0,16(sp)
    80000ae8:	e426                	sd	s1,8(sp)
    80000aea:	1000                	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000aec:	00010497          	auipc	s1,0x10
    80000af0:	11448493          	add	s1,s1,276 # 80010c00 <kmem>
    80000af4:	8526                	mv	a0,s1
    80000af6:	00000097          	auipc	ra,0x0
    80000afa:	0dc080e7          	jalr	220(ra) # 80000bd2 <acquire>
  r = kmem.freelist;
    80000afe:	6c84                	ld	s1,24(s1)
  if(r)
    80000b00:	c885                	beqz	s1,80000b30 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b02:	609c                	ld	a5,0(s1)
    80000b04:	00010517          	auipc	a0,0x10
    80000b08:	0fc50513          	add	a0,a0,252 # 80010c00 <kmem>
    80000b0c:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b0e:	00000097          	auipc	ra,0x0
    80000b12:	178080e7          	jalr	376(ra) # 80000c86 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b16:	6605                	lui	a2,0x1
    80000b18:	4595                	li	a1,5
    80000b1a:	8526                	mv	a0,s1
    80000b1c:	00000097          	auipc	ra,0x0
    80000b20:	1b2080e7          	jalr	434(ra) # 80000cce <memset>
  return (void*)r;
}
    80000b24:	8526                	mv	a0,s1
    80000b26:	60e2                	ld	ra,24(sp)
    80000b28:	6442                	ld	s0,16(sp)
    80000b2a:	64a2                	ld	s1,8(sp)
    80000b2c:	6105                	add	sp,sp,32
    80000b2e:	8082                	ret
  release(&kmem.lock);
    80000b30:	00010517          	auipc	a0,0x10
    80000b34:	0d050513          	add	a0,a0,208 # 80010c00 <kmem>
    80000b38:	00000097          	auipc	ra,0x0
    80000b3c:	14e080e7          	jalr	334(ra) # 80000c86 <release>
  if(r)
    80000b40:	b7d5                	j	80000b24 <kalloc+0x42>

0000000080000b42 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b42:	1141                	add	sp,sp,-16
    80000b44:	e422                	sd	s0,8(sp)
    80000b46:	0800                	add	s0,sp,16
  lk->name = name;
    80000b48:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b4a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b4e:	00053823          	sd	zero,16(a0)
}
    80000b52:	6422                	ld	s0,8(sp)
    80000b54:	0141                	add	sp,sp,16
    80000b56:	8082                	ret

0000000080000b58 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b58:	411c                	lw	a5,0(a0)
    80000b5a:	e399                	bnez	a5,80000b60 <holding+0x8>
    80000b5c:	4501                	li	a0,0
  return r;
}
    80000b5e:	8082                	ret
{
    80000b60:	1101                	add	sp,sp,-32
    80000b62:	ec06                	sd	ra,24(sp)
    80000b64:	e822                	sd	s0,16(sp)
    80000b66:	e426                	sd	s1,8(sp)
    80000b68:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b6a:	6904                	ld	s1,16(a0)
    80000b6c:	00001097          	auipc	ra,0x1
    80000b70:	e1e080e7          	jalr	-482(ra) # 8000198a <mycpu>
    80000b74:	40a48533          	sub	a0,s1,a0
    80000b78:	00153513          	seqz	a0,a0
}
    80000b7c:	60e2                	ld	ra,24(sp)
    80000b7e:	6442                	ld	s0,16(sp)
    80000b80:	64a2                	ld	s1,8(sp)
    80000b82:	6105                	add	sp,sp,32
    80000b84:	8082                	ret

0000000080000b86 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b86:	1101                	add	sp,sp,-32
    80000b88:	ec06                	sd	ra,24(sp)
    80000b8a:	e822                	sd	s0,16(sp)
    80000b8c:	e426                	sd	s1,8(sp)
    80000b8e:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b90:	100024f3          	csrr	s1,sstatus
    80000b94:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b98:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b9a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b9e:	00001097          	auipc	ra,0x1
    80000ba2:	dec080e7          	jalr	-532(ra) # 8000198a <mycpu>
    80000ba6:	5d3c                	lw	a5,120(a0)
    80000ba8:	cf89                	beqz	a5,80000bc2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000baa:	00001097          	auipc	ra,0x1
    80000bae:	de0080e7          	jalr	-544(ra) # 8000198a <mycpu>
    80000bb2:	5d3c                	lw	a5,120(a0)
    80000bb4:	2785                	addw	a5,a5,1
    80000bb6:	dd3c                	sw	a5,120(a0)
}
    80000bb8:	60e2                	ld	ra,24(sp)
    80000bba:	6442                	ld	s0,16(sp)
    80000bbc:	64a2                	ld	s1,8(sp)
    80000bbe:	6105                	add	sp,sp,32
    80000bc0:	8082                	ret
    mycpu()->intena = old;
    80000bc2:	00001097          	auipc	ra,0x1
    80000bc6:	dc8080e7          	jalr	-568(ra) # 8000198a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bca:	8085                	srl	s1,s1,0x1
    80000bcc:	8885                	and	s1,s1,1
    80000bce:	dd64                	sw	s1,124(a0)
    80000bd0:	bfe9                	j	80000baa <push_off+0x24>

0000000080000bd2 <acquire>:
{
    80000bd2:	1101                	add	sp,sp,-32
    80000bd4:	ec06                	sd	ra,24(sp)
    80000bd6:	e822                	sd	s0,16(sp)
    80000bd8:	e426                	sd	s1,8(sp)
    80000bda:	1000                	add	s0,sp,32
    80000bdc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bde:	00000097          	auipc	ra,0x0
    80000be2:	fa8080e7          	jalr	-88(ra) # 80000b86 <push_off>
  if(holding(lk))
    80000be6:	8526                	mv	a0,s1
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	f70080e7          	jalr	-144(ra) # 80000b58 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf0:	4705                	li	a4,1
  if(holding(lk))
    80000bf2:	e115                	bnez	a0,80000c16 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf4:	87ba                	mv	a5,a4
    80000bf6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bfa:	2781                	sext.w	a5,a5
    80000bfc:	ffe5                	bnez	a5,80000bf4 <acquire+0x22>
  __sync_synchronize();
    80000bfe:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c02:	00001097          	auipc	ra,0x1
    80000c06:	d88080e7          	jalr	-632(ra) # 8000198a <mycpu>
    80000c0a:	e888                	sd	a0,16(s1)
}
    80000c0c:	60e2                	ld	ra,24(sp)
    80000c0e:	6442                	ld	s0,16(sp)
    80000c10:	64a2                	ld	s1,8(sp)
    80000c12:	6105                	add	sp,sp,32
    80000c14:	8082                	ret
    panic("acquire");
    80000c16:	00007517          	auipc	a0,0x7
    80000c1a:	45a50513          	add	a0,a0,1114 # 80008070 <digits+0x30>
    80000c1e:	00000097          	auipc	ra,0x0
    80000c22:	91e080e7          	jalr	-1762(ra) # 8000053c <panic>

0000000080000c26 <pop_off>:

void
pop_off(void)
{
    80000c26:	1141                	add	sp,sp,-16
    80000c28:	e406                	sd	ra,8(sp)
    80000c2a:	e022                	sd	s0,0(sp)
    80000c2c:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    80000c2e:	00001097          	auipc	ra,0x1
    80000c32:	d5c080e7          	jalr	-676(ra) # 8000198a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c36:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c3a:	8b89                	and	a5,a5,2
  if(intr_get())
    80000c3c:	e78d                	bnez	a5,80000c66 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c3e:	5d3c                	lw	a5,120(a0)
    80000c40:	02f05b63          	blez	a5,80000c76 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c44:	37fd                	addw	a5,a5,-1
    80000c46:	0007871b          	sext.w	a4,a5
    80000c4a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c4c:	eb09                	bnez	a4,80000c5e <pop_off+0x38>
    80000c4e:	5d7c                	lw	a5,124(a0)
    80000c50:	c799                	beqz	a5,80000c5e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c52:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c56:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c5a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c5e:	60a2                	ld	ra,8(sp)
    80000c60:	6402                	ld	s0,0(sp)
    80000c62:	0141                	add	sp,sp,16
    80000c64:	8082                	ret
    panic("pop_off - interruptible");
    80000c66:	00007517          	auipc	a0,0x7
    80000c6a:	41250513          	add	a0,a0,1042 # 80008078 <digits+0x38>
    80000c6e:	00000097          	auipc	ra,0x0
    80000c72:	8ce080e7          	jalr	-1842(ra) # 8000053c <panic>
    panic("pop_off");
    80000c76:	00007517          	auipc	a0,0x7
    80000c7a:	41a50513          	add	a0,a0,1050 # 80008090 <digits+0x50>
    80000c7e:	00000097          	auipc	ra,0x0
    80000c82:	8be080e7          	jalr	-1858(ra) # 8000053c <panic>

0000000080000c86 <release>:
{
    80000c86:	1101                	add	sp,sp,-32
    80000c88:	ec06                	sd	ra,24(sp)
    80000c8a:	e822                	sd	s0,16(sp)
    80000c8c:	e426                	sd	s1,8(sp)
    80000c8e:	1000                	add	s0,sp,32
    80000c90:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c92:	00000097          	auipc	ra,0x0
    80000c96:	ec6080e7          	jalr	-314(ra) # 80000b58 <holding>
    80000c9a:	c115                	beqz	a0,80000cbe <release+0x38>
  lk->cpu = 0;
    80000c9c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca4:	0f50000f          	fence	iorw,ow
    80000ca8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cac:	00000097          	auipc	ra,0x0
    80000cb0:	f7a080e7          	jalr	-134(ra) # 80000c26 <pop_off>
}
    80000cb4:	60e2                	ld	ra,24(sp)
    80000cb6:	6442                	ld	s0,16(sp)
    80000cb8:	64a2                	ld	s1,8(sp)
    80000cba:	6105                	add	sp,sp,32
    80000cbc:	8082                	ret
    panic("release");
    80000cbe:	00007517          	auipc	a0,0x7
    80000cc2:	3da50513          	add	a0,a0,986 # 80008098 <digits+0x58>
    80000cc6:	00000097          	auipc	ra,0x0
    80000cca:	876080e7          	jalr	-1930(ra) # 8000053c <panic>

0000000080000cce <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cce:	1141                	add	sp,sp,-16
    80000cd0:	e422                	sd	s0,8(sp)
    80000cd2:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cd4:	ca19                	beqz	a2,80000cea <memset+0x1c>
    80000cd6:	87aa                	mv	a5,a0
    80000cd8:	1602                	sll	a2,a2,0x20
    80000cda:	9201                	srl	a2,a2,0x20
    80000cdc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ce0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ce4:	0785                	add	a5,a5,1
    80000ce6:	fee79de3          	bne	a5,a4,80000ce0 <memset+0x12>
  }
  return dst;
}
    80000cea:	6422                	ld	s0,8(sp)
    80000cec:	0141                	add	sp,sp,16
    80000cee:	8082                	ret

0000000080000cf0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cf0:	1141                	add	sp,sp,-16
    80000cf2:	e422                	sd	s0,8(sp)
    80000cf4:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf6:	ca05                	beqz	a2,80000d26 <memcmp+0x36>
    80000cf8:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cfc:	1682                	sll	a3,a3,0x20
    80000cfe:	9281                	srl	a3,a3,0x20
    80000d00:	0685                	add	a3,a3,1
    80000d02:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d04:	00054783          	lbu	a5,0(a0)
    80000d08:	0005c703          	lbu	a4,0(a1)
    80000d0c:	00e79863          	bne	a5,a4,80000d1c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d10:	0505                	add	a0,a0,1
    80000d12:	0585                	add	a1,a1,1
  while(n-- > 0){
    80000d14:	fed518e3          	bne	a0,a3,80000d04 <memcmp+0x14>
  }

  return 0;
    80000d18:	4501                	li	a0,0
    80000d1a:	a019                	j	80000d20 <memcmp+0x30>
      return *s1 - *s2;
    80000d1c:	40e7853b          	subw	a0,a5,a4
}
    80000d20:	6422                	ld	s0,8(sp)
    80000d22:	0141                	add	sp,sp,16
    80000d24:	8082                	ret
  return 0;
    80000d26:	4501                	li	a0,0
    80000d28:	bfe5                	j	80000d20 <memcmp+0x30>

0000000080000d2a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d2a:	1141                	add	sp,sp,-16
    80000d2c:	e422                	sd	s0,8(sp)
    80000d2e:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d30:	c205                	beqz	a2,80000d50 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d32:	02a5e263          	bltu	a1,a0,80000d56 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d36:	1602                	sll	a2,a2,0x20
    80000d38:	9201                	srl	a2,a2,0x20
    80000d3a:	00c587b3          	add	a5,a1,a2
{
    80000d3e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d40:	0585                	add	a1,a1,1
    80000d42:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd1d1>
    80000d44:	fff5c683          	lbu	a3,-1(a1)
    80000d48:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d4c:	fef59ae3          	bne	a1,a5,80000d40 <memmove+0x16>

  return dst;
}
    80000d50:	6422                	ld	s0,8(sp)
    80000d52:	0141                	add	sp,sp,16
    80000d54:	8082                	ret
  if(s < d && s + n > d){
    80000d56:	02061693          	sll	a3,a2,0x20
    80000d5a:	9281                	srl	a3,a3,0x20
    80000d5c:	00d58733          	add	a4,a1,a3
    80000d60:	fce57be3          	bgeu	a0,a4,80000d36 <memmove+0xc>
    d += n;
    80000d64:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d66:	fff6079b          	addw	a5,a2,-1
    80000d6a:	1782                	sll	a5,a5,0x20
    80000d6c:	9381                	srl	a5,a5,0x20
    80000d6e:	fff7c793          	not	a5,a5
    80000d72:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d74:	177d                	add	a4,a4,-1
    80000d76:	16fd                	add	a3,a3,-1
    80000d78:	00074603          	lbu	a2,0(a4)
    80000d7c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d80:	fee79ae3          	bne	a5,a4,80000d74 <memmove+0x4a>
    80000d84:	b7f1                	j	80000d50 <memmove+0x26>

0000000080000d86 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d86:	1141                	add	sp,sp,-16
    80000d88:	e406                	sd	ra,8(sp)
    80000d8a:	e022                	sd	s0,0(sp)
    80000d8c:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    80000d8e:	00000097          	auipc	ra,0x0
    80000d92:	f9c080e7          	jalr	-100(ra) # 80000d2a <memmove>
}
    80000d96:	60a2                	ld	ra,8(sp)
    80000d98:	6402                	ld	s0,0(sp)
    80000d9a:	0141                	add	sp,sp,16
    80000d9c:	8082                	ret

0000000080000d9e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d9e:	1141                	add	sp,sp,-16
    80000da0:	e422                	sd	s0,8(sp)
    80000da2:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000da4:	ce11                	beqz	a2,80000dc0 <strncmp+0x22>
    80000da6:	00054783          	lbu	a5,0(a0)
    80000daa:	cf89                	beqz	a5,80000dc4 <strncmp+0x26>
    80000dac:	0005c703          	lbu	a4,0(a1)
    80000db0:	00f71a63          	bne	a4,a5,80000dc4 <strncmp+0x26>
    n--, p++, q++;
    80000db4:	367d                	addw	a2,a2,-1
    80000db6:	0505                	add	a0,a0,1
    80000db8:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dba:	f675                	bnez	a2,80000da6 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dbc:	4501                	li	a0,0
    80000dbe:	a809                	j	80000dd0 <strncmp+0x32>
    80000dc0:	4501                	li	a0,0
    80000dc2:	a039                	j	80000dd0 <strncmp+0x32>
  if(n == 0)
    80000dc4:	ca09                	beqz	a2,80000dd6 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dc6:	00054503          	lbu	a0,0(a0)
    80000dca:	0005c783          	lbu	a5,0(a1)
    80000dce:	9d1d                	subw	a0,a0,a5
}
    80000dd0:	6422                	ld	s0,8(sp)
    80000dd2:	0141                	add	sp,sp,16
    80000dd4:	8082                	ret
    return 0;
    80000dd6:	4501                	li	a0,0
    80000dd8:	bfe5                	j	80000dd0 <strncmp+0x32>

0000000080000dda <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dda:	1141                	add	sp,sp,-16
    80000ddc:	e422                	sd	s0,8(sp)
    80000dde:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000de0:	87aa                	mv	a5,a0
    80000de2:	86b2                	mv	a3,a2
    80000de4:	367d                	addw	a2,a2,-1
    80000de6:	00d05963          	blez	a3,80000df8 <strncpy+0x1e>
    80000dea:	0785                	add	a5,a5,1
    80000dec:	0005c703          	lbu	a4,0(a1)
    80000df0:	fee78fa3          	sb	a4,-1(a5)
    80000df4:	0585                	add	a1,a1,1
    80000df6:	f775                	bnez	a4,80000de2 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000df8:	873e                	mv	a4,a5
    80000dfa:	9fb5                	addw	a5,a5,a3
    80000dfc:	37fd                	addw	a5,a5,-1
    80000dfe:	00c05963          	blez	a2,80000e10 <strncpy+0x36>
    *s++ = 0;
    80000e02:	0705                	add	a4,a4,1
    80000e04:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e08:	40e786bb          	subw	a3,a5,a4
    80000e0c:	fed04be3          	bgtz	a3,80000e02 <strncpy+0x28>
  return os;
}
    80000e10:	6422                	ld	s0,8(sp)
    80000e12:	0141                	add	sp,sp,16
    80000e14:	8082                	ret

0000000080000e16 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e16:	1141                	add	sp,sp,-16
    80000e18:	e422                	sd	s0,8(sp)
    80000e1a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e1c:	02c05363          	blez	a2,80000e42 <safestrcpy+0x2c>
    80000e20:	fff6069b          	addw	a3,a2,-1
    80000e24:	1682                	sll	a3,a3,0x20
    80000e26:	9281                	srl	a3,a3,0x20
    80000e28:	96ae                	add	a3,a3,a1
    80000e2a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e2c:	00d58963          	beq	a1,a3,80000e3e <safestrcpy+0x28>
    80000e30:	0585                	add	a1,a1,1
    80000e32:	0785                	add	a5,a5,1
    80000e34:	fff5c703          	lbu	a4,-1(a1)
    80000e38:	fee78fa3          	sb	a4,-1(a5)
    80000e3c:	fb65                	bnez	a4,80000e2c <safestrcpy+0x16>
    ;
  *s = 0;
    80000e3e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e42:	6422                	ld	s0,8(sp)
    80000e44:	0141                	add	sp,sp,16
    80000e46:	8082                	ret

0000000080000e48 <strlen>:

int
strlen(const char *s)
{
    80000e48:	1141                	add	sp,sp,-16
    80000e4a:	e422                	sd	s0,8(sp)
    80000e4c:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e4e:	00054783          	lbu	a5,0(a0)
    80000e52:	cf91                	beqz	a5,80000e6e <strlen+0x26>
    80000e54:	0505                	add	a0,a0,1
    80000e56:	87aa                	mv	a5,a0
    80000e58:	86be                	mv	a3,a5
    80000e5a:	0785                	add	a5,a5,1
    80000e5c:	fff7c703          	lbu	a4,-1(a5)
    80000e60:	ff65                	bnez	a4,80000e58 <strlen+0x10>
    80000e62:	40a6853b          	subw	a0,a3,a0
    80000e66:	2505                	addw	a0,a0,1
    ;
  return n;
}
    80000e68:	6422                	ld	s0,8(sp)
    80000e6a:	0141                	add	sp,sp,16
    80000e6c:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e6e:	4501                	li	a0,0
    80000e70:	bfe5                	j	80000e68 <strlen+0x20>

0000000080000e72 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e72:	1141                	add	sp,sp,-16
    80000e74:	e406                	sd	ra,8(sp)
    80000e76:	e022                	sd	s0,0(sp)
    80000e78:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80000e7a:	00001097          	auipc	ra,0x1
    80000e7e:	b00080e7          	jalr	-1280(ra) # 8000197a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e82:	00008717          	auipc	a4,0x8
    80000e86:	b1670713          	add	a4,a4,-1258 # 80008998 <started>
  if(cpuid() == 0){
    80000e8a:	c139                	beqz	a0,80000ed0 <main+0x5e>
    while(started == 0)
    80000e8c:	431c                	lw	a5,0(a4)
    80000e8e:	2781                	sext.w	a5,a5
    80000e90:	dff5                	beqz	a5,80000e8c <main+0x1a>
      ;
    __sync_synchronize();
    80000e92:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e96:	00001097          	auipc	ra,0x1
    80000e9a:	ae4080e7          	jalr	-1308(ra) # 8000197a <cpuid>
    80000e9e:	85aa                	mv	a1,a0
    80000ea0:	00007517          	auipc	a0,0x7
    80000ea4:	22850513          	add	a0,a0,552 # 800080c8 <digits+0x88>
    80000ea8:	fffff097          	auipc	ra,0xfffff
    80000eac:	6de080e7          	jalr	1758(ra) # 80000586 <printf>
    kvminithart();    // turn on paging
    80000eb0:	00000097          	auipc	ra,0x0
    80000eb4:	0d8080e7          	jalr	216(ra) # 80000f88 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eb8:	00001097          	auipc	ra,0x1
    80000ebc:	78c080e7          	jalr	1932(ra) # 80002644 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ec0:	00005097          	auipc	ra,0x5
    80000ec4:	f50080e7          	jalr	-176(ra) # 80005e10 <plicinithart>
  }

  scheduler();        
    80000ec8:	00001097          	auipc	ra,0x1
    80000ecc:	fd4080e7          	jalr	-44(ra) # 80001e9c <scheduler>
    consoleinit();
    80000ed0:	fffff097          	auipc	ra,0xfffff
    80000ed4:	57c080e7          	jalr	1404(ra) # 8000044c <consoleinit>
    printfinit();
    80000ed8:	00000097          	auipc	ra,0x0
    80000edc:	88e080e7          	jalr	-1906(ra) # 80000766 <printfinit>
    printf("\n\n\n\n\n\n\n\n\n\n\n\n");
    80000ee0:	00007517          	auipc	a0,0x7
    80000ee4:	1c050513          	add	a0,a0,448 # 800080a0 <digits+0x60>
    80000ee8:	fffff097          	auipc	ra,0xfffff
    80000eec:	69e080e7          	jalr	1694(ra) # 80000586 <printf>
    printf("xv6 kernel is booting\n");
    80000ef0:	00007517          	auipc	a0,0x7
    80000ef4:	1c050513          	add	a0,a0,448 # 800080b0 <digits+0x70>
    80000ef8:	fffff097          	auipc	ra,0xfffff
    80000efc:	68e080e7          	jalr	1678(ra) # 80000586 <printf>
    printf("\n");
    80000f00:	00007517          	auipc	a0,0x7
    80000f04:	1d850513          	add	a0,a0,472 # 800080d8 <digits+0x98>
    80000f08:	fffff097          	auipc	ra,0xfffff
    80000f0c:	67e080e7          	jalr	1662(ra) # 80000586 <printf>
    kinit();         // physical page allocator
    80000f10:	00000097          	auipc	ra,0x0
    80000f14:	b96080e7          	jalr	-1130(ra) # 80000aa6 <kinit>
    kvminit();       // create kernel page table
    80000f18:	00000097          	auipc	ra,0x0
    80000f1c:	326080e7          	jalr	806(ra) # 8000123e <kvminit>
    kvminithart();   // turn on paging
    80000f20:	00000097          	auipc	ra,0x0
    80000f24:	068080e7          	jalr	104(ra) # 80000f88 <kvminithart>
    procinit();      // process table
    80000f28:	00001097          	auipc	ra,0x1
    80000f2c:	99e080e7          	jalr	-1634(ra) # 800018c6 <procinit>
    trapinit();      // trap vectors
    80000f30:	00001097          	auipc	ra,0x1
    80000f34:	6ec080e7          	jalr	1772(ra) # 8000261c <trapinit>
    trapinithart();  // install kernel trap vector
    80000f38:	00001097          	auipc	ra,0x1
    80000f3c:	70c080e7          	jalr	1804(ra) # 80002644 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f40:	00005097          	auipc	ra,0x5
    80000f44:	eba080e7          	jalr	-326(ra) # 80005dfa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f48:	00005097          	auipc	ra,0x5
    80000f4c:	ec8080e7          	jalr	-312(ra) # 80005e10 <plicinithart>
    binit();         // buffer cache
    80000f50:	00002097          	auipc	ra,0x2
    80000f54:	f84080e7          	jalr	-124(ra) # 80002ed4 <binit>
    iinit();         // inode table
    80000f58:	00002097          	auipc	ra,0x2
    80000f5c:	762080e7          	jalr	1890(ra) # 800036ba <iinit>
    fileinit();      // file table
    80000f60:	00003097          	auipc	ra,0x3
    80000f64:	6da080e7          	jalr	1754(ra) # 8000463a <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f68:	00005097          	auipc	ra,0x5
    80000f6c:	fb0080e7          	jalr	-80(ra) # 80005f18 <virtio_disk_init>
    userinit();      // first user process
    80000f70:	00001097          	auipc	ra,0x1
    80000f74:	d0e080e7          	jalr	-754(ra) # 80001c7e <userinit>
    __sync_synchronize();
    80000f78:	0ff0000f          	fence
    started = 1;
    80000f7c:	4785                	li	a5,1
    80000f7e:	00008717          	auipc	a4,0x8
    80000f82:	a0f72d23          	sw	a5,-1510(a4) # 80008998 <started>
    80000f86:	b789                	j	80000ec8 <main+0x56>

0000000080000f88 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f88:	1141                	add	sp,sp,-16
    80000f8a:	e422                	sd	s0,8(sp)
    80000f8c:	0800                	add	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f8e:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f92:	00008797          	auipc	a5,0x8
    80000f96:	a0e7b783          	ld	a5,-1522(a5) # 800089a0 <kernel_pagetable>
    80000f9a:	83b1                	srl	a5,a5,0xc
    80000f9c:	577d                	li	a4,-1
    80000f9e:	177e                	sll	a4,a4,0x3f
    80000fa0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fa2:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000fa6:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000faa:	6422                	ld	s0,8(sp)
    80000fac:	0141                	add	sp,sp,16
    80000fae:	8082                	ret

0000000080000fb0 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fb0:	7139                	add	sp,sp,-64
    80000fb2:	fc06                	sd	ra,56(sp)
    80000fb4:	f822                	sd	s0,48(sp)
    80000fb6:	f426                	sd	s1,40(sp)
    80000fb8:	f04a                	sd	s2,32(sp)
    80000fba:	ec4e                	sd	s3,24(sp)
    80000fbc:	e852                	sd	s4,16(sp)
    80000fbe:	e456                	sd	s5,8(sp)
    80000fc0:	e05a                	sd	s6,0(sp)
    80000fc2:	0080                	add	s0,sp,64
    80000fc4:	84aa                	mv	s1,a0
    80000fc6:	89ae                	mv	s3,a1
    80000fc8:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fca:	57fd                	li	a5,-1
    80000fcc:	83e9                	srl	a5,a5,0x1a
    80000fce:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fd0:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fd2:	04b7f263          	bgeu	a5,a1,80001016 <walk+0x66>
    panic("walk");
    80000fd6:	00007517          	auipc	a0,0x7
    80000fda:	10a50513          	add	a0,a0,266 # 800080e0 <digits+0xa0>
    80000fde:	fffff097          	auipc	ra,0xfffff
    80000fe2:	55e080e7          	jalr	1374(ra) # 8000053c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fe6:	060a8663          	beqz	s5,80001052 <walk+0xa2>
    80000fea:	00000097          	auipc	ra,0x0
    80000fee:	af8080e7          	jalr	-1288(ra) # 80000ae2 <kalloc>
    80000ff2:	84aa                	mv	s1,a0
    80000ff4:	c529                	beqz	a0,8000103e <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000ff6:	6605                	lui	a2,0x1
    80000ff8:	4581                	li	a1,0
    80000ffa:	00000097          	auipc	ra,0x0
    80000ffe:	cd4080e7          	jalr	-812(ra) # 80000cce <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001002:	00c4d793          	srl	a5,s1,0xc
    80001006:	07aa                	sll	a5,a5,0xa
    80001008:	0017e793          	or	a5,a5,1
    8000100c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001010:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd1c7>
    80001012:	036a0063          	beq	s4,s6,80001032 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001016:	0149d933          	srl	s2,s3,s4
    8000101a:	1ff97913          	and	s2,s2,511
    8000101e:	090e                	sll	s2,s2,0x3
    80001020:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001022:	00093483          	ld	s1,0(s2)
    80001026:	0014f793          	and	a5,s1,1
    8000102a:	dfd5                	beqz	a5,80000fe6 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000102c:	80a9                	srl	s1,s1,0xa
    8000102e:	04b2                	sll	s1,s1,0xc
    80001030:	b7c5                	j	80001010 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001032:	00c9d513          	srl	a0,s3,0xc
    80001036:	1ff57513          	and	a0,a0,511
    8000103a:	050e                	sll	a0,a0,0x3
    8000103c:	9526                	add	a0,a0,s1
}
    8000103e:	70e2                	ld	ra,56(sp)
    80001040:	7442                	ld	s0,48(sp)
    80001042:	74a2                	ld	s1,40(sp)
    80001044:	7902                	ld	s2,32(sp)
    80001046:	69e2                	ld	s3,24(sp)
    80001048:	6a42                	ld	s4,16(sp)
    8000104a:	6aa2                	ld	s5,8(sp)
    8000104c:	6b02                	ld	s6,0(sp)
    8000104e:	6121                	add	sp,sp,64
    80001050:	8082                	ret
        return 0;
    80001052:	4501                	li	a0,0
    80001054:	b7ed                	j	8000103e <walk+0x8e>

0000000080001056 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001056:	57fd                	li	a5,-1
    80001058:	83e9                	srl	a5,a5,0x1a
    8000105a:	00b7f463          	bgeu	a5,a1,80001062 <walkaddr+0xc>
    return 0;
    8000105e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001060:	8082                	ret
{
    80001062:	1141                	add	sp,sp,-16
    80001064:	e406                	sd	ra,8(sp)
    80001066:	e022                	sd	s0,0(sp)
    80001068:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000106a:	4601                	li	a2,0
    8000106c:	00000097          	auipc	ra,0x0
    80001070:	f44080e7          	jalr	-188(ra) # 80000fb0 <walk>
  if(pte == 0)
    80001074:	c105                	beqz	a0,80001094 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001076:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001078:	0117f693          	and	a3,a5,17
    8000107c:	4745                	li	a4,17
    return 0;
    8000107e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001080:	00e68663          	beq	a3,a4,8000108c <walkaddr+0x36>
}
    80001084:	60a2                	ld	ra,8(sp)
    80001086:	6402                	ld	s0,0(sp)
    80001088:	0141                	add	sp,sp,16
    8000108a:	8082                	ret
  pa = PTE2PA(*pte);
    8000108c:	83a9                	srl	a5,a5,0xa
    8000108e:	00c79513          	sll	a0,a5,0xc
  return pa;
    80001092:	bfcd                	j	80001084 <walkaddr+0x2e>
    return 0;
    80001094:	4501                	li	a0,0
    80001096:	b7fd                	j	80001084 <walkaddr+0x2e>

0000000080001098 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001098:	715d                	add	sp,sp,-80
    8000109a:	e486                	sd	ra,72(sp)
    8000109c:	e0a2                	sd	s0,64(sp)
    8000109e:	fc26                	sd	s1,56(sp)
    800010a0:	f84a                	sd	s2,48(sp)
    800010a2:	f44e                	sd	s3,40(sp)
    800010a4:	f052                	sd	s4,32(sp)
    800010a6:	ec56                	sd	s5,24(sp)
    800010a8:	e85a                	sd	s6,16(sp)
    800010aa:	e45e                	sd	s7,8(sp)
    800010ac:	0880                	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800010ae:	c639                	beqz	a2,800010fc <mappages+0x64>
    800010b0:	8aaa                	mv	s5,a0
    800010b2:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800010b4:	777d                	lui	a4,0xfffff
    800010b6:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010ba:	fff58993          	add	s3,a1,-1
    800010be:	99b2                	add	s3,s3,a2
    800010c0:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010c4:	893e                	mv	s2,a5
    800010c6:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010ca:	6b85                	lui	s7,0x1
    800010cc:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800010d0:	4605                	li	a2,1
    800010d2:	85ca                	mv	a1,s2
    800010d4:	8556                	mv	a0,s5
    800010d6:	00000097          	auipc	ra,0x0
    800010da:	eda080e7          	jalr	-294(ra) # 80000fb0 <walk>
    800010de:	cd1d                	beqz	a0,8000111c <mappages+0x84>
    if(*pte & PTE_V)
    800010e0:	611c                	ld	a5,0(a0)
    800010e2:	8b85                	and	a5,a5,1
    800010e4:	e785                	bnez	a5,8000110c <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010e6:	80b1                	srl	s1,s1,0xc
    800010e8:	04aa                	sll	s1,s1,0xa
    800010ea:	0164e4b3          	or	s1,s1,s6
    800010ee:	0014e493          	or	s1,s1,1
    800010f2:	e104                	sd	s1,0(a0)
    if(a == last)
    800010f4:	05390063          	beq	s2,s3,80001134 <mappages+0x9c>
    a += PGSIZE;
    800010f8:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010fa:	bfc9                	j	800010cc <mappages+0x34>
    panic("mappages: size");
    800010fc:	00007517          	auipc	a0,0x7
    80001100:	fec50513          	add	a0,a0,-20 # 800080e8 <digits+0xa8>
    80001104:	fffff097          	auipc	ra,0xfffff
    80001108:	438080e7          	jalr	1080(ra) # 8000053c <panic>
      panic("mappages: remap");
    8000110c:	00007517          	auipc	a0,0x7
    80001110:	fec50513          	add	a0,a0,-20 # 800080f8 <digits+0xb8>
    80001114:	fffff097          	auipc	ra,0xfffff
    80001118:	428080e7          	jalr	1064(ra) # 8000053c <panic>
      return -1;
    8000111c:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000111e:	60a6                	ld	ra,72(sp)
    80001120:	6406                	ld	s0,64(sp)
    80001122:	74e2                	ld	s1,56(sp)
    80001124:	7942                	ld	s2,48(sp)
    80001126:	79a2                	ld	s3,40(sp)
    80001128:	7a02                	ld	s4,32(sp)
    8000112a:	6ae2                	ld	s5,24(sp)
    8000112c:	6b42                	ld	s6,16(sp)
    8000112e:	6ba2                	ld	s7,8(sp)
    80001130:	6161                	add	sp,sp,80
    80001132:	8082                	ret
  return 0;
    80001134:	4501                	li	a0,0
    80001136:	b7e5                	j	8000111e <mappages+0x86>

0000000080001138 <kvmmap>:
{
    80001138:	1141                	add	sp,sp,-16
    8000113a:	e406                	sd	ra,8(sp)
    8000113c:	e022                	sd	s0,0(sp)
    8000113e:	0800                	add	s0,sp,16
    80001140:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001142:	86b2                	mv	a3,a2
    80001144:	863e                	mv	a2,a5
    80001146:	00000097          	auipc	ra,0x0
    8000114a:	f52080e7          	jalr	-174(ra) # 80001098 <mappages>
    8000114e:	e509                	bnez	a0,80001158 <kvmmap+0x20>
}
    80001150:	60a2                	ld	ra,8(sp)
    80001152:	6402                	ld	s0,0(sp)
    80001154:	0141                	add	sp,sp,16
    80001156:	8082                	ret
    panic("kvmmap");
    80001158:	00007517          	auipc	a0,0x7
    8000115c:	fb050513          	add	a0,a0,-80 # 80008108 <digits+0xc8>
    80001160:	fffff097          	auipc	ra,0xfffff
    80001164:	3dc080e7          	jalr	988(ra) # 8000053c <panic>

0000000080001168 <kvmmake>:
{
    80001168:	1101                	add	sp,sp,-32
    8000116a:	ec06                	sd	ra,24(sp)
    8000116c:	e822                	sd	s0,16(sp)
    8000116e:	e426                	sd	s1,8(sp)
    80001170:	e04a                	sd	s2,0(sp)
    80001172:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001174:	00000097          	auipc	ra,0x0
    80001178:	96e080e7          	jalr	-1682(ra) # 80000ae2 <kalloc>
    8000117c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000117e:	6605                	lui	a2,0x1
    80001180:	4581                	li	a1,0
    80001182:	00000097          	auipc	ra,0x0
    80001186:	b4c080e7          	jalr	-1204(ra) # 80000cce <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000118a:	4719                	li	a4,6
    8000118c:	6685                	lui	a3,0x1
    8000118e:	10000637          	lui	a2,0x10000
    80001192:	100005b7          	lui	a1,0x10000
    80001196:	8526                	mv	a0,s1
    80001198:	00000097          	auipc	ra,0x0
    8000119c:	fa0080e7          	jalr	-96(ra) # 80001138 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800011a0:	4719                	li	a4,6
    800011a2:	6685                	lui	a3,0x1
    800011a4:	10001637          	lui	a2,0x10001
    800011a8:	100015b7          	lui	a1,0x10001
    800011ac:	8526                	mv	a0,s1
    800011ae:	00000097          	auipc	ra,0x0
    800011b2:	f8a080e7          	jalr	-118(ra) # 80001138 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800011b6:	4719                	li	a4,6
    800011b8:	004006b7          	lui	a3,0x400
    800011bc:	0c000637          	lui	a2,0xc000
    800011c0:	0c0005b7          	lui	a1,0xc000
    800011c4:	8526                	mv	a0,s1
    800011c6:	00000097          	auipc	ra,0x0
    800011ca:	f72080e7          	jalr	-142(ra) # 80001138 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011ce:	00007917          	auipc	s2,0x7
    800011d2:	e3290913          	add	s2,s2,-462 # 80008000 <etext>
    800011d6:	4729                	li	a4,10
    800011d8:	80007697          	auipc	a3,0x80007
    800011dc:	e2868693          	add	a3,a3,-472 # 8000 <_entry-0x7fff8000>
    800011e0:	4605                	li	a2,1
    800011e2:	067e                	sll	a2,a2,0x1f
    800011e4:	85b2                	mv	a1,a2
    800011e6:	8526                	mv	a0,s1
    800011e8:	00000097          	auipc	ra,0x0
    800011ec:	f50080e7          	jalr	-176(ra) # 80001138 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011f0:	4719                	li	a4,6
    800011f2:	46c5                	li	a3,17
    800011f4:	06ee                	sll	a3,a3,0x1b
    800011f6:	412686b3          	sub	a3,a3,s2
    800011fa:	864a                	mv	a2,s2
    800011fc:	85ca                	mv	a1,s2
    800011fe:	8526                	mv	a0,s1
    80001200:	00000097          	auipc	ra,0x0
    80001204:	f38080e7          	jalr	-200(ra) # 80001138 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001208:	4729                	li	a4,10
    8000120a:	6685                	lui	a3,0x1
    8000120c:	00006617          	auipc	a2,0x6
    80001210:	df460613          	add	a2,a2,-524 # 80007000 <_trampoline>
    80001214:	040005b7          	lui	a1,0x4000
    80001218:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000121a:	05b2                	sll	a1,a1,0xc
    8000121c:	8526                	mv	a0,s1
    8000121e:	00000097          	auipc	ra,0x0
    80001222:	f1a080e7          	jalr	-230(ra) # 80001138 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001226:	8526                	mv	a0,s1
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	608080e7          	jalr	1544(ra) # 80001830 <proc_mapstacks>
}
    80001230:	8526                	mv	a0,s1
    80001232:	60e2                	ld	ra,24(sp)
    80001234:	6442                	ld	s0,16(sp)
    80001236:	64a2                	ld	s1,8(sp)
    80001238:	6902                	ld	s2,0(sp)
    8000123a:	6105                	add	sp,sp,32
    8000123c:	8082                	ret

000000008000123e <kvminit>:
{
    8000123e:	1141                	add	sp,sp,-16
    80001240:	e406                	sd	ra,8(sp)
    80001242:	e022                	sd	s0,0(sp)
    80001244:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    80001246:	00000097          	auipc	ra,0x0
    8000124a:	f22080e7          	jalr	-222(ra) # 80001168 <kvmmake>
    8000124e:	00007797          	auipc	a5,0x7
    80001252:	74a7b923          	sd	a0,1874(a5) # 800089a0 <kernel_pagetable>
}
    80001256:	60a2                	ld	ra,8(sp)
    80001258:	6402                	ld	s0,0(sp)
    8000125a:	0141                	add	sp,sp,16
    8000125c:	8082                	ret

000000008000125e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000125e:	715d                	add	sp,sp,-80
    80001260:	e486                	sd	ra,72(sp)
    80001262:	e0a2                	sd	s0,64(sp)
    80001264:	fc26                	sd	s1,56(sp)
    80001266:	f84a                	sd	s2,48(sp)
    80001268:	f44e                	sd	s3,40(sp)
    8000126a:	f052                	sd	s4,32(sp)
    8000126c:	ec56                	sd	s5,24(sp)
    8000126e:	e85a                	sd	s6,16(sp)
    80001270:	e45e                	sd	s7,8(sp)
    80001272:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001274:	03459793          	sll	a5,a1,0x34
    80001278:	e795                	bnez	a5,800012a4 <uvmunmap+0x46>
    8000127a:	8a2a                	mv	s4,a0
    8000127c:	892e                	mv	s2,a1
    8000127e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001280:	0632                	sll	a2,a2,0xc
    80001282:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001286:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001288:	6b05                	lui	s6,0x1
    8000128a:	0735e263          	bltu	a1,s3,800012ee <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000128e:	60a6                	ld	ra,72(sp)
    80001290:	6406                	ld	s0,64(sp)
    80001292:	74e2                	ld	s1,56(sp)
    80001294:	7942                	ld	s2,48(sp)
    80001296:	79a2                	ld	s3,40(sp)
    80001298:	7a02                	ld	s4,32(sp)
    8000129a:	6ae2                	ld	s5,24(sp)
    8000129c:	6b42                	ld	s6,16(sp)
    8000129e:	6ba2                	ld	s7,8(sp)
    800012a0:	6161                	add	sp,sp,80
    800012a2:	8082                	ret
    panic("uvmunmap: not aligned");
    800012a4:	00007517          	auipc	a0,0x7
    800012a8:	e6c50513          	add	a0,a0,-404 # 80008110 <digits+0xd0>
    800012ac:	fffff097          	auipc	ra,0xfffff
    800012b0:	290080e7          	jalr	656(ra) # 8000053c <panic>
      panic("uvmunmap: walk");
    800012b4:	00007517          	auipc	a0,0x7
    800012b8:	e7450513          	add	a0,a0,-396 # 80008128 <digits+0xe8>
    800012bc:	fffff097          	auipc	ra,0xfffff
    800012c0:	280080e7          	jalr	640(ra) # 8000053c <panic>
      panic("uvmunmap: not mapped");
    800012c4:	00007517          	auipc	a0,0x7
    800012c8:	e7450513          	add	a0,a0,-396 # 80008138 <digits+0xf8>
    800012cc:	fffff097          	auipc	ra,0xfffff
    800012d0:	270080e7          	jalr	624(ra) # 8000053c <panic>
      panic("uvmunmap: not a leaf");
    800012d4:	00007517          	auipc	a0,0x7
    800012d8:	e7c50513          	add	a0,a0,-388 # 80008150 <digits+0x110>
    800012dc:	fffff097          	auipc	ra,0xfffff
    800012e0:	260080e7          	jalr	608(ra) # 8000053c <panic>
    *pte = 0;
    800012e4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012e8:	995a                	add	s2,s2,s6
    800012ea:	fb3972e3          	bgeu	s2,s3,8000128e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012ee:	4601                	li	a2,0
    800012f0:	85ca                	mv	a1,s2
    800012f2:	8552                	mv	a0,s4
    800012f4:	00000097          	auipc	ra,0x0
    800012f8:	cbc080e7          	jalr	-836(ra) # 80000fb0 <walk>
    800012fc:	84aa                	mv	s1,a0
    800012fe:	d95d                	beqz	a0,800012b4 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80001300:	6108                	ld	a0,0(a0)
    80001302:	00157793          	and	a5,a0,1
    80001306:	dfdd                	beqz	a5,800012c4 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001308:	3ff57793          	and	a5,a0,1023
    8000130c:	fd7784e3          	beq	a5,s7,800012d4 <uvmunmap+0x76>
    if(do_free){
    80001310:	fc0a8ae3          	beqz	s5,800012e4 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80001314:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    80001316:	0532                	sll	a0,a0,0xc
    80001318:	fffff097          	auipc	ra,0xfffff
    8000131c:	6cc080e7          	jalr	1740(ra) # 800009e4 <kfree>
    80001320:	b7d1                	j	800012e4 <uvmunmap+0x86>

0000000080001322 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001322:	1101                	add	sp,sp,-32
    80001324:	ec06                	sd	ra,24(sp)
    80001326:	e822                	sd	s0,16(sp)
    80001328:	e426                	sd	s1,8(sp)
    8000132a:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000132c:	fffff097          	auipc	ra,0xfffff
    80001330:	7b6080e7          	jalr	1974(ra) # 80000ae2 <kalloc>
    80001334:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001336:	c519                	beqz	a0,80001344 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001338:	6605                	lui	a2,0x1
    8000133a:	4581                	li	a1,0
    8000133c:	00000097          	auipc	ra,0x0
    80001340:	992080e7          	jalr	-1646(ra) # 80000cce <memset>
  return pagetable;
}
    80001344:	8526                	mv	a0,s1
    80001346:	60e2                	ld	ra,24(sp)
    80001348:	6442                	ld	s0,16(sp)
    8000134a:	64a2                	ld	s1,8(sp)
    8000134c:	6105                	add	sp,sp,32
    8000134e:	8082                	ret

0000000080001350 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001350:	7179                	add	sp,sp,-48
    80001352:	f406                	sd	ra,40(sp)
    80001354:	f022                	sd	s0,32(sp)
    80001356:	ec26                	sd	s1,24(sp)
    80001358:	e84a                	sd	s2,16(sp)
    8000135a:	e44e                	sd	s3,8(sp)
    8000135c:	e052                	sd	s4,0(sp)
    8000135e:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001360:	6785                	lui	a5,0x1
    80001362:	04f67863          	bgeu	a2,a5,800013b2 <uvmfirst+0x62>
    80001366:	8a2a                	mv	s4,a0
    80001368:	89ae                	mv	s3,a1
    8000136a:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000136c:	fffff097          	auipc	ra,0xfffff
    80001370:	776080e7          	jalr	1910(ra) # 80000ae2 <kalloc>
    80001374:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001376:	6605                	lui	a2,0x1
    80001378:	4581                	li	a1,0
    8000137a:	00000097          	auipc	ra,0x0
    8000137e:	954080e7          	jalr	-1708(ra) # 80000cce <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001382:	4779                	li	a4,30
    80001384:	86ca                	mv	a3,s2
    80001386:	6605                	lui	a2,0x1
    80001388:	4581                	li	a1,0
    8000138a:	8552                	mv	a0,s4
    8000138c:	00000097          	auipc	ra,0x0
    80001390:	d0c080e7          	jalr	-756(ra) # 80001098 <mappages>
  memmove(mem, src, sz);
    80001394:	8626                	mv	a2,s1
    80001396:	85ce                	mv	a1,s3
    80001398:	854a                	mv	a0,s2
    8000139a:	00000097          	auipc	ra,0x0
    8000139e:	990080e7          	jalr	-1648(ra) # 80000d2a <memmove>
}
    800013a2:	70a2                	ld	ra,40(sp)
    800013a4:	7402                	ld	s0,32(sp)
    800013a6:	64e2                	ld	s1,24(sp)
    800013a8:	6942                	ld	s2,16(sp)
    800013aa:	69a2                	ld	s3,8(sp)
    800013ac:	6a02                	ld	s4,0(sp)
    800013ae:	6145                	add	sp,sp,48
    800013b0:	8082                	ret
    panic("uvmfirst: more than a page");
    800013b2:	00007517          	auipc	a0,0x7
    800013b6:	db650513          	add	a0,a0,-586 # 80008168 <digits+0x128>
    800013ba:	fffff097          	auipc	ra,0xfffff
    800013be:	182080e7          	jalr	386(ra) # 8000053c <panic>

00000000800013c2 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013c2:	1101                	add	sp,sp,-32
    800013c4:	ec06                	sd	ra,24(sp)
    800013c6:	e822                	sd	s0,16(sp)
    800013c8:	e426                	sd	s1,8(sp)
    800013ca:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013cc:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013ce:	00b67d63          	bgeu	a2,a1,800013e8 <uvmdealloc+0x26>
    800013d2:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013d4:	6785                	lui	a5,0x1
    800013d6:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013d8:	00f60733          	add	a4,a2,a5
    800013dc:	76fd                	lui	a3,0xfffff
    800013de:	8f75                	and	a4,a4,a3
    800013e0:	97ae                	add	a5,a5,a1
    800013e2:	8ff5                	and	a5,a5,a3
    800013e4:	00f76863          	bltu	a4,a5,800013f4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013e8:	8526                	mv	a0,s1
    800013ea:	60e2                	ld	ra,24(sp)
    800013ec:	6442                	ld	s0,16(sp)
    800013ee:	64a2                	ld	s1,8(sp)
    800013f0:	6105                	add	sp,sp,32
    800013f2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013f4:	8f99                	sub	a5,a5,a4
    800013f6:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013f8:	4685                	li	a3,1
    800013fa:	0007861b          	sext.w	a2,a5
    800013fe:	85ba                	mv	a1,a4
    80001400:	00000097          	auipc	ra,0x0
    80001404:	e5e080e7          	jalr	-418(ra) # 8000125e <uvmunmap>
    80001408:	b7c5                	j	800013e8 <uvmdealloc+0x26>

000000008000140a <uvmalloc>:
  if(newsz < oldsz)
    8000140a:	0ab66563          	bltu	a2,a1,800014b4 <uvmalloc+0xaa>
{
    8000140e:	7139                	add	sp,sp,-64
    80001410:	fc06                	sd	ra,56(sp)
    80001412:	f822                	sd	s0,48(sp)
    80001414:	f426                	sd	s1,40(sp)
    80001416:	f04a                	sd	s2,32(sp)
    80001418:	ec4e                	sd	s3,24(sp)
    8000141a:	e852                	sd	s4,16(sp)
    8000141c:	e456                	sd	s5,8(sp)
    8000141e:	e05a                	sd	s6,0(sp)
    80001420:	0080                	add	s0,sp,64
    80001422:	8aaa                	mv	s5,a0
    80001424:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001426:	6785                	lui	a5,0x1
    80001428:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000142a:	95be                	add	a1,a1,a5
    8000142c:	77fd                	lui	a5,0xfffff
    8000142e:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001432:	08c9f363          	bgeu	s3,a2,800014b8 <uvmalloc+0xae>
    80001436:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001438:	0126eb13          	or	s6,a3,18
    mem = kalloc();
    8000143c:	fffff097          	auipc	ra,0xfffff
    80001440:	6a6080e7          	jalr	1702(ra) # 80000ae2 <kalloc>
    80001444:	84aa                	mv	s1,a0
    if(mem == 0){
    80001446:	c51d                	beqz	a0,80001474 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80001448:	6605                	lui	a2,0x1
    8000144a:	4581                	li	a1,0
    8000144c:	00000097          	auipc	ra,0x0
    80001450:	882080e7          	jalr	-1918(ra) # 80000cce <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001454:	875a                	mv	a4,s6
    80001456:	86a6                	mv	a3,s1
    80001458:	6605                	lui	a2,0x1
    8000145a:	85ca                	mv	a1,s2
    8000145c:	8556                	mv	a0,s5
    8000145e:	00000097          	auipc	ra,0x0
    80001462:	c3a080e7          	jalr	-966(ra) # 80001098 <mappages>
    80001466:	e90d                	bnez	a0,80001498 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001468:	6785                	lui	a5,0x1
    8000146a:	993e                	add	s2,s2,a5
    8000146c:	fd4968e3          	bltu	s2,s4,8000143c <uvmalloc+0x32>
  return newsz;
    80001470:	8552                	mv	a0,s4
    80001472:	a809                	j	80001484 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80001474:	864e                	mv	a2,s3
    80001476:	85ca                	mv	a1,s2
    80001478:	8556                	mv	a0,s5
    8000147a:	00000097          	auipc	ra,0x0
    8000147e:	f48080e7          	jalr	-184(ra) # 800013c2 <uvmdealloc>
      return 0;
    80001482:	4501                	li	a0,0
}
    80001484:	70e2                	ld	ra,56(sp)
    80001486:	7442                	ld	s0,48(sp)
    80001488:	74a2                	ld	s1,40(sp)
    8000148a:	7902                	ld	s2,32(sp)
    8000148c:	69e2                	ld	s3,24(sp)
    8000148e:	6a42                	ld	s4,16(sp)
    80001490:	6aa2                	ld	s5,8(sp)
    80001492:	6b02                	ld	s6,0(sp)
    80001494:	6121                	add	sp,sp,64
    80001496:	8082                	ret
      kfree(mem);
    80001498:	8526                	mv	a0,s1
    8000149a:	fffff097          	auipc	ra,0xfffff
    8000149e:	54a080e7          	jalr	1354(ra) # 800009e4 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800014a2:	864e                	mv	a2,s3
    800014a4:	85ca                	mv	a1,s2
    800014a6:	8556                	mv	a0,s5
    800014a8:	00000097          	auipc	ra,0x0
    800014ac:	f1a080e7          	jalr	-230(ra) # 800013c2 <uvmdealloc>
      return 0;
    800014b0:	4501                	li	a0,0
    800014b2:	bfc9                	j	80001484 <uvmalloc+0x7a>
    return oldsz;
    800014b4:	852e                	mv	a0,a1
}
    800014b6:	8082                	ret
  return newsz;
    800014b8:	8532                	mv	a0,a2
    800014ba:	b7e9                	j	80001484 <uvmalloc+0x7a>

00000000800014bc <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014bc:	7179                	add	sp,sp,-48
    800014be:	f406                	sd	ra,40(sp)
    800014c0:	f022                	sd	s0,32(sp)
    800014c2:	ec26                	sd	s1,24(sp)
    800014c4:	e84a                	sd	s2,16(sp)
    800014c6:	e44e                	sd	s3,8(sp)
    800014c8:	e052                	sd	s4,0(sp)
    800014ca:	1800                	add	s0,sp,48
    800014cc:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014ce:	84aa                	mv	s1,a0
    800014d0:	6905                	lui	s2,0x1
    800014d2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014d4:	4985                	li	s3,1
    800014d6:	a829                	j	800014f0 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014d8:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    800014da:	00c79513          	sll	a0,a5,0xc
    800014de:	00000097          	auipc	ra,0x0
    800014e2:	fde080e7          	jalr	-34(ra) # 800014bc <freewalk>
      pagetable[i] = 0;
    800014e6:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014ea:	04a1                	add	s1,s1,8
    800014ec:	03248163          	beq	s1,s2,8000150e <freewalk+0x52>
    pte_t pte = pagetable[i];
    800014f0:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014f2:	00f7f713          	and	a4,a5,15
    800014f6:	ff3701e3          	beq	a4,s3,800014d8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800014fa:	8b85                	and	a5,a5,1
    800014fc:	d7fd                	beqz	a5,800014ea <freewalk+0x2e>
      panic("freewalk: leaf");
    800014fe:	00007517          	auipc	a0,0x7
    80001502:	c8a50513          	add	a0,a0,-886 # 80008188 <digits+0x148>
    80001506:	fffff097          	auipc	ra,0xfffff
    8000150a:	036080e7          	jalr	54(ra) # 8000053c <panic>
    }
  }
  kfree((void*)pagetable);
    8000150e:	8552                	mv	a0,s4
    80001510:	fffff097          	auipc	ra,0xfffff
    80001514:	4d4080e7          	jalr	1236(ra) # 800009e4 <kfree>
}
    80001518:	70a2                	ld	ra,40(sp)
    8000151a:	7402                	ld	s0,32(sp)
    8000151c:	64e2                	ld	s1,24(sp)
    8000151e:	6942                	ld	s2,16(sp)
    80001520:	69a2                	ld	s3,8(sp)
    80001522:	6a02                	ld	s4,0(sp)
    80001524:	6145                	add	sp,sp,48
    80001526:	8082                	ret

0000000080001528 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001528:	1101                	add	sp,sp,-32
    8000152a:	ec06                	sd	ra,24(sp)
    8000152c:	e822                	sd	s0,16(sp)
    8000152e:	e426                	sd	s1,8(sp)
    80001530:	1000                	add	s0,sp,32
    80001532:	84aa                	mv	s1,a0
  if(sz > 0)
    80001534:	e999                	bnez	a1,8000154a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001536:	8526                	mv	a0,s1
    80001538:	00000097          	auipc	ra,0x0
    8000153c:	f84080e7          	jalr	-124(ra) # 800014bc <freewalk>
}
    80001540:	60e2                	ld	ra,24(sp)
    80001542:	6442                	ld	s0,16(sp)
    80001544:	64a2                	ld	s1,8(sp)
    80001546:	6105                	add	sp,sp,32
    80001548:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000154a:	6785                	lui	a5,0x1
    8000154c:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000154e:	95be                	add	a1,a1,a5
    80001550:	4685                	li	a3,1
    80001552:	00c5d613          	srl	a2,a1,0xc
    80001556:	4581                	li	a1,0
    80001558:	00000097          	auipc	ra,0x0
    8000155c:	d06080e7          	jalr	-762(ra) # 8000125e <uvmunmap>
    80001560:	bfd9                	j	80001536 <uvmfree+0xe>

0000000080001562 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001562:	c679                	beqz	a2,80001630 <uvmcopy+0xce>
{
    80001564:	715d                	add	sp,sp,-80
    80001566:	e486                	sd	ra,72(sp)
    80001568:	e0a2                	sd	s0,64(sp)
    8000156a:	fc26                	sd	s1,56(sp)
    8000156c:	f84a                	sd	s2,48(sp)
    8000156e:	f44e                	sd	s3,40(sp)
    80001570:	f052                	sd	s4,32(sp)
    80001572:	ec56                	sd	s5,24(sp)
    80001574:	e85a                	sd	s6,16(sp)
    80001576:	e45e                	sd	s7,8(sp)
    80001578:	0880                	add	s0,sp,80
    8000157a:	8b2a                	mv	s6,a0
    8000157c:	8aae                	mv	s5,a1
    8000157e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001580:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001582:	4601                	li	a2,0
    80001584:	85ce                	mv	a1,s3
    80001586:	855a                	mv	a0,s6
    80001588:	00000097          	auipc	ra,0x0
    8000158c:	a28080e7          	jalr	-1496(ra) # 80000fb0 <walk>
    80001590:	c531                	beqz	a0,800015dc <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001592:	6118                	ld	a4,0(a0)
    80001594:	00177793          	and	a5,a4,1
    80001598:	cbb1                	beqz	a5,800015ec <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000159a:	00a75593          	srl	a1,a4,0xa
    8000159e:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800015a2:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    800015a6:	fffff097          	auipc	ra,0xfffff
    800015aa:	53c080e7          	jalr	1340(ra) # 80000ae2 <kalloc>
    800015ae:	892a                	mv	s2,a0
    800015b0:	c939                	beqz	a0,80001606 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800015b2:	6605                	lui	a2,0x1
    800015b4:	85de                	mv	a1,s7
    800015b6:	fffff097          	auipc	ra,0xfffff
    800015ba:	774080e7          	jalr	1908(ra) # 80000d2a <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800015be:	8726                	mv	a4,s1
    800015c0:	86ca                	mv	a3,s2
    800015c2:	6605                	lui	a2,0x1
    800015c4:	85ce                	mv	a1,s3
    800015c6:	8556                	mv	a0,s5
    800015c8:	00000097          	auipc	ra,0x0
    800015cc:	ad0080e7          	jalr	-1328(ra) # 80001098 <mappages>
    800015d0:	e515                	bnez	a0,800015fc <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015d2:	6785                	lui	a5,0x1
    800015d4:	99be                	add	s3,s3,a5
    800015d6:	fb49e6e3          	bltu	s3,s4,80001582 <uvmcopy+0x20>
    800015da:	a081                	j	8000161a <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015dc:	00007517          	auipc	a0,0x7
    800015e0:	bbc50513          	add	a0,a0,-1092 # 80008198 <digits+0x158>
    800015e4:	fffff097          	auipc	ra,0xfffff
    800015e8:	f58080e7          	jalr	-168(ra) # 8000053c <panic>
      panic("uvmcopy: page not present");
    800015ec:	00007517          	auipc	a0,0x7
    800015f0:	bcc50513          	add	a0,a0,-1076 # 800081b8 <digits+0x178>
    800015f4:	fffff097          	auipc	ra,0xfffff
    800015f8:	f48080e7          	jalr	-184(ra) # 8000053c <panic>
      kfree(mem);
    800015fc:	854a                	mv	a0,s2
    800015fe:	fffff097          	auipc	ra,0xfffff
    80001602:	3e6080e7          	jalr	998(ra) # 800009e4 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001606:	4685                	li	a3,1
    80001608:	00c9d613          	srl	a2,s3,0xc
    8000160c:	4581                	li	a1,0
    8000160e:	8556                	mv	a0,s5
    80001610:	00000097          	auipc	ra,0x0
    80001614:	c4e080e7          	jalr	-946(ra) # 8000125e <uvmunmap>
  return -1;
    80001618:	557d                	li	a0,-1
}
    8000161a:	60a6                	ld	ra,72(sp)
    8000161c:	6406                	ld	s0,64(sp)
    8000161e:	74e2                	ld	s1,56(sp)
    80001620:	7942                	ld	s2,48(sp)
    80001622:	79a2                	ld	s3,40(sp)
    80001624:	7a02                	ld	s4,32(sp)
    80001626:	6ae2                	ld	s5,24(sp)
    80001628:	6b42                	ld	s6,16(sp)
    8000162a:	6ba2                	ld	s7,8(sp)
    8000162c:	6161                	add	sp,sp,80
    8000162e:	8082                	ret
  return 0;
    80001630:	4501                	li	a0,0
}
    80001632:	8082                	ret

0000000080001634 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001634:	1141                	add	sp,sp,-16
    80001636:	e406                	sd	ra,8(sp)
    80001638:	e022                	sd	s0,0(sp)
    8000163a:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000163c:	4601                	li	a2,0
    8000163e:	00000097          	auipc	ra,0x0
    80001642:	972080e7          	jalr	-1678(ra) # 80000fb0 <walk>
  if(pte == 0)
    80001646:	c901                	beqz	a0,80001656 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001648:	611c                	ld	a5,0(a0)
    8000164a:	9bbd                	and	a5,a5,-17
    8000164c:	e11c                	sd	a5,0(a0)
}
    8000164e:	60a2                	ld	ra,8(sp)
    80001650:	6402                	ld	s0,0(sp)
    80001652:	0141                	add	sp,sp,16
    80001654:	8082                	ret
    panic("uvmclear");
    80001656:	00007517          	auipc	a0,0x7
    8000165a:	b8250513          	add	a0,a0,-1150 # 800081d8 <digits+0x198>
    8000165e:	fffff097          	auipc	ra,0xfffff
    80001662:	ede080e7          	jalr	-290(ra) # 8000053c <panic>

0000000080001666 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001666:	c6bd                	beqz	a3,800016d4 <copyout+0x6e>
{
    80001668:	715d                	add	sp,sp,-80
    8000166a:	e486                	sd	ra,72(sp)
    8000166c:	e0a2                	sd	s0,64(sp)
    8000166e:	fc26                	sd	s1,56(sp)
    80001670:	f84a                	sd	s2,48(sp)
    80001672:	f44e                	sd	s3,40(sp)
    80001674:	f052                	sd	s4,32(sp)
    80001676:	ec56                	sd	s5,24(sp)
    80001678:	e85a                	sd	s6,16(sp)
    8000167a:	e45e                	sd	s7,8(sp)
    8000167c:	e062                	sd	s8,0(sp)
    8000167e:	0880                	add	s0,sp,80
    80001680:	8b2a                	mv	s6,a0
    80001682:	8c2e                	mv	s8,a1
    80001684:	8a32                	mv	s4,a2
    80001686:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001688:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000168a:	6a85                	lui	s5,0x1
    8000168c:	a015                	j	800016b0 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000168e:	9562                	add	a0,a0,s8
    80001690:	0004861b          	sext.w	a2,s1
    80001694:	85d2                	mv	a1,s4
    80001696:	41250533          	sub	a0,a0,s2
    8000169a:	fffff097          	auipc	ra,0xfffff
    8000169e:	690080e7          	jalr	1680(ra) # 80000d2a <memmove>

    len -= n;
    800016a2:	409989b3          	sub	s3,s3,s1
    src += n;
    800016a6:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800016a8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800016ac:	02098263          	beqz	s3,800016d0 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800016b0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800016b4:	85ca                	mv	a1,s2
    800016b6:	855a                	mv	a0,s6
    800016b8:	00000097          	auipc	ra,0x0
    800016bc:	99e080e7          	jalr	-1634(ra) # 80001056 <walkaddr>
    if(pa0 == 0)
    800016c0:	cd01                	beqz	a0,800016d8 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800016c2:	418904b3          	sub	s1,s2,s8
    800016c6:	94d6                	add	s1,s1,s5
    800016c8:	fc99f3e3          	bgeu	s3,s1,8000168e <copyout+0x28>
    800016cc:	84ce                	mv	s1,s3
    800016ce:	b7c1                	j	8000168e <copyout+0x28>
  }
  return 0;
    800016d0:	4501                	li	a0,0
    800016d2:	a021                	j	800016da <copyout+0x74>
    800016d4:	4501                	li	a0,0
}
    800016d6:	8082                	ret
      return -1;
    800016d8:	557d                	li	a0,-1
}
    800016da:	60a6                	ld	ra,72(sp)
    800016dc:	6406                	ld	s0,64(sp)
    800016de:	74e2                	ld	s1,56(sp)
    800016e0:	7942                	ld	s2,48(sp)
    800016e2:	79a2                	ld	s3,40(sp)
    800016e4:	7a02                	ld	s4,32(sp)
    800016e6:	6ae2                	ld	s5,24(sp)
    800016e8:	6b42                	ld	s6,16(sp)
    800016ea:	6ba2                	ld	s7,8(sp)
    800016ec:	6c02                	ld	s8,0(sp)
    800016ee:	6161                	add	sp,sp,80
    800016f0:	8082                	ret

00000000800016f2 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016f2:	caa5                	beqz	a3,80001762 <copyin+0x70>
{
    800016f4:	715d                	add	sp,sp,-80
    800016f6:	e486                	sd	ra,72(sp)
    800016f8:	e0a2                	sd	s0,64(sp)
    800016fa:	fc26                	sd	s1,56(sp)
    800016fc:	f84a                	sd	s2,48(sp)
    800016fe:	f44e                	sd	s3,40(sp)
    80001700:	f052                	sd	s4,32(sp)
    80001702:	ec56                	sd	s5,24(sp)
    80001704:	e85a                	sd	s6,16(sp)
    80001706:	e45e                	sd	s7,8(sp)
    80001708:	e062                	sd	s8,0(sp)
    8000170a:	0880                	add	s0,sp,80
    8000170c:	8b2a                	mv	s6,a0
    8000170e:	8a2e                	mv	s4,a1
    80001710:	8c32                	mv	s8,a2
    80001712:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001714:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001716:	6a85                	lui	s5,0x1
    80001718:	a01d                	j	8000173e <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000171a:	018505b3          	add	a1,a0,s8
    8000171e:	0004861b          	sext.w	a2,s1
    80001722:	412585b3          	sub	a1,a1,s2
    80001726:	8552                	mv	a0,s4
    80001728:	fffff097          	auipc	ra,0xfffff
    8000172c:	602080e7          	jalr	1538(ra) # 80000d2a <memmove>

    len -= n;
    80001730:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001734:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001736:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000173a:	02098263          	beqz	s3,8000175e <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    8000173e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001742:	85ca                	mv	a1,s2
    80001744:	855a                	mv	a0,s6
    80001746:	00000097          	auipc	ra,0x0
    8000174a:	910080e7          	jalr	-1776(ra) # 80001056 <walkaddr>
    if(pa0 == 0)
    8000174e:	cd01                	beqz	a0,80001766 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001750:	418904b3          	sub	s1,s2,s8
    80001754:	94d6                	add	s1,s1,s5
    80001756:	fc99f2e3          	bgeu	s3,s1,8000171a <copyin+0x28>
    8000175a:	84ce                	mv	s1,s3
    8000175c:	bf7d                	j	8000171a <copyin+0x28>
  }
  return 0;
    8000175e:	4501                	li	a0,0
    80001760:	a021                	j	80001768 <copyin+0x76>
    80001762:	4501                	li	a0,0
}
    80001764:	8082                	ret
      return -1;
    80001766:	557d                	li	a0,-1
}
    80001768:	60a6                	ld	ra,72(sp)
    8000176a:	6406                	ld	s0,64(sp)
    8000176c:	74e2                	ld	s1,56(sp)
    8000176e:	7942                	ld	s2,48(sp)
    80001770:	79a2                	ld	s3,40(sp)
    80001772:	7a02                	ld	s4,32(sp)
    80001774:	6ae2                	ld	s5,24(sp)
    80001776:	6b42                	ld	s6,16(sp)
    80001778:	6ba2                	ld	s7,8(sp)
    8000177a:	6c02                	ld	s8,0(sp)
    8000177c:	6161                	add	sp,sp,80
    8000177e:	8082                	ret

0000000080001780 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001780:	c2dd                	beqz	a3,80001826 <copyinstr+0xa6>
{
    80001782:	715d                	add	sp,sp,-80
    80001784:	e486                	sd	ra,72(sp)
    80001786:	e0a2                	sd	s0,64(sp)
    80001788:	fc26                	sd	s1,56(sp)
    8000178a:	f84a                	sd	s2,48(sp)
    8000178c:	f44e                	sd	s3,40(sp)
    8000178e:	f052                	sd	s4,32(sp)
    80001790:	ec56                	sd	s5,24(sp)
    80001792:	e85a                	sd	s6,16(sp)
    80001794:	e45e                	sd	s7,8(sp)
    80001796:	0880                	add	s0,sp,80
    80001798:	8a2a                	mv	s4,a0
    8000179a:	8b2e                	mv	s6,a1
    8000179c:	8bb2                	mv	s7,a2
    8000179e:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800017a0:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017a2:	6985                	lui	s3,0x1
    800017a4:	a02d                	j	800017ce <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800017a6:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800017aa:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800017ac:	37fd                	addw	a5,a5,-1
    800017ae:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800017b2:	60a6                	ld	ra,72(sp)
    800017b4:	6406                	ld	s0,64(sp)
    800017b6:	74e2                	ld	s1,56(sp)
    800017b8:	7942                	ld	s2,48(sp)
    800017ba:	79a2                	ld	s3,40(sp)
    800017bc:	7a02                	ld	s4,32(sp)
    800017be:	6ae2                	ld	s5,24(sp)
    800017c0:	6b42                	ld	s6,16(sp)
    800017c2:	6ba2                	ld	s7,8(sp)
    800017c4:	6161                	add	sp,sp,80
    800017c6:	8082                	ret
    srcva = va0 + PGSIZE;
    800017c8:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017cc:	c8a9                	beqz	s1,8000181e <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    800017ce:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017d2:	85ca                	mv	a1,s2
    800017d4:	8552                	mv	a0,s4
    800017d6:	00000097          	auipc	ra,0x0
    800017da:	880080e7          	jalr	-1920(ra) # 80001056 <walkaddr>
    if(pa0 == 0)
    800017de:	c131                	beqz	a0,80001822 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    800017e0:	417906b3          	sub	a3,s2,s7
    800017e4:	96ce                	add	a3,a3,s3
    800017e6:	00d4f363          	bgeu	s1,a3,800017ec <copyinstr+0x6c>
    800017ea:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800017ec:	955e                	add	a0,a0,s7
    800017ee:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800017f2:	daf9                	beqz	a3,800017c8 <copyinstr+0x48>
    800017f4:	87da                	mv	a5,s6
    800017f6:	885a                	mv	a6,s6
      if(*p == '\0'){
    800017f8:	41650633          	sub	a2,a0,s6
    while(n > 0){
    800017fc:	96da                	add	a3,a3,s6
    800017fe:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001800:	00f60733          	add	a4,a2,a5
    80001804:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd1d0>
    80001808:	df59                	beqz	a4,800017a6 <copyinstr+0x26>
        *dst = *p;
    8000180a:	00e78023          	sb	a4,0(a5)
      dst++;
    8000180e:	0785                	add	a5,a5,1
    while(n > 0){
    80001810:	fed797e3          	bne	a5,a3,800017fe <copyinstr+0x7e>
    80001814:	14fd                	add	s1,s1,-1
    80001816:	94c2                	add	s1,s1,a6
      --max;
    80001818:	8c8d                	sub	s1,s1,a1
      dst++;
    8000181a:	8b3e                	mv	s6,a5
    8000181c:	b775                	j	800017c8 <copyinstr+0x48>
    8000181e:	4781                	li	a5,0
    80001820:	b771                	j	800017ac <copyinstr+0x2c>
      return -1;
    80001822:	557d                	li	a0,-1
    80001824:	b779                	j	800017b2 <copyinstr+0x32>
  int got_null = 0;
    80001826:	4781                	li	a5,0
  if(got_null){
    80001828:	37fd                	addw	a5,a5,-1
    8000182a:	0007851b          	sext.w	a0,a5
}
    8000182e:	8082                	ret

0000000080001830 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001830:	7139                	add	sp,sp,-64
    80001832:	fc06                	sd	ra,56(sp)
    80001834:	f822                	sd	s0,48(sp)
    80001836:	f426                	sd	s1,40(sp)
    80001838:	f04a                	sd	s2,32(sp)
    8000183a:	ec4e                	sd	s3,24(sp)
    8000183c:	e852                	sd	s4,16(sp)
    8000183e:	e456                	sd	s5,8(sp)
    80001840:	e05a                	sd	s6,0(sp)
    80001842:	0080                	add	s0,sp,64
    80001844:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001846:	00010497          	auipc	s1,0x10
    8000184a:	80a48493          	add	s1,s1,-2038 # 80011050 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    8000184e:	8b26                	mv	s6,s1
    80001850:	00006a97          	auipc	s5,0x6
    80001854:	7b0a8a93          	add	s5,s5,1968 # 80008000 <etext>
    80001858:	04000937          	lui	s2,0x4000
    8000185c:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000185e:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001860:	00015a17          	auipc	s4,0x15
    80001864:	1f0a0a13          	add	s4,s4,496 # 80016a50 <tickslock>
    char *pa = kalloc();
    80001868:	fffff097          	auipc	ra,0xfffff
    8000186c:	27a080e7          	jalr	634(ra) # 80000ae2 <kalloc>
    80001870:	862a                	mv	a2,a0
    if(pa == 0)
    80001872:	c131                	beqz	a0,800018b6 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80001874:	416485b3          	sub	a1,s1,s6
    80001878:	858d                	sra	a1,a1,0x3
    8000187a:	000ab783          	ld	a5,0(s5)
    8000187e:	02f585b3          	mul	a1,a1,a5
    80001882:	2585                	addw	a1,a1,1
    80001884:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001888:	4719                	li	a4,6
    8000188a:	6685                	lui	a3,0x1
    8000188c:	40b905b3          	sub	a1,s2,a1
    80001890:	854e                	mv	a0,s3
    80001892:	00000097          	auipc	ra,0x0
    80001896:	8a6080e7          	jalr	-1882(ra) # 80001138 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000189a:	16848493          	add	s1,s1,360
    8000189e:	fd4495e3          	bne	s1,s4,80001868 <proc_mapstacks+0x38>
  }
}
    800018a2:	70e2                	ld	ra,56(sp)
    800018a4:	7442                	ld	s0,48(sp)
    800018a6:	74a2                	ld	s1,40(sp)
    800018a8:	7902                	ld	s2,32(sp)
    800018aa:	69e2                	ld	s3,24(sp)
    800018ac:	6a42                	ld	s4,16(sp)
    800018ae:	6aa2                	ld	s5,8(sp)
    800018b0:	6b02                	ld	s6,0(sp)
    800018b2:	6121                	add	sp,sp,64
    800018b4:	8082                	ret
      panic("kalloc");
    800018b6:	00007517          	auipc	a0,0x7
    800018ba:	93250513          	add	a0,a0,-1742 # 800081e8 <digits+0x1a8>
    800018be:	fffff097          	auipc	ra,0xfffff
    800018c2:	c7e080e7          	jalr	-898(ra) # 8000053c <panic>

00000000800018c6 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800018c6:	7139                	add	sp,sp,-64
    800018c8:	fc06                	sd	ra,56(sp)
    800018ca:	f822                	sd	s0,48(sp)
    800018cc:	f426                	sd	s1,40(sp)
    800018ce:	f04a                	sd	s2,32(sp)
    800018d0:	ec4e                	sd	s3,24(sp)
    800018d2:	e852                	sd	s4,16(sp)
    800018d4:	e456                	sd	s5,8(sp)
    800018d6:	e05a                	sd	s6,0(sp)
    800018d8:	0080                	add	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800018da:	00007597          	auipc	a1,0x7
    800018de:	91658593          	add	a1,a1,-1770 # 800081f0 <digits+0x1b0>
    800018e2:	0000f517          	auipc	a0,0xf
    800018e6:	33e50513          	add	a0,a0,830 # 80010c20 <pid_lock>
    800018ea:	fffff097          	auipc	ra,0xfffff
    800018ee:	258080e7          	jalr	600(ra) # 80000b42 <initlock>
  initlock(&wait_lock, "wait_lock");
    800018f2:	00007597          	auipc	a1,0x7
    800018f6:	90658593          	add	a1,a1,-1786 # 800081f8 <digits+0x1b8>
    800018fa:	0000f517          	auipc	a0,0xf
    800018fe:	33e50513          	add	a0,a0,830 # 80010c38 <wait_lock>
    80001902:	fffff097          	auipc	ra,0xfffff
    80001906:	240080e7          	jalr	576(ra) # 80000b42 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000190a:	0000f497          	auipc	s1,0xf
    8000190e:	74648493          	add	s1,s1,1862 # 80011050 <proc>
      initlock(&p->lock, "proc");
    80001912:	00007b17          	auipc	s6,0x7
    80001916:	8f6b0b13          	add	s6,s6,-1802 # 80008208 <digits+0x1c8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000191a:	8aa6                	mv	s5,s1
    8000191c:	00006a17          	auipc	s4,0x6
    80001920:	6e4a0a13          	add	s4,s4,1764 # 80008000 <etext>
    80001924:	04000937          	lui	s2,0x4000
    80001928:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000192a:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000192c:	00015997          	auipc	s3,0x15
    80001930:	12498993          	add	s3,s3,292 # 80016a50 <tickslock>
      initlock(&p->lock, "proc");
    80001934:	85da                	mv	a1,s6
    80001936:	8526                	mv	a0,s1
    80001938:	fffff097          	auipc	ra,0xfffff
    8000193c:	20a080e7          	jalr	522(ra) # 80000b42 <initlock>
      p->state = UNUSED;
    80001940:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001944:	415487b3          	sub	a5,s1,s5
    80001948:	878d                	sra	a5,a5,0x3
    8000194a:	000a3703          	ld	a4,0(s4)
    8000194e:	02e787b3          	mul	a5,a5,a4
    80001952:	2785                	addw	a5,a5,1
    80001954:	00d7979b          	sllw	a5,a5,0xd
    80001958:	40f907b3          	sub	a5,s2,a5
    8000195c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000195e:	16848493          	add	s1,s1,360
    80001962:	fd3499e3          	bne	s1,s3,80001934 <procinit+0x6e>
  }
}
    80001966:	70e2                	ld	ra,56(sp)
    80001968:	7442                	ld	s0,48(sp)
    8000196a:	74a2                	ld	s1,40(sp)
    8000196c:	7902                	ld	s2,32(sp)
    8000196e:	69e2                	ld	s3,24(sp)
    80001970:	6a42                	ld	s4,16(sp)
    80001972:	6aa2                	ld	s5,8(sp)
    80001974:	6b02                	ld	s6,0(sp)
    80001976:	6121                	add	sp,sp,64
    80001978:	8082                	ret

000000008000197a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    8000197a:	1141                	add	sp,sp,-16
    8000197c:	e422                	sd	s0,8(sp)
    8000197e:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001980:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001982:	2501                	sext.w	a0,a0
    80001984:	6422                	ld	s0,8(sp)
    80001986:	0141                	add	sp,sp,16
    80001988:	8082                	ret

000000008000198a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    8000198a:	1141                	add	sp,sp,-16
    8000198c:	e422                	sd	s0,8(sp)
    8000198e:	0800                	add	s0,sp,16
    80001990:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001992:	2781                	sext.w	a5,a5
    80001994:	079e                	sll	a5,a5,0x7
  return c;
}
    80001996:	0000f517          	auipc	a0,0xf
    8000199a:	2ba50513          	add	a0,a0,698 # 80010c50 <cpus>
    8000199e:	953e                	add	a0,a0,a5
    800019a0:	6422                	ld	s0,8(sp)
    800019a2:	0141                	add	sp,sp,16
    800019a4:	8082                	ret

00000000800019a6 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800019a6:	1101                	add	sp,sp,-32
    800019a8:	ec06                	sd	ra,24(sp)
    800019aa:	e822                	sd	s0,16(sp)
    800019ac:	e426                	sd	s1,8(sp)
    800019ae:	1000                	add	s0,sp,32
  push_off();
    800019b0:	fffff097          	auipc	ra,0xfffff
    800019b4:	1d6080e7          	jalr	470(ra) # 80000b86 <push_off>
    800019b8:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800019ba:	2781                	sext.w	a5,a5
    800019bc:	079e                	sll	a5,a5,0x7
    800019be:	0000f717          	auipc	a4,0xf
    800019c2:	26270713          	add	a4,a4,610 # 80010c20 <pid_lock>
    800019c6:	97ba                	add	a5,a5,a4
    800019c8:	7b84                	ld	s1,48(a5)
  pop_off();
    800019ca:	fffff097          	auipc	ra,0xfffff
    800019ce:	25c080e7          	jalr	604(ra) # 80000c26 <pop_off>
  return p;
}
    800019d2:	8526                	mv	a0,s1
    800019d4:	60e2                	ld	ra,24(sp)
    800019d6:	6442                	ld	s0,16(sp)
    800019d8:	64a2                	ld	s1,8(sp)
    800019da:	6105                	add	sp,sp,32
    800019dc:	8082                	ret

00000000800019de <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800019de:	1141                	add	sp,sp,-16
    800019e0:	e406                	sd	ra,8(sp)
    800019e2:	e022                	sd	s0,0(sp)
    800019e4:	0800                	add	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800019e6:	00000097          	auipc	ra,0x0
    800019ea:	fc0080e7          	jalr	-64(ra) # 800019a6 <myproc>
    800019ee:	fffff097          	auipc	ra,0xfffff
    800019f2:	298080e7          	jalr	664(ra) # 80000c86 <release>

  if (first) {
    800019f6:	00007797          	auipc	a5,0x7
    800019fa:	f3a7a783          	lw	a5,-198(a5) # 80008930 <first.1>
    800019fe:	eb89                	bnez	a5,80001a10 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001a00:	00001097          	auipc	ra,0x1
    80001a04:	c5c080e7          	jalr	-932(ra) # 8000265c <usertrapret>
}
    80001a08:	60a2                	ld	ra,8(sp)
    80001a0a:	6402                	ld	s0,0(sp)
    80001a0c:	0141                	add	sp,sp,16
    80001a0e:	8082                	ret
    first = 0;
    80001a10:	00007797          	auipc	a5,0x7
    80001a14:	f207a023          	sw	zero,-224(a5) # 80008930 <first.1>
    fsinit(ROOTDEV);
    80001a18:	4505                	li	a0,1
    80001a1a:	00002097          	auipc	ra,0x2
    80001a1e:	c20080e7          	jalr	-992(ra) # 8000363a <fsinit>
    80001a22:	bff9                	j	80001a00 <forkret+0x22>

0000000080001a24 <allocpid>:
{
    80001a24:	1101                	add	sp,sp,-32
    80001a26:	ec06                	sd	ra,24(sp)
    80001a28:	e822                	sd	s0,16(sp)
    80001a2a:	e426                	sd	s1,8(sp)
    80001a2c:	e04a                	sd	s2,0(sp)
    80001a2e:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80001a30:	0000f917          	auipc	s2,0xf
    80001a34:	1f090913          	add	s2,s2,496 # 80010c20 <pid_lock>
    80001a38:	854a                	mv	a0,s2
    80001a3a:	fffff097          	auipc	ra,0xfffff
    80001a3e:	198080e7          	jalr	408(ra) # 80000bd2 <acquire>
  pid = nextpid;
    80001a42:	00007797          	auipc	a5,0x7
    80001a46:	ef278793          	add	a5,a5,-270 # 80008934 <nextpid>
    80001a4a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a4c:	0014871b          	addw	a4,s1,1
    80001a50:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a52:	854a                	mv	a0,s2
    80001a54:	fffff097          	auipc	ra,0xfffff
    80001a58:	232080e7          	jalr	562(ra) # 80000c86 <release>
}
    80001a5c:	8526                	mv	a0,s1
    80001a5e:	60e2                	ld	ra,24(sp)
    80001a60:	6442                	ld	s0,16(sp)
    80001a62:	64a2                	ld	s1,8(sp)
    80001a64:	6902                	ld	s2,0(sp)
    80001a66:	6105                	add	sp,sp,32
    80001a68:	8082                	ret

0000000080001a6a <proc_pagetable>:
{
    80001a6a:	1101                	add	sp,sp,-32
    80001a6c:	ec06                	sd	ra,24(sp)
    80001a6e:	e822                	sd	s0,16(sp)
    80001a70:	e426                	sd	s1,8(sp)
    80001a72:	e04a                	sd	s2,0(sp)
    80001a74:	1000                	add	s0,sp,32
    80001a76:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a78:	00000097          	auipc	ra,0x0
    80001a7c:	8aa080e7          	jalr	-1878(ra) # 80001322 <uvmcreate>
    80001a80:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a82:	c121                	beqz	a0,80001ac2 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a84:	4729                	li	a4,10
    80001a86:	00005697          	auipc	a3,0x5
    80001a8a:	57a68693          	add	a3,a3,1402 # 80007000 <_trampoline>
    80001a8e:	6605                	lui	a2,0x1
    80001a90:	040005b7          	lui	a1,0x4000
    80001a94:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a96:	05b2                	sll	a1,a1,0xc
    80001a98:	fffff097          	auipc	ra,0xfffff
    80001a9c:	600080e7          	jalr	1536(ra) # 80001098 <mappages>
    80001aa0:	02054863          	bltz	a0,80001ad0 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001aa4:	4719                	li	a4,6
    80001aa6:	05893683          	ld	a3,88(s2)
    80001aaa:	6605                	lui	a2,0x1
    80001aac:	020005b7          	lui	a1,0x2000
    80001ab0:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ab2:	05b6                	sll	a1,a1,0xd
    80001ab4:	8526                	mv	a0,s1
    80001ab6:	fffff097          	auipc	ra,0xfffff
    80001aba:	5e2080e7          	jalr	1506(ra) # 80001098 <mappages>
    80001abe:	02054163          	bltz	a0,80001ae0 <proc_pagetable+0x76>
}
    80001ac2:	8526                	mv	a0,s1
    80001ac4:	60e2                	ld	ra,24(sp)
    80001ac6:	6442                	ld	s0,16(sp)
    80001ac8:	64a2                	ld	s1,8(sp)
    80001aca:	6902                	ld	s2,0(sp)
    80001acc:	6105                	add	sp,sp,32
    80001ace:	8082                	ret
    uvmfree(pagetable, 0);
    80001ad0:	4581                	li	a1,0
    80001ad2:	8526                	mv	a0,s1
    80001ad4:	00000097          	auipc	ra,0x0
    80001ad8:	a54080e7          	jalr	-1452(ra) # 80001528 <uvmfree>
    return 0;
    80001adc:	4481                	li	s1,0
    80001ade:	b7d5                	j	80001ac2 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ae0:	4681                	li	a3,0
    80001ae2:	4605                	li	a2,1
    80001ae4:	040005b7          	lui	a1,0x4000
    80001ae8:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001aea:	05b2                	sll	a1,a1,0xc
    80001aec:	8526                	mv	a0,s1
    80001aee:	fffff097          	auipc	ra,0xfffff
    80001af2:	770080e7          	jalr	1904(ra) # 8000125e <uvmunmap>
    uvmfree(pagetable, 0);
    80001af6:	4581                	li	a1,0
    80001af8:	8526                	mv	a0,s1
    80001afa:	00000097          	auipc	ra,0x0
    80001afe:	a2e080e7          	jalr	-1490(ra) # 80001528 <uvmfree>
    return 0;
    80001b02:	4481                	li	s1,0
    80001b04:	bf7d                	j	80001ac2 <proc_pagetable+0x58>

0000000080001b06 <proc_freepagetable>:
{
    80001b06:	1101                	add	sp,sp,-32
    80001b08:	ec06                	sd	ra,24(sp)
    80001b0a:	e822                	sd	s0,16(sp)
    80001b0c:	e426                	sd	s1,8(sp)
    80001b0e:	e04a                	sd	s2,0(sp)
    80001b10:	1000                	add	s0,sp,32
    80001b12:	84aa                	mv	s1,a0
    80001b14:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b16:	4681                	li	a3,0
    80001b18:	4605                	li	a2,1
    80001b1a:	040005b7          	lui	a1,0x4000
    80001b1e:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b20:	05b2                	sll	a1,a1,0xc
    80001b22:	fffff097          	auipc	ra,0xfffff
    80001b26:	73c080e7          	jalr	1852(ra) # 8000125e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b2a:	4681                	li	a3,0
    80001b2c:	4605                	li	a2,1
    80001b2e:	020005b7          	lui	a1,0x2000
    80001b32:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b34:	05b6                	sll	a1,a1,0xd
    80001b36:	8526                	mv	a0,s1
    80001b38:	fffff097          	auipc	ra,0xfffff
    80001b3c:	726080e7          	jalr	1830(ra) # 8000125e <uvmunmap>
  uvmfree(pagetable, sz);
    80001b40:	85ca                	mv	a1,s2
    80001b42:	8526                	mv	a0,s1
    80001b44:	00000097          	auipc	ra,0x0
    80001b48:	9e4080e7          	jalr	-1564(ra) # 80001528 <uvmfree>
}
    80001b4c:	60e2                	ld	ra,24(sp)
    80001b4e:	6442                	ld	s0,16(sp)
    80001b50:	64a2                	ld	s1,8(sp)
    80001b52:	6902                	ld	s2,0(sp)
    80001b54:	6105                	add	sp,sp,32
    80001b56:	8082                	ret

0000000080001b58 <freeproc>:
{
    80001b58:	1101                	add	sp,sp,-32
    80001b5a:	ec06                	sd	ra,24(sp)
    80001b5c:	e822                	sd	s0,16(sp)
    80001b5e:	e426                	sd	s1,8(sp)
    80001b60:	1000                	add	s0,sp,32
    80001b62:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b64:	6d28                	ld	a0,88(a0)
    80001b66:	c509                	beqz	a0,80001b70 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001b68:	fffff097          	auipc	ra,0xfffff
    80001b6c:	e7c080e7          	jalr	-388(ra) # 800009e4 <kfree>
  p->trapframe = 0;
    80001b70:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b74:	68a8                	ld	a0,80(s1)
    80001b76:	c511                	beqz	a0,80001b82 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001b78:	64ac                	ld	a1,72(s1)
    80001b7a:	00000097          	auipc	ra,0x0
    80001b7e:	f8c080e7          	jalr	-116(ra) # 80001b06 <proc_freepagetable>
  p->pagetable = 0;
    80001b82:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b86:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b8a:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001b8e:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001b92:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b96:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b9a:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b9e:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001ba2:	0004ac23          	sw	zero,24(s1)
}
    80001ba6:	60e2                	ld	ra,24(sp)
    80001ba8:	6442                	ld	s0,16(sp)
    80001baa:	64a2                	ld	s1,8(sp)
    80001bac:	6105                	add	sp,sp,32
    80001bae:	8082                	ret

0000000080001bb0 <allocproc>:
{
    80001bb0:	1101                	add	sp,sp,-32
    80001bb2:	ec06                	sd	ra,24(sp)
    80001bb4:	e822                	sd	s0,16(sp)
    80001bb6:	e426                	sd	s1,8(sp)
    80001bb8:	e04a                	sd	s2,0(sp)
    80001bba:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bbc:	0000f497          	auipc	s1,0xf
    80001bc0:	49448493          	add	s1,s1,1172 # 80011050 <proc>
    80001bc4:	00015917          	auipc	s2,0x15
    80001bc8:	e8c90913          	add	s2,s2,-372 # 80016a50 <tickslock>
    acquire(&p->lock);
    80001bcc:	8526                	mv	a0,s1
    80001bce:	fffff097          	auipc	ra,0xfffff
    80001bd2:	004080e7          	jalr	4(ra) # 80000bd2 <acquire>
    if(p->state == UNUSED) {
    80001bd6:	4c9c                	lw	a5,24(s1)
    80001bd8:	cf81                	beqz	a5,80001bf0 <allocproc+0x40>
      release(&p->lock);
    80001bda:	8526                	mv	a0,s1
    80001bdc:	fffff097          	auipc	ra,0xfffff
    80001be0:	0aa080e7          	jalr	170(ra) # 80000c86 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001be4:	16848493          	add	s1,s1,360
    80001be8:	ff2492e3          	bne	s1,s2,80001bcc <allocproc+0x1c>
  return 0;
    80001bec:	4481                	li	s1,0
    80001bee:	a889                	j	80001c40 <allocproc+0x90>
  p->pid = allocpid();
    80001bf0:	00000097          	auipc	ra,0x0
    80001bf4:	e34080e7          	jalr	-460(ra) # 80001a24 <allocpid>
    80001bf8:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001bfa:	4785                	li	a5,1
    80001bfc:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001bfe:	fffff097          	auipc	ra,0xfffff
    80001c02:	ee4080e7          	jalr	-284(ra) # 80000ae2 <kalloc>
    80001c06:	892a                	mv	s2,a0
    80001c08:	eca8                	sd	a0,88(s1)
    80001c0a:	c131                	beqz	a0,80001c4e <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001c0c:	8526                	mv	a0,s1
    80001c0e:	00000097          	auipc	ra,0x0
    80001c12:	e5c080e7          	jalr	-420(ra) # 80001a6a <proc_pagetable>
    80001c16:	892a                	mv	s2,a0
    80001c18:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c1a:	c531                	beqz	a0,80001c66 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001c1c:	07000613          	li	a2,112
    80001c20:	4581                	li	a1,0
    80001c22:	06048513          	add	a0,s1,96
    80001c26:	fffff097          	auipc	ra,0xfffff
    80001c2a:	0a8080e7          	jalr	168(ra) # 80000cce <memset>
  p->context.ra = (uint64)forkret;
    80001c2e:	00000797          	auipc	a5,0x0
    80001c32:	db078793          	add	a5,a5,-592 # 800019de <forkret>
    80001c36:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c38:	60bc                	ld	a5,64(s1)
    80001c3a:	6705                	lui	a4,0x1
    80001c3c:	97ba                	add	a5,a5,a4
    80001c3e:	f4bc                	sd	a5,104(s1)
}
    80001c40:	8526                	mv	a0,s1
    80001c42:	60e2                	ld	ra,24(sp)
    80001c44:	6442                	ld	s0,16(sp)
    80001c46:	64a2                	ld	s1,8(sp)
    80001c48:	6902                	ld	s2,0(sp)
    80001c4a:	6105                	add	sp,sp,32
    80001c4c:	8082                	ret
    freeproc(p);
    80001c4e:	8526                	mv	a0,s1
    80001c50:	00000097          	auipc	ra,0x0
    80001c54:	f08080e7          	jalr	-248(ra) # 80001b58 <freeproc>
    release(&p->lock);
    80001c58:	8526                	mv	a0,s1
    80001c5a:	fffff097          	auipc	ra,0xfffff
    80001c5e:	02c080e7          	jalr	44(ra) # 80000c86 <release>
    return 0;
    80001c62:	84ca                	mv	s1,s2
    80001c64:	bff1                	j	80001c40 <allocproc+0x90>
    freeproc(p);
    80001c66:	8526                	mv	a0,s1
    80001c68:	00000097          	auipc	ra,0x0
    80001c6c:	ef0080e7          	jalr	-272(ra) # 80001b58 <freeproc>
    release(&p->lock);
    80001c70:	8526                	mv	a0,s1
    80001c72:	fffff097          	auipc	ra,0xfffff
    80001c76:	014080e7          	jalr	20(ra) # 80000c86 <release>
    return 0;
    80001c7a:	84ca                	mv	s1,s2
    80001c7c:	b7d1                	j	80001c40 <allocproc+0x90>

0000000080001c7e <userinit>:
{
    80001c7e:	1101                	add	sp,sp,-32
    80001c80:	ec06                	sd	ra,24(sp)
    80001c82:	e822                	sd	s0,16(sp)
    80001c84:	e426                	sd	s1,8(sp)
    80001c86:	1000                	add	s0,sp,32
  p = allocproc();
    80001c88:	00000097          	auipc	ra,0x0
    80001c8c:	f28080e7          	jalr	-216(ra) # 80001bb0 <allocproc>
    80001c90:	84aa                	mv	s1,a0
  initproc = p;
    80001c92:	00007797          	auipc	a5,0x7
    80001c96:	d0a7bb23          	sd	a0,-746(a5) # 800089a8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001c9a:	03400613          	li	a2,52
    80001c9e:	00007597          	auipc	a1,0x7
    80001ca2:	ca258593          	add	a1,a1,-862 # 80008940 <initcode>
    80001ca6:	6928                	ld	a0,80(a0)
    80001ca8:	fffff097          	auipc	ra,0xfffff
    80001cac:	6a8080e7          	jalr	1704(ra) # 80001350 <uvmfirst>
  p->sz = PGSIZE;
    80001cb0:	6785                	lui	a5,0x1
    80001cb2:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001cb4:	6cb8                	ld	a4,88(s1)
    80001cb6:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001cba:	6cb8                	ld	a4,88(s1)
    80001cbc:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001cbe:	4641                	li	a2,16
    80001cc0:	00006597          	auipc	a1,0x6
    80001cc4:	55058593          	add	a1,a1,1360 # 80008210 <digits+0x1d0>
    80001cc8:	15848513          	add	a0,s1,344
    80001ccc:	fffff097          	auipc	ra,0xfffff
    80001cd0:	14a080e7          	jalr	330(ra) # 80000e16 <safestrcpy>
  p->cwd = namei("/");
    80001cd4:	00006517          	auipc	a0,0x6
    80001cd8:	54c50513          	add	a0,a0,1356 # 80008220 <digits+0x1e0>
    80001cdc:	00002097          	auipc	ra,0x2
    80001ce0:	37e080e7          	jalr	894(ra) # 8000405a <namei>
    80001ce4:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001ce8:	478d                	li	a5,3
    80001cea:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001cec:	8526                	mv	a0,s1
    80001cee:	fffff097          	auipc	ra,0xfffff
    80001cf2:	f98080e7          	jalr	-104(ra) # 80000c86 <release>
}
    80001cf6:	60e2                	ld	ra,24(sp)
    80001cf8:	6442                	ld	s0,16(sp)
    80001cfa:	64a2                	ld	s1,8(sp)
    80001cfc:	6105                	add	sp,sp,32
    80001cfe:	8082                	ret

0000000080001d00 <growproc>:
{
    80001d00:	1101                	add	sp,sp,-32
    80001d02:	ec06                	sd	ra,24(sp)
    80001d04:	e822                	sd	s0,16(sp)
    80001d06:	e426                	sd	s1,8(sp)
    80001d08:	e04a                	sd	s2,0(sp)
    80001d0a:	1000                	add	s0,sp,32
    80001d0c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001d0e:	00000097          	auipc	ra,0x0
    80001d12:	c98080e7          	jalr	-872(ra) # 800019a6 <myproc>
    80001d16:	84aa                	mv	s1,a0
  sz = p->sz;
    80001d18:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001d1a:	01204c63          	bgtz	s2,80001d32 <growproc+0x32>
  } else if(n < 0){
    80001d1e:	02094663          	bltz	s2,80001d4a <growproc+0x4a>
  p->sz = sz;
    80001d22:	e4ac                	sd	a1,72(s1)
  return 0;
    80001d24:	4501                	li	a0,0
}
    80001d26:	60e2                	ld	ra,24(sp)
    80001d28:	6442                	ld	s0,16(sp)
    80001d2a:	64a2                	ld	s1,8(sp)
    80001d2c:	6902                	ld	s2,0(sp)
    80001d2e:	6105                	add	sp,sp,32
    80001d30:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001d32:	4691                	li	a3,4
    80001d34:	00b90633          	add	a2,s2,a1
    80001d38:	6928                	ld	a0,80(a0)
    80001d3a:	fffff097          	auipc	ra,0xfffff
    80001d3e:	6d0080e7          	jalr	1744(ra) # 8000140a <uvmalloc>
    80001d42:	85aa                	mv	a1,a0
    80001d44:	fd79                	bnez	a0,80001d22 <growproc+0x22>
      return -1;
    80001d46:	557d                	li	a0,-1
    80001d48:	bff9                	j	80001d26 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d4a:	00b90633          	add	a2,s2,a1
    80001d4e:	6928                	ld	a0,80(a0)
    80001d50:	fffff097          	auipc	ra,0xfffff
    80001d54:	672080e7          	jalr	1650(ra) # 800013c2 <uvmdealloc>
    80001d58:	85aa                	mv	a1,a0
    80001d5a:	b7e1                	j	80001d22 <growproc+0x22>

0000000080001d5c <fork>:
{
    80001d5c:	7139                	add	sp,sp,-64
    80001d5e:	fc06                	sd	ra,56(sp)
    80001d60:	f822                	sd	s0,48(sp)
    80001d62:	f426                	sd	s1,40(sp)
    80001d64:	f04a                	sd	s2,32(sp)
    80001d66:	ec4e                	sd	s3,24(sp)
    80001d68:	e852                	sd	s4,16(sp)
    80001d6a:	e456                	sd	s5,8(sp)
    80001d6c:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001d6e:	00000097          	auipc	ra,0x0
    80001d72:	c38080e7          	jalr	-968(ra) # 800019a6 <myproc>
    80001d76:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001d78:	00000097          	auipc	ra,0x0
    80001d7c:	e38080e7          	jalr	-456(ra) # 80001bb0 <allocproc>
    80001d80:	10050c63          	beqz	a0,80001e98 <fork+0x13c>
    80001d84:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001d86:	048ab603          	ld	a2,72(s5)
    80001d8a:	692c                	ld	a1,80(a0)
    80001d8c:	050ab503          	ld	a0,80(s5)
    80001d90:	fffff097          	auipc	ra,0xfffff
    80001d94:	7d2080e7          	jalr	2002(ra) # 80001562 <uvmcopy>
    80001d98:	04054863          	bltz	a0,80001de8 <fork+0x8c>
  np->sz = p->sz;
    80001d9c:	048ab783          	ld	a5,72(s5)
    80001da0:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001da4:	058ab683          	ld	a3,88(s5)
    80001da8:	87b6                	mv	a5,a3
    80001daa:	058a3703          	ld	a4,88(s4)
    80001dae:	12068693          	add	a3,a3,288
    80001db2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001db6:	6788                	ld	a0,8(a5)
    80001db8:	6b8c                	ld	a1,16(a5)
    80001dba:	6f90                	ld	a2,24(a5)
    80001dbc:	01073023          	sd	a6,0(a4)
    80001dc0:	e708                	sd	a0,8(a4)
    80001dc2:	eb0c                	sd	a1,16(a4)
    80001dc4:	ef10                	sd	a2,24(a4)
    80001dc6:	02078793          	add	a5,a5,32
    80001dca:	02070713          	add	a4,a4,32
    80001dce:	fed792e3          	bne	a5,a3,80001db2 <fork+0x56>
  np->trapframe->a0 = 0;
    80001dd2:	058a3783          	ld	a5,88(s4)
    80001dd6:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001dda:	0d0a8493          	add	s1,s5,208
    80001dde:	0d0a0913          	add	s2,s4,208
    80001de2:	150a8993          	add	s3,s5,336
    80001de6:	a00d                	j	80001e08 <fork+0xac>
    freeproc(np);
    80001de8:	8552                	mv	a0,s4
    80001dea:	00000097          	auipc	ra,0x0
    80001dee:	d6e080e7          	jalr	-658(ra) # 80001b58 <freeproc>
    release(&np->lock);
    80001df2:	8552                	mv	a0,s4
    80001df4:	fffff097          	auipc	ra,0xfffff
    80001df8:	e92080e7          	jalr	-366(ra) # 80000c86 <release>
    return -1;
    80001dfc:	597d                	li	s2,-1
    80001dfe:	a059                	j	80001e84 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001e00:	04a1                	add	s1,s1,8
    80001e02:	0921                	add	s2,s2,8
    80001e04:	01348b63          	beq	s1,s3,80001e1a <fork+0xbe>
    if(p->ofile[i])
    80001e08:	6088                	ld	a0,0(s1)
    80001e0a:	d97d                	beqz	a0,80001e00 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e0c:	00003097          	auipc	ra,0x3
    80001e10:	8c0080e7          	jalr	-1856(ra) # 800046cc <filedup>
    80001e14:	00a93023          	sd	a0,0(s2)
    80001e18:	b7e5                	j	80001e00 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001e1a:	150ab503          	ld	a0,336(s5)
    80001e1e:	00002097          	auipc	ra,0x2
    80001e22:	a56080e7          	jalr	-1450(ra) # 80003874 <idup>
    80001e26:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e2a:	4641                	li	a2,16
    80001e2c:	158a8593          	add	a1,s5,344
    80001e30:	158a0513          	add	a0,s4,344
    80001e34:	fffff097          	auipc	ra,0xfffff
    80001e38:	fe2080e7          	jalr	-30(ra) # 80000e16 <safestrcpy>
  pid = np->pid;
    80001e3c:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001e40:	8552                	mv	a0,s4
    80001e42:	fffff097          	auipc	ra,0xfffff
    80001e46:	e44080e7          	jalr	-444(ra) # 80000c86 <release>
  acquire(&wait_lock);
    80001e4a:	0000f497          	auipc	s1,0xf
    80001e4e:	dee48493          	add	s1,s1,-530 # 80010c38 <wait_lock>
    80001e52:	8526                	mv	a0,s1
    80001e54:	fffff097          	auipc	ra,0xfffff
    80001e58:	d7e080e7          	jalr	-642(ra) # 80000bd2 <acquire>
  np->parent = p;
    80001e5c:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001e60:	8526                	mv	a0,s1
    80001e62:	fffff097          	auipc	ra,0xfffff
    80001e66:	e24080e7          	jalr	-476(ra) # 80000c86 <release>
  acquire(&np->lock);
    80001e6a:	8552                	mv	a0,s4
    80001e6c:	fffff097          	auipc	ra,0xfffff
    80001e70:	d66080e7          	jalr	-666(ra) # 80000bd2 <acquire>
  np->state = RUNNABLE;
    80001e74:	478d                	li	a5,3
    80001e76:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001e7a:	8552                	mv	a0,s4
    80001e7c:	fffff097          	auipc	ra,0xfffff
    80001e80:	e0a080e7          	jalr	-502(ra) # 80000c86 <release>
}
    80001e84:	854a                	mv	a0,s2
    80001e86:	70e2                	ld	ra,56(sp)
    80001e88:	7442                	ld	s0,48(sp)
    80001e8a:	74a2                	ld	s1,40(sp)
    80001e8c:	7902                	ld	s2,32(sp)
    80001e8e:	69e2                	ld	s3,24(sp)
    80001e90:	6a42                	ld	s4,16(sp)
    80001e92:	6aa2                	ld	s5,8(sp)
    80001e94:	6121                	add	sp,sp,64
    80001e96:	8082                	ret
    return -1;
    80001e98:	597d                	li	s2,-1
    80001e9a:	b7ed                	j	80001e84 <fork+0x128>

0000000080001e9c <scheduler>:
{
    80001e9c:	7139                	add	sp,sp,-64
    80001e9e:	fc06                	sd	ra,56(sp)
    80001ea0:	f822                	sd	s0,48(sp)
    80001ea2:	f426                	sd	s1,40(sp)
    80001ea4:	f04a                	sd	s2,32(sp)
    80001ea6:	ec4e                	sd	s3,24(sp)
    80001ea8:	e852                	sd	s4,16(sp)
    80001eaa:	e456                	sd	s5,8(sp)
    80001eac:	e05a                	sd	s6,0(sp)
    80001eae:	0080                	add	s0,sp,64
    80001eb0:	8792                	mv	a5,tp
  int id = r_tp();
    80001eb2:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001eb4:	00779a93          	sll	s5,a5,0x7
    80001eb8:	0000f717          	auipc	a4,0xf
    80001ebc:	d6870713          	add	a4,a4,-664 # 80010c20 <pid_lock>
    80001ec0:	9756                	add	a4,a4,s5
    80001ec2:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001ec6:	0000f717          	auipc	a4,0xf
    80001eca:	d9270713          	add	a4,a4,-622 # 80010c58 <cpus+0x8>
    80001ece:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001ed0:	498d                	li	s3,3
        p->state = RUNNING;
    80001ed2:	4b11                	li	s6,4
        c->proc = p;
    80001ed4:	079e                	sll	a5,a5,0x7
    80001ed6:	0000fa17          	auipc	s4,0xf
    80001eda:	d4aa0a13          	add	s4,s4,-694 # 80010c20 <pid_lock>
    80001ede:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ee0:	00015917          	auipc	s2,0x15
    80001ee4:	b7090913          	add	s2,s2,-1168 # 80016a50 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ee8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001eec:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ef0:	10079073          	csrw	sstatus,a5
    80001ef4:	0000f497          	auipc	s1,0xf
    80001ef8:	15c48493          	add	s1,s1,348 # 80011050 <proc>
    80001efc:	a811                	j	80001f10 <scheduler+0x74>
      release(&p->lock);
    80001efe:	8526                	mv	a0,s1
    80001f00:	fffff097          	auipc	ra,0xfffff
    80001f04:	d86080e7          	jalr	-634(ra) # 80000c86 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f08:	16848493          	add	s1,s1,360
    80001f0c:	fd248ee3          	beq	s1,s2,80001ee8 <scheduler+0x4c>
      acquire(&p->lock);
    80001f10:	8526                	mv	a0,s1
    80001f12:	fffff097          	auipc	ra,0xfffff
    80001f16:	cc0080e7          	jalr	-832(ra) # 80000bd2 <acquire>
      if(p->state == RUNNABLE) {
    80001f1a:	4c9c                	lw	a5,24(s1)
    80001f1c:	ff3791e3          	bne	a5,s3,80001efe <scheduler+0x62>
        p->state = RUNNING;
    80001f20:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001f24:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001f28:	06048593          	add	a1,s1,96
    80001f2c:	8556                	mv	a0,s5
    80001f2e:	00000097          	auipc	ra,0x0
    80001f32:	684080e7          	jalr	1668(ra) # 800025b2 <swtch>
        c->proc = 0;
    80001f36:	020a3823          	sd	zero,48(s4)
    80001f3a:	b7d1                	j	80001efe <scheduler+0x62>

0000000080001f3c <sched>:
{
    80001f3c:	7179                	add	sp,sp,-48
    80001f3e:	f406                	sd	ra,40(sp)
    80001f40:	f022                	sd	s0,32(sp)
    80001f42:	ec26                	sd	s1,24(sp)
    80001f44:	e84a                	sd	s2,16(sp)
    80001f46:	e44e                	sd	s3,8(sp)
    80001f48:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80001f4a:	00000097          	auipc	ra,0x0
    80001f4e:	a5c080e7          	jalr	-1444(ra) # 800019a6 <myproc>
    80001f52:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001f54:	fffff097          	auipc	ra,0xfffff
    80001f58:	c04080e7          	jalr	-1020(ra) # 80000b58 <holding>
    80001f5c:	c93d                	beqz	a0,80001fd2 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f5e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001f60:	2781                	sext.w	a5,a5
    80001f62:	079e                	sll	a5,a5,0x7
    80001f64:	0000f717          	auipc	a4,0xf
    80001f68:	cbc70713          	add	a4,a4,-836 # 80010c20 <pid_lock>
    80001f6c:	97ba                	add	a5,a5,a4
    80001f6e:	0a87a703          	lw	a4,168(a5)
    80001f72:	4785                	li	a5,1
    80001f74:	06f71763          	bne	a4,a5,80001fe2 <sched+0xa6>
  if(p->state == RUNNING)
    80001f78:	4c98                	lw	a4,24(s1)
    80001f7a:	4791                	li	a5,4
    80001f7c:	06f70b63          	beq	a4,a5,80001ff2 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f80:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f84:	8b89                	and	a5,a5,2
  if(intr_get())
    80001f86:	efb5                	bnez	a5,80002002 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f88:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001f8a:	0000f917          	auipc	s2,0xf
    80001f8e:	c9690913          	add	s2,s2,-874 # 80010c20 <pid_lock>
    80001f92:	2781                	sext.w	a5,a5
    80001f94:	079e                	sll	a5,a5,0x7
    80001f96:	97ca                	add	a5,a5,s2
    80001f98:	0ac7a983          	lw	s3,172(a5)
    80001f9c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001f9e:	2781                	sext.w	a5,a5
    80001fa0:	079e                	sll	a5,a5,0x7
    80001fa2:	0000f597          	auipc	a1,0xf
    80001fa6:	cb658593          	add	a1,a1,-842 # 80010c58 <cpus+0x8>
    80001faa:	95be                	add	a1,a1,a5
    80001fac:	06048513          	add	a0,s1,96
    80001fb0:	00000097          	auipc	ra,0x0
    80001fb4:	602080e7          	jalr	1538(ra) # 800025b2 <swtch>
    80001fb8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001fba:	2781                	sext.w	a5,a5
    80001fbc:	079e                	sll	a5,a5,0x7
    80001fbe:	993e                	add	s2,s2,a5
    80001fc0:	0b392623          	sw	s3,172(s2)
}
    80001fc4:	70a2                	ld	ra,40(sp)
    80001fc6:	7402                	ld	s0,32(sp)
    80001fc8:	64e2                	ld	s1,24(sp)
    80001fca:	6942                	ld	s2,16(sp)
    80001fcc:	69a2                	ld	s3,8(sp)
    80001fce:	6145                	add	sp,sp,48
    80001fd0:	8082                	ret
    panic("sched p->lock");
    80001fd2:	00006517          	auipc	a0,0x6
    80001fd6:	25650513          	add	a0,a0,598 # 80008228 <digits+0x1e8>
    80001fda:	ffffe097          	auipc	ra,0xffffe
    80001fde:	562080e7          	jalr	1378(ra) # 8000053c <panic>
    panic("sched locks");
    80001fe2:	00006517          	auipc	a0,0x6
    80001fe6:	25650513          	add	a0,a0,598 # 80008238 <digits+0x1f8>
    80001fea:	ffffe097          	auipc	ra,0xffffe
    80001fee:	552080e7          	jalr	1362(ra) # 8000053c <panic>
    panic("sched running");
    80001ff2:	00006517          	auipc	a0,0x6
    80001ff6:	25650513          	add	a0,a0,598 # 80008248 <digits+0x208>
    80001ffa:	ffffe097          	auipc	ra,0xffffe
    80001ffe:	542080e7          	jalr	1346(ra) # 8000053c <panic>
    panic("sched interruptible");
    80002002:	00006517          	auipc	a0,0x6
    80002006:	25650513          	add	a0,a0,598 # 80008258 <digits+0x218>
    8000200a:	ffffe097          	auipc	ra,0xffffe
    8000200e:	532080e7          	jalr	1330(ra) # 8000053c <panic>

0000000080002012 <yield>:
{
    80002012:	1101                	add	sp,sp,-32
    80002014:	ec06                	sd	ra,24(sp)
    80002016:	e822                	sd	s0,16(sp)
    80002018:	e426                	sd	s1,8(sp)
    8000201a:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    8000201c:	00000097          	auipc	ra,0x0
    80002020:	98a080e7          	jalr	-1654(ra) # 800019a6 <myproc>
    80002024:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002026:	fffff097          	auipc	ra,0xfffff
    8000202a:	bac080e7          	jalr	-1108(ra) # 80000bd2 <acquire>
  p->state = RUNNABLE;
    8000202e:	478d                	li	a5,3
    80002030:	cc9c                	sw	a5,24(s1)
  sched();
    80002032:	00000097          	auipc	ra,0x0
    80002036:	f0a080e7          	jalr	-246(ra) # 80001f3c <sched>
  release(&p->lock);
    8000203a:	8526                	mv	a0,s1
    8000203c:	fffff097          	auipc	ra,0xfffff
    80002040:	c4a080e7          	jalr	-950(ra) # 80000c86 <release>
}
    80002044:	60e2                	ld	ra,24(sp)
    80002046:	6442                	ld	s0,16(sp)
    80002048:	64a2                	ld	s1,8(sp)
    8000204a:	6105                	add	sp,sp,32
    8000204c:	8082                	ret

000000008000204e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000204e:	7179                	add	sp,sp,-48
    80002050:	f406                	sd	ra,40(sp)
    80002052:	f022                	sd	s0,32(sp)
    80002054:	ec26                	sd	s1,24(sp)
    80002056:	e84a                	sd	s2,16(sp)
    80002058:	e44e                	sd	s3,8(sp)
    8000205a:	1800                	add	s0,sp,48
    8000205c:	89aa                	mv	s3,a0
    8000205e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002060:	00000097          	auipc	ra,0x0
    80002064:	946080e7          	jalr	-1722(ra) # 800019a6 <myproc>
    80002068:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000206a:	fffff097          	auipc	ra,0xfffff
    8000206e:	b68080e7          	jalr	-1176(ra) # 80000bd2 <acquire>
  release(lk);
    80002072:	854a                	mv	a0,s2
    80002074:	fffff097          	auipc	ra,0xfffff
    80002078:	c12080e7          	jalr	-1006(ra) # 80000c86 <release>

  // Go to sleep.
  p->chan = chan;
    8000207c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002080:	4789                	li	a5,2
    80002082:	cc9c                	sw	a5,24(s1)

  sched();
    80002084:	00000097          	auipc	ra,0x0
    80002088:	eb8080e7          	jalr	-328(ra) # 80001f3c <sched>

  // Tidy up.
  p->chan = 0;
    8000208c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002090:	8526                	mv	a0,s1
    80002092:	fffff097          	auipc	ra,0xfffff
    80002096:	bf4080e7          	jalr	-1036(ra) # 80000c86 <release>
  acquire(lk);
    8000209a:	854a                	mv	a0,s2
    8000209c:	fffff097          	auipc	ra,0xfffff
    800020a0:	b36080e7          	jalr	-1226(ra) # 80000bd2 <acquire>
}
    800020a4:	70a2                	ld	ra,40(sp)
    800020a6:	7402                	ld	s0,32(sp)
    800020a8:	64e2                	ld	s1,24(sp)
    800020aa:	6942                	ld	s2,16(sp)
    800020ac:	69a2                	ld	s3,8(sp)
    800020ae:	6145                	add	sp,sp,48
    800020b0:	8082                	ret

00000000800020b2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800020b2:	7139                	add	sp,sp,-64
    800020b4:	fc06                	sd	ra,56(sp)
    800020b6:	f822                	sd	s0,48(sp)
    800020b8:	f426                	sd	s1,40(sp)
    800020ba:	f04a                	sd	s2,32(sp)
    800020bc:	ec4e                	sd	s3,24(sp)
    800020be:	e852                	sd	s4,16(sp)
    800020c0:	e456                	sd	s5,8(sp)
    800020c2:	0080                	add	s0,sp,64
    800020c4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800020c6:	0000f497          	auipc	s1,0xf
    800020ca:	f8a48493          	add	s1,s1,-118 # 80011050 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800020ce:	4989                	li	s3,2
        p->state = RUNNABLE;
    800020d0:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800020d2:	00015917          	auipc	s2,0x15
    800020d6:	97e90913          	add	s2,s2,-1666 # 80016a50 <tickslock>
    800020da:	a811                	j	800020ee <wakeup+0x3c>
      }
      release(&p->lock);
    800020dc:	8526                	mv	a0,s1
    800020de:	fffff097          	auipc	ra,0xfffff
    800020e2:	ba8080e7          	jalr	-1112(ra) # 80000c86 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800020e6:	16848493          	add	s1,s1,360
    800020ea:	03248663          	beq	s1,s2,80002116 <wakeup+0x64>
    if(p != myproc()){
    800020ee:	00000097          	auipc	ra,0x0
    800020f2:	8b8080e7          	jalr	-1864(ra) # 800019a6 <myproc>
    800020f6:	fea488e3          	beq	s1,a0,800020e6 <wakeup+0x34>
      acquire(&p->lock);
    800020fa:	8526                	mv	a0,s1
    800020fc:	fffff097          	auipc	ra,0xfffff
    80002100:	ad6080e7          	jalr	-1322(ra) # 80000bd2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002104:	4c9c                	lw	a5,24(s1)
    80002106:	fd379be3          	bne	a5,s3,800020dc <wakeup+0x2a>
    8000210a:	709c                	ld	a5,32(s1)
    8000210c:	fd4798e3          	bne	a5,s4,800020dc <wakeup+0x2a>
        p->state = RUNNABLE;
    80002110:	0154ac23          	sw	s5,24(s1)
    80002114:	b7e1                	j	800020dc <wakeup+0x2a>
    }
  }
}
    80002116:	70e2                	ld	ra,56(sp)
    80002118:	7442                	ld	s0,48(sp)
    8000211a:	74a2                	ld	s1,40(sp)
    8000211c:	7902                	ld	s2,32(sp)
    8000211e:	69e2                	ld	s3,24(sp)
    80002120:	6a42                	ld	s4,16(sp)
    80002122:	6aa2                	ld	s5,8(sp)
    80002124:	6121                	add	sp,sp,64
    80002126:	8082                	ret

0000000080002128 <reparent>:
{
    80002128:	7179                	add	sp,sp,-48
    8000212a:	f406                	sd	ra,40(sp)
    8000212c:	f022                	sd	s0,32(sp)
    8000212e:	ec26                	sd	s1,24(sp)
    80002130:	e84a                	sd	s2,16(sp)
    80002132:	e44e                	sd	s3,8(sp)
    80002134:	e052                	sd	s4,0(sp)
    80002136:	1800                	add	s0,sp,48
    80002138:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000213a:	0000f497          	auipc	s1,0xf
    8000213e:	f1648493          	add	s1,s1,-234 # 80011050 <proc>
      pp->parent = initproc;
    80002142:	00007a17          	auipc	s4,0x7
    80002146:	866a0a13          	add	s4,s4,-1946 # 800089a8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000214a:	00015997          	auipc	s3,0x15
    8000214e:	90698993          	add	s3,s3,-1786 # 80016a50 <tickslock>
    80002152:	a029                	j	8000215c <reparent+0x34>
    80002154:	16848493          	add	s1,s1,360
    80002158:	01348d63          	beq	s1,s3,80002172 <reparent+0x4a>
    if(pp->parent == p){
    8000215c:	7c9c                	ld	a5,56(s1)
    8000215e:	ff279be3          	bne	a5,s2,80002154 <reparent+0x2c>
      pp->parent = initproc;
    80002162:	000a3503          	ld	a0,0(s4)
    80002166:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002168:	00000097          	auipc	ra,0x0
    8000216c:	f4a080e7          	jalr	-182(ra) # 800020b2 <wakeup>
    80002170:	b7d5                	j	80002154 <reparent+0x2c>
}
    80002172:	70a2                	ld	ra,40(sp)
    80002174:	7402                	ld	s0,32(sp)
    80002176:	64e2                	ld	s1,24(sp)
    80002178:	6942                	ld	s2,16(sp)
    8000217a:	69a2                	ld	s3,8(sp)
    8000217c:	6a02                	ld	s4,0(sp)
    8000217e:	6145                	add	sp,sp,48
    80002180:	8082                	ret

0000000080002182 <exit>:
{
    80002182:	7179                	add	sp,sp,-48
    80002184:	f406                	sd	ra,40(sp)
    80002186:	f022                	sd	s0,32(sp)
    80002188:	ec26                	sd	s1,24(sp)
    8000218a:	e84a                	sd	s2,16(sp)
    8000218c:	e44e                	sd	s3,8(sp)
    8000218e:	e052                	sd	s4,0(sp)
    80002190:	1800                	add	s0,sp,48
    80002192:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002194:	00000097          	auipc	ra,0x0
    80002198:	812080e7          	jalr	-2030(ra) # 800019a6 <myproc>
    8000219c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000219e:	00007797          	auipc	a5,0x7
    800021a2:	80a7b783          	ld	a5,-2038(a5) # 800089a8 <initproc>
    800021a6:	0d050493          	add	s1,a0,208
    800021aa:	15050913          	add	s2,a0,336
    800021ae:	02a79363          	bne	a5,a0,800021d4 <exit+0x52>
    panic("init exiting");
    800021b2:	00006517          	auipc	a0,0x6
    800021b6:	0be50513          	add	a0,a0,190 # 80008270 <digits+0x230>
    800021ba:	ffffe097          	auipc	ra,0xffffe
    800021be:	382080e7          	jalr	898(ra) # 8000053c <panic>
      fileclose(f);
    800021c2:	00002097          	auipc	ra,0x2
    800021c6:	55c080e7          	jalr	1372(ra) # 8000471e <fileclose>
      p->ofile[fd] = 0;
    800021ca:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800021ce:	04a1                	add	s1,s1,8
    800021d0:	01248563          	beq	s1,s2,800021da <exit+0x58>
    if(p->ofile[fd]){
    800021d4:	6088                	ld	a0,0(s1)
    800021d6:	f575                	bnez	a0,800021c2 <exit+0x40>
    800021d8:	bfdd                	j	800021ce <exit+0x4c>
  begin_op();
    800021da:	00002097          	auipc	ra,0x2
    800021de:	080080e7          	jalr	128(ra) # 8000425a <begin_op>
  iput(p->cwd);
    800021e2:	1509b503          	ld	a0,336(s3)
    800021e6:	00002097          	auipc	ra,0x2
    800021ea:	886080e7          	jalr	-1914(ra) # 80003a6c <iput>
  end_op();
    800021ee:	00002097          	auipc	ra,0x2
    800021f2:	0e6080e7          	jalr	230(ra) # 800042d4 <end_op>
  p->cwd = 0;
    800021f6:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800021fa:	0000f497          	auipc	s1,0xf
    800021fe:	a3e48493          	add	s1,s1,-1474 # 80010c38 <wait_lock>
    80002202:	8526                	mv	a0,s1
    80002204:	fffff097          	auipc	ra,0xfffff
    80002208:	9ce080e7          	jalr	-1586(ra) # 80000bd2 <acquire>
  reparent(p);
    8000220c:	854e                	mv	a0,s3
    8000220e:	00000097          	auipc	ra,0x0
    80002212:	f1a080e7          	jalr	-230(ra) # 80002128 <reparent>
  wakeup(p->parent);
    80002216:	0389b503          	ld	a0,56(s3)
    8000221a:	00000097          	auipc	ra,0x0
    8000221e:	e98080e7          	jalr	-360(ra) # 800020b2 <wakeup>
  acquire(&p->lock);
    80002222:	854e                	mv	a0,s3
    80002224:	fffff097          	auipc	ra,0xfffff
    80002228:	9ae080e7          	jalr	-1618(ra) # 80000bd2 <acquire>
  p->xstate = status;
    8000222c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002230:	4795                	li	a5,5
    80002232:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002236:	8526                	mv	a0,s1
    80002238:	fffff097          	auipc	ra,0xfffff
    8000223c:	a4e080e7          	jalr	-1458(ra) # 80000c86 <release>
  sched();
    80002240:	00000097          	auipc	ra,0x0
    80002244:	cfc080e7          	jalr	-772(ra) # 80001f3c <sched>
  panic("zombie exit");
    80002248:	00006517          	auipc	a0,0x6
    8000224c:	03850513          	add	a0,a0,56 # 80008280 <digits+0x240>
    80002250:	ffffe097          	auipc	ra,0xffffe
    80002254:	2ec080e7          	jalr	748(ra) # 8000053c <panic>

0000000080002258 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002258:	7179                	add	sp,sp,-48
    8000225a:	f406                	sd	ra,40(sp)
    8000225c:	f022                	sd	s0,32(sp)
    8000225e:	ec26                	sd	s1,24(sp)
    80002260:	e84a                	sd	s2,16(sp)
    80002262:	e44e                	sd	s3,8(sp)
    80002264:	1800                	add	s0,sp,48
    80002266:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002268:	0000f497          	auipc	s1,0xf
    8000226c:	de848493          	add	s1,s1,-536 # 80011050 <proc>
    80002270:	00014997          	auipc	s3,0x14
    80002274:	7e098993          	add	s3,s3,2016 # 80016a50 <tickslock>
    acquire(&p->lock);
    80002278:	8526                	mv	a0,s1
    8000227a:	fffff097          	auipc	ra,0xfffff
    8000227e:	958080e7          	jalr	-1704(ra) # 80000bd2 <acquire>
    if(p->pid == pid){
    80002282:	589c                	lw	a5,48(s1)
    80002284:	01278d63          	beq	a5,s2,8000229e <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002288:	8526                	mv	a0,s1
    8000228a:	fffff097          	auipc	ra,0xfffff
    8000228e:	9fc080e7          	jalr	-1540(ra) # 80000c86 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002292:	16848493          	add	s1,s1,360
    80002296:	ff3491e3          	bne	s1,s3,80002278 <kill+0x20>
  }
  return -1;
    8000229a:	557d                	li	a0,-1
    8000229c:	a829                	j	800022b6 <kill+0x5e>
      p->killed = 1;
    8000229e:	4785                	li	a5,1
    800022a0:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800022a2:	4c98                	lw	a4,24(s1)
    800022a4:	4789                	li	a5,2
    800022a6:	00f70f63          	beq	a4,a5,800022c4 <kill+0x6c>
      release(&p->lock);
    800022aa:	8526                	mv	a0,s1
    800022ac:	fffff097          	auipc	ra,0xfffff
    800022b0:	9da080e7          	jalr	-1574(ra) # 80000c86 <release>
      return 0;
    800022b4:	4501                	li	a0,0
}
    800022b6:	70a2                	ld	ra,40(sp)
    800022b8:	7402                	ld	s0,32(sp)
    800022ba:	64e2                	ld	s1,24(sp)
    800022bc:	6942                	ld	s2,16(sp)
    800022be:	69a2                	ld	s3,8(sp)
    800022c0:	6145                	add	sp,sp,48
    800022c2:	8082                	ret
        p->state = RUNNABLE;
    800022c4:	478d                	li	a5,3
    800022c6:	cc9c                	sw	a5,24(s1)
    800022c8:	b7cd                	j	800022aa <kill+0x52>

00000000800022ca <setkilled>:

void
setkilled(struct proc *p)
{
    800022ca:	1101                	add	sp,sp,-32
    800022cc:	ec06                	sd	ra,24(sp)
    800022ce:	e822                	sd	s0,16(sp)
    800022d0:	e426                	sd	s1,8(sp)
    800022d2:	1000                	add	s0,sp,32
    800022d4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800022d6:	fffff097          	auipc	ra,0xfffff
    800022da:	8fc080e7          	jalr	-1796(ra) # 80000bd2 <acquire>
  p->killed = 1;
    800022de:	4785                	li	a5,1
    800022e0:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800022e2:	8526                	mv	a0,s1
    800022e4:	fffff097          	auipc	ra,0xfffff
    800022e8:	9a2080e7          	jalr	-1630(ra) # 80000c86 <release>
}
    800022ec:	60e2                	ld	ra,24(sp)
    800022ee:	6442                	ld	s0,16(sp)
    800022f0:	64a2                	ld	s1,8(sp)
    800022f2:	6105                	add	sp,sp,32
    800022f4:	8082                	ret

00000000800022f6 <killed>:

int
killed(struct proc *p)
{
    800022f6:	1101                	add	sp,sp,-32
    800022f8:	ec06                	sd	ra,24(sp)
    800022fa:	e822                	sd	s0,16(sp)
    800022fc:	e426                	sd	s1,8(sp)
    800022fe:	e04a                	sd	s2,0(sp)
    80002300:	1000                	add	s0,sp,32
    80002302:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002304:	fffff097          	auipc	ra,0xfffff
    80002308:	8ce080e7          	jalr	-1842(ra) # 80000bd2 <acquire>
  k = p->killed;
    8000230c:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002310:	8526                	mv	a0,s1
    80002312:	fffff097          	auipc	ra,0xfffff
    80002316:	974080e7          	jalr	-1676(ra) # 80000c86 <release>
  return k;
}
    8000231a:	854a                	mv	a0,s2
    8000231c:	60e2                	ld	ra,24(sp)
    8000231e:	6442                	ld	s0,16(sp)
    80002320:	64a2                	ld	s1,8(sp)
    80002322:	6902                	ld	s2,0(sp)
    80002324:	6105                	add	sp,sp,32
    80002326:	8082                	ret

0000000080002328 <wait>:
{
    80002328:	715d                	add	sp,sp,-80
    8000232a:	e486                	sd	ra,72(sp)
    8000232c:	e0a2                	sd	s0,64(sp)
    8000232e:	fc26                	sd	s1,56(sp)
    80002330:	f84a                	sd	s2,48(sp)
    80002332:	f44e                	sd	s3,40(sp)
    80002334:	f052                	sd	s4,32(sp)
    80002336:	ec56                	sd	s5,24(sp)
    80002338:	e85a                	sd	s6,16(sp)
    8000233a:	e45e                	sd	s7,8(sp)
    8000233c:	e062                	sd	s8,0(sp)
    8000233e:	0880                	add	s0,sp,80
    80002340:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002342:	fffff097          	auipc	ra,0xfffff
    80002346:	664080e7          	jalr	1636(ra) # 800019a6 <myproc>
    8000234a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000234c:	0000f517          	auipc	a0,0xf
    80002350:	8ec50513          	add	a0,a0,-1812 # 80010c38 <wait_lock>
    80002354:	fffff097          	auipc	ra,0xfffff
    80002358:	87e080e7          	jalr	-1922(ra) # 80000bd2 <acquire>
    havekids = 0;
    8000235c:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000235e:	4a15                	li	s4,5
        havekids = 1;
    80002360:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002362:	00014997          	auipc	s3,0x14
    80002366:	6ee98993          	add	s3,s3,1774 # 80016a50 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000236a:	0000fc17          	auipc	s8,0xf
    8000236e:	8cec0c13          	add	s8,s8,-1842 # 80010c38 <wait_lock>
    80002372:	a0d1                	j	80002436 <wait+0x10e>
          pid = pp->pid;
    80002374:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002378:	000b0e63          	beqz	s6,80002394 <wait+0x6c>
    8000237c:	4691                	li	a3,4
    8000237e:	02c48613          	add	a2,s1,44
    80002382:	85da                	mv	a1,s6
    80002384:	05093503          	ld	a0,80(s2)
    80002388:	fffff097          	auipc	ra,0xfffff
    8000238c:	2de080e7          	jalr	734(ra) # 80001666 <copyout>
    80002390:	04054163          	bltz	a0,800023d2 <wait+0xaa>
          freeproc(pp);
    80002394:	8526                	mv	a0,s1
    80002396:	fffff097          	auipc	ra,0xfffff
    8000239a:	7c2080e7          	jalr	1986(ra) # 80001b58 <freeproc>
          release(&pp->lock);
    8000239e:	8526                	mv	a0,s1
    800023a0:	fffff097          	auipc	ra,0xfffff
    800023a4:	8e6080e7          	jalr	-1818(ra) # 80000c86 <release>
          release(&wait_lock);
    800023a8:	0000f517          	auipc	a0,0xf
    800023ac:	89050513          	add	a0,a0,-1904 # 80010c38 <wait_lock>
    800023b0:	fffff097          	auipc	ra,0xfffff
    800023b4:	8d6080e7          	jalr	-1834(ra) # 80000c86 <release>
}
    800023b8:	854e                	mv	a0,s3
    800023ba:	60a6                	ld	ra,72(sp)
    800023bc:	6406                	ld	s0,64(sp)
    800023be:	74e2                	ld	s1,56(sp)
    800023c0:	7942                	ld	s2,48(sp)
    800023c2:	79a2                	ld	s3,40(sp)
    800023c4:	7a02                	ld	s4,32(sp)
    800023c6:	6ae2                	ld	s5,24(sp)
    800023c8:	6b42                	ld	s6,16(sp)
    800023ca:	6ba2                	ld	s7,8(sp)
    800023cc:	6c02                	ld	s8,0(sp)
    800023ce:	6161                	add	sp,sp,80
    800023d0:	8082                	ret
            release(&pp->lock);
    800023d2:	8526                	mv	a0,s1
    800023d4:	fffff097          	auipc	ra,0xfffff
    800023d8:	8b2080e7          	jalr	-1870(ra) # 80000c86 <release>
            release(&wait_lock);
    800023dc:	0000f517          	auipc	a0,0xf
    800023e0:	85c50513          	add	a0,a0,-1956 # 80010c38 <wait_lock>
    800023e4:	fffff097          	auipc	ra,0xfffff
    800023e8:	8a2080e7          	jalr	-1886(ra) # 80000c86 <release>
            return -1;
    800023ec:	59fd                	li	s3,-1
    800023ee:	b7e9                	j	800023b8 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800023f0:	16848493          	add	s1,s1,360
    800023f4:	03348463          	beq	s1,s3,8000241c <wait+0xf4>
      if(pp->parent == p){
    800023f8:	7c9c                	ld	a5,56(s1)
    800023fa:	ff279be3          	bne	a5,s2,800023f0 <wait+0xc8>
        acquire(&pp->lock);
    800023fe:	8526                	mv	a0,s1
    80002400:	ffffe097          	auipc	ra,0xffffe
    80002404:	7d2080e7          	jalr	2002(ra) # 80000bd2 <acquire>
        if(pp->state == ZOMBIE){
    80002408:	4c9c                	lw	a5,24(s1)
    8000240a:	f74785e3          	beq	a5,s4,80002374 <wait+0x4c>
        release(&pp->lock);
    8000240e:	8526                	mv	a0,s1
    80002410:	fffff097          	auipc	ra,0xfffff
    80002414:	876080e7          	jalr	-1930(ra) # 80000c86 <release>
        havekids = 1;
    80002418:	8756                	mv	a4,s5
    8000241a:	bfd9                	j	800023f0 <wait+0xc8>
    if(!havekids || killed(p)){
    8000241c:	c31d                	beqz	a4,80002442 <wait+0x11a>
    8000241e:	854a                	mv	a0,s2
    80002420:	00000097          	auipc	ra,0x0
    80002424:	ed6080e7          	jalr	-298(ra) # 800022f6 <killed>
    80002428:	ed09                	bnez	a0,80002442 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000242a:	85e2                	mv	a1,s8
    8000242c:	854a                	mv	a0,s2
    8000242e:	00000097          	auipc	ra,0x0
    80002432:	c20080e7          	jalr	-992(ra) # 8000204e <sleep>
    havekids = 0;
    80002436:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002438:	0000f497          	auipc	s1,0xf
    8000243c:	c1848493          	add	s1,s1,-1000 # 80011050 <proc>
    80002440:	bf65                	j	800023f8 <wait+0xd0>
      release(&wait_lock);
    80002442:	0000e517          	auipc	a0,0xe
    80002446:	7f650513          	add	a0,a0,2038 # 80010c38 <wait_lock>
    8000244a:	fffff097          	auipc	ra,0xfffff
    8000244e:	83c080e7          	jalr	-1988(ra) # 80000c86 <release>
      return -1;
    80002452:	59fd                	li	s3,-1
    80002454:	b795                	j	800023b8 <wait+0x90>

0000000080002456 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002456:	7179                	add	sp,sp,-48
    80002458:	f406                	sd	ra,40(sp)
    8000245a:	f022                	sd	s0,32(sp)
    8000245c:	ec26                	sd	s1,24(sp)
    8000245e:	e84a                	sd	s2,16(sp)
    80002460:	e44e                	sd	s3,8(sp)
    80002462:	e052                	sd	s4,0(sp)
    80002464:	1800                	add	s0,sp,48
    80002466:	84aa                	mv	s1,a0
    80002468:	892e                	mv	s2,a1
    8000246a:	89b2                	mv	s3,a2
    8000246c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000246e:	fffff097          	auipc	ra,0xfffff
    80002472:	538080e7          	jalr	1336(ra) # 800019a6 <myproc>
  if(user_dst){
    80002476:	c08d                	beqz	s1,80002498 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002478:	86d2                	mv	a3,s4
    8000247a:	864e                	mv	a2,s3
    8000247c:	85ca                	mv	a1,s2
    8000247e:	6928                	ld	a0,80(a0)
    80002480:	fffff097          	auipc	ra,0xfffff
    80002484:	1e6080e7          	jalr	486(ra) # 80001666 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002488:	70a2                	ld	ra,40(sp)
    8000248a:	7402                	ld	s0,32(sp)
    8000248c:	64e2                	ld	s1,24(sp)
    8000248e:	6942                	ld	s2,16(sp)
    80002490:	69a2                	ld	s3,8(sp)
    80002492:	6a02                	ld	s4,0(sp)
    80002494:	6145                	add	sp,sp,48
    80002496:	8082                	ret
    memmove((char *)dst, src, len);
    80002498:	000a061b          	sext.w	a2,s4
    8000249c:	85ce                	mv	a1,s3
    8000249e:	854a                	mv	a0,s2
    800024a0:	fffff097          	auipc	ra,0xfffff
    800024a4:	88a080e7          	jalr	-1910(ra) # 80000d2a <memmove>
    return 0;
    800024a8:	8526                	mv	a0,s1
    800024aa:	bff9                	j	80002488 <either_copyout+0x32>

00000000800024ac <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800024ac:	7179                	add	sp,sp,-48
    800024ae:	f406                	sd	ra,40(sp)
    800024b0:	f022                	sd	s0,32(sp)
    800024b2:	ec26                	sd	s1,24(sp)
    800024b4:	e84a                	sd	s2,16(sp)
    800024b6:	e44e                	sd	s3,8(sp)
    800024b8:	e052                	sd	s4,0(sp)
    800024ba:	1800                	add	s0,sp,48
    800024bc:	892a                	mv	s2,a0
    800024be:	84ae                	mv	s1,a1
    800024c0:	89b2                	mv	s3,a2
    800024c2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024c4:	fffff097          	auipc	ra,0xfffff
    800024c8:	4e2080e7          	jalr	1250(ra) # 800019a6 <myproc>
  if(user_src){
    800024cc:	c08d                	beqz	s1,800024ee <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800024ce:	86d2                	mv	a3,s4
    800024d0:	864e                	mv	a2,s3
    800024d2:	85ca                	mv	a1,s2
    800024d4:	6928                	ld	a0,80(a0)
    800024d6:	fffff097          	auipc	ra,0xfffff
    800024da:	21c080e7          	jalr	540(ra) # 800016f2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800024de:	70a2                	ld	ra,40(sp)
    800024e0:	7402                	ld	s0,32(sp)
    800024e2:	64e2                	ld	s1,24(sp)
    800024e4:	6942                	ld	s2,16(sp)
    800024e6:	69a2                	ld	s3,8(sp)
    800024e8:	6a02                	ld	s4,0(sp)
    800024ea:	6145                	add	sp,sp,48
    800024ec:	8082                	ret
    memmove(dst, (char*)src, len);
    800024ee:	000a061b          	sext.w	a2,s4
    800024f2:	85ce                	mv	a1,s3
    800024f4:	854a                	mv	a0,s2
    800024f6:	fffff097          	auipc	ra,0xfffff
    800024fa:	834080e7          	jalr	-1996(ra) # 80000d2a <memmove>
    return 0;
    800024fe:	8526                	mv	a0,s1
    80002500:	bff9                	j	800024de <either_copyin+0x32>

0000000080002502 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002502:	715d                	add	sp,sp,-80
    80002504:	e486                	sd	ra,72(sp)
    80002506:	e0a2                	sd	s0,64(sp)
    80002508:	fc26                	sd	s1,56(sp)
    8000250a:	f84a                	sd	s2,48(sp)
    8000250c:	f44e                	sd	s3,40(sp)
    8000250e:	f052                	sd	s4,32(sp)
    80002510:	ec56                	sd	s5,24(sp)
    80002512:	e85a                	sd	s6,16(sp)
    80002514:	e45e                	sd	s7,8(sp)
    80002516:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002518:	00006517          	auipc	a0,0x6
    8000251c:	bc050513          	add	a0,a0,-1088 # 800080d8 <digits+0x98>
    80002520:	ffffe097          	auipc	ra,0xffffe
    80002524:	066080e7          	jalr	102(ra) # 80000586 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002528:	0000f497          	auipc	s1,0xf
    8000252c:	c8048493          	add	s1,s1,-896 # 800111a8 <proc+0x158>
    80002530:	00014917          	auipc	s2,0x14
    80002534:	67890913          	add	s2,s2,1656 # 80016ba8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002538:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000253a:	00006997          	auipc	s3,0x6
    8000253e:	d5698993          	add	s3,s3,-682 # 80008290 <digits+0x250>
    printf("%d %s %s", p->pid, state, p->name);
    80002542:	00006a97          	auipc	s5,0x6
    80002546:	d56a8a93          	add	s5,s5,-682 # 80008298 <digits+0x258>
    printf("\n");
    8000254a:	00006a17          	auipc	s4,0x6
    8000254e:	b8ea0a13          	add	s4,s4,-1138 # 800080d8 <digits+0x98>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002552:	00006b97          	auipc	s7,0x6
    80002556:	d86b8b93          	add	s7,s7,-634 # 800082d8 <states.0>
    8000255a:	a00d                	j	8000257c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000255c:	ed86a583          	lw	a1,-296(a3)
    80002560:	8556                	mv	a0,s5
    80002562:	ffffe097          	auipc	ra,0xffffe
    80002566:	024080e7          	jalr	36(ra) # 80000586 <printf>
    printf("\n");
    8000256a:	8552                	mv	a0,s4
    8000256c:	ffffe097          	auipc	ra,0xffffe
    80002570:	01a080e7          	jalr	26(ra) # 80000586 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002574:	16848493          	add	s1,s1,360
    80002578:	03248263          	beq	s1,s2,8000259c <procdump+0x9a>
    if(p->state == UNUSED)
    8000257c:	86a6                	mv	a3,s1
    8000257e:	ec04a783          	lw	a5,-320(s1)
    80002582:	dbed                	beqz	a5,80002574 <procdump+0x72>
      state = "???";
    80002584:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002586:	fcfb6be3          	bltu	s6,a5,8000255c <procdump+0x5a>
    8000258a:	02079713          	sll	a4,a5,0x20
    8000258e:	01d75793          	srl	a5,a4,0x1d
    80002592:	97de                	add	a5,a5,s7
    80002594:	6390                	ld	a2,0(a5)
    80002596:	f279                	bnez	a2,8000255c <procdump+0x5a>
      state = "???";
    80002598:	864e                	mv	a2,s3
    8000259a:	b7c9                	j	8000255c <procdump+0x5a>
  }
}
    8000259c:	60a6                	ld	ra,72(sp)
    8000259e:	6406                	ld	s0,64(sp)
    800025a0:	74e2                	ld	s1,56(sp)
    800025a2:	7942                	ld	s2,48(sp)
    800025a4:	79a2                	ld	s3,40(sp)
    800025a6:	7a02                	ld	s4,32(sp)
    800025a8:	6ae2                	ld	s5,24(sp)
    800025aa:	6b42                	ld	s6,16(sp)
    800025ac:	6ba2                	ld	s7,8(sp)
    800025ae:	6161                	add	sp,sp,80
    800025b0:	8082                	ret

00000000800025b2 <swtch>:
    800025b2:	00153023          	sd	ra,0(a0)
    800025b6:	00253423          	sd	sp,8(a0)
    800025ba:	e900                	sd	s0,16(a0)
    800025bc:	ed04                	sd	s1,24(a0)
    800025be:	03253023          	sd	s2,32(a0)
    800025c2:	03353423          	sd	s3,40(a0)
    800025c6:	03453823          	sd	s4,48(a0)
    800025ca:	03553c23          	sd	s5,56(a0)
    800025ce:	05653023          	sd	s6,64(a0)
    800025d2:	05753423          	sd	s7,72(a0)
    800025d6:	05853823          	sd	s8,80(a0)
    800025da:	05953c23          	sd	s9,88(a0)
    800025de:	07a53023          	sd	s10,96(a0)
    800025e2:	07b53423          	sd	s11,104(a0)
    800025e6:	0005b083          	ld	ra,0(a1)
    800025ea:	0085b103          	ld	sp,8(a1)
    800025ee:	6980                	ld	s0,16(a1)
    800025f0:	6d84                	ld	s1,24(a1)
    800025f2:	0205b903          	ld	s2,32(a1)
    800025f6:	0285b983          	ld	s3,40(a1)
    800025fa:	0305ba03          	ld	s4,48(a1)
    800025fe:	0385ba83          	ld	s5,56(a1)
    80002602:	0405bb03          	ld	s6,64(a1)
    80002606:	0485bb83          	ld	s7,72(a1)
    8000260a:	0505bc03          	ld	s8,80(a1)
    8000260e:	0585bc83          	ld	s9,88(a1)
    80002612:	0605bd03          	ld	s10,96(a1)
    80002616:	0685bd83          	ld	s11,104(a1)
    8000261a:	8082                	ret

000000008000261c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000261c:	1141                	add	sp,sp,-16
    8000261e:	e406                	sd	ra,8(sp)
    80002620:	e022                	sd	s0,0(sp)
    80002622:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80002624:	00006597          	auipc	a1,0x6
    80002628:	ce458593          	add	a1,a1,-796 # 80008308 <states.0+0x30>
    8000262c:	00014517          	auipc	a0,0x14
    80002630:	42450513          	add	a0,a0,1060 # 80016a50 <tickslock>
    80002634:	ffffe097          	auipc	ra,0xffffe
    80002638:	50e080e7          	jalr	1294(ra) # 80000b42 <initlock>
}
    8000263c:	60a2                	ld	ra,8(sp)
    8000263e:	6402                	ld	s0,0(sp)
    80002640:	0141                	add	sp,sp,16
    80002642:	8082                	ret

0000000080002644 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002644:	1141                	add	sp,sp,-16
    80002646:	e422                	sd	s0,8(sp)
    80002648:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000264a:	00003797          	auipc	a5,0x3
    8000264e:	6f678793          	add	a5,a5,1782 # 80005d40 <kernelvec>
    80002652:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002656:	6422                	ld	s0,8(sp)
    80002658:	0141                	add	sp,sp,16
    8000265a:	8082                	ret

000000008000265c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000265c:	1141                	add	sp,sp,-16
    8000265e:	e406                	sd	ra,8(sp)
    80002660:	e022                	sd	s0,0(sp)
    80002662:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80002664:	fffff097          	auipc	ra,0xfffff
    80002668:	342080e7          	jalr	834(ra) # 800019a6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000266c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002670:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002672:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002676:	00005697          	auipc	a3,0x5
    8000267a:	98a68693          	add	a3,a3,-1654 # 80007000 <_trampoline>
    8000267e:	00005717          	auipc	a4,0x5
    80002682:	98270713          	add	a4,a4,-1662 # 80007000 <_trampoline>
    80002686:	8f15                	sub	a4,a4,a3
    80002688:	040007b7          	lui	a5,0x4000
    8000268c:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000268e:	07b2                	sll	a5,a5,0xc
    80002690:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002692:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002696:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002698:	18002673          	csrr	a2,satp
    8000269c:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000269e:	6d30                	ld	a2,88(a0)
    800026a0:	6138                	ld	a4,64(a0)
    800026a2:	6585                	lui	a1,0x1
    800026a4:	972e                	add	a4,a4,a1
    800026a6:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800026a8:	6d38                	ld	a4,88(a0)
    800026aa:	00000617          	auipc	a2,0x0
    800026ae:	13460613          	add	a2,a2,308 # 800027de <usertrap>
    800026b2:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800026b4:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800026b6:	8612                	mv	a2,tp
    800026b8:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026ba:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800026be:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800026c2:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026c6:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800026ca:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026cc:	6f18                	ld	a4,24(a4)
    800026ce:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800026d2:	6928                	ld	a0,80(a0)
    800026d4:	8131                	srl	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800026d6:	00005717          	auipc	a4,0x5
    800026da:	9c670713          	add	a4,a4,-1594 # 8000709c <userret>
    800026de:	8f15                	sub	a4,a4,a3
    800026e0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800026e2:	577d                	li	a4,-1
    800026e4:	177e                	sll	a4,a4,0x3f
    800026e6:	8d59                	or	a0,a0,a4
    800026e8:	9782                	jalr	a5
}
    800026ea:	60a2                	ld	ra,8(sp)
    800026ec:	6402                	ld	s0,0(sp)
    800026ee:	0141                	add	sp,sp,16
    800026f0:	8082                	ret

00000000800026f2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800026f2:	1101                	add	sp,sp,-32
    800026f4:	ec06                	sd	ra,24(sp)
    800026f6:	e822                	sd	s0,16(sp)
    800026f8:	e426                	sd	s1,8(sp)
    800026fa:	1000                	add	s0,sp,32
  acquire(&tickslock);
    800026fc:	00014497          	auipc	s1,0x14
    80002700:	35448493          	add	s1,s1,852 # 80016a50 <tickslock>
    80002704:	8526                	mv	a0,s1
    80002706:	ffffe097          	auipc	ra,0xffffe
    8000270a:	4cc080e7          	jalr	1228(ra) # 80000bd2 <acquire>
  ticks++;
    8000270e:	00006517          	auipc	a0,0x6
    80002712:	2a250513          	add	a0,a0,674 # 800089b0 <ticks>
    80002716:	411c                	lw	a5,0(a0)
    80002718:	2785                	addw	a5,a5,1
    8000271a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    8000271c:	00000097          	auipc	ra,0x0
    80002720:	996080e7          	jalr	-1642(ra) # 800020b2 <wakeup>
  release(&tickslock);
    80002724:	8526                	mv	a0,s1
    80002726:	ffffe097          	auipc	ra,0xffffe
    8000272a:	560080e7          	jalr	1376(ra) # 80000c86 <release>
}
    8000272e:	60e2                	ld	ra,24(sp)
    80002730:	6442                	ld	s0,16(sp)
    80002732:	64a2                	ld	s1,8(sp)
    80002734:	6105                	add	sp,sp,32
    80002736:	8082                	ret

0000000080002738 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002738:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    8000273c:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    8000273e:	0807df63          	bgez	a5,800027dc <devintr+0xa4>
{
    80002742:	1101                	add	sp,sp,-32
    80002744:	ec06                	sd	ra,24(sp)
    80002746:	e822                	sd	s0,16(sp)
    80002748:	e426                	sd	s1,8(sp)
    8000274a:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    8000274c:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80002750:	46a5                	li	a3,9
    80002752:	00d70d63          	beq	a4,a3,8000276c <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80002756:	577d                	li	a4,-1
    80002758:	177e                	sll	a4,a4,0x3f
    8000275a:	0705                	add	a4,a4,1
    return 0;
    8000275c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    8000275e:	04e78e63          	beq	a5,a4,800027ba <devintr+0x82>
  }
}
    80002762:	60e2                	ld	ra,24(sp)
    80002764:	6442                	ld	s0,16(sp)
    80002766:	64a2                	ld	s1,8(sp)
    80002768:	6105                	add	sp,sp,32
    8000276a:	8082                	ret
    int irq = plic_claim();
    8000276c:	00003097          	auipc	ra,0x3
    80002770:	6dc080e7          	jalr	1756(ra) # 80005e48 <plic_claim>
    80002774:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002776:	47a9                	li	a5,10
    80002778:	02f50763          	beq	a0,a5,800027a6 <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    8000277c:	4785                	li	a5,1
    8000277e:	02f50963          	beq	a0,a5,800027b0 <devintr+0x78>
    return 1;
    80002782:	4505                	li	a0,1
    } else if(irq){
    80002784:	dcf9                	beqz	s1,80002762 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80002786:	85a6                	mv	a1,s1
    80002788:	00006517          	auipc	a0,0x6
    8000278c:	b8850513          	add	a0,a0,-1144 # 80008310 <states.0+0x38>
    80002790:	ffffe097          	auipc	ra,0xffffe
    80002794:	df6080e7          	jalr	-522(ra) # 80000586 <printf>
      plic_complete(irq);
    80002798:	8526                	mv	a0,s1
    8000279a:	00003097          	auipc	ra,0x3
    8000279e:	6d2080e7          	jalr	1746(ra) # 80005e6c <plic_complete>
    return 1;
    800027a2:	4505                	li	a0,1
    800027a4:	bf7d                	j	80002762 <devintr+0x2a>
      uartintr();
    800027a6:	ffffe097          	auipc	ra,0xffffe
    800027aa:	1ee080e7          	jalr	494(ra) # 80000994 <uartintr>
    if(irq)
    800027ae:	b7ed                	j	80002798 <devintr+0x60>
      virtio_disk_intr();
    800027b0:	00004097          	auipc	ra,0x4
    800027b4:	b82080e7          	jalr	-1150(ra) # 80006332 <virtio_disk_intr>
    if(irq)
    800027b8:	b7c5                	j	80002798 <devintr+0x60>
    if(cpuid() == 0){
    800027ba:	fffff097          	auipc	ra,0xfffff
    800027be:	1c0080e7          	jalr	448(ra) # 8000197a <cpuid>
    800027c2:	c901                	beqz	a0,800027d2 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800027c4:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800027c8:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800027ca:	14479073          	csrw	sip,a5
    return 2;
    800027ce:	4509                	li	a0,2
    800027d0:	bf49                	j	80002762 <devintr+0x2a>
      clockintr();
    800027d2:	00000097          	auipc	ra,0x0
    800027d6:	f20080e7          	jalr	-224(ra) # 800026f2 <clockintr>
    800027da:	b7ed                	j	800027c4 <devintr+0x8c>
}
    800027dc:	8082                	ret

00000000800027de <usertrap>:
{
    800027de:	1101                	add	sp,sp,-32
    800027e0:	ec06                	sd	ra,24(sp)
    800027e2:	e822                	sd	s0,16(sp)
    800027e4:	e426                	sd	s1,8(sp)
    800027e6:	e04a                	sd	s2,0(sp)
    800027e8:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027ea:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800027ee:	1007f793          	and	a5,a5,256
    800027f2:	e3b1                	bnez	a5,80002836 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027f4:	00003797          	auipc	a5,0x3
    800027f8:	54c78793          	add	a5,a5,1356 # 80005d40 <kernelvec>
    800027fc:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002800:	fffff097          	auipc	ra,0xfffff
    80002804:	1a6080e7          	jalr	422(ra) # 800019a6 <myproc>
    80002808:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000280a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000280c:	14102773          	csrr	a4,sepc
    80002810:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002812:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002816:	47a1                	li	a5,8
    80002818:	02f70763          	beq	a4,a5,80002846 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    8000281c:	00000097          	auipc	ra,0x0
    80002820:	f1c080e7          	jalr	-228(ra) # 80002738 <devintr>
    80002824:	892a                	mv	s2,a0
    80002826:	c151                	beqz	a0,800028aa <usertrap+0xcc>
  if(killed(p))
    80002828:	8526                	mv	a0,s1
    8000282a:	00000097          	auipc	ra,0x0
    8000282e:	acc080e7          	jalr	-1332(ra) # 800022f6 <killed>
    80002832:	c929                	beqz	a0,80002884 <usertrap+0xa6>
    80002834:	a099                	j	8000287a <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80002836:	00006517          	auipc	a0,0x6
    8000283a:	afa50513          	add	a0,a0,-1286 # 80008330 <states.0+0x58>
    8000283e:	ffffe097          	auipc	ra,0xffffe
    80002842:	cfe080e7          	jalr	-770(ra) # 8000053c <panic>
    if(killed(p))
    80002846:	00000097          	auipc	ra,0x0
    8000284a:	ab0080e7          	jalr	-1360(ra) # 800022f6 <killed>
    8000284e:	e921                	bnez	a0,8000289e <usertrap+0xc0>
    p->trapframe->epc += 4;
    80002850:	6cb8                	ld	a4,88(s1)
    80002852:	6f1c                	ld	a5,24(a4)
    80002854:	0791                	add	a5,a5,4
    80002856:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002858:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000285c:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002860:	10079073          	csrw	sstatus,a5
    syscall();
    80002864:	00000097          	auipc	ra,0x0
    80002868:	2d4080e7          	jalr	724(ra) # 80002b38 <syscall>
  if(killed(p))
    8000286c:	8526                	mv	a0,s1
    8000286e:	00000097          	auipc	ra,0x0
    80002872:	a88080e7          	jalr	-1400(ra) # 800022f6 <killed>
    80002876:	c911                	beqz	a0,8000288a <usertrap+0xac>
    80002878:	4901                	li	s2,0
    exit(-1);
    8000287a:	557d                	li	a0,-1
    8000287c:	00000097          	auipc	ra,0x0
    80002880:	906080e7          	jalr	-1786(ra) # 80002182 <exit>
  if(which_dev == 2)
    80002884:	4789                	li	a5,2
    80002886:	04f90f63          	beq	s2,a5,800028e4 <usertrap+0x106>
  usertrapret();
    8000288a:	00000097          	auipc	ra,0x0
    8000288e:	dd2080e7          	jalr	-558(ra) # 8000265c <usertrapret>
}
    80002892:	60e2                	ld	ra,24(sp)
    80002894:	6442                	ld	s0,16(sp)
    80002896:	64a2                	ld	s1,8(sp)
    80002898:	6902                	ld	s2,0(sp)
    8000289a:	6105                	add	sp,sp,32
    8000289c:	8082                	ret
      exit(-1);
    8000289e:	557d                	li	a0,-1
    800028a0:	00000097          	auipc	ra,0x0
    800028a4:	8e2080e7          	jalr	-1822(ra) # 80002182 <exit>
    800028a8:	b765                	j	80002850 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028aa:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800028ae:	5890                	lw	a2,48(s1)
    800028b0:	00006517          	auipc	a0,0x6
    800028b4:	aa050513          	add	a0,a0,-1376 # 80008350 <states.0+0x78>
    800028b8:	ffffe097          	auipc	ra,0xffffe
    800028bc:	cce080e7          	jalr	-818(ra) # 80000586 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028c0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800028c4:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800028c8:	00006517          	auipc	a0,0x6
    800028cc:	ab850513          	add	a0,a0,-1352 # 80008380 <states.0+0xa8>
    800028d0:	ffffe097          	auipc	ra,0xffffe
    800028d4:	cb6080e7          	jalr	-842(ra) # 80000586 <printf>
    setkilled(p);
    800028d8:	8526                	mv	a0,s1
    800028da:	00000097          	auipc	ra,0x0
    800028de:	9f0080e7          	jalr	-1552(ra) # 800022ca <setkilled>
    800028e2:	b769                	j	8000286c <usertrap+0x8e>
    yield();
    800028e4:	fffff097          	auipc	ra,0xfffff
    800028e8:	72e080e7          	jalr	1838(ra) # 80002012 <yield>
    800028ec:	bf79                	j	8000288a <usertrap+0xac>

00000000800028ee <kerneltrap>:
{
    800028ee:	7179                	add	sp,sp,-48
    800028f0:	f406                	sd	ra,40(sp)
    800028f2:	f022                	sd	s0,32(sp)
    800028f4:	ec26                	sd	s1,24(sp)
    800028f6:	e84a                	sd	s2,16(sp)
    800028f8:	e44e                	sd	s3,8(sp)
    800028fa:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028fc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002900:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002904:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002908:	1004f793          	and	a5,s1,256
    8000290c:	cb85                	beqz	a5,8000293c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000290e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002912:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80002914:	ef85                	bnez	a5,8000294c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002916:	00000097          	auipc	ra,0x0
    8000291a:	e22080e7          	jalr	-478(ra) # 80002738 <devintr>
    8000291e:	cd1d                	beqz	a0,8000295c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002920:	4789                	li	a5,2
    80002922:	06f50a63          	beq	a0,a5,80002996 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002926:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000292a:	10049073          	csrw	sstatus,s1
}
    8000292e:	70a2                	ld	ra,40(sp)
    80002930:	7402                	ld	s0,32(sp)
    80002932:	64e2                	ld	s1,24(sp)
    80002934:	6942                	ld	s2,16(sp)
    80002936:	69a2                	ld	s3,8(sp)
    80002938:	6145                	add	sp,sp,48
    8000293a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000293c:	00006517          	auipc	a0,0x6
    80002940:	a6450513          	add	a0,a0,-1436 # 800083a0 <states.0+0xc8>
    80002944:	ffffe097          	auipc	ra,0xffffe
    80002948:	bf8080e7          	jalr	-1032(ra) # 8000053c <panic>
    panic("kerneltrap: interrupts enabled");
    8000294c:	00006517          	auipc	a0,0x6
    80002950:	a7c50513          	add	a0,a0,-1412 # 800083c8 <states.0+0xf0>
    80002954:	ffffe097          	auipc	ra,0xffffe
    80002958:	be8080e7          	jalr	-1048(ra) # 8000053c <panic>
    printf("scause %p\n", scause);
    8000295c:	85ce                	mv	a1,s3
    8000295e:	00006517          	auipc	a0,0x6
    80002962:	a8a50513          	add	a0,a0,-1398 # 800083e8 <states.0+0x110>
    80002966:	ffffe097          	auipc	ra,0xffffe
    8000296a:	c20080e7          	jalr	-992(ra) # 80000586 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000296e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002972:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002976:	00006517          	auipc	a0,0x6
    8000297a:	a8250513          	add	a0,a0,-1406 # 800083f8 <states.0+0x120>
    8000297e:	ffffe097          	auipc	ra,0xffffe
    80002982:	c08080e7          	jalr	-1016(ra) # 80000586 <printf>
    panic("kerneltrap");
    80002986:	00006517          	auipc	a0,0x6
    8000298a:	a8a50513          	add	a0,a0,-1398 # 80008410 <states.0+0x138>
    8000298e:	ffffe097          	auipc	ra,0xffffe
    80002992:	bae080e7          	jalr	-1106(ra) # 8000053c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002996:	fffff097          	auipc	ra,0xfffff
    8000299a:	010080e7          	jalr	16(ra) # 800019a6 <myproc>
    8000299e:	d541                	beqz	a0,80002926 <kerneltrap+0x38>
    800029a0:	fffff097          	auipc	ra,0xfffff
    800029a4:	006080e7          	jalr	6(ra) # 800019a6 <myproc>
    800029a8:	4d18                	lw	a4,24(a0)
    800029aa:	4791                	li	a5,4
    800029ac:	f6f71de3          	bne	a4,a5,80002926 <kerneltrap+0x38>
    yield();
    800029b0:	fffff097          	auipc	ra,0xfffff
    800029b4:	662080e7          	jalr	1634(ra) # 80002012 <yield>
    800029b8:	b7bd                	j	80002926 <kerneltrap+0x38>

00000000800029ba <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800029ba:	1101                	add	sp,sp,-32
    800029bc:	ec06                	sd	ra,24(sp)
    800029be:	e822                	sd	s0,16(sp)
    800029c0:	e426                	sd	s1,8(sp)
    800029c2:	1000                	add	s0,sp,32
    800029c4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800029c6:	fffff097          	auipc	ra,0xfffff
    800029ca:	fe0080e7          	jalr	-32(ra) # 800019a6 <myproc>
  switch (n) {
    800029ce:	4795                	li	a5,5
    800029d0:	0497e163          	bltu	a5,s1,80002a12 <argraw+0x58>
    800029d4:	048a                	sll	s1,s1,0x2
    800029d6:	00006717          	auipc	a4,0x6
    800029da:	a7270713          	add	a4,a4,-1422 # 80008448 <states.0+0x170>
    800029de:	94ba                	add	s1,s1,a4
    800029e0:	409c                	lw	a5,0(s1)
    800029e2:	97ba                	add	a5,a5,a4
    800029e4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800029e6:	6d3c                	ld	a5,88(a0)
    800029e8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800029ea:	60e2                	ld	ra,24(sp)
    800029ec:	6442                	ld	s0,16(sp)
    800029ee:	64a2                	ld	s1,8(sp)
    800029f0:	6105                	add	sp,sp,32
    800029f2:	8082                	ret
    return p->trapframe->a1;
    800029f4:	6d3c                	ld	a5,88(a0)
    800029f6:	7fa8                	ld	a0,120(a5)
    800029f8:	bfcd                	j	800029ea <argraw+0x30>
    return p->trapframe->a2;
    800029fa:	6d3c                	ld	a5,88(a0)
    800029fc:	63c8                	ld	a0,128(a5)
    800029fe:	b7f5                	j	800029ea <argraw+0x30>
    return p->trapframe->a3;
    80002a00:	6d3c                	ld	a5,88(a0)
    80002a02:	67c8                	ld	a0,136(a5)
    80002a04:	b7dd                	j	800029ea <argraw+0x30>
    return p->trapframe->a4;
    80002a06:	6d3c                	ld	a5,88(a0)
    80002a08:	6bc8                	ld	a0,144(a5)
    80002a0a:	b7c5                	j	800029ea <argraw+0x30>
    return p->trapframe->a5;
    80002a0c:	6d3c                	ld	a5,88(a0)
    80002a0e:	6fc8                	ld	a0,152(a5)
    80002a10:	bfe9                	j	800029ea <argraw+0x30>
  panic("argraw");
    80002a12:	00006517          	auipc	a0,0x6
    80002a16:	a0e50513          	add	a0,a0,-1522 # 80008420 <states.0+0x148>
    80002a1a:	ffffe097          	auipc	ra,0xffffe
    80002a1e:	b22080e7          	jalr	-1246(ra) # 8000053c <panic>

0000000080002a22 <fetchaddr>:
{
    80002a22:	1101                	add	sp,sp,-32
    80002a24:	ec06                	sd	ra,24(sp)
    80002a26:	e822                	sd	s0,16(sp)
    80002a28:	e426                	sd	s1,8(sp)
    80002a2a:	e04a                	sd	s2,0(sp)
    80002a2c:	1000                	add	s0,sp,32
    80002a2e:	84aa                	mv	s1,a0
    80002a30:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002a32:	fffff097          	auipc	ra,0xfffff
    80002a36:	f74080e7          	jalr	-140(ra) # 800019a6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002a3a:	653c                	ld	a5,72(a0)
    80002a3c:	02f4f863          	bgeu	s1,a5,80002a6c <fetchaddr+0x4a>
    80002a40:	00848713          	add	a4,s1,8
    80002a44:	02e7e663          	bltu	a5,a4,80002a70 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002a48:	46a1                	li	a3,8
    80002a4a:	8626                	mv	a2,s1
    80002a4c:	85ca                	mv	a1,s2
    80002a4e:	6928                	ld	a0,80(a0)
    80002a50:	fffff097          	auipc	ra,0xfffff
    80002a54:	ca2080e7          	jalr	-862(ra) # 800016f2 <copyin>
    80002a58:	00a03533          	snez	a0,a0
    80002a5c:	40a00533          	neg	a0,a0
}
    80002a60:	60e2                	ld	ra,24(sp)
    80002a62:	6442                	ld	s0,16(sp)
    80002a64:	64a2                	ld	s1,8(sp)
    80002a66:	6902                	ld	s2,0(sp)
    80002a68:	6105                	add	sp,sp,32
    80002a6a:	8082                	ret
    return -1;
    80002a6c:	557d                	li	a0,-1
    80002a6e:	bfcd                	j	80002a60 <fetchaddr+0x3e>
    80002a70:	557d                	li	a0,-1
    80002a72:	b7fd                	j	80002a60 <fetchaddr+0x3e>

0000000080002a74 <fetchstr>:
{
    80002a74:	7179                	add	sp,sp,-48
    80002a76:	f406                	sd	ra,40(sp)
    80002a78:	f022                	sd	s0,32(sp)
    80002a7a:	ec26                	sd	s1,24(sp)
    80002a7c:	e84a                	sd	s2,16(sp)
    80002a7e:	e44e                	sd	s3,8(sp)
    80002a80:	1800                	add	s0,sp,48
    80002a82:	892a                	mv	s2,a0
    80002a84:	84ae                	mv	s1,a1
    80002a86:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002a88:	fffff097          	auipc	ra,0xfffff
    80002a8c:	f1e080e7          	jalr	-226(ra) # 800019a6 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002a90:	86ce                	mv	a3,s3
    80002a92:	864a                	mv	a2,s2
    80002a94:	85a6                	mv	a1,s1
    80002a96:	6928                	ld	a0,80(a0)
    80002a98:	fffff097          	auipc	ra,0xfffff
    80002a9c:	ce8080e7          	jalr	-792(ra) # 80001780 <copyinstr>
    80002aa0:	00054e63          	bltz	a0,80002abc <fetchstr+0x48>
  return strlen(buf);
    80002aa4:	8526                	mv	a0,s1
    80002aa6:	ffffe097          	auipc	ra,0xffffe
    80002aaa:	3a2080e7          	jalr	930(ra) # 80000e48 <strlen>
}
    80002aae:	70a2                	ld	ra,40(sp)
    80002ab0:	7402                	ld	s0,32(sp)
    80002ab2:	64e2                	ld	s1,24(sp)
    80002ab4:	6942                	ld	s2,16(sp)
    80002ab6:	69a2                	ld	s3,8(sp)
    80002ab8:	6145                	add	sp,sp,48
    80002aba:	8082                	ret
    return -1;
    80002abc:	557d                	li	a0,-1
    80002abe:	bfc5                	j	80002aae <fetchstr+0x3a>

0000000080002ac0 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002ac0:	1101                	add	sp,sp,-32
    80002ac2:	ec06                	sd	ra,24(sp)
    80002ac4:	e822                	sd	s0,16(sp)
    80002ac6:	e426                	sd	s1,8(sp)
    80002ac8:	1000                	add	s0,sp,32
    80002aca:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002acc:	00000097          	auipc	ra,0x0
    80002ad0:	eee080e7          	jalr	-274(ra) # 800029ba <argraw>
    80002ad4:	c088                	sw	a0,0(s1)
}
    80002ad6:	60e2                	ld	ra,24(sp)
    80002ad8:	6442                	ld	s0,16(sp)
    80002ada:	64a2                	ld	s1,8(sp)
    80002adc:	6105                	add	sp,sp,32
    80002ade:	8082                	ret

0000000080002ae0 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002ae0:	1101                	add	sp,sp,-32
    80002ae2:	ec06                	sd	ra,24(sp)
    80002ae4:	e822                	sd	s0,16(sp)
    80002ae6:	e426                	sd	s1,8(sp)
    80002ae8:	1000                	add	s0,sp,32
    80002aea:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002aec:	00000097          	auipc	ra,0x0
    80002af0:	ece080e7          	jalr	-306(ra) # 800029ba <argraw>
    80002af4:	e088                	sd	a0,0(s1)
}
    80002af6:	60e2                	ld	ra,24(sp)
    80002af8:	6442                	ld	s0,16(sp)
    80002afa:	64a2                	ld	s1,8(sp)
    80002afc:	6105                	add	sp,sp,32
    80002afe:	8082                	ret

0000000080002b00 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002b00:	7179                	add	sp,sp,-48
    80002b02:	f406                	sd	ra,40(sp)
    80002b04:	f022                	sd	s0,32(sp)
    80002b06:	ec26                	sd	s1,24(sp)
    80002b08:	e84a                	sd	s2,16(sp)
    80002b0a:	1800                	add	s0,sp,48
    80002b0c:	84ae                	mv	s1,a1
    80002b0e:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002b10:	fd840593          	add	a1,s0,-40
    80002b14:	00000097          	auipc	ra,0x0
    80002b18:	fcc080e7          	jalr	-52(ra) # 80002ae0 <argaddr>
  return fetchstr(addr, buf, max);
    80002b1c:	864a                	mv	a2,s2
    80002b1e:	85a6                	mv	a1,s1
    80002b20:	fd843503          	ld	a0,-40(s0)
    80002b24:	00000097          	auipc	ra,0x0
    80002b28:	f50080e7          	jalr	-176(ra) # 80002a74 <fetchstr>
}
    80002b2c:	70a2                	ld	ra,40(sp)
    80002b2e:	7402                	ld	s0,32(sp)
    80002b30:	64e2                	ld	s1,24(sp)
    80002b32:	6942                	ld	s2,16(sp)
    80002b34:	6145                	add	sp,sp,48
    80002b36:	8082                	ret

0000000080002b38 <syscall>:
[SYS_writebigfile]    sys_writebigfile,
};

void
syscall(void)
{
    80002b38:	1101                	add	sp,sp,-32
    80002b3a:	ec06                	sd	ra,24(sp)
    80002b3c:	e822                	sd	s0,16(sp)
    80002b3e:	e426                	sd	s1,8(sp)
    80002b40:	e04a                	sd	s2,0(sp)
    80002b42:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002b44:	fffff097          	auipc	ra,0xfffff
    80002b48:	e62080e7          	jalr	-414(ra) # 800019a6 <myproc>
    80002b4c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002b4e:	05853903          	ld	s2,88(a0)
    80002b52:	0a893783          	ld	a5,168(s2)
    80002b56:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002b5a:	37fd                	addw	a5,a5,-1
    80002b5c:	4759                	li	a4,22
    80002b5e:	00f76f63          	bltu	a4,a5,80002b7c <syscall+0x44>
    80002b62:	00369713          	sll	a4,a3,0x3
    80002b66:	00006797          	auipc	a5,0x6
    80002b6a:	8fa78793          	add	a5,a5,-1798 # 80008460 <syscalls>
    80002b6e:	97ba                	add	a5,a5,a4
    80002b70:	639c                	ld	a5,0(a5)
    80002b72:	c789                	beqz	a5,80002b7c <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002b74:	9782                	jalr	a5
    80002b76:	06a93823          	sd	a0,112(s2)
    80002b7a:	a839                	j	80002b98 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002b7c:	15848613          	add	a2,s1,344
    80002b80:	588c                	lw	a1,48(s1)
    80002b82:	00006517          	auipc	a0,0x6
    80002b86:	8a650513          	add	a0,a0,-1882 # 80008428 <states.0+0x150>
    80002b8a:	ffffe097          	auipc	ra,0xffffe
    80002b8e:	9fc080e7          	jalr	-1540(ra) # 80000586 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002b92:	6cbc                	ld	a5,88(s1)
    80002b94:	577d                	li	a4,-1
    80002b96:	fbb8                	sd	a4,112(a5)
  }
}
    80002b98:	60e2                	ld	ra,24(sp)
    80002b9a:	6442                	ld	s0,16(sp)
    80002b9c:	64a2                	ld	s1,8(sp)
    80002b9e:	6902                	ld	s2,0(sp)
    80002ba0:	6105                	add	sp,sp,32
    80002ba2:	8082                	ret

0000000080002ba4 <sys_exit>:



uint64
sys_exit(void)
{
    80002ba4:	1101                	add	sp,sp,-32
    80002ba6:	ec06                	sd	ra,24(sp)
    80002ba8:	e822                	sd	s0,16(sp)
    80002baa:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    80002bac:	fec40593          	add	a1,s0,-20
    80002bb0:	4501                	li	a0,0
    80002bb2:	00000097          	auipc	ra,0x0
    80002bb6:	f0e080e7          	jalr	-242(ra) # 80002ac0 <argint>
  exit(n);
    80002bba:	fec42503          	lw	a0,-20(s0)
    80002bbe:	fffff097          	auipc	ra,0xfffff
    80002bc2:	5c4080e7          	jalr	1476(ra) # 80002182 <exit>
  return 0;  // not reached
}
    80002bc6:	4501                	li	a0,0
    80002bc8:	60e2                	ld	ra,24(sp)
    80002bca:	6442                	ld	s0,16(sp)
    80002bcc:	6105                	add	sp,sp,32
    80002bce:	8082                	ret

0000000080002bd0 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002bd0:	1141                	add	sp,sp,-16
    80002bd2:	e406                	sd	ra,8(sp)
    80002bd4:	e022                	sd	s0,0(sp)
    80002bd6:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002bd8:	fffff097          	auipc	ra,0xfffff
    80002bdc:	dce080e7          	jalr	-562(ra) # 800019a6 <myproc>
}
    80002be0:	5908                	lw	a0,48(a0)
    80002be2:	60a2                	ld	ra,8(sp)
    80002be4:	6402                	ld	s0,0(sp)
    80002be6:	0141                	add	sp,sp,16
    80002be8:	8082                	ret

0000000080002bea <sys_fork>:

uint64
sys_fork(void)
{
    80002bea:	1141                	add	sp,sp,-16
    80002bec:	e406                	sd	ra,8(sp)
    80002bee:	e022                	sd	s0,0(sp)
    80002bf0:	0800                	add	s0,sp,16
  return fork();
    80002bf2:	fffff097          	auipc	ra,0xfffff
    80002bf6:	16a080e7          	jalr	362(ra) # 80001d5c <fork>
}
    80002bfa:	60a2                	ld	ra,8(sp)
    80002bfc:	6402                	ld	s0,0(sp)
    80002bfe:	0141                	add	sp,sp,16
    80002c00:	8082                	ret

0000000080002c02 <sys_wait>:

uint64
sys_wait(void)
{
    80002c02:	1101                	add	sp,sp,-32
    80002c04:	ec06                	sd	ra,24(sp)
    80002c06:	e822                	sd	s0,16(sp)
    80002c08:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002c0a:	fe840593          	add	a1,s0,-24
    80002c0e:	4501                	li	a0,0
    80002c10:	00000097          	auipc	ra,0x0
    80002c14:	ed0080e7          	jalr	-304(ra) # 80002ae0 <argaddr>
  return wait(p);
    80002c18:	fe843503          	ld	a0,-24(s0)
    80002c1c:	fffff097          	auipc	ra,0xfffff
    80002c20:	70c080e7          	jalr	1804(ra) # 80002328 <wait>
}
    80002c24:	60e2                	ld	ra,24(sp)
    80002c26:	6442                	ld	s0,16(sp)
    80002c28:	6105                	add	sp,sp,32
    80002c2a:	8082                	ret

0000000080002c2c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002c2c:	7179                	add	sp,sp,-48
    80002c2e:	f406                	sd	ra,40(sp)
    80002c30:	f022                	sd	s0,32(sp)
    80002c32:	ec26                	sd	s1,24(sp)
    80002c34:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002c36:	fdc40593          	add	a1,s0,-36
    80002c3a:	4501                	li	a0,0
    80002c3c:	00000097          	auipc	ra,0x0
    80002c40:	e84080e7          	jalr	-380(ra) # 80002ac0 <argint>
  addr = myproc()->sz;
    80002c44:	fffff097          	auipc	ra,0xfffff
    80002c48:	d62080e7          	jalr	-670(ra) # 800019a6 <myproc>
    80002c4c:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002c4e:	fdc42503          	lw	a0,-36(s0)
    80002c52:	fffff097          	auipc	ra,0xfffff
    80002c56:	0ae080e7          	jalr	174(ra) # 80001d00 <growproc>
    80002c5a:	00054863          	bltz	a0,80002c6a <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002c5e:	8526                	mv	a0,s1
    80002c60:	70a2                	ld	ra,40(sp)
    80002c62:	7402                	ld	s0,32(sp)
    80002c64:	64e2                	ld	s1,24(sp)
    80002c66:	6145                	add	sp,sp,48
    80002c68:	8082                	ret
    return -1;
    80002c6a:	54fd                	li	s1,-1
    80002c6c:	bfcd                	j	80002c5e <sys_sbrk+0x32>

0000000080002c6e <sys_sleep>:

uint64
sys_sleep(void)
{
    80002c6e:	7139                	add	sp,sp,-64
    80002c70:	fc06                	sd	ra,56(sp)
    80002c72:	f822                	sd	s0,48(sp)
    80002c74:	f426                	sd	s1,40(sp)
    80002c76:	f04a                	sd	s2,32(sp)
    80002c78:	ec4e                	sd	s3,24(sp)
    80002c7a:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002c7c:	fcc40593          	add	a1,s0,-52
    80002c80:	4501                	li	a0,0
    80002c82:	00000097          	auipc	ra,0x0
    80002c86:	e3e080e7          	jalr	-450(ra) # 80002ac0 <argint>
  acquire(&tickslock);
    80002c8a:	00014517          	auipc	a0,0x14
    80002c8e:	dc650513          	add	a0,a0,-570 # 80016a50 <tickslock>
    80002c92:	ffffe097          	auipc	ra,0xffffe
    80002c96:	f40080e7          	jalr	-192(ra) # 80000bd2 <acquire>
  ticks0 = ticks;
    80002c9a:	00006917          	auipc	s2,0x6
    80002c9e:	d1692903          	lw	s2,-746(s2) # 800089b0 <ticks>
  while(ticks - ticks0 < n){
    80002ca2:	fcc42783          	lw	a5,-52(s0)
    80002ca6:	cf9d                	beqz	a5,80002ce4 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002ca8:	00014997          	auipc	s3,0x14
    80002cac:	da898993          	add	s3,s3,-600 # 80016a50 <tickslock>
    80002cb0:	00006497          	auipc	s1,0x6
    80002cb4:	d0048493          	add	s1,s1,-768 # 800089b0 <ticks>
    if(killed(myproc())){
    80002cb8:	fffff097          	auipc	ra,0xfffff
    80002cbc:	cee080e7          	jalr	-786(ra) # 800019a6 <myproc>
    80002cc0:	fffff097          	auipc	ra,0xfffff
    80002cc4:	636080e7          	jalr	1590(ra) # 800022f6 <killed>
    80002cc8:	ed15                	bnez	a0,80002d04 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002cca:	85ce                	mv	a1,s3
    80002ccc:	8526                	mv	a0,s1
    80002cce:	fffff097          	auipc	ra,0xfffff
    80002cd2:	380080e7          	jalr	896(ra) # 8000204e <sleep>
  while(ticks - ticks0 < n){
    80002cd6:	409c                	lw	a5,0(s1)
    80002cd8:	412787bb          	subw	a5,a5,s2
    80002cdc:	fcc42703          	lw	a4,-52(s0)
    80002ce0:	fce7ece3          	bltu	a5,a4,80002cb8 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002ce4:	00014517          	auipc	a0,0x14
    80002ce8:	d6c50513          	add	a0,a0,-660 # 80016a50 <tickslock>
    80002cec:	ffffe097          	auipc	ra,0xffffe
    80002cf0:	f9a080e7          	jalr	-102(ra) # 80000c86 <release>
  return 0;
    80002cf4:	4501                	li	a0,0
}
    80002cf6:	70e2                	ld	ra,56(sp)
    80002cf8:	7442                	ld	s0,48(sp)
    80002cfa:	74a2                	ld	s1,40(sp)
    80002cfc:	7902                	ld	s2,32(sp)
    80002cfe:	69e2                	ld	s3,24(sp)
    80002d00:	6121                	add	sp,sp,64
    80002d02:	8082                	ret
      release(&tickslock);
    80002d04:	00014517          	auipc	a0,0x14
    80002d08:	d4c50513          	add	a0,a0,-692 # 80016a50 <tickslock>
    80002d0c:	ffffe097          	auipc	ra,0xffffe
    80002d10:	f7a080e7          	jalr	-134(ra) # 80000c86 <release>
      return -1;
    80002d14:	557d                	li	a0,-1
    80002d16:	b7c5                	j	80002cf6 <sys_sleep+0x88>

0000000080002d18 <sys_kill>:

uint64
sys_kill(void)
{
    80002d18:	1101                	add	sp,sp,-32
    80002d1a:	ec06                	sd	ra,24(sp)
    80002d1c:	e822                	sd	s0,16(sp)
    80002d1e:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    80002d20:	fec40593          	add	a1,s0,-20
    80002d24:	4501                	li	a0,0
    80002d26:	00000097          	auipc	ra,0x0
    80002d2a:	d9a080e7          	jalr	-614(ra) # 80002ac0 <argint>
  return kill(pid);
    80002d2e:	fec42503          	lw	a0,-20(s0)
    80002d32:	fffff097          	auipc	ra,0xfffff
    80002d36:	526080e7          	jalr	1318(ra) # 80002258 <kill>
}
    80002d3a:	60e2                	ld	ra,24(sp)
    80002d3c:	6442                	ld	s0,16(sp)
    80002d3e:	6105                	add	sp,sp,32
    80002d40:	8082                	ret

0000000080002d42 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002d42:	1101                	add	sp,sp,-32
    80002d44:	ec06                	sd	ra,24(sp)
    80002d46:	e822                	sd	s0,16(sp)
    80002d48:	e426                	sd	s1,8(sp)
    80002d4a:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002d4c:	00014517          	auipc	a0,0x14
    80002d50:	d0450513          	add	a0,a0,-764 # 80016a50 <tickslock>
    80002d54:	ffffe097          	auipc	ra,0xffffe
    80002d58:	e7e080e7          	jalr	-386(ra) # 80000bd2 <acquire>
  xticks = ticks;
    80002d5c:	00006497          	auipc	s1,0x6
    80002d60:	c544a483          	lw	s1,-940(s1) # 800089b0 <ticks>
  release(&tickslock);
    80002d64:	00014517          	auipc	a0,0x14
    80002d68:	cec50513          	add	a0,a0,-788 # 80016a50 <tickslock>
    80002d6c:	ffffe097          	auipc	ra,0xffffe
    80002d70:	f1a080e7          	jalr	-230(ra) # 80000c86 <release>
  return xticks;
}
    80002d74:	02049513          	sll	a0,s1,0x20
    80002d78:	9101                	srl	a0,a0,0x20
    80002d7a:	60e2                	ld	ra,24(sp)
    80002d7c:	6442                	ld	s0,16(sp)
    80002d7e:	64a2                	ld	s1,8(sp)
    80002d80:	6105                	add	sp,sp,32
    80002d82:	8082                	ret

0000000080002d84 <sys_procs>:

uint64 sys_procs(void)
{
    80002d84:	7159                	add	sp,sp,-112
    80002d86:	f486                	sd	ra,104(sp)
    80002d88:	f0a2                	sd	s0,96(sp)
    80002d8a:	eca6                	sd	s1,88(sp)
    80002d8c:	e8ca                	sd	s2,80(sp)
    80002d8e:	e4ce                	sd	s3,72(sp)
    80002d90:	e0d2                	sd	s4,64(sp)
    80002d92:	fc56                	sd	s5,56(sp)
    80002d94:	f85a                	sd	s6,48(sp)
    80002d96:	f45e                	sd	s7,40(sp)
    80002d98:	f062                	sd	s8,32(sp)
    80002d9a:	ec66                	sd	s9,24(sp)
    80002d9c:	e86a                	sd	s10,16(sp)
    80002d9e:	e46e                	sd	s11,8(sp)
    80002da0:	1880                	add	s0,sp,112
    printf("process list\n");
    80002da2:	00005517          	auipc	a0,0x5
    80002da6:	77e50513          	add	a0,a0,1918 # 80008520 <syscalls+0xc0>
    80002daa:	ffffd097          	auipc	ra,0xffffd
    80002dae:	7dc080e7          	jalr	2012(ra) # 80000586 <printf>

    // Loop over process table looking for process with pid.
    struct proc *p;

     printf("name \t pid \t state \n");
    80002db2:	00005517          	auipc	a0,0x5
    80002db6:	77e50513          	add	a0,a0,1918 # 80008530 <syscalls+0xd0>
    80002dba:	ffffd097          	auipc	ra,0xffffd
    80002dbe:	7cc080e7          	jalr	1996(ra) # 80000586 <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002dc2:	0000e497          	auipc	s1,0xe
    80002dc6:	3e648493          	add	s1,s1,998 # 800111a8 <proc+0x158>
    80002dca:	00014a17          	auipc	s4,0x14
    80002dce:	ddea0a13          	add	s4,s4,-546 # 80016ba8 <bcache+0x140>
    {
        acquire(&p->lock); // Acquire the lock of the current process

        // Now you can access the fields of the process (p->state, p->pid, etc.)
        // and perform operations on them
        if (p->state == SLEEPING)
    80002dd2:	4989                	li	s3,2
            printf("%s \t %d \t SLEEPING \n", p->name, p->pid);
        else if (p->state == RUNNING)
    80002dd4:	4a91                	li	s5,4
            printf("%s \t %d \t RUNNING \n", p->name, p->pid);
        else if (p->state == RUNNABLE)
    80002dd6:	4b0d                	li	s6,3
            printf("%s \t %d \t RUNNABLE \n", p->name, p->pid);
        else if (p->state == USED)
    80002dd8:	4b85                	li	s7,1
            printf("%s \t %d \t USED \n", p->name, p->pid); 
        else if (p->state == ZOMBIE)
    80002dda:	4c15                	li	s8,5
            printf("%s \t %d \t ZOMBIE \n", p->name, p->pid); 
    80002ddc:	00005d97          	auipc	s11,0x5
    80002de0:	7ccd8d93          	add	s11,s11,1996 # 800085a8 <syscalls+0x148>
            printf("%s \t %d \t USED \n", p->name, p->pid); 
    80002de4:	00005d17          	auipc	s10,0x5
    80002de8:	7acd0d13          	add	s10,s10,1964 # 80008590 <syscalls+0x130>
            printf("%s \t %d \t RUNNABLE \n", p->name, p->pid);
    80002dec:	00005c97          	auipc	s9,0x5
    80002df0:	78cc8c93          	add	s9,s9,1932 # 80008578 <syscalls+0x118>
    80002df4:	a025                	j	80002e1c <sys_procs+0x98>
            printf("%s \t %d \t SLEEPING \n", p->name, p->pid);
    80002df6:	ed84a603          	lw	a2,-296(s1)
    80002dfa:	00005517          	auipc	a0,0x5
    80002dfe:	74e50513          	add	a0,a0,1870 # 80008548 <syscalls+0xe8>
    80002e02:	ffffd097          	auipc	ra,0xffffd
    80002e06:	784080e7          	jalr	1924(ra) # 80000586 <printf>

        release(&p->lock); // Release the lock of the current process
    80002e0a:	854a                	mv	a0,s2
    80002e0c:	ffffe097          	auipc	ra,0xffffe
    80002e10:	e7a080e7          	jalr	-390(ra) # 80000c86 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002e14:	16848493          	add	s1,s1,360
    80002e18:	07448963          	beq	s1,s4,80002e8a <sys_procs+0x106>
        acquire(&p->lock); // Acquire the lock of the current process
    80002e1c:	ea848913          	add	s2,s1,-344
    80002e20:	854a                	mv	a0,s2
    80002e22:	ffffe097          	auipc	ra,0xffffe
    80002e26:	db0080e7          	jalr	-592(ra) # 80000bd2 <acquire>
        if (p->state == SLEEPING)
    80002e2a:	85a6                	mv	a1,s1
    80002e2c:	ec04a783          	lw	a5,-320(s1)
    80002e30:	fd3783e3          	beq	a5,s3,80002df6 <sys_procs+0x72>
        else if (p->state == RUNNING)
    80002e34:	03578063          	beq	a5,s5,80002e54 <sys_procs+0xd0>
        else if (p->state == RUNNABLE)
    80002e38:	03678963          	beq	a5,s6,80002e6a <sys_procs+0xe6>
        else if (p->state == USED)
    80002e3c:	03778f63          	beq	a5,s7,80002e7a <sys_procs+0xf6>
        else if (p->state == ZOMBIE)
    80002e40:	fd8795e3          	bne	a5,s8,80002e0a <sys_procs+0x86>
            printf("%s \t %d \t ZOMBIE \n", p->name, p->pid); 
    80002e44:	ed84a603          	lw	a2,-296(s1)
    80002e48:	856e                	mv	a0,s11
    80002e4a:	ffffd097          	auipc	ra,0xffffd
    80002e4e:	73c080e7          	jalr	1852(ra) # 80000586 <printf>
    80002e52:	bf65                	j	80002e0a <sys_procs+0x86>
            printf("%s \t %d \t RUNNING \n", p->name, p->pid);
    80002e54:	ed84a603          	lw	a2,-296(s1)
    80002e58:	00005517          	auipc	a0,0x5
    80002e5c:	70850513          	add	a0,a0,1800 # 80008560 <syscalls+0x100>
    80002e60:	ffffd097          	auipc	ra,0xffffd
    80002e64:	726080e7          	jalr	1830(ra) # 80000586 <printf>
    80002e68:	b74d                	j	80002e0a <sys_procs+0x86>
            printf("%s \t %d \t RUNNABLE \n", p->name, p->pid);
    80002e6a:	ed84a603          	lw	a2,-296(s1)
    80002e6e:	8566                	mv	a0,s9
    80002e70:	ffffd097          	auipc	ra,0xffffd
    80002e74:	716080e7          	jalr	1814(ra) # 80000586 <printf>
    80002e78:	bf49                	j	80002e0a <sys_procs+0x86>
            printf("%s \t %d \t USED \n", p->name, p->pid); 
    80002e7a:	ed84a603          	lw	a2,-296(s1)
    80002e7e:	856a                	mv	a0,s10
    80002e80:	ffffd097          	auipc	ra,0xffffd
    80002e84:	706080e7          	jalr	1798(ra) # 80000586 <printf>
    80002e88:	b749                	j	80002e0a <sys_procs+0x86>
    }

    return 22;
}
    80002e8a:	4559                	li	a0,22
    80002e8c:	70a6                	ld	ra,104(sp)
    80002e8e:	7406                	ld	s0,96(sp)
    80002e90:	64e6                	ld	s1,88(sp)
    80002e92:	6946                	ld	s2,80(sp)
    80002e94:	69a6                	ld	s3,72(sp)
    80002e96:	6a06                	ld	s4,64(sp)
    80002e98:	7ae2                	ld	s5,56(sp)
    80002e9a:	7b42                	ld	s6,48(sp)
    80002e9c:	7ba2                	ld	s7,40(sp)
    80002e9e:	7c02                	ld	s8,32(sp)
    80002ea0:	6ce2                	ld	s9,24(sp)
    80002ea2:	6d42                	ld	s10,16(sp)
    80002ea4:	6da2                	ld	s11,8(sp)
    80002ea6:	6165                	add	sp,sp,112
    80002ea8:	8082                	ret

0000000080002eaa <sys_writebigfile>:


uint64 sys_writebigfile(void){ 
    80002eaa:	1141                	add	sp,sp,-16
    80002eac:	e406                	sd	ra,8(sp)
    80002eae:	e022                	sd	s0,0(sp)
    80002eb0:	0800                	add	s0,sp,16
char *s="cmd : usertests writebig";
printf("%s\n", s);
    80002eb2:	00005597          	auipc	a1,0x5
    80002eb6:	70e58593          	add	a1,a1,1806 # 800085c0 <syscalls+0x160>
    80002eba:	00005517          	auipc	a0,0x5
    80002ebe:	72650513          	add	a0,a0,1830 # 800085e0 <syscalls+0x180>
    80002ec2:	ffffd097          	auipc	ra,0xffffd
    80002ec6:	6c4080e7          	jalr	1732(ra) # 80000586 <printf>

 return 23;
    80002eca:	455d                	li	a0,23
    80002ecc:	60a2                	ld	ra,8(sp)
    80002ece:	6402                	ld	s0,0(sp)
    80002ed0:	0141                	add	sp,sp,16
    80002ed2:	8082                	ret

0000000080002ed4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002ed4:	7179                	add	sp,sp,-48
    80002ed6:	f406                	sd	ra,40(sp)
    80002ed8:	f022                	sd	s0,32(sp)
    80002eda:	ec26                	sd	s1,24(sp)
    80002edc:	e84a                	sd	s2,16(sp)
    80002ede:	e44e                	sd	s3,8(sp)
    80002ee0:	e052                	sd	s4,0(sp)
    80002ee2:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002ee4:	00005597          	auipc	a1,0x5
    80002ee8:	70458593          	add	a1,a1,1796 # 800085e8 <syscalls+0x188>
    80002eec:	00014517          	auipc	a0,0x14
    80002ef0:	b7c50513          	add	a0,a0,-1156 # 80016a68 <bcache>
    80002ef4:	ffffe097          	auipc	ra,0xffffe
    80002ef8:	c4e080e7          	jalr	-946(ra) # 80000b42 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002efc:	0001c797          	auipc	a5,0x1c
    80002f00:	b6c78793          	add	a5,a5,-1172 # 8001ea68 <bcache+0x8000>
    80002f04:	0001c717          	auipc	a4,0x1c
    80002f08:	dcc70713          	add	a4,a4,-564 # 8001ecd0 <bcache+0x8268>
    80002f0c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002f10:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f14:	00014497          	auipc	s1,0x14
    80002f18:	b6c48493          	add	s1,s1,-1172 # 80016a80 <bcache+0x18>
    b->next = bcache.head.next;
    80002f1c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002f1e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002f20:	00005a17          	auipc	s4,0x5
    80002f24:	6d0a0a13          	add	s4,s4,1744 # 800085f0 <syscalls+0x190>
    b->next = bcache.head.next;
    80002f28:	2b893783          	ld	a5,696(s2)
    80002f2c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002f2e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002f32:	85d2                	mv	a1,s4
    80002f34:	01048513          	add	a0,s1,16
    80002f38:	00001097          	auipc	ra,0x1
    80002f3c:	5d8080e7          	jalr	1496(ra) # 80004510 <initsleeplock>
    bcache.head.next->prev = b;
    80002f40:	2b893783          	ld	a5,696(s2)
    80002f44:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002f46:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f4a:	45848493          	add	s1,s1,1112
    80002f4e:	fd349de3          	bne	s1,s3,80002f28 <binit+0x54>
  }
}
    80002f52:	70a2                	ld	ra,40(sp)
    80002f54:	7402                	ld	s0,32(sp)
    80002f56:	64e2                	ld	s1,24(sp)
    80002f58:	6942                	ld	s2,16(sp)
    80002f5a:	69a2                	ld	s3,8(sp)
    80002f5c:	6a02                	ld	s4,0(sp)
    80002f5e:	6145                	add	sp,sp,48
    80002f60:	8082                	ret

0000000080002f62 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002f62:	7179                	add	sp,sp,-48
    80002f64:	f406                	sd	ra,40(sp)
    80002f66:	f022                	sd	s0,32(sp)
    80002f68:	ec26                	sd	s1,24(sp)
    80002f6a:	e84a                	sd	s2,16(sp)
    80002f6c:	e44e                	sd	s3,8(sp)
    80002f6e:	1800                	add	s0,sp,48
    80002f70:	892a                	mv	s2,a0
    80002f72:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002f74:	00014517          	auipc	a0,0x14
    80002f78:	af450513          	add	a0,a0,-1292 # 80016a68 <bcache>
    80002f7c:	ffffe097          	auipc	ra,0xffffe
    80002f80:	c56080e7          	jalr	-938(ra) # 80000bd2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002f84:	0001c497          	auipc	s1,0x1c
    80002f88:	d9c4b483          	ld	s1,-612(s1) # 8001ed20 <bcache+0x82b8>
    80002f8c:	0001c797          	auipc	a5,0x1c
    80002f90:	d4478793          	add	a5,a5,-700 # 8001ecd0 <bcache+0x8268>
    80002f94:	02f48f63          	beq	s1,a5,80002fd2 <bread+0x70>
    80002f98:	873e                	mv	a4,a5
    80002f9a:	a021                	j	80002fa2 <bread+0x40>
    80002f9c:	68a4                	ld	s1,80(s1)
    80002f9e:	02e48a63          	beq	s1,a4,80002fd2 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002fa2:	449c                	lw	a5,8(s1)
    80002fa4:	ff279ce3          	bne	a5,s2,80002f9c <bread+0x3a>
    80002fa8:	44dc                	lw	a5,12(s1)
    80002faa:	ff3799e3          	bne	a5,s3,80002f9c <bread+0x3a>
      b->refcnt++;
    80002fae:	40bc                	lw	a5,64(s1)
    80002fb0:	2785                	addw	a5,a5,1
    80002fb2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002fb4:	00014517          	auipc	a0,0x14
    80002fb8:	ab450513          	add	a0,a0,-1356 # 80016a68 <bcache>
    80002fbc:	ffffe097          	auipc	ra,0xffffe
    80002fc0:	cca080e7          	jalr	-822(ra) # 80000c86 <release>
      acquiresleep(&b->lock);
    80002fc4:	01048513          	add	a0,s1,16
    80002fc8:	00001097          	auipc	ra,0x1
    80002fcc:	582080e7          	jalr	1410(ra) # 8000454a <acquiresleep>
      return b;
    80002fd0:	a8b9                	j	8000302e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002fd2:	0001c497          	auipc	s1,0x1c
    80002fd6:	d464b483          	ld	s1,-698(s1) # 8001ed18 <bcache+0x82b0>
    80002fda:	0001c797          	auipc	a5,0x1c
    80002fde:	cf678793          	add	a5,a5,-778 # 8001ecd0 <bcache+0x8268>
    80002fe2:	00f48863          	beq	s1,a5,80002ff2 <bread+0x90>
    80002fe6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002fe8:	40bc                	lw	a5,64(s1)
    80002fea:	cf81                	beqz	a5,80003002 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002fec:	64a4                	ld	s1,72(s1)
    80002fee:	fee49de3          	bne	s1,a4,80002fe8 <bread+0x86>
  panic("bget: no buffers");
    80002ff2:	00005517          	auipc	a0,0x5
    80002ff6:	60650513          	add	a0,a0,1542 # 800085f8 <syscalls+0x198>
    80002ffa:	ffffd097          	auipc	ra,0xffffd
    80002ffe:	542080e7          	jalr	1346(ra) # 8000053c <panic>
      b->dev = dev;
    80003002:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003006:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000300a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000300e:	4785                	li	a5,1
    80003010:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003012:	00014517          	auipc	a0,0x14
    80003016:	a5650513          	add	a0,a0,-1450 # 80016a68 <bcache>
    8000301a:	ffffe097          	auipc	ra,0xffffe
    8000301e:	c6c080e7          	jalr	-916(ra) # 80000c86 <release>
      acquiresleep(&b->lock);
    80003022:	01048513          	add	a0,s1,16
    80003026:	00001097          	auipc	ra,0x1
    8000302a:	524080e7          	jalr	1316(ra) # 8000454a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000302e:	409c                	lw	a5,0(s1)
    80003030:	cb89                	beqz	a5,80003042 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003032:	8526                	mv	a0,s1
    80003034:	70a2                	ld	ra,40(sp)
    80003036:	7402                	ld	s0,32(sp)
    80003038:	64e2                	ld	s1,24(sp)
    8000303a:	6942                	ld	s2,16(sp)
    8000303c:	69a2                	ld	s3,8(sp)
    8000303e:	6145                	add	sp,sp,48
    80003040:	8082                	ret
    virtio_disk_rw(b, 0);
    80003042:	4581                	li	a1,0
    80003044:	8526                	mv	a0,s1
    80003046:	00003097          	auipc	ra,0x3
    8000304a:	0bc080e7          	jalr	188(ra) # 80006102 <virtio_disk_rw>
    b->valid = 1;
    8000304e:	4785                	li	a5,1
    80003050:	c09c                	sw	a5,0(s1)
  return b;
    80003052:	b7c5                	j	80003032 <bread+0xd0>

0000000080003054 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003054:	1101                	add	sp,sp,-32
    80003056:	ec06                	sd	ra,24(sp)
    80003058:	e822                	sd	s0,16(sp)
    8000305a:	e426                	sd	s1,8(sp)
    8000305c:	1000                	add	s0,sp,32
    8000305e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003060:	0541                	add	a0,a0,16
    80003062:	00001097          	auipc	ra,0x1
    80003066:	582080e7          	jalr	1410(ra) # 800045e4 <holdingsleep>
    8000306a:	cd01                	beqz	a0,80003082 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000306c:	4585                	li	a1,1
    8000306e:	8526                	mv	a0,s1
    80003070:	00003097          	auipc	ra,0x3
    80003074:	092080e7          	jalr	146(ra) # 80006102 <virtio_disk_rw>
}
    80003078:	60e2                	ld	ra,24(sp)
    8000307a:	6442                	ld	s0,16(sp)
    8000307c:	64a2                	ld	s1,8(sp)
    8000307e:	6105                	add	sp,sp,32
    80003080:	8082                	ret
    panic("bwrite");
    80003082:	00005517          	auipc	a0,0x5
    80003086:	58e50513          	add	a0,a0,1422 # 80008610 <syscalls+0x1b0>
    8000308a:	ffffd097          	auipc	ra,0xffffd
    8000308e:	4b2080e7          	jalr	1202(ra) # 8000053c <panic>

0000000080003092 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003092:	1101                	add	sp,sp,-32
    80003094:	ec06                	sd	ra,24(sp)
    80003096:	e822                	sd	s0,16(sp)
    80003098:	e426                	sd	s1,8(sp)
    8000309a:	e04a                	sd	s2,0(sp)
    8000309c:	1000                	add	s0,sp,32
    8000309e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800030a0:	01050913          	add	s2,a0,16
    800030a4:	854a                	mv	a0,s2
    800030a6:	00001097          	auipc	ra,0x1
    800030aa:	53e080e7          	jalr	1342(ra) # 800045e4 <holdingsleep>
    800030ae:	c925                	beqz	a0,8000311e <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800030b0:	854a                	mv	a0,s2
    800030b2:	00001097          	auipc	ra,0x1
    800030b6:	4ee080e7          	jalr	1262(ra) # 800045a0 <releasesleep>

  acquire(&bcache.lock);
    800030ba:	00014517          	auipc	a0,0x14
    800030be:	9ae50513          	add	a0,a0,-1618 # 80016a68 <bcache>
    800030c2:	ffffe097          	auipc	ra,0xffffe
    800030c6:	b10080e7          	jalr	-1264(ra) # 80000bd2 <acquire>
  b->refcnt--;
    800030ca:	40bc                	lw	a5,64(s1)
    800030cc:	37fd                	addw	a5,a5,-1
    800030ce:	0007871b          	sext.w	a4,a5
    800030d2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800030d4:	e71d                	bnez	a4,80003102 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800030d6:	68b8                	ld	a4,80(s1)
    800030d8:	64bc                	ld	a5,72(s1)
    800030da:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800030dc:	68b8                	ld	a4,80(s1)
    800030de:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800030e0:	0001c797          	auipc	a5,0x1c
    800030e4:	98878793          	add	a5,a5,-1656 # 8001ea68 <bcache+0x8000>
    800030e8:	2b87b703          	ld	a4,696(a5)
    800030ec:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800030ee:	0001c717          	auipc	a4,0x1c
    800030f2:	be270713          	add	a4,a4,-1054 # 8001ecd0 <bcache+0x8268>
    800030f6:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800030f8:	2b87b703          	ld	a4,696(a5)
    800030fc:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800030fe:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003102:	00014517          	auipc	a0,0x14
    80003106:	96650513          	add	a0,a0,-1690 # 80016a68 <bcache>
    8000310a:	ffffe097          	auipc	ra,0xffffe
    8000310e:	b7c080e7          	jalr	-1156(ra) # 80000c86 <release>
}
    80003112:	60e2                	ld	ra,24(sp)
    80003114:	6442                	ld	s0,16(sp)
    80003116:	64a2                	ld	s1,8(sp)
    80003118:	6902                	ld	s2,0(sp)
    8000311a:	6105                	add	sp,sp,32
    8000311c:	8082                	ret
    panic("brelse");
    8000311e:	00005517          	auipc	a0,0x5
    80003122:	4fa50513          	add	a0,a0,1274 # 80008618 <syscalls+0x1b8>
    80003126:	ffffd097          	auipc	ra,0xffffd
    8000312a:	416080e7          	jalr	1046(ra) # 8000053c <panic>

000000008000312e <bpin>:

void
bpin(struct buf *b) {
    8000312e:	1101                	add	sp,sp,-32
    80003130:	ec06                	sd	ra,24(sp)
    80003132:	e822                	sd	s0,16(sp)
    80003134:	e426                	sd	s1,8(sp)
    80003136:	1000                	add	s0,sp,32
    80003138:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000313a:	00014517          	auipc	a0,0x14
    8000313e:	92e50513          	add	a0,a0,-1746 # 80016a68 <bcache>
    80003142:	ffffe097          	auipc	ra,0xffffe
    80003146:	a90080e7          	jalr	-1392(ra) # 80000bd2 <acquire>
  b->refcnt++;
    8000314a:	40bc                	lw	a5,64(s1)
    8000314c:	2785                	addw	a5,a5,1
    8000314e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003150:	00014517          	auipc	a0,0x14
    80003154:	91850513          	add	a0,a0,-1768 # 80016a68 <bcache>
    80003158:	ffffe097          	auipc	ra,0xffffe
    8000315c:	b2e080e7          	jalr	-1234(ra) # 80000c86 <release>
}
    80003160:	60e2                	ld	ra,24(sp)
    80003162:	6442                	ld	s0,16(sp)
    80003164:	64a2                	ld	s1,8(sp)
    80003166:	6105                	add	sp,sp,32
    80003168:	8082                	ret

000000008000316a <bunpin>:

void
bunpin(struct buf *b) {
    8000316a:	1101                	add	sp,sp,-32
    8000316c:	ec06                	sd	ra,24(sp)
    8000316e:	e822                	sd	s0,16(sp)
    80003170:	e426                	sd	s1,8(sp)
    80003172:	1000                	add	s0,sp,32
    80003174:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003176:	00014517          	auipc	a0,0x14
    8000317a:	8f250513          	add	a0,a0,-1806 # 80016a68 <bcache>
    8000317e:	ffffe097          	auipc	ra,0xffffe
    80003182:	a54080e7          	jalr	-1452(ra) # 80000bd2 <acquire>
  b->refcnt--;
    80003186:	40bc                	lw	a5,64(s1)
    80003188:	37fd                	addw	a5,a5,-1
    8000318a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000318c:	00014517          	auipc	a0,0x14
    80003190:	8dc50513          	add	a0,a0,-1828 # 80016a68 <bcache>
    80003194:	ffffe097          	auipc	ra,0xffffe
    80003198:	af2080e7          	jalr	-1294(ra) # 80000c86 <release>
}
    8000319c:	60e2                	ld	ra,24(sp)
    8000319e:	6442                	ld	s0,16(sp)
    800031a0:	64a2                	ld	s1,8(sp)
    800031a2:	6105                	add	sp,sp,32
    800031a4:	8082                	ret

00000000800031a6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800031a6:	1101                	add	sp,sp,-32
    800031a8:	ec06                	sd	ra,24(sp)
    800031aa:	e822                	sd	s0,16(sp)
    800031ac:	e426                	sd	s1,8(sp)
    800031ae:	e04a                	sd	s2,0(sp)
    800031b0:	1000                	add	s0,sp,32
    800031b2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800031b4:	00d5d59b          	srlw	a1,a1,0xd
    800031b8:	0001c797          	auipc	a5,0x1c
    800031bc:	f8c7a783          	lw	a5,-116(a5) # 8001f144 <sb+0x1c>
    800031c0:	9dbd                	addw	a1,a1,a5
    800031c2:	00000097          	auipc	ra,0x0
    800031c6:	da0080e7          	jalr	-608(ra) # 80002f62 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800031ca:	0074f713          	and	a4,s1,7
    800031ce:	4785                	li	a5,1
    800031d0:	00e797bb          	sllw	a5,a5,a4
  if ((bp->data[bi / 8] & m) == 0)
    800031d4:	14ce                	sll	s1,s1,0x33
    800031d6:	90d9                	srl	s1,s1,0x36
    800031d8:	00950733          	add	a4,a0,s1
    800031dc:	05874703          	lbu	a4,88(a4)
    800031e0:	00e7f6b3          	and	a3,a5,a4
    800031e4:	c69d                	beqz	a3,80003212 <bfree+0x6c>
    800031e6:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    800031e8:	94aa                	add	s1,s1,a0
    800031ea:	fff7c793          	not	a5,a5
    800031ee:	8f7d                	and	a4,a4,a5
    800031f0:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800031f4:	00001097          	auipc	ra,0x1
    800031f8:	238080e7          	jalr	568(ra) # 8000442c <log_write>
  brelse(bp);
    800031fc:	854a                	mv	a0,s2
    800031fe:	00000097          	auipc	ra,0x0
    80003202:	e94080e7          	jalr	-364(ra) # 80003092 <brelse>
}
    80003206:	60e2                	ld	ra,24(sp)
    80003208:	6442                	ld	s0,16(sp)
    8000320a:	64a2                	ld	s1,8(sp)
    8000320c:	6902                	ld	s2,0(sp)
    8000320e:	6105                	add	sp,sp,32
    80003210:	8082                	ret
    panic("freeing free block");
    80003212:	00005517          	auipc	a0,0x5
    80003216:	40e50513          	add	a0,a0,1038 # 80008620 <syscalls+0x1c0>
    8000321a:	ffffd097          	auipc	ra,0xffffd
    8000321e:	322080e7          	jalr	802(ra) # 8000053c <panic>

0000000080003222 <balloc>:
{
    80003222:	711d                	add	sp,sp,-96
    80003224:	ec86                	sd	ra,88(sp)
    80003226:	e8a2                	sd	s0,80(sp)
    80003228:	e4a6                	sd	s1,72(sp)
    8000322a:	e0ca                	sd	s2,64(sp)
    8000322c:	fc4e                	sd	s3,56(sp)
    8000322e:	f852                	sd	s4,48(sp)
    80003230:	f456                	sd	s5,40(sp)
    80003232:	f05a                	sd	s6,32(sp)
    80003234:	ec5e                	sd	s7,24(sp)
    80003236:	e862                	sd	s8,16(sp)
    80003238:	e466                	sd	s9,8(sp)
    8000323a:	1080                	add	s0,sp,96
  for (b = 0; b < sb.size; b += BPB)
    8000323c:	0001c797          	auipc	a5,0x1c
    80003240:	ef07a783          	lw	a5,-272(a5) # 8001f12c <sb+0x4>
    80003244:	cff5                	beqz	a5,80003340 <balloc+0x11e>
    80003246:	8baa                	mv	s7,a0
    80003248:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000324a:	0001cb17          	auipc	s6,0x1c
    8000324e:	edeb0b13          	add	s6,s6,-290 # 8001f128 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80003252:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003254:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80003256:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB)
    80003258:	6c89                	lui	s9,0x2
    8000325a:	a061                	j	800032e2 <balloc+0xc0>
        bp->data[bi / 8] |= m; // Mark block in use.
    8000325c:	97ca                	add	a5,a5,s2
    8000325e:	8e55                	or	a2,a2,a3
    80003260:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003264:	854a                	mv	a0,s2
    80003266:	00001097          	auipc	ra,0x1
    8000326a:	1c6080e7          	jalr	454(ra) # 8000442c <log_write>
        brelse(bp);
    8000326e:	854a                	mv	a0,s2
    80003270:	00000097          	auipc	ra,0x0
    80003274:	e22080e7          	jalr	-478(ra) # 80003092 <brelse>
  bp = bread(dev, bno);
    80003278:	85a6                	mv	a1,s1
    8000327a:	855e                	mv	a0,s7
    8000327c:	00000097          	auipc	ra,0x0
    80003280:	ce6080e7          	jalr	-794(ra) # 80002f62 <bread>
    80003284:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003286:	40000613          	li	a2,1024
    8000328a:	4581                	li	a1,0
    8000328c:	05850513          	add	a0,a0,88
    80003290:	ffffe097          	auipc	ra,0xffffe
    80003294:	a3e080e7          	jalr	-1474(ra) # 80000cce <memset>
  log_write(bp);
    80003298:	854a                	mv	a0,s2
    8000329a:	00001097          	auipc	ra,0x1
    8000329e:	192080e7          	jalr	402(ra) # 8000442c <log_write>
  brelse(bp);
    800032a2:	854a                	mv	a0,s2
    800032a4:	00000097          	auipc	ra,0x0
    800032a8:	dee080e7          	jalr	-530(ra) # 80003092 <brelse>
}
    800032ac:	8526                	mv	a0,s1
    800032ae:	60e6                	ld	ra,88(sp)
    800032b0:	6446                	ld	s0,80(sp)
    800032b2:	64a6                	ld	s1,72(sp)
    800032b4:	6906                	ld	s2,64(sp)
    800032b6:	79e2                	ld	s3,56(sp)
    800032b8:	7a42                	ld	s4,48(sp)
    800032ba:	7aa2                	ld	s5,40(sp)
    800032bc:	7b02                	ld	s6,32(sp)
    800032be:	6be2                	ld	s7,24(sp)
    800032c0:	6c42                	ld	s8,16(sp)
    800032c2:	6ca2                	ld	s9,8(sp)
    800032c4:	6125                	add	sp,sp,96
    800032c6:	8082                	ret
    brelse(bp);
    800032c8:	854a                	mv	a0,s2
    800032ca:	00000097          	auipc	ra,0x0
    800032ce:	dc8080e7          	jalr	-568(ra) # 80003092 <brelse>
  for (b = 0; b < sb.size; b += BPB)
    800032d2:	015c87bb          	addw	a5,s9,s5
    800032d6:	00078a9b          	sext.w	s5,a5
    800032da:	004b2703          	lw	a4,4(s6)
    800032de:	06eaf163          	bgeu	s5,a4,80003340 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800032e2:	41fad79b          	sraw	a5,s5,0x1f
    800032e6:	0137d79b          	srlw	a5,a5,0x13
    800032ea:	015787bb          	addw	a5,a5,s5
    800032ee:	40d7d79b          	sraw	a5,a5,0xd
    800032f2:	01cb2583          	lw	a1,28(s6)
    800032f6:	9dbd                	addw	a1,a1,a5
    800032f8:	855e                	mv	a0,s7
    800032fa:	00000097          	auipc	ra,0x0
    800032fe:	c68080e7          	jalr	-920(ra) # 80002f62 <bread>
    80003302:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80003304:	004b2503          	lw	a0,4(s6)
    80003308:	000a849b          	sext.w	s1,s5
    8000330c:	8762                	mv	a4,s8
    8000330e:	faa4fde3          	bgeu	s1,a0,800032c8 <balloc+0xa6>
      m = 1 << (bi % 8);
    80003312:	00777693          	and	a3,a4,7
    80003316:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0)
    8000331a:	41f7579b          	sraw	a5,a4,0x1f
    8000331e:	01d7d79b          	srlw	a5,a5,0x1d
    80003322:	9fb9                	addw	a5,a5,a4
    80003324:	4037d79b          	sraw	a5,a5,0x3
    80003328:	00f90633          	add	a2,s2,a5
    8000332c:	05864603          	lbu	a2,88(a2)
    80003330:	00c6f5b3          	and	a1,a3,a2
    80003334:	d585                	beqz	a1,8000325c <balloc+0x3a>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80003336:	2705                	addw	a4,a4,1
    80003338:	2485                	addw	s1,s1,1
    8000333a:	fd471ae3          	bne	a4,s4,8000330e <balloc+0xec>
    8000333e:	b769                	j	800032c8 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80003340:	00005517          	auipc	a0,0x5
    80003344:	2f850513          	add	a0,a0,760 # 80008638 <syscalls+0x1d8>
    80003348:	ffffd097          	auipc	ra,0xffffd
    8000334c:	23e080e7          	jalr	574(ra) # 80000586 <printf>
  return 0;
    80003350:	4481                	li	s1,0
    80003352:	bfa9                	j	800032ac <balloc+0x8a>

0000000080003354 <bmap>:
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.

static uint
bmap(struct inode *ip, uint bn)
{
    80003354:	7139                	add	sp,sp,-64
    80003356:	fc06                	sd	ra,56(sp)
    80003358:	f822                	sd	s0,48(sp)
    8000335a:	f426                	sd	s1,40(sp)
    8000335c:	f04a                	sd	s2,32(sp)
    8000335e:	ec4e                	sd	s3,24(sp)
    80003360:	e852                	sd	s4,16(sp)
    80003362:	e456                	sd	s5,8(sp)
    80003364:	0080                	add	s0,sp,64
    80003366:	892a                	mv	s2,a0
    80003368:	84ae                	mv	s1,a1
    uint addr, *a;
    struct buf *bp;

    if (bn < NDIRECT) {
    8000336a:	47a9                	li	a5,10
    8000336c:	04b7e163          	bltu	a5,a1,800033ae <bmap+0x5a>
      
      
        // Direct block logic
        if ((addr = ip->addrs[bn]) == 0) {
    80003370:	02059793          	sll	a5,a1,0x20
    80003374:	01e7d493          	srl	s1,a5,0x1e
    80003378:	94aa                	add	s1,s1,a0
    8000337a:	0504aa03          	lw	s4,80(s1)
    8000337e:	000a0c63          	beqz	s4,80003396 <bmap+0x42>
        return addr;
    } else {
        // Out of range
        panic("bmap: out of range");
    }
}
    80003382:	8552                	mv	a0,s4
    80003384:	70e2                	ld	ra,56(sp)
    80003386:	7442                	ld	s0,48(sp)
    80003388:	74a2                	ld	s1,40(sp)
    8000338a:	7902                	ld	s2,32(sp)
    8000338c:	69e2                	ld	s3,24(sp)
    8000338e:	6a42                	ld	s4,16(sp)
    80003390:	6aa2                	ld	s5,8(sp)
    80003392:	6121                	add	sp,sp,64
    80003394:	8082                	ret
            addr = balloc(ip->dev);
    80003396:	4108                	lw	a0,0(a0)
    80003398:	00000097          	auipc	ra,0x0
    8000339c:	e8a080e7          	jalr	-374(ra) # 80003222 <balloc>
    800033a0:	00050a1b          	sext.w	s4,a0
            if (addr == 0)
    800033a4:	fc0a0fe3          	beqz	s4,80003382 <bmap+0x2e>
            ip->addrs[bn] = addr;
    800033a8:	0544a823          	sw	s4,80(s1)
    800033ac:	bfd9                	j	80003382 <bmap+0x2e>
    } else if (bn < NDIRECT + NINDIRECT) {
    800033ae:	10a00793          	li	a5,266
    800033b2:	08b7e363          	bltu	a5,a1,80003438 <bmap+0xe4>
        bn -= NDIRECT; // Adjust bn for indirect
    800033b6:	ff55849b          	addw	s1,a1,-11
        if ((addr = ip->addrs[NDIRECT]) == 0) {
    800033ba:	07c52a03          	lw	s4,124(a0)
    800033be:	000a1d63          	bnez	s4,800033d8 <bmap+0x84>
            addr = balloc(ip->dev);
    800033c2:	4108                	lw	a0,0(a0)
    800033c4:	00000097          	auipc	ra,0x0
    800033c8:	e5e080e7          	jalr	-418(ra) # 80003222 <balloc>
    800033cc:	00050a1b          	sext.w	s4,a0
            if (addr == 0)
    800033d0:	fa0a09e3          	beqz	s4,80003382 <bmap+0x2e>
            ip->addrs[NDIRECT] = addr;
    800033d4:	07492e23          	sw	s4,124(s2)
        bp = bread(ip->dev, addr);
    800033d8:	85d2                	mv	a1,s4
    800033da:	00092503          	lw	a0,0(s2)
    800033de:	00000097          	auipc	ra,0x0
    800033e2:	b84080e7          	jalr	-1148(ra) # 80002f62 <bread>
    800033e6:	89aa                	mv	s3,a0
        a = (uint*)bp->data;
    800033e8:	05850793          	add	a5,a0,88
        addr = a[bn];
    800033ec:	02049713          	sll	a4,s1,0x20
    800033f0:	01e75493          	srl	s1,a4,0x1e
    800033f4:	94be                	add	s1,s1,a5
    800033f6:	0004aa03          	lw	s4,0(s1)
        if (addr == 0) {
    800033fa:	020a1963          	bnez	s4,8000342c <bmap+0xd8>
            addr = balloc(ip->dev);
    800033fe:	00092503          	lw	a0,0(s2)
    80003402:	00000097          	auipc	ra,0x0
    80003406:	e20080e7          	jalr	-480(ra) # 80003222 <balloc>
    8000340a:	00050a1b          	sext.w	s4,a0
            if (addr == 0) {
    8000340e:	000a1863          	bnez	s4,8000341e <bmap+0xca>
                brelse(bp);
    80003412:	854e                	mv	a0,s3
    80003414:	00000097          	auipc	ra,0x0
    80003418:	c7e080e7          	jalr	-898(ra) # 80003092 <brelse>
                return 0; // Error handling
    8000341c:	b79d                	j	80003382 <bmap+0x2e>
            a[bn] = addr;
    8000341e:	0144a023          	sw	s4,0(s1)
            log_write(bp);
    80003422:	854e                	mv	a0,s3
    80003424:	00001097          	auipc	ra,0x1
    80003428:	008080e7          	jalr	8(ra) # 8000442c <log_write>
        brelse(bp);
    8000342c:	854e                	mv	a0,s3
    8000342e:	00000097          	auipc	ra,0x0
    80003432:	c64080e7          	jalr	-924(ra) # 80003092 <brelse>
        return addr;
    80003436:	b7b1                	j	80003382 <bmap+0x2e>
    } else if (bn < NDIRECT + NINDIRECT + NDOUBLY_INDIRECT) {
    80003438:	67c1                	lui	a5,0x10
    8000343a:	10a78793          	add	a5,a5,266 # 1010a <_entry-0x7ffefef6>
    8000343e:	12b7e863          	bltu	a5,a1,8000356e <bmap+0x21a>
        uint addr_double = ip->addrs[NDIRECT + 1];
    80003442:	08052a03          	lw	s4,128(a0)
        if (addr_double == 0) {
    80003446:	000a1d63          	bnez	s4,80003460 <bmap+0x10c>
            addr_double = balloc(ip->dev);
    8000344a:	4108                	lw	a0,0(a0)
    8000344c:	00000097          	auipc	ra,0x0
    80003450:	dd6080e7          	jalr	-554(ra) # 80003222 <balloc>
    80003454:	00050a1b          	sext.w	s4,a0
            if (addr_double == 0) {
    80003458:	f20a05e3          	beqz	s4,80003382 <bmap+0x2e>
            ip->addrs[NDIRECT + 1] = addr_double;
    8000345c:	09492023          	sw	s4,128(s2)
        bp = bread(ip->dev, addr_double);
    80003460:	85d2                	mv	a1,s4
    80003462:	00092503          	lw	a0,0(s2)
    80003466:	00000097          	auipc	ra,0x0
    8000346a:	afc080e7          	jalr	-1284(ra) # 80002f62 <bread>
    8000346e:	89aa                	mv	s3,a0
        uint addr_indirect = a[double_index];
    80003470:	05852a03          	lw	s4,88(a0)
        if (addr_indirect == 0) {
    80003474:	020a1363          	bnez	s4,8000349a <bmap+0x146>
            addr_indirect = balloc(ip->dev);
    80003478:	00092503          	lw	a0,0(s2)
    8000347c:	00000097          	auipc	ra,0x0
    80003480:	da6080e7          	jalr	-602(ra) # 80003222 <balloc>
    80003484:	00050a1b          	sext.w	s4,a0
            if (addr_indirect == 0) {
    80003488:	0a0a0a63          	beqz	s4,8000353c <bmap+0x1e8>
            a[double_index] = addr_indirect;
    8000348c:	0549ac23          	sw	s4,88(s3)
            log_write(bp);
    80003490:	854e                	mv	a0,s3
    80003492:	00001097          	auipc	ra,0x1
    80003496:	f9a080e7          	jalr	-102(ra) # 8000442c <log_write>
        bn -= NDIRECT + NINDIRECT; // Adjust bn for doubly indirect
    8000349a:	ef54849b          	addw	s1,s1,-267
        brelse(bp);
    8000349e:	854e                	mv	a0,s3
    800034a0:	00000097          	auipc	ra,0x0
    800034a4:	bf2080e7          	jalr	-1038(ra) # 80003092 <brelse>
        bp = bread(ip->dev, addr_indirect);
    800034a8:	85d2                	mv	a1,s4
    800034aa:	00092503          	lw	a0,0(s2)
    800034ae:	00000097          	auipc	ra,0x0
    800034b2:	ab4080e7          	jalr	-1356(ra) # 80002f62 <bread>
    800034b6:	89aa                	mv	s3,a0
        a = (uint*)bp->data;
    800034b8:	05850a93          	add	s5,a0,88
        uint addr_single = a[single_index];
    800034bc:	0084d79b          	srlw	a5,s1,0x8
    800034c0:	078a                	sll	a5,a5,0x2
    800034c2:	9abe                	add	s5,s5,a5
    800034c4:	000aaa03          	lw	s4,0(s5)
        if (addr_single == 0) {
    800034c8:	020a1363          	bnez	s4,800034ee <bmap+0x19a>
            addr_single = balloc(ip->dev);
    800034cc:	00092503          	lw	a0,0(s2)
    800034d0:	00000097          	auipc	ra,0x0
    800034d4:	d52080e7          	jalr	-686(ra) # 80003222 <balloc>
    800034d8:	00050a1b          	sext.w	s4,a0
            if (addr_single == 0) {
    800034dc:	060a0663          	beqz	s4,80003548 <bmap+0x1f4>
            a[single_index] = addr_single;
    800034e0:	014aa023          	sw	s4,0(s5)
            log_write(bp);
    800034e4:	854e                	mv	a0,s3
    800034e6:	00001097          	auipc	ra,0x1
    800034ea:	f46080e7          	jalr	-186(ra) # 8000442c <log_write>
        brelse(bp);
    800034ee:	854e                	mv	a0,s3
    800034f0:	00000097          	auipc	ra,0x0
    800034f4:	ba2080e7          	jalr	-1118(ra) # 80003092 <brelse>
        bp = bread(ip->dev, addr_single);
    800034f8:	85d2                	mv	a1,s4
    800034fa:	00092503          	lw	a0,0(s2)
    800034fe:	00000097          	auipc	ra,0x0
    80003502:	a64080e7          	jalr	-1436(ra) # 80002f62 <bread>
    80003506:	89aa                	mv	s3,a0
        a = (uint*)bp->data;
    80003508:	05850793          	add	a5,a0,88
        addr = a[pos];
    8000350c:	0ff4f493          	zext.b	s1,s1
    80003510:	048a                	sll	s1,s1,0x2
    80003512:	94be                	add	s1,s1,a5
    80003514:	0004aa03          	lw	s4,0(s1)
        if (addr == 0) {
    80003518:	040a1563          	bnez	s4,80003562 <bmap+0x20e>
            addr = balloc(ip->dev);
    8000351c:	00092503          	lw	a0,0(s2)
    80003520:	00000097          	auipc	ra,0x0
    80003524:	d02080e7          	jalr	-766(ra) # 80003222 <balloc>
    80003528:	00050a1b          	sext.w	s4,a0
            if (addr == 0) {
    8000352c:	020a1463          	bnez	s4,80003554 <bmap+0x200>
                brelse(bp);
    80003530:	854e                	mv	a0,s3
    80003532:	00000097          	auipc	ra,0x0
    80003536:	b60080e7          	jalr	-1184(ra) # 80003092 <brelse>
                return 0; // Error handling
    8000353a:	b5a1                	j	80003382 <bmap+0x2e>
                brelse(bp);
    8000353c:	854e                	mv	a0,s3
    8000353e:	00000097          	auipc	ra,0x0
    80003542:	b54080e7          	jalr	-1196(ra) # 80003092 <brelse>
                return 0; // Error handling
    80003546:	bd35                	j	80003382 <bmap+0x2e>
                brelse(bp);
    80003548:	854e                	mv	a0,s3
    8000354a:	00000097          	auipc	ra,0x0
    8000354e:	b48080e7          	jalr	-1208(ra) # 80003092 <brelse>
                return 0; // Error handling
    80003552:	bd05                	j	80003382 <bmap+0x2e>
            a[pos] = addr;
    80003554:	0144a023          	sw	s4,0(s1)
            log_write(bp);
    80003558:	854e                	mv	a0,s3
    8000355a:	00001097          	auipc	ra,0x1
    8000355e:	ed2080e7          	jalr	-302(ra) # 8000442c <log_write>
        brelse(bp);
    80003562:	854e                	mv	a0,s3
    80003564:	00000097          	auipc	ra,0x0
    80003568:	b2e080e7          	jalr	-1234(ra) # 80003092 <brelse>
        return addr;
    8000356c:	bd19                	j	80003382 <bmap+0x2e>
        panic("bmap: out of range");
    8000356e:	00005517          	auipc	a0,0x5
    80003572:	0e250513          	add	a0,a0,226 # 80008650 <syscalls+0x1f0>
    80003576:	ffffd097          	auipc	ra,0xffffd
    8000357a:	fc6080e7          	jalr	-58(ra) # 8000053c <panic>

000000008000357e <iget>:
{
    8000357e:	7179                	add	sp,sp,-48
    80003580:	f406                	sd	ra,40(sp)
    80003582:	f022                	sd	s0,32(sp)
    80003584:	ec26                	sd	s1,24(sp)
    80003586:	e84a                	sd	s2,16(sp)
    80003588:	e44e                	sd	s3,8(sp)
    8000358a:	e052                	sd	s4,0(sp)
    8000358c:	1800                	add	s0,sp,48
    8000358e:	89aa                	mv	s3,a0
    80003590:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003592:	0001c517          	auipc	a0,0x1c
    80003596:	bb650513          	add	a0,a0,-1098 # 8001f148 <itable>
    8000359a:	ffffd097          	auipc	ra,0xffffd
    8000359e:	638080e7          	jalr	1592(ra) # 80000bd2 <acquire>
  empty = 0;
    800035a2:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    800035a4:	0001c497          	auipc	s1,0x1c
    800035a8:	bbc48493          	add	s1,s1,-1092 # 8001f160 <itable+0x18>
    800035ac:	0001d697          	auipc	a3,0x1d
    800035b0:	64468693          	add	a3,a3,1604 # 80020bf0 <log>
    800035b4:	a039                	j	800035c2 <iget+0x44>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    800035b6:	02090b63          	beqz	s2,800035ec <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    800035ba:	08848493          	add	s1,s1,136
    800035be:	02d48a63          	beq	s1,a3,800035f2 <iget+0x74>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum)
    800035c2:	449c                	lw	a5,8(s1)
    800035c4:	fef059e3          	blez	a5,800035b6 <iget+0x38>
    800035c8:	4098                	lw	a4,0(s1)
    800035ca:	ff3716e3          	bne	a4,s3,800035b6 <iget+0x38>
    800035ce:	40d8                	lw	a4,4(s1)
    800035d0:	ff4713e3          	bne	a4,s4,800035b6 <iget+0x38>
      ip->ref++;
    800035d4:	2785                	addw	a5,a5,1
    800035d6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800035d8:	0001c517          	auipc	a0,0x1c
    800035dc:	b7050513          	add	a0,a0,-1168 # 8001f148 <itable>
    800035e0:	ffffd097          	auipc	ra,0xffffd
    800035e4:	6a6080e7          	jalr	1702(ra) # 80000c86 <release>
      return ip;
    800035e8:	8926                	mv	s2,s1
    800035ea:	a03d                	j	80003618 <iget+0x9a>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    800035ec:	f7f9                	bnez	a5,800035ba <iget+0x3c>
    800035ee:	8926                	mv	s2,s1
    800035f0:	b7e9                	j	800035ba <iget+0x3c>
  if (empty == 0)
    800035f2:	02090c63          	beqz	s2,8000362a <iget+0xac>
  ip->dev = dev;
    800035f6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800035fa:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800035fe:	4785                	li	a5,1
    80003600:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003604:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003608:	0001c517          	auipc	a0,0x1c
    8000360c:	b4050513          	add	a0,a0,-1216 # 8001f148 <itable>
    80003610:	ffffd097          	auipc	ra,0xffffd
    80003614:	676080e7          	jalr	1654(ra) # 80000c86 <release>
}
    80003618:	854a                	mv	a0,s2
    8000361a:	70a2                	ld	ra,40(sp)
    8000361c:	7402                	ld	s0,32(sp)
    8000361e:	64e2                	ld	s1,24(sp)
    80003620:	6942                	ld	s2,16(sp)
    80003622:	69a2                	ld	s3,8(sp)
    80003624:	6a02                	ld	s4,0(sp)
    80003626:	6145                	add	sp,sp,48
    80003628:	8082                	ret
    panic("iget: no inodes");
    8000362a:	00005517          	auipc	a0,0x5
    8000362e:	03e50513          	add	a0,a0,62 # 80008668 <syscalls+0x208>
    80003632:	ffffd097          	auipc	ra,0xffffd
    80003636:	f0a080e7          	jalr	-246(ra) # 8000053c <panic>

000000008000363a <fsinit>:
{
    8000363a:	7179                	add	sp,sp,-48
    8000363c:	f406                	sd	ra,40(sp)
    8000363e:	f022                	sd	s0,32(sp)
    80003640:	ec26                	sd	s1,24(sp)
    80003642:	e84a                	sd	s2,16(sp)
    80003644:	e44e                	sd	s3,8(sp)
    80003646:	1800                	add	s0,sp,48
    80003648:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000364a:	4585                	li	a1,1
    8000364c:	00000097          	auipc	ra,0x0
    80003650:	916080e7          	jalr	-1770(ra) # 80002f62 <bread>
    80003654:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003656:	0001c997          	auipc	s3,0x1c
    8000365a:	ad298993          	add	s3,s3,-1326 # 8001f128 <sb>
    8000365e:	02000613          	li	a2,32
    80003662:	05850593          	add	a1,a0,88
    80003666:	854e                	mv	a0,s3
    80003668:	ffffd097          	auipc	ra,0xffffd
    8000366c:	6c2080e7          	jalr	1730(ra) # 80000d2a <memmove>
  brelse(bp);
    80003670:	8526                	mv	a0,s1
    80003672:	00000097          	auipc	ra,0x0
    80003676:	a20080e7          	jalr	-1504(ra) # 80003092 <brelse>
  if (sb.magic != FSMAGIC)
    8000367a:	0009a703          	lw	a4,0(s3)
    8000367e:	102037b7          	lui	a5,0x10203
    80003682:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003686:	02f71263          	bne	a4,a5,800036aa <fsinit+0x70>
  initlog(dev, &sb);
    8000368a:	0001c597          	auipc	a1,0x1c
    8000368e:	a9e58593          	add	a1,a1,-1378 # 8001f128 <sb>
    80003692:	854a                	mv	a0,s2
    80003694:	00001097          	auipc	ra,0x1
    80003698:	b2e080e7          	jalr	-1234(ra) # 800041c2 <initlog>
}
    8000369c:	70a2                	ld	ra,40(sp)
    8000369e:	7402                	ld	s0,32(sp)
    800036a0:	64e2                	ld	s1,24(sp)
    800036a2:	6942                	ld	s2,16(sp)
    800036a4:	69a2                	ld	s3,8(sp)
    800036a6:	6145                	add	sp,sp,48
    800036a8:	8082                	ret
    panic("invalid file system");
    800036aa:	00005517          	auipc	a0,0x5
    800036ae:	fce50513          	add	a0,a0,-50 # 80008678 <syscalls+0x218>
    800036b2:	ffffd097          	auipc	ra,0xffffd
    800036b6:	e8a080e7          	jalr	-374(ra) # 8000053c <panic>

00000000800036ba <iinit>:
{
    800036ba:	7179                	add	sp,sp,-48
    800036bc:	f406                	sd	ra,40(sp)
    800036be:	f022                	sd	s0,32(sp)
    800036c0:	ec26                	sd	s1,24(sp)
    800036c2:	e84a                	sd	s2,16(sp)
    800036c4:	e44e                	sd	s3,8(sp)
    800036c6:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    800036c8:	00005597          	auipc	a1,0x5
    800036cc:	fc858593          	add	a1,a1,-56 # 80008690 <syscalls+0x230>
    800036d0:	0001c517          	auipc	a0,0x1c
    800036d4:	a7850513          	add	a0,a0,-1416 # 8001f148 <itable>
    800036d8:	ffffd097          	auipc	ra,0xffffd
    800036dc:	46a080e7          	jalr	1130(ra) # 80000b42 <initlock>
  for (i = 0; i < NINODE; i++)
    800036e0:	0001c497          	auipc	s1,0x1c
    800036e4:	a9048493          	add	s1,s1,-1392 # 8001f170 <itable+0x28>
    800036e8:	0001d997          	auipc	s3,0x1d
    800036ec:	51898993          	add	s3,s3,1304 # 80020c00 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800036f0:	00005917          	auipc	s2,0x5
    800036f4:	fa890913          	add	s2,s2,-88 # 80008698 <syscalls+0x238>
    800036f8:	85ca                	mv	a1,s2
    800036fa:	8526                	mv	a0,s1
    800036fc:	00001097          	auipc	ra,0x1
    80003700:	e14080e7          	jalr	-492(ra) # 80004510 <initsleeplock>
  for (i = 0; i < NINODE; i++)
    80003704:	08848493          	add	s1,s1,136
    80003708:	ff3498e3          	bne	s1,s3,800036f8 <iinit+0x3e>
}
    8000370c:	70a2                	ld	ra,40(sp)
    8000370e:	7402                	ld	s0,32(sp)
    80003710:	64e2                	ld	s1,24(sp)
    80003712:	6942                	ld	s2,16(sp)
    80003714:	69a2                	ld	s3,8(sp)
    80003716:	6145                	add	sp,sp,48
    80003718:	8082                	ret

000000008000371a <ialloc>:
{
    8000371a:	7139                	add	sp,sp,-64
    8000371c:	fc06                	sd	ra,56(sp)
    8000371e:	f822                	sd	s0,48(sp)
    80003720:	f426                	sd	s1,40(sp)
    80003722:	f04a                	sd	s2,32(sp)
    80003724:	ec4e                	sd	s3,24(sp)
    80003726:	e852                	sd	s4,16(sp)
    80003728:	e456                	sd	s5,8(sp)
    8000372a:	e05a                	sd	s6,0(sp)
    8000372c:	0080                	add	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++)
    8000372e:	0001c717          	auipc	a4,0x1c
    80003732:	a0672703          	lw	a4,-1530(a4) # 8001f134 <sb+0xc>
    80003736:	4785                	li	a5,1
    80003738:	04e7f863          	bgeu	a5,a4,80003788 <ialloc+0x6e>
    8000373c:	8aaa                	mv	s5,a0
    8000373e:	8b2e                	mv	s6,a1
    80003740:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003742:	0001ca17          	auipc	s4,0x1c
    80003746:	9e6a0a13          	add	s4,s4,-1562 # 8001f128 <sb>
    8000374a:	00495593          	srl	a1,s2,0x4
    8000374e:	018a2783          	lw	a5,24(s4)
    80003752:	9dbd                	addw	a1,a1,a5
    80003754:	8556                	mv	a0,s5
    80003756:	00000097          	auipc	ra,0x0
    8000375a:	80c080e7          	jalr	-2036(ra) # 80002f62 <bread>
    8000375e:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80003760:	05850993          	add	s3,a0,88
    80003764:	00f97793          	and	a5,s2,15
    80003768:	079a                	sll	a5,a5,0x6
    8000376a:	99be                	add	s3,s3,a5
    if (dip->type == 0)
    8000376c:	00099783          	lh	a5,0(s3)
    80003770:	cf9d                	beqz	a5,800037ae <ialloc+0x94>
    brelse(bp);
    80003772:	00000097          	auipc	ra,0x0
    80003776:	920080e7          	jalr	-1760(ra) # 80003092 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++)
    8000377a:	0905                	add	s2,s2,1
    8000377c:	00ca2703          	lw	a4,12(s4)
    80003780:	0009079b          	sext.w	a5,s2
    80003784:	fce7e3e3          	bltu	a5,a4,8000374a <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80003788:	00005517          	auipc	a0,0x5
    8000378c:	f1850513          	add	a0,a0,-232 # 800086a0 <syscalls+0x240>
    80003790:	ffffd097          	auipc	ra,0xffffd
    80003794:	df6080e7          	jalr	-522(ra) # 80000586 <printf>
  return 0;
    80003798:	4501                	li	a0,0
}
    8000379a:	70e2                	ld	ra,56(sp)
    8000379c:	7442                	ld	s0,48(sp)
    8000379e:	74a2                	ld	s1,40(sp)
    800037a0:	7902                	ld	s2,32(sp)
    800037a2:	69e2                	ld	s3,24(sp)
    800037a4:	6a42                	ld	s4,16(sp)
    800037a6:	6aa2                	ld	s5,8(sp)
    800037a8:	6b02                	ld	s6,0(sp)
    800037aa:	6121                	add	sp,sp,64
    800037ac:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800037ae:	04000613          	li	a2,64
    800037b2:	4581                	li	a1,0
    800037b4:	854e                	mv	a0,s3
    800037b6:	ffffd097          	auipc	ra,0xffffd
    800037ba:	518080e7          	jalr	1304(ra) # 80000cce <memset>
      dip->type = type;
    800037be:	01699023          	sh	s6,0(s3)
      log_write(bp); // mark it allocated on the disk
    800037c2:	8526                	mv	a0,s1
    800037c4:	00001097          	auipc	ra,0x1
    800037c8:	c68080e7          	jalr	-920(ra) # 8000442c <log_write>
      brelse(bp);
    800037cc:	8526                	mv	a0,s1
    800037ce:	00000097          	auipc	ra,0x0
    800037d2:	8c4080e7          	jalr	-1852(ra) # 80003092 <brelse>
      return iget(dev, inum);
    800037d6:	0009059b          	sext.w	a1,s2
    800037da:	8556                	mv	a0,s5
    800037dc:	00000097          	auipc	ra,0x0
    800037e0:	da2080e7          	jalr	-606(ra) # 8000357e <iget>
    800037e4:	bf5d                	j	8000379a <ialloc+0x80>

00000000800037e6 <iupdate>:
{
    800037e6:	1101                	add	sp,sp,-32
    800037e8:	ec06                	sd	ra,24(sp)
    800037ea:	e822                	sd	s0,16(sp)
    800037ec:	e426                	sd	s1,8(sp)
    800037ee:	e04a                	sd	s2,0(sp)
    800037f0:	1000                	add	s0,sp,32
    800037f2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800037f4:	415c                	lw	a5,4(a0)
    800037f6:	0047d79b          	srlw	a5,a5,0x4
    800037fa:	0001c597          	auipc	a1,0x1c
    800037fe:	9465a583          	lw	a1,-1722(a1) # 8001f140 <sb+0x18>
    80003802:	9dbd                	addw	a1,a1,a5
    80003804:	4108                	lw	a0,0(a0)
    80003806:	fffff097          	auipc	ra,0xfffff
    8000380a:	75c080e7          	jalr	1884(ra) # 80002f62 <bread>
    8000380e:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80003810:	05850793          	add	a5,a0,88
    80003814:	40d8                	lw	a4,4(s1)
    80003816:	8b3d                	and	a4,a4,15
    80003818:	071a                	sll	a4,a4,0x6
    8000381a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000381c:	04449703          	lh	a4,68(s1)
    80003820:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003824:	04649703          	lh	a4,70(s1)
    80003828:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000382c:	04849703          	lh	a4,72(s1)
    80003830:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003834:	04a49703          	lh	a4,74(s1)
    80003838:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000383c:	44f8                	lw	a4,76(s1)
    8000383e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003840:	03400613          	li	a2,52
    80003844:	05048593          	add	a1,s1,80
    80003848:	00c78513          	add	a0,a5,12
    8000384c:	ffffd097          	auipc	ra,0xffffd
    80003850:	4de080e7          	jalr	1246(ra) # 80000d2a <memmove>
  log_write(bp);
    80003854:	854a                	mv	a0,s2
    80003856:	00001097          	auipc	ra,0x1
    8000385a:	bd6080e7          	jalr	-1066(ra) # 8000442c <log_write>
  brelse(bp);
    8000385e:	854a                	mv	a0,s2
    80003860:	00000097          	auipc	ra,0x0
    80003864:	832080e7          	jalr	-1998(ra) # 80003092 <brelse>
}
    80003868:	60e2                	ld	ra,24(sp)
    8000386a:	6442                	ld	s0,16(sp)
    8000386c:	64a2                	ld	s1,8(sp)
    8000386e:	6902                	ld	s2,0(sp)
    80003870:	6105                	add	sp,sp,32
    80003872:	8082                	ret

0000000080003874 <idup>:
{
    80003874:	1101                	add	sp,sp,-32
    80003876:	ec06                	sd	ra,24(sp)
    80003878:	e822                	sd	s0,16(sp)
    8000387a:	e426                	sd	s1,8(sp)
    8000387c:	1000                	add	s0,sp,32
    8000387e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003880:	0001c517          	auipc	a0,0x1c
    80003884:	8c850513          	add	a0,a0,-1848 # 8001f148 <itable>
    80003888:	ffffd097          	auipc	ra,0xffffd
    8000388c:	34a080e7          	jalr	842(ra) # 80000bd2 <acquire>
  ip->ref++;
    80003890:	449c                	lw	a5,8(s1)
    80003892:	2785                	addw	a5,a5,1
    80003894:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003896:	0001c517          	auipc	a0,0x1c
    8000389a:	8b250513          	add	a0,a0,-1870 # 8001f148 <itable>
    8000389e:	ffffd097          	auipc	ra,0xffffd
    800038a2:	3e8080e7          	jalr	1000(ra) # 80000c86 <release>
}
    800038a6:	8526                	mv	a0,s1
    800038a8:	60e2                	ld	ra,24(sp)
    800038aa:	6442                	ld	s0,16(sp)
    800038ac:	64a2                	ld	s1,8(sp)
    800038ae:	6105                	add	sp,sp,32
    800038b0:	8082                	ret

00000000800038b2 <ilock>:
{
    800038b2:	1101                	add	sp,sp,-32
    800038b4:	ec06                	sd	ra,24(sp)
    800038b6:	e822                	sd	s0,16(sp)
    800038b8:	e426                	sd	s1,8(sp)
    800038ba:	e04a                	sd	s2,0(sp)
    800038bc:	1000                	add	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    800038be:	c115                	beqz	a0,800038e2 <ilock+0x30>
    800038c0:	84aa                	mv	s1,a0
    800038c2:	451c                	lw	a5,8(a0)
    800038c4:	00f05f63          	blez	a5,800038e2 <ilock+0x30>
  acquiresleep(&ip->lock);
    800038c8:	0541                	add	a0,a0,16
    800038ca:	00001097          	auipc	ra,0x1
    800038ce:	c80080e7          	jalr	-896(ra) # 8000454a <acquiresleep>
  if (ip->valid == 0)
    800038d2:	40bc                	lw	a5,64(s1)
    800038d4:	cf99                	beqz	a5,800038f2 <ilock+0x40>
}
    800038d6:	60e2                	ld	ra,24(sp)
    800038d8:	6442                	ld	s0,16(sp)
    800038da:	64a2                	ld	s1,8(sp)
    800038dc:	6902                	ld	s2,0(sp)
    800038de:	6105                	add	sp,sp,32
    800038e0:	8082                	ret
    panic("ilock");
    800038e2:	00005517          	auipc	a0,0x5
    800038e6:	dd650513          	add	a0,a0,-554 # 800086b8 <syscalls+0x258>
    800038ea:	ffffd097          	auipc	ra,0xffffd
    800038ee:	c52080e7          	jalr	-942(ra) # 8000053c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800038f2:	40dc                	lw	a5,4(s1)
    800038f4:	0047d79b          	srlw	a5,a5,0x4
    800038f8:	0001c597          	auipc	a1,0x1c
    800038fc:	8485a583          	lw	a1,-1976(a1) # 8001f140 <sb+0x18>
    80003900:	9dbd                	addw	a1,a1,a5
    80003902:	4088                	lw	a0,0(s1)
    80003904:	fffff097          	auipc	ra,0xfffff
    80003908:	65e080e7          	jalr	1630(ra) # 80002f62 <bread>
    8000390c:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    8000390e:	05850593          	add	a1,a0,88
    80003912:	40dc                	lw	a5,4(s1)
    80003914:	8bbd                	and	a5,a5,15
    80003916:	079a                	sll	a5,a5,0x6
    80003918:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000391a:	00059783          	lh	a5,0(a1)
    8000391e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003922:	00259783          	lh	a5,2(a1)
    80003926:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000392a:	00459783          	lh	a5,4(a1)
    8000392e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003932:	00659783          	lh	a5,6(a1)
    80003936:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000393a:	459c                	lw	a5,8(a1)
    8000393c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000393e:	03400613          	li	a2,52
    80003942:	05b1                	add	a1,a1,12
    80003944:	05048513          	add	a0,s1,80
    80003948:	ffffd097          	auipc	ra,0xffffd
    8000394c:	3e2080e7          	jalr	994(ra) # 80000d2a <memmove>
    brelse(bp);
    80003950:	854a                	mv	a0,s2
    80003952:	fffff097          	auipc	ra,0xfffff
    80003956:	740080e7          	jalr	1856(ra) # 80003092 <brelse>
    ip->valid = 1;
    8000395a:	4785                	li	a5,1
    8000395c:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    8000395e:	04449783          	lh	a5,68(s1)
    80003962:	fbb5                	bnez	a5,800038d6 <ilock+0x24>
      panic("ilock: no type");
    80003964:	00005517          	auipc	a0,0x5
    80003968:	d5c50513          	add	a0,a0,-676 # 800086c0 <syscalls+0x260>
    8000396c:	ffffd097          	auipc	ra,0xffffd
    80003970:	bd0080e7          	jalr	-1072(ra) # 8000053c <panic>

0000000080003974 <iunlock>:
{
    80003974:	1101                	add	sp,sp,-32
    80003976:	ec06                	sd	ra,24(sp)
    80003978:	e822                	sd	s0,16(sp)
    8000397a:	e426                	sd	s1,8(sp)
    8000397c:	e04a                	sd	s2,0(sp)
    8000397e:	1000                	add	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003980:	c905                	beqz	a0,800039b0 <iunlock+0x3c>
    80003982:	84aa                	mv	s1,a0
    80003984:	01050913          	add	s2,a0,16
    80003988:	854a                	mv	a0,s2
    8000398a:	00001097          	auipc	ra,0x1
    8000398e:	c5a080e7          	jalr	-934(ra) # 800045e4 <holdingsleep>
    80003992:	cd19                	beqz	a0,800039b0 <iunlock+0x3c>
    80003994:	449c                	lw	a5,8(s1)
    80003996:	00f05d63          	blez	a5,800039b0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    8000399a:	854a                	mv	a0,s2
    8000399c:	00001097          	auipc	ra,0x1
    800039a0:	c04080e7          	jalr	-1020(ra) # 800045a0 <releasesleep>
}
    800039a4:	60e2                	ld	ra,24(sp)
    800039a6:	6442                	ld	s0,16(sp)
    800039a8:	64a2                	ld	s1,8(sp)
    800039aa:	6902                	ld	s2,0(sp)
    800039ac:	6105                	add	sp,sp,32
    800039ae:	8082                	ret
    panic("iunlock");
    800039b0:	00005517          	auipc	a0,0x5
    800039b4:	d2050513          	add	a0,a0,-736 # 800086d0 <syscalls+0x270>
    800039b8:	ffffd097          	auipc	ra,0xffffd
    800039bc:	b84080e7          	jalr	-1148(ra) # 8000053c <panic>

00000000800039c0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800039c0:	7179                	add	sp,sp,-48
    800039c2:	f406                	sd	ra,40(sp)
    800039c4:	f022                	sd	s0,32(sp)
    800039c6:	ec26                	sd	s1,24(sp)
    800039c8:	e84a                	sd	s2,16(sp)
    800039ca:	e44e                	sd	s3,8(sp)
    800039cc:	e052                	sd	s4,0(sp)
    800039ce:	1800                	add	s0,sp,48
    800039d0:	89aa                	mv	s3,a0
    int i;
    struct buf *bp;

    // Free direct blocks
    for (i = 0; i < NDIRECT; i++) {
    800039d2:	05050493          	add	s1,a0,80
    800039d6:	07c50913          	add	s2,a0,124
    800039da:	a021                	j	800039e2 <itrunc+0x22>
    800039dc:	0491                	add	s1,s1,4
    800039de:	01248d63          	beq	s1,s2,800039f8 <itrunc+0x38>
        if (ip->addrs[i]) {
    800039e2:	408c                	lw	a1,0(s1)
    800039e4:	dde5                	beqz	a1,800039dc <itrunc+0x1c>
            bfree(ip->dev, ip->addrs[i]);
    800039e6:	0009a503          	lw	a0,0(s3)
    800039ea:	fffff097          	auipc	ra,0xfffff
    800039ee:	7bc080e7          	jalr	1980(ra) # 800031a6 <bfree>
            ip->addrs[i] = 0;
    800039f2:	0004a023          	sw	zero,0(s1)
    800039f6:	b7dd                	j	800039dc <itrunc+0x1c>
        }
    }
  
    // Free the indirect block
    if (ip->addrs[NDIRECT]) {
    800039f8:	07c9a583          	lw	a1,124(s3)
    800039fc:	e185                	bnez	a1,80003a1c <itrunc+0x5c>
        brelse(bp);
        bfree(ip->dev, ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }
    
    ip->size = 0;
    800039fe:	0409a623          	sw	zero,76(s3)
    iupdate(ip);
    80003a02:	854e                	mv	a0,s3
    80003a04:	00000097          	auipc	ra,0x0
    80003a08:	de2080e7          	jalr	-542(ra) # 800037e6 <iupdate>
}
    80003a0c:	70a2                	ld	ra,40(sp)
    80003a0e:	7402                	ld	s0,32(sp)
    80003a10:	64e2                	ld	s1,24(sp)
    80003a12:	6942                	ld	s2,16(sp)
    80003a14:	69a2                	ld	s3,8(sp)
    80003a16:	6a02                	ld	s4,0(sp)
    80003a18:	6145                	add	sp,sp,48
    80003a1a:	8082                	ret
        bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003a1c:	0009a503          	lw	a0,0(s3)
    80003a20:	fffff097          	auipc	ra,0xfffff
    80003a24:	542080e7          	jalr	1346(ra) # 80002f62 <bread>
    80003a28:	8a2a                	mv	s4,a0
        for (i = 0; i < NINDIRECT; i++) {
    80003a2a:	05850493          	add	s1,a0,88
    80003a2e:	45850913          	add	s2,a0,1112
    80003a32:	a021                	j	80003a3a <itrunc+0x7a>
    80003a34:	0491                	add	s1,s1,4
    80003a36:	01248b63          	beq	s1,s2,80003a4c <itrunc+0x8c>
            if (a[i]) {
    80003a3a:	408c                	lw	a1,0(s1)
    80003a3c:	dde5                	beqz	a1,80003a34 <itrunc+0x74>
                bfree(ip->dev, a[i]);
    80003a3e:	0009a503          	lw	a0,0(s3)
    80003a42:	fffff097          	auipc	ra,0xfffff
    80003a46:	764080e7          	jalr	1892(ra) # 800031a6 <bfree>
    80003a4a:	b7ed                	j	80003a34 <itrunc+0x74>
        brelse(bp);
    80003a4c:	8552                	mv	a0,s4
    80003a4e:	fffff097          	auipc	ra,0xfffff
    80003a52:	644080e7          	jalr	1604(ra) # 80003092 <brelse>
        bfree(ip->dev, ip->addrs[NDIRECT]);
    80003a56:	07c9a583          	lw	a1,124(s3)
    80003a5a:	0009a503          	lw	a0,0(s3)
    80003a5e:	fffff097          	auipc	ra,0xfffff
    80003a62:	748080e7          	jalr	1864(ra) # 800031a6 <bfree>
        ip->addrs[NDIRECT] = 0;
    80003a66:	0609ae23          	sw	zero,124(s3)
    80003a6a:	bf51                	j	800039fe <itrunc+0x3e>

0000000080003a6c <iput>:
{
    80003a6c:	1101                	add	sp,sp,-32
    80003a6e:	ec06                	sd	ra,24(sp)
    80003a70:	e822                	sd	s0,16(sp)
    80003a72:	e426                	sd	s1,8(sp)
    80003a74:	e04a                	sd	s2,0(sp)
    80003a76:	1000                	add	s0,sp,32
    80003a78:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003a7a:	0001b517          	auipc	a0,0x1b
    80003a7e:	6ce50513          	add	a0,a0,1742 # 8001f148 <itable>
    80003a82:	ffffd097          	auipc	ra,0xffffd
    80003a86:	150080e7          	jalr	336(ra) # 80000bd2 <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80003a8a:	4498                	lw	a4,8(s1)
    80003a8c:	4785                	li	a5,1
    80003a8e:	02f70363          	beq	a4,a5,80003ab4 <iput+0x48>
  ip->ref--;
    80003a92:	449c                	lw	a5,8(s1)
    80003a94:	37fd                	addw	a5,a5,-1
    80003a96:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003a98:	0001b517          	auipc	a0,0x1b
    80003a9c:	6b050513          	add	a0,a0,1712 # 8001f148 <itable>
    80003aa0:	ffffd097          	auipc	ra,0xffffd
    80003aa4:	1e6080e7          	jalr	486(ra) # 80000c86 <release>
}
    80003aa8:	60e2                	ld	ra,24(sp)
    80003aaa:	6442                	ld	s0,16(sp)
    80003aac:	64a2                	ld	s1,8(sp)
    80003aae:	6902                	ld	s2,0(sp)
    80003ab0:	6105                	add	sp,sp,32
    80003ab2:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80003ab4:	40bc                	lw	a5,64(s1)
    80003ab6:	dff1                	beqz	a5,80003a92 <iput+0x26>
    80003ab8:	04a49783          	lh	a5,74(s1)
    80003abc:	fbf9                	bnez	a5,80003a92 <iput+0x26>
    acquiresleep(&ip->lock);
    80003abe:	01048913          	add	s2,s1,16
    80003ac2:	854a                	mv	a0,s2
    80003ac4:	00001097          	auipc	ra,0x1
    80003ac8:	a86080e7          	jalr	-1402(ra) # 8000454a <acquiresleep>
    release(&itable.lock);
    80003acc:	0001b517          	auipc	a0,0x1b
    80003ad0:	67c50513          	add	a0,a0,1660 # 8001f148 <itable>
    80003ad4:	ffffd097          	auipc	ra,0xffffd
    80003ad8:	1b2080e7          	jalr	434(ra) # 80000c86 <release>
    itrunc(ip);
    80003adc:	8526                	mv	a0,s1
    80003ade:	00000097          	auipc	ra,0x0
    80003ae2:	ee2080e7          	jalr	-286(ra) # 800039c0 <itrunc>
    ip->type = 0;
    80003ae6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003aea:	8526                	mv	a0,s1
    80003aec:	00000097          	auipc	ra,0x0
    80003af0:	cfa080e7          	jalr	-774(ra) # 800037e6 <iupdate>
    ip->valid = 0;
    80003af4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003af8:	854a                	mv	a0,s2
    80003afa:	00001097          	auipc	ra,0x1
    80003afe:	aa6080e7          	jalr	-1370(ra) # 800045a0 <releasesleep>
    acquire(&itable.lock);
    80003b02:	0001b517          	auipc	a0,0x1b
    80003b06:	64650513          	add	a0,a0,1606 # 8001f148 <itable>
    80003b0a:	ffffd097          	auipc	ra,0xffffd
    80003b0e:	0c8080e7          	jalr	200(ra) # 80000bd2 <acquire>
    80003b12:	b741                	j	80003a92 <iput+0x26>

0000000080003b14 <iunlockput>:
{
    80003b14:	1101                	add	sp,sp,-32
    80003b16:	ec06                	sd	ra,24(sp)
    80003b18:	e822                	sd	s0,16(sp)
    80003b1a:	e426                	sd	s1,8(sp)
    80003b1c:	1000                	add	s0,sp,32
    80003b1e:	84aa                	mv	s1,a0
  iunlock(ip);
    80003b20:	00000097          	auipc	ra,0x0
    80003b24:	e54080e7          	jalr	-428(ra) # 80003974 <iunlock>
  iput(ip);
    80003b28:	8526                	mv	a0,s1
    80003b2a:	00000097          	auipc	ra,0x0
    80003b2e:	f42080e7          	jalr	-190(ra) # 80003a6c <iput>
}
    80003b32:	60e2                	ld	ra,24(sp)
    80003b34:	6442                	ld	s0,16(sp)
    80003b36:	64a2                	ld	s1,8(sp)
    80003b38:	6105                	add	sp,sp,32
    80003b3a:	8082                	ret

0000000080003b3c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st)
{
    80003b3c:	1141                	add	sp,sp,-16
    80003b3e:	e422                	sd	s0,8(sp)
    80003b40:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80003b42:	411c                	lw	a5,0(a0)
    80003b44:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003b46:	415c                	lw	a5,4(a0)
    80003b48:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003b4a:	04451783          	lh	a5,68(a0)
    80003b4e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003b52:	04a51783          	lh	a5,74(a0)
    80003b56:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003b5a:	04c56783          	lwu	a5,76(a0)
    80003b5e:	e99c                	sd	a5,16(a1)
}
    80003b60:	6422                	ld	s0,8(sp)
    80003b62:	0141                	add	sp,sp,16
    80003b64:	8082                	ret

0000000080003b66 <readi>:
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80003b66:	457c                	lw	a5,76(a0)
    80003b68:	0ed7e963          	bltu	a5,a3,80003c5a <readi+0xf4>
{
    80003b6c:	7159                	add	sp,sp,-112
    80003b6e:	f486                	sd	ra,104(sp)
    80003b70:	f0a2                	sd	s0,96(sp)
    80003b72:	eca6                	sd	s1,88(sp)
    80003b74:	e8ca                	sd	s2,80(sp)
    80003b76:	e4ce                	sd	s3,72(sp)
    80003b78:	e0d2                	sd	s4,64(sp)
    80003b7a:	fc56                	sd	s5,56(sp)
    80003b7c:	f85a                	sd	s6,48(sp)
    80003b7e:	f45e                	sd	s7,40(sp)
    80003b80:	f062                	sd	s8,32(sp)
    80003b82:	ec66                	sd	s9,24(sp)
    80003b84:	e86a                	sd	s10,16(sp)
    80003b86:	e46e                	sd	s11,8(sp)
    80003b88:	1880                	add	s0,sp,112
    80003b8a:	8b2a                	mv	s6,a0
    80003b8c:	8bae                	mv	s7,a1
    80003b8e:	8a32                	mv	s4,a2
    80003b90:	84b6                	mv	s1,a3
    80003b92:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    80003b94:	9f35                	addw	a4,a4,a3
    return 0;
    80003b96:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    80003b98:	0ad76063          	bltu	a4,a3,80003c38 <readi+0xd2>
  if (off + n > ip->size)
    80003b9c:	00e7f463          	bgeu	a5,a4,80003ba4 <readi+0x3e>
    n = ip->size - off;
    80003ba0:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80003ba4:	0a0a8963          	beqz	s5,80003c56 <readi+0xf0>
    80003ba8:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
   
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003baa:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1)
    80003bae:	5c7d                	li	s8,-1
    80003bb0:	a82d                	j	80003bea <readi+0x84>
    80003bb2:	020d1d93          	sll	s11,s10,0x20
    80003bb6:	020ddd93          	srl	s11,s11,0x20
    80003bba:	05890613          	add	a2,s2,88
    80003bbe:	86ee                	mv	a3,s11
    80003bc0:	963a                	add	a2,a2,a4
    80003bc2:	85d2                	mv	a1,s4
    80003bc4:	855e                	mv	a0,s7
    80003bc6:	fffff097          	auipc	ra,0xfffff
    80003bca:	890080e7          	jalr	-1904(ra) # 80002456 <either_copyout>
    80003bce:	05850d63          	beq	a0,s8,80003c28 <readi+0xc2>
    {
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003bd2:	854a                	mv	a0,s2
    80003bd4:	fffff097          	auipc	ra,0xfffff
    80003bd8:	4be080e7          	jalr	1214(ra) # 80003092 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80003bdc:	013d09bb          	addw	s3,s10,s3
    80003be0:	009d04bb          	addw	s1,s10,s1
    80003be4:	9a6e                	add	s4,s4,s11
    80003be6:	0559f763          	bgeu	s3,s5,80003c34 <readi+0xce>
    uint addr = bmap(ip, off / BSIZE);
    80003bea:	00a4d59b          	srlw	a1,s1,0xa
    80003bee:	855a                	mv	a0,s6
    80003bf0:	fffff097          	auipc	ra,0xfffff
    80003bf4:	764080e7          	jalr	1892(ra) # 80003354 <bmap>
    80003bf8:	0005059b          	sext.w	a1,a0
    if (addr == 0)
    80003bfc:	cd85                	beqz	a1,80003c34 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003bfe:	000b2503          	lw	a0,0(s6)
    80003c02:	fffff097          	auipc	ra,0xfffff
    80003c06:	360080e7          	jalr	864(ra) # 80002f62 <bread>
    80003c0a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003c0c:	3ff4f713          	and	a4,s1,1023
    80003c10:	40ec87bb          	subw	a5,s9,a4
    80003c14:	413a86bb          	subw	a3,s5,s3
    80003c18:	8d3e                	mv	s10,a5
    80003c1a:	2781                	sext.w	a5,a5
    80003c1c:	0006861b          	sext.w	a2,a3
    80003c20:	f8f679e3          	bgeu	a2,a5,80003bb2 <readi+0x4c>
    80003c24:	8d36                	mv	s10,a3
    80003c26:	b771                	j	80003bb2 <readi+0x4c>
      brelse(bp);
    80003c28:	854a                	mv	a0,s2
    80003c2a:	fffff097          	auipc	ra,0xfffff
    80003c2e:	468080e7          	jalr	1128(ra) # 80003092 <brelse>
      tot = -1;
    80003c32:	59fd                	li	s3,-1
  }
  return tot;
    80003c34:	0009851b          	sext.w	a0,s3
}
    80003c38:	70a6                	ld	ra,104(sp)
    80003c3a:	7406                	ld	s0,96(sp)
    80003c3c:	64e6                	ld	s1,88(sp)
    80003c3e:	6946                	ld	s2,80(sp)
    80003c40:	69a6                	ld	s3,72(sp)
    80003c42:	6a06                	ld	s4,64(sp)
    80003c44:	7ae2                	ld	s5,56(sp)
    80003c46:	7b42                	ld	s6,48(sp)
    80003c48:	7ba2                	ld	s7,40(sp)
    80003c4a:	7c02                	ld	s8,32(sp)
    80003c4c:	6ce2                	ld	s9,24(sp)
    80003c4e:	6d42                	ld	s10,16(sp)
    80003c50:	6da2                	ld	s11,8(sp)
    80003c52:	6165                	add	sp,sp,112
    80003c54:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80003c56:	89d6                	mv	s3,s5
    80003c58:	bff1                	j	80003c34 <readi+0xce>
    return 0;
    80003c5a:	4501                	li	a0,0
}
    80003c5c:	8082                	ret

0000000080003c5e <writei>:
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80003c5e:	457c                	lw	a5,76(a0)
    80003c60:	10d7e963          	bltu	a5,a3,80003d72 <writei+0x114>
{
    80003c64:	7159                	add	sp,sp,-112
    80003c66:	f486                	sd	ra,104(sp)
    80003c68:	f0a2                	sd	s0,96(sp)
    80003c6a:	eca6                	sd	s1,88(sp)
    80003c6c:	e8ca                	sd	s2,80(sp)
    80003c6e:	e4ce                	sd	s3,72(sp)
    80003c70:	e0d2                	sd	s4,64(sp)
    80003c72:	fc56                	sd	s5,56(sp)
    80003c74:	f85a                	sd	s6,48(sp)
    80003c76:	f45e                	sd	s7,40(sp)
    80003c78:	f062                	sd	s8,32(sp)
    80003c7a:	ec66                	sd	s9,24(sp)
    80003c7c:	e86a                	sd	s10,16(sp)
    80003c7e:	e46e                	sd	s11,8(sp)
    80003c80:	1880                	add	s0,sp,112
    80003c82:	8aaa                	mv	s5,a0
    80003c84:	8bae                	mv	s7,a1
    80003c86:	8a32                	mv	s4,a2
    80003c88:	8936                	mv	s2,a3
    80003c8a:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    80003c8c:	9f35                	addw	a4,a4,a3
    80003c8e:	0ed76463          	bltu	a4,a3,80003d76 <writei+0x118>
    return -1;
  if (off + n > MAXFILE * BSIZE)
    80003c92:	040437b7          	lui	a5,0x4043
    80003c96:	c0078793          	add	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    80003c9a:	0ee7e063          	bltu	a5,a4,80003d7a <writei+0x11c>
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m)
    80003c9e:	0c0b0863          	beqz	s6,80003d6e <writei+0x110>
    80003ca2:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);

    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003ca4:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1)
    80003ca8:	5c7d                	li	s8,-1
    80003caa:	a091                	j	80003cee <writei+0x90>
    80003cac:	020d1d93          	sll	s11,s10,0x20
    80003cb0:	020ddd93          	srl	s11,s11,0x20
    80003cb4:	05848513          	add	a0,s1,88
    80003cb8:	86ee                	mv	a3,s11
    80003cba:	8652                	mv	a2,s4
    80003cbc:	85de                	mv	a1,s7
    80003cbe:	953a                	add	a0,a0,a4
    80003cc0:	ffffe097          	auipc	ra,0xffffe
    80003cc4:	7ec080e7          	jalr	2028(ra) # 800024ac <either_copyin>
    80003cc8:	07850263          	beq	a0,s8,80003d2c <writei+0xce>
    {
      brelse(bp);
      break;
    }
    log_write(bp);
    80003ccc:	8526                	mv	a0,s1
    80003cce:	00000097          	auipc	ra,0x0
    80003cd2:	75e080e7          	jalr	1886(ra) # 8000442c <log_write>
    brelse(bp);
    80003cd6:	8526                	mv	a0,s1
    80003cd8:	fffff097          	auipc	ra,0xfffff
    80003cdc:	3ba080e7          	jalr	954(ra) # 80003092 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m)
    80003ce0:	013d09bb          	addw	s3,s10,s3
    80003ce4:	012d093b          	addw	s2,s10,s2
    80003ce8:	9a6e                	add	s4,s4,s11
    80003cea:	0569f663          	bgeu	s3,s6,80003d36 <writei+0xd8>
    uint addr = bmap(ip, off / BSIZE);
    80003cee:	00a9559b          	srlw	a1,s2,0xa
    80003cf2:	8556                	mv	a0,s5
    80003cf4:	fffff097          	auipc	ra,0xfffff
    80003cf8:	660080e7          	jalr	1632(ra) # 80003354 <bmap>
    80003cfc:	0005059b          	sext.w	a1,a0
    if (addr == 0)
    80003d00:	c99d                	beqz	a1,80003d36 <writei+0xd8>
    bp = bread(ip->dev, addr);
    80003d02:	000aa503          	lw	a0,0(s5)
    80003d06:	fffff097          	auipc	ra,0xfffff
    80003d0a:	25c080e7          	jalr	604(ra) # 80002f62 <bread>
    80003d0e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003d10:	3ff97713          	and	a4,s2,1023
    80003d14:	40ec87bb          	subw	a5,s9,a4
    80003d18:	413b06bb          	subw	a3,s6,s3
    80003d1c:	8d3e                	mv	s10,a5
    80003d1e:	2781                	sext.w	a5,a5
    80003d20:	0006861b          	sext.w	a2,a3
    80003d24:	f8f674e3          	bgeu	a2,a5,80003cac <writei+0x4e>
    80003d28:	8d36                	mv	s10,a3
    80003d2a:	b749                	j	80003cac <writei+0x4e>
      brelse(bp);
    80003d2c:	8526                	mv	a0,s1
    80003d2e:	fffff097          	auipc	ra,0xfffff
    80003d32:	364080e7          	jalr	868(ra) # 80003092 <brelse>
  }

  if (off > ip->size)
    80003d36:	04caa783          	lw	a5,76(s5)
    80003d3a:	0127f463          	bgeu	a5,s2,80003d42 <writei+0xe4>
    ip->size = off;
    80003d3e:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003d42:	8556                	mv	a0,s5
    80003d44:	00000097          	auipc	ra,0x0
    80003d48:	aa2080e7          	jalr	-1374(ra) # 800037e6 <iupdate>

  return tot;
    80003d4c:	0009851b          	sext.w	a0,s3
}
    80003d50:	70a6                	ld	ra,104(sp)
    80003d52:	7406                	ld	s0,96(sp)
    80003d54:	64e6                	ld	s1,88(sp)
    80003d56:	6946                	ld	s2,80(sp)
    80003d58:	69a6                	ld	s3,72(sp)
    80003d5a:	6a06                	ld	s4,64(sp)
    80003d5c:	7ae2                	ld	s5,56(sp)
    80003d5e:	7b42                	ld	s6,48(sp)
    80003d60:	7ba2                	ld	s7,40(sp)
    80003d62:	7c02                	ld	s8,32(sp)
    80003d64:	6ce2                	ld	s9,24(sp)
    80003d66:	6d42                	ld	s10,16(sp)
    80003d68:	6da2                	ld	s11,8(sp)
    80003d6a:	6165                	add	sp,sp,112
    80003d6c:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m)
    80003d6e:	89da                	mv	s3,s6
    80003d70:	bfc9                	j	80003d42 <writei+0xe4>
    return -1;
    80003d72:	557d                	li	a0,-1
}
    80003d74:	8082                	ret
    return -1;
    80003d76:	557d                	li	a0,-1
    80003d78:	bfe1                	j	80003d50 <writei+0xf2>
    return -1;
    80003d7a:	557d                	li	a0,-1
    80003d7c:	bfd1                	j	80003d50 <writei+0xf2>

0000000080003d7e <namecmp>:

// Directories

int namecmp(const char *s, const char *t)
{
    80003d7e:	1141                	add	sp,sp,-16
    80003d80:	e406                	sd	ra,8(sp)
    80003d82:	e022                	sd	s0,0(sp)
    80003d84:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003d86:	4639                	li	a2,14
    80003d88:	ffffd097          	auipc	ra,0xffffd
    80003d8c:	016080e7          	jalr	22(ra) # 80000d9e <strncmp>
}
    80003d90:	60a2                	ld	ra,8(sp)
    80003d92:	6402                	ld	s0,0(sp)
    80003d94:	0141                	add	sp,sp,16
    80003d96:	8082                	ret

0000000080003d98 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003d98:	7139                	add	sp,sp,-64
    80003d9a:	fc06                	sd	ra,56(sp)
    80003d9c:	f822                	sd	s0,48(sp)
    80003d9e:	f426                	sd	s1,40(sp)
    80003da0:	f04a                	sd	s2,32(sp)
    80003da2:	ec4e                	sd	s3,24(sp)
    80003da4:	e852                	sd	s4,16(sp)
    80003da6:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    80003da8:	04451703          	lh	a4,68(a0)
    80003dac:	4785                	li	a5,1
    80003dae:	00f71a63          	bne	a4,a5,80003dc2 <dirlookup+0x2a>
    80003db2:	892a                	mv	s2,a0
    80003db4:	89ae                	mv	s3,a1
    80003db6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de))
    80003db8:	457c                	lw	a5,76(a0)
    80003dba:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003dbc:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de))
    80003dbe:	e79d                	bnez	a5,80003dec <dirlookup+0x54>
    80003dc0:	a8a5                	j	80003e38 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003dc2:	00005517          	auipc	a0,0x5
    80003dc6:	91650513          	add	a0,a0,-1770 # 800086d8 <syscalls+0x278>
    80003dca:	ffffc097          	auipc	ra,0xffffc
    80003dce:	772080e7          	jalr	1906(ra) # 8000053c <panic>
      panic("dirlookup read");
    80003dd2:	00005517          	auipc	a0,0x5
    80003dd6:	91e50513          	add	a0,a0,-1762 # 800086f0 <syscalls+0x290>
    80003dda:	ffffc097          	auipc	ra,0xffffc
    80003dde:	762080e7          	jalr	1890(ra) # 8000053c <panic>
  for (off = 0; off < dp->size; off += sizeof(de))
    80003de2:	24c1                	addw	s1,s1,16
    80003de4:	04c92783          	lw	a5,76(s2)
    80003de8:	04f4f763          	bgeu	s1,a5,80003e36 <dirlookup+0x9e>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003dec:	4741                	li	a4,16
    80003dee:	86a6                	mv	a3,s1
    80003df0:	fc040613          	add	a2,s0,-64
    80003df4:	4581                	li	a1,0
    80003df6:	854a                	mv	a0,s2
    80003df8:	00000097          	auipc	ra,0x0
    80003dfc:	d6e080e7          	jalr	-658(ra) # 80003b66 <readi>
    80003e00:	47c1                	li	a5,16
    80003e02:	fcf518e3          	bne	a0,a5,80003dd2 <dirlookup+0x3a>
    if (de.inum == 0)
    80003e06:	fc045783          	lhu	a5,-64(s0)
    80003e0a:	dfe1                	beqz	a5,80003de2 <dirlookup+0x4a>
    if (namecmp(name, de.name) == 0)
    80003e0c:	fc240593          	add	a1,s0,-62
    80003e10:	854e                	mv	a0,s3
    80003e12:	00000097          	auipc	ra,0x0
    80003e16:	f6c080e7          	jalr	-148(ra) # 80003d7e <namecmp>
    80003e1a:	f561                	bnez	a0,80003de2 <dirlookup+0x4a>
      if (poff)
    80003e1c:	000a0463          	beqz	s4,80003e24 <dirlookup+0x8c>
        *poff = off;
    80003e20:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003e24:	fc045583          	lhu	a1,-64(s0)
    80003e28:	00092503          	lw	a0,0(s2)
    80003e2c:	fffff097          	auipc	ra,0xfffff
    80003e30:	752080e7          	jalr	1874(ra) # 8000357e <iget>
    80003e34:	a011                	j	80003e38 <dirlookup+0xa0>
  return 0;
    80003e36:	4501                	li	a0,0
}
    80003e38:	70e2                	ld	ra,56(sp)
    80003e3a:	7442                	ld	s0,48(sp)
    80003e3c:	74a2                	ld	s1,40(sp)
    80003e3e:	7902                	ld	s2,32(sp)
    80003e40:	69e2                	ld	s3,24(sp)
    80003e42:	6a42                	ld	s4,16(sp)
    80003e44:	6121                	add	sp,sp,64
    80003e46:	8082                	ret

0000000080003e48 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    80003e48:	711d                	add	sp,sp,-96
    80003e4a:	ec86                	sd	ra,88(sp)
    80003e4c:	e8a2                	sd	s0,80(sp)
    80003e4e:	e4a6                	sd	s1,72(sp)
    80003e50:	e0ca                	sd	s2,64(sp)
    80003e52:	fc4e                	sd	s3,56(sp)
    80003e54:	f852                	sd	s4,48(sp)
    80003e56:	f456                	sd	s5,40(sp)
    80003e58:	f05a                	sd	s6,32(sp)
    80003e5a:	ec5e                	sd	s7,24(sp)
    80003e5c:	e862                	sd	s8,16(sp)
    80003e5e:	e466                	sd	s9,8(sp)
    80003e60:	1080                	add	s0,sp,96
    80003e62:	84aa                	mv	s1,a0
    80003e64:	8b2e                	mv	s6,a1
    80003e66:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    80003e68:	00054703          	lbu	a4,0(a0)
    80003e6c:	02f00793          	li	a5,47
    80003e70:	02f70263          	beq	a4,a5,80003e94 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003e74:	ffffe097          	auipc	ra,0xffffe
    80003e78:	b32080e7          	jalr	-1230(ra) # 800019a6 <myproc>
    80003e7c:	15053503          	ld	a0,336(a0)
    80003e80:	00000097          	auipc	ra,0x0
    80003e84:	9f4080e7          	jalr	-1548(ra) # 80003874 <idup>
    80003e88:	8a2a                	mv	s4,a0
  while (*path == '/')
    80003e8a:	02f00913          	li	s2,47
  if (len >= DIRSIZ)
    80003e8e:	4c35                	li	s8,13

  while ((path = skipelem(path, name)) != 0)
  {
    ilock(ip);
    if (ip->type != T_DIR)
    80003e90:	4b85                	li	s7,1
    80003e92:	a875                	j	80003f4e <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003e94:	4585                	li	a1,1
    80003e96:	4505                	li	a0,1
    80003e98:	fffff097          	auipc	ra,0xfffff
    80003e9c:	6e6080e7          	jalr	1766(ra) # 8000357e <iget>
    80003ea0:	8a2a                	mv	s4,a0
    80003ea2:	b7e5                	j	80003e8a <namex+0x42>
    {
      iunlockput(ip);
    80003ea4:	8552                	mv	a0,s4
    80003ea6:	00000097          	auipc	ra,0x0
    80003eaa:	c6e080e7          	jalr	-914(ra) # 80003b14 <iunlockput>
      return 0;
    80003eae:	4a01                	li	s4,0
  {
    iput(ip);
    return 0;
  }
  return ip;
}
    80003eb0:	8552                	mv	a0,s4
    80003eb2:	60e6                	ld	ra,88(sp)
    80003eb4:	6446                	ld	s0,80(sp)
    80003eb6:	64a6                	ld	s1,72(sp)
    80003eb8:	6906                	ld	s2,64(sp)
    80003eba:	79e2                	ld	s3,56(sp)
    80003ebc:	7a42                	ld	s4,48(sp)
    80003ebe:	7aa2                	ld	s5,40(sp)
    80003ec0:	7b02                	ld	s6,32(sp)
    80003ec2:	6be2                	ld	s7,24(sp)
    80003ec4:	6c42                	ld	s8,16(sp)
    80003ec6:	6ca2                	ld	s9,8(sp)
    80003ec8:	6125                	add	sp,sp,96
    80003eca:	8082                	ret
      iunlock(ip);
    80003ecc:	8552                	mv	a0,s4
    80003ece:	00000097          	auipc	ra,0x0
    80003ed2:	aa6080e7          	jalr	-1370(ra) # 80003974 <iunlock>
      return ip;
    80003ed6:	bfe9                	j	80003eb0 <namex+0x68>
      iunlockput(ip);
    80003ed8:	8552                	mv	a0,s4
    80003eda:	00000097          	auipc	ra,0x0
    80003ede:	c3a080e7          	jalr	-966(ra) # 80003b14 <iunlockput>
      return 0;
    80003ee2:	8a4e                	mv	s4,s3
    80003ee4:	b7f1                	j	80003eb0 <namex+0x68>
  len = path - s;
    80003ee6:	40998633          	sub	a2,s3,s1
    80003eea:	00060c9b          	sext.w	s9,a2
  if (len >= DIRSIZ)
    80003eee:	099c5863          	bge	s8,s9,80003f7e <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003ef2:	4639                	li	a2,14
    80003ef4:	85a6                	mv	a1,s1
    80003ef6:	8556                	mv	a0,s5
    80003ef8:	ffffd097          	auipc	ra,0xffffd
    80003efc:	e32080e7          	jalr	-462(ra) # 80000d2a <memmove>
    80003f00:	84ce                	mv	s1,s3
  while (*path == '/')
    80003f02:	0004c783          	lbu	a5,0(s1)
    80003f06:	01279763          	bne	a5,s2,80003f14 <namex+0xcc>
    path++;
    80003f0a:	0485                	add	s1,s1,1
  while (*path == '/')
    80003f0c:	0004c783          	lbu	a5,0(s1)
    80003f10:	ff278de3          	beq	a5,s2,80003f0a <namex+0xc2>
    ilock(ip);
    80003f14:	8552                	mv	a0,s4
    80003f16:	00000097          	auipc	ra,0x0
    80003f1a:	99c080e7          	jalr	-1636(ra) # 800038b2 <ilock>
    if (ip->type != T_DIR)
    80003f1e:	044a1783          	lh	a5,68(s4)
    80003f22:	f97791e3          	bne	a5,s7,80003ea4 <namex+0x5c>
    if (nameiparent && *path == '\0')
    80003f26:	000b0563          	beqz	s6,80003f30 <namex+0xe8>
    80003f2a:	0004c783          	lbu	a5,0(s1)
    80003f2e:	dfd9                	beqz	a5,80003ecc <namex+0x84>
    if ((next = dirlookup(ip, name, 0)) == 0)
    80003f30:	4601                	li	a2,0
    80003f32:	85d6                	mv	a1,s5
    80003f34:	8552                	mv	a0,s4
    80003f36:	00000097          	auipc	ra,0x0
    80003f3a:	e62080e7          	jalr	-414(ra) # 80003d98 <dirlookup>
    80003f3e:	89aa                	mv	s3,a0
    80003f40:	dd41                	beqz	a0,80003ed8 <namex+0x90>
    iunlockput(ip);
    80003f42:	8552                	mv	a0,s4
    80003f44:	00000097          	auipc	ra,0x0
    80003f48:	bd0080e7          	jalr	-1072(ra) # 80003b14 <iunlockput>
    ip = next;
    80003f4c:	8a4e                	mv	s4,s3
  while (*path == '/')
    80003f4e:	0004c783          	lbu	a5,0(s1)
    80003f52:	01279763          	bne	a5,s2,80003f60 <namex+0x118>
    path++;
    80003f56:	0485                	add	s1,s1,1
  while (*path == '/')
    80003f58:	0004c783          	lbu	a5,0(s1)
    80003f5c:	ff278de3          	beq	a5,s2,80003f56 <namex+0x10e>
  if (*path == 0)
    80003f60:	cb9d                	beqz	a5,80003f96 <namex+0x14e>
  while (*path != '/' && *path != 0)
    80003f62:	0004c783          	lbu	a5,0(s1)
    80003f66:	89a6                	mv	s3,s1
  len = path - s;
    80003f68:	4c81                	li	s9,0
    80003f6a:	4601                	li	a2,0
  while (*path != '/' && *path != 0)
    80003f6c:	01278963          	beq	a5,s2,80003f7e <namex+0x136>
    80003f70:	dbbd                	beqz	a5,80003ee6 <namex+0x9e>
    path++;
    80003f72:	0985                	add	s3,s3,1
  while (*path != '/' && *path != 0)
    80003f74:	0009c783          	lbu	a5,0(s3)
    80003f78:	ff279ce3          	bne	a5,s2,80003f70 <namex+0x128>
    80003f7c:	b7ad                	j	80003ee6 <namex+0x9e>
    memmove(name, s, len);
    80003f7e:	2601                	sext.w	a2,a2
    80003f80:	85a6                	mv	a1,s1
    80003f82:	8556                	mv	a0,s5
    80003f84:	ffffd097          	auipc	ra,0xffffd
    80003f88:	da6080e7          	jalr	-602(ra) # 80000d2a <memmove>
    name[len] = 0;
    80003f8c:	9cd6                	add	s9,s9,s5
    80003f8e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003f92:	84ce                	mv	s1,s3
    80003f94:	b7bd                	j	80003f02 <namex+0xba>
  if (nameiparent)
    80003f96:	f00b0de3          	beqz	s6,80003eb0 <namex+0x68>
    iput(ip);
    80003f9a:	8552                	mv	a0,s4
    80003f9c:	00000097          	auipc	ra,0x0
    80003fa0:	ad0080e7          	jalr	-1328(ra) # 80003a6c <iput>
    return 0;
    80003fa4:	4a01                	li	s4,0
    80003fa6:	b729                	j	80003eb0 <namex+0x68>

0000000080003fa8 <dirlink>:
{
    80003fa8:	7139                	add	sp,sp,-64
    80003faa:	fc06                	sd	ra,56(sp)
    80003fac:	f822                	sd	s0,48(sp)
    80003fae:	f426                	sd	s1,40(sp)
    80003fb0:	f04a                	sd	s2,32(sp)
    80003fb2:	ec4e                	sd	s3,24(sp)
    80003fb4:	e852                	sd	s4,16(sp)
    80003fb6:	0080                	add	s0,sp,64
    80003fb8:	892a                	mv	s2,a0
    80003fba:	8a2e                	mv	s4,a1
    80003fbc:	89b2                	mv	s3,a2
  if ((ip = dirlookup(dp, name, 0)) != 0)
    80003fbe:	4601                	li	a2,0
    80003fc0:	00000097          	auipc	ra,0x0
    80003fc4:	dd8080e7          	jalr	-552(ra) # 80003d98 <dirlookup>
    80003fc8:	e93d                	bnez	a0,8000403e <dirlink+0x96>
  for (off = 0; off < dp->size; off += sizeof(de))
    80003fca:	04c92483          	lw	s1,76(s2)
    80003fce:	c49d                	beqz	s1,80003ffc <dirlink+0x54>
    80003fd0:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003fd2:	4741                	li	a4,16
    80003fd4:	86a6                	mv	a3,s1
    80003fd6:	fc040613          	add	a2,s0,-64
    80003fda:	4581                	li	a1,0
    80003fdc:	854a                	mv	a0,s2
    80003fde:	00000097          	auipc	ra,0x0
    80003fe2:	b88080e7          	jalr	-1144(ra) # 80003b66 <readi>
    80003fe6:	47c1                	li	a5,16
    80003fe8:	06f51163          	bne	a0,a5,8000404a <dirlink+0xa2>
    if (de.inum == 0)
    80003fec:	fc045783          	lhu	a5,-64(s0)
    80003ff0:	c791                	beqz	a5,80003ffc <dirlink+0x54>
  for (off = 0; off < dp->size; off += sizeof(de))
    80003ff2:	24c1                	addw	s1,s1,16
    80003ff4:	04c92783          	lw	a5,76(s2)
    80003ff8:	fcf4ede3          	bltu	s1,a5,80003fd2 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003ffc:	4639                	li	a2,14
    80003ffe:	85d2                	mv	a1,s4
    80004000:	fc240513          	add	a0,s0,-62
    80004004:	ffffd097          	auipc	ra,0xffffd
    80004008:	dd6080e7          	jalr	-554(ra) # 80000dda <strncpy>
  de.inum = inum;
    8000400c:	fd341023          	sh	s3,-64(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004010:	4741                	li	a4,16
    80004012:	86a6                	mv	a3,s1
    80004014:	fc040613          	add	a2,s0,-64
    80004018:	4581                	li	a1,0
    8000401a:	854a                	mv	a0,s2
    8000401c:	00000097          	auipc	ra,0x0
    80004020:	c42080e7          	jalr	-958(ra) # 80003c5e <writei>
    80004024:	1541                	add	a0,a0,-16
    80004026:	00a03533          	snez	a0,a0
    8000402a:	40a00533          	neg	a0,a0
}
    8000402e:	70e2                	ld	ra,56(sp)
    80004030:	7442                	ld	s0,48(sp)
    80004032:	74a2                	ld	s1,40(sp)
    80004034:	7902                	ld	s2,32(sp)
    80004036:	69e2                	ld	s3,24(sp)
    80004038:	6a42                	ld	s4,16(sp)
    8000403a:	6121                	add	sp,sp,64
    8000403c:	8082                	ret
    iput(ip);
    8000403e:	00000097          	auipc	ra,0x0
    80004042:	a2e080e7          	jalr	-1490(ra) # 80003a6c <iput>
    return -1;
    80004046:	557d                	li	a0,-1
    80004048:	b7dd                	j	8000402e <dirlink+0x86>
      panic("dirlink read");
    8000404a:	00004517          	auipc	a0,0x4
    8000404e:	6b650513          	add	a0,a0,1718 # 80008700 <syscalls+0x2a0>
    80004052:	ffffc097          	auipc	ra,0xffffc
    80004056:	4ea080e7          	jalr	1258(ra) # 8000053c <panic>

000000008000405a <namei>:

struct inode *
namei(char *path)
{
    8000405a:	1101                	add	sp,sp,-32
    8000405c:	ec06                	sd	ra,24(sp)
    8000405e:	e822                	sd	s0,16(sp)
    80004060:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004062:	fe040613          	add	a2,s0,-32
    80004066:	4581                	li	a1,0
    80004068:	00000097          	auipc	ra,0x0
    8000406c:	de0080e7          	jalr	-544(ra) # 80003e48 <namex>
}
    80004070:	60e2                	ld	ra,24(sp)
    80004072:	6442                	ld	s0,16(sp)
    80004074:	6105                	add	sp,sp,32
    80004076:	8082                	ret

0000000080004078 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80004078:	1141                	add	sp,sp,-16
    8000407a:	e406                	sd	ra,8(sp)
    8000407c:	e022                	sd	s0,0(sp)
    8000407e:	0800                	add	s0,sp,16
    80004080:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004082:	4585                	li	a1,1
    80004084:	00000097          	auipc	ra,0x0
    80004088:	dc4080e7          	jalr	-572(ra) # 80003e48 <namex>
}
    8000408c:	60a2                	ld	ra,8(sp)
    8000408e:	6402                	ld	s0,0(sp)
    80004090:	0141                	add	sp,sp,16
    80004092:	8082                	ret

0000000080004094 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004094:	1101                	add	sp,sp,-32
    80004096:	ec06                	sd	ra,24(sp)
    80004098:	e822                	sd	s0,16(sp)
    8000409a:	e426                	sd	s1,8(sp)
    8000409c:	e04a                	sd	s2,0(sp)
    8000409e:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800040a0:	0001d917          	auipc	s2,0x1d
    800040a4:	b5090913          	add	s2,s2,-1200 # 80020bf0 <log>
    800040a8:	01892583          	lw	a1,24(s2)
    800040ac:	02892503          	lw	a0,40(s2)
    800040b0:	fffff097          	auipc	ra,0xfffff
    800040b4:	eb2080e7          	jalr	-334(ra) # 80002f62 <bread>
    800040b8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800040ba:	02c92603          	lw	a2,44(s2)
    800040be:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800040c0:	00c05f63          	blez	a2,800040de <write_head+0x4a>
    800040c4:	0001d717          	auipc	a4,0x1d
    800040c8:	b5c70713          	add	a4,a4,-1188 # 80020c20 <log+0x30>
    800040cc:	87aa                	mv	a5,a0
    800040ce:	060a                	sll	a2,a2,0x2
    800040d0:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800040d2:	4314                	lw	a3,0(a4)
    800040d4:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800040d6:	0711                	add	a4,a4,4
    800040d8:	0791                	add	a5,a5,4
    800040da:	fec79ce3          	bne	a5,a2,800040d2 <write_head+0x3e>
  }
  bwrite(buf);
    800040de:	8526                	mv	a0,s1
    800040e0:	fffff097          	auipc	ra,0xfffff
    800040e4:	f74080e7          	jalr	-140(ra) # 80003054 <bwrite>
  brelse(buf);
    800040e8:	8526                	mv	a0,s1
    800040ea:	fffff097          	auipc	ra,0xfffff
    800040ee:	fa8080e7          	jalr	-88(ra) # 80003092 <brelse>
}
    800040f2:	60e2                	ld	ra,24(sp)
    800040f4:	6442                	ld	s0,16(sp)
    800040f6:	64a2                	ld	s1,8(sp)
    800040f8:	6902                	ld	s2,0(sp)
    800040fa:	6105                	add	sp,sp,32
    800040fc:	8082                	ret

00000000800040fe <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800040fe:	0001d797          	auipc	a5,0x1d
    80004102:	b1e7a783          	lw	a5,-1250(a5) # 80020c1c <log+0x2c>
    80004106:	0af05d63          	blez	a5,800041c0 <install_trans+0xc2>
{
    8000410a:	7139                	add	sp,sp,-64
    8000410c:	fc06                	sd	ra,56(sp)
    8000410e:	f822                	sd	s0,48(sp)
    80004110:	f426                	sd	s1,40(sp)
    80004112:	f04a                	sd	s2,32(sp)
    80004114:	ec4e                	sd	s3,24(sp)
    80004116:	e852                	sd	s4,16(sp)
    80004118:	e456                	sd	s5,8(sp)
    8000411a:	e05a                	sd	s6,0(sp)
    8000411c:	0080                	add	s0,sp,64
    8000411e:	8b2a                	mv	s6,a0
    80004120:	0001da97          	auipc	s5,0x1d
    80004124:	b00a8a93          	add	s5,s5,-1280 # 80020c20 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004128:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000412a:	0001d997          	auipc	s3,0x1d
    8000412e:	ac698993          	add	s3,s3,-1338 # 80020bf0 <log>
    80004132:	a00d                	j	80004154 <install_trans+0x56>
    brelse(lbuf);
    80004134:	854a                	mv	a0,s2
    80004136:	fffff097          	auipc	ra,0xfffff
    8000413a:	f5c080e7          	jalr	-164(ra) # 80003092 <brelse>
    brelse(dbuf);
    8000413e:	8526                	mv	a0,s1
    80004140:	fffff097          	auipc	ra,0xfffff
    80004144:	f52080e7          	jalr	-174(ra) # 80003092 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004148:	2a05                	addw	s4,s4,1
    8000414a:	0a91                	add	s5,s5,4
    8000414c:	02c9a783          	lw	a5,44(s3)
    80004150:	04fa5e63          	bge	s4,a5,800041ac <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004154:	0189a583          	lw	a1,24(s3)
    80004158:	014585bb          	addw	a1,a1,s4
    8000415c:	2585                	addw	a1,a1,1
    8000415e:	0289a503          	lw	a0,40(s3)
    80004162:	fffff097          	auipc	ra,0xfffff
    80004166:	e00080e7          	jalr	-512(ra) # 80002f62 <bread>
    8000416a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000416c:	000aa583          	lw	a1,0(s5)
    80004170:	0289a503          	lw	a0,40(s3)
    80004174:	fffff097          	auipc	ra,0xfffff
    80004178:	dee080e7          	jalr	-530(ra) # 80002f62 <bread>
    8000417c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000417e:	40000613          	li	a2,1024
    80004182:	05890593          	add	a1,s2,88
    80004186:	05850513          	add	a0,a0,88
    8000418a:	ffffd097          	auipc	ra,0xffffd
    8000418e:	ba0080e7          	jalr	-1120(ra) # 80000d2a <memmove>
    bwrite(dbuf);  // write dst to disk
    80004192:	8526                	mv	a0,s1
    80004194:	fffff097          	auipc	ra,0xfffff
    80004198:	ec0080e7          	jalr	-320(ra) # 80003054 <bwrite>
    if(recovering == 0)
    8000419c:	f80b1ce3          	bnez	s6,80004134 <install_trans+0x36>
      bunpin(dbuf);
    800041a0:	8526                	mv	a0,s1
    800041a2:	fffff097          	auipc	ra,0xfffff
    800041a6:	fc8080e7          	jalr	-56(ra) # 8000316a <bunpin>
    800041aa:	b769                	j	80004134 <install_trans+0x36>
}
    800041ac:	70e2                	ld	ra,56(sp)
    800041ae:	7442                	ld	s0,48(sp)
    800041b0:	74a2                	ld	s1,40(sp)
    800041b2:	7902                	ld	s2,32(sp)
    800041b4:	69e2                	ld	s3,24(sp)
    800041b6:	6a42                	ld	s4,16(sp)
    800041b8:	6aa2                	ld	s5,8(sp)
    800041ba:	6b02                	ld	s6,0(sp)
    800041bc:	6121                	add	sp,sp,64
    800041be:	8082                	ret
    800041c0:	8082                	ret

00000000800041c2 <initlog>:
{
    800041c2:	7179                	add	sp,sp,-48
    800041c4:	f406                	sd	ra,40(sp)
    800041c6:	f022                	sd	s0,32(sp)
    800041c8:	ec26                	sd	s1,24(sp)
    800041ca:	e84a                	sd	s2,16(sp)
    800041cc:	e44e                	sd	s3,8(sp)
    800041ce:	1800                	add	s0,sp,48
    800041d0:	892a                	mv	s2,a0
    800041d2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800041d4:	0001d497          	auipc	s1,0x1d
    800041d8:	a1c48493          	add	s1,s1,-1508 # 80020bf0 <log>
    800041dc:	00004597          	auipc	a1,0x4
    800041e0:	53458593          	add	a1,a1,1332 # 80008710 <syscalls+0x2b0>
    800041e4:	8526                	mv	a0,s1
    800041e6:	ffffd097          	auipc	ra,0xffffd
    800041ea:	95c080e7          	jalr	-1700(ra) # 80000b42 <initlock>
  log.start = sb->logstart;
    800041ee:	0149a583          	lw	a1,20(s3)
    800041f2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800041f4:	0109a783          	lw	a5,16(s3)
    800041f8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800041fa:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800041fe:	854a                	mv	a0,s2
    80004200:	fffff097          	auipc	ra,0xfffff
    80004204:	d62080e7          	jalr	-670(ra) # 80002f62 <bread>
  log.lh.n = lh->n;
    80004208:	4d30                	lw	a2,88(a0)
    8000420a:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000420c:	00c05f63          	blez	a2,8000422a <initlog+0x68>
    80004210:	87aa                	mv	a5,a0
    80004212:	0001d717          	auipc	a4,0x1d
    80004216:	a0e70713          	add	a4,a4,-1522 # 80020c20 <log+0x30>
    8000421a:	060a                	sll	a2,a2,0x2
    8000421c:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000421e:	4ff4                	lw	a3,92(a5)
    80004220:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004222:	0791                	add	a5,a5,4
    80004224:	0711                	add	a4,a4,4
    80004226:	fec79ce3          	bne	a5,a2,8000421e <initlog+0x5c>
  brelse(buf);
    8000422a:	fffff097          	auipc	ra,0xfffff
    8000422e:	e68080e7          	jalr	-408(ra) # 80003092 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004232:	4505                	li	a0,1
    80004234:	00000097          	auipc	ra,0x0
    80004238:	eca080e7          	jalr	-310(ra) # 800040fe <install_trans>
  log.lh.n = 0;
    8000423c:	0001d797          	auipc	a5,0x1d
    80004240:	9e07a023          	sw	zero,-1568(a5) # 80020c1c <log+0x2c>
  write_head(); // clear the log
    80004244:	00000097          	auipc	ra,0x0
    80004248:	e50080e7          	jalr	-432(ra) # 80004094 <write_head>
}
    8000424c:	70a2                	ld	ra,40(sp)
    8000424e:	7402                	ld	s0,32(sp)
    80004250:	64e2                	ld	s1,24(sp)
    80004252:	6942                	ld	s2,16(sp)
    80004254:	69a2                	ld	s3,8(sp)
    80004256:	6145                	add	sp,sp,48
    80004258:	8082                	ret

000000008000425a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000425a:	1101                	add	sp,sp,-32
    8000425c:	ec06                	sd	ra,24(sp)
    8000425e:	e822                	sd	s0,16(sp)
    80004260:	e426                	sd	s1,8(sp)
    80004262:	e04a                	sd	s2,0(sp)
    80004264:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80004266:	0001d517          	auipc	a0,0x1d
    8000426a:	98a50513          	add	a0,a0,-1654 # 80020bf0 <log>
    8000426e:	ffffd097          	auipc	ra,0xffffd
    80004272:	964080e7          	jalr	-1692(ra) # 80000bd2 <acquire>
  while(1){
    if(log.committing){
    80004276:	0001d497          	auipc	s1,0x1d
    8000427a:	97a48493          	add	s1,s1,-1670 # 80020bf0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000427e:	4979                	li	s2,30
    80004280:	a039                	j	8000428e <begin_op+0x34>
      sleep(&log, &log.lock);
    80004282:	85a6                	mv	a1,s1
    80004284:	8526                	mv	a0,s1
    80004286:	ffffe097          	auipc	ra,0xffffe
    8000428a:	dc8080e7          	jalr	-568(ra) # 8000204e <sleep>
    if(log.committing){
    8000428e:	50dc                	lw	a5,36(s1)
    80004290:	fbed                	bnez	a5,80004282 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004292:	5098                	lw	a4,32(s1)
    80004294:	2705                	addw	a4,a4,1
    80004296:	0027179b          	sllw	a5,a4,0x2
    8000429a:	9fb9                	addw	a5,a5,a4
    8000429c:	0017979b          	sllw	a5,a5,0x1
    800042a0:	54d4                	lw	a3,44(s1)
    800042a2:	9fb5                	addw	a5,a5,a3
    800042a4:	00f95963          	bge	s2,a5,800042b6 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800042a8:	85a6                	mv	a1,s1
    800042aa:	8526                	mv	a0,s1
    800042ac:	ffffe097          	auipc	ra,0xffffe
    800042b0:	da2080e7          	jalr	-606(ra) # 8000204e <sleep>
    800042b4:	bfe9                	j	8000428e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800042b6:	0001d517          	auipc	a0,0x1d
    800042ba:	93a50513          	add	a0,a0,-1734 # 80020bf0 <log>
    800042be:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800042c0:	ffffd097          	auipc	ra,0xffffd
    800042c4:	9c6080e7          	jalr	-1594(ra) # 80000c86 <release>
      break;
    }
  }
}
    800042c8:	60e2                	ld	ra,24(sp)
    800042ca:	6442                	ld	s0,16(sp)
    800042cc:	64a2                	ld	s1,8(sp)
    800042ce:	6902                	ld	s2,0(sp)
    800042d0:	6105                	add	sp,sp,32
    800042d2:	8082                	ret

00000000800042d4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800042d4:	7139                	add	sp,sp,-64
    800042d6:	fc06                	sd	ra,56(sp)
    800042d8:	f822                	sd	s0,48(sp)
    800042da:	f426                	sd	s1,40(sp)
    800042dc:	f04a                	sd	s2,32(sp)
    800042de:	ec4e                	sd	s3,24(sp)
    800042e0:	e852                	sd	s4,16(sp)
    800042e2:	e456                	sd	s5,8(sp)
    800042e4:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800042e6:	0001d497          	auipc	s1,0x1d
    800042ea:	90a48493          	add	s1,s1,-1782 # 80020bf0 <log>
    800042ee:	8526                	mv	a0,s1
    800042f0:	ffffd097          	auipc	ra,0xffffd
    800042f4:	8e2080e7          	jalr	-1822(ra) # 80000bd2 <acquire>
  log.outstanding -= 1;
    800042f8:	509c                	lw	a5,32(s1)
    800042fa:	37fd                	addw	a5,a5,-1
    800042fc:	0007891b          	sext.w	s2,a5
    80004300:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004302:	50dc                	lw	a5,36(s1)
    80004304:	e7b9                	bnez	a5,80004352 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004306:	04091e63          	bnez	s2,80004362 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000430a:	0001d497          	auipc	s1,0x1d
    8000430e:	8e648493          	add	s1,s1,-1818 # 80020bf0 <log>
    80004312:	4785                	li	a5,1
    80004314:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004316:	8526                	mv	a0,s1
    80004318:	ffffd097          	auipc	ra,0xffffd
    8000431c:	96e080e7          	jalr	-1682(ra) # 80000c86 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004320:	54dc                	lw	a5,44(s1)
    80004322:	06f04763          	bgtz	a5,80004390 <end_op+0xbc>
    acquire(&log.lock);
    80004326:	0001d497          	auipc	s1,0x1d
    8000432a:	8ca48493          	add	s1,s1,-1846 # 80020bf0 <log>
    8000432e:	8526                	mv	a0,s1
    80004330:	ffffd097          	auipc	ra,0xffffd
    80004334:	8a2080e7          	jalr	-1886(ra) # 80000bd2 <acquire>
    log.committing = 0;
    80004338:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000433c:	8526                	mv	a0,s1
    8000433e:	ffffe097          	auipc	ra,0xffffe
    80004342:	d74080e7          	jalr	-652(ra) # 800020b2 <wakeup>
    release(&log.lock);
    80004346:	8526                	mv	a0,s1
    80004348:	ffffd097          	auipc	ra,0xffffd
    8000434c:	93e080e7          	jalr	-1730(ra) # 80000c86 <release>
}
    80004350:	a03d                	j	8000437e <end_op+0xaa>
    panic("log.committing");
    80004352:	00004517          	auipc	a0,0x4
    80004356:	3c650513          	add	a0,a0,966 # 80008718 <syscalls+0x2b8>
    8000435a:	ffffc097          	auipc	ra,0xffffc
    8000435e:	1e2080e7          	jalr	482(ra) # 8000053c <panic>
    wakeup(&log);
    80004362:	0001d497          	auipc	s1,0x1d
    80004366:	88e48493          	add	s1,s1,-1906 # 80020bf0 <log>
    8000436a:	8526                	mv	a0,s1
    8000436c:	ffffe097          	auipc	ra,0xffffe
    80004370:	d46080e7          	jalr	-698(ra) # 800020b2 <wakeup>
  release(&log.lock);
    80004374:	8526                	mv	a0,s1
    80004376:	ffffd097          	auipc	ra,0xffffd
    8000437a:	910080e7          	jalr	-1776(ra) # 80000c86 <release>
}
    8000437e:	70e2                	ld	ra,56(sp)
    80004380:	7442                	ld	s0,48(sp)
    80004382:	74a2                	ld	s1,40(sp)
    80004384:	7902                	ld	s2,32(sp)
    80004386:	69e2                	ld	s3,24(sp)
    80004388:	6a42                	ld	s4,16(sp)
    8000438a:	6aa2                	ld	s5,8(sp)
    8000438c:	6121                	add	sp,sp,64
    8000438e:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004390:	0001da97          	auipc	s5,0x1d
    80004394:	890a8a93          	add	s5,s5,-1904 # 80020c20 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004398:	0001da17          	auipc	s4,0x1d
    8000439c:	858a0a13          	add	s4,s4,-1960 # 80020bf0 <log>
    800043a0:	018a2583          	lw	a1,24(s4)
    800043a4:	012585bb          	addw	a1,a1,s2
    800043a8:	2585                	addw	a1,a1,1
    800043aa:	028a2503          	lw	a0,40(s4)
    800043ae:	fffff097          	auipc	ra,0xfffff
    800043b2:	bb4080e7          	jalr	-1100(ra) # 80002f62 <bread>
    800043b6:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800043b8:	000aa583          	lw	a1,0(s5)
    800043bc:	028a2503          	lw	a0,40(s4)
    800043c0:	fffff097          	auipc	ra,0xfffff
    800043c4:	ba2080e7          	jalr	-1118(ra) # 80002f62 <bread>
    800043c8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800043ca:	40000613          	li	a2,1024
    800043ce:	05850593          	add	a1,a0,88
    800043d2:	05848513          	add	a0,s1,88
    800043d6:	ffffd097          	auipc	ra,0xffffd
    800043da:	954080e7          	jalr	-1708(ra) # 80000d2a <memmove>
    bwrite(to);  // write the log
    800043de:	8526                	mv	a0,s1
    800043e0:	fffff097          	auipc	ra,0xfffff
    800043e4:	c74080e7          	jalr	-908(ra) # 80003054 <bwrite>
    brelse(from);
    800043e8:	854e                	mv	a0,s3
    800043ea:	fffff097          	auipc	ra,0xfffff
    800043ee:	ca8080e7          	jalr	-856(ra) # 80003092 <brelse>
    brelse(to);
    800043f2:	8526                	mv	a0,s1
    800043f4:	fffff097          	auipc	ra,0xfffff
    800043f8:	c9e080e7          	jalr	-866(ra) # 80003092 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800043fc:	2905                	addw	s2,s2,1
    800043fe:	0a91                	add	s5,s5,4
    80004400:	02ca2783          	lw	a5,44(s4)
    80004404:	f8f94ee3          	blt	s2,a5,800043a0 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004408:	00000097          	auipc	ra,0x0
    8000440c:	c8c080e7          	jalr	-884(ra) # 80004094 <write_head>
    install_trans(0); // Now install writes to home locations
    80004410:	4501                	li	a0,0
    80004412:	00000097          	auipc	ra,0x0
    80004416:	cec080e7          	jalr	-788(ra) # 800040fe <install_trans>
    log.lh.n = 0;
    8000441a:	0001d797          	auipc	a5,0x1d
    8000441e:	8007a123          	sw	zero,-2046(a5) # 80020c1c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004422:	00000097          	auipc	ra,0x0
    80004426:	c72080e7          	jalr	-910(ra) # 80004094 <write_head>
    8000442a:	bdf5                	j	80004326 <end_op+0x52>

000000008000442c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000442c:	1101                	add	sp,sp,-32
    8000442e:	ec06                	sd	ra,24(sp)
    80004430:	e822                	sd	s0,16(sp)
    80004432:	e426                	sd	s1,8(sp)
    80004434:	e04a                	sd	s2,0(sp)
    80004436:	1000                	add	s0,sp,32
    80004438:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000443a:	0001c917          	auipc	s2,0x1c
    8000443e:	7b690913          	add	s2,s2,1974 # 80020bf0 <log>
    80004442:	854a                	mv	a0,s2
    80004444:	ffffc097          	auipc	ra,0xffffc
    80004448:	78e080e7          	jalr	1934(ra) # 80000bd2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000444c:	02c92603          	lw	a2,44(s2)
    80004450:	47f5                	li	a5,29
    80004452:	06c7c563          	blt	a5,a2,800044bc <log_write+0x90>
    80004456:	0001c797          	auipc	a5,0x1c
    8000445a:	7b67a783          	lw	a5,1974(a5) # 80020c0c <log+0x1c>
    8000445e:	37fd                	addw	a5,a5,-1
    80004460:	04f65e63          	bge	a2,a5,800044bc <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004464:	0001c797          	auipc	a5,0x1c
    80004468:	7ac7a783          	lw	a5,1964(a5) # 80020c10 <log+0x20>
    8000446c:	06f05063          	blez	a5,800044cc <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004470:	4781                	li	a5,0
    80004472:	06c05563          	blez	a2,800044dc <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004476:	44cc                	lw	a1,12(s1)
    80004478:	0001c717          	auipc	a4,0x1c
    8000447c:	7a870713          	add	a4,a4,1960 # 80020c20 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004480:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004482:	4314                	lw	a3,0(a4)
    80004484:	04b68c63          	beq	a3,a1,800044dc <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004488:	2785                	addw	a5,a5,1
    8000448a:	0711                	add	a4,a4,4
    8000448c:	fef61be3          	bne	a2,a5,80004482 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004490:	0621                	add	a2,a2,8
    80004492:	060a                	sll	a2,a2,0x2
    80004494:	0001c797          	auipc	a5,0x1c
    80004498:	75c78793          	add	a5,a5,1884 # 80020bf0 <log>
    8000449c:	97b2                	add	a5,a5,a2
    8000449e:	44d8                	lw	a4,12(s1)
    800044a0:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800044a2:	8526                	mv	a0,s1
    800044a4:	fffff097          	auipc	ra,0xfffff
    800044a8:	c8a080e7          	jalr	-886(ra) # 8000312e <bpin>
    log.lh.n++;
    800044ac:	0001c717          	auipc	a4,0x1c
    800044b0:	74470713          	add	a4,a4,1860 # 80020bf0 <log>
    800044b4:	575c                	lw	a5,44(a4)
    800044b6:	2785                	addw	a5,a5,1
    800044b8:	d75c                	sw	a5,44(a4)
    800044ba:	a82d                	j	800044f4 <log_write+0xc8>
    panic("too big a transaction");
    800044bc:	00004517          	auipc	a0,0x4
    800044c0:	26c50513          	add	a0,a0,620 # 80008728 <syscalls+0x2c8>
    800044c4:	ffffc097          	auipc	ra,0xffffc
    800044c8:	078080e7          	jalr	120(ra) # 8000053c <panic>
    panic("log_write outside of trans");
    800044cc:	00004517          	auipc	a0,0x4
    800044d0:	27450513          	add	a0,a0,628 # 80008740 <syscalls+0x2e0>
    800044d4:	ffffc097          	auipc	ra,0xffffc
    800044d8:	068080e7          	jalr	104(ra) # 8000053c <panic>
  log.lh.block[i] = b->blockno;
    800044dc:	00878693          	add	a3,a5,8
    800044e0:	068a                	sll	a3,a3,0x2
    800044e2:	0001c717          	auipc	a4,0x1c
    800044e6:	70e70713          	add	a4,a4,1806 # 80020bf0 <log>
    800044ea:	9736                	add	a4,a4,a3
    800044ec:	44d4                	lw	a3,12(s1)
    800044ee:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800044f0:	faf609e3          	beq	a2,a5,800044a2 <log_write+0x76>
  }
  release(&log.lock);
    800044f4:	0001c517          	auipc	a0,0x1c
    800044f8:	6fc50513          	add	a0,a0,1788 # 80020bf0 <log>
    800044fc:	ffffc097          	auipc	ra,0xffffc
    80004500:	78a080e7          	jalr	1930(ra) # 80000c86 <release>
}
    80004504:	60e2                	ld	ra,24(sp)
    80004506:	6442                	ld	s0,16(sp)
    80004508:	64a2                	ld	s1,8(sp)
    8000450a:	6902                	ld	s2,0(sp)
    8000450c:	6105                	add	sp,sp,32
    8000450e:	8082                	ret

0000000080004510 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004510:	1101                	add	sp,sp,-32
    80004512:	ec06                	sd	ra,24(sp)
    80004514:	e822                	sd	s0,16(sp)
    80004516:	e426                	sd	s1,8(sp)
    80004518:	e04a                	sd	s2,0(sp)
    8000451a:	1000                	add	s0,sp,32
    8000451c:	84aa                	mv	s1,a0
    8000451e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004520:	00004597          	auipc	a1,0x4
    80004524:	24058593          	add	a1,a1,576 # 80008760 <syscalls+0x300>
    80004528:	0521                	add	a0,a0,8
    8000452a:	ffffc097          	auipc	ra,0xffffc
    8000452e:	618080e7          	jalr	1560(ra) # 80000b42 <initlock>
  lk->name = name;
    80004532:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004536:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000453a:	0204a423          	sw	zero,40(s1)
}
    8000453e:	60e2                	ld	ra,24(sp)
    80004540:	6442                	ld	s0,16(sp)
    80004542:	64a2                	ld	s1,8(sp)
    80004544:	6902                	ld	s2,0(sp)
    80004546:	6105                	add	sp,sp,32
    80004548:	8082                	ret

000000008000454a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000454a:	1101                	add	sp,sp,-32
    8000454c:	ec06                	sd	ra,24(sp)
    8000454e:	e822                	sd	s0,16(sp)
    80004550:	e426                	sd	s1,8(sp)
    80004552:	e04a                	sd	s2,0(sp)
    80004554:	1000                	add	s0,sp,32
    80004556:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004558:	00850913          	add	s2,a0,8
    8000455c:	854a                	mv	a0,s2
    8000455e:	ffffc097          	auipc	ra,0xffffc
    80004562:	674080e7          	jalr	1652(ra) # 80000bd2 <acquire>
  while (lk->locked) {
    80004566:	409c                	lw	a5,0(s1)
    80004568:	cb89                	beqz	a5,8000457a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000456a:	85ca                	mv	a1,s2
    8000456c:	8526                	mv	a0,s1
    8000456e:	ffffe097          	auipc	ra,0xffffe
    80004572:	ae0080e7          	jalr	-1312(ra) # 8000204e <sleep>
  while (lk->locked) {
    80004576:	409c                	lw	a5,0(s1)
    80004578:	fbed                	bnez	a5,8000456a <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000457a:	4785                	li	a5,1
    8000457c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000457e:	ffffd097          	auipc	ra,0xffffd
    80004582:	428080e7          	jalr	1064(ra) # 800019a6 <myproc>
    80004586:	591c                	lw	a5,48(a0)
    80004588:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000458a:	854a                	mv	a0,s2
    8000458c:	ffffc097          	auipc	ra,0xffffc
    80004590:	6fa080e7          	jalr	1786(ra) # 80000c86 <release>
}
    80004594:	60e2                	ld	ra,24(sp)
    80004596:	6442                	ld	s0,16(sp)
    80004598:	64a2                	ld	s1,8(sp)
    8000459a:	6902                	ld	s2,0(sp)
    8000459c:	6105                	add	sp,sp,32
    8000459e:	8082                	ret

00000000800045a0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800045a0:	1101                	add	sp,sp,-32
    800045a2:	ec06                	sd	ra,24(sp)
    800045a4:	e822                	sd	s0,16(sp)
    800045a6:	e426                	sd	s1,8(sp)
    800045a8:	e04a                	sd	s2,0(sp)
    800045aa:	1000                	add	s0,sp,32
    800045ac:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800045ae:	00850913          	add	s2,a0,8
    800045b2:	854a                	mv	a0,s2
    800045b4:	ffffc097          	auipc	ra,0xffffc
    800045b8:	61e080e7          	jalr	1566(ra) # 80000bd2 <acquire>
  lk->locked = 0;
    800045bc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800045c0:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800045c4:	8526                	mv	a0,s1
    800045c6:	ffffe097          	auipc	ra,0xffffe
    800045ca:	aec080e7          	jalr	-1300(ra) # 800020b2 <wakeup>
  release(&lk->lk);
    800045ce:	854a                	mv	a0,s2
    800045d0:	ffffc097          	auipc	ra,0xffffc
    800045d4:	6b6080e7          	jalr	1718(ra) # 80000c86 <release>
}
    800045d8:	60e2                	ld	ra,24(sp)
    800045da:	6442                	ld	s0,16(sp)
    800045dc:	64a2                	ld	s1,8(sp)
    800045de:	6902                	ld	s2,0(sp)
    800045e0:	6105                	add	sp,sp,32
    800045e2:	8082                	ret

00000000800045e4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800045e4:	7179                	add	sp,sp,-48
    800045e6:	f406                	sd	ra,40(sp)
    800045e8:	f022                	sd	s0,32(sp)
    800045ea:	ec26                	sd	s1,24(sp)
    800045ec:	e84a                	sd	s2,16(sp)
    800045ee:	e44e                	sd	s3,8(sp)
    800045f0:	1800                	add	s0,sp,48
    800045f2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800045f4:	00850913          	add	s2,a0,8
    800045f8:	854a                	mv	a0,s2
    800045fa:	ffffc097          	auipc	ra,0xffffc
    800045fe:	5d8080e7          	jalr	1496(ra) # 80000bd2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004602:	409c                	lw	a5,0(s1)
    80004604:	ef99                	bnez	a5,80004622 <holdingsleep+0x3e>
    80004606:	4481                	li	s1,0
  release(&lk->lk);
    80004608:	854a                	mv	a0,s2
    8000460a:	ffffc097          	auipc	ra,0xffffc
    8000460e:	67c080e7          	jalr	1660(ra) # 80000c86 <release>
  return r;
}
    80004612:	8526                	mv	a0,s1
    80004614:	70a2                	ld	ra,40(sp)
    80004616:	7402                	ld	s0,32(sp)
    80004618:	64e2                	ld	s1,24(sp)
    8000461a:	6942                	ld	s2,16(sp)
    8000461c:	69a2                	ld	s3,8(sp)
    8000461e:	6145                	add	sp,sp,48
    80004620:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004622:	0284a983          	lw	s3,40(s1)
    80004626:	ffffd097          	auipc	ra,0xffffd
    8000462a:	380080e7          	jalr	896(ra) # 800019a6 <myproc>
    8000462e:	5904                	lw	s1,48(a0)
    80004630:	413484b3          	sub	s1,s1,s3
    80004634:	0014b493          	seqz	s1,s1
    80004638:	bfc1                	j	80004608 <holdingsleep+0x24>

000000008000463a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000463a:	1141                	add	sp,sp,-16
    8000463c:	e406                	sd	ra,8(sp)
    8000463e:	e022                	sd	s0,0(sp)
    80004640:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004642:	00004597          	auipc	a1,0x4
    80004646:	12e58593          	add	a1,a1,302 # 80008770 <syscalls+0x310>
    8000464a:	0001c517          	auipc	a0,0x1c
    8000464e:	6ee50513          	add	a0,a0,1774 # 80020d38 <ftable>
    80004652:	ffffc097          	auipc	ra,0xffffc
    80004656:	4f0080e7          	jalr	1264(ra) # 80000b42 <initlock>
}
    8000465a:	60a2                	ld	ra,8(sp)
    8000465c:	6402                	ld	s0,0(sp)
    8000465e:	0141                	add	sp,sp,16
    80004660:	8082                	ret

0000000080004662 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004662:	1101                	add	sp,sp,-32
    80004664:	ec06                	sd	ra,24(sp)
    80004666:	e822                	sd	s0,16(sp)
    80004668:	e426                	sd	s1,8(sp)
    8000466a:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000466c:	0001c517          	auipc	a0,0x1c
    80004670:	6cc50513          	add	a0,a0,1740 # 80020d38 <ftable>
    80004674:	ffffc097          	auipc	ra,0xffffc
    80004678:	55e080e7          	jalr	1374(ra) # 80000bd2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000467c:	0001c497          	auipc	s1,0x1c
    80004680:	6d448493          	add	s1,s1,1748 # 80020d50 <ftable+0x18>
    80004684:	0001d717          	auipc	a4,0x1d
    80004688:	66c70713          	add	a4,a4,1644 # 80021cf0 <disk>
    if(f->ref == 0){
    8000468c:	40dc                	lw	a5,4(s1)
    8000468e:	cf99                	beqz	a5,800046ac <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004690:	02848493          	add	s1,s1,40
    80004694:	fee49ce3          	bne	s1,a4,8000468c <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004698:	0001c517          	auipc	a0,0x1c
    8000469c:	6a050513          	add	a0,a0,1696 # 80020d38 <ftable>
    800046a0:	ffffc097          	auipc	ra,0xffffc
    800046a4:	5e6080e7          	jalr	1510(ra) # 80000c86 <release>
  return 0;
    800046a8:	4481                	li	s1,0
    800046aa:	a819                	j	800046c0 <filealloc+0x5e>
      f->ref = 1;
    800046ac:	4785                	li	a5,1
    800046ae:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800046b0:	0001c517          	auipc	a0,0x1c
    800046b4:	68850513          	add	a0,a0,1672 # 80020d38 <ftable>
    800046b8:	ffffc097          	auipc	ra,0xffffc
    800046bc:	5ce080e7          	jalr	1486(ra) # 80000c86 <release>
}
    800046c0:	8526                	mv	a0,s1
    800046c2:	60e2                	ld	ra,24(sp)
    800046c4:	6442                	ld	s0,16(sp)
    800046c6:	64a2                	ld	s1,8(sp)
    800046c8:	6105                	add	sp,sp,32
    800046ca:	8082                	ret

00000000800046cc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800046cc:	1101                	add	sp,sp,-32
    800046ce:	ec06                	sd	ra,24(sp)
    800046d0:	e822                	sd	s0,16(sp)
    800046d2:	e426                	sd	s1,8(sp)
    800046d4:	1000                	add	s0,sp,32
    800046d6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800046d8:	0001c517          	auipc	a0,0x1c
    800046dc:	66050513          	add	a0,a0,1632 # 80020d38 <ftable>
    800046e0:	ffffc097          	auipc	ra,0xffffc
    800046e4:	4f2080e7          	jalr	1266(ra) # 80000bd2 <acquire>
  if(f->ref < 1)
    800046e8:	40dc                	lw	a5,4(s1)
    800046ea:	02f05263          	blez	a5,8000470e <filedup+0x42>
    panic("filedup");
  f->ref++;
    800046ee:	2785                	addw	a5,a5,1
    800046f0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800046f2:	0001c517          	auipc	a0,0x1c
    800046f6:	64650513          	add	a0,a0,1606 # 80020d38 <ftable>
    800046fa:	ffffc097          	auipc	ra,0xffffc
    800046fe:	58c080e7          	jalr	1420(ra) # 80000c86 <release>
  return f;
}
    80004702:	8526                	mv	a0,s1
    80004704:	60e2                	ld	ra,24(sp)
    80004706:	6442                	ld	s0,16(sp)
    80004708:	64a2                	ld	s1,8(sp)
    8000470a:	6105                	add	sp,sp,32
    8000470c:	8082                	ret
    panic("filedup");
    8000470e:	00004517          	auipc	a0,0x4
    80004712:	06a50513          	add	a0,a0,106 # 80008778 <syscalls+0x318>
    80004716:	ffffc097          	auipc	ra,0xffffc
    8000471a:	e26080e7          	jalr	-474(ra) # 8000053c <panic>

000000008000471e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000471e:	7139                	add	sp,sp,-64
    80004720:	fc06                	sd	ra,56(sp)
    80004722:	f822                	sd	s0,48(sp)
    80004724:	f426                	sd	s1,40(sp)
    80004726:	f04a                	sd	s2,32(sp)
    80004728:	ec4e                	sd	s3,24(sp)
    8000472a:	e852                	sd	s4,16(sp)
    8000472c:	e456                	sd	s5,8(sp)
    8000472e:	0080                	add	s0,sp,64
    80004730:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004732:	0001c517          	auipc	a0,0x1c
    80004736:	60650513          	add	a0,a0,1542 # 80020d38 <ftable>
    8000473a:	ffffc097          	auipc	ra,0xffffc
    8000473e:	498080e7          	jalr	1176(ra) # 80000bd2 <acquire>
  if(f->ref < 1)
    80004742:	40dc                	lw	a5,4(s1)
    80004744:	06f05163          	blez	a5,800047a6 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004748:	37fd                	addw	a5,a5,-1
    8000474a:	0007871b          	sext.w	a4,a5
    8000474e:	c0dc                	sw	a5,4(s1)
    80004750:	06e04363          	bgtz	a4,800047b6 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004754:	0004a903          	lw	s2,0(s1)
    80004758:	0094ca83          	lbu	s5,9(s1)
    8000475c:	0104ba03          	ld	s4,16(s1)
    80004760:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004764:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004768:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000476c:	0001c517          	auipc	a0,0x1c
    80004770:	5cc50513          	add	a0,a0,1484 # 80020d38 <ftable>
    80004774:	ffffc097          	auipc	ra,0xffffc
    80004778:	512080e7          	jalr	1298(ra) # 80000c86 <release>

  if(ff.type == FD_PIPE){
    8000477c:	4785                	li	a5,1
    8000477e:	04f90d63          	beq	s2,a5,800047d8 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004782:	3979                	addw	s2,s2,-2
    80004784:	4785                	li	a5,1
    80004786:	0527e063          	bltu	a5,s2,800047c6 <fileclose+0xa8>
    begin_op();
    8000478a:	00000097          	auipc	ra,0x0
    8000478e:	ad0080e7          	jalr	-1328(ra) # 8000425a <begin_op>
    iput(ff.ip);
    80004792:	854e                	mv	a0,s3
    80004794:	fffff097          	auipc	ra,0xfffff
    80004798:	2d8080e7          	jalr	728(ra) # 80003a6c <iput>
    end_op();
    8000479c:	00000097          	auipc	ra,0x0
    800047a0:	b38080e7          	jalr	-1224(ra) # 800042d4 <end_op>
    800047a4:	a00d                	j	800047c6 <fileclose+0xa8>
    panic("fileclose");
    800047a6:	00004517          	auipc	a0,0x4
    800047aa:	fda50513          	add	a0,a0,-38 # 80008780 <syscalls+0x320>
    800047ae:	ffffc097          	auipc	ra,0xffffc
    800047b2:	d8e080e7          	jalr	-626(ra) # 8000053c <panic>
    release(&ftable.lock);
    800047b6:	0001c517          	auipc	a0,0x1c
    800047ba:	58250513          	add	a0,a0,1410 # 80020d38 <ftable>
    800047be:	ffffc097          	auipc	ra,0xffffc
    800047c2:	4c8080e7          	jalr	1224(ra) # 80000c86 <release>
  }
}
    800047c6:	70e2                	ld	ra,56(sp)
    800047c8:	7442                	ld	s0,48(sp)
    800047ca:	74a2                	ld	s1,40(sp)
    800047cc:	7902                	ld	s2,32(sp)
    800047ce:	69e2                	ld	s3,24(sp)
    800047d0:	6a42                	ld	s4,16(sp)
    800047d2:	6aa2                	ld	s5,8(sp)
    800047d4:	6121                	add	sp,sp,64
    800047d6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800047d8:	85d6                	mv	a1,s5
    800047da:	8552                	mv	a0,s4
    800047dc:	00000097          	auipc	ra,0x0
    800047e0:	348080e7          	jalr	840(ra) # 80004b24 <pipeclose>
    800047e4:	b7cd                	j	800047c6 <fileclose+0xa8>

00000000800047e6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800047e6:	715d                	add	sp,sp,-80
    800047e8:	e486                	sd	ra,72(sp)
    800047ea:	e0a2                	sd	s0,64(sp)
    800047ec:	fc26                	sd	s1,56(sp)
    800047ee:	f84a                	sd	s2,48(sp)
    800047f0:	f44e                	sd	s3,40(sp)
    800047f2:	0880                	add	s0,sp,80
    800047f4:	84aa                	mv	s1,a0
    800047f6:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800047f8:	ffffd097          	auipc	ra,0xffffd
    800047fc:	1ae080e7          	jalr	430(ra) # 800019a6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004800:	409c                	lw	a5,0(s1)
    80004802:	37f9                	addw	a5,a5,-2
    80004804:	4705                	li	a4,1
    80004806:	04f76763          	bltu	a4,a5,80004854 <filestat+0x6e>
    8000480a:	892a                	mv	s2,a0
    ilock(f->ip);
    8000480c:	6c88                	ld	a0,24(s1)
    8000480e:	fffff097          	auipc	ra,0xfffff
    80004812:	0a4080e7          	jalr	164(ra) # 800038b2 <ilock>
    stati(f->ip, &st);
    80004816:	fb840593          	add	a1,s0,-72
    8000481a:	6c88                	ld	a0,24(s1)
    8000481c:	fffff097          	auipc	ra,0xfffff
    80004820:	320080e7          	jalr	800(ra) # 80003b3c <stati>
    iunlock(f->ip);
    80004824:	6c88                	ld	a0,24(s1)
    80004826:	fffff097          	auipc	ra,0xfffff
    8000482a:	14e080e7          	jalr	334(ra) # 80003974 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000482e:	46e1                	li	a3,24
    80004830:	fb840613          	add	a2,s0,-72
    80004834:	85ce                	mv	a1,s3
    80004836:	05093503          	ld	a0,80(s2)
    8000483a:	ffffd097          	auipc	ra,0xffffd
    8000483e:	e2c080e7          	jalr	-468(ra) # 80001666 <copyout>
    80004842:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004846:	60a6                	ld	ra,72(sp)
    80004848:	6406                	ld	s0,64(sp)
    8000484a:	74e2                	ld	s1,56(sp)
    8000484c:	7942                	ld	s2,48(sp)
    8000484e:	79a2                	ld	s3,40(sp)
    80004850:	6161                	add	sp,sp,80
    80004852:	8082                	ret
  return -1;
    80004854:	557d                	li	a0,-1
    80004856:	bfc5                	j	80004846 <filestat+0x60>

0000000080004858 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004858:	7179                	add	sp,sp,-48
    8000485a:	f406                	sd	ra,40(sp)
    8000485c:	f022                	sd	s0,32(sp)
    8000485e:	ec26                	sd	s1,24(sp)
    80004860:	e84a                	sd	s2,16(sp)
    80004862:	e44e                	sd	s3,8(sp)
    80004864:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004866:	00854783          	lbu	a5,8(a0)
    8000486a:	c3d5                	beqz	a5,8000490e <fileread+0xb6>
    8000486c:	84aa                	mv	s1,a0
    8000486e:	89ae                	mv	s3,a1
    80004870:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004872:	411c                	lw	a5,0(a0)
    80004874:	4705                	li	a4,1
    80004876:	04e78963          	beq	a5,a4,800048c8 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000487a:	470d                	li	a4,3
    8000487c:	04e78d63          	beq	a5,a4,800048d6 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004880:	4709                	li	a4,2
    80004882:	06e79e63          	bne	a5,a4,800048fe <fileread+0xa6>
    ilock(f->ip);
    80004886:	6d08                	ld	a0,24(a0)
    80004888:	fffff097          	auipc	ra,0xfffff
    8000488c:	02a080e7          	jalr	42(ra) # 800038b2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004890:	874a                	mv	a4,s2
    80004892:	5094                	lw	a3,32(s1)
    80004894:	864e                	mv	a2,s3
    80004896:	4585                	li	a1,1
    80004898:	6c88                	ld	a0,24(s1)
    8000489a:	fffff097          	auipc	ra,0xfffff
    8000489e:	2cc080e7          	jalr	716(ra) # 80003b66 <readi>
    800048a2:	892a                	mv	s2,a0
    800048a4:	00a05563          	blez	a0,800048ae <fileread+0x56>
      f->off += r;
    800048a8:	509c                	lw	a5,32(s1)
    800048aa:	9fa9                	addw	a5,a5,a0
    800048ac:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800048ae:	6c88                	ld	a0,24(s1)
    800048b0:	fffff097          	auipc	ra,0xfffff
    800048b4:	0c4080e7          	jalr	196(ra) # 80003974 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800048b8:	854a                	mv	a0,s2
    800048ba:	70a2                	ld	ra,40(sp)
    800048bc:	7402                	ld	s0,32(sp)
    800048be:	64e2                	ld	s1,24(sp)
    800048c0:	6942                	ld	s2,16(sp)
    800048c2:	69a2                	ld	s3,8(sp)
    800048c4:	6145                	add	sp,sp,48
    800048c6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800048c8:	6908                	ld	a0,16(a0)
    800048ca:	00000097          	auipc	ra,0x0
    800048ce:	3c2080e7          	jalr	962(ra) # 80004c8c <piperead>
    800048d2:	892a                	mv	s2,a0
    800048d4:	b7d5                	j	800048b8 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800048d6:	02451783          	lh	a5,36(a0)
    800048da:	03079693          	sll	a3,a5,0x30
    800048de:	92c1                	srl	a3,a3,0x30
    800048e0:	4725                	li	a4,9
    800048e2:	02d76863          	bltu	a4,a3,80004912 <fileread+0xba>
    800048e6:	0792                	sll	a5,a5,0x4
    800048e8:	0001c717          	auipc	a4,0x1c
    800048ec:	3b070713          	add	a4,a4,944 # 80020c98 <devsw>
    800048f0:	97ba                	add	a5,a5,a4
    800048f2:	639c                	ld	a5,0(a5)
    800048f4:	c38d                	beqz	a5,80004916 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800048f6:	4505                	li	a0,1
    800048f8:	9782                	jalr	a5
    800048fa:	892a                	mv	s2,a0
    800048fc:	bf75                	j	800048b8 <fileread+0x60>
    panic("fileread");
    800048fe:	00004517          	auipc	a0,0x4
    80004902:	e9250513          	add	a0,a0,-366 # 80008790 <syscalls+0x330>
    80004906:	ffffc097          	auipc	ra,0xffffc
    8000490a:	c36080e7          	jalr	-970(ra) # 8000053c <panic>
    return -1;
    8000490e:	597d                	li	s2,-1
    80004910:	b765                	j	800048b8 <fileread+0x60>
      return -1;
    80004912:	597d                	li	s2,-1
    80004914:	b755                	j	800048b8 <fileread+0x60>
    80004916:	597d                	li	s2,-1
    80004918:	b745                	j	800048b8 <fileread+0x60>

000000008000491a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000491a:	00954783          	lbu	a5,9(a0)
    8000491e:	10078e63          	beqz	a5,80004a3a <filewrite+0x120>
{
    80004922:	715d                	add	sp,sp,-80
    80004924:	e486                	sd	ra,72(sp)
    80004926:	e0a2                	sd	s0,64(sp)
    80004928:	fc26                	sd	s1,56(sp)
    8000492a:	f84a                	sd	s2,48(sp)
    8000492c:	f44e                	sd	s3,40(sp)
    8000492e:	f052                	sd	s4,32(sp)
    80004930:	ec56                	sd	s5,24(sp)
    80004932:	e85a                	sd	s6,16(sp)
    80004934:	e45e                	sd	s7,8(sp)
    80004936:	e062                	sd	s8,0(sp)
    80004938:	0880                	add	s0,sp,80
    8000493a:	892a                	mv	s2,a0
    8000493c:	8b2e                	mv	s6,a1
    8000493e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004940:	411c                	lw	a5,0(a0)
    80004942:	4705                	li	a4,1
    80004944:	02e78263          	beq	a5,a4,80004968 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004948:	470d                	li	a4,3
    8000494a:	02e78563          	beq	a5,a4,80004974 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000494e:	4709                	li	a4,2
    80004950:	0ce79d63          	bne	a5,a4,80004a2a <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004954:	0ac05b63          	blez	a2,80004a0a <filewrite+0xf0>
    int i = 0;
    80004958:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    8000495a:	6b85                	lui	s7,0x1
    8000495c:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004960:	6c05                	lui	s8,0x1
    80004962:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004966:	a851                	j	800049fa <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004968:	6908                	ld	a0,16(a0)
    8000496a:	00000097          	auipc	ra,0x0
    8000496e:	22a080e7          	jalr	554(ra) # 80004b94 <pipewrite>
    80004972:	a045                	j	80004a12 <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004974:	02451783          	lh	a5,36(a0)
    80004978:	03079693          	sll	a3,a5,0x30
    8000497c:	92c1                	srl	a3,a3,0x30
    8000497e:	4725                	li	a4,9
    80004980:	0ad76f63          	bltu	a4,a3,80004a3e <filewrite+0x124>
    80004984:	0792                	sll	a5,a5,0x4
    80004986:	0001c717          	auipc	a4,0x1c
    8000498a:	31270713          	add	a4,a4,786 # 80020c98 <devsw>
    8000498e:	97ba                	add	a5,a5,a4
    80004990:	679c                	ld	a5,8(a5)
    80004992:	cbc5                	beqz	a5,80004a42 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80004994:	4505                	li	a0,1
    80004996:	9782                	jalr	a5
    80004998:	a8ad                	j	80004a12 <filewrite+0xf8>
      if(n1 > max)
    8000499a:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    8000499e:	00000097          	auipc	ra,0x0
    800049a2:	8bc080e7          	jalr	-1860(ra) # 8000425a <begin_op>
      ilock(f->ip);
    800049a6:	01893503          	ld	a0,24(s2)
    800049aa:	fffff097          	auipc	ra,0xfffff
    800049ae:	f08080e7          	jalr	-248(ra) # 800038b2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800049b2:	8756                	mv	a4,s5
    800049b4:	02092683          	lw	a3,32(s2)
    800049b8:	01698633          	add	a2,s3,s6
    800049bc:	4585                	li	a1,1
    800049be:	01893503          	ld	a0,24(s2)
    800049c2:	fffff097          	auipc	ra,0xfffff
    800049c6:	29c080e7          	jalr	668(ra) # 80003c5e <writei>
    800049ca:	84aa                	mv	s1,a0
    800049cc:	00a05763          	blez	a0,800049da <filewrite+0xc0>
        f->off += r;
    800049d0:	02092783          	lw	a5,32(s2)
    800049d4:	9fa9                	addw	a5,a5,a0
    800049d6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800049da:	01893503          	ld	a0,24(s2)
    800049de:	fffff097          	auipc	ra,0xfffff
    800049e2:	f96080e7          	jalr	-106(ra) # 80003974 <iunlock>
      end_op();
    800049e6:	00000097          	auipc	ra,0x0
    800049ea:	8ee080e7          	jalr	-1810(ra) # 800042d4 <end_op>

      if(r != n1){
    800049ee:	009a9f63          	bne	s5,s1,80004a0c <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    800049f2:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800049f6:	0149db63          	bge	s3,s4,80004a0c <filewrite+0xf2>
      int n1 = n - i;
    800049fa:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800049fe:	0004879b          	sext.w	a5,s1
    80004a02:	f8fbdce3          	bge	s7,a5,8000499a <filewrite+0x80>
    80004a06:	84e2                	mv	s1,s8
    80004a08:	bf49                	j	8000499a <filewrite+0x80>
    int i = 0;
    80004a0a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004a0c:	033a1d63          	bne	s4,s3,80004a46 <filewrite+0x12c>
    80004a10:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004a12:	60a6                	ld	ra,72(sp)
    80004a14:	6406                	ld	s0,64(sp)
    80004a16:	74e2                	ld	s1,56(sp)
    80004a18:	7942                	ld	s2,48(sp)
    80004a1a:	79a2                	ld	s3,40(sp)
    80004a1c:	7a02                	ld	s4,32(sp)
    80004a1e:	6ae2                	ld	s5,24(sp)
    80004a20:	6b42                	ld	s6,16(sp)
    80004a22:	6ba2                	ld	s7,8(sp)
    80004a24:	6c02                	ld	s8,0(sp)
    80004a26:	6161                	add	sp,sp,80
    80004a28:	8082                	ret
    panic("filewrite");
    80004a2a:	00004517          	auipc	a0,0x4
    80004a2e:	d7650513          	add	a0,a0,-650 # 800087a0 <syscalls+0x340>
    80004a32:	ffffc097          	auipc	ra,0xffffc
    80004a36:	b0a080e7          	jalr	-1270(ra) # 8000053c <panic>
    return -1;
    80004a3a:	557d                	li	a0,-1
}
    80004a3c:	8082                	ret
      return -1;
    80004a3e:	557d                	li	a0,-1
    80004a40:	bfc9                	j	80004a12 <filewrite+0xf8>
    80004a42:	557d                	li	a0,-1
    80004a44:	b7f9                	j	80004a12 <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80004a46:	557d                	li	a0,-1
    80004a48:	b7e9                	j	80004a12 <filewrite+0xf8>

0000000080004a4a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004a4a:	7179                	add	sp,sp,-48
    80004a4c:	f406                	sd	ra,40(sp)
    80004a4e:	f022                	sd	s0,32(sp)
    80004a50:	ec26                	sd	s1,24(sp)
    80004a52:	e84a                	sd	s2,16(sp)
    80004a54:	e44e                	sd	s3,8(sp)
    80004a56:	e052                	sd	s4,0(sp)
    80004a58:	1800                	add	s0,sp,48
    80004a5a:	84aa                	mv	s1,a0
    80004a5c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004a5e:	0005b023          	sd	zero,0(a1)
    80004a62:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004a66:	00000097          	auipc	ra,0x0
    80004a6a:	bfc080e7          	jalr	-1028(ra) # 80004662 <filealloc>
    80004a6e:	e088                	sd	a0,0(s1)
    80004a70:	c551                	beqz	a0,80004afc <pipealloc+0xb2>
    80004a72:	00000097          	auipc	ra,0x0
    80004a76:	bf0080e7          	jalr	-1040(ra) # 80004662 <filealloc>
    80004a7a:	00aa3023          	sd	a0,0(s4)
    80004a7e:	c92d                	beqz	a0,80004af0 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004a80:	ffffc097          	auipc	ra,0xffffc
    80004a84:	062080e7          	jalr	98(ra) # 80000ae2 <kalloc>
    80004a88:	892a                	mv	s2,a0
    80004a8a:	c125                	beqz	a0,80004aea <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004a8c:	4985                	li	s3,1
    80004a8e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004a92:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004a96:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004a9a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004a9e:	00004597          	auipc	a1,0x4
    80004aa2:	d1258593          	add	a1,a1,-750 # 800087b0 <syscalls+0x350>
    80004aa6:	ffffc097          	auipc	ra,0xffffc
    80004aaa:	09c080e7          	jalr	156(ra) # 80000b42 <initlock>
  (*f0)->type = FD_PIPE;
    80004aae:	609c                	ld	a5,0(s1)
    80004ab0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004ab4:	609c                	ld	a5,0(s1)
    80004ab6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004aba:	609c                	ld	a5,0(s1)
    80004abc:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004ac0:	609c                	ld	a5,0(s1)
    80004ac2:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004ac6:	000a3783          	ld	a5,0(s4)
    80004aca:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004ace:	000a3783          	ld	a5,0(s4)
    80004ad2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004ad6:	000a3783          	ld	a5,0(s4)
    80004ada:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004ade:	000a3783          	ld	a5,0(s4)
    80004ae2:	0127b823          	sd	s2,16(a5)
  return 0;
    80004ae6:	4501                	li	a0,0
    80004ae8:	a025                	j	80004b10 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004aea:	6088                	ld	a0,0(s1)
    80004aec:	e501                	bnez	a0,80004af4 <pipealloc+0xaa>
    80004aee:	a039                	j	80004afc <pipealloc+0xb2>
    80004af0:	6088                	ld	a0,0(s1)
    80004af2:	c51d                	beqz	a0,80004b20 <pipealloc+0xd6>
    fileclose(*f0);
    80004af4:	00000097          	auipc	ra,0x0
    80004af8:	c2a080e7          	jalr	-982(ra) # 8000471e <fileclose>
  if(*f1)
    80004afc:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004b00:	557d                	li	a0,-1
  if(*f1)
    80004b02:	c799                	beqz	a5,80004b10 <pipealloc+0xc6>
    fileclose(*f1);
    80004b04:	853e                	mv	a0,a5
    80004b06:	00000097          	auipc	ra,0x0
    80004b0a:	c18080e7          	jalr	-1000(ra) # 8000471e <fileclose>
  return -1;
    80004b0e:	557d                	li	a0,-1
}
    80004b10:	70a2                	ld	ra,40(sp)
    80004b12:	7402                	ld	s0,32(sp)
    80004b14:	64e2                	ld	s1,24(sp)
    80004b16:	6942                	ld	s2,16(sp)
    80004b18:	69a2                	ld	s3,8(sp)
    80004b1a:	6a02                	ld	s4,0(sp)
    80004b1c:	6145                	add	sp,sp,48
    80004b1e:	8082                	ret
  return -1;
    80004b20:	557d                	li	a0,-1
    80004b22:	b7fd                	j	80004b10 <pipealloc+0xc6>

0000000080004b24 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004b24:	1101                	add	sp,sp,-32
    80004b26:	ec06                	sd	ra,24(sp)
    80004b28:	e822                	sd	s0,16(sp)
    80004b2a:	e426                	sd	s1,8(sp)
    80004b2c:	e04a                	sd	s2,0(sp)
    80004b2e:	1000                	add	s0,sp,32
    80004b30:	84aa                	mv	s1,a0
    80004b32:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004b34:	ffffc097          	auipc	ra,0xffffc
    80004b38:	09e080e7          	jalr	158(ra) # 80000bd2 <acquire>
  if(writable){
    80004b3c:	02090d63          	beqz	s2,80004b76 <pipeclose+0x52>
    pi->writeopen = 0;
    80004b40:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004b44:	21848513          	add	a0,s1,536
    80004b48:	ffffd097          	auipc	ra,0xffffd
    80004b4c:	56a080e7          	jalr	1386(ra) # 800020b2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004b50:	2204b783          	ld	a5,544(s1)
    80004b54:	eb95                	bnez	a5,80004b88 <pipeclose+0x64>
    release(&pi->lock);
    80004b56:	8526                	mv	a0,s1
    80004b58:	ffffc097          	auipc	ra,0xffffc
    80004b5c:	12e080e7          	jalr	302(ra) # 80000c86 <release>
    kfree((char*)pi);
    80004b60:	8526                	mv	a0,s1
    80004b62:	ffffc097          	auipc	ra,0xffffc
    80004b66:	e82080e7          	jalr	-382(ra) # 800009e4 <kfree>
  } else
    release(&pi->lock);
}
    80004b6a:	60e2                	ld	ra,24(sp)
    80004b6c:	6442                	ld	s0,16(sp)
    80004b6e:	64a2                	ld	s1,8(sp)
    80004b70:	6902                	ld	s2,0(sp)
    80004b72:	6105                	add	sp,sp,32
    80004b74:	8082                	ret
    pi->readopen = 0;
    80004b76:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004b7a:	21c48513          	add	a0,s1,540
    80004b7e:	ffffd097          	auipc	ra,0xffffd
    80004b82:	534080e7          	jalr	1332(ra) # 800020b2 <wakeup>
    80004b86:	b7e9                	j	80004b50 <pipeclose+0x2c>
    release(&pi->lock);
    80004b88:	8526                	mv	a0,s1
    80004b8a:	ffffc097          	auipc	ra,0xffffc
    80004b8e:	0fc080e7          	jalr	252(ra) # 80000c86 <release>
}
    80004b92:	bfe1                	j	80004b6a <pipeclose+0x46>

0000000080004b94 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004b94:	711d                	add	sp,sp,-96
    80004b96:	ec86                	sd	ra,88(sp)
    80004b98:	e8a2                	sd	s0,80(sp)
    80004b9a:	e4a6                	sd	s1,72(sp)
    80004b9c:	e0ca                	sd	s2,64(sp)
    80004b9e:	fc4e                	sd	s3,56(sp)
    80004ba0:	f852                	sd	s4,48(sp)
    80004ba2:	f456                	sd	s5,40(sp)
    80004ba4:	f05a                	sd	s6,32(sp)
    80004ba6:	ec5e                	sd	s7,24(sp)
    80004ba8:	e862                	sd	s8,16(sp)
    80004baa:	1080                	add	s0,sp,96
    80004bac:	84aa                	mv	s1,a0
    80004bae:	8aae                	mv	s5,a1
    80004bb0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004bb2:	ffffd097          	auipc	ra,0xffffd
    80004bb6:	df4080e7          	jalr	-524(ra) # 800019a6 <myproc>
    80004bba:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004bbc:	8526                	mv	a0,s1
    80004bbe:	ffffc097          	auipc	ra,0xffffc
    80004bc2:	014080e7          	jalr	20(ra) # 80000bd2 <acquire>
  while(i < n){
    80004bc6:	0b405663          	blez	s4,80004c72 <pipewrite+0xde>
  int i = 0;
    80004bca:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004bcc:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004bce:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004bd2:	21c48b93          	add	s7,s1,540
    80004bd6:	a089                	j	80004c18 <pipewrite+0x84>
      release(&pi->lock);
    80004bd8:	8526                	mv	a0,s1
    80004bda:	ffffc097          	auipc	ra,0xffffc
    80004bde:	0ac080e7          	jalr	172(ra) # 80000c86 <release>
      return -1;
    80004be2:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004be4:	854a                	mv	a0,s2
    80004be6:	60e6                	ld	ra,88(sp)
    80004be8:	6446                	ld	s0,80(sp)
    80004bea:	64a6                	ld	s1,72(sp)
    80004bec:	6906                	ld	s2,64(sp)
    80004bee:	79e2                	ld	s3,56(sp)
    80004bf0:	7a42                	ld	s4,48(sp)
    80004bf2:	7aa2                	ld	s5,40(sp)
    80004bf4:	7b02                	ld	s6,32(sp)
    80004bf6:	6be2                	ld	s7,24(sp)
    80004bf8:	6c42                	ld	s8,16(sp)
    80004bfa:	6125                	add	sp,sp,96
    80004bfc:	8082                	ret
      wakeup(&pi->nread);
    80004bfe:	8562                	mv	a0,s8
    80004c00:	ffffd097          	auipc	ra,0xffffd
    80004c04:	4b2080e7          	jalr	1202(ra) # 800020b2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004c08:	85a6                	mv	a1,s1
    80004c0a:	855e                	mv	a0,s7
    80004c0c:	ffffd097          	auipc	ra,0xffffd
    80004c10:	442080e7          	jalr	1090(ra) # 8000204e <sleep>
  while(i < n){
    80004c14:	07495063          	bge	s2,s4,80004c74 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004c18:	2204a783          	lw	a5,544(s1)
    80004c1c:	dfd5                	beqz	a5,80004bd8 <pipewrite+0x44>
    80004c1e:	854e                	mv	a0,s3
    80004c20:	ffffd097          	auipc	ra,0xffffd
    80004c24:	6d6080e7          	jalr	1750(ra) # 800022f6 <killed>
    80004c28:	f945                	bnez	a0,80004bd8 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004c2a:	2184a783          	lw	a5,536(s1)
    80004c2e:	21c4a703          	lw	a4,540(s1)
    80004c32:	2007879b          	addw	a5,a5,512
    80004c36:	fcf704e3          	beq	a4,a5,80004bfe <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004c3a:	4685                	li	a3,1
    80004c3c:	01590633          	add	a2,s2,s5
    80004c40:	faf40593          	add	a1,s0,-81
    80004c44:	0509b503          	ld	a0,80(s3)
    80004c48:	ffffd097          	auipc	ra,0xffffd
    80004c4c:	aaa080e7          	jalr	-1366(ra) # 800016f2 <copyin>
    80004c50:	03650263          	beq	a0,s6,80004c74 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004c54:	21c4a783          	lw	a5,540(s1)
    80004c58:	0017871b          	addw	a4,a5,1
    80004c5c:	20e4ae23          	sw	a4,540(s1)
    80004c60:	1ff7f793          	and	a5,a5,511
    80004c64:	97a6                	add	a5,a5,s1
    80004c66:	faf44703          	lbu	a4,-81(s0)
    80004c6a:	00e78c23          	sb	a4,24(a5)
      i++;
    80004c6e:	2905                	addw	s2,s2,1
    80004c70:	b755                	j	80004c14 <pipewrite+0x80>
  int i = 0;
    80004c72:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004c74:	21848513          	add	a0,s1,536
    80004c78:	ffffd097          	auipc	ra,0xffffd
    80004c7c:	43a080e7          	jalr	1082(ra) # 800020b2 <wakeup>
  release(&pi->lock);
    80004c80:	8526                	mv	a0,s1
    80004c82:	ffffc097          	auipc	ra,0xffffc
    80004c86:	004080e7          	jalr	4(ra) # 80000c86 <release>
  return i;
    80004c8a:	bfa9                	j	80004be4 <pipewrite+0x50>

0000000080004c8c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004c8c:	715d                	add	sp,sp,-80
    80004c8e:	e486                	sd	ra,72(sp)
    80004c90:	e0a2                	sd	s0,64(sp)
    80004c92:	fc26                	sd	s1,56(sp)
    80004c94:	f84a                	sd	s2,48(sp)
    80004c96:	f44e                	sd	s3,40(sp)
    80004c98:	f052                	sd	s4,32(sp)
    80004c9a:	ec56                	sd	s5,24(sp)
    80004c9c:	e85a                	sd	s6,16(sp)
    80004c9e:	0880                	add	s0,sp,80
    80004ca0:	84aa                	mv	s1,a0
    80004ca2:	892e                	mv	s2,a1
    80004ca4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004ca6:	ffffd097          	auipc	ra,0xffffd
    80004caa:	d00080e7          	jalr	-768(ra) # 800019a6 <myproc>
    80004cae:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004cb0:	8526                	mv	a0,s1
    80004cb2:	ffffc097          	auipc	ra,0xffffc
    80004cb6:	f20080e7          	jalr	-224(ra) # 80000bd2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004cba:	2184a703          	lw	a4,536(s1)
    80004cbe:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004cc2:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004cc6:	02f71763          	bne	a4,a5,80004cf4 <piperead+0x68>
    80004cca:	2244a783          	lw	a5,548(s1)
    80004cce:	c39d                	beqz	a5,80004cf4 <piperead+0x68>
    if(killed(pr)){
    80004cd0:	8552                	mv	a0,s4
    80004cd2:	ffffd097          	auipc	ra,0xffffd
    80004cd6:	624080e7          	jalr	1572(ra) # 800022f6 <killed>
    80004cda:	e949                	bnez	a0,80004d6c <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004cdc:	85a6                	mv	a1,s1
    80004cde:	854e                	mv	a0,s3
    80004ce0:	ffffd097          	auipc	ra,0xffffd
    80004ce4:	36e080e7          	jalr	878(ra) # 8000204e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ce8:	2184a703          	lw	a4,536(s1)
    80004cec:	21c4a783          	lw	a5,540(s1)
    80004cf0:	fcf70de3          	beq	a4,a5,80004cca <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004cf4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004cf6:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004cf8:	05505463          	blez	s5,80004d40 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004cfc:	2184a783          	lw	a5,536(s1)
    80004d00:	21c4a703          	lw	a4,540(s1)
    80004d04:	02f70e63          	beq	a4,a5,80004d40 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004d08:	0017871b          	addw	a4,a5,1
    80004d0c:	20e4ac23          	sw	a4,536(s1)
    80004d10:	1ff7f793          	and	a5,a5,511
    80004d14:	97a6                	add	a5,a5,s1
    80004d16:	0187c783          	lbu	a5,24(a5)
    80004d1a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004d1e:	4685                	li	a3,1
    80004d20:	fbf40613          	add	a2,s0,-65
    80004d24:	85ca                	mv	a1,s2
    80004d26:	050a3503          	ld	a0,80(s4)
    80004d2a:	ffffd097          	auipc	ra,0xffffd
    80004d2e:	93c080e7          	jalr	-1732(ra) # 80001666 <copyout>
    80004d32:	01650763          	beq	a0,s6,80004d40 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004d36:	2985                	addw	s3,s3,1
    80004d38:	0905                	add	s2,s2,1
    80004d3a:	fd3a91e3          	bne	s5,s3,80004cfc <piperead+0x70>
    80004d3e:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004d40:	21c48513          	add	a0,s1,540
    80004d44:	ffffd097          	auipc	ra,0xffffd
    80004d48:	36e080e7          	jalr	878(ra) # 800020b2 <wakeup>
  release(&pi->lock);
    80004d4c:	8526                	mv	a0,s1
    80004d4e:	ffffc097          	auipc	ra,0xffffc
    80004d52:	f38080e7          	jalr	-200(ra) # 80000c86 <release>
  return i;
}
    80004d56:	854e                	mv	a0,s3
    80004d58:	60a6                	ld	ra,72(sp)
    80004d5a:	6406                	ld	s0,64(sp)
    80004d5c:	74e2                	ld	s1,56(sp)
    80004d5e:	7942                	ld	s2,48(sp)
    80004d60:	79a2                	ld	s3,40(sp)
    80004d62:	7a02                	ld	s4,32(sp)
    80004d64:	6ae2                	ld	s5,24(sp)
    80004d66:	6b42                	ld	s6,16(sp)
    80004d68:	6161                	add	sp,sp,80
    80004d6a:	8082                	ret
      release(&pi->lock);
    80004d6c:	8526                	mv	a0,s1
    80004d6e:	ffffc097          	auipc	ra,0xffffc
    80004d72:	f18080e7          	jalr	-232(ra) # 80000c86 <release>
      return -1;
    80004d76:	59fd                	li	s3,-1
    80004d78:	bff9                	j	80004d56 <piperead+0xca>

0000000080004d7a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004d7a:	1141                	add	sp,sp,-16
    80004d7c:	e422                	sd	s0,8(sp)
    80004d7e:	0800                	add	s0,sp,16
    80004d80:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004d82:	8905                	and	a0,a0,1
    80004d84:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004d86:	8b89                	and	a5,a5,2
    80004d88:	c399                	beqz	a5,80004d8e <flags2perm+0x14>
      perm |= PTE_W;
    80004d8a:	00456513          	or	a0,a0,4
    return perm;
}
    80004d8e:	6422                	ld	s0,8(sp)
    80004d90:	0141                	add	sp,sp,16
    80004d92:	8082                	ret

0000000080004d94 <exec>:

int
exec(char *path, char **argv)
{
    80004d94:	df010113          	add	sp,sp,-528
    80004d98:	20113423          	sd	ra,520(sp)
    80004d9c:	20813023          	sd	s0,512(sp)
    80004da0:	ffa6                	sd	s1,504(sp)
    80004da2:	fbca                	sd	s2,496(sp)
    80004da4:	f7ce                	sd	s3,488(sp)
    80004da6:	f3d2                	sd	s4,480(sp)
    80004da8:	efd6                	sd	s5,472(sp)
    80004daa:	ebda                	sd	s6,464(sp)
    80004dac:	e7de                	sd	s7,456(sp)
    80004dae:	e3e2                	sd	s8,448(sp)
    80004db0:	ff66                	sd	s9,440(sp)
    80004db2:	fb6a                	sd	s10,432(sp)
    80004db4:	f76e                	sd	s11,424(sp)
    80004db6:	0c00                	add	s0,sp,528
    80004db8:	892a                	mv	s2,a0
    80004dba:	dea43c23          	sd	a0,-520(s0)
    80004dbe:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004dc2:	ffffd097          	auipc	ra,0xffffd
    80004dc6:	be4080e7          	jalr	-1052(ra) # 800019a6 <myproc>
    80004dca:	84aa                	mv	s1,a0

  begin_op();
    80004dcc:	fffff097          	auipc	ra,0xfffff
    80004dd0:	48e080e7          	jalr	1166(ra) # 8000425a <begin_op>

  if((ip = namei(path)) == 0){
    80004dd4:	854a                	mv	a0,s2
    80004dd6:	fffff097          	auipc	ra,0xfffff
    80004dda:	284080e7          	jalr	644(ra) # 8000405a <namei>
    80004dde:	c92d                	beqz	a0,80004e50 <exec+0xbc>
    80004de0:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004de2:	fffff097          	auipc	ra,0xfffff
    80004de6:	ad0080e7          	jalr	-1328(ra) # 800038b2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004dea:	04000713          	li	a4,64
    80004dee:	4681                	li	a3,0
    80004df0:	e5040613          	add	a2,s0,-432
    80004df4:	4581                	li	a1,0
    80004df6:	8552                	mv	a0,s4
    80004df8:	fffff097          	auipc	ra,0xfffff
    80004dfc:	d6e080e7          	jalr	-658(ra) # 80003b66 <readi>
    80004e00:	04000793          	li	a5,64
    80004e04:	00f51a63          	bne	a0,a5,80004e18 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004e08:	e5042703          	lw	a4,-432(s0)
    80004e0c:	464c47b7          	lui	a5,0x464c4
    80004e10:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004e14:	04f70463          	beq	a4,a5,80004e5c <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004e18:	8552                	mv	a0,s4
    80004e1a:	fffff097          	auipc	ra,0xfffff
    80004e1e:	cfa080e7          	jalr	-774(ra) # 80003b14 <iunlockput>
    end_op();
    80004e22:	fffff097          	auipc	ra,0xfffff
    80004e26:	4b2080e7          	jalr	1202(ra) # 800042d4 <end_op>
  }
  return -1;
    80004e2a:	557d                	li	a0,-1
}
    80004e2c:	20813083          	ld	ra,520(sp)
    80004e30:	20013403          	ld	s0,512(sp)
    80004e34:	74fe                	ld	s1,504(sp)
    80004e36:	795e                	ld	s2,496(sp)
    80004e38:	79be                	ld	s3,488(sp)
    80004e3a:	7a1e                	ld	s4,480(sp)
    80004e3c:	6afe                	ld	s5,472(sp)
    80004e3e:	6b5e                	ld	s6,464(sp)
    80004e40:	6bbe                	ld	s7,456(sp)
    80004e42:	6c1e                	ld	s8,448(sp)
    80004e44:	7cfa                	ld	s9,440(sp)
    80004e46:	7d5a                	ld	s10,432(sp)
    80004e48:	7dba                	ld	s11,424(sp)
    80004e4a:	21010113          	add	sp,sp,528
    80004e4e:	8082                	ret
    end_op();
    80004e50:	fffff097          	auipc	ra,0xfffff
    80004e54:	484080e7          	jalr	1156(ra) # 800042d4 <end_op>
    return -1;
    80004e58:	557d                	li	a0,-1
    80004e5a:	bfc9                	j	80004e2c <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004e5c:	8526                	mv	a0,s1
    80004e5e:	ffffd097          	auipc	ra,0xffffd
    80004e62:	c0c080e7          	jalr	-1012(ra) # 80001a6a <proc_pagetable>
    80004e66:	8b2a                	mv	s6,a0
    80004e68:	d945                	beqz	a0,80004e18 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e6a:	e7042d03          	lw	s10,-400(s0)
    80004e6e:	e8845783          	lhu	a5,-376(s0)
    80004e72:	10078463          	beqz	a5,80004f7a <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004e76:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e78:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004e7a:	6c85                	lui	s9,0x1
    80004e7c:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004e80:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004e84:	6a85                	lui	s5,0x1
    80004e86:	a0b5                	j	80004ef2 <exec+0x15e>
      panic("loadseg: address should exist");
    80004e88:	00004517          	auipc	a0,0x4
    80004e8c:	93050513          	add	a0,a0,-1744 # 800087b8 <syscalls+0x358>
    80004e90:	ffffb097          	auipc	ra,0xffffb
    80004e94:	6ac080e7          	jalr	1708(ra) # 8000053c <panic>
    if(sz - i < PGSIZE)
    80004e98:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004e9a:	8726                	mv	a4,s1
    80004e9c:	012c06bb          	addw	a3,s8,s2
    80004ea0:	4581                	li	a1,0
    80004ea2:	8552                	mv	a0,s4
    80004ea4:	fffff097          	auipc	ra,0xfffff
    80004ea8:	cc2080e7          	jalr	-830(ra) # 80003b66 <readi>
    80004eac:	2501                	sext.w	a0,a0
    80004eae:	24a49863          	bne	s1,a0,800050fe <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    80004eb2:	012a893b          	addw	s2,s5,s2
    80004eb6:	03397563          	bgeu	s2,s3,80004ee0 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    80004eba:	02091593          	sll	a1,s2,0x20
    80004ebe:	9181                	srl	a1,a1,0x20
    80004ec0:	95de                	add	a1,a1,s7
    80004ec2:	855a                	mv	a0,s6
    80004ec4:	ffffc097          	auipc	ra,0xffffc
    80004ec8:	192080e7          	jalr	402(ra) # 80001056 <walkaddr>
    80004ecc:	862a                	mv	a2,a0
    if(pa == 0)
    80004ece:	dd4d                	beqz	a0,80004e88 <exec+0xf4>
    if(sz - i < PGSIZE)
    80004ed0:	412984bb          	subw	s1,s3,s2
    80004ed4:	0004879b          	sext.w	a5,s1
    80004ed8:	fcfcf0e3          	bgeu	s9,a5,80004e98 <exec+0x104>
    80004edc:	84d6                	mv	s1,s5
    80004ede:	bf6d                	j	80004e98 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004ee0:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004ee4:	2d85                	addw	s11,s11,1
    80004ee6:	038d0d1b          	addw	s10,s10,56
    80004eea:	e8845783          	lhu	a5,-376(s0)
    80004eee:	08fdd763          	bge	s11,a5,80004f7c <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004ef2:	2d01                	sext.w	s10,s10
    80004ef4:	03800713          	li	a4,56
    80004ef8:	86ea                	mv	a3,s10
    80004efa:	e1840613          	add	a2,s0,-488
    80004efe:	4581                	li	a1,0
    80004f00:	8552                	mv	a0,s4
    80004f02:	fffff097          	auipc	ra,0xfffff
    80004f06:	c64080e7          	jalr	-924(ra) # 80003b66 <readi>
    80004f0a:	03800793          	li	a5,56
    80004f0e:	1ef51663          	bne	a0,a5,800050fa <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    80004f12:	e1842783          	lw	a5,-488(s0)
    80004f16:	4705                	li	a4,1
    80004f18:	fce796e3          	bne	a5,a4,80004ee4 <exec+0x150>
    if(ph.memsz < ph.filesz)
    80004f1c:	e4043483          	ld	s1,-448(s0)
    80004f20:	e3843783          	ld	a5,-456(s0)
    80004f24:	1ef4e863          	bltu	s1,a5,80005114 <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004f28:	e2843783          	ld	a5,-472(s0)
    80004f2c:	94be                	add	s1,s1,a5
    80004f2e:	1ef4e663          	bltu	s1,a5,8000511a <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    80004f32:	df043703          	ld	a4,-528(s0)
    80004f36:	8ff9                	and	a5,a5,a4
    80004f38:	1e079463          	bnez	a5,80005120 <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004f3c:	e1c42503          	lw	a0,-484(s0)
    80004f40:	00000097          	auipc	ra,0x0
    80004f44:	e3a080e7          	jalr	-454(ra) # 80004d7a <flags2perm>
    80004f48:	86aa                	mv	a3,a0
    80004f4a:	8626                	mv	a2,s1
    80004f4c:	85ca                	mv	a1,s2
    80004f4e:	855a                	mv	a0,s6
    80004f50:	ffffc097          	auipc	ra,0xffffc
    80004f54:	4ba080e7          	jalr	1210(ra) # 8000140a <uvmalloc>
    80004f58:	e0a43423          	sd	a0,-504(s0)
    80004f5c:	1c050563          	beqz	a0,80005126 <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004f60:	e2843b83          	ld	s7,-472(s0)
    80004f64:	e2042c03          	lw	s8,-480(s0)
    80004f68:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004f6c:	00098463          	beqz	s3,80004f74 <exec+0x1e0>
    80004f70:	4901                	li	s2,0
    80004f72:	b7a1                	j	80004eba <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004f74:	e0843903          	ld	s2,-504(s0)
    80004f78:	b7b5                	j	80004ee4 <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004f7a:	4901                	li	s2,0
  iunlockput(ip);
    80004f7c:	8552                	mv	a0,s4
    80004f7e:	fffff097          	auipc	ra,0xfffff
    80004f82:	b96080e7          	jalr	-1130(ra) # 80003b14 <iunlockput>
  end_op();
    80004f86:	fffff097          	auipc	ra,0xfffff
    80004f8a:	34e080e7          	jalr	846(ra) # 800042d4 <end_op>
  p = myproc();
    80004f8e:	ffffd097          	auipc	ra,0xffffd
    80004f92:	a18080e7          	jalr	-1512(ra) # 800019a6 <myproc>
    80004f96:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004f98:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004f9c:	6985                	lui	s3,0x1
    80004f9e:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004fa0:	99ca                	add	s3,s3,s2
    80004fa2:	77fd                	lui	a5,0xfffff
    80004fa4:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004fa8:	4691                	li	a3,4
    80004faa:	6609                	lui	a2,0x2
    80004fac:	964e                	add	a2,a2,s3
    80004fae:	85ce                	mv	a1,s3
    80004fb0:	855a                	mv	a0,s6
    80004fb2:	ffffc097          	auipc	ra,0xffffc
    80004fb6:	458080e7          	jalr	1112(ra) # 8000140a <uvmalloc>
    80004fba:	892a                	mv	s2,a0
    80004fbc:	e0a43423          	sd	a0,-504(s0)
    80004fc0:	e509                	bnez	a0,80004fca <exec+0x236>
  if(pagetable)
    80004fc2:	e1343423          	sd	s3,-504(s0)
    80004fc6:	4a01                	li	s4,0
    80004fc8:	aa1d                	j	800050fe <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004fca:	75f9                	lui	a1,0xffffe
    80004fcc:	95aa                	add	a1,a1,a0
    80004fce:	855a                	mv	a0,s6
    80004fd0:	ffffc097          	auipc	ra,0xffffc
    80004fd4:	664080e7          	jalr	1636(ra) # 80001634 <uvmclear>
  stackbase = sp - PGSIZE;
    80004fd8:	7bfd                	lui	s7,0xfffff
    80004fda:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004fdc:	e0043783          	ld	a5,-512(s0)
    80004fe0:	6388                	ld	a0,0(a5)
    80004fe2:	c52d                	beqz	a0,8000504c <exec+0x2b8>
    80004fe4:	e9040993          	add	s3,s0,-368
    80004fe8:	f9040c13          	add	s8,s0,-112
    80004fec:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004fee:	ffffc097          	auipc	ra,0xffffc
    80004ff2:	e5a080e7          	jalr	-422(ra) # 80000e48 <strlen>
    80004ff6:	0015079b          	addw	a5,a0,1
    80004ffa:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004ffe:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80005002:	13796563          	bltu	s2,s7,8000512c <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005006:	e0043d03          	ld	s10,-512(s0)
    8000500a:	000d3a03          	ld	s4,0(s10)
    8000500e:	8552                	mv	a0,s4
    80005010:	ffffc097          	auipc	ra,0xffffc
    80005014:	e38080e7          	jalr	-456(ra) # 80000e48 <strlen>
    80005018:	0015069b          	addw	a3,a0,1
    8000501c:	8652                	mv	a2,s4
    8000501e:	85ca                	mv	a1,s2
    80005020:	855a                	mv	a0,s6
    80005022:	ffffc097          	auipc	ra,0xffffc
    80005026:	644080e7          	jalr	1604(ra) # 80001666 <copyout>
    8000502a:	10054363          	bltz	a0,80005130 <exec+0x39c>
    ustack[argc] = sp;
    8000502e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005032:	0485                	add	s1,s1,1
    80005034:	008d0793          	add	a5,s10,8
    80005038:	e0f43023          	sd	a5,-512(s0)
    8000503c:	008d3503          	ld	a0,8(s10)
    80005040:	c909                	beqz	a0,80005052 <exec+0x2be>
    if(argc >= MAXARG)
    80005042:	09a1                	add	s3,s3,8
    80005044:	fb8995e3          	bne	s3,s8,80004fee <exec+0x25a>
  ip = 0;
    80005048:	4a01                	li	s4,0
    8000504a:	a855                	j	800050fe <exec+0x36a>
  sp = sz;
    8000504c:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80005050:	4481                	li	s1,0
  ustack[argc] = 0;
    80005052:	00349793          	sll	a5,s1,0x3
    80005056:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdd160>
    8000505a:	97a2                	add	a5,a5,s0
    8000505c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005060:	00148693          	add	a3,s1,1
    80005064:	068e                	sll	a3,a3,0x3
    80005066:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000506a:	ff097913          	and	s2,s2,-16
  sz = sz1;
    8000506e:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80005072:	f57968e3          	bltu	s2,s7,80004fc2 <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005076:	e9040613          	add	a2,s0,-368
    8000507a:	85ca                	mv	a1,s2
    8000507c:	855a                	mv	a0,s6
    8000507e:	ffffc097          	auipc	ra,0xffffc
    80005082:	5e8080e7          	jalr	1512(ra) # 80001666 <copyout>
    80005086:	0a054763          	bltz	a0,80005134 <exec+0x3a0>
  p->trapframe->a1 = sp;
    8000508a:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000508e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005092:	df843783          	ld	a5,-520(s0)
    80005096:	0007c703          	lbu	a4,0(a5)
    8000509a:	cf11                	beqz	a4,800050b6 <exec+0x322>
    8000509c:	0785                	add	a5,a5,1
    if(*s == '/')
    8000509e:	02f00693          	li	a3,47
    800050a2:	a039                	j	800050b0 <exec+0x31c>
      last = s+1;
    800050a4:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800050a8:	0785                	add	a5,a5,1
    800050aa:	fff7c703          	lbu	a4,-1(a5)
    800050ae:	c701                	beqz	a4,800050b6 <exec+0x322>
    if(*s == '/')
    800050b0:	fed71ce3          	bne	a4,a3,800050a8 <exec+0x314>
    800050b4:	bfc5                	j	800050a4 <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    800050b6:	4641                	li	a2,16
    800050b8:	df843583          	ld	a1,-520(s0)
    800050bc:	158a8513          	add	a0,s5,344
    800050c0:	ffffc097          	auipc	ra,0xffffc
    800050c4:	d56080e7          	jalr	-682(ra) # 80000e16 <safestrcpy>
  oldpagetable = p->pagetable;
    800050c8:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800050cc:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800050d0:	e0843783          	ld	a5,-504(s0)
    800050d4:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800050d8:	058ab783          	ld	a5,88(s5)
    800050dc:	e6843703          	ld	a4,-408(s0)
    800050e0:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800050e2:	058ab783          	ld	a5,88(s5)
    800050e6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800050ea:	85e6                	mv	a1,s9
    800050ec:	ffffd097          	auipc	ra,0xffffd
    800050f0:	a1a080e7          	jalr	-1510(ra) # 80001b06 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800050f4:	0004851b          	sext.w	a0,s1
    800050f8:	bb15                	j	80004e2c <exec+0x98>
    800050fa:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800050fe:	e0843583          	ld	a1,-504(s0)
    80005102:	855a                	mv	a0,s6
    80005104:	ffffd097          	auipc	ra,0xffffd
    80005108:	a02080e7          	jalr	-1534(ra) # 80001b06 <proc_freepagetable>
  return -1;
    8000510c:	557d                	li	a0,-1
  if(ip){
    8000510e:	d00a0fe3          	beqz	s4,80004e2c <exec+0x98>
    80005112:	b319                	j	80004e18 <exec+0x84>
    80005114:	e1243423          	sd	s2,-504(s0)
    80005118:	b7dd                	j	800050fe <exec+0x36a>
    8000511a:	e1243423          	sd	s2,-504(s0)
    8000511e:	b7c5                	j	800050fe <exec+0x36a>
    80005120:	e1243423          	sd	s2,-504(s0)
    80005124:	bfe9                	j	800050fe <exec+0x36a>
    80005126:	e1243423          	sd	s2,-504(s0)
    8000512a:	bfd1                	j	800050fe <exec+0x36a>
  ip = 0;
    8000512c:	4a01                	li	s4,0
    8000512e:	bfc1                	j	800050fe <exec+0x36a>
    80005130:	4a01                	li	s4,0
  if(pagetable)
    80005132:	b7f1                	j	800050fe <exec+0x36a>
  sz = sz1;
    80005134:	e0843983          	ld	s3,-504(s0)
    80005138:	b569                	j	80004fc2 <exec+0x22e>

000000008000513a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000513a:	7179                	add	sp,sp,-48
    8000513c:	f406                	sd	ra,40(sp)
    8000513e:	f022                	sd	s0,32(sp)
    80005140:	ec26                	sd	s1,24(sp)
    80005142:	e84a                	sd	s2,16(sp)
    80005144:	1800                	add	s0,sp,48
    80005146:	892e                	mv	s2,a1
    80005148:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000514a:	fdc40593          	add	a1,s0,-36
    8000514e:	ffffe097          	auipc	ra,0xffffe
    80005152:	972080e7          	jalr	-1678(ra) # 80002ac0 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005156:	fdc42703          	lw	a4,-36(s0)
    8000515a:	47bd                	li	a5,15
    8000515c:	02e7eb63          	bltu	a5,a4,80005192 <argfd+0x58>
    80005160:	ffffd097          	auipc	ra,0xffffd
    80005164:	846080e7          	jalr	-1978(ra) # 800019a6 <myproc>
    80005168:	fdc42703          	lw	a4,-36(s0)
    8000516c:	01a70793          	add	a5,a4,26
    80005170:	078e                	sll	a5,a5,0x3
    80005172:	953e                	add	a0,a0,a5
    80005174:	611c                	ld	a5,0(a0)
    80005176:	c385                	beqz	a5,80005196 <argfd+0x5c>
    return -1;
  if(pfd)
    80005178:	00090463          	beqz	s2,80005180 <argfd+0x46>
    *pfd = fd;
    8000517c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005180:	4501                	li	a0,0
  if(pf)
    80005182:	c091                	beqz	s1,80005186 <argfd+0x4c>
    *pf = f;
    80005184:	e09c                	sd	a5,0(s1)
}
    80005186:	70a2                	ld	ra,40(sp)
    80005188:	7402                	ld	s0,32(sp)
    8000518a:	64e2                	ld	s1,24(sp)
    8000518c:	6942                	ld	s2,16(sp)
    8000518e:	6145                	add	sp,sp,48
    80005190:	8082                	ret
    return -1;
    80005192:	557d                	li	a0,-1
    80005194:	bfcd                	j	80005186 <argfd+0x4c>
    80005196:	557d                	li	a0,-1
    80005198:	b7fd                	j	80005186 <argfd+0x4c>

000000008000519a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000519a:	1101                	add	sp,sp,-32
    8000519c:	ec06                	sd	ra,24(sp)
    8000519e:	e822                	sd	s0,16(sp)
    800051a0:	e426                	sd	s1,8(sp)
    800051a2:	1000                	add	s0,sp,32
    800051a4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800051a6:	ffffd097          	auipc	ra,0xffffd
    800051aa:	800080e7          	jalr	-2048(ra) # 800019a6 <myproc>
    800051ae:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800051b0:	0d050793          	add	a5,a0,208
    800051b4:	4501                	li	a0,0
    800051b6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800051b8:	6398                	ld	a4,0(a5)
    800051ba:	cb19                	beqz	a4,800051d0 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800051bc:	2505                	addw	a0,a0,1
    800051be:	07a1                	add	a5,a5,8
    800051c0:	fed51ce3          	bne	a0,a3,800051b8 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800051c4:	557d                	li	a0,-1
}
    800051c6:	60e2                	ld	ra,24(sp)
    800051c8:	6442                	ld	s0,16(sp)
    800051ca:	64a2                	ld	s1,8(sp)
    800051cc:	6105                	add	sp,sp,32
    800051ce:	8082                	ret
      p->ofile[fd] = f;
    800051d0:	01a50793          	add	a5,a0,26
    800051d4:	078e                	sll	a5,a5,0x3
    800051d6:	963e                	add	a2,a2,a5
    800051d8:	e204                	sd	s1,0(a2)
      return fd;
    800051da:	b7f5                	j	800051c6 <fdalloc+0x2c>

00000000800051dc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800051dc:	715d                	add	sp,sp,-80
    800051de:	e486                	sd	ra,72(sp)
    800051e0:	e0a2                	sd	s0,64(sp)
    800051e2:	fc26                	sd	s1,56(sp)
    800051e4:	f84a                	sd	s2,48(sp)
    800051e6:	f44e                	sd	s3,40(sp)
    800051e8:	f052                	sd	s4,32(sp)
    800051ea:	ec56                	sd	s5,24(sp)
    800051ec:	e85a                	sd	s6,16(sp)
    800051ee:	0880                	add	s0,sp,80
    800051f0:	8b2e                	mv	s6,a1
    800051f2:	89b2                	mv	s3,a2
    800051f4:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800051f6:	fb040593          	add	a1,s0,-80
    800051fa:	fffff097          	auipc	ra,0xfffff
    800051fe:	e7e080e7          	jalr	-386(ra) # 80004078 <nameiparent>
    80005202:	84aa                	mv	s1,a0
    80005204:	14050b63          	beqz	a0,8000535a <create+0x17e>
    return 0;

  ilock(dp);
    80005208:	ffffe097          	auipc	ra,0xffffe
    8000520c:	6aa080e7          	jalr	1706(ra) # 800038b2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005210:	4601                	li	a2,0
    80005212:	fb040593          	add	a1,s0,-80
    80005216:	8526                	mv	a0,s1
    80005218:	fffff097          	auipc	ra,0xfffff
    8000521c:	b80080e7          	jalr	-1152(ra) # 80003d98 <dirlookup>
    80005220:	8aaa                	mv	s5,a0
    80005222:	c921                	beqz	a0,80005272 <create+0x96>
    iunlockput(dp);
    80005224:	8526                	mv	a0,s1
    80005226:	fffff097          	auipc	ra,0xfffff
    8000522a:	8ee080e7          	jalr	-1810(ra) # 80003b14 <iunlockput>
    ilock(ip);
    8000522e:	8556                	mv	a0,s5
    80005230:	ffffe097          	auipc	ra,0xffffe
    80005234:	682080e7          	jalr	1666(ra) # 800038b2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005238:	4789                	li	a5,2
    8000523a:	02fb1563          	bne	s6,a5,80005264 <create+0x88>
    8000523e:	044ad783          	lhu	a5,68(s5)
    80005242:	37f9                	addw	a5,a5,-2
    80005244:	17c2                	sll	a5,a5,0x30
    80005246:	93c1                	srl	a5,a5,0x30
    80005248:	4705                	li	a4,1
    8000524a:	00f76d63          	bltu	a4,a5,80005264 <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000524e:	8556                	mv	a0,s5
    80005250:	60a6                	ld	ra,72(sp)
    80005252:	6406                	ld	s0,64(sp)
    80005254:	74e2                	ld	s1,56(sp)
    80005256:	7942                	ld	s2,48(sp)
    80005258:	79a2                	ld	s3,40(sp)
    8000525a:	7a02                	ld	s4,32(sp)
    8000525c:	6ae2                	ld	s5,24(sp)
    8000525e:	6b42                	ld	s6,16(sp)
    80005260:	6161                	add	sp,sp,80
    80005262:	8082                	ret
    iunlockput(ip);
    80005264:	8556                	mv	a0,s5
    80005266:	fffff097          	auipc	ra,0xfffff
    8000526a:	8ae080e7          	jalr	-1874(ra) # 80003b14 <iunlockput>
    return 0;
    8000526e:	4a81                	li	s5,0
    80005270:	bff9                	j	8000524e <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005272:	85da                	mv	a1,s6
    80005274:	4088                	lw	a0,0(s1)
    80005276:	ffffe097          	auipc	ra,0xffffe
    8000527a:	4a4080e7          	jalr	1188(ra) # 8000371a <ialloc>
    8000527e:	8a2a                	mv	s4,a0
    80005280:	c529                	beqz	a0,800052ca <create+0xee>
  ilock(ip);
    80005282:	ffffe097          	auipc	ra,0xffffe
    80005286:	630080e7          	jalr	1584(ra) # 800038b2 <ilock>
  ip->major = major;
    8000528a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000528e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005292:	4905                	li	s2,1
    80005294:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005298:	8552                	mv	a0,s4
    8000529a:	ffffe097          	auipc	ra,0xffffe
    8000529e:	54c080e7          	jalr	1356(ra) # 800037e6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800052a2:	032b0b63          	beq	s6,s2,800052d8 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800052a6:	004a2603          	lw	a2,4(s4)
    800052aa:	fb040593          	add	a1,s0,-80
    800052ae:	8526                	mv	a0,s1
    800052b0:	fffff097          	auipc	ra,0xfffff
    800052b4:	cf8080e7          	jalr	-776(ra) # 80003fa8 <dirlink>
    800052b8:	06054f63          	bltz	a0,80005336 <create+0x15a>
  iunlockput(dp);
    800052bc:	8526                	mv	a0,s1
    800052be:	fffff097          	auipc	ra,0xfffff
    800052c2:	856080e7          	jalr	-1962(ra) # 80003b14 <iunlockput>
  return ip;
    800052c6:	8ad2                	mv	s5,s4
    800052c8:	b759                	j	8000524e <create+0x72>
    iunlockput(dp);
    800052ca:	8526                	mv	a0,s1
    800052cc:	fffff097          	auipc	ra,0xfffff
    800052d0:	848080e7          	jalr	-1976(ra) # 80003b14 <iunlockput>
    return 0;
    800052d4:	8ad2                	mv	s5,s4
    800052d6:	bfa5                	j	8000524e <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800052d8:	004a2603          	lw	a2,4(s4)
    800052dc:	00003597          	auipc	a1,0x3
    800052e0:	4fc58593          	add	a1,a1,1276 # 800087d8 <syscalls+0x378>
    800052e4:	8552                	mv	a0,s4
    800052e6:	fffff097          	auipc	ra,0xfffff
    800052ea:	cc2080e7          	jalr	-830(ra) # 80003fa8 <dirlink>
    800052ee:	04054463          	bltz	a0,80005336 <create+0x15a>
    800052f2:	40d0                	lw	a2,4(s1)
    800052f4:	00003597          	auipc	a1,0x3
    800052f8:	4ec58593          	add	a1,a1,1260 # 800087e0 <syscalls+0x380>
    800052fc:	8552                	mv	a0,s4
    800052fe:	fffff097          	auipc	ra,0xfffff
    80005302:	caa080e7          	jalr	-854(ra) # 80003fa8 <dirlink>
    80005306:	02054863          	bltz	a0,80005336 <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    8000530a:	004a2603          	lw	a2,4(s4)
    8000530e:	fb040593          	add	a1,s0,-80
    80005312:	8526                	mv	a0,s1
    80005314:	fffff097          	auipc	ra,0xfffff
    80005318:	c94080e7          	jalr	-876(ra) # 80003fa8 <dirlink>
    8000531c:	00054d63          	bltz	a0,80005336 <create+0x15a>
    dp->nlink++;  // for ".."
    80005320:	04a4d783          	lhu	a5,74(s1)
    80005324:	2785                	addw	a5,a5,1
    80005326:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000532a:	8526                	mv	a0,s1
    8000532c:	ffffe097          	auipc	ra,0xffffe
    80005330:	4ba080e7          	jalr	1210(ra) # 800037e6 <iupdate>
    80005334:	b761                	j	800052bc <create+0xe0>
  ip->nlink = 0;
    80005336:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000533a:	8552                	mv	a0,s4
    8000533c:	ffffe097          	auipc	ra,0xffffe
    80005340:	4aa080e7          	jalr	1194(ra) # 800037e6 <iupdate>
  iunlockput(ip);
    80005344:	8552                	mv	a0,s4
    80005346:	ffffe097          	auipc	ra,0xffffe
    8000534a:	7ce080e7          	jalr	1998(ra) # 80003b14 <iunlockput>
  iunlockput(dp);
    8000534e:	8526                	mv	a0,s1
    80005350:	ffffe097          	auipc	ra,0xffffe
    80005354:	7c4080e7          	jalr	1988(ra) # 80003b14 <iunlockput>
  return 0;
    80005358:	bddd                	j	8000524e <create+0x72>
    return 0;
    8000535a:	8aaa                	mv	s5,a0
    8000535c:	bdcd                	j	8000524e <create+0x72>

000000008000535e <sys_dup>:
{
    8000535e:	7179                	add	sp,sp,-48
    80005360:	f406                	sd	ra,40(sp)
    80005362:	f022                	sd	s0,32(sp)
    80005364:	ec26                	sd	s1,24(sp)
    80005366:	e84a                	sd	s2,16(sp)
    80005368:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000536a:	fd840613          	add	a2,s0,-40
    8000536e:	4581                	li	a1,0
    80005370:	4501                	li	a0,0
    80005372:	00000097          	auipc	ra,0x0
    80005376:	dc8080e7          	jalr	-568(ra) # 8000513a <argfd>
    return -1;
    8000537a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000537c:	02054363          	bltz	a0,800053a2 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80005380:	fd843903          	ld	s2,-40(s0)
    80005384:	854a                	mv	a0,s2
    80005386:	00000097          	auipc	ra,0x0
    8000538a:	e14080e7          	jalr	-492(ra) # 8000519a <fdalloc>
    8000538e:	84aa                	mv	s1,a0
    return -1;
    80005390:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005392:	00054863          	bltz	a0,800053a2 <sys_dup+0x44>
  filedup(f);
    80005396:	854a                	mv	a0,s2
    80005398:	fffff097          	auipc	ra,0xfffff
    8000539c:	334080e7          	jalr	820(ra) # 800046cc <filedup>
  return fd;
    800053a0:	87a6                	mv	a5,s1
}
    800053a2:	853e                	mv	a0,a5
    800053a4:	70a2                	ld	ra,40(sp)
    800053a6:	7402                	ld	s0,32(sp)
    800053a8:	64e2                	ld	s1,24(sp)
    800053aa:	6942                	ld	s2,16(sp)
    800053ac:	6145                	add	sp,sp,48
    800053ae:	8082                	ret

00000000800053b0 <sys_read>:
{
    800053b0:	7179                	add	sp,sp,-48
    800053b2:	f406                	sd	ra,40(sp)
    800053b4:	f022                	sd	s0,32(sp)
    800053b6:	1800                	add	s0,sp,48
  argaddr(1, &p);
    800053b8:	fd840593          	add	a1,s0,-40
    800053bc:	4505                	li	a0,1
    800053be:	ffffd097          	auipc	ra,0xffffd
    800053c2:	722080e7          	jalr	1826(ra) # 80002ae0 <argaddr>
  argint(2, &n);
    800053c6:	fe440593          	add	a1,s0,-28
    800053ca:	4509                	li	a0,2
    800053cc:	ffffd097          	auipc	ra,0xffffd
    800053d0:	6f4080e7          	jalr	1780(ra) # 80002ac0 <argint>
  if(argfd(0, 0, &f) < 0)
    800053d4:	fe840613          	add	a2,s0,-24
    800053d8:	4581                	li	a1,0
    800053da:	4501                	li	a0,0
    800053dc:	00000097          	auipc	ra,0x0
    800053e0:	d5e080e7          	jalr	-674(ra) # 8000513a <argfd>
    800053e4:	87aa                	mv	a5,a0
    return -1;
    800053e6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800053e8:	0007cc63          	bltz	a5,80005400 <sys_read+0x50>
  return fileread(f, p, n);
    800053ec:	fe442603          	lw	a2,-28(s0)
    800053f0:	fd843583          	ld	a1,-40(s0)
    800053f4:	fe843503          	ld	a0,-24(s0)
    800053f8:	fffff097          	auipc	ra,0xfffff
    800053fc:	460080e7          	jalr	1120(ra) # 80004858 <fileread>
}
    80005400:	70a2                	ld	ra,40(sp)
    80005402:	7402                	ld	s0,32(sp)
    80005404:	6145                	add	sp,sp,48
    80005406:	8082                	ret

0000000080005408 <sys_write>:
{
    80005408:	7179                	add	sp,sp,-48
    8000540a:	f406                	sd	ra,40(sp)
    8000540c:	f022                	sd	s0,32(sp)
    8000540e:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80005410:	fd840593          	add	a1,s0,-40
    80005414:	4505                	li	a0,1
    80005416:	ffffd097          	auipc	ra,0xffffd
    8000541a:	6ca080e7          	jalr	1738(ra) # 80002ae0 <argaddr>
  argint(2, &n);
    8000541e:	fe440593          	add	a1,s0,-28
    80005422:	4509                	li	a0,2
    80005424:	ffffd097          	auipc	ra,0xffffd
    80005428:	69c080e7          	jalr	1692(ra) # 80002ac0 <argint>
  if(argfd(0, 0, &f) < 0)
    8000542c:	fe840613          	add	a2,s0,-24
    80005430:	4581                	li	a1,0
    80005432:	4501                	li	a0,0
    80005434:	00000097          	auipc	ra,0x0
    80005438:	d06080e7          	jalr	-762(ra) # 8000513a <argfd>
    8000543c:	87aa                	mv	a5,a0
    return -1;
    8000543e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005440:	0007cc63          	bltz	a5,80005458 <sys_write+0x50>
  return filewrite(f, p, n);
    80005444:	fe442603          	lw	a2,-28(s0)
    80005448:	fd843583          	ld	a1,-40(s0)
    8000544c:	fe843503          	ld	a0,-24(s0)
    80005450:	fffff097          	auipc	ra,0xfffff
    80005454:	4ca080e7          	jalr	1226(ra) # 8000491a <filewrite>
}
    80005458:	70a2                	ld	ra,40(sp)
    8000545a:	7402                	ld	s0,32(sp)
    8000545c:	6145                	add	sp,sp,48
    8000545e:	8082                	ret

0000000080005460 <sys_close>:
{
    80005460:	1101                	add	sp,sp,-32
    80005462:	ec06                	sd	ra,24(sp)
    80005464:	e822                	sd	s0,16(sp)
    80005466:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005468:	fe040613          	add	a2,s0,-32
    8000546c:	fec40593          	add	a1,s0,-20
    80005470:	4501                	li	a0,0
    80005472:	00000097          	auipc	ra,0x0
    80005476:	cc8080e7          	jalr	-824(ra) # 8000513a <argfd>
    return -1;
    8000547a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000547c:	02054463          	bltz	a0,800054a4 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005480:	ffffc097          	auipc	ra,0xffffc
    80005484:	526080e7          	jalr	1318(ra) # 800019a6 <myproc>
    80005488:	fec42783          	lw	a5,-20(s0)
    8000548c:	07e9                	add	a5,a5,26
    8000548e:	078e                	sll	a5,a5,0x3
    80005490:	953e                	add	a0,a0,a5
    80005492:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005496:	fe043503          	ld	a0,-32(s0)
    8000549a:	fffff097          	auipc	ra,0xfffff
    8000549e:	284080e7          	jalr	644(ra) # 8000471e <fileclose>
  return 0;
    800054a2:	4781                	li	a5,0
}
    800054a4:	853e                	mv	a0,a5
    800054a6:	60e2                	ld	ra,24(sp)
    800054a8:	6442                	ld	s0,16(sp)
    800054aa:	6105                	add	sp,sp,32
    800054ac:	8082                	ret

00000000800054ae <sys_fstat>:
{
    800054ae:	1101                	add	sp,sp,-32
    800054b0:	ec06                	sd	ra,24(sp)
    800054b2:	e822                	sd	s0,16(sp)
    800054b4:	1000                	add	s0,sp,32
  argaddr(1, &st);
    800054b6:	fe040593          	add	a1,s0,-32
    800054ba:	4505                	li	a0,1
    800054bc:	ffffd097          	auipc	ra,0xffffd
    800054c0:	624080e7          	jalr	1572(ra) # 80002ae0 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800054c4:	fe840613          	add	a2,s0,-24
    800054c8:	4581                	li	a1,0
    800054ca:	4501                	li	a0,0
    800054cc:	00000097          	auipc	ra,0x0
    800054d0:	c6e080e7          	jalr	-914(ra) # 8000513a <argfd>
    800054d4:	87aa                	mv	a5,a0
    return -1;
    800054d6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800054d8:	0007ca63          	bltz	a5,800054ec <sys_fstat+0x3e>
  return filestat(f, st);
    800054dc:	fe043583          	ld	a1,-32(s0)
    800054e0:	fe843503          	ld	a0,-24(s0)
    800054e4:	fffff097          	auipc	ra,0xfffff
    800054e8:	302080e7          	jalr	770(ra) # 800047e6 <filestat>
}
    800054ec:	60e2                	ld	ra,24(sp)
    800054ee:	6442                	ld	s0,16(sp)
    800054f0:	6105                	add	sp,sp,32
    800054f2:	8082                	ret

00000000800054f4 <sys_link>:
{
    800054f4:	7169                	add	sp,sp,-304
    800054f6:	f606                	sd	ra,296(sp)
    800054f8:	f222                	sd	s0,288(sp)
    800054fa:	ee26                	sd	s1,280(sp)
    800054fc:	ea4a                	sd	s2,272(sp)
    800054fe:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005500:	08000613          	li	a2,128
    80005504:	ed040593          	add	a1,s0,-304
    80005508:	4501                	li	a0,0
    8000550a:	ffffd097          	auipc	ra,0xffffd
    8000550e:	5f6080e7          	jalr	1526(ra) # 80002b00 <argstr>
    return -1;
    80005512:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005514:	10054e63          	bltz	a0,80005630 <sys_link+0x13c>
    80005518:	08000613          	li	a2,128
    8000551c:	f5040593          	add	a1,s0,-176
    80005520:	4505                	li	a0,1
    80005522:	ffffd097          	auipc	ra,0xffffd
    80005526:	5de080e7          	jalr	1502(ra) # 80002b00 <argstr>
    return -1;
    8000552a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000552c:	10054263          	bltz	a0,80005630 <sys_link+0x13c>
  begin_op();
    80005530:	fffff097          	auipc	ra,0xfffff
    80005534:	d2a080e7          	jalr	-726(ra) # 8000425a <begin_op>
  if((ip = namei(old)) == 0){
    80005538:	ed040513          	add	a0,s0,-304
    8000553c:	fffff097          	auipc	ra,0xfffff
    80005540:	b1e080e7          	jalr	-1250(ra) # 8000405a <namei>
    80005544:	84aa                	mv	s1,a0
    80005546:	c551                	beqz	a0,800055d2 <sys_link+0xde>
  ilock(ip);
    80005548:	ffffe097          	auipc	ra,0xffffe
    8000554c:	36a080e7          	jalr	874(ra) # 800038b2 <ilock>
  if(ip->type == T_DIR){
    80005550:	04449703          	lh	a4,68(s1)
    80005554:	4785                	li	a5,1
    80005556:	08f70463          	beq	a4,a5,800055de <sys_link+0xea>
  ip->nlink++;
    8000555a:	04a4d783          	lhu	a5,74(s1)
    8000555e:	2785                	addw	a5,a5,1
    80005560:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005564:	8526                	mv	a0,s1
    80005566:	ffffe097          	auipc	ra,0xffffe
    8000556a:	280080e7          	jalr	640(ra) # 800037e6 <iupdate>
  iunlock(ip);
    8000556e:	8526                	mv	a0,s1
    80005570:	ffffe097          	auipc	ra,0xffffe
    80005574:	404080e7          	jalr	1028(ra) # 80003974 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005578:	fd040593          	add	a1,s0,-48
    8000557c:	f5040513          	add	a0,s0,-176
    80005580:	fffff097          	auipc	ra,0xfffff
    80005584:	af8080e7          	jalr	-1288(ra) # 80004078 <nameiparent>
    80005588:	892a                	mv	s2,a0
    8000558a:	c935                	beqz	a0,800055fe <sys_link+0x10a>
  ilock(dp);
    8000558c:	ffffe097          	auipc	ra,0xffffe
    80005590:	326080e7          	jalr	806(ra) # 800038b2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005594:	00092703          	lw	a4,0(s2)
    80005598:	409c                	lw	a5,0(s1)
    8000559a:	04f71d63          	bne	a4,a5,800055f4 <sys_link+0x100>
    8000559e:	40d0                	lw	a2,4(s1)
    800055a0:	fd040593          	add	a1,s0,-48
    800055a4:	854a                	mv	a0,s2
    800055a6:	fffff097          	auipc	ra,0xfffff
    800055aa:	a02080e7          	jalr	-1534(ra) # 80003fa8 <dirlink>
    800055ae:	04054363          	bltz	a0,800055f4 <sys_link+0x100>
  iunlockput(dp);
    800055b2:	854a                	mv	a0,s2
    800055b4:	ffffe097          	auipc	ra,0xffffe
    800055b8:	560080e7          	jalr	1376(ra) # 80003b14 <iunlockput>
  iput(ip);
    800055bc:	8526                	mv	a0,s1
    800055be:	ffffe097          	auipc	ra,0xffffe
    800055c2:	4ae080e7          	jalr	1198(ra) # 80003a6c <iput>
  end_op();
    800055c6:	fffff097          	auipc	ra,0xfffff
    800055ca:	d0e080e7          	jalr	-754(ra) # 800042d4 <end_op>
  return 0;
    800055ce:	4781                	li	a5,0
    800055d0:	a085                	j	80005630 <sys_link+0x13c>
    end_op();
    800055d2:	fffff097          	auipc	ra,0xfffff
    800055d6:	d02080e7          	jalr	-766(ra) # 800042d4 <end_op>
    return -1;
    800055da:	57fd                	li	a5,-1
    800055dc:	a891                	j	80005630 <sys_link+0x13c>
    iunlockput(ip);
    800055de:	8526                	mv	a0,s1
    800055e0:	ffffe097          	auipc	ra,0xffffe
    800055e4:	534080e7          	jalr	1332(ra) # 80003b14 <iunlockput>
    end_op();
    800055e8:	fffff097          	auipc	ra,0xfffff
    800055ec:	cec080e7          	jalr	-788(ra) # 800042d4 <end_op>
    return -1;
    800055f0:	57fd                	li	a5,-1
    800055f2:	a83d                	j	80005630 <sys_link+0x13c>
    iunlockput(dp);
    800055f4:	854a                	mv	a0,s2
    800055f6:	ffffe097          	auipc	ra,0xffffe
    800055fa:	51e080e7          	jalr	1310(ra) # 80003b14 <iunlockput>
  ilock(ip);
    800055fe:	8526                	mv	a0,s1
    80005600:	ffffe097          	auipc	ra,0xffffe
    80005604:	2b2080e7          	jalr	690(ra) # 800038b2 <ilock>
  ip->nlink--;
    80005608:	04a4d783          	lhu	a5,74(s1)
    8000560c:	37fd                	addw	a5,a5,-1
    8000560e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005612:	8526                	mv	a0,s1
    80005614:	ffffe097          	auipc	ra,0xffffe
    80005618:	1d2080e7          	jalr	466(ra) # 800037e6 <iupdate>
  iunlockput(ip);
    8000561c:	8526                	mv	a0,s1
    8000561e:	ffffe097          	auipc	ra,0xffffe
    80005622:	4f6080e7          	jalr	1270(ra) # 80003b14 <iunlockput>
  end_op();
    80005626:	fffff097          	auipc	ra,0xfffff
    8000562a:	cae080e7          	jalr	-850(ra) # 800042d4 <end_op>
  return -1;
    8000562e:	57fd                	li	a5,-1
}
    80005630:	853e                	mv	a0,a5
    80005632:	70b2                	ld	ra,296(sp)
    80005634:	7412                	ld	s0,288(sp)
    80005636:	64f2                	ld	s1,280(sp)
    80005638:	6952                	ld	s2,272(sp)
    8000563a:	6155                	add	sp,sp,304
    8000563c:	8082                	ret

000000008000563e <sys_unlink>:
{
    8000563e:	7151                	add	sp,sp,-240
    80005640:	f586                	sd	ra,232(sp)
    80005642:	f1a2                	sd	s0,224(sp)
    80005644:	eda6                	sd	s1,216(sp)
    80005646:	e9ca                	sd	s2,208(sp)
    80005648:	e5ce                	sd	s3,200(sp)
    8000564a:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000564c:	08000613          	li	a2,128
    80005650:	f3040593          	add	a1,s0,-208
    80005654:	4501                	li	a0,0
    80005656:	ffffd097          	auipc	ra,0xffffd
    8000565a:	4aa080e7          	jalr	1194(ra) # 80002b00 <argstr>
    8000565e:	18054163          	bltz	a0,800057e0 <sys_unlink+0x1a2>
  begin_op();
    80005662:	fffff097          	auipc	ra,0xfffff
    80005666:	bf8080e7          	jalr	-1032(ra) # 8000425a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000566a:	fb040593          	add	a1,s0,-80
    8000566e:	f3040513          	add	a0,s0,-208
    80005672:	fffff097          	auipc	ra,0xfffff
    80005676:	a06080e7          	jalr	-1530(ra) # 80004078 <nameiparent>
    8000567a:	84aa                	mv	s1,a0
    8000567c:	c979                	beqz	a0,80005752 <sys_unlink+0x114>
  ilock(dp);
    8000567e:	ffffe097          	auipc	ra,0xffffe
    80005682:	234080e7          	jalr	564(ra) # 800038b2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005686:	00003597          	auipc	a1,0x3
    8000568a:	15258593          	add	a1,a1,338 # 800087d8 <syscalls+0x378>
    8000568e:	fb040513          	add	a0,s0,-80
    80005692:	ffffe097          	auipc	ra,0xffffe
    80005696:	6ec080e7          	jalr	1772(ra) # 80003d7e <namecmp>
    8000569a:	14050a63          	beqz	a0,800057ee <sys_unlink+0x1b0>
    8000569e:	00003597          	auipc	a1,0x3
    800056a2:	14258593          	add	a1,a1,322 # 800087e0 <syscalls+0x380>
    800056a6:	fb040513          	add	a0,s0,-80
    800056aa:	ffffe097          	auipc	ra,0xffffe
    800056ae:	6d4080e7          	jalr	1748(ra) # 80003d7e <namecmp>
    800056b2:	12050e63          	beqz	a0,800057ee <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800056b6:	f2c40613          	add	a2,s0,-212
    800056ba:	fb040593          	add	a1,s0,-80
    800056be:	8526                	mv	a0,s1
    800056c0:	ffffe097          	auipc	ra,0xffffe
    800056c4:	6d8080e7          	jalr	1752(ra) # 80003d98 <dirlookup>
    800056c8:	892a                	mv	s2,a0
    800056ca:	12050263          	beqz	a0,800057ee <sys_unlink+0x1b0>
  ilock(ip);
    800056ce:	ffffe097          	auipc	ra,0xffffe
    800056d2:	1e4080e7          	jalr	484(ra) # 800038b2 <ilock>
  if(ip->nlink < 1)
    800056d6:	04a91783          	lh	a5,74(s2)
    800056da:	08f05263          	blez	a5,8000575e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800056de:	04491703          	lh	a4,68(s2)
    800056e2:	4785                	li	a5,1
    800056e4:	08f70563          	beq	a4,a5,8000576e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800056e8:	4641                	li	a2,16
    800056ea:	4581                	li	a1,0
    800056ec:	fc040513          	add	a0,s0,-64
    800056f0:	ffffb097          	auipc	ra,0xffffb
    800056f4:	5de080e7          	jalr	1502(ra) # 80000cce <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800056f8:	4741                	li	a4,16
    800056fa:	f2c42683          	lw	a3,-212(s0)
    800056fe:	fc040613          	add	a2,s0,-64
    80005702:	4581                	li	a1,0
    80005704:	8526                	mv	a0,s1
    80005706:	ffffe097          	auipc	ra,0xffffe
    8000570a:	558080e7          	jalr	1368(ra) # 80003c5e <writei>
    8000570e:	47c1                	li	a5,16
    80005710:	0af51563          	bne	a0,a5,800057ba <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005714:	04491703          	lh	a4,68(s2)
    80005718:	4785                	li	a5,1
    8000571a:	0af70863          	beq	a4,a5,800057ca <sys_unlink+0x18c>
  iunlockput(dp);
    8000571e:	8526                	mv	a0,s1
    80005720:	ffffe097          	auipc	ra,0xffffe
    80005724:	3f4080e7          	jalr	1012(ra) # 80003b14 <iunlockput>
  ip->nlink--;
    80005728:	04a95783          	lhu	a5,74(s2)
    8000572c:	37fd                	addw	a5,a5,-1
    8000572e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005732:	854a                	mv	a0,s2
    80005734:	ffffe097          	auipc	ra,0xffffe
    80005738:	0b2080e7          	jalr	178(ra) # 800037e6 <iupdate>
  iunlockput(ip);
    8000573c:	854a                	mv	a0,s2
    8000573e:	ffffe097          	auipc	ra,0xffffe
    80005742:	3d6080e7          	jalr	982(ra) # 80003b14 <iunlockput>
  end_op();
    80005746:	fffff097          	auipc	ra,0xfffff
    8000574a:	b8e080e7          	jalr	-1138(ra) # 800042d4 <end_op>
  return 0;
    8000574e:	4501                	li	a0,0
    80005750:	a84d                	j	80005802 <sys_unlink+0x1c4>
    end_op();
    80005752:	fffff097          	auipc	ra,0xfffff
    80005756:	b82080e7          	jalr	-1150(ra) # 800042d4 <end_op>
    return -1;
    8000575a:	557d                	li	a0,-1
    8000575c:	a05d                	j	80005802 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    8000575e:	00003517          	auipc	a0,0x3
    80005762:	08a50513          	add	a0,a0,138 # 800087e8 <syscalls+0x388>
    80005766:	ffffb097          	auipc	ra,0xffffb
    8000576a:	dd6080e7          	jalr	-554(ra) # 8000053c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000576e:	04c92703          	lw	a4,76(s2)
    80005772:	02000793          	li	a5,32
    80005776:	f6e7f9e3          	bgeu	a5,a4,800056e8 <sys_unlink+0xaa>
    8000577a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000577e:	4741                	li	a4,16
    80005780:	86ce                	mv	a3,s3
    80005782:	f1840613          	add	a2,s0,-232
    80005786:	4581                	li	a1,0
    80005788:	854a                	mv	a0,s2
    8000578a:	ffffe097          	auipc	ra,0xffffe
    8000578e:	3dc080e7          	jalr	988(ra) # 80003b66 <readi>
    80005792:	47c1                	li	a5,16
    80005794:	00f51b63          	bne	a0,a5,800057aa <sys_unlink+0x16c>
    if(de.inum != 0)
    80005798:	f1845783          	lhu	a5,-232(s0)
    8000579c:	e7a1                	bnez	a5,800057e4 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000579e:	29c1                	addw	s3,s3,16
    800057a0:	04c92783          	lw	a5,76(s2)
    800057a4:	fcf9ede3          	bltu	s3,a5,8000577e <sys_unlink+0x140>
    800057a8:	b781                	j	800056e8 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800057aa:	00003517          	auipc	a0,0x3
    800057ae:	05650513          	add	a0,a0,86 # 80008800 <syscalls+0x3a0>
    800057b2:	ffffb097          	auipc	ra,0xffffb
    800057b6:	d8a080e7          	jalr	-630(ra) # 8000053c <panic>
    panic("unlink: writei");
    800057ba:	00003517          	auipc	a0,0x3
    800057be:	05e50513          	add	a0,a0,94 # 80008818 <syscalls+0x3b8>
    800057c2:	ffffb097          	auipc	ra,0xffffb
    800057c6:	d7a080e7          	jalr	-646(ra) # 8000053c <panic>
    dp->nlink--;
    800057ca:	04a4d783          	lhu	a5,74(s1)
    800057ce:	37fd                	addw	a5,a5,-1
    800057d0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800057d4:	8526                	mv	a0,s1
    800057d6:	ffffe097          	auipc	ra,0xffffe
    800057da:	010080e7          	jalr	16(ra) # 800037e6 <iupdate>
    800057de:	b781                	j	8000571e <sys_unlink+0xe0>
    return -1;
    800057e0:	557d                	li	a0,-1
    800057e2:	a005                	j	80005802 <sys_unlink+0x1c4>
    iunlockput(ip);
    800057e4:	854a                	mv	a0,s2
    800057e6:	ffffe097          	auipc	ra,0xffffe
    800057ea:	32e080e7          	jalr	814(ra) # 80003b14 <iunlockput>
  iunlockput(dp);
    800057ee:	8526                	mv	a0,s1
    800057f0:	ffffe097          	auipc	ra,0xffffe
    800057f4:	324080e7          	jalr	804(ra) # 80003b14 <iunlockput>
  end_op();
    800057f8:	fffff097          	auipc	ra,0xfffff
    800057fc:	adc080e7          	jalr	-1316(ra) # 800042d4 <end_op>
  return -1;
    80005800:	557d                	li	a0,-1
}
    80005802:	70ae                	ld	ra,232(sp)
    80005804:	740e                	ld	s0,224(sp)
    80005806:	64ee                	ld	s1,216(sp)
    80005808:	694e                	ld	s2,208(sp)
    8000580a:	69ae                	ld	s3,200(sp)
    8000580c:	616d                	add	sp,sp,240
    8000580e:	8082                	ret

0000000080005810 <sys_open>:

uint64
sys_open(void)
{
    80005810:	7131                	add	sp,sp,-192
    80005812:	fd06                	sd	ra,184(sp)
    80005814:	f922                	sd	s0,176(sp)
    80005816:	f526                	sd	s1,168(sp)
    80005818:	f14a                	sd	s2,160(sp)
    8000581a:	ed4e                	sd	s3,152(sp)
    8000581c:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000581e:	f4c40593          	add	a1,s0,-180
    80005822:	4505                	li	a0,1
    80005824:	ffffd097          	auipc	ra,0xffffd
    80005828:	29c080e7          	jalr	668(ra) # 80002ac0 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000582c:	08000613          	li	a2,128
    80005830:	f5040593          	add	a1,s0,-176
    80005834:	4501                	li	a0,0
    80005836:	ffffd097          	auipc	ra,0xffffd
    8000583a:	2ca080e7          	jalr	714(ra) # 80002b00 <argstr>
    8000583e:	87aa                	mv	a5,a0
    return -1;
    80005840:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005842:	0a07c863          	bltz	a5,800058f2 <sys_open+0xe2>

  begin_op();
    80005846:	fffff097          	auipc	ra,0xfffff
    8000584a:	a14080e7          	jalr	-1516(ra) # 8000425a <begin_op>

  if(omode & O_CREATE){
    8000584e:	f4c42783          	lw	a5,-180(s0)
    80005852:	2007f793          	and	a5,a5,512
    80005856:	cbdd                	beqz	a5,8000590c <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80005858:	4681                	li	a3,0
    8000585a:	4601                	li	a2,0
    8000585c:	4589                	li	a1,2
    8000585e:	f5040513          	add	a0,s0,-176
    80005862:	00000097          	auipc	ra,0x0
    80005866:	97a080e7          	jalr	-1670(ra) # 800051dc <create>
    8000586a:	84aa                	mv	s1,a0
    if(ip == 0){
    8000586c:	c951                	beqz	a0,80005900 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000586e:	04449703          	lh	a4,68(s1)
    80005872:	478d                	li	a5,3
    80005874:	00f71763          	bne	a4,a5,80005882 <sys_open+0x72>
    80005878:	0464d703          	lhu	a4,70(s1)
    8000587c:	47a5                	li	a5,9
    8000587e:	0ce7ec63          	bltu	a5,a4,80005956 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005882:	fffff097          	auipc	ra,0xfffff
    80005886:	de0080e7          	jalr	-544(ra) # 80004662 <filealloc>
    8000588a:	892a                	mv	s2,a0
    8000588c:	c56d                	beqz	a0,80005976 <sys_open+0x166>
    8000588e:	00000097          	auipc	ra,0x0
    80005892:	90c080e7          	jalr	-1780(ra) # 8000519a <fdalloc>
    80005896:	89aa                	mv	s3,a0
    80005898:	0c054a63          	bltz	a0,8000596c <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000589c:	04449703          	lh	a4,68(s1)
    800058a0:	478d                	li	a5,3
    800058a2:	0ef70563          	beq	a4,a5,8000598c <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800058a6:	4789                	li	a5,2
    800058a8:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800058ac:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800058b0:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800058b4:	f4c42783          	lw	a5,-180(s0)
    800058b8:	0017c713          	xor	a4,a5,1
    800058bc:	8b05                	and	a4,a4,1
    800058be:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800058c2:	0037f713          	and	a4,a5,3
    800058c6:	00e03733          	snez	a4,a4
    800058ca:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800058ce:	4007f793          	and	a5,a5,1024
    800058d2:	c791                	beqz	a5,800058de <sys_open+0xce>
    800058d4:	04449703          	lh	a4,68(s1)
    800058d8:	4789                	li	a5,2
    800058da:	0cf70063          	beq	a4,a5,8000599a <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    800058de:	8526                	mv	a0,s1
    800058e0:	ffffe097          	auipc	ra,0xffffe
    800058e4:	094080e7          	jalr	148(ra) # 80003974 <iunlock>
  end_op();
    800058e8:	fffff097          	auipc	ra,0xfffff
    800058ec:	9ec080e7          	jalr	-1556(ra) # 800042d4 <end_op>

  return fd;
    800058f0:	854e                	mv	a0,s3
}
    800058f2:	70ea                	ld	ra,184(sp)
    800058f4:	744a                	ld	s0,176(sp)
    800058f6:	74aa                	ld	s1,168(sp)
    800058f8:	790a                	ld	s2,160(sp)
    800058fa:	69ea                	ld	s3,152(sp)
    800058fc:	6129                	add	sp,sp,192
    800058fe:	8082                	ret
      end_op();
    80005900:	fffff097          	auipc	ra,0xfffff
    80005904:	9d4080e7          	jalr	-1580(ra) # 800042d4 <end_op>
      return -1;
    80005908:	557d                	li	a0,-1
    8000590a:	b7e5                	j	800058f2 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    8000590c:	f5040513          	add	a0,s0,-176
    80005910:	ffffe097          	auipc	ra,0xffffe
    80005914:	74a080e7          	jalr	1866(ra) # 8000405a <namei>
    80005918:	84aa                	mv	s1,a0
    8000591a:	c905                	beqz	a0,8000594a <sys_open+0x13a>
    ilock(ip);
    8000591c:	ffffe097          	auipc	ra,0xffffe
    80005920:	f96080e7          	jalr	-106(ra) # 800038b2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005924:	04449703          	lh	a4,68(s1)
    80005928:	4785                	li	a5,1
    8000592a:	f4f712e3          	bne	a4,a5,8000586e <sys_open+0x5e>
    8000592e:	f4c42783          	lw	a5,-180(s0)
    80005932:	dba1                	beqz	a5,80005882 <sys_open+0x72>
      iunlockput(ip);
    80005934:	8526                	mv	a0,s1
    80005936:	ffffe097          	auipc	ra,0xffffe
    8000593a:	1de080e7          	jalr	478(ra) # 80003b14 <iunlockput>
      end_op();
    8000593e:	fffff097          	auipc	ra,0xfffff
    80005942:	996080e7          	jalr	-1642(ra) # 800042d4 <end_op>
      return -1;
    80005946:	557d                	li	a0,-1
    80005948:	b76d                	j	800058f2 <sys_open+0xe2>
      end_op();
    8000594a:	fffff097          	auipc	ra,0xfffff
    8000594e:	98a080e7          	jalr	-1654(ra) # 800042d4 <end_op>
      return -1;
    80005952:	557d                	li	a0,-1
    80005954:	bf79                	j	800058f2 <sys_open+0xe2>
    iunlockput(ip);
    80005956:	8526                	mv	a0,s1
    80005958:	ffffe097          	auipc	ra,0xffffe
    8000595c:	1bc080e7          	jalr	444(ra) # 80003b14 <iunlockput>
    end_op();
    80005960:	fffff097          	auipc	ra,0xfffff
    80005964:	974080e7          	jalr	-1676(ra) # 800042d4 <end_op>
    return -1;
    80005968:	557d                	li	a0,-1
    8000596a:	b761                	j	800058f2 <sys_open+0xe2>
      fileclose(f);
    8000596c:	854a                	mv	a0,s2
    8000596e:	fffff097          	auipc	ra,0xfffff
    80005972:	db0080e7          	jalr	-592(ra) # 8000471e <fileclose>
    iunlockput(ip);
    80005976:	8526                	mv	a0,s1
    80005978:	ffffe097          	auipc	ra,0xffffe
    8000597c:	19c080e7          	jalr	412(ra) # 80003b14 <iunlockput>
    end_op();
    80005980:	fffff097          	auipc	ra,0xfffff
    80005984:	954080e7          	jalr	-1708(ra) # 800042d4 <end_op>
    return -1;
    80005988:	557d                	li	a0,-1
    8000598a:	b7a5                	j	800058f2 <sys_open+0xe2>
    f->type = FD_DEVICE;
    8000598c:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005990:	04649783          	lh	a5,70(s1)
    80005994:	02f91223          	sh	a5,36(s2)
    80005998:	bf21                	j	800058b0 <sys_open+0xa0>
    itrunc(ip);
    8000599a:	8526                	mv	a0,s1
    8000599c:	ffffe097          	auipc	ra,0xffffe
    800059a0:	024080e7          	jalr	36(ra) # 800039c0 <itrunc>
    800059a4:	bf2d                	j	800058de <sys_open+0xce>

00000000800059a6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800059a6:	7175                	add	sp,sp,-144
    800059a8:	e506                	sd	ra,136(sp)
    800059aa:	e122                	sd	s0,128(sp)
    800059ac:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800059ae:	fffff097          	auipc	ra,0xfffff
    800059b2:	8ac080e7          	jalr	-1876(ra) # 8000425a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800059b6:	08000613          	li	a2,128
    800059ba:	f7040593          	add	a1,s0,-144
    800059be:	4501                	li	a0,0
    800059c0:	ffffd097          	auipc	ra,0xffffd
    800059c4:	140080e7          	jalr	320(ra) # 80002b00 <argstr>
    800059c8:	02054963          	bltz	a0,800059fa <sys_mkdir+0x54>
    800059cc:	4681                	li	a3,0
    800059ce:	4601                	li	a2,0
    800059d0:	4585                	li	a1,1
    800059d2:	f7040513          	add	a0,s0,-144
    800059d6:	00000097          	auipc	ra,0x0
    800059da:	806080e7          	jalr	-2042(ra) # 800051dc <create>
    800059de:	cd11                	beqz	a0,800059fa <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800059e0:	ffffe097          	auipc	ra,0xffffe
    800059e4:	134080e7          	jalr	308(ra) # 80003b14 <iunlockput>
  end_op();
    800059e8:	fffff097          	auipc	ra,0xfffff
    800059ec:	8ec080e7          	jalr	-1812(ra) # 800042d4 <end_op>
  return 0;
    800059f0:	4501                	li	a0,0
}
    800059f2:	60aa                	ld	ra,136(sp)
    800059f4:	640a                	ld	s0,128(sp)
    800059f6:	6149                	add	sp,sp,144
    800059f8:	8082                	ret
    end_op();
    800059fa:	fffff097          	auipc	ra,0xfffff
    800059fe:	8da080e7          	jalr	-1830(ra) # 800042d4 <end_op>
    return -1;
    80005a02:	557d                	li	a0,-1
    80005a04:	b7fd                	j	800059f2 <sys_mkdir+0x4c>

0000000080005a06 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005a06:	7135                	add	sp,sp,-160
    80005a08:	ed06                	sd	ra,152(sp)
    80005a0a:	e922                	sd	s0,144(sp)
    80005a0c:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005a0e:	fffff097          	auipc	ra,0xfffff
    80005a12:	84c080e7          	jalr	-1972(ra) # 8000425a <begin_op>
  argint(1, &major);
    80005a16:	f6c40593          	add	a1,s0,-148
    80005a1a:	4505                	li	a0,1
    80005a1c:	ffffd097          	auipc	ra,0xffffd
    80005a20:	0a4080e7          	jalr	164(ra) # 80002ac0 <argint>
  argint(2, &minor);
    80005a24:	f6840593          	add	a1,s0,-152
    80005a28:	4509                	li	a0,2
    80005a2a:	ffffd097          	auipc	ra,0xffffd
    80005a2e:	096080e7          	jalr	150(ra) # 80002ac0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005a32:	08000613          	li	a2,128
    80005a36:	f7040593          	add	a1,s0,-144
    80005a3a:	4501                	li	a0,0
    80005a3c:	ffffd097          	auipc	ra,0xffffd
    80005a40:	0c4080e7          	jalr	196(ra) # 80002b00 <argstr>
    80005a44:	02054b63          	bltz	a0,80005a7a <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005a48:	f6841683          	lh	a3,-152(s0)
    80005a4c:	f6c41603          	lh	a2,-148(s0)
    80005a50:	458d                	li	a1,3
    80005a52:	f7040513          	add	a0,s0,-144
    80005a56:	fffff097          	auipc	ra,0xfffff
    80005a5a:	786080e7          	jalr	1926(ra) # 800051dc <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005a5e:	cd11                	beqz	a0,80005a7a <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005a60:	ffffe097          	auipc	ra,0xffffe
    80005a64:	0b4080e7          	jalr	180(ra) # 80003b14 <iunlockput>
  end_op();
    80005a68:	fffff097          	auipc	ra,0xfffff
    80005a6c:	86c080e7          	jalr	-1940(ra) # 800042d4 <end_op>
  return 0;
    80005a70:	4501                	li	a0,0
}
    80005a72:	60ea                	ld	ra,152(sp)
    80005a74:	644a                	ld	s0,144(sp)
    80005a76:	610d                	add	sp,sp,160
    80005a78:	8082                	ret
    end_op();
    80005a7a:	fffff097          	auipc	ra,0xfffff
    80005a7e:	85a080e7          	jalr	-1958(ra) # 800042d4 <end_op>
    return -1;
    80005a82:	557d                	li	a0,-1
    80005a84:	b7fd                	j	80005a72 <sys_mknod+0x6c>

0000000080005a86 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005a86:	7135                	add	sp,sp,-160
    80005a88:	ed06                	sd	ra,152(sp)
    80005a8a:	e922                	sd	s0,144(sp)
    80005a8c:	e526                	sd	s1,136(sp)
    80005a8e:	e14a                	sd	s2,128(sp)
    80005a90:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005a92:	ffffc097          	auipc	ra,0xffffc
    80005a96:	f14080e7          	jalr	-236(ra) # 800019a6 <myproc>
    80005a9a:	892a                	mv	s2,a0
  
  begin_op();
    80005a9c:	ffffe097          	auipc	ra,0xffffe
    80005aa0:	7be080e7          	jalr	1982(ra) # 8000425a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005aa4:	08000613          	li	a2,128
    80005aa8:	f6040593          	add	a1,s0,-160
    80005aac:	4501                	li	a0,0
    80005aae:	ffffd097          	auipc	ra,0xffffd
    80005ab2:	052080e7          	jalr	82(ra) # 80002b00 <argstr>
    80005ab6:	04054b63          	bltz	a0,80005b0c <sys_chdir+0x86>
    80005aba:	f6040513          	add	a0,s0,-160
    80005abe:	ffffe097          	auipc	ra,0xffffe
    80005ac2:	59c080e7          	jalr	1436(ra) # 8000405a <namei>
    80005ac6:	84aa                	mv	s1,a0
    80005ac8:	c131                	beqz	a0,80005b0c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005aca:	ffffe097          	auipc	ra,0xffffe
    80005ace:	de8080e7          	jalr	-536(ra) # 800038b2 <ilock>
  if(ip->type != T_DIR){
    80005ad2:	04449703          	lh	a4,68(s1)
    80005ad6:	4785                	li	a5,1
    80005ad8:	04f71063          	bne	a4,a5,80005b18 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005adc:	8526                	mv	a0,s1
    80005ade:	ffffe097          	auipc	ra,0xffffe
    80005ae2:	e96080e7          	jalr	-362(ra) # 80003974 <iunlock>
  iput(p->cwd);
    80005ae6:	15093503          	ld	a0,336(s2)
    80005aea:	ffffe097          	auipc	ra,0xffffe
    80005aee:	f82080e7          	jalr	-126(ra) # 80003a6c <iput>
  end_op();
    80005af2:	ffffe097          	auipc	ra,0xffffe
    80005af6:	7e2080e7          	jalr	2018(ra) # 800042d4 <end_op>
  p->cwd = ip;
    80005afa:	14993823          	sd	s1,336(s2)
  return 0;
    80005afe:	4501                	li	a0,0
}
    80005b00:	60ea                	ld	ra,152(sp)
    80005b02:	644a                	ld	s0,144(sp)
    80005b04:	64aa                	ld	s1,136(sp)
    80005b06:	690a                	ld	s2,128(sp)
    80005b08:	610d                	add	sp,sp,160
    80005b0a:	8082                	ret
    end_op();
    80005b0c:	ffffe097          	auipc	ra,0xffffe
    80005b10:	7c8080e7          	jalr	1992(ra) # 800042d4 <end_op>
    return -1;
    80005b14:	557d                	li	a0,-1
    80005b16:	b7ed                	j	80005b00 <sys_chdir+0x7a>
    iunlockput(ip);
    80005b18:	8526                	mv	a0,s1
    80005b1a:	ffffe097          	auipc	ra,0xffffe
    80005b1e:	ffa080e7          	jalr	-6(ra) # 80003b14 <iunlockput>
    end_op();
    80005b22:	ffffe097          	auipc	ra,0xffffe
    80005b26:	7b2080e7          	jalr	1970(ra) # 800042d4 <end_op>
    return -1;
    80005b2a:	557d                	li	a0,-1
    80005b2c:	bfd1                	j	80005b00 <sys_chdir+0x7a>

0000000080005b2e <sys_exec>:

uint64
sys_exec(void)
{
    80005b2e:	7121                	add	sp,sp,-448
    80005b30:	ff06                	sd	ra,440(sp)
    80005b32:	fb22                	sd	s0,432(sp)
    80005b34:	f726                	sd	s1,424(sp)
    80005b36:	f34a                	sd	s2,416(sp)
    80005b38:	ef4e                	sd	s3,408(sp)
    80005b3a:	eb52                	sd	s4,400(sp)
    80005b3c:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005b3e:	e4840593          	add	a1,s0,-440
    80005b42:	4505                	li	a0,1
    80005b44:	ffffd097          	auipc	ra,0xffffd
    80005b48:	f9c080e7          	jalr	-100(ra) # 80002ae0 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005b4c:	08000613          	li	a2,128
    80005b50:	f5040593          	add	a1,s0,-176
    80005b54:	4501                	li	a0,0
    80005b56:	ffffd097          	auipc	ra,0xffffd
    80005b5a:	faa080e7          	jalr	-86(ra) # 80002b00 <argstr>
    80005b5e:	87aa                	mv	a5,a0
    return -1;
    80005b60:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005b62:	0c07c263          	bltz	a5,80005c26 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80005b66:	10000613          	li	a2,256
    80005b6a:	4581                	li	a1,0
    80005b6c:	e5040513          	add	a0,s0,-432
    80005b70:	ffffb097          	auipc	ra,0xffffb
    80005b74:	15e080e7          	jalr	350(ra) # 80000cce <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005b78:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005b7c:	89a6                	mv	s3,s1
    80005b7e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005b80:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005b84:	00391513          	sll	a0,s2,0x3
    80005b88:	e4040593          	add	a1,s0,-448
    80005b8c:	e4843783          	ld	a5,-440(s0)
    80005b90:	953e                	add	a0,a0,a5
    80005b92:	ffffd097          	auipc	ra,0xffffd
    80005b96:	e90080e7          	jalr	-368(ra) # 80002a22 <fetchaddr>
    80005b9a:	02054a63          	bltz	a0,80005bce <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005b9e:	e4043783          	ld	a5,-448(s0)
    80005ba2:	c3b9                	beqz	a5,80005be8 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005ba4:	ffffb097          	auipc	ra,0xffffb
    80005ba8:	f3e080e7          	jalr	-194(ra) # 80000ae2 <kalloc>
    80005bac:	85aa                	mv	a1,a0
    80005bae:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005bb2:	cd11                	beqz	a0,80005bce <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005bb4:	6605                	lui	a2,0x1
    80005bb6:	e4043503          	ld	a0,-448(s0)
    80005bba:	ffffd097          	auipc	ra,0xffffd
    80005bbe:	eba080e7          	jalr	-326(ra) # 80002a74 <fetchstr>
    80005bc2:	00054663          	bltz	a0,80005bce <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80005bc6:	0905                	add	s2,s2,1
    80005bc8:	09a1                	add	s3,s3,8
    80005bca:	fb491de3          	bne	s2,s4,80005b84 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005bce:	f5040913          	add	s2,s0,-176
    80005bd2:	6088                	ld	a0,0(s1)
    80005bd4:	c921                	beqz	a0,80005c24 <sys_exec+0xf6>
    kfree(argv[i]);
    80005bd6:	ffffb097          	auipc	ra,0xffffb
    80005bda:	e0e080e7          	jalr	-498(ra) # 800009e4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005bde:	04a1                	add	s1,s1,8
    80005be0:	ff2499e3          	bne	s1,s2,80005bd2 <sys_exec+0xa4>
  return -1;
    80005be4:	557d                	li	a0,-1
    80005be6:	a081                	j	80005c26 <sys_exec+0xf8>
      argv[i] = 0;
    80005be8:	0009079b          	sext.w	a5,s2
    80005bec:	078e                	sll	a5,a5,0x3
    80005bee:	fd078793          	add	a5,a5,-48
    80005bf2:	97a2                	add	a5,a5,s0
    80005bf4:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005bf8:	e5040593          	add	a1,s0,-432
    80005bfc:	f5040513          	add	a0,s0,-176
    80005c00:	fffff097          	auipc	ra,0xfffff
    80005c04:	194080e7          	jalr	404(ra) # 80004d94 <exec>
    80005c08:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c0a:	f5040993          	add	s3,s0,-176
    80005c0e:	6088                	ld	a0,0(s1)
    80005c10:	c901                	beqz	a0,80005c20 <sys_exec+0xf2>
    kfree(argv[i]);
    80005c12:	ffffb097          	auipc	ra,0xffffb
    80005c16:	dd2080e7          	jalr	-558(ra) # 800009e4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c1a:	04a1                	add	s1,s1,8
    80005c1c:	ff3499e3          	bne	s1,s3,80005c0e <sys_exec+0xe0>
  return ret;
    80005c20:	854a                	mv	a0,s2
    80005c22:	a011                	j	80005c26 <sys_exec+0xf8>
  return -1;
    80005c24:	557d                	li	a0,-1
}
    80005c26:	70fa                	ld	ra,440(sp)
    80005c28:	745a                	ld	s0,432(sp)
    80005c2a:	74ba                	ld	s1,424(sp)
    80005c2c:	791a                	ld	s2,416(sp)
    80005c2e:	69fa                	ld	s3,408(sp)
    80005c30:	6a5a                	ld	s4,400(sp)
    80005c32:	6139                	add	sp,sp,448
    80005c34:	8082                	ret

0000000080005c36 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005c36:	7139                	add	sp,sp,-64
    80005c38:	fc06                	sd	ra,56(sp)
    80005c3a:	f822                	sd	s0,48(sp)
    80005c3c:	f426                	sd	s1,40(sp)
    80005c3e:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005c40:	ffffc097          	auipc	ra,0xffffc
    80005c44:	d66080e7          	jalr	-666(ra) # 800019a6 <myproc>
    80005c48:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005c4a:	fd840593          	add	a1,s0,-40
    80005c4e:	4501                	li	a0,0
    80005c50:	ffffd097          	auipc	ra,0xffffd
    80005c54:	e90080e7          	jalr	-368(ra) # 80002ae0 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005c58:	fc840593          	add	a1,s0,-56
    80005c5c:	fd040513          	add	a0,s0,-48
    80005c60:	fffff097          	auipc	ra,0xfffff
    80005c64:	dea080e7          	jalr	-534(ra) # 80004a4a <pipealloc>
    return -1;
    80005c68:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005c6a:	0c054463          	bltz	a0,80005d32 <sys_pipe+0xfc>
  fd0 = -1;
    80005c6e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005c72:	fd043503          	ld	a0,-48(s0)
    80005c76:	fffff097          	auipc	ra,0xfffff
    80005c7a:	524080e7          	jalr	1316(ra) # 8000519a <fdalloc>
    80005c7e:	fca42223          	sw	a0,-60(s0)
    80005c82:	08054b63          	bltz	a0,80005d18 <sys_pipe+0xe2>
    80005c86:	fc843503          	ld	a0,-56(s0)
    80005c8a:	fffff097          	auipc	ra,0xfffff
    80005c8e:	510080e7          	jalr	1296(ra) # 8000519a <fdalloc>
    80005c92:	fca42023          	sw	a0,-64(s0)
    80005c96:	06054863          	bltz	a0,80005d06 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c9a:	4691                	li	a3,4
    80005c9c:	fc440613          	add	a2,s0,-60
    80005ca0:	fd843583          	ld	a1,-40(s0)
    80005ca4:	68a8                	ld	a0,80(s1)
    80005ca6:	ffffc097          	auipc	ra,0xffffc
    80005caa:	9c0080e7          	jalr	-1600(ra) # 80001666 <copyout>
    80005cae:	02054063          	bltz	a0,80005cce <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005cb2:	4691                	li	a3,4
    80005cb4:	fc040613          	add	a2,s0,-64
    80005cb8:	fd843583          	ld	a1,-40(s0)
    80005cbc:	0591                	add	a1,a1,4
    80005cbe:	68a8                	ld	a0,80(s1)
    80005cc0:	ffffc097          	auipc	ra,0xffffc
    80005cc4:	9a6080e7          	jalr	-1626(ra) # 80001666 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005cc8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005cca:	06055463          	bgez	a0,80005d32 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005cce:	fc442783          	lw	a5,-60(s0)
    80005cd2:	07e9                	add	a5,a5,26
    80005cd4:	078e                	sll	a5,a5,0x3
    80005cd6:	97a6                	add	a5,a5,s1
    80005cd8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005cdc:	fc042783          	lw	a5,-64(s0)
    80005ce0:	07e9                	add	a5,a5,26
    80005ce2:	078e                	sll	a5,a5,0x3
    80005ce4:	94be                	add	s1,s1,a5
    80005ce6:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005cea:	fd043503          	ld	a0,-48(s0)
    80005cee:	fffff097          	auipc	ra,0xfffff
    80005cf2:	a30080e7          	jalr	-1488(ra) # 8000471e <fileclose>
    fileclose(wf);
    80005cf6:	fc843503          	ld	a0,-56(s0)
    80005cfa:	fffff097          	auipc	ra,0xfffff
    80005cfe:	a24080e7          	jalr	-1500(ra) # 8000471e <fileclose>
    return -1;
    80005d02:	57fd                	li	a5,-1
    80005d04:	a03d                	j	80005d32 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005d06:	fc442783          	lw	a5,-60(s0)
    80005d0a:	0007c763          	bltz	a5,80005d18 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005d0e:	07e9                	add	a5,a5,26
    80005d10:	078e                	sll	a5,a5,0x3
    80005d12:	97a6                	add	a5,a5,s1
    80005d14:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005d18:	fd043503          	ld	a0,-48(s0)
    80005d1c:	fffff097          	auipc	ra,0xfffff
    80005d20:	a02080e7          	jalr	-1534(ra) # 8000471e <fileclose>
    fileclose(wf);
    80005d24:	fc843503          	ld	a0,-56(s0)
    80005d28:	fffff097          	auipc	ra,0xfffff
    80005d2c:	9f6080e7          	jalr	-1546(ra) # 8000471e <fileclose>
    return -1;
    80005d30:	57fd                	li	a5,-1
}
    80005d32:	853e                	mv	a0,a5
    80005d34:	70e2                	ld	ra,56(sp)
    80005d36:	7442                	ld	s0,48(sp)
    80005d38:	74a2                	ld	s1,40(sp)
    80005d3a:	6121                	add	sp,sp,64
    80005d3c:	8082                	ret
	...

0000000080005d40 <kernelvec>:
    80005d40:	7111                	add	sp,sp,-256
    80005d42:	e006                	sd	ra,0(sp)
    80005d44:	e40a                	sd	sp,8(sp)
    80005d46:	e80e                	sd	gp,16(sp)
    80005d48:	ec12                	sd	tp,24(sp)
    80005d4a:	f016                	sd	t0,32(sp)
    80005d4c:	f41a                	sd	t1,40(sp)
    80005d4e:	f81e                	sd	t2,48(sp)
    80005d50:	fc22                	sd	s0,56(sp)
    80005d52:	e0a6                	sd	s1,64(sp)
    80005d54:	e4aa                	sd	a0,72(sp)
    80005d56:	e8ae                	sd	a1,80(sp)
    80005d58:	ecb2                	sd	a2,88(sp)
    80005d5a:	f0b6                	sd	a3,96(sp)
    80005d5c:	f4ba                	sd	a4,104(sp)
    80005d5e:	f8be                	sd	a5,112(sp)
    80005d60:	fcc2                	sd	a6,120(sp)
    80005d62:	e146                	sd	a7,128(sp)
    80005d64:	e54a                	sd	s2,136(sp)
    80005d66:	e94e                	sd	s3,144(sp)
    80005d68:	ed52                	sd	s4,152(sp)
    80005d6a:	f156                	sd	s5,160(sp)
    80005d6c:	f55a                	sd	s6,168(sp)
    80005d6e:	f95e                	sd	s7,176(sp)
    80005d70:	fd62                	sd	s8,184(sp)
    80005d72:	e1e6                	sd	s9,192(sp)
    80005d74:	e5ea                	sd	s10,200(sp)
    80005d76:	e9ee                	sd	s11,208(sp)
    80005d78:	edf2                	sd	t3,216(sp)
    80005d7a:	f1f6                	sd	t4,224(sp)
    80005d7c:	f5fa                	sd	t5,232(sp)
    80005d7e:	f9fe                	sd	t6,240(sp)
    80005d80:	b6ffc0ef          	jal	800028ee <kerneltrap>
    80005d84:	6082                	ld	ra,0(sp)
    80005d86:	6122                	ld	sp,8(sp)
    80005d88:	61c2                	ld	gp,16(sp)
    80005d8a:	7282                	ld	t0,32(sp)
    80005d8c:	7322                	ld	t1,40(sp)
    80005d8e:	73c2                	ld	t2,48(sp)
    80005d90:	7462                	ld	s0,56(sp)
    80005d92:	6486                	ld	s1,64(sp)
    80005d94:	6526                	ld	a0,72(sp)
    80005d96:	65c6                	ld	a1,80(sp)
    80005d98:	6666                	ld	a2,88(sp)
    80005d9a:	7686                	ld	a3,96(sp)
    80005d9c:	7726                	ld	a4,104(sp)
    80005d9e:	77c6                	ld	a5,112(sp)
    80005da0:	7866                	ld	a6,120(sp)
    80005da2:	688a                	ld	a7,128(sp)
    80005da4:	692a                	ld	s2,136(sp)
    80005da6:	69ca                	ld	s3,144(sp)
    80005da8:	6a6a                	ld	s4,152(sp)
    80005daa:	7a8a                	ld	s5,160(sp)
    80005dac:	7b2a                	ld	s6,168(sp)
    80005dae:	7bca                	ld	s7,176(sp)
    80005db0:	7c6a                	ld	s8,184(sp)
    80005db2:	6c8e                	ld	s9,192(sp)
    80005db4:	6d2e                	ld	s10,200(sp)
    80005db6:	6dce                	ld	s11,208(sp)
    80005db8:	6e6e                	ld	t3,216(sp)
    80005dba:	7e8e                	ld	t4,224(sp)
    80005dbc:	7f2e                	ld	t5,232(sp)
    80005dbe:	7fce                	ld	t6,240(sp)
    80005dc0:	6111                	add	sp,sp,256
    80005dc2:	10200073          	sret
    80005dc6:	00000013          	nop
    80005dca:	00000013          	nop
    80005dce:	0001                	nop

0000000080005dd0 <timervec>:
    80005dd0:	34051573          	csrrw	a0,mscratch,a0
    80005dd4:	e10c                	sd	a1,0(a0)
    80005dd6:	e510                	sd	a2,8(a0)
    80005dd8:	e914                	sd	a3,16(a0)
    80005dda:	6d0c                	ld	a1,24(a0)
    80005ddc:	7110                	ld	a2,32(a0)
    80005dde:	6194                	ld	a3,0(a1)
    80005de0:	96b2                	add	a3,a3,a2
    80005de2:	e194                	sd	a3,0(a1)
    80005de4:	4589                	li	a1,2
    80005de6:	14459073          	csrw	sip,a1
    80005dea:	6914                	ld	a3,16(a0)
    80005dec:	6510                	ld	a2,8(a0)
    80005dee:	610c                	ld	a1,0(a0)
    80005df0:	34051573          	csrrw	a0,mscratch,a0
    80005df4:	30200073          	mret
	...

0000000080005dfa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005dfa:	1141                	add	sp,sp,-16
    80005dfc:	e422                	sd	s0,8(sp)
    80005dfe:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005e00:	0c0007b7          	lui	a5,0xc000
    80005e04:	4705                	li	a4,1
    80005e06:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005e08:	c3d8                	sw	a4,4(a5)
}
    80005e0a:	6422                	ld	s0,8(sp)
    80005e0c:	0141                	add	sp,sp,16
    80005e0e:	8082                	ret

0000000080005e10 <plicinithart>:

void
plicinithart(void)
{
    80005e10:	1141                	add	sp,sp,-16
    80005e12:	e406                	sd	ra,8(sp)
    80005e14:	e022                	sd	s0,0(sp)
    80005e16:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005e18:	ffffc097          	auipc	ra,0xffffc
    80005e1c:	b62080e7          	jalr	-1182(ra) # 8000197a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005e20:	0085171b          	sllw	a4,a0,0x8
    80005e24:	0c0027b7          	lui	a5,0xc002
    80005e28:	97ba                	add	a5,a5,a4
    80005e2a:	40200713          	li	a4,1026
    80005e2e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005e32:	00d5151b          	sllw	a0,a0,0xd
    80005e36:	0c2017b7          	lui	a5,0xc201
    80005e3a:	97aa                	add	a5,a5,a0
    80005e3c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005e40:	60a2                	ld	ra,8(sp)
    80005e42:	6402                	ld	s0,0(sp)
    80005e44:	0141                	add	sp,sp,16
    80005e46:	8082                	ret

0000000080005e48 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005e48:	1141                	add	sp,sp,-16
    80005e4a:	e406                	sd	ra,8(sp)
    80005e4c:	e022                	sd	s0,0(sp)
    80005e4e:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005e50:	ffffc097          	auipc	ra,0xffffc
    80005e54:	b2a080e7          	jalr	-1238(ra) # 8000197a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005e58:	00d5151b          	sllw	a0,a0,0xd
    80005e5c:	0c2017b7          	lui	a5,0xc201
    80005e60:	97aa                	add	a5,a5,a0
  return irq;
}
    80005e62:	43c8                	lw	a0,4(a5)
    80005e64:	60a2                	ld	ra,8(sp)
    80005e66:	6402                	ld	s0,0(sp)
    80005e68:	0141                	add	sp,sp,16
    80005e6a:	8082                	ret

0000000080005e6c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005e6c:	1101                	add	sp,sp,-32
    80005e6e:	ec06                	sd	ra,24(sp)
    80005e70:	e822                	sd	s0,16(sp)
    80005e72:	e426                	sd	s1,8(sp)
    80005e74:	1000                	add	s0,sp,32
    80005e76:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005e78:	ffffc097          	auipc	ra,0xffffc
    80005e7c:	b02080e7          	jalr	-1278(ra) # 8000197a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005e80:	00d5151b          	sllw	a0,a0,0xd
    80005e84:	0c2017b7          	lui	a5,0xc201
    80005e88:	97aa                	add	a5,a5,a0
    80005e8a:	c3c4                	sw	s1,4(a5)
}
    80005e8c:	60e2                	ld	ra,24(sp)
    80005e8e:	6442                	ld	s0,16(sp)
    80005e90:	64a2                	ld	s1,8(sp)
    80005e92:	6105                	add	sp,sp,32
    80005e94:	8082                	ret

0000000080005e96 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005e96:	1141                	add	sp,sp,-16
    80005e98:	e406                	sd	ra,8(sp)
    80005e9a:	e022                	sd	s0,0(sp)
    80005e9c:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005e9e:	479d                	li	a5,7
    80005ea0:	04a7cc63          	blt	a5,a0,80005ef8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005ea4:	0001c797          	auipc	a5,0x1c
    80005ea8:	e4c78793          	add	a5,a5,-436 # 80021cf0 <disk>
    80005eac:	97aa                	add	a5,a5,a0
    80005eae:	0187c783          	lbu	a5,24(a5)
    80005eb2:	ebb9                	bnez	a5,80005f08 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005eb4:	00451693          	sll	a3,a0,0x4
    80005eb8:	0001c797          	auipc	a5,0x1c
    80005ebc:	e3878793          	add	a5,a5,-456 # 80021cf0 <disk>
    80005ec0:	6398                	ld	a4,0(a5)
    80005ec2:	9736                	add	a4,a4,a3
    80005ec4:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005ec8:	6398                	ld	a4,0(a5)
    80005eca:	9736                	add	a4,a4,a3
    80005ecc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005ed0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005ed4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005ed8:	97aa                	add	a5,a5,a0
    80005eda:	4705                	li	a4,1
    80005edc:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005ee0:	0001c517          	auipc	a0,0x1c
    80005ee4:	e2850513          	add	a0,a0,-472 # 80021d08 <disk+0x18>
    80005ee8:	ffffc097          	auipc	ra,0xffffc
    80005eec:	1ca080e7          	jalr	458(ra) # 800020b2 <wakeup>
}
    80005ef0:	60a2                	ld	ra,8(sp)
    80005ef2:	6402                	ld	s0,0(sp)
    80005ef4:	0141                	add	sp,sp,16
    80005ef6:	8082                	ret
    panic("free_desc 1");
    80005ef8:	00003517          	auipc	a0,0x3
    80005efc:	93050513          	add	a0,a0,-1744 # 80008828 <syscalls+0x3c8>
    80005f00:	ffffa097          	auipc	ra,0xffffa
    80005f04:	63c080e7          	jalr	1596(ra) # 8000053c <panic>
    panic("free_desc 2");
    80005f08:	00003517          	auipc	a0,0x3
    80005f0c:	93050513          	add	a0,a0,-1744 # 80008838 <syscalls+0x3d8>
    80005f10:	ffffa097          	auipc	ra,0xffffa
    80005f14:	62c080e7          	jalr	1580(ra) # 8000053c <panic>

0000000080005f18 <virtio_disk_init>:
{
    80005f18:	1101                	add	sp,sp,-32
    80005f1a:	ec06                	sd	ra,24(sp)
    80005f1c:	e822                	sd	s0,16(sp)
    80005f1e:	e426                	sd	s1,8(sp)
    80005f20:	e04a                	sd	s2,0(sp)
    80005f22:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005f24:	00003597          	auipc	a1,0x3
    80005f28:	92458593          	add	a1,a1,-1756 # 80008848 <syscalls+0x3e8>
    80005f2c:	0001c517          	auipc	a0,0x1c
    80005f30:	eec50513          	add	a0,a0,-276 # 80021e18 <disk+0x128>
    80005f34:	ffffb097          	auipc	ra,0xffffb
    80005f38:	c0e080e7          	jalr	-1010(ra) # 80000b42 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f3c:	100017b7          	lui	a5,0x10001
    80005f40:	4398                	lw	a4,0(a5)
    80005f42:	2701                	sext.w	a4,a4
    80005f44:	747277b7          	lui	a5,0x74727
    80005f48:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005f4c:	14f71b63          	bne	a4,a5,800060a2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005f50:	100017b7          	lui	a5,0x10001
    80005f54:	43dc                	lw	a5,4(a5)
    80005f56:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f58:	4709                	li	a4,2
    80005f5a:	14e79463          	bne	a5,a4,800060a2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005f5e:	100017b7          	lui	a5,0x10001
    80005f62:	479c                	lw	a5,8(a5)
    80005f64:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005f66:	12e79e63          	bne	a5,a4,800060a2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005f6a:	100017b7          	lui	a5,0x10001
    80005f6e:	47d8                	lw	a4,12(a5)
    80005f70:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005f72:	554d47b7          	lui	a5,0x554d4
    80005f76:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005f7a:	12f71463          	bne	a4,a5,800060a2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f7e:	100017b7          	lui	a5,0x10001
    80005f82:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f86:	4705                	li	a4,1
    80005f88:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f8a:	470d                	li	a4,3
    80005f8c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005f8e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005f90:	c7ffe6b7          	lui	a3,0xc7ffe
    80005f94:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc92f>
    80005f98:	8f75                	and	a4,a4,a3
    80005f9a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f9c:	472d                	li	a4,11
    80005f9e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005fa0:	5bbc                	lw	a5,112(a5)
    80005fa2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005fa6:	8ba1                	and	a5,a5,8
    80005fa8:	10078563          	beqz	a5,800060b2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005fac:	100017b7          	lui	a5,0x10001
    80005fb0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005fb4:	43fc                	lw	a5,68(a5)
    80005fb6:	2781                	sext.w	a5,a5
    80005fb8:	10079563          	bnez	a5,800060c2 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005fbc:	100017b7          	lui	a5,0x10001
    80005fc0:	5bdc                	lw	a5,52(a5)
    80005fc2:	2781                	sext.w	a5,a5
  if(max == 0)
    80005fc4:	10078763          	beqz	a5,800060d2 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005fc8:	471d                	li	a4,7
    80005fca:	10f77c63          	bgeu	a4,a5,800060e2 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    80005fce:	ffffb097          	auipc	ra,0xffffb
    80005fd2:	b14080e7          	jalr	-1260(ra) # 80000ae2 <kalloc>
    80005fd6:	0001c497          	auipc	s1,0x1c
    80005fda:	d1a48493          	add	s1,s1,-742 # 80021cf0 <disk>
    80005fde:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005fe0:	ffffb097          	auipc	ra,0xffffb
    80005fe4:	b02080e7          	jalr	-1278(ra) # 80000ae2 <kalloc>
    80005fe8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005fea:	ffffb097          	auipc	ra,0xffffb
    80005fee:	af8080e7          	jalr	-1288(ra) # 80000ae2 <kalloc>
    80005ff2:	87aa                	mv	a5,a0
    80005ff4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005ff6:	6088                	ld	a0,0(s1)
    80005ff8:	cd6d                	beqz	a0,800060f2 <virtio_disk_init+0x1da>
    80005ffa:	0001c717          	auipc	a4,0x1c
    80005ffe:	cfe73703          	ld	a4,-770(a4) # 80021cf8 <disk+0x8>
    80006002:	cb65                	beqz	a4,800060f2 <virtio_disk_init+0x1da>
    80006004:	c7fd                	beqz	a5,800060f2 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80006006:	6605                	lui	a2,0x1
    80006008:	4581                	li	a1,0
    8000600a:	ffffb097          	auipc	ra,0xffffb
    8000600e:	cc4080e7          	jalr	-828(ra) # 80000cce <memset>
  memset(disk.avail, 0, PGSIZE);
    80006012:	0001c497          	auipc	s1,0x1c
    80006016:	cde48493          	add	s1,s1,-802 # 80021cf0 <disk>
    8000601a:	6605                	lui	a2,0x1
    8000601c:	4581                	li	a1,0
    8000601e:	6488                	ld	a0,8(s1)
    80006020:	ffffb097          	auipc	ra,0xffffb
    80006024:	cae080e7          	jalr	-850(ra) # 80000cce <memset>
  memset(disk.used, 0, PGSIZE);
    80006028:	6605                	lui	a2,0x1
    8000602a:	4581                	li	a1,0
    8000602c:	6888                	ld	a0,16(s1)
    8000602e:	ffffb097          	auipc	ra,0xffffb
    80006032:	ca0080e7          	jalr	-864(ra) # 80000cce <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006036:	100017b7          	lui	a5,0x10001
    8000603a:	4721                	li	a4,8
    8000603c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000603e:	4098                	lw	a4,0(s1)
    80006040:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006044:	40d8                	lw	a4,4(s1)
    80006046:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000604a:	6498                	ld	a4,8(s1)
    8000604c:	0007069b          	sext.w	a3,a4
    80006050:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006054:	9701                	sra	a4,a4,0x20
    80006056:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000605a:	6898                	ld	a4,16(s1)
    8000605c:	0007069b          	sext.w	a3,a4
    80006060:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006064:	9701                	sra	a4,a4,0x20
    80006066:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000606a:	4705                	li	a4,1
    8000606c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000606e:	00e48c23          	sb	a4,24(s1)
    80006072:	00e48ca3          	sb	a4,25(s1)
    80006076:	00e48d23          	sb	a4,26(s1)
    8000607a:	00e48da3          	sb	a4,27(s1)
    8000607e:	00e48e23          	sb	a4,28(s1)
    80006082:	00e48ea3          	sb	a4,29(s1)
    80006086:	00e48f23          	sb	a4,30(s1)
    8000608a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000608e:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006092:	0727a823          	sw	s2,112(a5)
}
    80006096:	60e2                	ld	ra,24(sp)
    80006098:	6442                	ld	s0,16(sp)
    8000609a:	64a2                	ld	s1,8(sp)
    8000609c:	6902                	ld	s2,0(sp)
    8000609e:	6105                	add	sp,sp,32
    800060a0:	8082                	ret
    panic("could not find virtio disk");
    800060a2:	00002517          	auipc	a0,0x2
    800060a6:	7b650513          	add	a0,a0,1974 # 80008858 <syscalls+0x3f8>
    800060aa:	ffffa097          	auipc	ra,0xffffa
    800060ae:	492080e7          	jalr	1170(ra) # 8000053c <panic>
    panic("virtio disk FEATURES_OK unset");
    800060b2:	00002517          	auipc	a0,0x2
    800060b6:	7c650513          	add	a0,a0,1990 # 80008878 <syscalls+0x418>
    800060ba:	ffffa097          	auipc	ra,0xffffa
    800060be:	482080e7          	jalr	1154(ra) # 8000053c <panic>
    panic("virtio disk should not be ready");
    800060c2:	00002517          	auipc	a0,0x2
    800060c6:	7d650513          	add	a0,a0,2006 # 80008898 <syscalls+0x438>
    800060ca:	ffffa097          	auipc	ra,0xffffa
    800060ce:	472080e7          	jalr	1138(ra) # 8000053c <panic>
    panic("virtio disk has no queue 0");
    800060d2:	00002517          	auipc	a0,0x2
    800060d6:	7e650513          	add	a0,a0,2022 # 800088b8 <syscalls+0x458>
    800060da:	ffffa097          	auipc	ra,0xffffa
    800060de:	462080e7          	jalr	1122(ra) # 8000053c <panic>
    panic("virtio disk max queue too short");
    800060e2:	00002517          	auipc	a0,0x2
    800060e6:	7f650513          	add	a0,a0,2038 # 800088d8 <syscalls+0x478>
    800060ea:	ffffa097          	auipc	ra,0xffffa
    800060ee:	452080e7          	jalr	1106(ra) # 8000053c <panic>
    panic("virtio disk kalloc");
    800060f2:	00003517          	auipc	a0,0x3
    800060f6:	80650513          	add	a0,a0,-2042 # 800088f8 <syscalls+0x498>
    800060fa:	ffffa097          	auipc	ra,0xffffa
    800060fe:	442080e7          	jalr	1090(ra) # 8000053c <panic>

0000000080006102 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006102:	7159                	add	sp,sp,-112
    80006104:	f486                	sd	ra,104(sp)
    80006106:	f0a2                	sd	s0,96(sp)
    80006108:	eca6                	sd	s1,88(sp)
    8000610a:	e8ca                	sd	s2,80(sp)
    8000610c:	e4ce                	sd	s3,72(sp)
    8000610e:	e0d2                	sd	s4,64(sp)
    80006110:	fc56                	sd	s5,56(sp)
    80006112:	f85a                	sd	s6,48(sp)
    80006114:	f45e                	sd	s7,40(sp)
    80006116:	f062                	sd	s8,32(sp)
    80006118:	ec66                	sd	s9,24(sp)
    8000611a:	e86a                	sd	s10,16(sp)
    8000611c:	1880                	add	s0,sp,112
    8000611e:	8a2a                	mv	s4,a0
    80006120:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006122:	00c52c83          	lw	s9,12(a0)
    80006126:	001c9c9b          	sllw	s9,s9,0x1
    8000612a:	1c82                	sll	s9,s9,0x20
    8000612c:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006130:	0001c517          	auipc	a0,0x1c
    80006134:	ce850513          	add	a0,a0,-792 # 80021e18 <disk+0x128>
    80006138:	ffffb097          	auipc	ra,0xffffb
    8000613c:	a9a080e7          	jalr	-1382(ra) # 80000bd2 <acquire>
  for(int i = 0; i < 3; i++){
    80006140:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80006142:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006144:	0001cb17          	auipc	s6,0x1c
    80006148:	bacb0b13          	add	s6,s6,-1108 # 80021cf0 <disk>
  for(int i = 0; i < 3; i++){
    8000614c:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000614e:	0001cc17          	auipc	s8,0x1c
    80006152:	ccac0c13          	add	s8,s8,-822 # 80021e18 <disk+0x128>
    80006156:	a095                	j	800061ba <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80006158:	00fb0733          	add	a4,s6,a5
    8000615c:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006160:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80006162:	0207c563          	bltz	a5,8000618c <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    80006166:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80006168:	0591                	add	a1,a1,4
    8000616a:	05560d63          	beq	a2,s5,800061c4 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    8000616e:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80006170:	0001c717          	auipc	a4,0x1c
    80006174:	b8070713          	add	a4,a4,-1152 # 80021cf0 <disk>
    80006178:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000617a:	01874683          	lbu	a3,24(a4)
    8000617e:	fee9                	bnez	a3,80006158 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80006180:	2785                	addw	a5,a5,1
    80006182:	0705                	add	a4,a4,1
    80006184:	fe979be3          	bne	a5,s1,8000617a <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    80006188:	57fd                	li	a5,-1
    8000618a:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    8000618c:	00c05e63          	blez	a2,800061a8 <virtio_disk_rw+0xa6>
    80006190:	060a                	sll	a2,a2,0x2
    80006192:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80006196:	0009a503          	lw	a0,0(s3)
    8000619a:	00000097          	auipc	ra,0x0
    8000619e:	cfc080e7          	jalr	-772(ra) # 80005e96 <free_desc>
      for(int j = 0; j < i; j++)
    800061a2:	0991                	add	s3,s3,4
    800061a4:	ffa999e3          	bne	s3,s10,80006196 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800061a8:	85e2                	mv	a1,s8
    800061aa:	0001c517          	auipc	a0,0x1c
    800061ae:	b5e50513          	add	a0,a0,-1186 # 80021d08 <disk+0x18>
    800061b2:	ffffc097          	auipc	ra,0xffffc
    800061b6:	e9c080e7          	jalr	-356(ra) # 8000204e <sleep>
  for(int i = 0; i < 3; i++){
    800061ba:	f9040993          	add	s3,s0,-112
{
    800061be:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    800061c0:	864a                	mv	a2,s2
    800061c2:	b775                	j	8000616e <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800061c4:	f9042503          	lw	a0,-112(s0)
    800061c8:	00a50713          	add	a4,a0,10
    800061cc:	0712                	sll	a4,a4,0x4

  if(write)
    800061ce:	0001c797          	auipc	a5,0x1c
    800061d2:	b2278793          	add	a5,a5,-1246 # 80021cf0 <disk>
    800061d6:	00e786b3          	add	a3,a5,a4
    800061da:	01703633          	snez	a2,s7
    800061de:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800061e0:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    800061e4:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800061e8:	f6070613          	add	a2,a4,-160
    800061ec:	6394                	ld	a3,0(a5)
    800061ee:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800061f0:	00870593          	add	a1,a4,8
    800061f4:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800061f6:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800061f8:	0007b803          	ld	a6,0(a5)
    800061fc:	9642                	add	a2,a2,a6
    800061fe:	46c1                	li	a3,16
    80006200:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006202:	4585                	li	a1,1
    80006204:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80006208:	f9442683          	lw	a3,-108(s0)
    8000620c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006210:	0692                	sll	a3,a3,0x4
    80006212:	9836                	add	a6,a6,a3
    80006214:	058a0613          	add	a2,s4,88
    80006218:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000621c:	0007b803          	ld	a6,0(a5)
    80006220:	96c2                	add	a3,a3,a6
    80006222:	40000613          	li	a2,1024
    80006226:	c690                	sw	a2,8(a3)
  if(write)
    80006228:	001bb613          	seqz	a2,s7
    8000622c:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006230:	00166613          	or	a2,a2,1
    80006234:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80006238:	f9842603          	lw	a2,-104(s0)
    8000623c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006240:	00250693          	add	a3,a0,2
    80006244:	0692                	sll	a3,a3,0x4
    80006246:	96be                	add	a3,a3,a5
    80006248:	58fd                	li	a7,-1
    8000624a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000624e:	0612                	sll	a2,a2,0x4
    80006250:	9832                	add	a6,a6,a2
    80006252:	f9070713          	add	a4,a4,-112
    80006256:	973e                	add	a4,a4,a5
    80006258:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000625c:	6398                	ld	a4,0(a5)
    8000625e:	9732                	add	a4,a4,a2
    80006260:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006262:	4609                	li	a2,2
    80006264:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80006268:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000626c:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80006270:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006274:	6794                	ld	a3,8(a5)
    80006276:	0026d703          	lhu	a4,2(a3)
    8000627a:	8b1d                	and	a4,a4,7
    8000627c:	0706                	sll	a4,a4,0x1
    8000627e:	96ba                	add	a3,a3,a4
    80006280:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006284:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006288:	6798                	ld	a4,8(a5)
    8000628a:	00275783          	lhu	a5,2(a4)
    8000628e:	2785                	addw	a5,a5,1
    80006290:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006294:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006298:	100017b7          	lui	a5,0x10001
    8000629c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800062a0:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800062a4:	0001c917          	auipc	s2,0x1c
    800062a8:	b7490913          	add	s2,s2,-1164 # 80021e18 <disk+0x128>
  while(b->disk == 1) {
    800062ac:	4485                	li	s1,1
    800062ae:	00b79c63          	bne	a5,a1,800062c6 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800062b2:	85ca                	mv	a1,s2
    800062b4:	8552                	mv	a0,s4
    800062b6:	ffffc097          	auipc	ra,0xffffc
    800062ba:	d98080e7          	jalr	-616(ra) # 8000204e <sleep>
  while(b->disk == 1) {
    800062be:	004a2783          	lw	a5,4(s4)
    800062c2:	fe9788e3          	beq	a5,s1,800062b2 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800062c6:	f9042903          	lw	s2,-112(s0)
    800062ca:	00290713          	add	a4,s2,2
    800062ce:	0712                	sll	a4,a4,0x4
    800062d0:	0001c797          	auipc	a5,0x1c
    800062d4:	a2078793          	add	a5,a5,-1504 # 80021cf0 <disk>
    800062d8:	97ba                	add	a5,a5,a4
    800062da:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800062de:	0001c997          	auipc	s3,0x1c
    800062e2:	a1298993          	add	s3,s3,-1518 # 80021cf0 <disk>
    800062e6:	00491713          	sll	a4,s2,0x4
    800062ea:	0009b783          	ld	a5,0(s3)
    800062ee:	97ba                	add	a5,a5,a4
    800062f0:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800062f4:	854a                	mv	a0,s2
    800062f6:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800062fa:	00000097          	auipc	ra,0x0
    800062fe:	b9c080e7          	jalr	-1124(ra) # 80005e96 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006302:	8885                	and	s1,s1,1
    80006304:	f0ed                	bnez	s1,800062e6 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006306:	0001c517          	auipc	a0,0x1c
    8000630a:	b1250513          	add	a0,a0,-1262 # 80021e18 <disk+0x128>
    8000630e:	ffffb097          	auipc	ra,0xffffb
    80006312:	978080e7          	jalr	-1672(ra) # 80000c86 <release>
}
    80006316:	70a6                	ld	ra,104(sp)
    80006318:	7406                	ld	s0,96(sp)
    8000631a:	64e6                	ld	s1,88(sp)
    8000631c:	6946                	ld	s2,80(sp)
    8000631e:	69a6                	ld	s3,72(sp)
    80006320:	6a06                	ld	s4,64(sp)
    80006322:	7ae2                	ld	s5,56(sp)
    80006324:	7b42                	ld	s6,48(sp)
    80006326:	7ba2                	ld	s7,40(sp)
    80006328:	7c02                	ld	s8,32(sp)
    8000632a:	6ce2                	ld	s9,24(sp)
    8000632c:	6d42                	ld	s10,16(sp)
    8000632e:	6165                	add	sp,sp,112
    80006330:	8082                	ret

0000000080006332 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006332:	1101                	add	sp,sp,-32
    80006334:	ec06                	sd	ra,24(sp)
    80006336:	e822                	sd	s0,16(sp)
    80006338:	e426                	sd	s1,8(sp)
    8000633a:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000633c:	0001c497          	auipc	s1,0x1c
    80006340:	9b448493          	add	s1,s1,-1612 # 80021cf0 <disk>
    80006344:	0001c517          	auipc	a0,0x1c
    80006348:	ad450513          	add	a0,a0,-1324 # 80021e18 <disk+0x128>
    8000634c:	ffffb097          	auipc	ra,0xffffb
    80006350:	886080e7          	jalr	-1914(ra) # 80000bd2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006354:	10001737          	lui	a4,0x10001
    80006358:	533c                	lw	a5,96(a4)
    8000635a:	8b8d                	and	a5,a5,3
    8000635c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000635e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006362:	689c                	ld	a5,16(s1)
    80006364:	0204d703          	lhu	a4,32(s1)
    80006368:	0027d783          	lhu	a5,2(a5)
    8000636c:	04f70863          	beq	a4,a5,800063bc <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80006370:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006374:	6898                	ld	a4,16(s1)
    80006376:	0204d783          	lhu	a5,32(s1)
    8000637a:	8b9d                	and	a5,a5,7
    8000637c:	078e                	sll	a5,a5,0x3
    8000637e:	97ba                	add	a5,a5,a4
    80006380:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006382:	00278713          	add	a4,a5,2
    80006386:	0712                	sll	a4,a4,0x4
    80006388:	9726                	add	a4,a4,s1
    8000638a:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000638e:	e721                	bnez	a4,800063d6 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006390:	0789                	add	a5,a5,2
    80006392:	0792                	sll	a5,a5,0x4
    80006394:	97a6                	add	a5,a5,s1
    80006396:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006398:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000639c:	ffffc097          	auipc	ra,0xffffc
    800063a0:	d16080e7          	jalr	-746(ra) # 800020b2 <wakeup>

    disk.used_idx += 1;
    800063a4:	0204d783          	lhu	a5,32(s1)
    800063a8:	2785                	addw	a5,a5,1
    800063aa:	17c2                	sll	a5,a5,0x30
    800063ac:	93c1                	srl	a5,a5,0x30
    800063ae:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800063b2:	6898                	ld	a4,16(s1)
    800063b4:	00275703          	lhu	a4,2(a4)
    800063b8:	faf71ce3          	bne	a4,a5,80006370 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800063bc:	0001c517          	auipc	a0,0x1c
    800063c0:	a5c50513          	add	a0,a0,-1444 # 80021e18 <disk+0x128>
    800063c4:	ffffb097          	auipc	ra,0xffffb
    800063c8:	8c2080e7          	jalr	-1854(ra) # 80000c86 <release>
}
    800063cc:	60e2                	ld	ra,24(sp)
    800063ce:	6442                	ld	s0,16(sp)
    800063d0:	64a2                	ld	s1,8(sp)
    800063d2:	6105                	add	sp,sp,32
    800063d4:	8082                	ret
      panic("virtio_disk_intr status");
    800063d6:	00002517          	auipc	a0,0x2
    800063da:	53a50513          	add	a0,a0,1338 # 80008910 <syscalls+0x4b0>
    800063de:	ffffa097          	auipc	ra,0xffffa
    800063e2:	15e080e7          	jalr	350(ra) # 8000053c <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	sll	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	sll	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
