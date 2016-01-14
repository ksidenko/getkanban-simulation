module Card where

import Dict exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

-- MODEL

type alias Model =
    { dicesCount : Int
    , storyPoints : List (String, String, Int, Int)
    }

init : (Int, Int, Int) -> Model
init (anLimit, devLimit, testLimit) =
    { dicesCount = 0
    , storyPoints = [ ("Analytic", "an: ", 2, anLimit)
                    , ("Development", "dev: ", 0, devLimit)
                    , ("Testing", "test: ", 0, testLimit)
                    ]
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
        ( List.map storyPointsView model.storyPoints )

storyPointsView : (String, String, Int, Int) -> Html
storyPointsView (title, shortTitle, neededStoryPoints, completedStoryPoints) =
    div []
      [ span [] [ text (shortTitle ++ toString neededStoryPoints) ]
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
