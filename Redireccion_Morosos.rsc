################################################################################
#                                                                              #
#         Redireccion A Morosos sin necesidad de portal cautivo                #
#                                                                              #
################################################################################
#                             COMO FUNCIONA?                                   #
#
# Se usa el proxy para redirigir a los usuarios dentro del address list
# a un portal, adicional se le corta la navegación y cualquier otro servicio
# Una vez hecha la configuracion se agregara en address list las IP que quieran
# aparecer con la restriccion, si se maneja usermamager, basta con crear un nuevo
# perfil e indicar en avanzado, address list el mismo nombre que pongamos a los
# suspendidos
#
################################################################################
#                              REQUISITOS                                      #
#
# 1. Se debe contar con un servidor web para almacenar el mensaje, sea local
#    o en internet.
# 2. Se debe aceptar el tráfico desde el servidor donde esté almacenado el aviso
# 3. Tener activo el proxy para redirigir a los morosos
#
################################################################################
#                         VARIABLES GENERALES                                  #
# Puerto del Proxy
:global PuertoProxy "8081"
# IP del servidor o dominio donde esta contenido el aviso de suspension
:global Servidor "167.114.64.207"
# Si el servidor tiene puerto, especificarlo con : mas el puerto, ej :8000
:global URL "http://wificolombia.net/suspension/"
# Nombre de la Lista de suspension (por defecto llamada "Suspendidos")
:global Lista "Suspendidos"
################################################################################
/ip firewall filter
add action=accept chain=forward dst-address=$Servidor
/ip proxy
set enabled=yes port=$PuertoProxy
/ip proxy access
add action=allow disabled=no dst-address=$Servidor
add action=deny disabled=no redirect-to=$URL

/ip firewall filter
# add chain=forward dst-address=$Servidor action=accept place-before=0
add chain=disconnected comment="Se necesita el puerto 53 DNS para funcionar" dst-port=53 protocol=udp
add chain=disconnected comment="Se necesita el puerto 80 WEB para funcionar" dst-port=80 protocol=tcp
add action=drop chain=disconnected comment="No funciona ningún servicio para los listados"
add action=jump chain=forward comment="Se redirige los usuarios desconectados a la cadena de desconexion" \
jump-target=disconnected src-address-list=$Lista

/ip firewall nat
add chain=dstnat action=redirect to-ports=$PuertoProxy protocol=tcp src-address-list=Suspendidos \
dst-port=80 comment="Redirect to Proxy" disable=no