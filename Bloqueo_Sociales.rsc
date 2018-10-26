##Parametros globales
:global OutInterface "ether1"
## Muestra mensaje de confirmacion
:global Msg "Reglas de Contenido Correctamente aplicadas"
##Bloqueo Redes Sociales
/ip firewall layer7-protocol
add name=Bloqueos regexp="^.*(facebook.com|twitter.com|instagram.com|hi5.com|t\
    agged.com|snapchat.com|match.com|pinterest.com|badoo.com|Instagram.com).*\
    \$"
##Bloqueo Youtube, youtube movil
add name=Youtube_Adicional regexp="^.+(youtube.com|www.youtube.com|m.youtube.c\
    om|ytimg.com|s.ytimg.com|ytimg.l.google.com|googlevideo.com|youtu.be).*\$"

/ip firewall filter
add action=drop chain=forward comment="Bloqueos General" layer7-protocol=\
    Bloqueos out-interface=$OutInterface place-before=1
add action=drop chain=forward comment="Bloqueo Youtube - Streaming" \
    layer7-protocol=Youtube_Adicional out-interface=$OutInterface place-before=2
##Imprime El mensaje en el log
:log info $Msg