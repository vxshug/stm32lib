#include "stm32f10x_conf.h"

int main()
{
    //*(unsigned int *)0x40021018 |= (1<<4);
    //*(unsigned int *)0x4001100c &= ~(1<<2);  
    //*(unsigned int *)0x40011000 |= (1<<(4* 2));  
    	/* 开启GPIOA时钟 */
	*(unsigned int*)(0x40021000+0x18) |= 1<<2;
	
	/* 配置PB0为推挽输出 */
        //GPIOA->ODR &= ~(1<<3);
        while(1);
}
