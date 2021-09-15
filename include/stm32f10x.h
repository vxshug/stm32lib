#pragma once

#define AFIO                             0X40010000

#define GPIOA_BASE                       (AFIO+0X0800)
#define GPIOB_BASE                       (AFIO+0X0C00)
#define GPIOC_BASE                       (AFIO+0X1000)
#define GPIOD_BASE                       (AFIO+0X1400)

typedef unsigned int uint32_t;
typedef unsigned short uint16_t;

typedef struct
{
    uint32_t CRL;
    uint32_t CRH;
    uint32_t IDR;
    uint32_t ODR;
    uint32_t BSRR;
    uint32_t BRR;
    uint32_t LCKR;
}GPIO_TypeDef;



#define GPIOA                            ((GPIO_TypeDef *)GPIOA_BASE)
#define GPIOB                            ((GPIO_TypeDef *)GPIOB_BASE)
#define GPIOC                            ((GPIO_TypeDef *)GPIOC_BASE)
#define GPIOD                            ((GPIO_TypeDef *)GPIOD_BASE)
