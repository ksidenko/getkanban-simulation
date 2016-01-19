module Board where

import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Column exposing (Model, init, update, view, Action, unsafeCard, Context)

-- MODEL

type alias Model =
    { columns : List ( ID, Column.Model )
    , nextID : ID
    }


init : Int -> Int -> Int -> Int -> Int -> Model
init s a d t dd =
    { columns =
      [ ( 0, Column.init "Selected" 2 a False )
      , ( 1, Column.init "Analytic" 3 a True )
      , ( 2, Column.init "Development" 2 d True )
      , ( 3, Column.init "Testing" 2 t False )
      , ( 4, Column.init "Deploy" 100 dd False )
      ]
    , nextID = 5
    }

-- UPDATE

type alias ID = Int
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
        updateColumn (id_, column) = if id_ == id then (id_, Column.update act column) else (id_, column)
      in
        { model | columns = List.map updateColumn model.columns }

    MoveCardToNextColumn columnId cardId ->
      let columnCheck = List.filter ( \(columnId', _) -> columnId' == columnId ) model.columns |> List.head
      in case columnCheck of
        Just ( _, column ) ->
          let card = List.filter (\(cardId', _) -> cardId' == cardId) ( column.cards ) |> List.head
          in case card of
            Just ( _, card ) ->
              let
                -- delete card from column
                column' = Column.update ( Column.DelCard cardId ) column

                updateColumn (id_, column) = if id_ == columnId then (id_, column') else (id_, column)
                model' = { model | columns = List.map updateColumn model.columns }

                -- move card to next column, if it is exist
                columnNextId = columnId + 1
                model'' =
                  if List.length model.columns /= columnNextId then
                    let columnCheck = List.filter ( \(columnId', _) -> columnId' == columnNextId ) model.columns |> List.head
                    in case columnCheck of
                      Just ( _, columnNext ) ->
                        let
                          columnNext' = Column.update (Column.AddCard card ) columnNext

                          updateColumn (id_, column) = if id_ == columnNextId then (id_, columnNext') else (id_, column)
                          model'' = { model' | columns = List.map updateColumn model'.columns }
                        in
                          model''
                      Nothing -> model' -- no next column (impossible case ;-)
                  else
                    model'
              in
                model''
            Nothing -> model -- no such card in column
        Nothing -> model -- no such column


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
        Column.view context column
  in
    div [] ( List.map f model.columns )

