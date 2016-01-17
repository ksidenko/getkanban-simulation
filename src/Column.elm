module Column (Model, init, update, view, Action, unsafeCard, Context ) where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Dict exposing (Dict)

import Card
import Card.StoryPoints

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
type alias CardID = Int


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
    | DelCard ID
    | EditCard ID Card.Action


update : Action -> Model -> Model
update action model =
  case action of
    AddCard ->
      { model |
          cards = ( model.nextID, Card.init (2, 3, 2) ) :: model.cards,
          nextID = model.nextID + 1
      }

    DelCard id ->
      { model |
          cards = List.filter (\(cardId, _) -> cardId /= id) model.cards
      }

    EditCard id cardAction ->
      let updateCard (cardID, cardModel) =
        if cardID == id then
            (cardID, Card.update cardAction cardModel)
        else
          (cardID, cardModel)
      in
        { model | cards = List.map updateCard model.cards }


unsafeCard : Int -> List ( ID, Card.Model ) -> Card.Model
unsafeCard cardId cards =
  let card = List.filter (\(cardId', _) -> cardId' == cardId) cards |> List.head
  in case card of
       Just card -> snd card
       Nothing -> Debug.crash ("No such card id: " ++ toString (cardId))

-- VIEW

type alias Context =
    { actions : Signal.Address Action
    , move: Signal.Address CardID
    }

view : Context -> Model -> Html
view context model =
  let
    width = (\hasDone -> if hasDone == False then 92 else 185) model.hasDone
  in
    div [ columnStyle width ]
      [ headerView context model
      , columnView context width model
      ]

headerView : Context -> Model -> Html
headerView context model =
  div []
    [ div [] [ text ( model.name ++ " (" ++ toString(model.wipLimit) ++ ")") ]
    , hr [] []
    , div [] [ text ( "Dices: " ++ toString (model.dicesCount ) ) ]
    , div [] [ button [ onClick context.actions AddCard ] [ text "Add Card" ] ]
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
          (inProgressCards, doneCards) = List.partition ( f model.name ) model.cards
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
        (Signal.forwardTo context.move (always ( id )))
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
