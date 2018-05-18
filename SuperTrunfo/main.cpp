#include <iostream>
#include <string>
#include <locale.h>
#include <stack>

using namespace std;

typedef struct{
string tipo;
string nome;
int ataque;
int defesa;
int meio;
int titulos;
int aparicao_copas;
bool is_super_trunfo = false;
}Carta;

// Estruturas de Dados
Carta cartas [32];
std::stack<Carta> stack_1;
std::stack<Carta> stack_2;

// Declaração de Métodos
void inicializar_cartas();
string to_string_carta(Carta carta);
void embaralhar_cartas(Carta *cartas, int size);
void swap(Carta *cartas, int i, int r);
void inicializar_pilhas();

// Métodos

int main()
{   setlocale(LC_ALL, "Portuguese");
    inicializar_cartas();
    embaralhar_cartas(cartas,32);
    inicializar_pilhas();

    cout << to_string_carta(cartas[0]) << endl;
    return 0;
}

string to_string_carta(Carta carta){
string to_string = "Tipo: " + carta.tipo + "\n" +
"Seleção: " + carta.nome + "\n" +
"Ataque: " + std::to_string(carta.ataque) + "\n" +
"Defesa: " + std::to_string(carta.defesa) + "\n" +
"Títulos: " + std::to_string(carta.titulos) + "\n" +
"Aparições em Copas: " + std::to_string(carta.aparicao_copas) + "\n" ;

if (cartas[0].is_super_trunfo)
    to_string += " SUPER TRUNFO ";

return to_string;
}

void inicializar_cartas(){
// Carta 1
cartas[0].nome = "Brasil";
cartas[0].ataque = 5;
cartas[0].defesa = 10;
cartas[0].meio = 4;
cartas[0].titulos = 5;
cartas[0].aparicao_copas = 4;


//  Carta 2 ... até  carta 32, o indice vai de 0 a 31

}

void inicializar_pilhas(){
for (int i = 0; i < 16; i++){
stack_1.push(cartas[i]);
}
for (int i = 16; i < 32; i++){
stack_2.push(cartas[i]);
}


}

void embaralhar_cartas(int *cartas, int tamanho_vetor)
{
	for (int i = 0; i < tamanho_vetor; i++)
	{
		int r = rand() % tamanho_vetor;

		swap(cartas,i,r);
	}
}

void swap (int *cartas, int i, int r){
int temp = cartas[i];
cartas[i] = cartas[r];
cartas[r] = temp;
}



