module Test exposing (..)


import Html exposing (button, div, text)
import Html.App exposing(begrinnerProgram)
import Html.Events exposing (onClick)


initModel = 0 


type Msg = Increment | Decrement


update msg model = 
 case msg of
  Increment ->
   model + 1 

  Decrement -> 
   model - 1



view model = 
 div [] 
  [ button [onClick Decrement ] [text "-"]
  , div [] [text (model) ]
  , button [onClick Increment] [text "+"]
  ]


main = begrinnerProgram {model = model, view = view, update = update}