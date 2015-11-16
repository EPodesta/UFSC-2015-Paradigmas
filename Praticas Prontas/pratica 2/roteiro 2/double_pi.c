/*-- GRUPO: 
-- Pedro van Rooij Costa
-- Nelson Mariano Leite Neto
-- Bruno Freitas */

#include <stdio.h>
#include <math.h>

int main(){
	double pi;
	char ch;

	pi = 4* atan(1);
	ch = *(char *) &pi;

	printf("pi=%1.10f\tch=%c\n", pi, ch);
	return 0;
}
