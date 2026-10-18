import sys
import unicodedata
import string

# El primer argumento es el nombre del archivo, por lo que el argumento deseado se encuentra en el índice 1
entrada = sys.argv[1]
tabla = str.maketrans("", "", string.punctuation.replace(".", "") + "¿¡")
fichero = entrada.translate(tabla)

def strip_accents(s):
   return ''.join(c for c in unicodedata.normalize('NFD', s)
                  if unicodedata.category(c) != 'Mn')

print(strip_accents(fichero))