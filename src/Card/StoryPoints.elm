module Card.StoryPoints where

import Html exposing (..)

-- MODEL --

type alias Model = (Int, Int)

init : Int -> Model
init limit =
    (0, limit)

isDone : Model -> Bool
isDone (actualPoints, completedPoints) =
    actualPoints == completedPoints


-- VIEW --

view : String -> Model -> Html
view title (actualPoints, completedPoints) =
    div []
      [ span []
        [ text (title ++ ": " ++ toString actualPoints)
        ]
      , span [] [ text "/" ]
      , span []
        [ text (toString completedPoints)
        ]
      ]
