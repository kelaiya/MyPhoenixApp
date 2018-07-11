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
   , photo : Webdata
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

type alias Webdata =
  { webname : String
  , webimage : String
  }

initModel : Model
initModel =
   { names = []
   , users = []
   , photo = webinit
   , search = ""
   , error = ""
   }

webinit : Webdata
webinit =
  { webname = ""
  , webimage = ""
  }

{-- Api --}

api : String
api =
   "http://api.giphy.com/v1/gifs/search?q=cake&api_key=4zqMjqn9oECYbu2ZwHgseweLyahB2IxR&limit=15"


getData : String -> Http.Request (List Giphy)
getData search =
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
   JD.map3 Backend
       (JD.field "name" JD.string)
       (JD.field "pic" JD.string)
       (JD.field "id" JD.int)

--failOnError : Result String a -> JD.Decoder a
--failOnError result =
--  case result of
--    Ok a ->
--      JD.succeed a
--    Err error ->
--      JD.fail error

{-- Initial Command --}

initialCmd : Cmd Msg
initialCmd =
   Http.send GetDataFromBackend getBackendUsers


{-- Msg --}

type Msg
   = GetDataFromBackend (Result Http.Error (List Backend))
   --| SetGiphyApi 
   | GetDataFromGiphy (Result Http.Error (List Giphy))
   | PostPic Webdata
   | PicPosted (Result Http.Error Webdata)
   | Search String
   | AddSearch



{--Update--}

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetDataFromBackend (Ok users) ->
            ( { model | users = users }, Cmd.none )

        GetDataFromBackend (Err error) ->
            ( { model | error = toString error }, Cmd.none )
        --SetGiphyApi ->
        --    ( model, Http.send GetDataFromGiphy getData )

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
        Search search ->
          ( { model | search = search}, Cmd.none )
        AddSearch ->
          ( { model | search = "" }, Http.send GetDataFromGiphy (getData model.search))



{--View--}

view : Model -> Html Msg
view model =
   div []
        [ h1[] [text "This is the data from Backend"]
        , ul []
           (List.map
                (\n ->
                    li []
                        [ button [onClick (PostPic n.username, n.userimage)] [h2 [] [ text ("Title : " ++ n.username) ]]
                        , img [src n.userimage] []
                        , h3 [] [text <| toString n.userid]
                        ]
                )
                model.users
           )
        , div []
            [ input [ type_ "text", value model.search, onInput Search] []
            , button [onClick AddSearch] [text "Add"]
            ]
        , if model.names == [] then
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


postData : String -> String -> Http.Request String
postData name image =
   Http.post backendapi (Http.jsonBody (postName name image)) sendName

postName : String -> String -> JE.Value
postName name image =
    JE.object
        [ ( "name", JE.string name )
        , ( "image", JE.string image )]

sendName : JD.Decoder String 
sendName =
   JD.map2 Webdata
    (JD.field "name" JD.string)
    (JD.field "image" JD.string)



