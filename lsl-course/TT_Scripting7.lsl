//Incrementos:
// Incrementar en X valores: variable += incremento;
// Incrementar en 1 unidad: varibale++;

//Extensi�n de la estructura condicional if:
// else: ejecutar� instrucciones si la condici�n definida en
// el if NO se cumple.

//string llKey2Name(key id); : Devuelve el nombre del avatar que tiene key 'id'
// llKey2Name(llGetOwner()); Devuelve el nombre del due�o

integer numero;
integer estado = FALSE;

default {

    touch_start(integer total_number) {
        
        //numero = numero + 1;
        //numero += 1;
        numero++;
        llSetText((string)numero, <1.0, 1.0, 1.0>, 1.0);
        
        /*if(numero >= 3) {
            llSay(0, "Activado");
            //numero = 0;
        } else {
            llSay(0, "Desactivado");
        }*/
                
        
        if(numero == 3 && llDetectedKey(0)==llGetOwner()) {
            llSay(0, "Tocado por el owner, en la tercersa pulsaci�n");
            //numero = 0;
        } else { 
            llSay(0, "O no eres el owner o no es la tercera pulsaci�n.");
        }
        
        
        //Switch l�gico:        
        /*if(estado == TRUE){ //Si el objeto estaba encendido
            llSay(0, "Apagando"); //Lo apagamos
            //Apagado...
            estado = FALSE;
        } else { //Si el objeto NO estaba encendido (apagado)
            llSay(0, "Encendiendo"); //Lo encendemos
            //Encendido...
            estado = TRUE;
        }*/
        
    }
}
