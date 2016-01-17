module Column.Header (Model, init, view, Context) where


import Html exposing (..)
import Html.Events exposing (onClick)

-- MODEL --

type alias Model =
  { name : String
  , wipLimit : Int
  , dicesCount : Int
  }

init : String -> Int -> Int -> Model
init name wipLimit dicesCount =
    { name = name
    , wipLimit = wipLimit
    , dicesCount = dicesCount
    }

-- UPDATE --



-- VIEW --

type alias Context =
    { actions : Signal.Address ()
    }

view : Context -> Model -> Html
view context model =
  div []
    [ div [] [ text ( model.name ++ " (" ++ toString(model.wipLimit) ++ ")") ]
    , hr [] []
    , div [] [ text ( "Dices: " ++ toString (model.dicesCount ) ) ]
    , div [] [ button [ onClick context.actions () ] [ text "Add Card" ] ]
    ]


