module ColumnGroup where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

import Column exposing (Model, init, update, view)


-- MODEL

type alias Model =
    { inProgress: Column.Model
    , done: Column.Model
    , wip: Int
    , columnGroupName: String
    , onlyOneColumn: Bool
    }


init : Int -> String -> Bool -> Model
init wip_ columnGroupName_ onlyOneColumn_ =
    { inProgress = Column.init "In Progress"
    , done = Column.init "Done"
    , wip = wip_
    , columnGroupName = columnGroupName_
    , onlyOneColumn = onlyOneColumn_
    }

-- UPDATE

type Action
    = AddCardInProgress Column.Action
    | AddCardDone Column.Action

update : Action -> Model -> Model
update action model =
  case action of
    AddCardInProgress act ->
      { model |
          inProgress = Column.update act model.inProgress
      }

    AddCardDone act ->
      { model |
          done = Column.update act model.done
      }

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  let
    columnHeader = div []
      [ text (model.columnGroupName ++ " (" ++ toString( model.wip ) ++ ")")
      , hr [] []
      ]
    columnsHtml1 = [Column.view (Signal.forwardTo address AddCardInProgress) model.inProgress]
    columnsHtml2 = if model.onlyOneColumn == False then [Column.view (Signal.forwardTo address AddCardDone) model.done] else []
  in
    div [ columnGroupStyle ( (\onlyOneColumn -> if onlyOneColumn == True then "92px" else "185px") model.onlyOneColumn ) ]
      ( columnHeader::(List.append columnsHtml1 columnsHtml2 ))


columnGroupStyle : String -> Attribute
columnGroupStyle cssColumnWidth =
  style
    [ ("width", "30px")
    , ("display", "inline-block")
    , ("width", cssColumnWidth )
    , ("float", "left")
    , ("border", "1px solid green")
    , ("margin-right", "10px")
    ]
