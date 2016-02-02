module Column (Model, init,  view, Context ) where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

import Card
import Card.StoryPoints
import Column.Header


-- MODEL

type alias Model =
    { hasDone: Bool
    , header: Column.Header.Model
    }

type alias ID = Int
type alias CardID = Int


init : String -> Int -> Int -> Bool -> Model
init name dicesCount wipLimit hasDone =
    { hasDone = hasDone
    , header = Column.Header.init name wipLimit dicesCount
    }

-- UPDATE

-- VIEW

type alias Context =
  --{ cardModify: Signal.Address CardID 
  { cardMove: Signal.Address CardID
  , cardDel: Signal.Address CardID
  }

view : Context -> List ( ID, Card.Model ) -> Model -> Html
view context cards model =
  let
    width = if model.hasDone == False then 92 else 185
    --contextHeader = Column.Header.Context
        --(Signal.forwardTo context.actions (always ( AddCard ( Card.init (2,3,2) ))))
  in
    div [ columnStyle width ]
      [ Column.Header.view model.header
      , columnView context cards width model
      ]

columnView : Context -> List ( ID, Card.Model ) -> Int -> Model -> Html
columnView context cards widthCss model =
  let
    columnList =
      if not model.hasDone then -- only one column
        [ subColumnView context cards widthCss ]
      else
        let
          widthCssOffset = 15
          f storyPointsTitle ( _, card ) = not <| Card.isDone storyPointsTitle card
          (inProgressCards, doneCards) = List.partition ( f model.header.name ) cards
        in
          [ subColumnView context inProgressCards (widthCss // 2 - widthCssOffset )
          , subColumnView context doneCards (widthCss // 2 - widthCssOffset )
          ]
  in
    div [] ( columnList )


subColumnView : Context -> List (ID, Card.Model) -> Int -> Html
subColumnView context cards widthCss =
  div [ columnStyle (widthCss) ] [ div [] (List.map (cardView context) cards) ]


cardView : Context -> (ID, Card.Model) -> Html
cardView context (id, model) =
  let context' =
    Card.Context
        --(Signal.forwardTo context.cardModify (id) )
        (Signal.forwardTo context.cardMove (always ( id )))
        (Signal.forwardTo context.cardDel (always ( id )))
  in
    Card.view context' model


columnStyle : Int -> Attribute
columnStyle cssColumnWidth =
  style
    [ ("display", "inline-block")
    , ("width", toString(cssColumnWidth) ++ "px")
    , ("float", "left")
    , ("border", "1px solid green")
    , ("margin-right", "10px")
    ]
