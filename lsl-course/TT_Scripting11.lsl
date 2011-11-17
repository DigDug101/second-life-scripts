// changed(integer cambio) - Se dispara cuando suceden cambios en el objeto que contiene el script.
//Para la comprobaci�n de los cambios se utiliza el operador &

//key llAvatarOnSitTarget() - Devuelve el key de la persona que est� sentada en el objeto, se necesita hacer un llSitTarget primero.

//Comprobar validez de keys: if(key) {}

//llRequestPermissions(key avatar, integer permisos)
//PERMISSION_DEBIT - Tomar dinero del avatar.
//PERMISSION_TAKE_CONTROLS - Tomar posesi�n de los controles del visor
//PERMISSION_TRIGGER_ANIMATION - Ejecutar animaciones
//PERMISSION_ATTACH - Adjuntar, o soltar objetos
//PERMISSION_CHANGE_LINKS - Cambiar los links
//PERMISSION_TRACK_CAMERA - Seguir la posici�n de la c�mara
//PERMISSION_CONTROL_CAMERA - Controlar la c�mara

default {

    state_entry() {
        llSitTarget(<0,0,1>, ZERO_ROTATION);
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION | PERMISSION_DEBIT);
    }
    
    changed(integer cambio) {
        if(cambio & CHANGED_COLOR) {
            llSay(0, "Se ha cambiado mi color");
        }
        
        if(cambio & CHANGED_LINK) {
            key avatar = llAvatarOnSitTarget();
            if(avatar) {
                llSay(0, "Te has sentado!");
                llSetAlpha(0.0, ALL_SIDES);
            } else {
                llSay(0, "Te pusiste de pie.");            
                llSetAlpha(1.0, ALL_SIDES);
            }
        }
    }
    
    run_time_permissions(integer permisos) {
        if(permisos & PERMISSION_TRIGGER_ANIMATION) {
            llSay(0, "Inicar animaciones...");
        }
    }
}
