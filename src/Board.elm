module Board where

import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Column exposing (Model, init, update, view)

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

type Action
    = ModifyColumn ColumnID Column.Action


update : Action -> Model -> Model
update action model =
  case action of

    ModifyColumn id act ->
      let
        column =
          let
            columnForCheck = get id model.columns
          in
            case columnForCheck of
              Just column -> column
              Nothing -> Debug.crash ("no such column index: " ++ toString(id))

        column' = Column.update act column
      in
        { model | columns = set id column' model.columns }

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  let
    f ( id, column ) =
      Column.view ( Signal.forwardTo address ( ModifyColumn id ) ) column
  in
    div [] ( List.map f ( Array.toIndexedList model.columns ) )

