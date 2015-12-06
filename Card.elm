module Card where


import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

-- MODEL

type alias Model =
    { analyticStoryPointsAvailable : Int
    , devStoryPointsAvailable  : Int
    , testStoryPointsAvailable  : Int
    , countDices : Int
    }

init : Int -> Int -> Int -> Int -> Model
init a d t c =
    { analyticStoryPointsAvailable = a
    , devStoryPointsAvailable  = d
    , testStoryPointsAvailable  = t
    , countDices = c
    }

-- UPDATE
type Action = SelectCard | DeselectCard

update : Action -> Model -> Model
update action model =
  case action of
      SelectCard ->
          { model | countDices = 1 }
      DeselectCard ->
          { model | countDices = 0 }

-- VIEW

type alias Context =
    { actions : Signal.Address Action
    }

view: Context -> Model -> Html
view context model =
  span [ countStyle ]
    [ span [ ] [ text (toString model.analyticStoryPointsAvailable ) ]
    , span [ ] [ text (toString model.devStoryPointsAvailable) ]
    , span [ ] [ text (toString model.testStoryPointsAvailable) ]
    ]

countStyle : Attribute
countStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "50px")
    , ("border", "1px dotted black")
    , ("text-align", "center")
    ]
