//Operador l�gico OR ||

integer a = TRUE;
integer b = TRUE;

// do {
//     instrucciones...
// } while(condici�n);
// Ejecuta el bloque de instrucciones hasta que la condici�n no se cumpla.

// while(condici�n) {
//     instrucciones...
// }
// Comprueba la condici�n para ejecutar las instrucciones repetitivamente hasta que no se cumpla.

// for(condici�n inicial; condici�n final; incremento) {
//     instrucciones...
// }
//

default {
    touch_start(integer total_number) {
        if( a!=TRUE || b==TRUE ) {
            llSay(0, "Una de los dos valores es verdadero.");
        }
        
        integer cuenta = 0;
     
        /*while(cuenta<6) {
            llOwnerSay((string)cuenta);
            cuenta++;
        }
        
        do {
            llOwnerSay((string)cuenta);
            cuenta++;
        }while(cuenta<6);*/
        
        for(cuenta=0; cuenta<6; cuenta++) {
            llOwnerSay((string)cuenta);
        }
        
    }
}
