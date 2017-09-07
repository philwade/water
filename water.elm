import Html exposing (Html, div, text, span, button)
import Html.Events exposing (onClick)

main = Html.program { init = init, view = view, update = update, subscriptions = subscriptions }

type alias Model = { count: Int, goal: Int }

init : (Model, Cmd Msg)
init = ({ count = 0, goal = 8 }, Cmd.none)

type Msg = Increment

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Increment -> ({ model | count = model.count + 1 }, Cmd.none)


view : Model -> Html Msg
view model =
    div [] [ displayCount model
           , button [ onClick Increment ] [ text "+" ]
           , progressDisplay model
           , encouragementDisplay model
           ]

displayCount : Model -> Html Msg
displayCount model =
    if model.count == 0 then
        div [] [ text "Nothing yet, get drinking!" ]
    else
        div [] (List.repeat model.count waterImage)

progressDisplay : Model -> Html Msg
progressDisplay model =
    div [] [ text <| (toString model.count) ++ " / " ++ (toString model.goal) ]

encouragementDisplay : Model -> Html Msg
encouragementDisplay model =
    let
        halfway = model.goal // 2
    in
        if model.count == halfway then
            div [] [ text "halfway there! you got this!" ]
        else if model.count == model.goal then
            div [] [ text "you did it! hell yeah!" ]
        else if model.count > model.goal then
            div [] [ text "awwww damn getting extracurricular!" ]
        else
            span [] []

waterImage : Html Msg
waterImage = span [] [ text "🚰" ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
