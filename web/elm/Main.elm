module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Http exposing (Request)
import Json.Decode as JD
import Json.Encode as JE

{--Model--}


type alias Model =
   { names : List Giphy
   , users : List Backend
   , photo : String
   , error : String
   }


type alias Giphy = 
  { dataname : String
  , dataimage : String
  }

type alias Backend = 
  { username : String
  , userimage : String
  }

initModel : Model
initModel =
   { names = []
   , users = []
   , photo = ""
   , error = ""
   }

{-- Api --}

api : String
api =
   "http://api.giphy.com/v1/gifs/search?q=cake&api_key=4zqMjqn9oECYbu2ZwHgseweLyahB2IxR&limit=15"


getData : Http.Request (List Giphy)
getData =
   Http.get api getGiphies


getGiphies : JD.Decoder (List Giphy)
getGiphies =
   JD.field "data" (JD.list getGiphy)


getGiphy : JD.Decoder Giphy
getGiphy =
   JD.map2 Giphy
       (JD.field "title" JD.string)
       (JD.at [ "images", "original_still", "url" ] JD.string)

userapi : String
userapi =
   "http://localhost:4000/api/users/"


getBackendUsers : Http.Request (List Backend)
getBackendUsers =
   Http.get userapi getUsers


getUsers : JD.Decoder (List Backend)
getUsers =
   JD.list getUser


getUser : JD.Decoder Backend
getUser =
   JD.map2 Backend
       (JD.field "name" JD.string)
       (JD.field "pic" JD.string)

{-- Initial Command --}

initialCmd : Cmd Msg
initialCmd =
   Http.send GetDataFromBackend getBackendUsers


{-- Msg --}

type Msg
   = GetDataFromBackend (Result Http.Error (List Backend))
   | SetGiphyApi 
   | GetDataFromGiphy (Result Http.Error (List Giphy))
   | PostPic String
   | PicPosted (Result Http.Error String)


{--Update--}

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetDataFromBackend (Ok users) ->
            ( { model | users = users }, Cmd.none )

        GetDataFromBackend (Err error) ->
            ( { model | error = toString error }, Cmd.none )
        SetGiphyApi ->
            ( model, Http.send GetDataFromGiphy getData )

        GetDataFromGiphy (Ok names) ->
            ( { model | names = names }, Cmd.none)

        GetDataFromGiphy (Err error) ->
            ( { model | error = toString error }, Cmd.none )
        PostPic photo ->
            ( {model | photo = photo}, Http.send PicPosted (postData photo) )

        PicPosted (Ok photo) ->
            ( { model | photo = photo }, Cmd.none)

        PicPosted (Err error) ->
            ( { model | error = toString error }, Cmd.none )



{--View--}

view : Model -> Html Msg
view model =
   div []
        [ h1[] [text "This is the data from Backend"]
        , ul []
           (List.map
                (\n ->
                    li []
                        [ button [onClick SetGiphyApi] [h2 [] [ text ("Title : " ++ n.username) ]]
                        , img [src n.userimage] []
                        ]
                )
                model.users
           )

        , h1[] [text "This is the data from Giphy Api"]

        , if model.names == [] then
            div [][text "Hello"]
          else
            div [] [ul []
              (List.map
                (\n ->
                     li []
                         [ button [onClick (PostPic n.dataname) ] [h2 [] [ text ("Title : " ++ n.dataname) ]]
                         , img [src n.dataimage] []

                         ]
                )
                model.names
              )
            ]
       ]


{-- Main --}

main : Program Never Model Msg
main =
   program
       { update = update
       , view = view
       , init = ( initModel, initialCmd )
       , subscriptions = \_ -> Sub.none
       }



{-- Rough --}



backendapi : String 
backendapi =
   "http://localhost:4000/api/users/post/"


postData : String -> Http.Request String
postData name =
   Http.post backendapi (Http.jsonBody (postName name)) sendName

postName : String -> JE.Value
postName name =
    JE.object
        [ ( "name", JE.string name )]

sendName : JD.Decoder String 
sendName =
   JD.field "name" JD.string


