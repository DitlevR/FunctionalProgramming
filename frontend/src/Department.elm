module Department exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick, onInput)
import Browser
import Http 
import Json.Decode exposing (Decoder, string, field, map3, at, int)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid



main = Browser.element
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }



type alias Department = 
 {   id: Int
   , name: String
   , desc: String
 }


type Model
 = Waiting 
 | Loading 
 | Succes String
 | Failure String


type Message 
 = GetDepartments (Result Http.Error String)
 | Alldep

init : () -> (Model, Cmd Message)
init _ = (Waiting, Cmd.none)


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




update : Message -> Model -> (Model, Cmd Message)
update message model = 
 case message of 
  Alldep ->
   (Loading, getDepartments)
 
 
  GetDepartments result ->
     case result of 
     Ok getAllDepartments -> (Succes getAllDepartments, Cmd.none)
     Err error -> handleError error


getDepartments: Cmd Message
getDepartments = Http.get 
 {url = "http://localhost:5000/department/alldep"
 , expect = Http.expectString GetDepartments
 } 



view : Model -> Html Message
view model = 
 case model of 
 Waiting -> Grid.container [] [ button [ onClick Alldep ] [text "Click for all departments"] ]
 Loading -> text ("Jeg loader")
 Succes getAllDepartments -> text ("All deparments " ++ getAllDepartments)
 Failure msg -> text ("Something went wrong: "++msg)



subscriptions : Model -> Sub Message
subscriptions model = Sub.none