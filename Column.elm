module Column(Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Card

-- MODEL

type alias Model =
    { cards: List ( ID, Card.Model )
    , nextID : ID
    }

type alias ID = Int


init : Model
init =
    { cards = []
    , nextID = 0
    }


-- UPDATE

type Action 
    = SelectCard ID Card.Action
    | DeselectCard ID Card.Action

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

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div [ countStyle ]
    --[ button [ onClick address SelectCard ] [ text "-" ]
    [ div [ ] [ text "column text" ]
    --, button [ onClick address DeselectCard ] [ text "+" ]
    ]

countStyle : Attribute
countStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "150px")
    , ("border", "1px solid black")
    , ("text-align", "center")
    ]
