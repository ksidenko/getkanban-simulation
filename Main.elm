
import Card exposing (init, update, view)
import Column exposing (..)
import ColumnGroup exposing (..)
import Board exposing (..)
import StartApp.Simple exposing (start)


main =
  start
    { model = Card.init 2 3 2
    , update = update
    , view = view
    }
