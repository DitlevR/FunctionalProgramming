module Employee exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick, onInput)
import Browser
import Http 
import Json.Decode exposing (Decoder, string, field, map3, at, int, list)

main = Browser.element
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

type alias Employee =
 { id: Int
 , name: String
 , email: String
 }

type alias EmployeeList = 
  { employees : List Employee  }




type Model 
 = Failure String
 | Waiting
 | Loading 
 | Succes (List Employee)
 | SingleSucces Employee


type Message 
 = Allemp
 | Allemployees (Result Http.Error (List Employee))
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
  Allemp ->
   (Loading, getAllemployees)

  Allemployees result ->
            case result of
                Ok employees -> (Succes employees, Cmd.none)
                Err error -> handleError error

  GetSingleEmpid ->
   (Loading, getSingleEmp)

  SingleEmpid result ->
   case result of 
    Ok singemp -> (SingleSucces singemp, Cmd.none)
    Err error -> handleError error






getAllemployees : Cmd Message
getAllemployees = Http.get 
 {url = "http://localhost:5000/allemployees"
 , expect = Http.expectJson Allemployees (list empDecoder)
 } 


getSingleEmp : Cmd Message 
getSingleEmp = Http.get
 {url = "http://localhost:4711/em1"
 , expect = Http.expectJson SingleEmpid empDecoder
 }


empDecoder : Decoder Employee {- Decoder afleverer en decoder der decoder en Employee-}
empDecoder = 
  map3 Employee
    (at ["id"] int)
    (at ["name"] string)
    (at ["email"] string)



viewEmployees : List Employee -> Html Message
viewEmployees employees =
    div []
        [ h3 [] [ text "Allemp" ]
        , table []
            ([ viewTableHeader ] ++ List.map viewEmployee employees)
        ]


viewEmployee : Employee -> Html Message
viewEmployee employee =
    tr []
        [ td []
            [ text (String.fromInt employee.id) ]
        , td []
            [ text employee.name ]
        , td []
            [ text employee.email ]
        ]

viewTableHeader : Html Message
viewTableHeader =
    tr []
        [ th []
            [ text "ID" ]
        , th []
            [ text "Name" ]
        , th []
            [ text "Email" ]
        ]



view : Model -> Html Message 
view model =
 case model of 
  Waiting -> div [] [button [ onClick Allemp ] [text "Click for all employees"], button [onClick GetSingleEmpid] [text"get emp with id 1"]]
  Failure msg -> text ("Something went wrong: "++msg)
  Loading -> text ("Loading")
  Succes employees -> viewEmployees employees

  SingleSucces singemp -> text ("singleemp is " ++ String.fromInt(singemp.id) ++ singemp.name ++ singemp.email )



subscriptions : Model -> Sub Message
subscriptions model = Sub.none
