module Department exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick, onInput)
import Browser
import Http 
import Json.Decode exposing (Decoder, string, field, map4, at, int, list)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid



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



type alias Departmentlist = 
  { departments : List Department  }


type Model
 = Waiting 
 | Loading 
 | Succes (List Department)
 | Failure String


type Message 
 = GetDepartments (Result Http.Error (List Department))
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
     Ok departments -> (Succes departments, Cmd.none)
     Err error -> handleError error


getDepartments: Cmd Message
getDepartments = Http.get 
 {url = "http://localhost:5000/department/alldep"
 , expect = Http.expectJson GetDepartments (list depDecoder)
 } 



depDecoder : Decoder Department 
depDecoder = 
  map4 Department
    (at ["description"] string)
    (at ["employee_id"] int)
    (at ["id"] int)
    (at ["name"] string)



viewDeparments : List Department -> Html Message
viewDeparments departments =
    div []
        [ h3 [] [ text "All departments" ]
        , table []
            ([ viewTableHeader ] ++ List.map viewDepartment departments)
        ] 


viewDepartment : Department -> Html Message
viewDepartment department =
    tr []
        [ td []
            [ text department.desc ]
        , td []
            [ text (String.fromInt department.employee_id) ]
        , td []
            [ text (String.fromInt department.id) ]
        , td []
            [ text department.name ]
        ]

viewTableHeader : Html Message
viewTableHeader =
    tr []
        [ th []
            [ text "Description" ]
        , th []
            [ text "Employee_id" ]
        , th []
            [ text "Id" ]
         , th []
            [ text "name" ]
        ]




view : Model -> Html Message
view model = 
 case model of 
 Waiting -> Grid.container [] [ button [ onClick Alldep ] [text "Click for all departments"] ]
 Loading -> text ("Jeg loader")
 Succes departments -> viewDeparments departments 
 Failure msg -> text ("Something went wrong: "++msg)



subscriptions : Model -> Sub Message
subscriptions model = Sub.none
