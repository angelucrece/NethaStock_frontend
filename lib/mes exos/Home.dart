import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       appBar: AppBar(
         title: Text('Inscription',style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w200,color: Colors.blue,),),
         titleSpacing: 8.0,
       ),
        // au centre
        body: Center(
          //formulaire
            child: Form(
              //colonne
                child: Column(
                  //on aligne le contenu de la colonne au debut
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('entrer votre mot de passe'),
                    SizedBox(height: 10.0,),
                    //zone pour entrer le texte
                    TextFormField(
                      keyboardType: TextInputType.text,
                      //on design le style de l'input
                      decoration: InputDecoration(
                        //ceci represente le texte par defaut ecrit dans la zone lorsque le formulaire n;est pas rempli
                        hintText: 'Ex: john.doc@gmail.com',
                        //style des bordures
                        border: OutlineInputBorder(
                          //on arrondie les bordures 'border radius'
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  ],
                )),
        ),

      ),
    );
  }
}
