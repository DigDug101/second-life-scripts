// Tiaeld Tolsen @ Academia de Scripting - Estad�sticas de SL en Tiempo Real


//Empezamos definiendo alg�n par de cosas que utilizaremos luego...
key kRequest;
list lResultados;

//Empezamos el script
default {
	
	//En este ejemplo, obtendremos las estad�sticas del estado, n�mero de cuentas y
	//el n�mero de personas conectadas actualmente a SecondLife, utilizando algo llamado
	//Data Feed, que no es m�s que un peque�o archivo que se actualiza en tiempo real
	//con la informaci�n que necesitamos y que se encuentra en http://secondlife.com/xmlhttp/secondlife.php
    state_entry() {
		//No queremos saturar a los servidore oficiales, ni estamos tan desesperados
		//por tener la informaci�n al momento, por lo que cada consulta adicional ser�
		//hecha en un intervalo de 300 segundos (5 minutos).
        llSetTimerEvent(300.);
		
		//Utilizamos un HTTPRequest para obtener el contenido del feed:
        kRequest = llHTTPRequest("http://secondlife.com/xmlhttp/secondlife.php", [], "");
		//N�tese:
        //  -Un HTTPRequest 'saldr� de SL' a hacer una 'consulta', no necesariamente la respuesta
        //  se de instant�neamente, por lo que utilizamos un identificador para trabajar con �l.
        //  -Pueden hacerse varios HTTPRequests y las respuestas no llegar�n necesariametne en ese mismo
        //  orden, para eso se usa el key.
    }
    
    //Al momento de producirse la respuesta a nuestro Request, se dispara http_response
    http_response(key identificador, integer codigo, list metadatos, string contenido) {
	
		//Averiguamos si la respuesta que obtuvimos corresponde al request que lanzamos,
        if(identificador==kRequest) {
		
			//Asignamos a nuestra lista los resultados de nuestra respuesta,
            //separ�ndolas con el los delimitadores que nos interesan (ver m�s abajo).
            lResultados = llParseString2List(contenido, ["<status>", "</status>", "<signups>", "</signups>", "<inworld>", "</inworld>"], []);
			
			//Inmediatamente despu�s, mostramos las estad�sticas que recogimos como un texto flotante:
            llSetText("Estad�sticas de SecondLife:\nEstado: " + llList2String(lResultados, 1) 
					+ "\nCuentas Totales: " + llList2String(lResultados, 3) 
					+ "\nConectados Actualmente: " + llList2String(lResultados, 5), 
			<1., 1., 1.>, 1.);
			//N�tese:
			//  -Los saltos de l�nea est�n representados por \n
			//  -La respuesta tiene la siguiente forma:
			//		<stats>
			//			<status>ONLINE</status>
			//			<signups>29,126,152</signups>
			//			<logged_in_last_60>Loading...</logged_in_last_60>
			//			<transactions>Loading...</transactions>
			//			<inworld>58,462</inworld>
			//		</stats>
			//	Al cortarla utilizando las etiquetas de apertura y cierre (<status>, </status>, ....)
			//	obtenemos una lista que se ve m�s o menos as�:
			//		["(etiquetas del inicio)", "ONLINE", "(cierre y apertura)", "29,126,152", "(cierre y apertura)", ...]
			//	es por eso que los datos son mostrados sac�ndolos de la lista con �ndices impares.
        }
    }

	//Cuando pasen los 300 segundos, se disparar� el evento timer
    timer() {
	
		//Donde simplemente solicitaremos la informaci�n una vez m�s, disparando otra vez
		//al evento http_response
        kRequest = llHTTPRequest("http://secondlife.com/xmlhttp/secondlife.php", [], "");
    }
    
	//Cada vez que el objeto sea rezeado en el mundo, se dispara on_rez
    on_rez(integer i) {
		
		//Para reiniciar el script y repetir todo el proceso desde el inicio.
        llResetScript();
    }
}
