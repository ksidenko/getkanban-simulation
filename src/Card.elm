module Card where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

-- MODEL

type alias Model =
    { analyticStoryPoints : (Int, Int)
    , developmentStoryPoints : (Int, Int)
    , testingStoryPoints : (Int, Int)
    , dicesCount : Int
    }

init : (Int, Int, Int) -> Model
init (anLimit, devLimit, testLimit) =
    { analyticStoryPoints = (0, anLimit)
    , developmentStoryPoints = (0, devLimit)
    , testingStoryPoints = (0, testLimit)
    , dicesCount = 0
    }

-- UPDATE

type Action
    = ToggleSelectCard

update : Action -> Model -> Model
update action model =
  case action of
    ToggleSelectCard ->
      { model | dicesCount = if model.dicesCount == 1 then 0 else 1 }

-- VIEW

type alias Context =
    { actions : Signal.Address Action
    }

view : Context -> Model -> Html
view context model =
    let bgColor = if model.dicesCount > 0 then "green" else "white"
    in
        span [ cardStyle bgColor, onClick context.actions ToggleSelectCard ]
            [ storyPointsView "An:" model.analyticStoryPoints
            , storyPointsView "Dev:" model.developmentStoryPoints
            , storyPointsView "Test:" model.testingStoryPoints
            ]

storyPointsView : String -> (Int, Int) -> Html
storyPointsView title (neededStoryPoints, completedStoryPoints) =
    div []
        [ span [] [ text (title ++ toString neededStoryPoints) ]
        , span [] [ text "/" ]
        , span [] [ text (toString completedStoryPoints) ]
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
