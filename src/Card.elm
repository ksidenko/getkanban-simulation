module Card where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

-- MODEL

type alias Model =
    { analyticPoints : (Int, Int)
    , developmentPoints : (Int, Int)
    , testingPoints : (Int, Int)
    , dicesCount : Int
    }

init : Int -> Int -> Int -> Model
init analiticLimit developmentLimit testingLimit =
    { analyticPoints = (0, analiticLimit)
    , developmentPoints = (0, developmentLimit)
    , testingPoints = (0, testingLimit)
    , dicesCount = 0
    }

-- UPDATE

type Action
    = ToggleSelectCard

update : Action -> Model -> Model
update action model =
  case action of
    ToggleSelectCard ->
      { model | dicesCount = model.dicesCount + 1 }

-- VIEW

type alias Context =
    { actions : Signal.Address Action
    }

view : Context -> Model -> Html
view context model =
  let
    cssSelectCard = if model.dicesCount > 0 then "green" else "white"
  in
    span [ (cardStyle cssSelectCard), onClick context.actions ToggleSelectCard ]
      [ renderPoints "An:" model.analyticPoints
      , renderPoints "Dev:" model.developmentPoints
      , renderPoints "Test:" model.testingPoints
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

renderPoints : String -> (Int, Int) -> Html
renderPoints title points =
  div [] [ span [ ] [ text (title ++ toString (fst points)) ]
         , span [ ] [ text ("/") ]
         , span [ ] [ text (toString (snd points)) ]
         ]
