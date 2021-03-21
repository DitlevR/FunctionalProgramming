module Hello exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick, onInput)
import Browser
import Http 
import Json.Decode exposing (Decoder, string, field, map3, at)

main = Browser.element
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

type alias Employee =
 { name: String
 , email: String
 }



type Model 
 = Failure String
 | Waiting
 | Loading 
 | Succes String
 | SingleSucces Employee


type Message 
 = TryAgainPlease
 | GreetingResult (Result Http.Error String)
 | SingleEmpid (Result Http.Error Employee)
 | GetSingleEmpid



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
  TryAgainPlease ->
   (Loading, getGreeting)

  GreetingResult result ->
            case result of
                Ok greeting -> (Succes greeting, Cmd.none)
                Err error -> handleError error

  GetSingleEmpid ->
   (Loading, getSingleEmp)

  SingleEmpid result ->
   case result of 
    Ok singemp -> (SingleSucces singemp, Cmd.none)
    Err error -> handleError error






getGreeting : Cmd Message
getGreeting = Http.get 
 {url = "http://localhost:5000/allemployees"
 , expect = Http.expectString GreetingResult
 }


getSingleEmp : Cmd Message
getSingleEmp = Http.get
 {url = "http://localhost:5000/employee/1"
 , expect = Http.expectJson SingleEmpid empDecoder
 }


empDecoder : Decoder Employee {- Decoder afleverer en decoder der decoder en Employee-}
empDecoder = 
  map3 Employee
    (at ["id"] string)
    (at ["name"] string)
    (at ["email"] string)
    

 
 
 



view : Model -> Html Message 
view model =
 case model of 
  Waiting -> div [] [button [ onClick TryAgainPlease ] [text "Click for greeting"], button [onClick GetSingleEmpid] [text"get single emp"]]
  Failure msg -> text ("Something went wrong: "++msg)
  Loading -> text ("Loading")
  Succes greeting -> text ("The greeting was: " ++ greeting)
  SingleSucces singemp -> text ("singleemp is " ++ singemp.name )



subscriptions : Model -> Sub Message
subscriptions model = Sub.none
