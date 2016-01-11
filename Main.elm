--import Task exposing (Task, andThen)

--import Card exposing (init, update, view)
import Column exposing (..)
import ColumnGroup exposing (..)
import Board exposing (init, update, view)

--https://github.com/evancz/start-app/blob/master/src/StartApp.elm
import StartApp.Simple exposing (start)

main =
  start
    { model = Board.init 1 2 3 4 5
    , update = Board.update
    , view = Board.view
    }

