module Column (Model, init, update, view, Action(AddCard, DelCard), Context ) where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Dict exposing (Dict)

import Card
import Card.StoryPoints
import Column.Header


-- MODEL

type alias Model =
    { cards: List ( ID, Card.Model )
    , nextID : ID
    , hasDone: Bool
    , header: Column.Header.Model
    }

type alias ID = Int
type alias CardID = Int


init : String -> Int -> Int -> Bool -> Model
init name dicesCount wipLimit hasDone =
    { cards = []
    , nextID = 0
    , hasDone = hasDone
    , header = Column.Header.init name wipLimit dicesCount
    }

-- UPDATE

type Action
    = AddCard Card.Model
    | DelCard ID
    | EditCard ID Card.Action


update : Action -> Model -> Model
update action model =
  case action of
    AddCard card ->
      { model
        | cards = ( model.nextID, card ) :: model.cards
        , nextID = model.nextID + 1
      }

    DelCard id ->
      { model
        | cards = List.filter (\(cardId, _) -> cardId /= id) model.cards
      }

    EditCard id cardAction ->
      let updateCard (cardID, cardModel) =
        if cardID == id
            then (cardID, Card.update cardAction cardModel)
            else (cardID, cardModel)
      in
        { model | cards = List.map updateCard model.cards }

-- VIEW

type alias Context =
    { actions : Signal.Address Action
    , move: Signal.Address CardID
    }

view : Context -> Model -> Html
view context model =
  let
    width = (\hasDone -> if hasDone == False then 92 else 185) model.hasDone
    contextHeader = Column.Header.Context
        (Signal.forwardTo context.actions (always ( AddCard ( Card.init (2,3,2) ))))
  in
    div [ columnStyle width ]
      [ Column.Header.view contextHeader model.header
      , columnView context width model
      ]

columnView : Context -> Int -> Model -> Html
columnView context widthCss model =
  let
    columnList =
      if not model.hasDone then -- only one column
        [ subColumnView context model.cards widthCss ]
      else
        let
          widthCssOffset = 15
          f storyPointsTitle ( _, card ) = not <| Card.isDone storyPointsTitle card
          (inProgressCards, doneCards) = List.partition ( f model.header.name ) model.cards
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
        (Signal.forwardTo context.actions (EditCard id))
        (Signal.forwardTo context.actions (always (DelCard id)))
        (Signal.forwardTo context.move (always (id)))
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
