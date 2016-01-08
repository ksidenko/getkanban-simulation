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
--    , wip: Int
    }


init : (Model, Effects Action)
init =
  let
    (inProgress, inProgressFx) = Column.init
    (done, doneFx) = Column.init
  in
    ( Model inProgress done
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
        ( Model inProgress_ model.done
        , Effects.map AddCardInProgress fx_
        )

    AddCardDone act ->
      let
        (done_, fx_) = Column.update act model.done
      in
        ( Model model.inProgress  done_
        , Effects.map AddCardDone fx_
        )

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ Column.view (Signal.forwardTo address AddCardInProgress) model.inProgress
    , Column.view (Signal.forwardTo address AddCardDone) model.done
    ]

