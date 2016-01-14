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
    [ headerView address model
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
  let
    widthOffset = 12
    dividedCards = if model.hasDone then divideCards model.name model.cards else [ model.cards ]
    widthOneColumn = if model.hasDone == True then (widthCss // 2 - widthOffset ) else (widthCss - widthOffset)
  in
    div [] ( List.map ( oneColumnView address model widthOneColumn ) dividedCards )

divideCards : String -> List ( ID, Card.Model ) ->  List (List ( ID, Card.Model ) )
divideCards columnName cards =
  let
    f columnName (_, card) =
      let
        ff columnName (name, _, _, _) = columnName == name

        spInfo  = List.filter (ff columnName ) card.storyPoints
      in
        case spInfo of
          [] -> True
          [(name, shortName, a, b)] -> a /= b
          _ -> True

    (inProgress, done) = List.partition (f columnName) cards
  in
    [inProgress, done]


columnStyle : Int -> Attribute
columnStyle cssColumnWidth =
  style
    [ ("display", "inline-block")
    , ("width", toString(cssColumnWidth) ++ "px")
    , ("float", "left")
    , ("border", "1px solid green")
    , ("margin-right", "10px")
    ]

oneColumnView : Signal.Address Action -> Model -> Int -> List ( ID, Card.Model) -> Html
oneColumnView address model widthCss cards =
  div [ columnStyle (widthCss) ]
    [ div [] (List.map (cardView address) cards) ]

cardView : Signal.Address Action -> (ID, Card.Model) -> Html
cardView address (id, model) =
  let context =
    Card.Context
        (Signal.forwardTo address (Modify id))
  in
    Card.view context model

