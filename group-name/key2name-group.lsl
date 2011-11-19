// Tiaeld Tolsen @ Academia de Scripting - Nombre de un grupo, dado su UUID

//Empezamos definiendo alg�n par de cosas que utilizaremos luego...
string nombre;
key grupo;
key keyRequest;
integer manejadorListener;

//Empezamos el script

default {
    
    //En este ejemplo, haremos que nuestro querido usuario provea a nuestro script
    //del UUID del grupo cuyo nombre averiguaremos, para ello:    
    touch_start(integer n) {
        //Por si qued� alg�n residuo de un listener anterior...
        llListenRemove(manejadorListener);
        
        //Abrimos un listener para nosotros, que usaremos para recoger el nombre.
        manejadorListener = llListen(0, "", llGetOwner(), "");
        
        llSay(0, "Diga el UUID del grupo a consultar.");
    }
    
    //Cuando digamos algo por el chat, una vez abierto el listener...
    listen(integer canal, string nombre, key id, string mensaje) {
        
        //No necesitaremos nuestro listener por ahora, as� que lo matamos.
        llListenRemove(manejadorListener);
		
		//Rescatamos el mensaje (que contiene el UUID) en una variable (por ahora).
		grupo = (key)mensaje;

        //Rescatamos el UUID del grupo. LSL _NO_ provee de un m�todo
        //para recuperar el nombre de un grupo dado su key, por lo que
        //nos valdremos de un peque�o 'truco': Cuando accedemos a
		//http://world.secondlife.com/group/UUID-del-grupo obtenemos una
		//p�gina con informaci�n relevante a este grupo, espec�ficamente esta
		//p�gina tiene el nombre del grupo dado en su t�tulo, por lo que la
		//usaremos para nuestros fines.
		//
		//Empezamos asignando a nuestra variable el valor de la consulta HTTP para
		//reconocerla en el futuro:
        keyRequest = llHTTPRequest("http://world.secondlife.com/group/" + mensaje, [], "");
        //N�tese:
        //  -Un HTTPRequest 'saldr� de SL' a hacer una 'consulta', no necesariamente la respuesta
        //  se de instant�neamente, por lo que utilizamos un identificador para trabajar con �l.
        //  -Pueden hacerse varios HTTPRequests y las respuestas no llegar�n necesariametne en ese mismo
        //  orden, para eso se usa el key.
        
    }
    
    //Al momento de producirse la respuesta a nuestro Request, se dispara http_response
    http_response(key identificador, integer codigo, list metadatos, string contenido) {

        //Averiguamos si la respuesta que obtuvimos corresponde al request que lanzamos,
        //y si la respuesta tiene c�digo 200 (OK). Otros c�digos de respuesta pueden ser:
        //  -> 404 - Recurso no encontrado
        //  -> 500 - Error del servidor
        if(identificador == keyRequest && codigo == 200) {
        
            //Nuestra respuesta contendr� el c�digo HTML de una p�gina de Second Life
			//conteniendo informaci�n del grupo que, entre otras cosas, tiene exactamente
			//lo que nos interesa: su nombre. Especialmente para el caso del nombre, este
			//se encuentra ubicado en el t�tulo de la p�gina, y recordando algo de HTML
			//b�sico, el t�tulo de una p�gina se encuentra rodeado de las etiquetas <title>
			//y </title>, por lo que utilizaremos estos dos 's�mbolos' para realizar un corte
			//en la respuesta y extraer exactamente lo que necesitamos.			
			list resultados = llParseString2List(contenido, ["<title>", "</title>"], []);			
            //N�tese:
            //  -En s�ntesis, la respuesta ser�a algo como: 
            //     (c�digo html) <title> Nombre del Grupo </title> (m�s c�digo HTML)
            //  entonces, si separamos la respuesta con llParseString2List usando
            //  tanto a '<title>' como a '</title>' de separadores, obtendremos una 
			//	lista en donde, el elemento 0 (el primero) ser� el c�digo HTML precedente
			//	al nombre, el elemento 1 ser� el nombre (que es lo que nos interesa), y
			//	el elemento 2 ser� el resto de la p�gina web.
			
			nombre = llList2String(resultados, 1);            
			llSay(0, "El nombre del grupo " + (string)grupo + " es: " + nombre);
            
        //En caso de que el c�digo de la respuesta no sea satisfactorio:
        } else {
            llSay(0, "Servicio no disponible actualmente. Intente luego.");
        }
    }    
}