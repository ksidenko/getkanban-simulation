module Board where

import ColumnGroup


-- MODEL

type alias Model =
    { selected : ColumnGroup.Model
    , analytics: ColumnGroup.Model
    , development: ColumnGroup.Model
    , testing: ColumnGroup.Model
    , deploy: ColumnGroup.Model
    }


init : Int -> Int -> Int -> Int -> Int -> Model
init s a d t d =
    { selected = ColumnGroup.init s
    , analytics= ColumnGroup.init a
    , development= ColumnGroup.init d
    , testing= ColumnGroup.init t
    , deploy= ColumnGroup.init d
    }


-- UPDATE

-- VIEW

