import 'package:flutter/material.dart';

class Resposta extends StatelessWidget {
  final String textoResposta;
  final Color corResposta;
  final Function respostaTap;

  Resposta({this.textoResposta, this.corResposta, this.respostaTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: respostaTap,
        child: Container(
          padding: EdgeInsets.all(15.0),
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: corResposta,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              textoResposta,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
  }
}
