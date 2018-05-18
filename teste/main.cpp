#include <iostream>

using namespace std;

void embaralhar_cartas(int *cartas, int size);
void swap(int *cartas, int i, int r);


int cartas[32];

int main()
{

    for(int i = 0; i < 32; i++){
        cartas[i] = i;
    }

    for(int i = 0; i < 32; i++){
        cout << cartas[i] << " ";
    }
     cout << endl;

    embaralhar_cartas(cartas,32);

     for(int i = 0; i < 32; i++){
        cout << cartas[i] << " ";
    }

    return 0;
}

void embaralhar_cartas(int *vet, int vetSize)
{
	for (int i = 0; i < vetSize; i++)
	{
		int r = rand() % vetSize;

		swap(vet,i,r);
	}
}

void swap (int *vet, int i, int r){
int temp = vet[i];
vet[i] = vet[r];
vet[r] = temp;
}



