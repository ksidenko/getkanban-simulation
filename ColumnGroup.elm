module ColumnGroup where

import Effects exposing (Effects, Never)
import Column exposing (Model, init, Action, update, view)


-- MODEL

type alias Model =
    { inProgress: (Column.Model, Effects Action)
    , done: (Column.Model, Effects Action)
    , wip: Int
    }


init : Int -> Model
init wip_ =
    { inProgress = Column.init 0
    , done = Column.init 0
    , wip = wip_
    }


-- UPDATE

-- VIEW

