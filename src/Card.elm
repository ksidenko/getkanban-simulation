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

getStoryPoints : String -> Model -> StoryPoints.Model
getStoryPoints storyPointsTitle model =
  let pointsForCheck = Dict.get storyPointsTitle model.storyPoints
  in
    case pointsForCheck of
      Just points -> points
      Nothing -> Debug.crash ("Debug.crash info message: no such Story Point title " ++ storyPointsTitle )


isDone : String -> Model -> Bool
isDone storyPointsTitle model =
  getStoryPoints storyPointsTitle model
    |> StoryPoints.isDone


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
    let 
      bgColor = if model.dicesCount > 0 then "green" else "white"
    in
        span [ cardStyle bgColor, onClick context.actions ToggleSelectCard ]
            [ StoryPoints.view "An" <| getStoryPoints "Analytic" model
            , StoryPoints.view "Dev" <| getStoryPoints "Development" model
            , StoryPoints.view "Test" <| getStoryPoints "Testing" model
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
