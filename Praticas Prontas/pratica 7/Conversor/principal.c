/* -- GRUPO: 
-- Pedro van Rooij Costa
-- Nelson Mariano Leite Neto
-- Bruno Freitas */

#include "local.h"

int main() {
	int opt;
	float *resp,*a;
	while ((opt = mostreMenu()) != 0) {
		if (opt == 1) {
			a = pedirParam();
			resp = paraGraus(a);
			mostreResp(opt, a, resp);
		} else if (opt == 2) {
			a = pedirParam();
			resp = paraRadianos(a);
			mostreResp(opt, a, resp);
		}
	}
	return EXIT_SUCCESS;
}
