module Column.Header (Model, init, Action, view, Context) where

import Html exposing (..)
import Html.Events exposing (onClick)


-- MODEL --


type alias Model =
  { name : String
  , wipLimit : Int
  , dicesCount : Int
  }


-- UPDATE --


type Action
    = AddCard


type alias Context =
    { actions : Signal.Address Action
    }


-- VIEW --


init : String -> Int -> Int -> Model
init name wipLimit dicesCount =
    { name = name
    , wipLimit = wipLimit
    , dicesCount = dicesCount
    }


view : Context -> Model -> Html
view context model =
  div []
    [ div [] [ text ( model.name ++ " (" ++ toString(model.wipLimit) ++ ")") ]
    , hr [] []
    , div [] [ text ( "Dices: " ++ toString (model.dicesCount ) ) ]
    , div [] [ button [ onClick context.actions AddCard ] [ text "Add Card" ] ]
    ]

