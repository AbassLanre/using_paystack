import 'dart:convert';

import 'package:http/http.dart' as http;

class APIService {
  // secret key
  static final String secretKey = 'sk_test_4df11f7af9a3919b687992e0e49f69765450b15e';
  // public key
  static final String publicKey = 'pk_test_ac7f6240fdb347887a91c0e110de40cc1b400d73';

  // initialize transaction url
  static final String initTransactionUrl =
      'https://api.paystack.co/transaction/initialize';
  static final String transactionUrl = 'https://api.paystack.co/transaction/';


  // initialize transaction connection
  static Future initTransaction(String secretKey) async {
    // headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $secretKey'
    };

    // body
    Map<String, String> body = {
      "amount": '10000',
      "email": "kalanruse3@gmail.com"
    };

    // api connection
    var response = await http.post(Uri.parse(APIService.initTransactionUrl), headers: headers, body: jsonEncode(body));
//    print(response.body);
    var values = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return values;
    }
    else {
      print(response.reasonPhrase);
    }
  }

  static Future chargeAuthorization({ required String secretKey, required String authCode, required String email, required String amount}) async {
    // headers
    // var headers = {
    //   'Authorization': 'Bearer SECRET_KEY',
    //   'Content-Type': 'application/json'
    // };
    // // var body = jsonEncode({
    // //   'authorization_code': authCode,
    // //   'email': email,
    // //   'amount': amount
    // // });
    // var request = http.Request('POST', Uri.parse('https://api.paystack.co/transaction/charge_authorization'));
    // request.bodyFields.addAll(
    //     {
    //       'authorization_code': authCode,
    //       'email': email,
    //       'amount': amount
    //     }
    // );
    //
    // request.headers.addAll(headers);
    //
    // http.StreamedResponse response = await request.send();
    // var res = await response.stream.bytesToString();
    // print(res);
    /////////////////////////////////////////////////////////////////////////////////////////////////

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $secretKey'
    };

    final body = jsonEncode({
      "authorization_code": authCode,
      "amount": amount,
      "email": email,
    });

    // api connection
    var response = await http.post(
        Uri.parse(APIService.transactionUrl+'charge_authorization'),
        headers: headers,
        body: body);
    print('response in charge: '+ response.body);
    var values = jsonDecode(jsonEncode(response.body));
    if (response.statusCode == 200) {
      return values;
    }
    else if(response.statusCode == 400){
      print('400 '+response.reasonPhrase!);
    }    else if(response.statusCode == 401){
      print('401 '+response.reasonPhrase!);
    }    else if(response.statusCode == 404){
      print('404 '+response.reasonPhrase!);
    }    else {
      print('500+' );
    }

  }

  static Future fetchTransaction(String secretKey, String id) async {
    // headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $secretKey'
    };

    // api connection
    var response = await http.get(Uri.parse(APIService.transactionUrl+id),headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    }
    else {
      print(response.reasonPhrase);
    }

  }

  static Future verifyTransaction(String secretKey, String reference) async{
    // headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $secretKey'
    };
    // api connection
    var response = await http.get(Uri.parse(APIService.transactionUrl+'verify/'+reference), headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    }
    else {
      print(response.reasonPhrase);
    }
  }

}
