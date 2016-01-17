module Board where

import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Column exposing (Model, init, update, view, Action, unsafeCard, Context)

-- MODEL

type alias Model =
    { columns : Array ( Column.Model )
    }


init : Int -> Int -> Int -> Int -> Int -> Model
init s a d t dd =
    { columns = Array.fromList
        ([ Column.init "Selected" 2 a False
        , Column.init "Analytic" 3 a True
        , Column.init "Development" 2 d True
        , Column.init "Testing" 2 t False
        , Column.init "Deploy" 100 dd False
        ])
    }

-- UPDATE

type alias ColumnID = Int
type alias CardID = Int

type Action
    = ModifyColumn ColumnID Column.Action
    | MoveCardToNextColumn ColumnID CardID


update : Action -> Model -> Model
update action model =
  case action of

    ModifyColumn id act ->
      let
        column = unsafeColumn id model.columns
        column' = Column.update act column
      in
        { model | columns = set id column' model.columns }


    MoveCardToNextColumn columnId cardId ->
      let
        column = unsafeColumn columnId model.columns
        card = Column.unsafeCard cardId column.cards
        columnNextId = columnId + 1

        -- delete card from column
        column' = { column | cards = List.filter (\(cardId', _) -> cardId' /= cardId) column.cards }
        columns' = set columnId column' model.columns

        -- move card to next column, if it is exist
        f columns' columnNextId =
          let columnNext_ = get columnNextId model.columns
          in case columnNext_ of
            Just columnNext ->
              let
                columnNext' = { columnNext |
                  cards = ( columnNext.nextID, card )::columnNext.cards,
                  nextID = columnNext.nextID + 1
                }
              in
                set columnNextId columnNext' columns'

            Nothing ->
              columns'

        --columnNext' = Column.update AddCard columnNext
        --column' = Column.update DelCard column
      in
        { model | columns = f columns' columnNextId}


unsafeColumn : Int -> Array ( Column.Model ) -> Column.Model
unsafeColumn columnId columns =
  let
    column = get columnId columns
  in
    case column of
      Just column' -> column'
      Nothing -> Debug.crash ("no such column index: " ++ toString(id))


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  let
    f ( columnId, column ) =
      let 
        context = Column.Context
            ( Signal.forwardTo address ( ModifyColumn columnId ) )
            ( Signal.forwardTo address ( MoveCardToNextColumn columnId ))
      in
        Column.view ( context ) column
  in
    div [] ( List.map f ( Array.toIndexedList model.columns ) )

