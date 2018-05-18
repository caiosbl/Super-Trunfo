#include <iostream>
#include <string>
#include <locale.h>
#include <stack>
#include <ctime>
#include <cstdlib>

using namespace std;
// Struct Carta
typedef struct
{
    string tipo;
    string nome;
    int ataque;
    int defesa;
    int meio;
    int titulos;
    int aparicao_copas;
    bool super_trunfo = false;
} Carta;

// Atributos
const int numero_cartas = 32;
Carta cartas [numero_cartas];
std::stack<Carta> stack_1;
std::stack<Carta> stack_2;
bool is_two_players = false;
int player_atual;

// Declara��o de M�todos
void inicializar_cartas();
string to_string_carta(Carta carta);
void embaralhar_cartas(Carta *cartas, int size);
void swap(Carta *cartas, int i, int r);
void inicializar_pilhas();
void random_set_carta_trunfo();
void set_random_player_inicia_jogo();
void setup();
void select_numero_players();
void jogada_player(stack<Carta> pilha_jogador, stack<Carta> pilha_adversario);
bool is_a (string tipo);

// M�todos

int main()
{
    setup();
    cout << endl << "Placar" << endl << "PLAYER 1 - " << stack_1.size() << " Cartas" << " x " << stack_2.size() << " - Cartas " << "PLAYER 2"<< endl;
    if (player_atual == 1)
        jogada_player(stack_1,stack_2);
    else
        jogada_player(stack_2,stack_1);

    /*
    while(!stack_1.empty() && !stack_2.empty()){

        if (player_atual == 1)
        jogada_player(stack_1,stack_2);
        else
        jogada_player(stack_1,stack_2);
    } */
    return 0;
}

void setup()
{
    setlocale(LC_ALL, "Portuguese");
    inicializar_cartas();
    embaralhar_cartas(cartas,numero_cartas);
    inicializar_pilhas();
    random_set_carta_trunfo();
    set_random_player_inicia_jogo();
    select_numero_players();
}

void select_numero_players()
{
    cout << "Selecione o N�mero de Jogadores (1 ou 2): " ;
    int opcao;


    cin >> opcao;

    switch (opcao)
    {
    case 1:
        system("cls");
        cout << "MODO DE JOGO - JOGADOR x PC" << endl  ;
        break;
    case 2:
        is_two_players = true;
        system("cls");
        cout << "MODO DE JOGO - JOGADOR1 x JOGADOR2" << endl  ;
        break;
    default:
        system("cls");
        cout << "OP��O INV�LIDA!" << endl  ;
        cin.clear();
        cin.ignore();
        select_numero_players();

        break;


    }


}


string to_string_carta(Carta carta)
{
    string to_string = "Tipo: " + carta.tipo + "\n" +
                       "Sele��o: " + carta.nome + "\n" +
                       "Ataque: " + std::to_string(carta.ataque) + "\n" +
                       "Defesa: " + std::to_string(carta.defesa) + "\n" +
                       "T�tulos: " + std::to_string(carta.titulos) + "\n" +
                       "Apari��es em Copas: " + std::to_string(carta.aparicao_copas) + "\n" ;

    if (carta.super_trunfo)
        to_string += " SUPER TRUNFO ";

    return to_string;
}

void inicializar_cartas()
{
    for (int i = 0; i < numero_cartas ; i++)
    {
        cartas[i].tipo = "A1";
        cartas[i].nome = "Brasil";
        cartas[i].ataque = 5;
        cartas[i].defesa = 10;
        cartas[i].meio = 4;
        cartas[i].titulos = 5;
        cartas[i].aparicao_copas = 4;
    }


//  Carta 2 ... at�  carta 32, o indice vai de 0 a 31

}

void inicializar_pilhas()
{
    for (int i = 0; i < numero_cartas / 2; i++)
    {
        stack_1.push(cartas[i]);
    }
    for (int i = numero_cartas / 2; i < numero_cartas; i++)
    {
        stack_2.push(cartas[i]);
    }


}

void embaralhar_cartas(Carta *cartas, int tamanho_vetor)
{
    for (int i = 0; i < tamanho_vetor; i++)
    {
        int r = rand() % tamanho_vetor;

        swap(cartas,i,r);
    }
}

void swap (Carta *cartas, int i, int r)
{
    Carta temp = cartas[i];
    cartas[i] = cartas[r];
    cartas[r] = temp;
}

void random_set_carta_trunfo()
{
    srand(time(0));
    int r = rand() % numero_cartas;
    cartas[r].super_trunfo = true;
}

void set_random_player_inicia_jogo()
{
    srand(time(0));
    player_atual  =   1 + rand() % 2;
}


void jogada_player (stack<Carta> pilha_jogador, stack<Carta> pilha_adversario)
{
    Carta carta_jogador = pilha_jogador.top();
    Carta carta_adversario = pilha_adversario.top();



    cout << endl << "[NOVA JOGADA]" << endl << "PLAYER " << player_atual << endl;
    cout  << endl << "CARTA:" <<  endl << to_string_carta(carta_jogador);

    if (carta_jogador.super_trunfo)
    {
        cout << "CARTA ATUAL � TRUNFO" << endl;




    }

}

bool is_a (string tipo)
{
    return tipo.substr(0,1).compare("A") == 0;
}




