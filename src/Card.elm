module Card where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dict exposing (Dict)

import Card.StoryPoints as StoryPoints

-- MODEL

type alias Model =
    { dicesCount : Int
    , storyPoints : Dict String StoryPoints.Model
    }

init : (Int, Int, Int) -> Model
init (anLimit, devLimit, testLimit) =
    { dicesCount = 0
    , storyPoints =
        Dict.fromList
            [ ("Analytic", StoryPoints.init anLimit)
            , ("Development", StoryPoints.init devLimit)
            , ("Testing", StoryPoints.init testLimit)
            ]
    }

isDone : String -> Model -> Bool
isDone storyPointsTitle model =
    let pointsForCheck = Dict.get storyPointsTitle model.storyPoints
    in
        case pointsForCheck of
            Just points -> StoryPoints.isDone points
            Nothing -> Debug.crash "ololo"

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
            [ StoryPoints.view "An" (Maybe.withDefault (-1, -1) (Dict.get "Analytic" model.storyPoints))
            , StoryPoints.view "Dev" (Maybe.withDefault (-1, -1) (Dict.get "Development" model.storyPoints))
            , StoryPoints.view "Test" (Maybe.withDefault (-1, -1) (Dict.get "Testing" model.storyPoints))
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
