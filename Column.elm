module Column(Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Card

-- MODEL

type alias Model =
    { cards: List ( ID, Card.Model )
    , columnName: String
    , nextID : ID
    }

type alias ID = Int


init : String -> Model
init columnName_ =
    { cards = []
    , columnName = columnName_
    , nextID = 0
    }

-- UPDATE

type Action
    = SelectCard ID Card.Action
    | DeselectCard ID Card.Action
    | AddCard
    | DelCard ID
    | Modify ID Card.Action


update : Action -> Model -> Model
update action model =
  case action of
    SelectCard id cardAction ->
      let updateCard (cardID, cardModel) =
        if cardID == id then
          (cardID, Card.update cardAction cardModel)
        else
          (cardID, cardModel)
      in
          { model | cards = List.map updateCard model.cards }

    DeselectCard id cardAction ->
      let updateCard (cardID, cardModel) =
        if cardID == id then
          (cardID, Card.update cardAction cardModel)
        else
          (cardID, cardModel)
      in
        { model | cards = List.map updateCard model.cards }

    AddCard ->
      { model |
          cards = ( model.nextID, Card.init 2 3 2 0 ) :: model.cards,
          nextID = model.nextID + 1
      }

    DelCard id ->
      { model | cards = List.filter (\(cardID, _) -> cardID /= id) model.cards
      }

    Modify id cardAction ->
      let updateCard (cardID, cardModel) =
              if cardID == id then
                  (cardID, Card.update cardAction cardModel)
              else
                (cardID, cardModel)
      in
        { model | cards = List.map updateCard model.cards }

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
    let
      insert = div []
        [ div [] [ text model.columnName ]
        , button [ onClick address AddCard ] [ text "Add Card" ]
        , hr [] []
        ]
    in
      div [ columnStyle ] (insert :: List.map (viewCard address) model.cards)


columnStyle : Attribute
columnStyle =
  style
    [ ("display", "block")
    , ("float", "left")
    , ("width", "90px")
    , ("border", "1px solid black")
    ]

viewCard : Signal.Address Action -> (ID, Card.Model) -> Html
viewCard address (id, model) =
  let context =
    Card.Context
        (Signal.forwardTo address (Modify id))
  in
    Card.view context model

