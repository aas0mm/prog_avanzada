-- AUTORES: Maximiliano Opazo, Martina Opazo, Antonia Orellana, Nicole Retamal y Estefania Troncoso
-- FECHA: 27 de agosto de 2026

module CasoDeEstudio exposing (main)

import Browser
import Html exposing (Html, button, div, h1, h2, li, text, ul)
import Html.Events exposing (onClick)
import List
import Set


-- 1. MODELO Y TIPOS DE DATOS

type Equipamiento
    = Proyector
    | Pizarra
    | Videoconferencia
    | AireAcondicionado

type alias FranjaHoraria =
    { inicio : Int
    , fin : Int
    }

type alias Sala =
    { id : String
    , capacidad : Int
    , equipamiento : List Equipamiento
    }

type alias Solicitud =
    { id : String
    , horaria : FranjaHoraria
    , asistentes : Int
    , equipamientoRequerido : List Equipamiento
    }

type alias Asignacion =
    { solicitudId : String
    , salaId : String
    , horaria : FranjaHoraria
    }

type alias Rechazo =
    { solicitudId : String
    , motivo : String
    }

type alias Model =
    { catalogoSalas : List Sala
    , solicitudesPendientes : List Solicitud
    , asignaciones : List Asignacion
    , rechazos : List Rechazo
    , finalizado : Bool
    }


-- 2. LÓGICA DE NEGOCIO (Funciones Puras)

seSolapan : FranjaHoraria -> FranjaHoraria -> Bool
seSolapan f1 f2 =
    not (f1.fin <= f2.inicio || f1.inicio >= f2.fin)

tieneEquipamiento : List Equipamiento -> List Equipamiento -> Bool
tieneEquipamiento requeridos ofrecidos =
    List.all (\req -> List.member req ofrecidos) requeridos

salaDisponible : String -> FranjaHoraria -> List Asignacion -> Bool
salaDisponible salaId franja asignaciones =
    not (List.any (\a -> a.salaId == salaId && seSolapan a.horaria franja) asignaciones)

type ResultadoAsignacion
    = Éxito String
    | Fallo String

-- Punto 1: PUreza funcional e inmutabilidad en la lógica de dominio
-- El paradigma funcional determina la solución mediante funciones puras que 
-- transforman datos inmutables mediante composición y expresiones lógicas,
-- eliminando por completo los efectos secundarios y la mutación de estado.

intentarAsignar : Solicitud -> Model -> ResultadoAsignacion
intentarAsignar req model =
    let
        evaluarSala sala =
            if sala.capacidad < req.asistentes then
                Err "Capacidad insuficiente"
            else if not (tieneEquipamiento req.equipamientoRequerido sala.equipamiento) then
                Err "Falta equipamiento requerido"
            else if not (salaDisponible sala.id req.horaria model.asignaciones) then
                Err "Sala ocupada en ese horario"
            else
                Ok sala.id

        resultados = List.map evaluarSala model.catalogoSalas
    in
    case List.filterMap Result.toMaybe resultados of
        primerExito :: _ ->
            Éxito primerExito

        [] ->
            -- Si fallan todas, toma el motivo del primer fallo o un error genérico
            case List.head resultados of
                Just (Err motivo) -> Fallo motivo
                _ -> Fallo "Ninguna sala cumple con las condiciones"


-- 3. ACTUALIZACIÓN (UPDATE)

type Msg
    = ProcesarSiguiente
    | ProcesarTodas

-- Punto 2: Transición de estado inmutable vía Pattern Matching
-- En lugar de modificar destructivamente el estado global (como en la POO o
-- progamación imperativa), el paradigma exige retornar una nueva copia del
-- estado ('Model') calculada declarativamente a partir del estado anterior.

procesarUnaSolicitud : Model -> Model
procesarUnaSolicitud model =
    case model.solicitudesPendientes of
        [] ->
            { model | finalizado = True }

        actual :: rest ->
            case intentarAsignar actual model of
                Éxito salaId ->
                    let
                        nuevaAsignacion =
                            { solicitudId = actual.id, salaId = salaId, horaria = actual.horaria }
                    in
                    { model
                        | solicitudesPendientes = rest
                        , asignaciones = model.asignaciones ++ [ nuevaAsignacion ]
                        , finalizado = List.isEmpty rest
                    }

                Fallo motivo ->
                    let
                        nuevoRechazo =
                            { solicitudId = actual.id, motivo = motivo }
                    in
                    { model
                        | solicitudesPendientes = rest
                        , rechazos = model.rechazos ++ [ nuevoRechazo ]
                        , finalizado = List.isEmpty rest
                    }

update : Msg -> Model -> Model
update msg model =
    case msg of
        ProcesarSiguiente ->
            procesarUnaSolicitud model

        ProcesarTodas ->
            if model.finalizado then
                model
            else
                update ProcesarTodas (procesarUnaSolicitud model)


-- 4. VISTA (VIEW)

view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Sistema de Asignación de Salas (Elm)" ]
        
        , h2 [] [ text "Solicitudes Pendientes" ]
        , if List.isEmpty model.solicitudesPendientes then
            pText "(Sin solicitudes pendientes)"
          else
            ul [] (List.map (\s -> li [] [ text ("- ID: " ++ s.id ++ " | Asistentes: " ++ String.fromInt s.asistentes) ]) model.solicitudesPendientes)

        , h2 [] [ text "Asignaciones Aceptadas" ]
        , ul [] (List.map (\a -> li [] [ text ("✓ Solicitud " ++ a.solicitudId ++ " -> Sala " ++ a.salaId ++ " (" ++ String.fromInt a.horaria.inicio ++ ":00 - " ++ String.fromInt a.horaria.fin ++ ":00)") ]) model.asignaciones)

        , h2 [] [ text "Solicitudes Rechazadas" ]
        , ul [] (List.map (\r -> li [] [ text ("✗ Solicitud " ++ r.solicitudId ++ " -> Rechazada: " ++ r.motivo) ]) model.rechazos)

        , if model.finalizado then
            div [] [ text "¡Procesamiento del flujo finalizado!" ]
          else
            div []
                [ button [ onClick ProcesarSiguiente ] [ text "Procesar Siguiente Solicitud" ]
                , button [ onClick ProcesarTodas ] [ text "Procesar Todas de Golpe" ]
                ]
        ]

pText : String -> Html Msg
pText txt =
    Html.p [] [ text txt ]


-- 5. INICIALIZACIÓN Y MAIN

init : Model
init =
    { catalogoSalas =
        [ { id = "A101", capacidad = 10, equipamiento = [ Proyector, Pizarra ] }
        , { id = "B202", capacidad = 30, equipamiento = [ Proyector, Videoconferencia, AireAcondicionado ] }
        , { id = "C303", capacidad = 50, equipamiento = [ Proyector, Pizarra, Videoconferencia, AireAcondicionado ] }
        ]
    , solicitudesPendientes =
        [ { id = "SOL-01", horaria = { inicio = 9, fin = 11 }, asistentes = 8, equipamientoRequerido = [ Proyector ] }
        , { id = "SOL-02", horaria = { inicio = 10, fin = 12 }, asistentes = 25, equipamientoRequerido = [ Videoconferencia ] }
        , { id = "SOL-03", horaria = { inicio = 9, fin = 11 }, asistentes = 5, equipamientoRequerido = [ Proyector ] }
        , { id = "SOL-04", horaria = { inicio = 14, fin = 16 }, asistentes = 100, equipamientoRequerido = [] }
        ]
    , asignaciones = []
    , rechazos = []
    , finalizado = False
    }

-- Punto 3: Bucle reactivo y renderizado declarativo (The Elm Architecture)
-- El componente diferencial reactivo: la interfaz es una función pura del estado
-- (HTML = f(Model)). Los eventos de usuario no manipulan el DOM manualmente.
-- sino que emiten mensajes (Msg) que alimentan el ciclo reactivo gestionado
-- por el Runtime ('Browser.sandbox').

main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }