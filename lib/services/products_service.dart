import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:productos_apps/models/models.dart';
import 'package:http/http.dart' as http;


class ProductsService extends ChangeNotifier{

final String _baseUrl = 'flutter-new-648ac-default-rtdb.firebaseio.com';
final List<Product> products = [];
late Product selectedProduct;

File? newPictureFile; /* para almacenar la imagen */

bool isLoading = true;
bool isSaving = false;

ProductsService() {
  this.loadProducts();

}
// Para agregar nuevos productos loadProducts
Future<List<Product>> loadProducts() async {

  this.isLoading = true;
  notifyListeners(); /* para notificar a cualquier widget que se esta cargando */

  final url = Uri.https( _baseUrl, 'product.json');
/* dispara la peticion y regresa como un body */
  final resp = await http.get( url );

  final Map<String, dynamic> productsMap = json.decode( resp.body );

  productsMap.forEach((key, value) {
    final tempProduct = Product.fromMap( value );
    tempProduct.id = key;
    this.products.add( tempProduct );
  });

  this.isLoading = false;
  notifyListeners();  
  // para llamar a loadproducts

  return this.products;

}
  Future saveOrCreateProduct( Product product ) async {

    isSaving = true;
    notifyListeners();

    if ( product.id == null ) {
      // es necesario crear
      await this.createProduct( product );
    } else {
      // Actualizar
      await this.updateProduct(product);

    }


    isSaving = false;
    notifyListeners();

  }

  Future<String> updateProduct ( Product product ) async {

    final url = Uri.https( _baseUrl, 'products/${ product.id }.json');
    final resp = await http.put( url, body: product.toJson() );
    final decodedData = resp.body;

    // // //TODO: Actualizar el listado de productos
    final index = this.products.indexWhere((element) => element.id == product.id );
    this.products[index] = product;
    

    return product.id!;

  }

  Future<String> createProduct ( Product product ) async {

    final url = Uri.https( _baseUrl, 'products.json');
    final resp = await http.post( url, body: product.toJson() );
    final decodedData = json.decode( resp.body );

    product.id = decodedData['name'];

    this.products.add(product);

    return product.id!;
    

  }

  void updateSelectedProductImage( String path ){

    this.selectedProduct.picture = path;
    print('lisa: path $path');
    this.newPictureFile = File.fromUri( Uri (path: path) );

    notifyListeners();
  }

  Future<String?> uploadImage() async{


    if ( this.newPictureFile == null ) return null;

    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dpmzoaf4d/image/upload?upload_preset=f96bo2e1');

    final imageUploadRequest = http.MultipartRequest('POST', url );

    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('algo salio mal');
      print( resp.body );
      return null;
    }

    this.newPictureFile = null;

    final decodedData = json.decode( resp.body );
    return decodedData['secure_url'];

  }

}