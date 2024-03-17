
user/_writebigfile:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <printProgressBar>:


#define NDOUBLY_INDIRECT NINDIRECT*NINDIRECT
#define MAXFILE (NDIRECT + NINDIRECT + NDOUBLY_INDIRECT)

void printProgressBar(int t) {
   0:	7139                	add	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	e05a                	sd	s6,0(sp)
  12:	0080                	add	s0,sp,64
    const int barWidth = 50;
    int percentage = (t * 100) / MAXFILE;
  14:	06400b13          	li	s6,100
  18:	02ab0b3b          	mulw	s6,s6,a0
  1c:	67c1                	lui	a5,0x10
  1e:	10b78793          	add	a5,a5,267 # 1010b <base+0xf0fb>
  22:	02fb5b33          	divu	s6,s6,a5
  26:	2b01                	sext.w	s6,s6
    int barLength = (t * barWidth) / MAXFILE;
  28:	03200913          	li	s2,50
  2c:	02a9093b          	mulw	s2,s2,a0
  30:	02f95933          	divu	s2,s2,a5
  34:	2901                	sext.w	s2,s2

    printf("[");
  36:	00001517          	auipc	a0,0x1
  3a:	9aa50513          	add	a0,a0,-1622 # 9e0 <malloc+0xf2>
  3e:	00000097          	auipc	ra,0x0
  42:	7f8080e7          	jalr	2040(ra) # 836 <printf>
    for (int i = 0; i < barWidth; ++i) {
  46:	4481                	li	s1,0
        if (i < barLength)
            printf("=");
        else
            printf(" ");
  48:	00001a97          	auipc	s5,0x1
  4c:	9a8a8a93          	add	s5,s5,-1624 # 9f0 <malloc+0x102>
            printf("=");
  50:	00001a17          	auipc	s4,0x1
  54:	998a0a13          	add	s4,s4,-1640 # 9e8 <malloc+0xfa>
    for (int i = 0; i < barWidth; ++i) {
  58:	03200993          	li	s3,50
  5c:	a809                	j	6e <printProgressBar+0x6e>
            printf(" ");
  5e:	8556                	mv	a0,s5
  60:	00000097          	auipc	ra,0x0
  64:	7d6080e7          	jalr	2006(ra) # 836 <printf>
    for (int i = 0; i < barWidth; ++i) {
  68:	2485                	addw	s1,s1,1
  6a:	01348a63          	beq	s1,s3,7e <printProgressBar+0x7e>
        if (i < barLength)
  6e:	ff24d8e3          	bge	s1,s2,5e <printProgressBar+0x5e>
            printf("=");
  72:	8552                	mv	a0,s4
  74:	00000097          	auipc	ra,0x0
  78:	7c2080e7          	jalr	1986(ra) # 836 <printf>
  7c:	b7f5                	j	68 <printProgressBar+0x68>
    }
    printf("] %d%%\r", percentage);
  7e:	85da                	mv	a1,s6
  80:	00001517          	auipc	a0,0x1
  84:	97850513          	add	a0,a0,-1672 # 9f8 <malloc+0x10a>
  88:	00000097          	auipc	ra,0x0
  8c:	7ae080e7          	jalr	1966(ra) # 836 <printf>
    
}
  90:	70e2                	ld	ra,56(sp)
  92:	7442                	ld	s0,48(sp)
  94:	74a2                	ld	s1,40(sp)
  96:	7902                	ld	s2,32(sp)
  98:	69e2                	ld	s3,24(sp)
  9a:	6a42                	ld	s4,16(sp)
  9c:	6aa2                	ld	s5,8(sp)
  9e:	6b02                	ld	s6,0(sp)
  a0:	6121                	add	sp,sp,64
  a2:	8082                	ret

00000000000000a4 <main>:


int main(int argc, char **argv)
{
  a4:	dc010113          	add	sp,sp,-576
  a8:	22113c23          	sd	ra,568(sp)
  ac:	22813823          	sd	s0,560(sp)
  b0:	22913423          	sd	s1,552(sp)
  b4:	23213023          	sd	s2,544(sp)
  b8:	21313c23          	sd	s3,536(sp)
  bc:	21413823          	sd	s4,528(sp)
  c0:	21513423          	sd	s5,520(sp)
  c4:	21613023          	sd	s6,512(sp)
  c8:	0480                	add	s0,sp,576
  char buf[512];
  int fd, i, t;
  printf("\nMAXFILE: %d\n",MAXFILE);
  ca:	65c1                	lui	a1,0x10
  cc:	10b58593          	add	a1,a1,267 # 1010b <base+0xf0fb>
  d0:	00001517          	auipc	a0,0x1
  d4:	93050513          	add	a0,a0,-1744 # a00 <malloc+0x112>
  d8:	00000097          	auipc	ra,0x0
  dc:	75e080e7          	jalr	1886(ra) # 836 <printf>
  fd = open("max.file", O_CREATE | O_WRONLY);
  e0:	20100593          	li	a1,513
  e4:	00001517          	auipc	a0,0x1
  e8:	92c50513          	add	a0,a0,-1748 # a10 <malloc+0x122>
  ec:	00000097          	auipc	ra,0x0
  f0:	422080e7          	jalr	1058(ra) # 50e <open>
  if(fd < 0){
  f4:	00054c63          	bltz	a0,10c <main+0x68>
  f8:	89aa                	mv	s3,a0
  fa:	4485                	li	s1,1
    if(cc <= 0)
      break;
    t++;

   
  if (t % (MAXFILE / 100) == 0 || t == MAXFILE) {
  fc:	29200a93          	li	s5,658
 100:	6a41                	lui	s4,0x10
 102:	10ba0b13          	add	s6,s4,267 # 1010b <base+0xf0fb>
  while(t<MAXFILE){
 106:	10ca0a13          	add	s4,s4,268
 10a:	a015                	j	12e <main+0x8a>
    printf("max: cannot open max.file for writing\n");
 10c:	00001517          	auipc	a0,0x1
 110:	91450513          	add	a0,a0,-1772 # a20 <malloc+0x132>
 114:	00000097          	auipc	ra,0x0
 118:	722080e7          	jalr	1826(ra) # 836 <printf>
   return 0;
 11c:	a0c5                	j	1fc <main+0x158>
            printProgressBar(t);
 11e:	854a                	mv	a0,s2
 120:	00000097          	auipc	ra,0x0
 124:	ee0080e7          	jalr	-288(ra) # 0 <printProgressBar>
  while(t<MAXFILE){
 128:	0485                	add	s1,s1,1
 12a:	03448b63          	beq	s1,s4,160 <main+0xbc>
 12e:	fff4879b          	addw	a5,s1,-1
 132:	0007891b          	sext.w	s2,a5
    *(int*)buf = t;
 136:	dcf42023          	sw	a5,-576(s0)
    int cc = write(fd, buf, sizeof(buf));
 13a:	20000613          	li	a2,512
 13e:	dc040593          	add	a1,s0,-576
 142:	854e                	mv	a0,s3
 144:	00000097          	auipc	ra,0x0
 148:	39a080e7          	jalr	922(ra) # 4de <write>
    if(cc <= 0)
 14c:	00a05a63          	blez	a0,160 <main+0xbc>
    t++;
 150:	0004891b          	sext.w	s2,s1
  if (t % (MAXFILE / 100) == 0 || t == MAXFILE) {
 154:	0354f7b3          	remu	a5,s1,s5
 158:	d3f9                	beqz	a5,11e <main+0x7a>
 15a:	fd6917e3          	bne	s2,s6,128 <main+0x84>
 15e:	b7c1                	j	11e <main+0x7a>
        }
  
  }

  printf("\nwrote: %d \n\n", t);
 160:	85ca                	mv	a1,s2
 162:	00001517          	auipc	a0,0x1
 166:	8e650513          	add	a0,a0,-1818 # a48 <malloc+0x15a>
 16a:	00000097          	auipc	ra,0x0
 16e:	6cc080e7          	jalr	1740(ra) # 836 <printf>

  close(fd);
 172:	854e                	mv	a0,s3
 174:	00000097          	auipc	ra,0x0
 178:	372080e7          	jalr	882(ra) # 4e6 <close>
  fd = open("max.file", O_RDONLY);
 17c:	4581                	li	a1,0
 17e:	00001517          	auipc	a0,0x1
 182:	89250513          	add	a0,a0,-1902 # a10 <malloc+0x122>
 186:	00000097          	auipc	ra,0x0
 18a:	388080e7          	jalr	904(ra) # 50e <open>
 18e:	89aa                	mv	s3,a0
  if(fd < 0){
 190:	04054463          	bltz	a0,1d8 <main+0x134>
    printf("maxfile: cannot re-open max.file for reading\n");
     return 0;
  }
  for(i = 0; i < t; i++){
 194:	4481                	li	s1,0
 196:	03205463          	blez	s2,1be <main+0x11a>
    int cc = read(fd, buf, sizeof(buf));
 19a:	20000613          	li	a2,512
 19e:	dc040593          	add	a1,s0,-576
 1a2:	854e                	mv	a0,s3
 1a4:	00000097          	auipc	ra,0x0
 1a8:	332080e7          	jalr	818(ra) # 4d6 <read>
    if(cc <= 0){
 1ac:	02a05f63          	blez	a0,1ea <main+0x146>
      printf("maxfile: read error at sector %d\n", i);
      return 0;
    }
    if(*(int*)buf != i){
 1b0:	dc042583          	lw	a1,-576(s0)
 1b4:	06959863          	bne	a1,s1,224 <main+0x180>
  for(i = 0; i < t; i++){
 1b8:	2485                	addw	s1,s1,1
 1ba:	ff2490e3          	bne	s1,s2,19a <main+0xf6>
             *(int*)buf, i);
       return 0;
    }

  }
  unlink("max.file");
 1be:	00001517          	auipc	a0,0x1
 1c2:	85250513          	add	a0,a0,-1966 # a10 <malloc+0x122>
 1c6:	00000097          	auipc	ra,0x0
 1ca:	358080e7          	jalr	856(ra) # 51e <unlink>
  exit(1);
 1ce:	4505                	li	a0,1
 1d0:	00000097          	auipc	ra,0x0
 1d4:	2ee080e7          	jalr	750(ra) # 4be <exit>
    printf("maxfile: cannot re-open max.file for reading\n");
 1d8:	00001517          	auipc	a0,0x1
 1dc:	88050513          	add	a0,a0,-1920 # a58 <malloc+0x16a>
 1e0:	00000097          	auipc	ra,0x0
 1e4:	656080e7          	jalr	1622(ra) # 836 <printf>
     return 0;
 1e8:	a811                	j	1fc <main+0x158>
      printf("maxfile: read error at sector %d\n", i);
 1ea:	85a6                	mv	a1,s1
 1ec:	00001517          	auipc	a0,0x1
 1f0:	89c50513          	add	a0,a0,-1892 # a88 <malloc+0x19a>
 1f4:	00000097          	auipc	ra,0x0
 1f8:	642080e7          	jalr	1602(ra) # 836 <printf>
}
 1fc:	4501                	li	a0,0
 1fe:	23813083          	ld	ra,568(sp)
 202:	23013403          	ld	s0,560(sp)
 206:	22813483          	ld	s1,552(sp)
 20a:	22013903          	ld	s2,544(sp)
 20e:	21813983          	ld	s3,536(sp)
 212:	21013a03          	ld	s4,528(sp)
 216:	20813a83          	ld	s5,520(sp)
 21a:	20013b03          	ld	s6,512(sp)
 21e:	24010113          	add	sp,sp,576
 222:	8082                	ret
      printf("maxfile: read the wrong data (%d) for sector %d\n",
 224:	8626                	mv	a2,s1
 226:	00001517          	auipc	a0,0x1
 22a:	88a50513          	add	a0,a0,-1910 # ab0 <malloc+0x1c2>
 22e:	00000097          	auipc	ra,0x0
 232:	608080e7          	jalr	1544(ra) # 836 <printf>
       return 0;
 236:	b7d9                	j	1fc <main+0x158>

0000000000000238 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 238:	1141                	add	sp,sp,-16
 23a:	e406                	sd	ra,8(sp)
 23c:	e022                	sd	s0,0(sp)
 23e:	0800                	add	s0,sp,16
  extern int main();
  main();
 240:	00000097          	auipc	ra,0x0
 244:	e64080e7          	jalr	-412(ra) # a4 <main>
  exit(0);
 248:	4501                	li	a0,0
 24a:	00000097          	auipc	ra,0x0
 24e:	274080e7          	jalr	628(ra) # 4be <exit>

0000000000000252 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 252:	1141                	add	sp,sp,-16
 254:	e422                	sd	s0,8(sp)
 256:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 258:	87aa                	mv	a5,a0
 25a:	0585                	add	a1,a1,1
 25c:	0785                	add	a5,a5,1
 25e:	fff5c703          	lbu	a4,-1(a1)
 262:	fee78fa3          	sb	a4,-1(a5)
 266:	fb75                	bnez	a4,25a <strcpy+0x8>
    ;
  return os;
}
 268:	6422                	ld	s0,8(sp)
 26a:	0141                	add	sp,sp,16
 26c:	8082                	ret

000000000000026e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 26e:	1141                	add	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 274:	00054783          	lbu	a5,0(a0)
 278:	cb91                	beqz	a5,28c <strcmp+0x1e>
 27a:	0005c703          	lbu	a4,0(a1)
 27e:	00f71763          	bne	a4,a5,28c <strcmp+0x1e>
    p++, q++;
 282:	0505                	add	a0,a0,1
 284:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 286:	00054783          	lbu	a5,0(a0)
 28a:	fbe5                	bnez	a5,27a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 28c:	0005c503          	lbu	a0,0(a1)
}
 290:	40a7853b          	subw	a0,a5,a0
 294:	6422                	ld	s0,8(sp)
 296:	0141                	add	sp,sp,16
 298:	8082                	ret

000000000000029a <strlen>:

uint
strlen(const char *s)
{
 29a:	1141                	add	sp,sp,-16
 29c:	e422                	sd	s0,8(sp)
 29e:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	cf91                	beqz	a5,2c0 <strlen+0x26>
 2a6:	0505                	add	a0,a0,1
 2a8:	87aa                	mv	a5,a0
 2aa:	86be                	mv	a3,a5
 2ac:	0785                	add	a5,a5,1
 2ae:	fff7c703          	lbu	a4,-1(a5)
 2b2:	ff65                	bnez	a4,2aa <strlen+0x10>
 2b4:	40a6853b          	subw	a0,a3,a0
 2b8:	2505                	addw	a0,a0,1
    ;
  return n;
}
 2ba:	6422                	ld	s0,8(sp)
 2bc:	0141                	add	sp,sp,16
 2be:	8082                	ret
  for(n = 0; s[n]; n++)
 2c0:	4501                	li	a0,0
 2c2:	bfe5                	j	2ba <strlen+0x20>

00000000000002c4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2c4:	1141                	add	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ca:	ca19                	beqz	a2,2e0 <memset+0x1c>
 2cc:	87aa                	mv	a5,a0
 2ce:	1602                	sll	a2,a2,0x20
 2d0:	9201                	srl	a2,a2,0x20
 2d2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2da:	0785                	add	a5,a5,1
 2dc:	fee79de3          	bne	a5,a4,2d6 <memset+0x12>
  }
  return dst;
}
 2e0:	6422                	ld	s0,8(sp)
 2e2:	0141                	add	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <strchr>:

char*
strchr(const char *s, char c)
{
 2e6:	1141                	add	sp,sp,-16
 2e8:	e422                	sd	s0,8(sp)
 2ea:	0800                	add	s0,sp,16
  for(; *s; s++)
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	cb99                	beqz	a5,306 <strchr+0x20>
    if(*s == c)
 2f2:	00f58763          	beq	a1,a5,300 <strchr+0x1a>
  for(; *s; s++)
 2f6:	0505                	add	a0,a0,1
 2f8:	00054783          	lbu	a5,0(a0)
 2fc:	fbfd                	bnez	a5,2f2 <strchr+0xc>
      return (char*)s;
  return 0;
 2fe:	4501                	li	a0,0
}
 300:	6422                	ld	s0,8(sp)
 302:	0141                	add	sp,sp,16
 304:	8082                	ret
  return 0;
 306:	4501                	li	a0,0
 308:	bfe5                	j	300 <strchr+0x1a>

000000000000030a <gets>:

char*
gets(char *buf, int max)
{
 30a:	711d                	add	sp,sp,-96
 30c:	ec86                	sd	ra,88(sp)
 30e:	e8a2                	sd	s0,80(sp)
 310:	e4a6                	sd	s1,72(sp)
 312:	e0ca                	sd	s2,64(sp)
 314:	fc4e                	sd	s3,56(sp)
 316:	f852                	sd	s4,48(sp)
 318:	f456                	sd	s5,40(sp)
 31a:	f05a                	sd	s6,32(sp)
 31c:	ec5e                	sd	s7,24(sp)
 31e:	1080                	add	s0,sp,96
 320:	8baa                	mv	s7,a0
 322:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 324:	892a                	mv	s2,a0
 326:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 328:	4aa9                	li	s5,10
 32a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 32c:	89a6                	mv	s3,s1
 32e:	2485                	addw	s1,s1,1
 330:	0344d863          	bge	s1,s4,360 <gets+0x56>
    cc = read(0, &c, 1);
 334:	4605                	li	a2,1
 336:	faf40593          	add	a1,s0,-81
 33a:	4501                	li	a0,0
 33c:	00000097          	auipc	ra,0x0
 340:	19a080e7          	jalr	410(ra) # 4d6 <read>
    if(cc < 1)
 344:	00a05e63          	blez	a0,360 <gets+0x56>
    buf[i++] = c;
 348:	faf44783          	lbu	a5,-81(s0)
 34c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 350:	01578763          	beq	a5,s5,35e <gets+0x54>
 354:	0905                	add	s2,s2,1
 356:	fd679be3          	bne	a5,s6,32c <gets+0x22>
  for(i=0; i+1 < max; ){
 35a:	89a6                	mv	s3,s1
 35c:	a011                	j	360 <gets+0x56>
 35e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 360:	99de                	add	s3,s3,s7
 362:	00098023          	sb	zero,0(s3)
  return buf;
}
 366:	855e                	mv	a0,s7
 368:	60e6                	ld	ra,88(sp)
 36a:	6446                	ld	s0,80(sp)
 36c:	64a6                	ld	s1,72(sp)
 36e:	6906                	ld	s2,64(sp)
 370:	79e2                	ld	s3,56(sp)
 372:	7a42                	ld	s4,48(sp)
 374:	7aa2                	ld	s5,40(sp)
 376:	7b02                	ld	s6,32(sp)
 378:	6be2                	ld	s7,24(sp)
 37a:	6125                	add	sp,sp,96
 37c:	8082                	ret

000000000000037e <stat>:

int
stat(const char *n, struct stat *st)
{
 37e:	1101                	add	sp,sp,-32
 380:	ec06                	sd	ra,24(sp)
 382:	e822                	sd	s0,16(sp)
 384:	e426                	sd	s1,8(sp)
 386:	e04a                	sd	s2,0(sp)
 388:	1000                	add	s0,sp,32
 38a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 38c:	4581                	li	a1,0
 38e:	00000097          	auipc	ra,0x0
 392:	180080e7          	jalr	384(ra) # 50e <open>
  if(fd < 0)
 396:	02054563          	bltz	a0,3c0 <stat+0x42>
 39a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 39c:	85ca                	mv	a1,s2
 39e:	00000097          	auipc	ra,0x0
 3a2:	188080e7          	jalr	392(ra) # 526 <fstat>
 3a6:	892a                	mv	s2,a0
  close(fd);
 3a8:	8526                	mv	a0,s1
 3aa:	00000097          	auipc	ra,0x0
 3ae:	13c080e7          	jalr	316(ra) # 4e6 <close>
  return r;
}
 3b2:	854a                	mv	a0,s2
 3b4:	60e2                	ld	ra,24(sp)
 3b6:	6442                	ld	s0,16(sp)
 3b8:	64a2                	ld	s1,8(sp)
 3ba:	6902                	ld	s2,0(sp)
 3bc:	6105                	add	sp,sp,32
 3be:	8082                	ret
    return -1;
 3c0:	597d                	li	s2,-1
 3c2:	bfc5                	j	3b2 <stat+0x34>

00000000000003c4 <atoi>:

int
atoi(const char *s)
{
 3c4:	1141                	add	sp,sp,-16
 3c6:	e422                	sd	s0,8(sp)
 3c8:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ca:	00054683          	lbu	a3,0(a0)
 3ce:	fd06879b          	addw	a5,a3,-48
 3d2:	0ff7f793          	zext.b	a5,a5
 3d6:	4625                	li	a2,9
 3d8:	02f66863          	bltu	a2,a5,408 <atoi+0x44>
 3dc:	872a                	mv	a4,a0
  n = 0;
 3de:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3e0:	0705                	add	a4,a4,1
 3e2:	0025179b          	sllw	a5,a0,0x2
 3e6:	9fa9                	addw	a5,a5,a0
 3e8:	0017979b          	sllw	a5,a5,0x1
 3ec:	9fb5                	addw	a5,a5,a3
 3ee:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3f2:	00074683          	lbu	a3,0(a4)
 3f6:	fd06879b          	addw	a5,a3,-48
 3fa:	0ff7f793          	zext.b	a5,a5
 3fe:	fef671e3          	bgeu	a2,a5,3e0 <atoi+0x1c>
  return n;
}
 402:	6422                	ld	s0,8(sp)
 404:	0141                	add	sp,sp,16
 406:	8082                	ret
  n = 0;
 408:	4501                	li	a0,0
 40a:	bfe5                	j	402 <atoi+0x3e>

000000000000040c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 40c:	1141                	add	sp,sp,-16
 40e:	e422                	sd	s0,8(sp)
 410:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 412:	02b57463          	bgeu	a0,a1,43a <memmove+0x2e>
    while(n-- > 0)
 416:	00c05f63          	blez	a2,434 <memmove+0x28>
 41a:	1602                	sll	a2,a2,0x20
 41c:	9201                	srl	a2,a2,0x20
 41e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 422:	872a                	mv	a4,a0
      *dst++ = *src++;
 424:	0585                	add	a1,a1,1
 426:	0705                	add	a4,a4,1
 428:	fff5c683          	lbu	a3,-1(a1)
 42c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 430:	fee79ae3          	bne	a5,a4,424 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 434:	6422                	ld	s0,8(sp)
 436:	0141                	add	sp,sp,16
 438:	8082                	ret
    dst += n;
 43a:	00c50733          	add	a4,a0,a2
    src += n;
 43e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 440:	fec05ae3          	blez	a2,434 <memmove+0x28>
 444:	fff6079b          	addw	a5,a2,-1
 448:	1782                	sll	a5,a5,0x20
 44a:	9381                	srl	a5,a5,0x20
 44c:	fff7c793          	not	a5,a5
 450:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 452:	15fd                	add	a1,a1,-1
 454:	177d                	add	a4,a4,-1
 456:	0005c683          	lbu	a3,0(a1)
 45a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 45e:	fee79ae3          	bne	a5,a4,452 <memmove+0x46>
 462:	bfc9                	j	434 <memmove+0x28>

0000000000000464 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 464:	1141                	add	sp,sp,-16
 466:	e422                	sd	s0,8(sp)
 468:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 46a:	ca05                	beqz	a2,49a <memcmp+0x36>
 46c:	fff6069b          	addw	a3,a2,-1
 470:	1682                	sll	a3,a3,0x20
 472:	9281                	srl	a3,a3,0x20
 474:	0685                	add	a3,a3,1
 476:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 478:	00054783          	lbu	a5,0(a0)
 47c:	0005c703          	lbu	a4,0(a1)
 480:	00e79863          	bne	a5,a4,490 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 484:	0505                	add	a0,a0,1
    p2++;
 486:	0585                	add	a1,a1,1
  while (n-- > 0) {
 488:	fed518e3          	bne	a0,a3,478 <memcmp+0x14>
  }
  return 0;
 48c:	4501                	li	a0,0
 48e:	a019                	j	494 <memcmp+0x30>
      return *p1 - *p2;
 490:	40e7853b          	subw	a0,a5,a4
}
 494:	6422                	ld	s0,8(sp)
 496:	0141                	add	sp,sp,16
 498:	8082                	ret
  return 0;
 49a:	4501                	li	a0,0
 49c:	bfe5                	j	494 <memcmp+0x30>

000000000000049e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 49e:	1141                	add	sp,sp,-16
 4a0:	e406                	sd	ra,8(sp)
 4a2:	e022                	sd	s0,0(sp)
 4a4:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 4a6:	00000097          	auipc	ra,0x0
 4aa:	f66080e7          	jalr	-154(ra) # 40c <memmove>
}
 4ae:	60a2                	ld	ra,8(sp)
 4b0:	6402                	ld	s0,0(sp)
 4b2:	0141                	add	sp,sp,16
 4b4:	8082                	ret

00000000000004b6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4b6:	4885                	li	a7,1
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <exit>:
.global exit
exit:
 li a7, SYS_exit
 4be:	4889                	li	a7,2
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4c6:	488d                	li	a7,3
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4ce:	4891                	li	a7,4
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <read>:
.global read
read:
 li a7, SYS_read
 4d6:	4895                	li	a7,5
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <write>:
.global write
write:
 li a7, SYS_write
 4de:	48c1                	li	a7,16
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <close>:
.global close
close:
 li a7, SYS_close
 4e6:	48d5                	li	a7,21
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <kill>:
.global kill
kill:
 li a7, SYS_kill
 4ee:	4899                	li	a7,6
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <procs>:
.global procs
procs:
 li a7, SYS_procs
 4f6:	48d9                	li	a7,22
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <writebigfile>:
.global writebigfile
writebigfile:
 li a7, SYS_writebigfile
 4fe:	48dd                	li	a7,23
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <exec>:
.global exec
exec:
 li a7, SYS_exec
 506:	489d                	li	a7,7
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <open>:
.global open
open:
 li a7, SYS_open
 50e:	48bd                	li	a7,15
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 516:	48c5                	li	a7,17
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 51e:	48c9                	li	a7,18
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 526:	48a1                	li	a7,8
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <link>:
.global link
link:
 li a7, SYS_link
 52e:	48cd                	li	a7,19
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 536:	48d1                	li	a7,20
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 53e:	48a5                	li	a7,9
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <dup>:
.global dup
dup:
 li a7, SYS_dup
 546:	48a9                	li	a7,10
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 54e:	48ad                	li	a7,11
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 556:	48b1                	li	a7,12
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 55e:	48b5                	li	a7,13
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 566:	48b9                	li	a7,14
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 56e:	1101                	add	sp,sp,-32
 570:	ec06                	sd	ra,24(sp)
 572:	e822                	sd	s0,16(sp)
 574:	1000                	add	s0,sp,32
 576:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 57a:	4605                	li	a2,1
 57c:	fef40593          	add	a1,s0,-17
 580:	00000097          	auipc	ra,0x0
 584:	f5e080e7          	jalr	-162(ra) # 4de <write>
}
 588:	60e2                	ld	ra,24(sp)
 58a:	6442                	ld	s0,16(sp)
 58c:	6105                	add	sp,sp,32
 58e:	8082                	ret

0000000000000590 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 590:	7139                	add	sp,sp,-64
 592:	fc06                	sd	ra,56(sp)
 594:	f822                	sd	s0,48(sp)
 596:	f426                	sd	s1,40(sp)
 598:	f04a                	sd	s2,32(sp)
 59a:	ec4e                	sd	s3,24(sp)
 59c:	0080                	add	s0,sp,64
 59e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5a0:	c299                	beqz	a3,5a6 <printint+0x16>
 5a2:	0805c963          	bltz	a1,634 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5a6:	2581                	sext.w	a1,a1
  neg = 0;
 5a8:	4881                	li	a7,0
 5aa:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 5ae:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5b0:	2601                	sext.w	a2,a2
 5b2:	00000517          	auipc	a0,0x0
 5b6:	59650513          	add	a0,a0,1430 # b48 <digits>
 5ba:	883a                	mv	a6,a4
 5bc:	2705                	addw	a4,a4,1
 5be:	02c5f7bb          	remuw	a5,a1,a2
 5c2:	1782                	sll	a5,a5,0x20
 5c4:	9381                	srl	a5,a5,0x20
 5c6:	97aa                	add	a5,a5,a0
 5c8:	0007c783          	lbu	a5,0(a5)
 5cc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5d0:	0005879b          	sext.w	a5,a1
 5d4:	02c5d5bb          	divuw	a1,a1,a2
 5d8:	0685                	add	a3,a3,1
 5da:	fec7f0e3          	bgeu	a5,a2,5ba <printint+0x2a>
  if(neg)
 5de:	00088c63          	beqz	a7,5f6 <printint+0x66>
    buf[i++] = '-';
 5e2:	fd070793          	add	a5,a4,-48
 5e6:	00878733          	add	a4,a5,s0
 5ea:	02d00793          	li	a5,45
 5ee:	fef70823          	sb	a5,-16(a4)
 5f2:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 5f6:	02e05863          	blez	a4,626 <printint+0x96>
 5fa:	fc040793          	add	a5,s0,-64
 5fe:	00e78933          	add	s2,a5,a4
 602:	fff78993          	add	s3,a5,-1
 606:	99ba                	add	s3,s3,a4
 608:	377d                	addw	a4,a4,-1
 60a:	1702                	sll	a4,a4,0x20
 60c:	9301                	srl	a4,a4,0x20
 60e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 612:	fff94583          	lbu	a1,-1(s2)
 616:	8526                	mv	a0,s1
 618:	00000097          	auipc	ra,0x0
 61c:	f56080e7          	jalr	-170(ra) # 56e <putc>
  while(--i >= 0)
 620:	197d                	add	s2,s2,-1
 622:	ff3918e3          	bne	s2,s3,612 <printint+0x82>
}
 626:	70e2                	ld	ra,56(sp)
 628:	7442                	ld	s0,48(sp)
 62a:	74a2                	ld	s1,40(sp)
 62c:	7902                	ld	s2,32(sp)
 62e:	69e2                	ld	s3,24(sp)
 630:	6121                	add	sp,sp,64
 632:	8082                	ret
    x = -xx;
 634:	40b005bb          	negw	a1,a1
    neg = 1;
 638:	4885                	li	a7,1
    x = -xx;
 63a:	bf85                	j	5aa <printint+0x1a>

000000000000063c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 63c:	715d                	add	sp,sp,-80
 63e:	e486                	sd	ra,72(sp)
 640:	e0a2                	sd	s0,64(sp)
 642:	fc26                	sd	s1,56(sp)
 644:	f84a                	sd	s2,48(sp)
 646:	f44e                	sd	s3,40(sp)
 648:	f052                	sd	s4,32(sp)
 64a:	ec56                	sd	s5,24(sp)
 64c:	e85a                	sd	s6,16(sp)
 64e:	e45e                	sd	s7,8(sp)
 650:	e062                	sd	s8,0(sp)
 652:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 654:	0005c903          	lbu	s2,0(a1)
 658:	18090c63          	beqz	s2,7f0 <vprintf+0x1b4>
 65c:	8aaa                	mv	s5,a0
 65e:	8bb2                	mv	s7,a2
 660:	00158493          	add	s1,a1,1
  state = 0;
 664:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 666:	02500a13          	li	s4,37
 66a:	4b55                	li	s6,21
 66c:	a839                	j	68a <vprintf+0x4e>
        putc(fd, c);
 66e:	85ca                	mv	a1,s2
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	efc080e7          	jalr	-260(ra) # 56e <putc>
 67a:	a019                	j	680 <vprintf+0x44>
    } else if(state == '%'){
 67c:	01498d63          	beq	s3,s4,696 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 680:	0485                	add	s1,s1,1
 682:	fff4c903          	lbu	s2,-1(s1)
 686:	16090563          	beqz	s2,7f0 <vprintf+0x1b4>
    if(state == 0){
 68a:	fe0999e3          	bnez	s3,67c <vprintf+0x40>
      if(c == '%'){
 68e:	ff4910e3          	bne	s2,s4,66e <vprintf+0x32>
        state = '%';
 692:	89d2                	mv	s3,s4
 694:	b7f5                	j	680 <vprintf+0x44>
      if(c == 'd'){
 696:	13490263          	beq	s2,s4,7ba <vprintf+0x17e>
 69a:	f9d9079b          	addw	a5,s2,-99
 69e:	0ff7f793          	zext.b	a5,a5
 6a2:	12fb6563          	bltu	s6,a5,7cc <vprintf+0x190>
 6a6:	f9d9079b          	addw	a5,s2,-99
 6aa:	0ff7f713          	zext.b	a4,a5
 6ae:	10eb6f63          	bltu	s6,a4,7cc <vprintf+0x190>
 6b2:	00271793          	sll	a5,a4,0x2
 6b6:	00000717          	auipc	a4,0x0
 6ba:	43a70713          	add	a4,a4,1082 # af0 <malloc+0x202>
 6be:	97ba                	add	a5,a5,a4
 6c0:	439c                	lw	a5,0(a5)
 6c2:	97ba                	add	a5,a5,a4
 6c4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6c6:	008b8913          	add	s2,s7,8
 6ca:	4685                	li	a3,1
 6cc:	4629                	li	a2,10
 6ce:	000ba583          	lw	a1,0(s7)
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	ebc080e7          	jalr	-324(ra) # 590 <printint>
 6dc:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	b745                	j	680 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e2:	008b8913          	add	s2,s7,8
 6e6:	4681                	li	a3,0
 6e8:	4629                	li	a2,10
 6ea:	000ba583          	lw	a1,0(s7)
 6ee:	8556                	mv	a0,s5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	ea0080e7          	jalr	-352(ra) # 590 <printint>
 6f8:	8bca                	mv	s7,s2
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	b751                	j	680 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 6fe:	008b8913          	add	s2,s7,8
 702:	4681                	li	a3,0
 704:	4641                	li	a2,16
 706:	000ba583          	lw	a1,0(s7)
 70a:	8556                	mv	a0,s5
 70c:	00000097          	auipc	ra,0x0
 710:	e84080e7          	jalr	-380(ra) # 590 <printint>
 714:	8bca                	mv	s7,s2
      state = 0;
 716:	4981                	li	s3,0
 718:	b7a5                	j	680 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 71a:	008b8c13          	add	s8,s7,8
 71e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 722:	03000593          	li	a1,48
 726:	8556                	mv	a0,s5
 728:	00000097          	auipc	ra,0x0
 72c:	e46080e7          	jalr	-442(ra) # 56e <putc>
  putc(fd, 'x');
 730:	07800593          	li	a1,120
 734:	8556                	mv	a0,s5
 736:	00000097          	auipc	ra,0x0
 73a:	e38080e7          	jalr	-456(ra) # 56e <putc>
 73e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 740:	00000b97          	auipc	s7,0x0
 744:	408b8b93          	add	s7,s7,1032 # b48 <digits>
 748:	03c9d793          	srl	a5,s3,0x3c
 74c:	97de                	add	a5,a5,s7
 74e:	0007c583          	lbu	a1,0(a5)
 752:	8556                	mv	a0,s5
 754:	00000097          	auipc	ra,0x0
 758:	e1a080e7          	jalr	-486(ra) # 56e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 75c:	0992                	sll	s3,s3,0x4
 75e:	397d                	addw	s2,s2,-1
 760:	fe0914e3          	bnez	s2,748 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 764:	8be2                	mv	s7,s8
      state = 0;
 766:	4981                	li	s3,0
 768:	bf21                	j	680 <vprintf+0x44>
        s = va_arg(ap, char*);
 76a:	008b8993          	add	s3,s7,8
 76e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 772:	02090163          	beqz	s2,794 <vprintf+0x158>
        while(*s != 0){
 776:	00094583          	lbu	a1,0(s2)
 77a:	c9a5                	beqz	a1,7ea <vprintf+0x1ae>
          putc(fd, *s);
 77c:	8556                	mv	a0,s5
 77e:	00000097          	auipc	ra,0x0
 782:	df0080e7          	jalr	-528(ra) # 56e <putc>
          s++;
 786:	0905                	add	s2,s2,1
        while(*s != 0){
 788:	00094583          	lbu	a1,0(s2)
 78c:	f9e5                	bnez	a1,77c <vprintf+0x140>
        s = va_arg(ap, char*);
 78e:	8bce                	mv	s7,s3
      state = 0;
 790:	4981                	li	s3,0
 792:	b5fd                	j	680 <vprintf+0x44>
          s = "(null)";
 794:	00000917          	auipc	s2,0x0
 798:	35490913          	add	s2,s2,852 # ae8 <malloc+0x1fa>
        while(*s != 0){
 79c:	02800593          	li	a1,40
 7a0:	bff1                	j	77c <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 7a2:	008b8913          	add	s2,s7,8
 7a6:	000bc583          	lbu	a1,0(s7)
 7aa:	8556                	mv	a0,s5
 7ac:	00000097          	auipc	ra,0x0
 7b0:	dc2080e7          	jalr	-574(ra) # 56e <putc>
 7b4:	8bca                	mv	s7,s2
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	b5e1                	j	680 <vprintf+0x44>
        putc(fd, c);
 7ba:	02500593          	li	a1,37
 7be:	8556                	mv	a0,s5
 7c0:	00000097          	auipc	ra,0x0
 7c4:	dae080e7          	jalr	-594(ra) # 56e <putc>
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	bd5d                	j	680 <vprintf+0x44>
        putc(fd, '%');
 7cc:	02500593          	li	a1,37
 7d0:	8556                	mv	a0,s5
 7d2:	00000097          	auipc	ra,0x0
 7d6:	d9c080e7          	jalr	-612(ra) # 56e <putc>
        putc(fd, c);
 7da:	85ca                	mv	a1,s2
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	d90080e7          	jalr	-624(ra) # 56e <putc>
      state = 0;
 7e6:	4981                	li	s3,0
 7e8:	bd61                	j	680 <vprintf+0x44>
        s = va_arg(ap, char*);
 7ea:	8bce                	mv	s7,s3
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	bd49                	j	680 <vprintf+0x44>
    }
  }
}
 7f0:	60a6                	ld	ra,72(sp)
 7f2:	6406                	ld	s0,64(sp)
 7f4:	74e2                	ld	s1,56(sp)
 7f6:	7942                	ld	s2,48(sp)
 7f8:	79a2                	ld	s3,40(sp)
 7fa:	7a02                	ld	s4,32(sp)
 7fc:	6ae2                	ld	s5,24(sp)
 7fe:	6b42                	ld	s6,16(sp)
 800:	6ba2                	ld	s7,8(sp)
 802:	6c02                	ld	s8,0(sp)
 804:	6161                	add	sp,sp,80
 806:	8082                	ret

0000000000000808 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 808:	715d                	add	sp,sp,-80
 80a:	ec06                	sd	ra,24(sp)
 80c:	e822                	sd	s0,16(sp)
 80e:	1000                	add	s0,sp,32
 810:	e010                	sd	a2,0(s0)
 812:	e414                	sd	a3,8(s0)
 814:	e818                	sd	a4,16(s0)
 816:	ec1c                	sd	a5,24(s0)
 818:	03043023          	sd	a6,32(s0)
 81c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 820:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 824:	8622                	mv	a2,s0
 826:	00000097          	auipc	ra,0x0
 82a:	e16080e7          	jalr	-490(ra) # 63c <vprintf>
}
 82e:	60e2                	ld	ra,24(sp)
 830:	6442                	ld	s0,16(sp)
 832:	6161                	add	sp,sp,80
 834:	8082                	ret

0000000000000836 <printf>:

void
printf(const char *fmt, ...)
{
 836:	711d                	add	sp,sp,-96
 838:	ec06                	sd	ra,24(sp)
 83a:	e822                	sd	s0,16(sp)
 83c:	1000                	add	s0,sp,32
 83e:	e40c                	sd	a1,8(s0)
 840:	e810                	sd	a2,16(s0)
 842:	ec14                	sd	a3,24(s0)
 844:	f018                	sd	a4,32(s0)
 846:	f41c                	sd	a5,40(s0)
 848:	03043823          	sd	a6,48(s0)
 84c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 850:	00840613          	add	a2,s0,8
 854:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 858:	85aa                	mv	a1,a0
 85a:	4505                	li	a0,1
 85c:	00000097          	auipc	ra,0x0
 860:	de0080e7          	jalr	-544(ra) # 63c <vprintf>
}
 864:	60e2                	ld	ra,24(sp)
 866:	6442                	ld	s0,16(sp)
 868:	6125                	add	sp,sp,96
 86a:	8082                	ret

000000000000086c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 86c:	1141                	add	sp,sp,-16
 86e:	e422                	sd	s0,8(sp)
 870:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 872:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 876:	00000797          	auipc	a5,0x0
 87a:	78a7b783          	ld	a5,1930(a5) # 1000 <freep>
 87e:	a02d                	j	8a8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 880:	4618                	lw	a4,8(a2)
 882:	9f2d                	addw	a4,a4,a1
 884:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 888:	6398                	ld	a4,0(a5)
 88a:	6310                	ld	a2,0(a4)
 88c:	a83d                	j	8ca <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 88e:	ff852703          	lw	a4,-8(a0)
 892:	9f31                	addw	a4,a4,a2
 894:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 896:	ff053683          	ld	a3,-16(a0)
 89a:	a091                	j	8de <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89c:	6398                	ld	a4,0(a5)
 89e:	00e7e463          	bltu	a5,a4,8a6 <free+0x3a>
 8a2:	00e6ea63          	bltu	a3,a4,8b6 <free+0x4a>
{
 8a6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a8:	fed7fae3          	bgeu	a5,a3,89c <free+0x30>
 8ac:	6398                	ld	a4,0(a5)
 8ae:	00e6e463          	bltu	a3,a4,8b6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b2:	fee7eae3          	bltu	a5,a4,8a6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8b6:	ff852583          	lw	a1,-8(a0)
 8ba:	6390                	ld	a2,0(a5)
 8bc:	02059813          	sll	a6,a1,0x20
 8c0:	01c85713          	srl	a4,a6,0x1c
 8c4:	9736                	add	a4,a4,a3
 8c6:	fae60de3          	beq	a2,a4,880 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8ca:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8ce:	4790                	lw	a2,8(a5)
 8d0:	02061593          	sll	a1,a2,0x20
 8d4:	01c5d713          	srl	a4,a1,0x1c
 8d8:	973e                	add	a4,a4,a5
 8da:	fae68ae3          	beq	a3,a4,88e <free+0x22>
    p->s.ptr = bp->s.ptr;
 8de:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8e0:	00000717          	auipc	a4,0x0
 8e4:	72f73023          	sd	a5,1824(a4) # 1000 <freep>
}
 8e8:	6422                	ld	s0,8(sp)
 8ea:	0141                	add	sp,sp,16
 8ec:	8082                	ret

00000000000008ee <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ee:	7139                	add	sp,sp,-64
 8f0:	fc06                	sd	ra,56(sp)
 8f2:	f822                	sd	s0,48(sp)
 8f4:	f426                	sd	s1,40(sp)
 8f6:	f04a                	sd	s2,32(sp)
 8f8:	ec4e                	sd	s3,24(sp)
 8fa:	e852                	sd	s4,16(sp)
 8fc:	e456                	sd	s5,8(sp)
 8fe:	e05a                	sd	s6,0(sp)
 900:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 902:	02051493          	sll	s1,a0,0x20
 906:	9081                	srl	s1,s1,0x20
 908:	04bd                	add	s1,s1,15
 90a:	8091                	srl	s1,s1,0x4
 90c:	0014899b          	addw	s3,s1,1
 910:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 912:	00000517          	auipc	a0,0x0
 916:	6ee53503          	ld	a0,1774(a0) # 1000 <freep>
 91a:	c515                	beqz	a0,946 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 91e:	4798                	lw	a4,8(a5)
 920:	02977f63          	bgeu	a4,s1,95e <malloc+0x70>
  if(nu < 4096)
 924:	8a4e                	mv	s4,s3
 926:	0009871b          	sext.w	a4,s3
 92a:	6685                	lui	a3,0x1
 92c:	00d77363          	bgeu	a4,a3,932 <malloc+0x44>
 930:	6a05                	lui	s4,0x1
 932:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 936:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 93a:	00000917          	auipc	s2,0x0
 93e:	6c690913          	add	s2,s2,1734 # 1000 <freep>
  if(p == (char*)-1)
 942:	5afd                	li	s5,-1
 944:	a895                	j	9b8 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 946:	00000797          	auipc	a5,0x0
 94a:	6ca78793          	add	a5,a5,1738 # 1010 <base>
 94e:	00000717          	auipc	a4,0x0
 952:	6af73923          	sd	a5,1714(a4) # 1000 <freep>
 956:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 958:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 95c:	b7e1                	j	924 <malloc+0x36>
      if(p->s.size == nunits)
 95e:	02e48c63          	beq	s1,a4,996 <malloc+0xa8>
        p->s.size -= nunits;
 962:	4137073b          	subw	a4,a4,s3
 966:	c798                	sw	a4,8(a5)
        p += p->s.size;
 968:	02071693          	sll	a3,a4,0x20
 96c:	01c6d713          	srl	a4,a3,0x1c
 970:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 972:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 976:	00000717          	auipc	a4,0x0
 97a:	68a73523          	sd	a0,1674(a4) # 1000 <freep>
      return (void*)(p + 1);
 97e:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 982:	70e2                	ld	ra,56(sp)
 984:	7442                	ld	s0,48(sp)
 986:	74a2                	ld	s1,40(sp)
 988:	7902                	ld	s2,32(sp)
 98a:	69e2                	ld	s3,24(sp)
 98c:	6a42                	ld	s4,16(sp)
 98e:	6aa2                	ld	s5,8(sp)
 990:	6b02                	ld	s6,0(sp)
 992:	6121                	add	sp,sp,64
 994:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 996:	6398                	ld	a4,0(a5)
 998:	e118                	sd	a4,0(a0)
 99a:	bff1                	j	976 <malloc+0x88>
  hp->s.size = nu;
 99c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9a0:	0541                	add	a0,a0,16
 9a2:	00000097          	auipc	ra,0x0
 9a6:	eca080e7          	jalr	-310(ra) # 86c <free>
  return freep;
 9aa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9ae:	d971                	beqz	a0,982 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b2:	4798                	lw	a4,8(a5)
 9b4:	fa9775e3          	bgeu	a4,s1,95e <malloc+0x70>
    if(p == freep)
 9b8:	00093703          	ld	a4,0(s2)
 9bc:	853e                	mv	a0,a5
 9be:	fef719e3          	bne	a4,a5,9b0 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9c2:	8552                	mv	a0,s4
 9c4:	00000097          	auipc	ra,0x0
 9c8:	b92080e7          	jalr	-1134(ra) # 556 <sbrk>
  if(p == (char*)-1)
 9cc:	fd5518e3          	bne	a0,s5,99c <malloc+0xae>
        return 0;
 9d0:	4501                	li	a0,0
 9d2:	bf45                	j	982 <malloc+0x94>
