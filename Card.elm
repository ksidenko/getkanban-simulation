module Card where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

-- MODEL

type alias Model =
    { analyticStoryPointsNeeded : Int
    , developmentStoryPointsNeeded  : Int
    , testingStoryPointsNeeded  : Int
    , countDices : Int
    , analyticStoryPointsCompleted : Int
    , developmentStoryPointsCompleted  : Int
    , testingStoryPointsCompleted  : Int
    }

init : Int -> Int -> Int -> Int -> Model
init a d t c =
    { analyticStoryPointsNeeded = a
    , developmentStoryPointsNeeded  = d
    , testingStoryPointsNeeded  = t
    , analyticStoryPointsCompleted = 0
    , developmentStoryPointsCompleted  = 0
    , testingStoryPointsCompleted  = 0
    , countDices = c
    }

-- UPDATE
type Action
    = SelectCard
    | DeselectCard

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
  span [ cardStyle ]
    [ div [] [ span [ ] [ text ("An: " ++ toString model.analyticStoryPointsNeeded ) ]
             , span [ ] [ text ("/") ]
             , span [ ] [ text (toString model.analyticStoryPointsCompleted ) ]
             ]
    , div [] [ span [ ] [ text ("Dev: " ++ toString model.developmentStoryPointsNeeded ) ]
             , span [ ] [ text ("/") ]
             , span [ ] [ text (toString model.developmentStoryPointsCompleted ) ]
             ]
    , div [] [ span [ ] [ text ("Test: " ++ toString model.testingStoryPointsNeeded ) ]
             , span [ ] [ text ("/") ]
             , span [ ] [ text (toString model.testingStoryPointsCompleted ) ]
             ]
    ]


cardStyle : Attribute
cardStyle =
  style
    [ ("font-size", "14px")
    , ("display", "inline-block")
    , ("width", "80px")
    , ("border", "1px dotted black")
    , ("text-align", "left")
    ]

