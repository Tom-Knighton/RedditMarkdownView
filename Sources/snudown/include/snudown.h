//
//  Header.h
//  
//
//  Created by Tom Knighton on 07/09/2023.
//

#ifndef Snudown_h
#define Snudown_h

#include <stdio.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

void init_renderers();
const char* markdownTest(char* text);


#ifdef __cplusplus
}
#endif
#endif
