#include <iostream>
#include <string>
#include <locale.h>

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

Carta cartas [32];

void inicializar_cartas();
string to_string_carta(Carta carta);


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

int main()
{   setlocale(LC_ALL, "Portuguese");
    inicializar_cartas();
    cout << to_string_carta(cartas[0]) << endl;
    return 0;
}
