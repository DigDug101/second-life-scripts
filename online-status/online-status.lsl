// Tiaeld Tolsen @ Academia de Scripting - Detector de estado online sencillo

//   �Nuevo en esta versi�n!
//
// -Cambiado el sistema N2K que aparentemente no funciona m�s
// -Eliminado el query para obtener el nombre, sabiendo que el
//  N2K tambi�n lo devuelve.

//Empezamos definiendo alg�n par de cosas que utilizaremos luego...
string nombre;
key avatar;
key keyRequest;
key keyRequestOnline;
integer manejadorListener;

//Empezamos el script

default {
    
    //En este ejemplo, haremos que nuestro querido usuario provea a nuestro script
    //del nombre de la persona de la cual averiguaremos su estado conectado, para ello:    
    touch_start(integer n) {
        //Por si qued� alg�n residuo de un listener anterior...
        llListenRemove(manejadorListener);
        
        //Abrimos un listener para nosotros, que usaremos para recoger el nombre.
        manejadorListener = llListen(0, "", llGetOwner(), "");
        
        llSay(0, "Diga el nombre de la persona a procesar.");
    }
    
    //Cuando digamos algo por el chat, una vez abierto el listener...
    listen(integer canal, string nombre, key id, string mensaje) {
        
        //No necesitaremos nuestro listener por ahora, as� que lo matamos.
        llListenRemove(manejadorListener);

        //Rescatamos el key de la persona. LSL _NO_ provee de un m�todo
        //para recuperar el key dado un nombre (mas s� existe el caso inverso
        //con llKey2Name, por lo que utilizamos un HTTPRequest a un servicio
        //externo que har� el trabajo por nosotros:
        keyRequest = llHTTPRequest("http://name2key.appspot.com/?name="+llEscapeURL(mensaje), [], "");
        //N�tese:
        //  -Un HTTPRequest 'saldr� de SL' a hacer una 'consulta', no necesariamente la respuesta
        //  se de instant�neamente, por lo que utilizamos un identificador para trabajar con �l.
        //  -Pueden hacerse varios HTTPRequests y las respuestas no llegar�n necesariametne en ese mismo
        //  orden, para eso se usa el key.
        //  -llEscapeURL convierte un string cualquiera a otro procesable para un Request (convierte los
        //  espacios a %20, y dem�s s�mbolos a sus respectivos equivalentes, si los hubiese).
        
    }
    
    //Al momento de producirse la respuesta a nuestro Request, se dispara http_response
    http_response(key identificador, integer codigo, list metadatos, string contenido) {

        //Averiguamos si la respuesta que obtuvimos corresponde al request que lanzamos,
        //y si la respuesta tiene c�digo 200 (OK). Otros c�digos de respuesta pueden ser:
        //  -> 404 - Recurso no encontrado
        //  -> 500 - Error del servidor
        if(identificador == keyRequest && codigo == 200) {
        
            //Creamos una lista que albergar� los resultados de nuestra respuesta,
            //separ�ndolas con el caracter definido en la misma (ver m�s abajo).
            list resultados = llParseString2List(contenido, [":"], []);
            
            //Recogemos el key encontrado por el servicio web externo. Seg�n la
            //documentaci�n del servicio, la respuesta contendr� el nombre "bien escrito"
            //del avatar y su key, los dos valores separados por dos puntos. Con esto
            //matamos dos p�jaros de un solo tiro, respecto a la versi�n anterior. :)
            nombre = llList2String(resultados, 0);
            avatar = llList2Key(resultados, 1);
            //N�tese:
            //  -En s�ntesis, la respuesta ser�a algo como: 
            //        Tiaeld Tolsen:a90cf39a-d8f7-4dc0-adcf-cbde11a6fb07
            //  entonces, si separamos las dos partes con llParseString2List usando
            //  a ':' como separador, obtendremos una lista en donde, el elemento 0
            //  (el primero) ser� el nombre "bien escrito" del avatar, y el elemento 1
            //  ser� su key.
            
            //Si la respuesta es nula, quiere decir que la consulta no ha sido satisfactoria.
            if(avatar == NULL_KEY) {
                llSay(0, "Nombre incorrecto, o servicio no disponible. Intente luego.");
                //A�n con el status 200 puede que el servicio no se encuentre disponible
                //o el nombre no se encuentre en la base de datos del servicio; aunque
                //por lo que he leido, este servicio usa la b�squeda de SL directamente.
            }
            
            //Sin embargo, si nuestra consulta es exitosa
            else { 
                
                //Preguntamos si est� conectado o no.
                keyRequestOnline = llRequestAgentData(avatar, DATA_ONLINE);
            }
            
        //En caso de que el c�digo de la respuesta no sea satisfactorio:
        } else {
            llSay(0, "Servicio no disponible actualmente. Intente luego.");
        }
    }    
    
    //Todas las peticiones de llRequestAgentData generar�n un evento dataserver:
    dataserver(key identificador, string contenido) {
        
        //Donde si nuestra respuesta corresponde a la petici�n que hab�amos hecho
        //corresponde a la del estado online.
        if ( identificador == keyRequestOnline ) {
            
            //El estado se devuelve como un string convertible a un entero
            //que representar� un valor de verdad: TRUE si est� conectado,
            //o FALSE si es que no lo est�.
            integer estaConectado = (integer)contenido;
            
            //Entonces actuamos de acuerdo al estado del avatar:
            if ( estaConectado ) {
                llSay(0, nombre + " est� conectado en este momento.");
            } else {
                llSay(0, nombre + " NO est� conectado en este momento.");
            }            
        }        
    }
}