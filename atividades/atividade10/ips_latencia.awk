# Correção: 0,5
BEGIN { print "Aguarde... Isso pode demorar uma pouco."}
{
        comando = "ping -c3 "$1" | grep rtt | cut -f5 -d'/'"
        comando | getline latencia
        print latencia " ms - " $1 | "sort -n"
}
