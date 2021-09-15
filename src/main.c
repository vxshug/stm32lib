#include "stm32f10x.h"
#include "stm32f10x_gpio.h"

int main()
{
    //*(unsigned int *)0x40021018 |= (1<<4);
    //*(unsigned int *)0x4001100c &= ~(1<<2);  
    //*(unsigned int *)0x40011000 |= (1<<(4* 2));  
    	/* 开启GPIOA时钟 */
	*(unsigned int*)(0x40021000+0x18) |= 1<<2;
	
	/* 配置PB0为推挽输出 */
        GPIOA->CRL |= 1<<(4*3);
        GPIOA->CRL |= 1<<(4*2);
        GPIOA->CRL |= 1<<(4*1);
        //GPIOA->ODR &= ~(1<<3);
        GPIO_SetBits(GPIOA, GPIO_Pin_1);
        while(1);
}
void SystemInit(void)
{

}
