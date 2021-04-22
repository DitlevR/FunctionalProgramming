module PostList exposing (..)

import Browser
import Html exposing (Html, Attribute, div, input, text, li, button)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Html.Events exposing (onClick)
import Post exposing (Department)
import Bootstrap.Form.Input exposing (email)



-- MAIN


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }



-- MODEL



type alias Listofthings =
    { name : String
    , email : String
    , department : String
    }


type alias Model =
  { text : String
  , newlist : List Listofthings
  }


init : ( Model, Cmd Msg )
init =
  ( { text = ""
    , newlist =
              [{name = "james", email = "james@mail.dk", department ="HR"}
             ,  {name = "james", email = "james@mail.dk", department ="HR"}
             ] 
        }
    , Cmd.none
    )



-- UPDATE


type Msg
  = Addperson String



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
       Addperson ->
          ( addPerson model, Cmd.none )
    
    
      



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "Text to reverse", value model.content, onInput Change ] []
    , button [onClick  (AddtoList)] [ text "Add to list" ]
    , div [] [ li [] [ text ( model.content)] ]
    ]
