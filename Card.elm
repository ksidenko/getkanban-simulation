module Card where


import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

-- MODEL

type alias Model =
    { analyticStoryPointsAvailable : Int
    , devStoryPointsAvailable  : Int
    , testStoryPointsAvailable  : Int
    }

init : Int -> Int -> Int -> Model
init a d t =
    { analyticStoryPointsAvailable = a
    , devStoryPointsAvailable  = d
    , testStoryPointsAvailable  = t
    }

-- UPDATE
type Action = Increment | Decrement | Reset

update : Action -> Model -> Model
update action model =
  case action of
    Reset ->
        init 7 7 7

    Increment ->
        { model |
            analyticStoryPointsAvailable = model.analyticStoryPointsAvailable + 1
        }

    Decrement ->
        { model |
            analyticStoryPointsAvailable = model.analyticStoryPointsAvailable - 1
        }

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ button [ onClick address Decrement ] [ text "-" ]
    , div [ countStyle ] [ text (toString model.analyticStoryPointsAvailable ) ]
    , div [ countStyle ] [ text (toString model.devStoryPointsAvailable) ]
    , div [ countStyle ] [ text (toString model.testStoryPointsAvailable) ]
    , button [ onClick address Increment ] [ text "+" ]
    , button [ onClick address Reset ] [ text "reset" ]
    ]


countStyle : Attribute
countStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "50px")
    , ("text-align", "center")
    ]
