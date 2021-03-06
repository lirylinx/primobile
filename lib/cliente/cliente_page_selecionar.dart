// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:primobile/Database/Database.dart';
import 'package:primobile/sessao/sessao_api_provider.dart';
import 'cliente_modelo.dart';

List<Cliente> clientes = new List<Cliente>();
List<Cliente> clientesDuplicado = new List<Cliente>();

String baseUrl = "";
String url = "";

class ClienteSelecionarPage extends StatefulWidget {
  ClienteSelecionarPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ClienteSelecionarPageState createState() =>
      new _ClienteSelecionarPageState();
}

class _ClienteSelecionarPageState extends State<ClienteSelecionarPage> {
  TextEditingController editingController = TextEditingController();
  var duplicateItems;
  var items = List<_ListaTile>();

  @override
  void initState() {
    super.initState();

    //     getClientes().then((value) => setState(() {
    //    clientes = value;
    //  }) );
    getClientes().then((value) {
      if (this.mounted == true) {
        setState(() {
          if (value != null && value.length > 0)
            clientes = clientesDuplicado = value;
          else
            clientes = null;
        });
      }
    });
  }

  void filterSearchResults(String query) {
    List<Cliente> dummySearchList = List<Cliente>();

    dummySearchList.addAll(clientesDuplicado);
    if (query.trim().isNotEmpty) {
      List<Cliente> dummyListData = List<Cliente>();
      dummySearchList.forEach((item) {
        if (item.nome.toLowerCase().contains(query.toString().toLowerCase()) ||
            item.cliente
                .toLowerCase()
                .contains(query.toString().toLowerCase())) {
          dummyListData.add(item);
        }
      });
            if (this.mounted == true) {

      setState(() {
        clientes.clear();
        clientes = dummyListData;
      });
            }
      return;
    } else {
            if (this.mounted == true) {

      setState(() {
        clientes.clear();
        clientes = dummySearchList;
      });
            }
    }
  }

  @override
  Widget build(BuildContext context) {
    SessaoApiProvider.read().then((parsed) async {
      Map<String, dynamic> filial = parsed['resultado'];
      String protocolo = 'http://';
      String host = filial['empresa_filial']['ip'];
      String rota = '/api/ImagemUpload/cliente/';
      // var status = await getUrlStatus(url) ;
            if (this.mounted == true) {

      setState(() {
        baseUrl = url = protocolo + host + rota;
      });
            }
    });

    getClientes().then((value) {
            if (this.mounted == true) {

      setState(() {
          clientesDuplicado = value;
        });
            }
  });
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: new Text("Clientes"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration:
                  BoxDecoration(color: Color.fromRGBO(241, 249, 255, 100)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 45,
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                      )
                    ]),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          hintText: 'Procurar'),
                      onChanged: (value) {
                        // filtroResultadoBusca( value );
                        filterSearchResults(value);
                      },
                      controller: editingController,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: listaCliente()),
          ],
        ),
      ),
    );
  }
}

Widget listaCliente() {
  if (clientes == null) {
    return Container(
      child: Text(
        "Nenhum Cliente encontrado. Sincronize os Dados",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  } else if (clientes.length <= 0) {
    return Container(child: Center(child: CircularProgressIndicator()));
  } else {
    return Scrollbar(
      isAlwaysShown: false,
      child: ListView.builder(
        itemCount: clientes.length,
        itemBuilder: (context, index) {
          Cliente cliente = clientes[index];
          url = baseUrl + cliente.cliente;

          return Container(
            child: _ListaTile(
              onTap: () {
                Navigator.pop(context, cliente);
              },
              leading: GestureDetector(
                  child: GestureDetector(
                      child: ClipOval(
                          child:Icon(Icons.error)),
                      //      CachedNetworkImage(
                      //   width: 45,
                      //   height: 45,
                      //   fit: BoxFit.cover,
                      //   imageUrl: url,
                      //   placeholder: (context, url) =>
                      //       CircularProgressIndicator(),
                      //   errorWidget: (context, url, error) => Icon(Icons.error),
                      // )),
                      onTap: () {
                        print('ok');
                      }),
                  onTap: () {
                    print('ok');
                  }),
              title: Text(
                cliente.nome,
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                cliente.endereco.descricao +
                    ' - ' +
                    cliente.numContrib.toString().replaceAll(" ", "") +
                    ' - ' +
                    "Encomenda Pendente: " +
                    cliente.encomendaPendente.toStringAsFixed(2) +
                    ' - ' +
                    "Venda não Convertida: " +
                    cliente.vendaNaoConvertida.toStringAsFixed(2) +
                    ' - ' +
                    "Total Deb: " +
                    cliente.totalDeb.toStringAsFixed(2) +
                    ' - ' +
                    "Limite Credito: " +
                    cliente.limiteCredito.toStringAsFixed(2),
                style: TextStyle(color: Colors.blueAccent, fontSize: 14),
              ),
              data: cliente,
            ),
          );
        },
      ),
    );
  }
}

class _ListaTile extends ListTile {
  _ListaTile(
      {Key key,
      this.leading,
      this.title,
      this.subtitle,
      this.trailing,
      this.isThreeLine = false,
      this.dense,
      this.contentPadding,
      this.enabled = true,
      this.onTap,
      this.onLongPress,
      this.selected = false,
      this.data = ""})
      : super(
            key: key,
            leading: leading,
            title: title,
            subtitle: subtitle,
            trailing: trailing,
            isThreeLine: isThreeLine,
            dense: dense,
            contentPadding: contentPadding,
            enabled: enabled,
            onTap: onTap,
            onLongPress: onLongPress,
            selected: selected);
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final bool isThreeLine;
  final bool dense;
  final EdgeInsetsGeometry contentPadding;
  final bool enabled;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  final bool selected;
  final dynamic data;

  dynamic getTitle() {
    return this.data;
  }

  bool contem(value) {
    return this.data.toLowerCase().contains(value.toString().toLowerCase());
  }
}

Future getClientes() async {
  var res = await DBProvider.db.getTodosClientes();

  return res;
}
