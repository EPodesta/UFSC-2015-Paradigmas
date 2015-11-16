/* -- GRUPO: 
-- Pedro van Rooij Costa
-- Nelson Mariano Leite Neto
-- Bruno Freitas */

#include <stdio.h>

int main(){
	int i = 37;
	float f = i;
	float f2 = *(float *) &i;

	printf("%f\n", f);
	printf("%1.80f\n", f2);
	return 0;
}
