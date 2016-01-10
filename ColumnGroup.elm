module ColumnGroup where

import Effects exposing (Effects, Never)
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


init : Int -> String -> Bool -> (Model, Effects Action)
init wip_ columnGroupName_ onlyOneColumn_ =
  let
    (inProgress, inProgressFx) = Column.init "In Progress"
    (done, doneFx) = Column.init "Done"
  in
    ( Model inProgress done wip_ columnGroupName_ onlyOneColumn_
    , Effects.batch
        [ Effects.map AddCardInProgress inProgressFx
        , Effects.map AddCardDone doneFx
        ]
    )

-- UPDATE

type Action
    = AddCardInProgress Column.Action
    | AddCardDone Column.Action

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    AddCardInProgress act ->
      let
        (inProgress_, fx_) = Column.update act model.inProgress
      in
        ( Model inProgress_ model.done model.wip model.columnGroupName model.onlyOneColumn
        , Effects.map AddCardInProgress fx_
        )

    AddCardDone act ->
      let
        (done_, fx_) = Column.update act model.done
      in
        ( Model model.inProgress  done_ model.wip model.columnGroupName model.onlyOneColumn
        , Effects.map AddCardDone fx_
        )

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
