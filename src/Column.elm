module Column (Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Card


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
  in
  div [ columnStyle width ]
    [ viewHeader address model
    , viewColumn address model
    ]

viewColumn : Signal.Address Action -> Model -> String -> Html
viewColumn address model widthCss =
  let
      column = viewCardList address model
  in
    div [ columnStyle widthCss ] [ column ]

columnStyle : String -> Attribute
columnStyle cssColumnWidth =
  style
    [ ("display", "inline-block")
    , ("width", toString(cssColumnWidth) ++ "px")
    , ("float", "left")
    , ("border", "1px solid green")
    , ("margin-right", "10px")
    ]

viewCardList : Signal.Address Action -> Model -> Html
viewCardList address model =
  div [] (List.map (viewCard address) model.cards)

viewBtn : Signal.Address Action -> Model -> Html
viewBtn address model =
  div []
    [ button [ onClick address AddCard ] [ text "Add Card" ]
    , hr [] []
    ]

viewHeader : Signal.Address Action -> Model -> Html
viewHeader address model =
  div []
    [ div [] [ text ( model.name ++ " (" ++ toString(model.wipLimit) ++ ")") ]
    , hr [] []
    , div [] [ text ( "Dices: " ++ toString (model.dicesCount ) )]
    , hr [] []
    , viewBtn address model
    ]


viewCard : Signal.Address Action -> (ID, Card.Model) -> Html
viewCard address (id, model) =
  let context =
    Card.Context
        (Signal.forwardTo address (Modify id))
  in
    Card.view context model
