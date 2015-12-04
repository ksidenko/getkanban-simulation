module ColumnGroup where

import Column


-- MODEL

type alias Model =
    { inProgress: Column.Model
    , done: Column.Model
    , wip: Int
    }


init : Int -> Model
init wip_ =
    { inProgress = Column.init
    , done = Column.init
    , wip = wip_
    }


-- UPDATE

-- VIEW

