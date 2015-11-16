/* -- GRUPO: 
-- Pedro van Rooij Costa
-- Nelson Mariano Leite Neto
-- Bruno Freitas */ 


#include <stdio.h>
#include <stdlib.h>

int main(){
	short int x=1372;
	char a;
	a=*(&x);
	printf("a= %c\n", a);
	printf("cont a: %x\n", a);
	printf("cont end x: %X\n", *(&x));
	exit (0);
}
	
