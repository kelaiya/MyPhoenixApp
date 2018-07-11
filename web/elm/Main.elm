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
   { frontend : List Giphy
   , backend : List Backend
   , favorite : Favorite
   , search : String
   , error : String
   }

type alias Giphy = 
  { dataname : String
  , dataimage : String
  }

type alias Backend = 
  { username : String
  , userimage : String
  , userid : Int
  }

type alias Favorite =
  { webname : String
  , webid : Int
  }

initModel : Model
initModel =
   { frontend = []
   , backend = []
   , favorite = webinit
   , search = ""
   , error = ""
   }

webinit : Favorite
webinit =
  { webname = ""
  , webid = 0
  }

{-- Api --}

{-- Giphy Api --}

getDataFromGiphy : String -> Http.Request (List Giphy)
getDataFromGiphy search =
  let
    giphyapi = "http://api.giphy.com/v1/gifs/search?q=" ++ search ++ "&api_key=4zqMjqn9oECYbu2ZwHgseweLyahB2IxR&limit=15"
      
  in
      
   Http.get giphyapi getGiphies


getGiphies : JD.Decoder (List Giphy)
getGiphies =
   JD.field "data" (JD.list getGiphy)


getGiphy : JD.Decoder Giphy
getGiphy =
   JD.map2 Giphy
       (JD.field "title" JD.string)
       (JD.at [ "images", "original_still", "url" ] JD.string)

{-- Backend Api --}

backendapi : String
backendapi =
   "http://localhost:4000/api/users/"


getBackendData : Http.Request (List Backend)
getBackendData =
   Http.get backendapi getDataFromUser


getDataFromUser : JD.Decoder (List Backend)
getDataFromUser =
   JD.list getUser


getUser : JD.Decoder Backend
getUser =
   JD.map3 Backend
       (JD.field "name" JD.string)
       (JD.field "pic" JD.string)
       (JD.field "id" JD.int)

{-- Favorite Api --} 

favoriteapi : String 
favoriteapi =
   "http://localhost:4000/api/users/post/"


postData : String -> Int -> Http.Request Favorite
postData name id =
   Http.post favoriteapi (Http.jsonBody (postFavData name id)) sendData

postFavData : String -> Int -> JE.Value
postFavData name id =
    JE.object
        [ ( "name", JE.string name )
        , ( "webid", JE.int id )]

sendData : JD.Decoder Favorite 
sendData =
   JD.map2 Favorite
    (JD.field "name" JD.string)
    (JD.field "webid" JD.int)


{-- Initial Command --}

initialCmd : Cmd Msg
initialCmd =
   Http.send GetDataFromBackend getBackendData


{-- Msg --}

type Msg
   = GetDataFromBackend (Result Http.Error (List Backend))
   | GetDataFromGiphy (Result Http.Error (List Giphy))
   | PostData String Int
   | DataPosted (Result Http.Error Favorite)
   | Search String
   | AddSearch



{--Update--}

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetDataFromBackend (Ok backend) ->
            ( { model | backend = backend }, Cmd.none )

        GetDataFromBackend (Err error) ->
            ( { model | error = toString error }, Cmd.none )
        

        GetDataFromGiphy (Ok frontend) ->
            ( { model | frontend = frontend }, Cmd.none)

        GetDataFromGiphy (Err error) ->
            ( { model | error = toString error }, Cmd.none )
        

        PostData name webid ->
            ( model, Http.send DataPosted (postData name webid) )

        DataPosted (Ok favorite) ->
            ( { model | favorite = favorite }, Cmd.none)

        DataPosted (Err error) ->
            ( { model | error = toString error }, Cmd.none )
        

        Search search ->
          ( { model | search = search}, Cmd.none )
        AddSearch ->
          ( { model | search = "" }, Http.send GetDataFromGiphy (getDataFromGiphy model.search))



{--View--}

view : Model -> Html Msg
view model =
   div []
        [ h1[] [text "This is the data from Backend"]
        , ul []
           (List.map
                (\n ->
                    li []
                        [ button [onClick (PostData n.username n.userid)] [h2 [] [ text ("Title : " ++ n.username) ]]
                        , img [src n.userimage] []
                        , h3 [] [text <| toString n.userid]
                        ]
                )
                model.backend
           )
        , div []
            [ input [ type_ "text", value model.search, onInput Search] []
            , button [onClick AddSearch] [text "Add"]
            ]
        , if model.frontend == [] then
            div [][text "Hello"]
          else
            div [] 
              [ h1[] [text "This is the data from Giphy Api"]
              , ul []
                (List.map
                  (\n ->
                       li []
                           [ button [] [h2 [] [ text ("Title : " ++ n.dataname) ]]
                           , img [src n.dataimage] []

                           ]
                  )
                  model.frontend
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






