import 'package:flutter/material.dart';
import 'package:quizmatematico/respostas.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Icon> _listaPontos = [];
  int _questaoIndex = 0;
  int _totalPontos = 0;
  bool respostaFoiSelecionada = false;
  bool fimDoQuiz = false;
  bool respostaCorretaSelecionada = false;

  void _perguntaRespondida(bool pontosResposta) {
    setState(() {
      //Resposta foi selecionada
      respostaFoiSelecionada = true;
      //Verifique se a resposta estava correta
      if (pontosResposta) {
        _totalPontos++;
        respostaCorretaSelecionada = true;
      }
      //Adiciona no topo V ou X caso acerte a questão ou erre
      _listaPontos.add(
        pontosResposta
            ? Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : Icon(
                Icons.clear,
                color: Colors.red,
              ),
      );
      //Quando o quiz termina
      if (_questaoIndex + 1 == _questoes.length) {
        fimDoQuiz = true;
      }
    });
  }

  void _proximaQuestao() {
    setState(() {
      _questaoIndex++;
      respostaFoiSelecionada = false;
      respostaCorretaSelecionada = false;
    });
    //O que acontece no final do quiz
    if (_questaoIndex >= _questoes.length) {
      _resetarQuiz();
    }
  }

  void _resetarQuiz() {
    setState(() {
      _questaoIndex = 0;
      _totalPontos = 0;
      _listaPontos = [];
      fimDoQuiz = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[300],
        title: Text(
          'Quiz Matemático',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/fundo.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_listaPontos.length == 0)
                  SizedBox(
                    height: 24.0,
                  ),
                if (_listaPontos.length > 0) ..._listaPontos
              ],
            ),
            Container(
              //Fundo pergunta
              width: double.infinity,
              height: 130.0,
              margin: EdgeInsets.only(bottom: 10.0, left: 30.0, right: 30.0),
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  _questoes[_questaoIndex]['questao'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ...(_questoes[_questaoIndex]['respostas']
                    as List<Map<String, Object>>)
                .map(
              (resposta) => Resposta(
                textoResposta: resposta['textoResposta'],
                corResposta: respostaFoiSelecionada
                    //Cor de fundo das alternativas
                    ? resposta['pontos']
                        ? Colors.green
                        : Colors.red
                    : Colors.white,
                respostaTap: () {
                  //Se a resposta já foi selecionada, então nada acontece no clique
                  if (respostaFoiSelecionada) {
                    return;
                  }
                  //Resposta está sendo selecionada
                  _perguntaRespondida(resposta['pontos']);
                },
              ),
            ),
            SizedBox(height: 20.0),
            //Botão Reiniciar/Próximo
            ElevatedButton(
              style:
                  (fimDoQuiz //Mudando a cor do botão caso tenha acabado o game
                      ? ElevatedButton.styleFrom(
                          minimumSize: Size(40.0, 40.0), primary: Colors.black)
                      : ElevatedButton.styleFrom(
                          minimumSize: Size(40.0, 40.0), primary: Colors.red)),
              onPressed: () {
                if (!respostaFoiSelecionada) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        '         Escolha sua resposta antes de continuar'),
                  ));
                  return;
                }
                _proximaQuestao();
              },
              child: Text(fimDoQuiz ? 'Reiniciar Quiz' : 'Próxima Questão'),
            ),
            Container(
              child: Align(
                alignment: Alignment(0, -0.5),
                child: Text(
                  '${_questaoIndex + 1}/${_questoes.length}',
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            if (respostaFoiSelecionada && !fimDoQuiz)
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: respostaCorretaSelecionada ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                width: respostaCorretaSelecionada ? 190 : 110,
                child: Center(
                  child: Text(
                    respostaCorretaSelecionada
                        ? 'Parabéns, Correto!'
                        : 'Errado :(',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (fimDoQuiz)
              Container(
                height: 106,
                width: 380,
                //width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    _totalPontos >= 1
                        ? 'Parabéns, sua pontuação final é: $_totalPontos.'
                        : 'Sua pontuação final é: $_totalPontos.\n'
                            'Tente novamente, você vai conseguir :D',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: _totalPontos >= 1 ? Colors.white : Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final _questoes = const [
  //Adicionar 10 questões ao total
  {
    'questao': 'Quanto é 2x2?',
    'respostas': [
      {'textoResposta': '4', 'pontos': true},
      {'textoResposta': '1', 'pontos': false},
      {'textoResposta': '2', 'pontos': false},
    ],
  },
  {
    'questao': 'Quanto é 2x2?',
    'respostas': [
      {'textoResposta': '4', 'pontos': true},
      {'textoResposta': '1', 'pontos': false},
      {'textoResposta': '2', 'pontos': false},
    ],
  },
  {
    'questao': 'Quanto é 2x2?',
    'respostas': [
      {'textoResposta': '4', 'pontos': true},
      {'textoResposta': '1', 'pontos': false},
      {'textoResposta': '2', 'pontos': false},
    ],
  },
  {
    'questao': 'Quanto é 2x2?',
    'respostas': [
      {'textoResposta': '4', 'pontos': true},
      {'textoResposta': '1', 'pontos': false},
      {'textoResposta': '2', 'pontos': false},
    ],
  },
  {
    'questao': 'Quanto é 2x2?',
    'respostas': [
      {'textoResposta': '4', 'pontos': true},
      {'textoResposta': '1', 'pontos': false},
      {'textoResposta': '2', 'pontos': false},
    ],
  },
  {
    'questao': 'Quanto é 2x2?',
    'respostas': [
      {'textoResposta': '4', 'pontos': true},
      {'textoResposta': '1', 'pontos': false},
      {'textoResposta': '2', 'pontos': false},
    ],
  },
  {
    'questao': 'Quanto é 2x2?',
    'respostas': [
      {'textoResposta': '4', 'pontos': true},
      {'textoResposta': '1', 'pontos': false},
      {'textoResposta': '2', 'pontos': false},
    ],
  },
  {
    'questao': 'Quanto é 2x2?',
    'respostas': [
      {'textoResposta': '4', 'pontos': true},
      {'textoResposta': '1', 'pontos': false},
      {'textoResposta': '2', 'pontos': false},
    ],
  },
  {
    'questao': 'Quanto é 2x2?',
    'respostas': [
      {'textoResposta': '4', 'pontos': true},
      {'textoResposta': '1', 'pontos': false},
      {'textoResposta': '2', 'pontos': false},
    ],
  },
  {
    'questao': 'Quanto é 2x2?',
    'respostas': [
      {'textoResposta': '4', 'pontos': true},
      {'textoResposta': '1', 'pontos': false},
      {'textoResposta': '2', 'pontos': false},
    ],
  },
];
