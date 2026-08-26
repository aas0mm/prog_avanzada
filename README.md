# Sistema de Asignación de Salas de Reunión (Elm)

**Autores:** Maximiliano Opazo, Martina Opazo, Antonia Orellana, Nicole Retamal y Estefania Troncoso  
**Fecha:** 27 de agosto de 2026  

Este proyecto implementa una aplicación web desarrollada en **Elm** bajo el paradigma de **Programación Reactiva Funcional (FRP)** para la gestión y asignación automática de salas al procesar un flujo de solicitudes.

---

## Prerrequisitos: Descarga e instalación del Compilador de Elm

Para poder compilar y ejecutar este proyecto, es necesario contar con 
el compiladori¿oficial de **Elm (versión 0.19.1 o superior)**.

1. Opción A: **Node.js** (opcional, sólo si cuentas con **Node.js**)
La forma más rápida de instalar Elm es a través del gestor de paquetes de Node: 
    ```bash
    npm install -g elm

2. Opción B: Instalación directa de **Elm compiler** desde el sitio oficial
   - Ve al sitio web oficial de instalación de Elm: https://guide.elm-lang.org/install/elm 
   - Descarga el instalador correspondiente a tu sistema operativo.
   - Ejecuta el instalador descargado y sigue los pasos del asistente.
   - Para verificar la instalación, abre una terminal y ejecuta el siguiente comando:
        elm --version
    Deberías ver en pantalla una respuesta confirmando la versión.

## Compilación del programa a un archivo HTML
1. Abre una terminal y navega hasta la carpeta raíz del repositorio
2. Si es la primera vez que ejecutas el proyecto en esa carptea, inicializa o verifica las
dependencias con:
    elm make
3. Compila el archivo fuente **CasoDeEstudio.elm** para generar un documento HTML:
    elm make src/CasoDeEstudio.elm --output=index.html

## Ejecución del programa .html
- Para ejecutar el programa tras la compilación, simplemente puedes buscarlo en la carpeta de la aplicación de archivos y hacer click en él.

---
