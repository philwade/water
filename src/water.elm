import Html exposing (Html, div, text, span, button, img, input, a)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (class, classList, attribute, value)

main = Html.program { init = init, view = view, update = update, subscriptions = subscriptions }

type alias Model = { count: Int, goal: Int, editingGoal: Bool }

init : (Model, Cmd Msg)
init = ({ count = 0, goal = 8, editingGoal = False }, Cmd.none)

type Msg = Increment | OpenEditGoal | CloseEditGoal | ChangeGoal String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Increment -> ({ model | count = model.count + 1 }, Cmd.none)
        CloseEditGoal -> ({ model | editingGoal = False }, Cmd.none)
        OpenEditGoal -> ({ model | editingGoal = True }, Cmd.none)
        ChangeGoal newGoal ->
            case String.toInt newGoal of
                Ok goal -> ({ model | goal = goal }, Cmd.none)
                Err _ -> (model, Cmd.none)


view : Model -> Html Msg
view model =
    div [] [ div [ class "display" ] [ displayCount model
                                     , button [ class "increment", onClick Increment ] [ text "+" ]
                                     , progressDisplay model
                                     , encouragementDisplay model
                                     , span [ class "toggle-modal" ] [ a [ onClick OpenEditGoal ] [ text "change goal" ] ]
                                     ]
           , displayModal model
           ]

displayModal : Model -> Html Msg
displayModal model =
    div [ classList
            [ ("modal", True)
            , ("hidden", not model.editingGoal)
            ]
        ]
        [ div
            [ class "modal-content" ]
            [ text "The standard recommendation for water is 64 oz or 1800 ml. Akaeight 8 oz glasses. Adjust your goal according to the size of your cup and goals!"
            , span [ class "close-modal" ] [ a [ onClick CloseEditGoal ] [ text "X" ] ]
            , input [ value (toString model.goal), onInput ChangeGoal ] [ ]
            ]
        ]

displayCount : Model -> Html Msg
displayCount model =
    if model.count == 0 then
        div [ class "display-text" ] [ text "Nothing yet, get drinking!" ]
    else
        div [ class "display-emoji" ] (List.repeat model.count waterImage)

progressDisplay : Model -> Html Msg
progressDisplay model =
    div [ class "progress" ] [ text <| (toString model.count) ++ " / " ++ (toString model.goal) ]

encouragementDisplay : Model -> Html Msg
encouragementDisplay model =
    let
        halfway = model.goal // 2
    in
        if model.count == halfway then
            div [ class "comment-half" ] [ text "halfway there! you got this!" ]
        else if model.count == model.goal then
            div [ class "comment-success"] [ text "you did it! hell yeah!" ]
        else if model.count > model.goal then
            div [] [ text "awwww damn getting extracurricular!" ]
        else
            span [] []

waterImage : Html Msg
waterImage = span [] [ img [ class "water-img", attribute "src" "water.png" ] [] ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
