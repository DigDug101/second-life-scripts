//llDialog(key avatar, string mensaje, list botones, integer canal) - Env�a un men� al avatar designado, conteniendo un mensaje, y una serie de botones cuya opci�n pulsada se enviar� por un canal.

//llSetTimerEvent(float segundos) - Dispara el evento timer() dentro de una cantidad determinada de segundos, peri�dicamente, hasta que se desactive (manualmente).

integer controlListen;

default {

    touch_start(integer total_number) {
        llDialog(llDetectedKey(0), "Escoge una opci�n:", ["Uno", "Dos"], 2);
        controlListen = llListen(2, "", llDetectedKey(0), "");
        llSetTimerEvent(20);
    }
    
    listen(integer chan, string nombre, key id, string mensaje) {
        llListenRemove(controlListen);
        llSetTimerEvent(0);
        
        if(mensaje=="Uno") {
            llSay(0, "Elegiste la primera opci�n.");
        } 
        else if(mensaje=="Dos") {
            llSay(0, "Elegiste la segunda opci�n.");
        }
    }
    
    timer() {
        llSetTimerEvent(0);
        llListenRemove(controlListen);
        llSay(0, "Di�logo expirado. Toque otra vez el prim para empezar.");
    }
    
}
