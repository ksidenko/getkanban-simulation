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

init : (Int, Int, Int) -> Model
init (anLimit, devLimit, testLimit) =
    { analyticPoints = (0, anLimit)
    , developmentPoints = (0, devLimit)
    , testingPoints = (0, testLimit)
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
    let bgColor = if model.dicesCount > 0 then "green" else "white"
    in
        span [ cardStyle bgColor, onClick context.actions ToggleSelectCard ]
            [ pointsView "An:" model.analyticPoints
            , pointsView "Dev:" model.developmentPoints
            , pointsView "Test:" model.testingPoints
            ]

pointsView : String -> (Int, Int) -> Html
pointsView title points =
    div []
        [ span [] [ text (title ++ toString (fst points)) ]
        , span [] [ text "/" ]
        , span [] [ text (toString (snd points)) ]
        ]

cardStyle : String -> Attribute
cardStyle bgColor =
    style
        [ ("font-size", "14px")
        , ("display", "inline-block")
        , ("width", "80px")
        , ("border", "1px dotted black")
        , ("text-align", "left")
        , ("background-color", bgColor)
        ]
