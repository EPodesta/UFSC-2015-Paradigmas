/* -- GRUPO: 
-- Pedro van Rooij Costa
-- Nelson Mariano Leite Neto
-- Bruno Freitas */

#include "local.h"

float* paraGraus(float* radianos) {
	float* ret = (float*) malloc(sizeof(float));
	*ret = *radianos * (180 / PI);
	return ret;

}

float* paraRadianos(float* graus) {
	float* ret = (float*) malloc(sizeof(float));
	*ret = *graus * (PI / 180);
	return ret;
}
