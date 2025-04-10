import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String route;
  final String title;
  final String subTitle;


  const Labels({super.key, required this.route, this.title = '¿No tienes una cuenta?', this.subTitle = 'Crea una ahora!'});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, route);
            },
            child: Text(subTitle),
          ),
        ],
      ),
    );
  }
}
