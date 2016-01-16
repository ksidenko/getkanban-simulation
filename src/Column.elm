module Column (Model, init, Action, update, view) where

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
    , columnView address width model
    ]

headerView : Signal.Address Action -> Model -> Html
headerView address model =
  div []
    [ div [] [ text ( model.name ++ " (" ++ toString(model.wipLimit) ++ ")") ]
    , hr [] []
    , div [] [ text ( "Dices: " ++ toString (model.dicesCount ) ) ]
    , div [] [ button [ onClick address AddCard ] [ text "Add Card" ] ]
    ]

columnView : Signal.Address Action -> Int -> Model -> Html
columnView address widthCss model =
  let
    f storyPointsTitle ( _, card ) =
      Dict.get storyPointsTitle card.storyPoints
        |> Maybe.withDefault (-1, -1)
        |> Card.StoryPoints.isDone
        |> not

    (inProgressCards, doneCards) = List.partition ( f model.name ) model.cards
    widthCssOffset = 15
  in
    if not model.hasDone then -- only one column
      div [] [ subColumnView address model.cards widthCss ]
    else
      div []
        [ subColumnView address inProgressCards (widthCss // 2 - widthCssOffset )
        , subColumnView address doneCards (widthCss // 2 - widthCssOffset )
        ]


subColumnView : Signal.Address Action -> List (ID, Card.Model) -> Int -> Html
subColumnView address cards widthCss =
  div [ columnStyle (widthCss) ] [ div [] (List.map (cardView address) cards) ]


cardView : Signal.Address Action -> (ID, Card.Model) -> Html
cardView address (id, model) =
  let context =
    Card.Context
        (Signal.forwardTo address (Modify id))
  in
    Card.view context model


columnStyle : Int -> Attribute
columnStyle cssColumnWidth =
  style
    [ ("display", "inline-block")
    , ("width", toString(cssColumnWidth) ++ "px")
    , ("float", "left")
    , ("border", "1px solid green")
    , ("margin-right", "10px")
    ]
