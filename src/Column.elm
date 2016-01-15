module Column (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

import Card
import Column.Header

-- MODEL

type alias Model =
    { cards: List ( ID, Card.Model )
    , nextID : ID
    , name: String
    , dicesCount: Int
    , wipLimit: Int
    , hasDone: Bool
    }

type alias ID = Int


init : String -> Int -> Int -> Bool -> Model
init name dicesCount wipLimit hasDone =
    { cards = []
    , nextID = 0
    , name = name
    , dicesCount = dicesCount
    , wipLimit = wipLimit
    , hasDone = hasDone
    }

-- UPDATE

type Action
    = AddCard
    | Modify ID Card.Action


update : Action -> Model -> Model
update action model =
  case action of
    AddCard ->
      { model |
          cards = ( model.nextID, Card.init (2, 3, 2) ) :: model.cards,
          nextID = model.nextID + 1
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
    width = (\hasDone -> if hasDone == False then 92 else 185) model.hasDone
    --context =
        --Column.Header.Context
          --(Signal.forwardTo address (AddCard))
  in
  div [ columnStyle width ]
    [ headerView address model
    --Column.Header.view context model
    , columnView address model width
    ]

headerView : Signal.Address Action -> Model -> Html
headerView address model =
  div []
    [ div [] [ text ( model.name ++ " (" ++ toString(model.wipLimit) ++ ")") ]
    , hr [] []
    , div [] [ text ( "Dices: " ++ toString (model.dicesCount ) ) ]
    , div [] [ button [ onClick address AddCard ] [ text "Add Card" ] ]
    ]

columnView : Signal.Address Action -> Model -> Int -> Html
columnView address model widthCss =
    if model.hasDone then
        div [] [ oneColumnView address model.cards 80]
    else
        div []
            [ oneColumnView address model.cards 80
            , oneColumnView address model.cards 80
            ]

columnStyle : Int -> Attribute
columnStyle cssColumnWidth =
  style
    [ ("display", "inline-block")
    , ("width", toString(cssColumnWidth) ++ "px")
    , ("float", "left")
    , ("border", "1px solid green")
    , ("margin-right", "10px")
    ]

oneColumnView : Signal.Address Action -> List (ID, Card.Model) -> Int -> Html
oneColumnView address cards widthCss =
  div [ columnStyle (widthCss) ]
    [ div [] (List.map (cardView address) cards)
    ]

cardView : Signal.Address Action -> (ID, Card.Model) -> Html
cardView address (id, model) =
  let context =
    Card.Context
        (Signal.forwardTo address (Modify id))
  in
    Card.view context model
