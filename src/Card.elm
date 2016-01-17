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


unsafeStoryPoint : String -> Model -> StoryPoints.Model
unsafeStoryPoint storyPointsTitle model =
  let pointsForCheck = Dict.get storyPointsTitle model.storyPoints
  in
    case pointsForCheck of
      Just points -> points
      Nothing -> Debug.crash ("Debug.crash info message: no such Story Point title " ++ storyPointsTitle )


isDone : String -> Model -> Bool
isDone storyPointsTitle model =
  unsafeStoryPoint storyPointsTitle model
    |> StoryPoints.isDone


-- UPDATE

type Action
    = ToggleSelectCard
    | MoveRight

update : Action -> Model -> Model
update action model =
  case action of
    ToggleSelectCard ->
      { model | dicesCount = if model.dicesCount == 1 then 0 else 1 }

    MoveRight ->
      model

-- VIEW

type alias Context =
    { actions : Signal.Address Action
    , move : Signal.Address ()
    , del : Signal.Address ()
    }

view : Context -> Model -> Html
view context model =
    let
      bgColor = if model.dicesCount > 0 then "green" else "white"
    in
    div [] [
        span [ cardStyle bgColor, onClick context.actions ToggleSelectCard ]
            [ StoryPoints.view "An" <| unsafeStoryPoint "Analytic" model
            , StoryPoints.view "Dev" <| unsafeStoryPoint "Development" model
            , StoryPoints.view "Test" <| unsafeStoryPoint "Testing" model
            ]
            , div [] [ button [ onClick context.move () ] [ text "-> " ]
                     , button [ onClick context.del () ] [ text "x" ]
                     ]
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
