module Card (update, view, Model, Context, Status(..), isDone, init, Action(..)) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Card.StoryPoints as StoryPoints

-- MODEL

type alias Model =
    { status : Status
    , dicesCount : Int
    , analyticStoryPoints : StoryPoints.Model
    , developmentStoryPoints : StoryPoints.Model
    , testingStoryPoints : StoryPoints.Model
    }

init : (Int, Int, Int) -> Model
init (anLimit, devLimit, testLimit) =
    { status = Selected
    , dicesCount = 0
    , analyticStoryPoints = StoryPoints.init anLimit
    , developmentStoryPoints = StoryPoints.init devLimit
    , testingStoryPoints = StoryPoints.init testLimit
    }

isDone : String -> Model -> Bool
isDone storyPointsTitle model =
  let storyPoints = case storyPointsTitle of
    "Analytic" -> model.analyticStoryPoints
    "Development" -> model.developmentStoryPoints
    "Testing" -> model.testingStoryPoints
    _ -> model.analyticStoryPoints
  in
     StoryPoints.isDone storyPoints


-- UPDATE

type Action
    = ToggleSelectCard
    | NextStatus

type Status
    = Backlog
    | Selected
    | Analytic
    | Development
    | Testing
    | ReadyForDeploy
    | Deploy

update : Action -> Model -> Model
update action model =
  case action of
    ToggleSelectCard ->
      { model |
          dicesCount = if model.dicesCount == 1 then 0 else 1
      }

    NextStatus ->
      { model |
          status = case model.status of
                          Backlog -> Selected
                          Selected -> Analytic
                          Analytic -> Development
                          Development -> Testing
                          Testing -> ReadyForDeploy
                          ReadyForDeploy -> Deploy
                          Deploy -> Deploy
      }

-- VIEW

type alias Context =
    --{ actions : Signal.Address Action
    { move : Signal.Address ()
    , del : Signal.Address ()
    }

view : Context -> Model -> Html
view context model =
    let
      bgColor = if model.dicesCount > 0 then "green" else "white"
    in
    div [] [
        span [ cardStyle bgColor
             --, onClick context.actions ToggleSelectCard
             ]
            [ StoryPoints.view "An" model.analyticStoryPoints
            , StoryPoints.view "Dev" model.developmentStoryPoints
            , StoryPoints.view "Test" model.testingStoryPoints
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
