/*-- GRUPO: 
-- Pedro van Rooij Costa
-- Nelson Mariano Leite Neto
-- Bruno Freitas */


#include "local.h"

float* pedirParam() {
	printf("Digite um valor: ");
	fflush(stdout);
	float* ret = (float*) malloc(sizeof(float));
	scanf("%f", ret);
	fflush(stdin);
	return ret;
}
void mostreResp(int opt, float* a, float* resp) {
	if (opt == 1)
		printf("O valor %f em graus eh %f\n", *a, *resp);
	else
		printf("O valor %f em radianos eh %f\n", *a, *resp);
	fflush(stdout);

}

int mostreMenu() {
	int i;
	printf("1. Para converter valor para graus \n");
	printf("2. Para converter valor para radianos \n");
	printf("0. Para sair.\n");
	printf("Digite Opcao: ");
	fflush(stdout);
	scanf("%d", &i);
	fflush(stdin);
	return i;
}

