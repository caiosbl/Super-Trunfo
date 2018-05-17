#include <iostream>

using namespace std;

typedef struct{
string tipo;
string nome;
int ataque;
int defesa;
int meio;
int titulos;
int aparicao_copas;
bool is_super_trunfo;
}Carta;

Carta cartas [32];

void inicializar_cartas();

void inicializar_cartas(){
cartas[0].nome = "Brasil";
cartas[0].ataque = 5;
cartas[0].defesa = 10;
cartas[0].meio = 4;
cartas[0].titulos = 5;
cartas[0].aparicao_copas = 4;
}

int main()
{   inicializar_cartas();
    cout << "Hello world!" << cartas[0] << endl;
    return 0;
}
