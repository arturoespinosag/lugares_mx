

class Lugares{

  List<Lugar> items = [];

  Lugares();

  Lugares.fromJsonList( List<dynamic> jsonList){

    if(jsonList == null) return;

    for (var item in jsonList) {
      
      final lugar = new Lugar.fromJsonMap(item);
      items.add(lugar);

    }

  }

}




class Lugar {
    Lugar({
        this.id,
        this.nombre,
        this.razonSocial,
        this.claseActividad,
        this.estrato,
        this.tipoVialidad,
        this.calle,
        this.numExterior,
        this.numInterior,
        this.colonia,
        this.cp,
        this.ubicacion,
        this.telefono,
        this.correoE,
        this.sitioInternet,
        this.tipo,
        this.longitud,
        this.latitud,
        this.centroComercial,
        this.tipoCentroComercial,
        this.numLocal,
    });

    String id;
    String nombre;
    String razonSocial;
    String claseActividad;
    String estrato;
    String tipoVialidad;
    String calle;
    String numExterior;
    String numInterior;
    String colonia;
    String cp;
    String ubicacion;
    String telefono;
    String correoE;
    String sitioInternet;
    String tipo;
    String longitud;
    String latitud;
    String centroComercial;
    String tipoCentroComercial;
    String numLocal;

    Lugar.fromJsonMap( Map<String, dynamic> json){

    id                      = json['Id'];
    nombre                  = json['Nombre'];
    razonSocial             = json['Razon_social'];
    claseActividad          = json['Clase_actividad'];
    estrato                 = json['Estrato'];
    tipoVialidad            = json['Tipo_vialidad'];
    calle                   = json['Calle'];
    numExterior             = json['Num_Exterior'];
    numInterior             = json['Num_Interior'];
    colonia                 = json['Colonia'];
    cp                      = json['CP'];
    ubicacion               = json['Ubicacion'];
    telefono                = json['Telefono'];
    correoE                 = json['Correo_e'];
    sitioInternet           = json['Sitio_internet'];
    tipo                    = json['Tipo'];
    longitud                = json['Longitud'];
    latitud                 = json['Latitud'];
    centroComercial         = json['CentroComercial'];
    tipoCentroComercial     = json['TipoCentroComercial'];
    numLocal                = json['NumLocal'];


  }

}
