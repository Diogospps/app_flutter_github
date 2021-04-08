import 'package:flutter/material.dart';
import 'package:app2/main.dart';

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: futureRequest,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(snapshot.data.login),
              ),
              body: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Image(
                      image: NetworkImage(snapshot.data.avatar_url),
                    ),
                  ),
                  Container(
                    child: Text('Usuário: ' + snapshot.data.login),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text('Seguidores: ' +
                            snapshot.data.followers.toString()),
                      ),
                      Container(
                        child: Text(
                            'Seguindo: ' + snapshot.data.following.toString()),
                      ),
                    ],
                  ),
                  Container(
                    child:
                        Text('Perfil criado em: ' + snapshot.data.created_at),
                  )
                ],
              )),
            );
          } else {
            return Container(
                child: Column(
              children: [
                Container(
                  child: Text('Usuário não encontrado!'),
                ),
                Container(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Faça outra pesquisa!'),
                )),
              ],
            ));
          }
        },
      ),
    );
  }
}
