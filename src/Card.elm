module Card where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

-- MODEL

type alias Model =
    { analyticStoryPointsNeeded : Int
    , developmentStoryPointsNeeded  : Int
    , testingStoryPointsNeeded  : Int
    , analyticStoryPointsCompleted : Int
    , developmentStoryPointsCompleted  : Int
    , testingStoryPointsCompleted  : Int
    , countDices : Int
    , selected : Bool
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
    , selected = False
    }

-- UPDATE

type Action
    = ToggleSelectCard

update : Action -> Model -> Model
update action model =
  case action of
    ToggleSelectCard ->
      { model | selected = not model.selected }

-- VIEW

type alias Context =
    { actions : Signal.Address Action
    }

view : Context -> Model -> Html
view context model =
  let
    cssSelectCard = if model.selected then "green" else "white"
  in
    span [ (cardStyle cssSelectCard) , onClick context.actions ToggleSelectCard ]
      [ renderNeedAndCompletedSP "An:" model.analyticStoryPointsNeeded model.analyticStoryPointsCompleted
      , renderNeedAndCompletedSP "Dev:" model.developmentStoryPointsNeeded model.developmentStoryPointsCompleted
      , renderNeedAndCompletedSP "Test:" model.testingStoryPointsNeeded model.testingStoryPointsCompleted
      ]


cardStyle : String -> Attribute
cardStyle cssSelectCard =
  style
    [ ("font-size", "14px")
    , ("display", "inline-block")
    , ("width", "80px")
    , ("border", "1px dotted black")
    , ("text-align", "left")
    , ("background-color", cssSelectCard)
    ]


renderNeedAndCompletedSP : String -> Int -> Int -> Html
renderNeedAndCompletedSP title needSP completedSP =
  div [] [ span [ ] [ text (title ++ toString needSP) ]
         , span [ ] [ text ("/") ]
         , span [ ] [ text (toString completedSP) ]
         ]
