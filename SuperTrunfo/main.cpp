
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
cartas[0].tipo = "A1";
    cartas[0].nome = "Russia";
    cartas[0].ataque = 80;
    cartas[0].defesa = 76;
    cartas[0].meio = 78;
    cartas[0].titulos = 0;
    cartas[0].aparicao_copas = 11;

    cartas[1].tipo = "A2";
    cartas[1].nome = "Alemanha";
    cartas[1].ataque = 81;
    cartas[1].meio = 85;
    cartas[1].defesa = 84;
    cartas[1].titulos = 4;
    cartas[1].aparicao_copas = 19;

    cartas[2].tipo = "A3";
    cartas[2].nome = "Brasil";
    cartas[2].ataque = 86;
    cartas[2].meio = 84;
    cartas[2].defesa = 85;
    cartas[2].titulos = 5;
    cartas[2].aparicao_copas = 21;

    cartas[3].tipo = "A4";
    cartas[3].nome = "Portugal";
    cartas[3].ataque = 85;
    cartas[3].meio = 82;
    cartas[3].defesa = 80;
    cartas[3].titulos = 0;
    cartas[3].aparicao_copas = 7;

    cartas[4].tipo = "A5";
    cartas[4].nome = "Argentina";
    cartas[4].ataque = 87;
    cartas[4].meio = 81;
    cartas[4].defesa = 80;
    cartas[4].titulos = 2;
    cartas[4].aparicao_copas = 17;

    cartas[5].tipo = "A6";
    cartas[5].nome = "Belgica";
    cartas[5].ataque = 86;
    cartas[5].meio = 84;
    cartas[5].defesa = 85;
    cartas[5].titulos = 0;
    cartas[5].aparicao_copas = 13;

    cartas[6].tipo = "A7";
    cartas[6].nome = "Polonia";
    cartas[6].ataque = 82;
    cartas[6].meio = 75;
    cartas[6].defesa = 79;
    cartas[6].titulos = 0;
    cartas[6].aparicao_copas = 8;

    cartas[7].tipo = "A8";
    cartas[7].nome = "Franca";
    cartas[7].ataque = 83;
    cartas[7].meio = 85;
    cartas[7].defesa = 82;
    cartas[7].titulos = 1;
    cartas[7].aparicao_copas = 15;

    cartas[8].tipo = "B1";
    cartas[8].nome = "Espanha";
    cartas[8].ataque = 84;
    cartas[8].meio = 86;
    cartas[8].defesa = 86;
    cartas[8].titulos = 1;
    cartas[8].aparicao_copas = 15;

    cartas[9].tipo = "B2";
    cartas[9].nome = "Suica";
    cartas[9].ataque = 74;
    cartas[9].meio = 78;
    cartas[9].defesa = 77;
    cartas[9].titulos = 0;
    cartas[9].aparicao_copas = 11;

    cartas[10].tipo = "B3";
    cartas[10].nome = "Inglaterra";
    cartas[10].ataque = 84;
    cartas[10].meio = 81;
    cartas[10].defesa = 81;
    cartas[10].titulos = 1;
    cartas[10].aparicao_copas = 15;

    cartas[11].tipo = "B4";
    cartas[11].nome = "Colombia";
    cartas[11].ataque = 81;
    cartas[11].meio = 77;
    cartas[11].defesa = 78;
    cartas[11].titulos = 0;
    cartas[11].aparicao_copas = 6;


    cartas[12].tipo = "B5";
    cartas[12].nome = "Mexico";
    cartas[12].ataque = 79;
    cartas[12].meio = 79;
    cartas[12].defesa = 76;
    cartas[12].titulos = 0;
    cartas[12].aparicao_copas = 16;

    cartas[13].tipo = "B6";
    cartas[13].nome = "Uruguai";
    cartas[13].ataque = 86;
    cartas[13].meio = 76;
    cartas[13].defesa = 79;
    cartas[13].titulos = 2;
    cartas[13].aparicao_copas = 13;

    cartas[14].tipo = "B7";
    cartas[14].nome = "Croacia";
    cartas[14].ataque = 76;
    cartas[14].meio = 83;
    cartas[14].defesa = 77;
    cartas[14].titulos = 0;
    cartas[14].aparicao_copas = 5;

    cartas[15].tipo = "B8";
    cartas[15].nome = "Peru";
    cartas[15].ataque = 74;
    cartas[15].meio = 72;
    cartas[15].defesa = 71;
    cartas[15].titulos = 0;
    cartas[15].aparicao_copas = 5;

    cartas[16].tipo = "C1";
    cartas[16].nome = "Costa Rica";
    cartas[16].ataque = 70;
    cartas[16].meio = 70;
    cartas[16].defesa = 75;
    cartas[16].titulos = 0;
    cartas[16].aparicao_copas = 5;

    cartas[17].tipo = "C2";
    cartas[17].nome = "Suecia";
    cartas[17].ataque = 74;
    cartas[17].meio = 73;
    cartas[17].defesa = 74;
    cartas[17].titulos = 0;
    cartas[17].aparicao_copas = 12;

    cartas[18].tipo = "C3";
    cartas[18].nome = "Tunisia";
    cartas[18].ataque = 69;
    cartas[18].meio = 69;
    cartas[18].defesa = 70;
    cartas[18].titulos = 0;
    cartas[18].aparicao_copas = 5;

    cartas[19].tipo = "C4";
    cartas[19].nome = "Egito";
    cartas[19].ataque = 78;
    cartas[19].meio = 72;
    cartas[19].defesa = 71;
    cartas[19].titulos = 0;
    cartas[19].aparicao_copas = 3;

    cartas[20].tipo = "C5";
    cartas[20].nome = "Senegal";
    cartas[20].ataque = 76;
    cartas[20].meio = 72;
    cartas[20].defesa = 70;
    cartas[20].titulos = 0;
    cartas[20].aparicao_copas = 2;

    cartas[21].tipo = "C6";
    cartas[21].nome = "Ira";
    cartas[21].ataque = 70;
    cartas[21].meio = 69;
    cartas[21].defesa = 69;
    cartas[21].titulos = 0;
    cartas[21].aparicao_copas = 5;

    cartas[22].tipo = "C7";
    cartas[22].nome = "Dinamarca";
    cartas[22].ataque = 75;
    cartas[22].meio = 77;
    cartas[22].defesa = 77;
    cartas[22].titulos = 0;
    cartas[22].aparicao_copas = 5;

    cartas[23].tipo = "C8";
    cartas[23].nome = "Islandia ";
    cartas[23].ataque = 73;
    cartas[23].meio = 74;
    cartas[23].defesa = 69;
    cartas[23].titulos = 0;
    cartas[23].aparicao_copas = 1;
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

