int main()
{
    //*(unsigned int *)0x40021018 |= (1<<4);
    //*(unsigned int *)0x4001100c &= ~(1<<2);  
    //*(unsigned int *)0x40011000 |= (1<<(4* 2));  
    	/* 开启GPIOB时钟 */
	*(unsigned int*)(0x40021000+0x18) |= 1<<2;
	
	/* 配置PB0为推挽输出 */
	*(unsigned int*)(0x40010800+0x00) |= 1<<(4*3);
	*(unsigned int*)(0x40010800+0x00) |= 1<<(4*2);
	*(unsigned int*)(0x40010800+0x00) |= 1<<(4*1);
	
	/* PB0输出低电平，点亮绿色LED */
	*(unsigned int*)(0x40010800+0x0c) &= ~(1<<3);
	*(unsigned int*)(0x40010800+0x0c) &= ~(1<<2);
	*(unsigned int*)(0x40010800+0x0c) &= ~(1<<1);
        //熄灭灯
	*(unsigned int*)(0x40010800+0x0c) |= (1<<3);
	*(unsigned int*)(0x40010800+0x0c) |= (1<<2);
	*(unsigned int*)(0x40010800+0x0c) |= (1<<1);
    while(1);
}
void SystemInit(void)
{

}
