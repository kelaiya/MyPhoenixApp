--module Main exposing (main)
--import Html exposing (..)
--import Json.Decode exposing (..)
--import Html.Events exposing (..)
--import Http 

--import Html exposing (Html, button, div, text)
--import Html.Events exposing (onClick)


----main =
----  Html.beginnerProgram { model = model, view = view, update = update }


---- MODEL

--type alias Ticket =
--    { id : Int
--    , date : String
--    , opponent : String
--    , time : String
--    , userId : Maybe Int
--    }
--type alias User =
--    { id : Int
--    , name : String
--    }
--type alias Model =
--    { tickets : List Ticket
--    , users : List User
--    , myUserName : String
--    , systemError : String
--    }

--init : ( Model, Cmd Msg )
--init =
--    { tickets = []
--    , users = []
--    , myUserName = "Bill"
--    , systemError = ""
--    }
--        ! [ ticketsRequest, usersRequest ]

--{--Decoders--}

--ticketListDecoder : Json.Decode.Decoder (List Ticket)
--ticketListDecoder =
--    Json.Decode.list ticketDecoder
--ticketDecoder : Json.Decode.Decoder Ticket
--ticketDecoder =
--    Json.Decode.Pipeline.decode Ticket
--        |> Json.Decode.Pipeline.required "id" Json.Decode.int
--        |> Json.Decode.Pipeline.required "date" Json.Decode.string
--        |> Json.Decode.Pipeline.required "opponent" 
--             Json.Decode.string
--        |> Json.Decode.Pipeline.required "time" Json.Decode.string
--        |> Json.Decode.Pipeline.required "user_id" 
--            (Json.Decode.nullable Json.Decode.int)
--ticketsRequest : Cmd Msg
--ticketsRequest =
--    let
--        url =
--            "http://localhost:4000/api/v1/tickets"
--    in
--        Http.send ProcessTicketRequest
--          (Http.get url ticketListDecoder)
--userListDecoder : Json.Decode.Decoder (List User)
--userListDecoder =
--    Json.Decode.list userDecoder
--userDecoder : Json.Decode.Decoder User
--userDecoder =
--    Json.Decode.Pipeline.decode User
--        |> Json.Decode.Pipeline.required "id" Json.Decode.int
--        |> Json.Decode.Pipeline.required "name" Json.Decode.string
--usersRequest : Cmd Msg
--usersRequest =
--    let
--        url =
--            "http://localhost:4000/api/v1/users"
--    in
--        Http.send ProcessUserRequest (Http.get url userListDecoder)
---- UPDATE
--type Msg
--  = ProcessTicketRequest (Result Http.Error String)
--  | ProcessUserRequest (Result Http.Error String)

--update : Msg -> Model -> (Model, Cmd Msg)
--update msg model =
--  case msg of
--    ProcessTicketRequest (Ok tickets) ->
--        { model | tickets = tickets } ! []
--    ProcessTicketRequest (Err error) ->
--        let
--            errorString =
--                error |> toString |> String.slice 0 120
--        in
--            { model | systemError = errorString } ! []
--    ProcessUserRequest (Ok users) ->
--        { model | users = users } ! []
--    ProcessUserRequest (Err error) ->
--        let
--            errorString =
--                error |> toString |> String.slice 0 120
--        in
--            { model | systemError = errorString } ! []


---- VIEW

--view : Model -> Html Msg
--view model =
--    div []
--        [ header model.systemError
--        , remainingTickets model.tickets model.myUserName
--        , myTickets model
--        ]

--header : String -> Html Msg
--header systemError =
--    let
--        errorAttributes =
--            if model.systemError == "" then
--                []
--            else
--                []
--    in
--        div []
--            [ div errorAttributes [ text systemError ] ]

--remainingTickets : List Ticket -> Html Msg
--remainingTickets tickets myUserId =
--    div
--        []
--        [ h1 []
--            [ span
--                []
--                [ text "Remaining Tickets" ]
--            ]
--        , div []
--            (List.filter
--                (\ticket -> ticket.userId == Nothing)
--                    tickets
--                |> remainingTicketList
--            )
--        ]
--remainingTicketList : List Ticket -> List (Html Msg)
--remainingTicketList tickets =
--    List.map
--        (\ticket -> singleRemainingTicket ticket) tickets
--singleRemainingTicket : Ticket -> Html Msg
--singleRemainingTicket ticket =
--    let
--        innerDiv =
--            div []
--                [ div []
--                    [ div [] [ text ticket.date ]
--                    , div [] [ text ticket.opponent ]
--                    , div [] [ text ticket.time ]
--                    ]
--                ]
--    in
--        a [] [ innerDiv ]

--myTickets : Model -> Html Msg
--myTickets model =
--    let
--        myUserId = userIdFromName model.myUserName
--    in
--        div []
--            [ h1 []
--                [ span
--                    []
--                    [ text "My Tickets" ]
--                ]
--            , div []
--                (List.filter
--                    (\ticket -> ticket.userId == Just myUserId)
--                    model.tickets
--                    |> ticketList
--                )
--            ]
--userIdFromName : String -> List User -> Int
--userIdFromName name users =
--    List.filter (\user -> user.name == name) users
--        |> List.head
--        |> Maybe.withDefault nullUser
--        |> .id



--main : Program Never Model Msg
--main =
--  Html.program
--    { init = init 
--    , view = view
--    , update = update
--    , subscriptions = Cmd.none
--    }


module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as JD


{--Model--}


type alias Model =
   { names : List Image
   , error : String
   }


type alias Image =
   { name : String
   , image: String
   }

initModel : Model
initModel =
   { names = []
   , error = ""
   }


api : String
api =
   "http://api.giphy.com/v1/gifs/search?q=cake&api_key=4zqMjqn9oECYbu2ZwHgseweLyahB2IxR&limit=15"


getData : Http.Request (List Image)
getData =
   Http.get api getNames


getNames : JD.Decoder (List Image)
getNames =
   JD.field "data" (JD.list getName)


getName : JD.Decoder Image
getName =
   JD.map2 Image
       (JD.field "title" JD.string)
       (JD.at [ "images", "original_still", "url" ] JD.string)


type Msg
   = GotName
   | SetName (Result Http.Error (List Image))



{--Update--}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
   case msg of
       GotName ->
           ( model, Cmd.none )

       SetName (Ok names) ->
           ( { model | names = names }, Cmd.none )

       SetName (Err error) ->
           ( { model | error = toString error }, Cmd.none )


initialCmd : Cmd Msg
initialCmd =
   Http.send SetName getData



{--View--}


view : Model -> Html Msg
view model =
   div []
       [ ul []
           (List.map
               (\n ->
                   li []
                       [ button [onClick func] [h2 [] [ text ("Title : " ++ n.name) ]]
                       , img [src n.image] []
                       ]
               )
               model.names
           )
       ]


main : Program Never Model Msg
main =
   program
       { update = update
       , view = view
       , init = ( initModel, initialCmd )
       , subscriptions = \_ -> Sub.none
       }