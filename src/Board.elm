module Board where

import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Column exposing (Model, init, view, Context)
import Card exposing (Model, init, update, view, Action(..), Status(..))

-- MODEL

type alias Model =
    { cards : List ( ID, Card.Model )
    , nextID : ID
    , selectedColumn : Column.Model
    , analyticColumn : Column.Model
    , developmentColumn : Column.Model
    , testingColumn : Column.Model
    , readyForDeployColumn : Column.Model
    , deployColumn : Column.Model
    }


init : Int -> Int -> Int -> Int -> Int -> Model
init s a d t dd =
    { cards =
            [ (1, Card.init ( 2, 3, 2 ))
            , (2, Card.init ( 4, 1, 5 ))
            , (3, Card.init ( 1, 1, 5 ))
            ]
    , nextID = 0
    , selectedColumn = Column.init "Selected" 2 a False
    , analyticColumn = Column.init "Analytic" 3 a True
    , developmentColumn = Column.init "Development" 2 d True
    , testingColumn = Column.init "Testing" 2 t False
    , readyForDeployColumn = Column.init "Ready For Deploy" 10 dd False
    , deployColumn = Column.init "Deploy" 10 dd False
    }

-- UPDATE

type alias ID = Int
type alias CardID = Int

type BoardAction
    = ModifyCard CardID Card.Action
    | MoveCard CardID
    | DelCard CardID
    | AddCard Card.Model

update : BoardAction -> Model -> Model
update action model =
  case action of

    MoveCard id ->
      let updateCard (cardID, cardModel) =
        if cardID == id
            then (cardID, Card.update NextStatus cardModel)
            else (cardID, cardModel)
      in
        { model | cards = List.map updateCard model.cards }

    DelCard id ->
      { model
        | cards = List.filter (\(cardId, _) -> cardId /= id) model.cards
      }

    AddCard card ->
      { model
        | cards = ( model.nextID, card ) :: model.cards
        , nextID = model.nextID + 1
      }

    ModifyCard id cardAction ->
      let updateCard (cardID, cardModel) =
        if cardID == id
            then (cardID, Card.update cardAction cardModel)
            else (cardID, cardModel)
      in
        { model | cards = List.map updateCard model.cards }

-- VIEW

view : Signal.Address BoardAction -> Model -> Html
view address model =
  let
    filterCards status cards = List.filter ( \( _, card) -> card.status == status ) cards

    cardsSelected = filterCards Selected model.cards
    cardsAnalytic = filterCards Analytic model.cards
    cardsDevelopment = filterCards Development model.cards
    cardsTesting = filterCards Testing model.cards
    cardsReadyForDeploy = filterCards ReadyForDeploy model.cards
    cardsDeploy = filterCards Deploy model.cards

    context = Column.Context
      --( Signal.forwardTo address ( ModifyCard ))
      ( Signal.forwardTo address ( MoveCard ))
      ( Signal.forwardTo address ( DelCard ))
  in
      div []
        [ Column.view context cardsSelected model.selectedColumn
        , Column.view context cardsAnalytic model.analyticColumn
        , Column.view context cardsDevelopment model.developmentColumn
        , Column.view context cardsTesting  model.testingColumn
        , Column.view context cardsReadyForDeploy model.readyForDeployColumn
        , Column.view context cardsDeploy model.deployColumn
        ]
