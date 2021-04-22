module Post exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick, onInput)
import Browser
import Http 
import Json.Decode exposing (Decoder, string, field, map4, at, int, list)
import Department exposing (Department)
import Json.Encode as Encode



main = Browser.element
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }


type alias Department = 
 {   desc: String 
   , employee_id: Int
   , id: Int 
   , name: String
 }

 type Model
 = Waiting 
 | Loading 
 | Succes (Department)
 | Failure String

handleError : Http.Error -> (Model, Cmd Message)
handleError error =
    case error of
        Http.BadStatus code ->
          (Failure <| "Code: "++(String.fromInt code), Cmd.none)
        Http.NetworkError ->
          (Failure "Network Error", Cmd.none)
        Http.BadBody err ->
          (Failure <| "Bad Body: "++err, Cmd.none)
        Http.Timeout ->
          (Failure "Timeout", Cmd.none)
        Http.BadUrl string ->
          (Failure <| "Bad Url: "++string, Cmd.none)


type Message
  = GotDepartment (Result Http.Error String)


postDepartment : Cmd Message
postDepartment =
  Http.post
    { url = "http://localhost:5000/department/alldep"
    , body = Http.emptyBody
    , expect = Http.expectJson GotDepartment (depDecoder)
    }


depDecoder : Decoder Department 
depDecoder = 
  map4 Department
    (at ["description"] string)
    (at ["employee_id"] int)
    (at ["id"] int)
    (at ["name"] string)



view : Model -> Html Message
view model = 
 case model of 
 Waiting -> Grid.container [] [ button [ onClick Alldep ] [text "Click for all departments"] ]
 Loading -> text ("Jeg loader")
 Succes departments -> viewDeparments departments 
 Failure msg -> text ("Something went wrong: "++msg)



subscriptions : Model -> Sub Message
subscriptions model = Sub.none
