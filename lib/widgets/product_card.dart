import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.only( top: 30, bottom: 50),
        width: double.infinity,
        height: 350,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [

            _BackgroundImage(),

            _ProductDetails(),

            Positioned(
             top: 0,
             right: 0,
             child: _PriceTag()
            ),

              // TODO: mostrar de manera condicional
             Positioned(
             top: 0,
             left: 0,
             child: _NotAvailable()
            ),

          ],
        ),
      
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
    color: Colors.pink[50],
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0,9),
        blurRadius: 10,
      )
    ]
  );
}

class _NotAvailable extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'No disponible',
            style: TextStyle( color: Colors.white, fontSize: 20 ),
          ),
        ),
      ),
      width: 100,
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.only( topLeft: Radius.circular(25), bottomRight: Radius.circular(20) )
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10 ),
          child: Text('\$103.99', 
            style: TextStyle( color: Colors.pink[50], 
            fontSize: 20 )
          ),
        ),
      ),
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.pink[400],
        borderRadius: const BorderRadius.only( topRight: Radius.circular(25),
         bottomLeft: Radius.circular(25)
        )
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only( right: 50 ),
      child: Container(
        padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Disco duro G', 
              style: TextStyle( 
                fontSize: 20, 
                color: Colors.pink[50], 
                fontWeight: FontWeight.bold
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Id del disco duro', 
              style: TextStyle( 
                fontSize: 15, color: Colors.pink[50] 
              ),
            ),
          ],
        )
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.pink[400],
    borderRadius: BorderRadius.only( 
      bottomLeft: Radius.circular(25), 
      topRight: Radius.circular(25) 
    ),
  );
}

class _BackgroundImage extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 350,
        child: const FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'),
          image: NetworkImage('https://via.placeholder.com/400x300/f6f6f6'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}