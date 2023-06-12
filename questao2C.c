/*
Grupo: Gabriel Sizinio, Caio Mello, Fernando Schettini
*/

#include <stdlib.h>
#include <stdio.h>


/*
Calcula a raiz cúbica aproximada
*/
int cbrtt(int med){
	int res = 0;
	for(int i = 1; i <= med; i++){
		if(i*i*i >= med){
			res = i;
			break;
		}
	}
	
	//printf("%d", res);
	return res;

}


/*
Calcula a média aritmética aproximada
*/

int MArit(int a, int b, int c){
	int med = (a+b+c)/3;
	
	printf("%d", med);
	return med;
}

/*
Calcula média geométrica aproximada
*/

int MGeo(int a, int b, int c){
	int med = a*b*c;
	int ra = (int) cbrtt(med);
	
	printf("%d", ra);
	return ra;
}

/*
Calcula a média harmônica aproximada
*/

int MHarm(int a, int b, int c){
	float ra = 1/ (float) a + 1/ (float) b + 1/ (float) c;
	int med = (int) 3/ra;
	
	printf("%d", med);
	return med;
}