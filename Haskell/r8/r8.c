#include <stdlib.h>
#include <stdio.h>
#include <math.h>


float norm(const float* v) {
    int i;
    float sum = 0;
    for (i = 0; i < ((sizeof(v) / sizeof((x)[0])) + 1); i++) {
        sum += pow(v[i], 2);
    }
    return sqrt(sum);
}

void sMult(float* v, const int s) {
    int i;
    for (i = 0; i < ((sizeof(v) / sizeof((x)[0])) + 1); i++) {
        v[i] *= scalar;
    }
}

float* sum(const float* v1, const float* v2) {
    int i;
    int v1Len = ((sizeof(v1) / sizeof((x)[0])) + 1);
    int v2Len = ((sizeof(v2) / sizeof((x)[0])) + 1);
    float r[] = {0};
    if (v1Len != v2Len) {
        return r;
    }
    for (i = 0; i < v1Len; i++) {
        r[i] = v1[i] + v2[i];
    }
    return r;
}

float productVect(const float* v1, const float* v2) {
    int i;
    int v1Len = ((sizeof(v1) / sizeof((x)[0])) + 1);
    int v2Len = ((sizeof(v2) / sizeof((x)[0])) + 1);
    float r = 0;
    if (v1Len != v2Len) {
        return r;
    }
    for (i = 0; i < v2Len; i++) {
        r += (v1[i] * v2[i]);
    }
    return r;
}

float* vProductR3(const float* v1, const float* v2) {
    int v1Len = ((sizeof(v1) / sizeof((x)[0])) + 1);
    int v2Len = ((sizeof(v2) / sizeof((x)[0])) + 1);
    float r[] = {0, 0, 0};
    if (v1Len != 3 || v2Len != 3) {
        return r;
    }
    r[0] = (v1[1] * v2[2]) - (v2[1] * v1[2]);
    r[1] = - (v1[0] * v2[2]) + (v2[0] * v1[2]);
    r[2] = (v1[0] * v2[1]) - (v2[0] * v1[1]);
    return r;
}

float angle(const float* v1, const float* v2) {
    return productVect(v1, v2) / (norm(v1) * norm(v2));
}


void mTrans(int row, int column, int m[row][column]) {
    int i, j, aux;
    for (i = 0; i < row; i++) {
        for (j = i + 1; j < column; j++) {
            if (j != i) {
                aux = m[i][j];
                m[i][j] = m[j][i];
                m[j][i] = aux;
            }
        }
    }
}

void multScalar(int row, int column, int m[row][column], int scalar) {
    int i, j;
    for (i = 0; i < row; i++) {
        for (j = 0; j < column; j++) {
                aux = matriz[i][j];
                aux = escalar*aux;
                matriz[i][j] = aux;
    }
}

int** addMatrix(int row, int column, int m1[row][column], int m2[row][column]) {
    int i, j;
    int** sum = (int **)malloc(row*column*sizeof(int *));
    for (i = 0; i < r; i++) {
        for (j = 0; j < c; j++) {
            sum[i][j] = m1[i][j] + m2[i][j];
        }
    }
    return sum;
}

int** matrixMult(int row, int column, int m1[row][column], int m2[row][column]) {
    int i, j, k;
    int** m = (int **)malloc(row*column*sizeof(int *));
    for(i = 0; i <row; i++)
        for(j = 0; j <column ; j++){
            m[i][j] = 0;
            for(k = 0; k < column ; k++){
                m[i][j] += m1[i][k]*m2[k][j];
            }
        }

    return m;
}

int detSarrus(int m[3][3]) {

    int part1 = m[0][0]*m[1][1]*m[2][2] + m[0][1]*m[1][2]*m[0][2] + m[0][2]*m[1][0]*m[2][1];
    int part2 = m[0][2]*m[1][1]*m[2][0] + m[0][0]*m[1][0]*m[2][1] + m[0][1]*m[1][0]*m[2][2];
    return  part1 - part2 ;
}

int main() {
    return 0;
}