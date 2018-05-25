
#include <iostream>
#include <string>
#include <locale.h>
#include <stack>
#include <ctime>
#include <algorithm>
#include <chrono>
#include <thread>

using namespace std;

struct Carta
{
    string tipo;
    string nome;
    int ataque;
    int defesa;
    int meio;
    int titulos;
    int aparicao_copas;
    bool super_trunfo = false;
} ;

struct Media_Atributos
{
    int ataque = 0;
    int defesa = 0;
    int meio = 0;
    int titulos = 0;
    int aparicao_copas = 0;
};


// Atributos
const int numero_cartas = 32;
Carta cartas [numero_cartas];
stack<Carta> stack_1;
stack<Carta> stack_2;
bool is_two_players = false;
int player_atual;
Media_Atributos media_atributos;



// Declaração de Métodos
void inicializar_cartas();
string to_string_carta(Carta carta);
void embaralhar_cartas();
void inicializar_pilhas();
void random_set_carta_trunfo();
void set_random_player_inicia_jogo();
void setup();
void select_numero_players();
void jogada_player(stack<Carta> *pilha_jogador, stack<Carta> *pilha_adversario);
bool is_a (string tipo);
void inverte_pilha(stack<Carta> *pilha);
string escolher_atributo_bot(Carta carta);
bool valida_atributo(string atributo);
int compara_cartas(Carta carta1,Carta carta2, string atributo);
void mediaAtributos();

// Métodos

int main()
{
    setup();
    int rodada = 1;
    this_thread::sleep_for(chrono::milliseconds(5000));

    while(!stack_1.empty() && !stack_2.empty())
    {

        system("clear");
        cout << endl << ">>> Placar <<<" << endl << "P1 - " << stack_1.size() << " Cartas" << " x " << stack_2.size() << " Cartas - " << "P2"<< endl << "Player Atual: " << player_atual << endl;
        cout << "Rodada: " << rodada++ << endl;
        this_thread::sleep_for(chrono::milliseconds(2000));

        if (player_atual == 1)
            jogada_player(&stack_1,&stack_2);
        else
            jogada_player(&stack_2,&stack_1);

        this_thread::sleep_for(chrono::milliseconds(5500));
    }

    if (stack_1.empty())
        cout << endl << "FIM DE JOGO - PLAYER 2 VENCEU!!!" << rodada++ << endl;
    else
        cout << endl << "FIM DE JOGO - PLAYER 1 VENCEU!!!" << rodada++ << endl;

    cout << "Total de Rodadas: " << rodada;


    return 0;
}

void setup()
{
    setlocale(LC_ALL, "Portuguese");
    select_numero_players();
    inicializar_cartas();
    embaralhar_cartas();
    mediaAtributos();
    inicializar_pilhas();
    random_set_carta_trunfo();
    set_random_player_inicia_jogo();

}

void select_numero_players()
{
    cout << "Selecione o Numero de Jogadores (1 ou 2): " ;
    int opcao;


    cin >> opcao;

    switch (opcao)
    {
    case 1:
        system("clear");
        cout << "MODO DE JOGO - JOGADOR x PC" << endl  ;
        break;
    case 2:
        is_two_players = true;
        system("clear");
        cout << "MODO DE JOGO - JOGADOR1 x JOGADOR2" << endl  ;
        break;
    default:
        system("clear");
        cout << "OPCAO INVALIDA!" << endl  ;
        cin.clear();
        cin.ignore();
        select_numero_players();

        break;


    }


}


string to_string_carta(Carta carta)
{
    string to_string = "Tipo: " + carta.tipo + "\n" +
                       "Selecao: " + carta.nome + "\n" +
                       "Ataque: " + std::to_string(carta.ataque) + "\n" +
                       "Meio: " + std::to_string(carta.meio) + "\n" +
                       "Defesa: " + std::to_string(carta.defesa) + "\n" +
                       "Titulos: " + std::to_string(carta.titulos) + "\n" +
                       "Aparicoes em Copas: " + std::to_string(carta.aparicao_copas) + "\n" ;

    if (carta.super_trunfo)
        to_string += " SUPER TRUNFO ";

    return to_string;
}

void inicializar_cartas()
{

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

    cout << ">>> Pilhas de Cartas Montadas" << endl ;
    this_thread::sleep_for(chrono::milliseconds(1000));

}

void embaralhar_cartas()
{
    srand(time(0));
    random_shuffle(&cartas[0], &cartas[32]);
    cout << ">>> Cartas Embaralhadas" << endl;
    this_thread::sleep_for(chrono::milliseconds(1000));
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

    cout << ">>> Player " << player_atual << " inicia o Jogo" << endl;
    this_thread::sleep_for(chrono::milliseconds(1000));
}


void jogada_player (stack<Carta> *pilha_jogador, stack<Carta> *pilha_adversario)
{
    Carta carta_jogador = pilha_jogador->top();
    Carta carta_adversario = pilha_adversario->top();

    int player_adversario;

    if (player_atual == 2)
        player_adversario = 1;
    else
        player_adversario = 2;


    cout << endl << "[NOVA JOGADA]" << endl << "PLAYER " << player_atual << endl;
    cout  << endl << "CARTA PLAYER " << player_atual <<  endl << to_string_carta(carta_jogador) << endl;


    if (carta_jogador.super_trunfo)
    {
        cout << "[EH TRUNFO]" << endl;
        cout  << endl << "CARTA PLAYER " << player_adversario <<  endl << to_string_carta(carta_adversario) << endl;


        if(is_a(carta_adversario.tipo))
        {
            cout << endl << "PLAYER " << player_adversario << " Vencedor da Rodada]" << endl;
            inverte_pilha(pilha_adversario);
            pilha_adversario->push(pilha_jogador->top());
            pilha_jogador->pop();
            inverte_pilha(pilha_adversario);
            player_atual = player_adversario;
        }
        else
        {
            cout << endl << "[PLAYER " << player_atual << " Vencedor da Rodada]" << endl;
            inverte_pilha(pilha_jogador);
            pilha_jogador->push(pilha_adversario->top());
            inverte_pilha(pilha_jogador);
            pilha_adversario->pop();
        }
    }

    else
    {

        if (!is_two_players && player_atual == 2)
        {

            string atributo = escolher_atributo_bot(carta_jogador);
            this_thread::sleep_for(std::chrono::milliseconds(2000));

            cout << "ATRIBUTO ESCOLHIDO: " << atributo << endl;
            this_thread::sleep_for(chrono::milliseconds(3000));

            cout  << endl << "CARTA PLAYER " << player_adversario <<  endl << to_string_carta(carta_adversario);

            if (compara_cartas(carta_jogador,carta_adversario,atributo) > 0)
            {
                cout << endl << "[PLAYER " << player_atual << " Vencedor da Rodada]" << endl;
                inverte_pilha(pilha_jogador);
                pilha_jogador->push(pilha_adversario->top());
                inverte_pilha(pilha_jogador);
                pilha_adversario->pop();


            }
            else
            {
                cout << endl << "[PLAYER " << player_adversario << " Vencedor da Rodada]" << endl;
                inverte_pilha(pilha_adversario);
                pilha_adversario->push(pilha_jogador->top());
                inverte_pilha(pilha_adversario);
                pilha_jogador->pop();
                player_atual = player_adversario;

            }

        }

        else
        {

            string atributo;

            cout << "Selecione um Atributo [ATAQUE | DEFESA | MEIO | TITULOS | APARICOES_COPA]: " ;
            cin >> atributo;

            while (!valida_atributo(atributo))
            {
                cin.clear();
                cin.ignore();

                cout << "ATRIBUTO INVALIDO!" << endl ;
                cout << "Selecione um Atributo [ATAQUE | DEFESA | MEIO | TITULOS | APARICOES_COPA]: " ;
                cin >> atributo;

            }

            cout << "ATRIBUTO ESCOLHIDO: " << atributo << endl;
            cout  << endl << "CARTA PLAYER " << player_adversario <<  endl << to_string_carta(carta_adversario);

            if (compara_cartas(carta_jogador,carta_adversario,atributo) > 0)
            {
                cout << endl << "[PLAYER " << player_atual << " Vencedor da Rodada]" << endl;
                inverte_pilha(pilha_jogador);
                pilha_jogador->push(pilha_adversario->top());
                inverte_pilha(pilha_jogador);
                pilha_adversario->pop();


            }
            else
            {
                cout << endl << "[PLAYER " << player_adversario << " Vencedor da Rodada]" << endl;
                inverte_pilha(pilha_adversario);
                pilha_adversario->push(pilha_jogador->top());
                inverte_pilha(pilha_adversario);
                pilha_jogador->pop();
                player_atual = player_adversario;

            }

        }

    }

}

int compara_cartas(Carta carta1,Carta carta2, string atributo)
{
    if (atributo.compare("ATAQUE") == 0)
    {
        if ((carta1.ataque - carta2.ataque) != 0)
            return carta1.ataque - carta2.ataque;
        else
            return carta2.tipo.compare(carta1.tipo);
    }

    else if (atributo.compare("DEFESA") == 0)
    {
        if ((carta1.defesa - carta2.defesa) != 0)
            return carta1.defesa - carta2.defesa;
        else
            return carta2.tipo.compare(carta1.tipo);
    }

    else if (atributo.compare("MEIO") == 0)
    {
        if ((carta1.meio - carta2.meio) != 0)
            return carta1.meio - carta2.meio;
        else
            return carta2.tipo.compare(carta1.tipo);

    }

    else if (atributo.compare("APARICOES_COPA") == 0)
    {
        if ((carta1.aparicao_copas - carta2.aparicao_copas) != 0)
            return carta1.aparicao_copas - carta2.aparicao_copas;
        else
            return carta2.tipo.compare(carta1.tipo);

    }

    else if (atributo.compare("TITULOS") == 0)
    {
        if ((carta1.titulos - carta2.titulos) != 0)
            return carta1.titulos - carta2.titulos;
        else
            return carta2.tipo.compare(carta1.tipo);
    }

    return 0;


}

bool valida_atributo(string atributo)
{
    if (atributo.compare("ATAQUE") == 0)
        return true;
    else if (atributo.compare("DEFESA") == 0)
        return true;
    else if (atributo.compare("MEIO") == 0)
        return true;
    else if (atributo.compare("APARICOES_COPA") == 0)
        return true;
    else if (atributo.compare("TITULOS") == 0)
        return true;
    else
        return false;
}

string escolher_atributo_bot(Carta carta)
{
    int ataque = carta.ataque - media_atributos.ataque;
    int meio = carta.meio - media_atributos.meio;
    int defesa = carta.defesa - media_atributos.defesa;
    int titulos = carta.titulos - media_atributos.titulos;
    int aparicoes_copa = carta.aparicao_copas - media_atributos.aparicao_copas;

    int maior = ataque;
    string tipo = "ATAQUE";

    if (defesa > maior)
    {
        maior = defesa;
        tipo = "DEFESA";
    }

    if (meio > maior)
    {
        maior = meio;
        tipo = "MEIO";
    }

    if (aparicoes_copa> maior)
    {
        maior = aparicoes_copa;
        tipo = "APARICOES COPA";
    }

    if (titulos > maior)
    {
        maior = titulos;
        tipo = "TITULOS";
    }

    return tipo;
}

void inverte_pilha(stack<Carta> *pilha)
{
    stack<Carta> stack_temp_1;
    stack<Carta> stack_temp_2;


    while (!pilha->empty())
    {
        stack_temp_1.push(pilha->top());
        pilha->pop();
    }

    while (!stack_temp_1.empty())
    {
        stack_temp_2.push(stack_temp_1.top());
        stack_temp_1.pop();
    }

    while (!stack_temp_2.empty())
    {
        pilha->push(stack_temp_2.top());
        stack_temp_2.pop();
    }


}

bool is_a (string tipo)
{
    return tipo.substr(0,1).compare("A") == 0;
}

void mediaAtributos()
{
    int ataque = 0;
    int meio = 0;
    int defesa = 0;
    int titulos = 0;
    int aparicoes_copa = 0;

    for (int i = 0; i < numero_cartas; i++)
    {
        ataque += cartas[i].ataque;
        meio += cartas[i].meio;
        defesa += cartas[i].defesa;
        titulos += cartas[i].titulos;
        aparicoes_copa += cartas[i].aparicao_copas;
    }

    media_atributos.ataque = ataque/numero_cartas;
    media_atributos.defesa = defesa/numero_cartas;
    media_atributos.meio = meio/numero_cartas;
    media_atributos.titulos = titulos/numero_cartas;
    media_atributos.aparicao_copas = aparicoes_copa/numero_cartas;

}

